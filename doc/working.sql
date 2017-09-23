USE [dsg_test]
GO

set statistics time on
set statistics io on
go

SELECT 1 FROM MaterialSend_DetailD A(nolock)
	INNER JOIN dbo.MaterialSend_head B(nolock) ON A.DocNo = B.DocNo
	FULL JOIN pdaoutcase C(nolock) ON A.DocNo=C.DocNo AND A.BatchID=C.BatchID AND A.BarcodeNo=C.BarcodeNo
	WHERE (A.DocNo IS NULL OR C.DocNo IS NULL OR ISNULL(B.CheckFlag,0)=0) AND C.DocNo='BCK99900ss000C'
	
	
select top 10 docno from pdaoutcase C;


sp_helptext spGetBranchDocNumber

declare @outdocno varchar(100)
exec spGetBranchDocNumber 'MATSTORE','stockoutnumber','OUT999','1',@outdocno OUTPUT
select @outdocno


SELECT top 100 sendlldocno=a.DocNo, CheckFlag=A.CheckFlag ,tojjdate=a.tojjdate
FROM dbo.MaterialSend_head A (NOLOCK)


exec sp_pdaoutcasecommit 'SED99900CEUQ'

SELECT top 10 a.SendNo FROM MaterialOut_Head a (nolock)
WHERE a.SendNo in (SELECT b.DocNo FROM MaterialSend_head b (NOLOCK))
	  and a.SendNo in (select c.DocNo from MaterialSend_head c)

select top 10 x.DocNo from MaterialSend_head x 
where x.tojjdate is not null and x.DocNo not in (select y.SendNo from MaterialOut_Head y (nolock))
and 0 = (SELECT COUNT(A.DocNo)
FROM dbo.MaterialSend_DetailD A (nolock)
INNER JOIN dbo.MaterialSend_head B(nolock) ON A.DocNo=B.DocNo
LEFT JOIN pdaoutcase C(nolock) ON A.DocNo=C.DocNo AND A.BatchID=C.BatchID AND A.BarcodeNo=C.BarcodeNo
WHERE A.DocNo=x.DocNo AND C.DocNo IS NULL)
and null = (SELECT TOP 1 a.BatchID
FROM pdaoutcase a (nolock)
LEFT JOIN MaterialSend_DetailD b(nolock) ON A.DocNo=B.DocNo AND A.BatchID=B.BatchID
WHERE a.DocNo=x.DocNo AND b.DocNo IS NULL)


SELECT *
FROM pdaoutcase a(nolock)
LEFT JOIN MaterialSend_DetailD b(nolock) ON a.DocNo=B.DocNo AND a.BatchID=b.BatchID
WHERE a.DocNo='SED99900CEUQ' AND b.DocNo IS NULL


----------- patch data to run PDA out store----------
select * from pdaoutcase where DocNo = 'SED99900CEUQ' and BatchID in ('B020017331L-01','B020043411B-01','B020054231G-01','NB02072100Z1-01R')
delete from pdaoutcase where DocNo = 'SED99900CEUQ' and BatchID in ('B020017331L-01','B020043411B-01','B020054231G-01','NB02072100Z1-01R')


SELECT * FROM dbo.MaterialOut_Head (nolock) WHERE SendNo='SED99900CEUQ'
delete from MaterialOut_Head WHERE SendNo='SED99900CEUQ';









----------- /patch data to run PDA out store----------


exec spsavebaneditlog 'mb00363005', 'Vista', 'ÐÞ¸Ä'

exec xp_readerrorlog


DBCC TRACEON (1222, -1)
GO
DBCC TRACESTATUS


select * from sys.sysprocesses where status LIKE 's%'

sp_lock


SELECT  *
FROM    sys.dm_os_performance_counters
WHERE   counter_name LIKE 'Number of Deadlocksc%';


WITH
	CTE_SID ( BSID, SID, sql_handle )
   AS ( SELECT   blocking_session_id ,
                        session_id ,
                        sql_handle
               FROM     sys.dm_exec_requests
               WHERE    blocking_session_id <> 0
               UNION ALL
               SELECT   A.blocking_session_id ,
                        A.session_id ,
                        A.sql_handle
               FROM     sys.dm_exec_requests A
                        JOIN CTE_SID B ON A.SESSION_ID = B.BSID
             )
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
    FROM    CTE_SID C 
            JOIN sys.dm_exec_sessions S ON C.sid = s.session_id
            CROSS APPLY sys.dm_exec_sql_text(C.sql_handle) Q
    ORDER BY sid