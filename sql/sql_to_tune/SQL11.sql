select
	distinct CASE WHEN isnull(a.tjkflag,0)=1 THEN '特急款' ELSE '' END AS istjkflag,
	b.req_serial,b.req_line,b.podate,b.podate_0,b.podate_user0,b.podate_date0,
	b.podate_1,b.podate_user1,b.podate_date1,b.podate_2,b.podate_user2,b.podate_date2,b.podate_3,b.podate_user3,b.podate_date3,
	b.podate_1text,b.podate_2text,b.podate_3text,b.podate_4text,b.podate_5text,b.podate_6text,b.podate_7text,--add by xm 217-3-23
	b.podate_4,b.podate_user4,b.podate_date4,b.podate_5,b.podate_user5,b.podate_date5,b.podate_6,b.podate_user6,b.podate_date6,
	g.base_itemcode,rh.dsgconfirmflag as reqpriceapplydsgconfirmflag,ieh.dsgflag as iedsgflag,
	(case when (bs.cac_seasonid>=45 and ((isnull(b.jjprice,0)<>0 and b.poprice>b.jjprice) or (isnull(b.jjprice,0)=0 and b.poprice>b.Banbu_engkaifa_price1))) or (bs.cac_seasonid<45 and  isnull(b.minoyearprice,0)<>0 and isnull(b.minoyearcacprice,0)<>0 and (b.poprice>b.minoyearprice or b.poprice>b.minoyearcacprice)) then cast(1 as bit) else cast(0 as bit) end) as ifhighjjpriceflag
into #reptemptb
from req_head a(nolock)
inner join req_detail b(nolock) on a.req_serial=b.req_serial
left join req_detaild b1(nolock) on b.req_serial=b1.req_serial and b.req_line=b1.req_line
left join b_item g(nolock) on b.item_code=g.item_code
left join b_itemcate h(nolock) on g.treeid=h.treeid
left join reqpriceapply_detail(nolock) rd on rd.req_serial=b1.req_serial and rd.req_line=b.req_line
left join reqpriceapply_head(nolock) rh on rh.priceapply_number=rd.priceapply_number
left join ie_dsgmbp_detail(nolock) ie on ie.req_serial=b1.req_serial and ie.req_line=b.req_line
left join ie_dsgmbp(nolock) ieh on ieh.dsgmbp_number=ie.dsgmbp_number
left join b_season(nolock) bs on bs.season=b1.season
where 1=1
	and a.reqdept in (select reqdept from reqrange where userid='1215')
	and a.podept in (select podept from porange where userid='1215')

select distinct * from (
	select
		a1.istjkflag,b.banid,b.styleno,a.req_serial,a.req_number,b.dsgstyle,b.part,a.type,a.season,a.reqdept,a.reqdeptdesc,a.indate,
		a.podept,a.podeptdesc,a.reqperson,a.revperson,b.dporevflag,b.dporevuser,b.dporevdate,b.req_line,b.item_code,b.item_desc,
		b.model,b.color_name,b.color_desc,b.unit,b.weight,b.supply_code,b.supply_desc,
		case when isnull(b.deferapplydateconfirmflag,0)=1 then b.deferdate else b.reqdate end as reqdate,
		b.reqyqdate,b.reqyq_user,b.reqyq_date,b.poprice,b.needqty,d.rtnqty,b.completeflag,b.poperson,b.nowsupply_code,
		b.nowsupply_desc,b.dsgconfirmflag,b.dsgconfirmuser,b.dsgconfirmdate,isnull(b.needqty,0)+isnull(c1.backqty,0)-isnull(d.rtnqty,0) as restqty,isnull(c1.backqty,0) as backqty,
		isnull(b.needqty,0)*isnull(b.poprice,0) as needamt, isnull(d.rtnqty,0)*isnull(b.poprice,0) as rtnamt,
		dbo.GETDSGREQPOLIENOVERDAY(b.req_serial,b.req_line,getdate()) as overday,b.dsgname,b.dsgdeptdesc,
		b.dsgpoperson,b.dahuoprice,b.goodsperiod,b.item_series,b.szmd,b.remark,b.reqbackflag,b.reqbackuser,b.reqbackdate,
		b.cancelreqflag,b.cancelrequser,b.cancelreqdate,b.okconfirmflag,b.okconfirmdate,b.okconfirmuser,b.dsgokdate,b.indatedetail,
		a.mattype,a1.podate,a1.podate_0,a1.podate_user0,a1.podate_date0,a1.podate_1,a1.podate_user1,a1.podate_date1,a1.podate_2,
		a1.podate_user2,a1.podate_date2,a1.podate_3,a1.podate_user3,a1.podate_date3,a1.podate_4,a1.podate_user4,a1.podate_date4,
		a1.podate_5,a1.podate_user5,a1.podate_date5,a1.podate_6,a1.podate_user6,a1.podate_date6,a1.podate_1text,a1.podate_2text,
		a1.podate_3text,a1.podate_4text,a1.podate_5text,a1.podate_6text,a1.podate_7text,--add by xm 217-3-23
		a1.reqpriceapplydsgconfirmflag,a1.iedsgflag,a1.ifhighjjpriceflag,b.supply_colorname,b.supply_colordesc,b.isbefflag,
		b.orderbakdate,b.isorderluseflag, b.qtyotherorder,isnull(c.payflag,0) as payflag,c.dsgmbp_number,d.rtndate,d.confirmsenddate,
		case when ISNULL(f.item_series,'')<>'' then isnull(f.deliverytime1,0) when ISNULL(g.item_series,'')<>'' then isnull(g.deliverytime1,0) when ISNULL(e.item_series,'')<>'' then isnull(e.deliverytime1,0) end as time1,
		case when ISNULL(f.item_series,'')<>'' then isnull(f.deliverytime2,0) when ISNULL(g.item_series,'')<>'' then isnull(g.deliverytime2,0) when ISNULL(e.item_series,'')<>'' then isnull(e.deliverytime2,0) end as time2,\
		ase when ISNULL(f.item_series,'')<>'' then isnull(f.deliverytime3,0) when ISNULL(g.item_series,'')<>'' then isnull(g.deliverytime3,0)  when  ISNULL(e.item_series,'')<>'' then isnull(e.deliverytime3,0) end as time3,d.toinlocatedate,
		b.minoyearprice as minprice,b.minoyearcacprice as mincacprice,b.Banbu_engkaifa_price1,b.Banbu_engkaifa_price2,b.jjprice,
		b.remotematcode,f1.poindate,f1.poconfirmdate,i.revconfirmdate,j.ysindate,j.rkdate,l.qacheckdate,a1.base_itemcode,
		a.req_serial+b.item_code+b.color_name as pid,
		case when d.tfodate is not null then '转仓'
			when j.rkdate is not null then '入仓'
			when l.qacheckdate is not null then 'Q布'
			when i.revconfirmdate is not null then '回货'
			when a1.podate_0 is not null then '供应商复期'
			when b.dsgconfirmdate is not null then '开立采购单给供应商'
			when b.dporevdate is not null then '采购接单'
			else '' end as pstate,
		case when CONVERT(varchar(10),b.indatedetail,120)>=cast(CONVERT(varchar(8),b.indatedetail,23)+'01' as datetime) and CONVERT(varchar(10),b.indatedetail,120)<=dateadd(dd,6,cast(CONVERT(varchar(8),b.indatedetail,23)+'01' as datetime)) then CONVERT(varchar(8),b.indatedetail,120)+'1周' when CONVERT(varchar(10),b.indatedetail,120)>dateadd(dd,6,cast(CONVERT(varchar(8),b.indatedetail,23)+'01' as datetime)) and CONVERT(varchar(10),b.indatedetail,120)<=dateadd(dd,14,cast(CONVERT(varchar(8),b.indatedetail,23)+'01' as datetime)) then CONVERT(varchar(8),b.indatedetail,120)+'2周' when CONVERT(varchar(10),b.indatedetail,120)>dateadd(dd,14,cast(CONVERT(varchar(8),b.indatedetail,23)+'01' as datetime)) and CONVERT(varchar(10),b.indatedetail,120)<=dateadd(dd,22,cast(CONVERT(varchar(8),b.indatedetail,23)+'01' as datetime)) then CONVERT(varchar(8),b.indatedetail,120)+'3周' when CONVERT(varchar(10),b.indatedetail,120)>dateadd(dd,22,cast(CONVERT(varchar(8),b.indatedetail,23)+'01' as datetime)) and CONVERT(varchar(10),b.indatedetail,120)<=dateadd(dd,-1,dateadd(mm,1,cast(CONVERT(varchar(8),b.indatedetail,23)+'01' as datetime))) then CONVERT(varchar(8),b.indatedetail,120)+'4周' end as pweekgroup,p.projectleader,p.supply_desc as psupply_desc,p.tracknm as ptracknm,a.tjkPPtype
	from #reptemptb a1(nolock)
	inner join req_head a(nolock) on a1.req_serial=a.req_serial
	inner join req_detail b(nolock) on (a1.req_serial=b.req_serial) and (a1.req_line=b.req_line)
	left join b_projectleader(nolock) p on p.supply_code=b.supply_code and p.season=a.season
	left join (
		select a.dsgmbp_number,b.req_serial,b.req_line,a.payflag
		from ie_dsgmbp a(nolock)
		inner join ie_dsgmbp_detail b(nolock) on a.dsgmbp_number=b.dsgmbp_number) c on b.req_serial=c.req_serial and b.req_line=c.req_line
	left join (
		select b.req_serial,b.req_line,sum(thisback) as backqty
		from dsgback_head a(nolock)
		inner join dsgback_detail b(nolock) on a.dsgback_number=b.dsgback_number
		group by b.req_serial,b.req_line) c1 on b.req_serial=c1.req_serial and b.req_line=c1.req_line
	left join (
		select b.req_serial,b.req_line,max(convert(varchar(10),a.rtndate,120)) as rtndate,max(convert(varchar(10),b.confirmsenddate,120)) as confirmsenddate,max(b.toinlocatedate) as toinlocatedate,MAX(b.tfodate) as tfodate,sum(b.thisrtn) as rtnqty
		from rtn_head a(nolock)
		inner join rtn_detail b(nolock) on a.rtn_number=b.rtn_number
		where isnull(a.confirmrtn,0)=1
		group by b.req_serial,b.req_line) d on b.req_serial=d.req_serial and b.req_line=d.req_line
	left join (
		select b.req_serial,b.req_line,min(a.indate) as poindate,min(confirmdate) as poconfirmdate
		from poreq_head a(nolock)
		inner join poreq_detail b(nolock) on a.preq_number=b.preq_number
        group by b.req_serial,b.req_line) f1 on b.req_serial=f1.req_serial and b.req_line=f1.req_line
	left join (
		select b.req_serial,b.req_line,min(a.confirmdate) as revconfirmdate
        from rev_head a(nolock)
		inner join rev_detail b(nolock) on a.rev_number=b.rev_number
        group by b.req_serial,b.req_line) i on b.req_serial=i.req_serial and b.req_line=i.req_line
	left join (
		select b.OrderSerial as req_serial,b.Orderline as req_line,min(b.checkdate) as ysindate,min(c.checkdate) as rkdate
        from MaterialReceivble_Head b(nolock)
		left join MaterialCollect_Head c(nolock) on b.docno=c.recno
        group by b.OrderSerial,b.Orderline) j on b.req_serial=j.req_serial and b.req_line=j.req_line
	left join (
		select b.OrderSerial as req_serial,b.Orderline as req_line,min(a.checkdate) as qacheckdate
        from dsg_checkout_head a(nolock)
		inner join dsg_checkout_detail b(nolock) on a.det_number=b.det_number
		group by b.OrderSerial,b.Orderline) l on b.req_serial=l.req_serial and b.req_line=l.req_line
	left join dsg_deliverytime e(nolock) on b.treeid = e.treeid
	left join dsg_deliverytime f(nolock) on b.goodsperiod=f.item_series
	left join (
		select a.podept,a.podeptdesc,b.item_series,b.item_series_name,b.deliverytime1,b.deliverytime2,b.deliverytime3
		from podept a(nolock)
		inner join dsg_deliverytime b(nolock) on ISNULL(issg,0)=1 and item_series='市购面料') g on a.podept=g.podept
 where 1=1
 )a where 1=1

 drop table #reptemptb
