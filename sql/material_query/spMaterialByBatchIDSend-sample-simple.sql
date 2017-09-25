Select XXX
into #new_material
from vm_batchstoreqty a
left join req_detaild(nolock) reqd on a.orderserial=reqd.req_serial and a.line=reqd.req_line
left join  MaterialLocationInfo(nolock) k  on a.LocationID = k.locationID
where a.isoldmat=1 and a.storelength>0 and a.storeweight>0 and a.avnoreslength >0 and a.avnoresweight>0 and k.lockflag=0
and a.BatchID  like '%18EK-PWS0172%'

---------------------------------------------------------------
select * into #tmpmaterialsend from (
Select XXX
from #new_material a
left join (
	Select c.pre_number,c.pre_line,SUM(a.length) as outlength
	from MaterialOut_Detail(nolock) a
	left join MaterialOut_Head(nolock) b on b.DocNo=a.DocNo
	left join MaterialSend_DetailD(nolock) c on c.DocNo=b.SendNo and c.BatchID=a.BatchID
	where c.pre_number+convert(varchar,c.pre_line) in (select pre_number+convert(varchar,pre_line)from #new_material) 
		and c.resno is null and b.SendNo not like 'BCK%' and c.pre_number is not null
	group by c.pre_number,c.pre_line) c on c.pre_number=a.pre_number and c.pre_line=a.pre_line  --已出库
left join (
	Select a.pre_number,a.pre_line,SUM(length) as sendlength
	from MaterialSend_DetailD(nolock) a
	inner join MaterialSend_head(nolock) c on c.docno=a.docno
	left join MaterialOut_Head(nolock) b on b.SendNo=a.DocNo
	where a.docno like 'SED%' and a.resno is null and b.DocNo is null and a.pre_number is not null 
		and a.pre_number+convert(varchar,a.pre_line) in (select pre_number+convert(varchar,pre_line) from #new_material)
    group by a.pre_number,a.pre_line) d on d.pre_number=a.pre_number and d.pre_line=a.pre_line  --未出库
union all
Select XXX
from vm_batchstoreqty a
left join req_detaild reqd(nolock) on a.orderserial=reqd.req_serial and a.line=reqd.req_line
left join  MaterialLocationInfo (nolock) k  on a.LocationID = k.locationID
where a.isoldmat=0 and a.storelength>0 and a.storeweight>0 and a.avnoreslength >0 and a.avnoresweight>0 and k.lockflag=0
and a.BatchID  like '%18EK-PWS0172%'
)

select * from #tmpmaterialsend