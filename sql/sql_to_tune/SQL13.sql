select
	distinct b.docno as recno,a.checkdate as colindate,a.docno,a.doctype,ad.length,ad.lunit,ad.weight,ad.wunit,ad.batchid,ad.conversion,a.inuser as colinuser,a.checkflag colcheckflag,a.checkdate  collectdate,ad.remark,i.username ,ad.turnoldragsflag,ad.turnoldragsdate,ad.turnoldragsuserid,ad.turnoldragsusername,a.printdate,a.printuser,a.printcount,b.checkdate as recdate,bd.length as reclength,bd.weight as recweight,b.checkflag as reccheckflag,b.inuser as recinuser,y.det_number,Y.checkdate,Y.qadate,Y.styleflag,Y.returnflag,Y.ratify,Y.qainuser,Y.ratifyuser,Y.ratifydate,Y.unqualified,Y.result,Y.dsgcheckdate,case when (Y.ratifydate is not null) and (DATEDIFF(hh,isnull(dd.tmprecdate,getdate()),isnull(Y.ratifydate,getdate()))>4) then '超时' when (Y.ratifydate is not null) and (DATEDIFF(hh,isnull(dd.tmprecdate,getdate()),isnull(Y.ratifydate,getdate()))<=4) then '未超时' when (Y.ratifydate is null) and (DATEDIFF(hh,isnull(dd.tmprecdate,getdate()),isnull(Y.checkdate,getdate()))>4) then '超时' else '未超时' end as overdatetime,d.rev_number,dd.req_number orderno,dd.req_serial orderserial,dd.req_line,dd.podeptdesc,dd.item_code matno,dd.item_desc matdesc,dd.color_name colorid,dd.color_desc colordesc,dd.season,dd.reqperson,dd.dsgpoperson,dd.dsgdeptDesc,dd.dsgname designer,dd.model,dd.unit,dd.dsgstyle,dd.needqty,dd.podivqty,dd.restqty,dd.ganghao,dd.supply_code,dd.supply_desc,dd.supply_colorname,dd.ponumber,dd.szmd,dd.tmprecdate,dd.tmprecuserid,dd.tmprecusername,dd.tmprecflag,dd.isTempMatFlag,dd.recremark,e.poprice,e.storeno,e.mattype,e.mattypename,e.mattypedesc,e.isoldmat,e.package,e.supplierid,e.supplierDesc,g.putdate,g.docno putdocno,g.checkflag putcheckflag,g.inuser as putinuser,b.OrderTjkRemark,bd.otherinweight,bd.otherinlength
from rev_detail(nolock) dd
Left join rev_head(nolock) d on d.rev_number=dd.rev_number
--Left join dsg_checkout_detail(nolock) cd on cd.rev_number=dd.rev_number and cd.orderserial=dd.req_serial and cd.orderline=dd.req_line
--Left join dsg_checkout_head(nolock) c on c.det_number=cd.det_number
Left join (
	select x.* from(
		select
			c.det_number,cd.rev_number,cd.orderserial,cd.orderline,c.checkdate,c.checkdate as qadate,cd.styleflag,cd.returnflag,cd.ratify,c.inuser as qainuser,cd.ratifyuser,cd.ratifydate,case when cd.result2date is not null then cd.unqualified2 else cd.unqualified end as unqualified,case when cd.result2date is not null then cd.result2 else cd.result end as result,case when cd.result2date is not null then cd.result2date when cd.resultdate is not null then cd.resultdate else c.checkdate end as dsgcheckdate
		from dsg_checkout_head(nolock) c
		left join dsg_checkout_detail(nolock) cd on cd.det_number=c.det_number) X
inner join (
	select 
		cd.rev_number,cd.orderserial,cd.orderline,MAX(case when cd.result2date is not null then cd.result2date when cd.resultdate is not null then cd.resultdate else c.checkdate end) as dsgcheckdate
	from dsg_checkout_head(nolock) c
	left join dsg_checkout_detail(nolock) cd on cd.det_number=c.det_number
	group by cd.rev_number,cd.orderserial,cd.orderline) w on w.rev_number=x.rev_number and w.orderserial=x.orderserial and w.orderline=x.orderline and w.dsgcheckdate=x.dsgcheckdate) Y on Y.rev_number=dd.rev_number and Y.orderserial=dd.req_serial and Y.orderline=dd.req_line
left join MaterialReceivble_Head(nolock) b on b.rev_number=dd.rev_number and b.orderserial=dd.req_serial  and b.OrderLine=dd.req_line
left join MaterialReceivble_detail(nolock) bd on bd.docno=b.docno --and bd.line=dd.req_line
left join MaterialCollect_detail(nolock) ad on ad.BatchID=bd.BatchID
left join MaterialCollect_Head(nolock) a on a.DocNo=ad.DocNo
left join materialbatchinfo(nolock) e on e.batchid=bd.batchid
Left join MaterialPut_detail(nolock) f on f.batchid=bd.batchid
Left join MaterialPut_Head(nolock) g on g.docno=f.docno
Left join b_item(nolock) h on h.item_code=dd.item_code
left join s_users(nolock) i on i.userid = a.inuser
where 1=1 and isnull(a.docno,'')=''
	and dd.tmprecdate>='2017-08-24 00:00:00'
	and y.checkdate>='2017-08-24 00:00:00'
	and isnull(dd.isTempMatFlag,0)=0
	and h.itemtype='02'
