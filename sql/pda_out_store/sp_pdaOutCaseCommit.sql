--��� 2017-09-22 10:14:28
--����PDA�����SQL

/*
exec sp_pdaoutcasecommit 'SED99900CEUQ'
-----------------SQL to get DocNo to run ------------------
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
*/

CREATE  PROC [dbo].[sp_pdaOutCaseCommit]

@docno NVARCHAR(20)         --����

AS

/*
-- pine   2015.10.15  modi ���ӶԱ�MaterialOut_Head     packqty �ֶεĸ�ֵ
-- pine    2015.10.26  modi ��������Ŀ��ƣ���Ϊ��C#�������ܲ������ã������ڴ˼���������ơ�
*/

DECLARE @batchqty INT    --δ��������
DECLARE @error NVARCHAR(50)   --�����¼
DECLARE @otherbatch NVARCHAR(30) --δ��¼������
DECLARE @CheckFlag BIT    --���ϵ���˱�־
DECLARE @batchid NVARCHAR(30)  --��¼���������
DECLARE @outdocno VARCHAR(20)  --���ⵥ��
DECLARE @sendlldocno VARCHAR(20)  --���ϵ���
DECLARE @tojjdate DATETIME        -- ���Ͻ��� by lw 2016.04.26 ����

--**** Create index idx_docno on MaterialSend_head(docno)
SELECT @sendlldocno=a.DocNo, @CheckFlag=A.CheckFlag ,@tojjdate=a.tojjdate
FROM dbo.MaterialSend_head A (NOLOCK)
WHERE A.DocNo=@docno

--û�����ϵ�
IF @sendlldocno is null
	BEGIN

		SET @error='û�����ϵ���'
		RAISERROR(@error,16,1)
		RETURN
	END

--���ϵ�û�����
IF ISNULL(@CheckFlag,0) <> 1
	BEGIN
		SET @error='���ϵ�: '+@docno +' û����ˣ�'
		RAISERROR(@error,16,1)
		RETURN
	END

--���ӱ��Ͻ����жϣ����п���ͨ���巿ϵͳȡ���˱��Ͻ��ӵ����
if @tojjdate is null
	begin
		SET @error='�����ϵ�û�б��Ͻ��ӳ����ȡ���˱��Ͻ��ӳ���,���飡'
		RAISERROR(@error,16,1)
		RETURN
	end

IF EXISTS(SELECT * FROM dbo.MaterialOut_Head (nolock) WHERE SendNo=@docno)
	BEGIN
		SET @error='���ϵ�: '+@docno + ' �Ѿ����ɳ��ⵥ�����飡'
		RAISERROR(@error,16,1)
		RETURN
	END


IF EXISTS(SELECT * FROM dbo.MaterialSend_DetailD (nolock) WHERE OutFlag=1 AND DocNo=@docno)
	BEGIN
		SET @error='���ϵ�: '+@docno + ' �Ѿ����⣬���飡'
		RAISERROR(@error,16,1)
		RETURN
	END

SELECT @batchqty=COUNT(A.DocNo)
FROM dbo.MaterialSend_DetailD A (nolock)
INNER JOIN dbo.MaterialSend_head B(nolock) ON A.DocNo=B.DocNo
LEFT JOIN pdaoutcase C(nolock) ON A.DocNo=C.DocNo AND A.BatchID=C.BatchID AND A.BarcodeNo=C.BarcodeNo
WHERE A.DocNo=@docno AND C.DocNo IS NULL

IF @batchqty<>0
	BEGIN
		SET @error='���� '+CAST(@batchqty AS VARCHAR(10))  + ' ��û����ɣ�������ٷ��ͣ�'
		RAISERROR(@error,16,1)
		RETURN
	END

SELECT TOP 1 @otherbatch=a.BatchID
FROM pdaoutcase a(nolock)
LEFT JOIN MaterialSend_DetailD b(nolock) ON A.DocNo=B.DocNo AND A.BatchID=B.BatchID
WHERE a.DocNo=@docno AND b.DocNo IS NULL

IF @otherbatch IS NOT NULL
	BEGIN
		SET @error='������ '+@otherbatch +' �����ڵ�ǰ���ϵ���'
		RAISERROR(@error,16,1)
		RETURN
	END

SELECT TOP 1 @batchid=a.BatchID
FROM pdaoutcase a(nolock) LEFT JOIN dbo.MaterialStoreQty b(nolock) ON a.BatchID=b.BatchID
WHERE a.DocNo=@docno AND b.BatchID IS NULL

IF @batchid IS NOT NULL
	BEGIN
		SET @error='������ '+@batchid +' û���ϻ��ܣ�'
		RAISERROR(@error,16,1)
		RETURN
	END

SELECT @batchid=a.BatchID
FROM pdaoutcase a (nolock)
LEFT JOIN MaterialSend_DetailD b(nolock) ON a.DocNo=b.DocNo AND a.BatchID=b.BatchID AND a.BarcodeNo = b.BarcodeNo
LEFT JOIN MaterialStoreQty c(nolock) ON  a.BatchID=c.BatchID
WHERE (ISNULL(c.[Length],0)<=0 OR ISNULL(c.Weight,0)<=0) AND a.DocNo=@docno

IF @batchid IS NOT NULL
	BEGIN
		SET @error='����ʧ�ܣ������� '+@batchid +' ���Ϊ0�����飡'
		RAISERROR(@error,16,1)
		RETURN
	END


IF EXISTS(
	--**** SELECT 1 FROM
	SELECT * FROM MaterialSend_DetailD A(nolock)
	INNER JOIN dbo.MaterialSend_head B(nolock) ON A.DocNo = B.DocNo
	FULL JOIN pdaoutcase C(nolock) ON A.DocNo=C.DocNo AND A.BatchID=C.BatchID AND A.BarcodeNo=C.BarcodeNo
	WHERE (A.DocNo IS NULL OR C.DocNo IS NULL OR ISNULL(B.CheckFlag,0)=0) AND C.DocNo=@docno)
	BEGIN
		SET @error='��֪���������������: '+@docno+' �Ƿ����쳣��'
		RAISERROR(@error,16,1)
		RETURN
	END
ELSE
	BEGIN
		-- pine    2015.10.26  modi ��������Ŀ��ƣ���Ϊ��C#�������ܲ������ã������ڴ˼���������ơ�
		begin tran tr1
			exec spGetBranchDocNumber 'MATSTORE','stockoutnumber','OUT999','1',@outdocno OUTPUT

			--by lw 2016.05.11 �������ʵ�ʳ�������length��Ϊͨ������������������ȡ��,������������sendlength
			INSERT INTO dbo.MaterialOut_Detail
				(DocNo,Line,BarcodeNo,MatNo,BatchID,VolumeID,Package,Qtyi,Qunit,Weight,Wunit,Conversion,Length,Lunit,locationid,matdesc,season,reqperson,dsgpoperson,colorid,colodesc,storelength,storeweight,storeno,sendlength)
			SELECT
				distinct @outdocno,A.DLine,A.BarcodeNo,A.MatNo,A.BatchID,A.VolumeID,A.Package,A.Qtyi,A.Qunit,b.WeightQty,A.Wunit,A.Conversion,CASE when isnull(a.Conversion,0)<=0 then A.Length else b.WeightQty/a.Conversion*ISNULL(a.sampleqty,1) end Length,A.Lunit,A.LocationID,c.matdesc,c.season,c.reqperson,c.dsgpoperson,c.colorid,c.colordesc,d.Length,d.Weight,c.storeno,a.Length
			FROM
				MaterialSend_DetailD A (nolock)
			INNER JOIN
				pdaOutCase B(nolock) ON A.DocNo=B.DocNo AND A.BarcodeNo = B.BarcodeNo AND A.BatchID = B.BatchID
			left join
				vw_matBatchInfo (nolock) c on a.batchid=c.batchid
			left join
				MaterialStoreQty (nolock) d on a.batchid=d.batchid
			WHERE B.DocNo=@docno

			IF( @@ERROR<>0 OR @@ROWCOUNT<1)
				BEGIN
					SET @error='д��MaterialOut_Detail�����'
					if @@ERROR<>0 rollback tran tr1;
					RAISERROR(@error,16,1)
					RETURN
				END

			-- pine   2015.10.15  modi ���ӶԱ�MaterialOut_Head     packqty �ֶεĸ�ֵ
			INSERT INTO dbo.MaterialOut_Head
				(DocNo,SendNo,MocType,StoreNo,ReceiveDpt,SendDate,SendUser,CheckFlag,CheckDate,CheckUser,Inuser,Indate,Remark,stock_desc,pdauserid,packqty)
			SELECT
				TOP 1 @outdocno DocNo,b.DocNo SendNo,'��������' MocType,b.StoreNo StoreNo,b.ReceiveDpt ReceiveDpt,GETDATE() SendDate,b.SendUser SendUser,0 CheckFlag,'1900-01-01 00:00:00.000' CheckDate,b.CheckUser CheckUser,b.Inuser Inuser,GETDATE() Indate,'PDA��������' AS Remark,c.StoreName,a.userid,a.packqty
			FROM
				pdaoutcase a (nolock)
			INNER JOIN
				dbo.MaterialSend_head b(nolock) ON a.DocNo=b.DocNo
			left join
				MaterialStoreInfo c(nolock) on b.StoreNo=c.StoreNo
			WHERE a.DocNo=@docno

			IF(@@ERROR<>0 OR @@ROWCOUNT<1)
				BEGIN
					SET @error='д��MaterialOut_Head�����'
					if @@ERROR<>0 rollback tran tr1;
					RAISERROR(@error,16,1)
					RETURN
				END

			UPDATE MaterialSend_DetailD
				set Weight=b.WeightQty,
					OutFlag=1
			FROM dbo.MaterialSend_DetailD a(nolock)
			INNER JOIN
				pdaoutcase b(nolock) on a.DocNo=b.DocNo AND a.BarcodeNo = b.BarcodeNo AND a.BatchID = b.BatchID
			INNER JOIN
				MaterialOut_Detail c(nolock) on a.BatchID=c.BatchID
			WHERE a.DocNo=@docno and c.DocNo=@outdocno

			IF(@@ERROR<>0 OR @@ROWCOUNT<1)
				BEGIN
					SET @error='����MaterialSend_DetailD�����'
					if @@ERROR<>0 rollback tran tr1;
					RAISERROR(@error,16,1)
					RETURN
				END

			UPDATE MaterialStoreQty
				SET Length=CASE WHEN (a.Length-d.Length)<=0 OR (a.Weight-c.WeightQty)<=0 THEN 0 ELSE (a.Length- case when e.itemtype='02' then d.Length when isnull(b.Conversion,0)<=0 then d.Length else c.WeightQty/b.Conversion*ISNULL(b.sampleqty,1) end) end,
					Weight=CASE WHEN (a.Length-d.Length)<=0 OR (a.Weight-c.WeightQty)<=0 THEN 0 ELSE a.Weight-c.WeightQty end
			FROM MaterialStoreQty a (nolock)
			INNER JOIN
				MaterialSend_DetailD b(nolock) ON a.BatchID = b.BatchID
			INNER JOIN
				pdaoutcase c(nolock) ON b.BarcodeNo = c.BarcodeNo AND b.DocNo = c.DocNo AND b.BatchID = c.BatchID
			INNER JOIN
				MaterialOut_Detail d(nolock) on b.BatchID=d.BatchID
			LEFT JOIN
				b_item e(nolock) on b.MatNo=e.item_code
			WHERE c.DocNo=@docno and d.DocNo=@outdocno

			IF( @@ERROR<>0 OR @@ROWCOUNT<1)
				BEGIN
					SET @error='����MaterialStoreQty�����'
					if @@ERROR<>0 rollback tran tr1;
					RAISERROR(@error,16,1)
					RETURN
				END

			Insert into MaterialDayQuery
				(docno,line,doctype,docdate,matno,batchid,conversion,length,weight,storelength,storeweight,remark,inuser,checkuser,department)
				--by lw 2016.05.11 ��MaterialDayQuery �����ֶ� length ԭ��ȡ a.length ��Ϊȡ a.sendlength
			select
				a.docno,a.line,'PDAɨ�����',b.senddate,a.matno,a.batchid,a.conversion,a.sendlength,a.qtyi,c.length,c.weight,b.remark,Inuser,CheckUser,b.ReceiveDpt
			from
				MaterialOut_Detail (nolock) a
			left join
				MaterialOut_Head (nolock) b on a.docno=b.docno
			left join
				MaterialStoreQty (nolock) c on a.BatchID=c.BatchID
			where b.docno=@outdocno

			IF( @@ERROR<>0 OR @@ROWCOUNT<1)
				BEGIN
					SET @error='д��MaterialDayQuery�����'
					if @@ERROR<>0 rollback tran tr1;
					RAISERROR(@error,16,1)
					RETURN
				END

			UPDATE MaterialOut_Head
				SET CheckFlag=1,
					CheckDate=GETDATE()
			WHERE DocNo=@outdocno

			IF( @@ERROR<>0 OR @@ROWCOUNT<1)
				BEGIN
					SET @error='����MaterialOut_Head��־����'
					if @@ERROR<>0 rollback tran tr1;
					RAISERROR(@error,16,1)
					RETURN
				END

		--by lw 2016.07.22 ����
		--exec spexecupdatereqllqty   @outdocno
	END

if @@ERROR<>0
	rollback tran tr1
else
	commit tran tr1;
