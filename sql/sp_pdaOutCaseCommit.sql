--李东初 2017-09-22 10:14:28
--这是PDA出库的SQL

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

@docno NVARCHAR(20)         --单号

AS

/*
-- pine   2015.10.15  modi 增加对表MaterialOut_Head     packqty 字段的赋值
-- pine    2015.10.26  modi 增加事务的控制，因为在C#中事务不能产生作用，所以在此加上事务控制。
*/

DECLARE @batchqty INT    --未过磅数量
DECLARE @error NVARCHAR(50)   --错误记录
DECLARE @otherbatch NVARCHAR(30) --未记录的批次
DECLARE @CheckFlag BIT    --领料单审核标志
DECLARE @batchid NVARCHAR(30)  --记录错误的批次
DECLARE @outdocno VARCHAR(20)  --出库单号
DECLARE @sendlldocno VARCHAR(20)  --领料单号
DECLARE @tojjdate DATETIME        -- 备料交接 by lw 2016.04.26 增加

--**** Create index idx_docno on MaterialSend_head(docno)
SELECT @sendlldocno=a.DocNo, @CheckFlag=A.CheckFlag ,@tojjdate=a.tojjdate
FROM dbo.MaterialSend_head A (NOLOCK)
WHERE A.DocNo=@docno

--没有领料单
IF @sendlldocno is null
	BEGIN

		SET @error='没有领料单！'
		RAISERROR(@error,16,1)
		RETURN
	END

--领料单没有审核
IF ISNULL(@CheckFlag,0) <> 1
	BEGIN
		SET @error='物料单: '+@docno +' 没有审核！'
		RAISERROR(@error,16,1)
		RETURN
	END

--增加备料交接判断，因有可能通过板房系统取消了备料交接的情况
if @tojjdate is null
	begin
		SET @error='该领料单没有备料交接出库或取消了备料交接出库,请检查！'
		RAISERROR(@error,16,1)
		RETURN
	end

IF EXISTS(SELECT * FROM dbo.MaterialOut_Head (nolock) WHERE SendNo=@docno)
	BEGIN
		SET @error='领料单: '+@docno + ' 已经生成出库单，请检查！'
		RAISERROR(@error,16,1)
		RETURN
	END


IF EXISTS(SELECT * FROM dbo.MaterialSend_DetailD (nolock) WHERE OutFlag=1 AND DocNo=@docno)
	BEGIN
		SET @error='领料单: '+@docno + ' 已经出库，请检查！'
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
		SET @error='还有 '+CAST(@batchqty AS VARCHAR(10))  + ' 批没有完成，请完成再发送！'
		RAISERROR(@error,16,1)
		RETURN
	END

SELECT TOP 1 @otherbatch=a.BatchID
FROM pdaoutcase a(nolock)
LEFT JOIN MaterialSend_DetailD b(nolock) ON A.DocNo=B.DocNo AND A.BatchID=B.BatchID
WHERE a.DocNo=@docno AND b.DocNo IS NULL

IF @otherbatch IS NOT NULL
	BEGIN
		SET @error='该批次 '+@otherbatch +' 不属于当前领料单！'
		RAISERROR(@error,16,1)
		RETURN
	END

SELECT TOP 1 @batchid=a.BatchID
FROM pdaoutcase a(nolock) LEFT JOIN dbo.MaterialStoreQty b(nolock) ON a.BatchID=b.BatchID
WHERE a.DocNo=@docno AND b.BatchID IS NULL

IF @batchid IS NOT NULL
	BEGIN
		SET @error='该批次 '+@batchid +' 没有上货架！'
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
		SET @error='发送失败，该批次 '+@batchid +' 库存为0，请检查！'
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
		SET @error='不知明错误，请检查领货单: '+@docno+' 是否有异常！'
		RAISERROR(@error,16,1)
		RETURN
	END
ELSE
	BEGIN
		-- pine    2015.10.26  modi 增加事务的控制，因为在C#中事务不能产生作用，所以在此加上事务控制。
		begin tran tr1
			exec spGetBranchDocNumber 'MATSTORE','stockoutnumber','OUT999','1',@outdocno OUTPUT

			--by lw 2016.05.11 出库表中实际出库数量length改为通过过磅称重数量换算取得,增加申领数量sendlength
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
					SET @error='写入MaterialOut_Detail表出错！'
					if @@ERROR<>0 rollback tran tr1;
					RAISERROR(@error,16,1)
					RETURN
				END

			-- pine   2015.10.15  modi 增加对表MaterialOut_Head     packqty 字段的赋值
			INSERT INTO dbo.MaterialOut_Head
				(DocNo,SendNo,MocType,StoreNo,ReceiveDpt,SendDate,SendUser,CheckFlag,CheckDate,CheckUser,Inuser,Indate,Remark,stock_desc,pdauserid,packqty)
			SELECT
				TOP 1 @outdocno DocNo,b.DocNo SendNo,'正常出库' MocType,b.StoreNo StoreNo,b.ReceiveDpt ReceiveDpt,GETDATE() SendDate,b.SendUser SendUser,0 CheckFlag,'1900-01-01 00:00:00.000' CheckDate,b.CheckUser CheckUser,b.Inuser Inuser,GETDATE() Indate,'PDA出库生成' AS Remark,c.StoreName,a.userid,a.packqty
			FROM
				pdaoutcase a (nolock)
			INNER JOIN
				dbo.MaterialSend_head b(nolock) ON a.DocNo=b.DocNo
			left join
				MaterialStoreInfo c(nolock) on b.StoreNo=c.StoreNo
			WHERE a.DocNo=@docno

			IF(@@ERROR<>0 OR @@ROWCOUNT<1)
				BEGIN
					SET @error='写入MaterialOut_Head表出错！'
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
					SET @error='更新MaterialSend_DetailD表出错！'
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
					SET @error='更新MaterialStoreQty表出错！'
					if @@ERROR<>0 rollback tran tr1;
					RAISERROR(@error,16,1)
					RETURN
				END

			Insert into MaterialDayQuery
				(docno,line,doctype,docdate,matno,batchid,conversion,length,weight,storelength,storeweight,remark,inuser,checkuser,department)
				--by lw 2016.05.11 把MaterialDayQuery 表中字段 length 原来取 a.length 改为取 a.sendlength
			select
				a.docno,a.line,'PDA扫描出库',b.senddate,a.matno,a.batchid,a.conversion,a.sendlength,a.qtyi,c.length,c.weight,b.remark,Inuser,CheckUser,b.ReceiveDpt
			from
				MaterialOut_Detail (nolock) a
			left join
				MaterialOut_Head (nolock) b on a.docno=b.docno
			left join
				MaterialStoreQty (nolock) c on a.BatchID=c.BatchID
			where b.docno=@outdocno

			IF( @@ERROR<>0 OR @@ROWCOUNT<1)
				BEGIN
					SET @error='写入MaterialDayQuery表出错！'
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
					SET @error='更新MaterialOut_Head标志出错！'
					if @@ERROR<>0 rollback tran tr1;
					RAISERROR(@error,16,1)
					RETURN
				END

		--by lw 2016.07.22 屏蔽
		--exec spexecupdatereqllqty   @outdocno
	END

if @@ERROR<>0
	rollback tran tr1
else
	commit tran tr1;
