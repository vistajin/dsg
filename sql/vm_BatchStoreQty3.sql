/*cyueyong 20160526 批号库存数量运算*/
CREATE VIEW [dbo].[vm_BatchStoreQty3] With Schemabinding
AS
--cyueyong 20160526 批号库存数量运算

-- table used in this view
-- materialbatchinfo (BatchID)
-- MaterialStoreQty (BatchID)
-- MaterialCollect_detail (docno)
-- MaterialCollect_head (docno)
-- MaterialReturnStore_Detail (docno)
-- MaterialReturnStore_head (docno)
-- materialsend_detaild (docno, resno)
-- materialsend_head (docno, checkflag)
-- materialout_head (sendno)
select
    a.BatchID,a.MatNo,a.volumeid,a.mattype,a.mattypename,a.mattypedesc,a.MatDesc,a.OrderNo,a.line,a.orderserial,a.lockflag,a.ColorID,a.ColorDesc,a.Season,a.reqperson,a.Designer,a.dsgdeptdesc,a.supplierid, a.SupplierDesc,a.Package,a.batch,a.conversion,a.crockid,a.dsgpoperson,a.poprice,a.isoldmat,a.storeno,a.podept,a.podeptdesc,a.reqdept,a.reqdeptdesc,a.revperson,a.supply_colorname,a.part,a.dsgstyle,a.element,a.needqty,a.banid,a.goodsperiod,a.styleno,a.rev_number,a.isoptionalflag,a.optionalflaguser,a.optionalflagdate,a.clothareano,a.weight as kz,a.dsgclothareano,a.itemtype,
    (case when (a.mattypename='针织' or a.mattypename='毛织' or a.mattypename='鸭绒') then isnull(a.poprice,0)*isnull(b.weight,0) else isnull(a.poprice,0)*isnull(b.Length,0) end) as amount,
    b.LocationID,b.sampleqty,a.Lunit,a.Wunit,
    b.Length as StoreLength,--库存数量
    b.weight as StoreWeight,--库存重量
    d.Length inlength,--入库数量
    d.Weight inweight,--入库重量
    --可用数量=库存-正常未出-预留未出
    case when b.length-e.doclen-e.reslen<0 then 0 else b.length-e.doclen-e.reslen end avlength,
    --可用重量
    case when b.weight-e.docqtyi-e.resqtyi<0 then 0 else b.weight-e.docqtyi-e.resqtyi end avweight,
    --实际可用数量=库存-正常未出-预留未出-预留剩余
    case WHEN f.doclen-f.reslen < 0 THEN b.length-e.doclen
         WHEN b.length-e.doclen-e.reslen-(f.doclen-f.reslen) < 0 THEN 0
         else b.length-e.doclen-e.reslen-(f.doclen-f.reslen)end as avnoreslength,
    case WHEN f.docqtyi-f.resqtyi < 0 THEN b.weight-e.docqtyi
         WHEN b.weight-e.docqtyi-e.resqtyi-f.docqtyi-f.resqtyi < 0 THEN 0
         else b.weight-e.docqtyi-e.resqtyi-f.docqtyi-f.resqtyi end as avnoresweight,  --实际可用重量
    e.doclen as nochecknoreslen , --未审核(不包括领预留)|数量
    e.docqtyi as nochecknoresweight,
    f.reslen as reslylen , --预留|已领数量(b)
    f.resqtyi as reslyqtyi,
    case when (f.doclen-f.reslen) > 0 then f.doclen-f.reslen else 0.0 end as reslensy, --预留|剩余数量(c=a-b)
    case when (f.docqtyi-f.resqtyi) > 0 then f.docqtyi-f.resqtyi else 0.0 end as resweightsy,
    f.doclen as reslen , --预留|最初数量(a)
    f.docqtyi as resweight,b.inoutdate,d.remark,d.CollectDate,d.DocNo as coldocno,d.turnoldragsdate,d.returndpt
from doo.materialbatchinfo (nolock) a
left join doo.MaterialStoreQty (nolock) b on b.BatchID=a.BatchID
left join (
    select mm.docno,mm.batchid,matno,length,lunit,weight,wunit,conversion, turnoldragsflag,turnoldragsdate,cc.CollectDate ,cc.color_name,cc.color_desc,mm.remark,'' as returndpt
    from doo.MaterialCollect_detail (nolock) mm
    inner join doo.MaterialCollect_head cc on mm.docno=cc.docno
    union all
    select rr.docno,newbatchid,rr.matno,length,lunit,weight,wunit,conversion,'','',ss.InDate CollectDate,ss.ColorID  color_name,ss.ColorDesc color_desc ,rr.remark,returndpt
    from doo.MaterialReturnStore_Detail (nolock) rr
    inner join doo.MaterialReturnStore_head ss on rr.docno=ss.docno) d on a.batchid=d.BatchID

left join (select 
                batchid, 
                SUM(CASE WHEN msd.docno like 'RES%' THEN length ELSE 0 END)as doclen, 
                SUM(CASE WHEN msd.docno like 'RES%' THEN qtyi ELSE 0 END) as docqtyi, 
                SUM(CASE WHEN msd.resno like 'RES%' THEN length ELSE 0 END) reslen,
                SUM(CASE WHEN msd.resno like 'RES%' THEN qtyi ELSE 0 END) resqtyi
            from doo.materialsend_detaild msd(nolock) 
            inner join doo.materialsend_head d(nolock) on msd.docno=d.docno
            where d.checkflag=1 and (msd.docno like 'RES%' or msd.resno like 'RES%')
            group by BatchID) f on a.batchid=f.batchid  --f 预留数量 / 领预留数量
left join (select 
                batchid,
				SUM(CASE WHEN msd2.resno is null THEN length ELSE 0 END) as doclen, 
				SUM(CASE WHEN msd2.resno is null THEN qtyi ELSE 0 END) as docqtyi,
				SUM(CASE WHEN msd2.resno like 'RES%' THEN length ELSE 0 END) as reslen, 
				SUM(CASE WHEN msd2.resno like 'RES%' THEN qtyi ELSE 0 END) as resqtyi
           from doo.materialsend_detaild msd2(nolock)
           inner join doo.materialsend_head d(nolock) on msd2.docno=d.docno
           left join doo.materialout_head c(nolock) on msd2.docno=c.sendno
           where d.checkflag=1 and msd2.docno not like 'RES%' and c.docno is null and (msd2.resno is null or msd2.resno like 'RES%')
           group by BatchID) e on a.batchid=e.batchid  --e 正常领料未出货 / 领预留未出数量