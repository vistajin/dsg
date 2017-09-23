USE [dsg_test]
GO

set statistics time on
set statistics io on
go
----------- patch data to run PDA out store----------
--exec sp_pdaoutcasecommit 'SED99900CEUQ'

--领料单: SED99900CEUQ 已经生成出库单，请检查！
--SELECT * FROM dbo.MaterialOut_Head (nolock) WHERE SendNo='SED99900CEUQ'
--delete from MaterialOut_Head WHERE SendNo='SED99900CEUQ';
update MaterialOut_Head set SendNo='SED99900CEUQ-bak' where SendNo='SED99900CEUQ';

--领料单: SED99900CEUQ 已经出库，请检查！
--SELECT BarcodeNo FROM dbo.MaterialSend_DetailD (nolock) WHERE OutFlag=1 AND DocNo='SED99900CEUQ'
--delete from MaterialSend_DetailD WHERE OutFlag=1 AND DocNo='SED99900CEUQ'
update MaterialSend_DetailD set OutFlag=0,BatchID='B020017331L-01',BarcodeNo='SED99900CEUQ-18' where DocNo='SED99900CEUQ'
--update MaterialSend_DetailD set DocNo='SED99900CEUQ' where DocNo='SED99900CEUQ-bak'


-- 发送失败，该批次 B020017331L-01 库存为0，请检查！
/*SELECT a.BatchID
FROM pdaoutcase a (nolock)
LEFT JOIN MaterialSend_DetailD b(nolock) ON a.DocNo=b.DocNo AND a.BatchID=b.BatchID AND a.BarcodeNo = b.BarcodeNo
LEFT JOIN MaterialStoreQty c(nolock) ON  a.BatchID=c.BatchID
WHERE (ISNULL(c.[Length],0)<=0 OR ISNULL(c.Weight,0)<=0) AND a.DocNo='SED99900CEUQ' */







select * from pdaoutcase where DocNo = 'SED99900CEUQ';
update pdaoutcase set DocNo = 'SED99900CEUQ' where DocNo = 'SED99900CEUQ-bak'; --B020017331L-01/SED99900CEUQ-18
                                                                               --B020029424H-01/SED99900CEUQ-36

SELECT A.DocNo,C.DocNo --COUNT(A.DocNo)
FROM dbo.MaterialSend_DetailD A (nolock)
INNER JOIN dbo.MaterialSend_head B(nolock) ON A.DocNo=B.DocNo
LEFT JOIN pdaoutcase C(nolock) ON A.DocNo=C.DocNo AND A.BatchID=C.BatchID AND A.BarcodeNo=C.BarcodeNo
WHERE A.DocNo='SED99900CEUQ' AND C.DocNo IS NULL

select * from MaterialSend_head where DocNo = 'SED99900CEUQ'
update MaterialSend_head set DocNo = 'SED99900CEUQ-bak' where DocNo = 'SED99900CEUQ'
update MaterialSend_head set DocNo = 'SED99900CEUQ' where DocNo = 'SED99900CEUQ-bak'


SELECT *
FROM pdaoutcase a(nolock)
LEFT JOIN MaterialSend_DetailD b(nolock) ON a.DocNo=B.DocNo AND a.BatchID=b.BatchID
WHERE a.DocNo='SED99900CEUQ' AND b.DocNo IS NULL

SELECT TOP 1 a.BatchID
FROM pdaoutcase a(nolock)
LEFT JOIN MaterialSend_DetailD b(nolock) ON a.DocNo=B.DocNo AND a.BatchID=b.BatchID
WHERE a.DocNo='SED99900CEUQ' AND b.DocNo IS NULL

select * from pdaoutcase where DocNo = 'SED99900CEUQ' and BatchID in ('B020017331L-01','B020043411B-01','B020054231G-01','NB02072100Z1-01R')
--delete from pdaoutcase where DocNo = 'SED99900CEUQ' and BatchID in ('B020017331L-01','B020043411B-01','B020054231G-01','NB02072100Z1-01R')
delete from pdaoutcase where DocNo = 'SED99900CEUQ' and BatchID in 
(SELECT a.BatchID
FROM pdaoutcase a(nolock)
LEFT JOIN MaterialSend_DetailD b(nolock) ON a.DocNo=B.DocNo AND a.BatchID=b.BatchID
WHERE a.DocNo='SED99900CEUQ' AND b.DocNo IS NULL)


select *from  MaterialSend_head where DocNo='SED99900CEUQ'
exec sp_pdaoutcasecommit 'SED99900CEUQ'
----------- /patch data to run PDA out store----------