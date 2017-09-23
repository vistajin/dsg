USE [dsg_test]
GO

set statistics time on
set statistics io on

go

sp_who_lock
p_lockinfo

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



SELECT
		distinct A.DLine,A.BarcodeNo,A.MatNo,A.BatchID,A.VolumeID,A.Package,A.Qtyi,A.Qunit,b.WeightQty,A.Wunit,A.Conversion,CASE when isnull(a.Conversion,0)<=0 then A.Length else b.WeightQty/a.Conversion*ISNULL(a.sampleqty,1) end Length,A.Lunit,A.LocationID,c.matdesc,c.season,c.reqperson,c.dsgpoperson,c.colorid,c.colordesc,d.Length,d.Weight,c.storeno,a.Length
	FROM
		MaterialSend_DetailD A (nolock)
	INNER JOIN
		pdaOutCase B(nolock) ON A.DocNo=B.DocNo AND A.BarcodeNo = B.BarcodeNo AND A.BatchID = B.BatchID
	left join
		vw_matBatchInfo (nolock) c on a.batchid=c.batchid
	left join
		MaterialStoreQty (nolock) d on a.batchid=d.batchid
	WHERE B.DocNo='SED99900CEUQ'



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


INSERT INTO [dsg_test].[dbo].[pdaoutcase]
           ([DocNo]
           ,[BarcodeNo]
           ,[BatchID]
           ,[WeightQty]
           ,[BatchWeight]
           ,[BatchLength]
           ,[userid]
           ,[pdaid]
           ,[worktime]
           ,[packqty])
     VALUES
           ('SED99900CEUQ','SED99900CEUQ-18','B020017331L-01',4.700000,4.700000,13.055600,'BF2399',
           'V1111403073958','2017-09-14 22:49:02.567',1)
GO




INSERT INTO [dsg_test].[dbo].[MaterialSend_DetailD]
           ([DocNo]
           ,[Line]
           ,[Dline]
           ,[BarcodeNo]
           ,[LocationID]
           ,[MatNo]
           ,[BatchID]
           ,[VolumeID]
           ,[Package]
           ,[Qtyi]
           ,[Qunit]
           ,[Weight]
           ,[stockWeight]
           ,[Wunit]
           ,[Conversion]
           ,[Length]
           ,[Lunit]
           ,[OutFlag]
           ,[usablelength]
           ,[stocklength]
           ,[colorid]
           ,[colordesc]
           ,[matdesc]
           ,[mattype]
           ,[season]
           ,[person]
           ,[dsgpoperson]
           ,[CrockID]
           ,[resno]
           ,[resline]
           ,[templetid]
           ,[styleno]
           ,[remark]
           ,[rev_number]
           ,[sampleqty]
           ,[freq_number]
           ,[freq_line]
           ,[item_line]
           ,[issendcacflag]
           ,[orderno]
           ,[isdaiyongflag]
           ,[isfenggebanflag]
           ,[isfenggebanuser]
           ,[isfenggebandate]
           ,[Sendbuyangdate]
           ,[Sendbuyanguser]
           ,[Putbuyangdate]
           ,[Putbuyanguser]
           ,[IsOkcolourflag]
           ,[IsOkcolouruser]
           ,[IsOkcolourdate]
           ,[IsOkfenggeflag]
           ,[IsOkfenggeuser]
           ,[IsOkfenggedate]
           ,[useseason]
           ,[pre_number]
           ,[pre_line]
           ,[tobldate]
           ,[bluserid]
           ,[blusername]
           ,[tojjdate]
           ,[jjuserid]
           ,[jjusername]
           ,[storeno]
           ,[preunit]
           ,[preneedqty]
           ,[bcklength]
           ,[prerestqty]
           ,[detailcheckflag]
           ,[detailcheckuser]
           ,[detailcheckdate]
           ,[pdaid]
           ,[inuser1]
           ,[indate1])
     VALUES
           ('SED99900CEUQ',3,36,'SED99900CEUQ-36','BG089065','1BF08-B-032','B020029424H-01',
           01,58,4.300000,'°õ',4.300000,4.300000,'°õ',0.339000,12.684400,'Âë',1,12.684400,12.684400,03-002,'ºÚÉ«',
           'K813#²¼','B2','2014ÏÄ¼¾','Ö£ÀöÏ¼','ÈÎÀò',NULL,NULL,NULL,NULL,1731040030,'´ü²¼','SZSG100006275',
           1.000000,NULL,NULL,NULL,NULL,'POA13-004745',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
           NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'B',NULL,NULL,0.000000,12.684400,
           0,NULL,NULL,NULL,'BF0359','2017-09-14 14:34:55.017')
GO


