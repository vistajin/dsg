Select 
    cast(0 as bit ) as selectflag,a.LocationID,a.MatNo,a.MatDesc,a.BatchID,a.volumeid,a.Package,
    a.avnoresweight Qtyi,a.Wunit as Qunit,a.storelength stocklength,--????
    a.storeweight stockweight,a.Wunit,a.conversion,a.avnoreslength as Length,a.Lunit,a.avnoreslength  as usablelength,--????
    a.ColorID,a.ColorDesc, a.mattype,a.Season,a.reqperson as person,
    case when reqd.req_serial is null then a.dsgpoperson else reqd.bantracknm end as dsgpoperson,
    a.crockid,a.sampleqty,NULL as resno,NULL as resline,a.storeno,
    case when reqd.req_serial is null then a.styleno else reqd.styleno end as styleno,
    case when reqd.req_serial is null then a.banid else reqd.banid end as templetid,
    a.itemtype,
    case when a.storeno in ('B','C') then '主料' when a.storeno='A' then '辅料' else '' end as itemtype1,
    a.OrderNo,a.inoutdate,a.SupplierDesc,a.inLength as YLength,a.inWeight AS YWeight,a.supplierid,a.podeptdesc,
    a.supply_colorname, a.rev_number,a.mattypename,a.mattypedesc,
    case when reqd.req_serial is null then a.banid else reqd.banid end as banid,
    case when reqd.req_serial is null then a.part else reqd.part end as part,
    case when reqd.req_serial is null then a.Designer else reqd.dsgdeptname end as Designer,
    case when reqd.req_serial is null then a.dsgstyle else reqd.dsgstyle end as dsgstyle,
    reqd.pre_number,reqd.pre_line,pre.unit as preunit,
    case when pre.unit<>a.Lunit and pre.unit='磅' then (pre.needqty-ISNULL(pre.cancleQty,0)-ISNULL(pre.cancleQty2,0))*a.sampleqty/a.conversion
         else (pre.needqty-ISNULL(pre.cancleQty,0)-ISNULL(pre.cancleQty2,0)) end preneedqty,
    (isnull(c.outlength,0)+ISNULL(d.sendlength,0)) bcklength,
    case when a.storeno in ('B','C') and (a.avnoreslength-((case when pre.unit<>a.Lunit and pre.unit='磅' then pre.rtnqty*a.sampleqty/a.conversion else pre.rtnqty end)-isnull(c.outlength,0)-ISNULL(d.sendlength,0))>=0) then ((case when pre.unit<>a.Lunit and pre.unit='磅' then pre.rtnqty*a.sampleqty/a.conversion else pre.rtnqty end)-isnull(c.outlength,0)-ISNULL(d.sendlength,0))
         when a.storeno in ('B','C') and (a.avnoreslength-((case when pre.unit<>a.Lunit and pre.unit='磅' then pre.rtnqty*a.sampleqty/a.conversion else pre.rtnqty end)-isnull(c.outlength,0)-ISNULL(d.sendlength,0))<0) then a.avnoreslength
         when a.storeno in ('A') and (a.avnoreslength-(pre.rtnqty-isnull(c.outlength,0)-ISNULL(d.sendlength,0))>=0) then pre.rtnqty-isnull(c.outlength,0)-ISNULL(d.sendlength,0)
         when a.storeno in ('A') and (a.avnoreslength-(pre.rtnqty-isnull(c.outlength,0)-ISNULL(d.sendlength,0))<0) then a.avnoreslength
         else a.avnoreslength end as prerestqty
into #tmpmaterialsend
from vm_batchstoreqty a
left join materialtype (nolock) b on a.mattype=b.mattypeid
left join req_detaild reqd(nolock) on a.orderserial=reqd.req_serial and a.line=reqd.req_line
left join req_head reqh(nolock) on reqh.req_serial=reqd.req_serial
left join  MaterialLocationInfo (nolock) k on a.LocationID = k.locationID
Left join dsg_prelist_detail(nolock) pre on pre.pre_number=reqd.pre_number and pre.pre_line=reqd.pre_line
left join (
    Select c.pre_number,c.pre_line,SUM(a.length) as outlength
    from MaterialOut_Detail a
    left join MaterialOut_Head b on b.DocNo=a.DocNo
    left join MaterialSend_DetailD c on c.DocNo=b.SendNo and c.BatchID=a.BatchID
    where c.resno is null and b.SendNo not like 'BCK%' and c.pre_number is not null
        and a.MatNo like '18EK-PWS0172%'
        and a.colorid like '01-003%'
    group by c.pre_number,c.pre_line) c on c.pre_number=reqd.pre_number and c.pre_line=reqd.pre_line
left join (
    Select a.pre_number,a.pre_line,SUM(length) as sendlength
    from MaterialSend_DetailD a
    inner join MaterialSend_head c on c.docno=a.docno
    left join MaterialOut_Head b on b.SendNo=a.DocNo
    where c.indate>=getdate()-15 and a.resno is null and b.DocNo is null and a.docno like 'SED%' and a.pre_number is not null
    group by a.pre_number,a.pre_line) d on d.pre_number=reqd.pre_number and d.pre_line=reqd.pre_line  --未出库

where 1=1 and a.storelength>0 and a.storeweight>0 and a.avnoreslength>0 and a.avnoresweight>0
      and (k.lockflag is null or k.lockflag<>'1')
      and a.MatNo like '18EK-PWS0172%'
      and a.colorid like '01-003%';

select * from #tmpmaterialsend

