
--Get CPU count
select max_workers_count,scheduler_count,cpu_count,hyperthread_ratio from sys.dm_os_sys_info

--https://blogs.msdn.microsoft.com/apgcdsd/2012/11/27/sql-server-worker-threads/
--让我们来谈谈一个有趣的话题。我的SQL server 的worker threads是否够用？如何判断SQL server 用光了所有的worker threads?
--一个简单的方法就是查询DMV sys.dm_os_schedulers：
SELECT    scheduler_id,   cpu_id,  current_tasks_count,   runnable_tasks_count,   current_workers_count,   active_workers_count,   work_queue_count
FROM sys.dm_os_schedulers
WHERE scheduler_id < 255
--其中的work_queue_count表示正在等待worker 的task数 
--如果这个值一直大于0，那么说明没有可用的worker threads了。这个时候如果runnable_tasks_count很大，那么一般意味着SQL Sever有某种性能瓶颈，或者是严重过载了。 
--------------------------------------------------

--是否有task等待worker  thread
select * from sys.dm_os_tasks where task_state='PENDING'
--如果上面语句有输出，那么就表示有task 等待worker去执行。


--
SET DEADLOCK_PRIORITY LOW/NORMAL/HIGHT/-10~10

Dbcc traceon (1204,-1)

DBCC Traceon (1222,-1)

select * from sys.sysprocesses where blocked > 0
SELECT Blocker.text --, Blocker.*, *
FROM sys.dm_exec_connections AS Conns
INNER JOIN sys.dm_exec_requests AS BlockedReqs
    ON Conns.session_id = BlockedReqs.blocking_session_id
INNER JOIN sys.dm_os_waiting_tasks AS w
    ON BlockedReqs.session_id = w.session_id
CROSS APPLY sys.dm_exec_sql_text(Conns.most_recent_sql_handle) AS Blocker

--每秒死锁数量
SELECT  *
FROM    sys.dm_os_performance_counters
WHERE   counter_name LIKE 'Number of Deadlocksc%';

--查询当前阻塞
WITH	CTE_SID ( BSID, SID, sql_handle ) AS (
	SELECT
		blocking_session_id,
		session_id,
		sql_handle
	FROM
		sys.dm_exec_requests
	WHERE
		blocking_session_id <> 0
    UNION ALL
	SELECT
		A.blocking_session_id,
		A.session_id,
		A.sql_handle
	FROM
		sys.dm_exec_requests A
	JOIN CTE_SID B ON A.SESSION_ID = B.BSID)

SELECT  C.BSID ,
		C.SID ,
		S.login_name ,
		S.host_name ,
		S.status ,
		S.cpu_time ,
		S.memory_usage ,
		S.last_request_start_time ,
		S.last_request_end_time ,
		S.logical_reads ,
		S.row_count ,
		q.text
FROM	CTE_SID C
JOIN	sys.dm_exec_sessions S ON C.sid = s.session_id
CROSS APPLY sys.dm_exec_sql_text(C.sql_handle) Q
ORDER BY sid

--TRY / CATCH
BEGIN TRANSACTION tx
BEGIN TRY
  -- main code goes here
  WAITFOR DELAY '00:00:05'
  -- some other code
  COMMIT TRANSACTION tx
END TRY
BEGIN CATCH
  SELECT ERROR_NUMBER() AS ErrorNumber
  ROLLBACK TRANSACTION tx
END CATCH;
SELECT @@TRANCOUNT AS '@@Trancount'

--TRY / CATCH with retry
DECLARE @Tries tinyint
SET @Tries = 1
WHILE @Tries <= 3
	BEGIN
		BEGIN TRANSACTION tx
		BEGIN TRY
			-- main code goes here
			WAITFOR DELAY '00:00:05'
			-- some other code
			COMMIT TRANSACTION tx
			BREAK
		END TRY
		BEGIN CATCH
			SELECT ERROR_NUMBER() AS ErrorNumber
			ROLLBACK TRANSACTION tx
			SET @Tries = @Tries + 1
			CONTINUE
		END CATCH
	END

-- sysprocesses
--https://docs.microsoft.com/en-us/sql/relational-databases/system-compatibility-views/sys-sysprocesses-transact-sql
--master.dbo.sysprocesses and its compatibility view sys.sysprocesses are deprecated, so use this instead:
select session_id from sys.dm_exec_sessions

-- Check SQL Server Schedulers
SELECT scheduler_id, current_tasks_count, runnable_tasks_count
FROM sys.dm_os_schedulers
WHERE scheduler_id < 255

-- Detect blocking
SELECT blocked_query.session_id AS blocked_session_id,
blocking_query.session_id AS blocking_session_id,
sql_text.text AS blocked_text, sql_btext.text AS blocking_text, waits.wait_type AS blocking_resource
FROM sys.dm_exec_requests AS blocked_query
INNER JOIN sys.dm_exec_requests AS blocking_query
ON blocked_query.blocking_session_id = blocking_query.session_id
CROSS APPLY
(SELECT * FROM sys.dm_exec_sql_text(blocking_query.sql_handle)) sql_btext
CROSS APPLY
(SELECT * FROM sys.dm_exec_sql_text(blocked_query.sql_handle)) sql_text
INNER JOIN sys.dm_os_waiting_tasks AS waits
ON waits.session_id = blocking_query.session_id


-- Clear Wait Stats
DBCC SQLPERF('sys.dm_os_wait_stats', CLEAR);

-- Isolate top waits
WITH Waits AS
(
SELECT
wait_type,
wait_time_ms / 1000. AS wait_time_s,
100. * wait_time_ms / SUM(wait_time_ms) OVER() AS pct,
ROW_NUMBER() OVER(ORDER BY wait_time_ms DESC) AS rn
FROM sys.dm_os_wait_stats
WHERE wait_type NOT LIKE '%SLEEP%'
-- filter out additional irrelevant waits
)

SELECT
W1.wait_type,
CAST(W1.wait_time_s AS DECIMAL(12, 2)) AS wait_time_s,
CAST(W1.pct AS DECIMAL(12, 2)) AS pct,
CAST(SUM(W2.pct) AS DECIMAL(12, 2)) AS running_pct
FROM Waits AS W1
INNER JOIN Waits AS W2
ON W2.rn <= W1.rn
GROUP BY W1.rn, W1.wait_type, W1.wait_time_s, W1.pct
HAVING SUM(W2.pct) - W1.pct < 90 -- percentage threshold
ORDER BY W1.rn;


--I grabbed the following snippet which indicates whether the default max worker threads setting is sufficient (if the average value per scheduler is greater than 1 than this indicates the setting is not high enough).
--Code Snippet
select
AVG (work_queue_count)
from
sys.dm_os_schedulers
where
status = 'VISIBLE ONLINE';

select cpu_count,hyperthread_ratio, scheduler_count,scheduler_total_count, max_workers_count
from sys.dm_os_sys_info;

Sp_serv
er_diagnostics

-- Turn on advanced options
EXEC sp_configure 'Show Advanced Options', 1
GO
RECONFIGURE
GO
-- See what the current value is for 'max degree of parallelism'
EXEC sp_configure
-- Set MAXDOP = 1 for the server
EXEC sp_configure 'max degree of parallelism', 1
GO
RECONFIGURE
GO


EXEC sp_configure 'Show Advanced Options', 1
GO
RECONFIGURE
GO
sp_configure 'max worker threads'

SELECT max_workers_count FROM sys.dm_os_sys_info
SELECT SUM(current_workers_count) as [Current worker thread] FROM sys.dm_os_schedulers
--If on average such value is above 1 then you might benefit from adding more threads to the system
select AVG (work_queue_count) from sys.dm_os_schedulers where status = 'VISIBLE ONLINE'


--http://www.faceofit.com/how-to-resolve-max-worker-threads-issues-in-sql-server/

--the following query will provide information about the system tasks that have spawned the additional threads.
SELECT
s.session_id,
r.command,
r.status,
r.wait_type,
r.scheduler_id,
w.worker_address,
w.is_preemptive,
w.state,
t.task_state,
t.session_id,
t.exec_context_id,
t.request_id
FROM sys.dm_exec_sessions AS s
INNER JOIN sys.dm_exec_requests AS r
    ON s.session_id = r.session_id
INNER JOIN sys.dm_os_tasks AS t
    ON r.task_address = t.task_address
INNER JOIN sys.dm_os_workers AS w
    ON t.worker_address = w.worker_address
WHERE s.is_user_process = 0;

select  is_user_process,count(*) as RequestCount from sys.dm_exec_sessions s
inner join sys.dm_exec_requests r
on s.session_id = r.session_id
group by is_user_process


;with cte as
(
       select
              s.is_user_process,
             w.worker_address,
              w.is_preemptive,
              w.state,
              r.status,
              t.task_state,
              r.command,
              w.last_wait_type,
              t.session_id,
              t.exec_context_id,
              t.request_id
       from dm_exec_sessions s
       inner join dm_exec_requests r
       on s.session_id = r.session_id
       inner join dm_os_tasks t
       on r.task_address = t.task_address
       inner join dm_os_workers w
       on t.worker_address = w.worker_address
       where s.is_user_process = 0
)
select
       is_user_process,command,
       last_wait_type,
       count(*) as cmd_cnt
from cte
group by is_user_process,command, last_wait_type
order by cmd_cnt desc

--https://blogs.msdn.microsoft.com/sql_pfe_blog/2013/07/01/are-my-actual-worker-threads-exceeding-the-sp_configure-max-worker-threads-value/
-- available groups
select count(*)as NumAvailabilityGroups from sys.availability_groups

--available workers
select scheduler_id,current_tasks_count,current_workers_count,active_workers_count,work_queue_count
from sys.dm_os_schedulers
where status = 'Visible Online'

select is_preemptive,state,last_wait_type,count(*) as NumWorkers from sys.dm_os_workers
Group by state,last_wait_type,is_preemptive
order by count(*) desc

--https://social.msdn.microsoft.com/Forums/sqlserver/en-US/b67f7f3b-6e23-4552-846b-1ec981f814fc/performance-issue-worker-threads-ccassionally-run-out-then-sql-server-rejects-connections?forum=sqldatabaseengine

--https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/configure-the-max-worker-threads-server-configuration-option

master..sysprocesses

master..sysperfinfo

dm_os_schedulers

dm_os_threads

dm_os_workers

dm_os_waiting_tasks