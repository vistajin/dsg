USE [dsg]
GO
/****** Object:  StoredProcedure [dbo].[sp_who_lock]    Script Date: 14/09/2017 10:59:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_who_lock]

AS

BEGIN

DECLARE @spid int,@bl int

,@intTransactionCountOnEntry int

,@intRowcount int

,@intCountProperties int

,@intCounter int

CREATE TABLE #tmp_lock_who

(

id int identity(1,1)

,spid smallint

,bl smallint

)

IF @@ERROR<>0 RETURN @@ERROR

INSERT INTO #tmp_lock_who(spid,bl)

SELECT 0 , blocked

FROM (SELECT*

FROM sysprocesses

WHERE blocked>0 ) AS A

WHERE not exists(SELECT 1


 
FROM (SELECT * FROM sysprocesses WHERE blocked>0 ) B

WHERE A.blocked=spid)

UNION ALL

SELECT spid,blocked FROM sysprocesses WHERE blocked>0

IF @@ERROR<>0 RETURN @@ERROR

-- 找到臨時表的記錄數

SELECT @intCountProperties = Count(*),@intCounter = 1

FROM #tmp_lock_who

IF @@ERROR<>0 RETURN @@ERROR

IF @intCountProperties=0

SELECT 'No blocked and Locked info' as message

-- 循環開始

WHILE @intCounter <= @intCountProperties


 
BEGIN

-- 取第一條記錄

SELECT @spid = spid,@bl = bl

FROM #tmp_lock_who

WHERE Id = @intCounter

IF @spid =0

SELECT 'Cause of DB lock is: '+ CAST(@bl AS VARCHAR(10)) + 'process, corresponding sql is'

ELSE

SELECT 'Process SPID：'+ CAST(@spid AS VARCHAR(10))+ 'blocked by' + 'Process SPID：'+ CAST(@bl AS VARCHAR(10)) +',corresponding sql is: '

DBCC INPUTBUFFER (@bl )

-- 循環指針下移

SET @intCounter = @intCounter + 1

END

DROP TABLE #tmp_lock_who

RETURN 0

END