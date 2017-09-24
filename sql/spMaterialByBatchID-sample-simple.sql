Select XXX
into #tmpmaterialsend
from vm_batchstoreqty a
left join materialtype (nolock) b on a.mattype=b.mattypeid
left join req_detaild reqd(nolock) on a.orderserial=reqd.req_serial and a.line=reqd.req_line
left join req_head reqh(nolock) on reqh.req_serial=reqd.req_serial
left join  MaterialLocationInfo (nolock) k on a.LocationID = k.locationID
Left join dsg_prelist_detail(nolock) pre on pre.pre_number=reqd.pre_number and pre.pre_line=reqd.pre_line
left join (
    Select c.pre_number,c.pre_line,SUM(a.length) as outlength ----->isnull(SUM(a.length),0) as outlength
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

