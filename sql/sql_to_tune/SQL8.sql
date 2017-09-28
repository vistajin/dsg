SELECT
    DISTINCT a.season,a.bossdate,                              
    case when  isnull(a.buliaoflag,0)=1 then'补料'                                 
         when  isnull(a.loudingflag,0)=1 then '漏订'                                   
         when  isnull(a.chongdingflag,0)=1 then '重订'                                 
         when  isnull(a.beiliaoflag,0)=1 then '备料'                                   
         when isnull(a.dabanflag,0)=1 then '打板'                                 
         when isnull(a.noscflag,0)=1  then '非生产物料'                                        
         when isnull(a.daiyongflag,0)=1 then '头板代用'                                 
         when isnull(a.isdlflag,0)=1 then '正常订料'end as dltype,                                
    b.pre_number,b.pre_line,b.mattype,b.dsgstyle,b.banid,b.styleno,b.isbefflag,                              
    b.item_code, b.item_desc,b.color_name,b.color_desc,b.model,b.weight,b.element,b.unit,b.part,                              
    b.dsgdeptname,b.dsgdeptdesc,b.dsgnamecode,b.dsgname,b.isstoreflag,b.isstoredate,b.isstoreuser,b.yldocremark,
    b.batch,b.bantracknm,b.rptgroupnm,b.reqjcomfirmdatetime,c.needqty,c.fpqty,c.rtnqty,                             
    isnull(c.cancleQty,0)  as cancleQty, c.applycancelflag,c.applycanceluser,c.applycanceldate,            
    c.cancelconfirmflag,c.cancelconfirmuser,c.cancelconfirmdate,            
    isnull(c.cancleQty2,0) as cancleQty2,c.applycancelflag2,c.applycanceluser2,c.applycanceldate2,            
    c.cancelconfirmflag2,c.cancelconfirmuser2,c.cancelconfirmdate2,d.req_serial, 
    d.req_line,d.poprice,d.dahuoprice,d.jjprice,d.minoyearprice,d.minoyearcacprice,d.needqty as sumneedqty,                               
    d.nowsupply_code ,d.nowsupply_desc,d.supply_code,d.supply_desc,d.supply_colorname,d.supply_colordesc,
    d.completeflag,d.indatedetail,d.dporevdate,d.reqdate,       
    d.podate_0,d.podate_user0,d.podate_date0,                                         
    d.podate_1,d.podate_user1,d.podate_date1,                                
    d.podate_2,d.podate_user2,d.podate_date2,                                
    d.podate_3,d.podate_user3,d.podate_date3,                                    
    d.podate_4,d.podate_user4,d.podate_date4,                                
    d.podate_5,d.podate_user5,d.podate_date5,                                
    d.podate_6,d.podate_user6,d.podate_date6,
    e.req_number,e.reqdept,e.reqdeptdesc,e.podept,e.podeptdesc,e.reqperson,e.revperson,e.indate,
    DATEDIFF(day,b.reqjcomfirmdatetime,d.indatedetail) as reqjuseday,                                
    DATEDIFF(day,b.reqjcomfirmdatetime,isnull(d.indatedetail,getdate()))-2 as reqjuseoverday,
    DATEDIFF(day,d.indatedetail,d.dporevdate)  as reqtopojday,
    g.remotematcode,h.seriestype,p.makedeptdesc                               
INTO #tmppretoreq                                   
FROM dsg_prelist_head a(nolock)
inner join dsg_prelist_detail b on (a.pre_number=b.pre_number)
left join req_detaild c(nolock) on b.pre_number=c.pre_number and b.pre_line=c.pre_line
left join req_detail d(nolock) on c.req_serial=d.req_serial and c.req_line=d.req_line
left join req_head e (nolock) on c.req_serial=e.req_serial
left join b_item g(nolock) on b.item_code=g.item_code 
left join b_itemcate h(nolock) on g.treeID=h.treeID 
left join(
    select distinct banid,styleno,makedeptdesc 
    from b_styleno                                
      )p on b.banid=p.banid 
left join(
    select b.OrderSerial as req_serial,b.Orderline as req_line,min(c.checkdate) as rkdate                             
    from MaterialReceivble_Head b(nolock ) 
    left join MaterialCollect_Head c(nolock) on b.docno=c.recno                                                      
    group by b.OrderSerial,b.Orderline) j on d.req_serial=j.req_serial and d.req_line=j.req_line                                                                   
WHERE 1=1                                 
    and a.season = '2017冬季'
    and isnull(g.itemtype,'')='01'
    and e.reqdept in (select reqdept from reqrange where userid='SA') 
    and e.podept in (select podept from porange where userid='SA')                                                     

select 
    a1.*,f.poindate,f.poconfirmdate,f.podate,
    /* 根据订购单对应的物料申请单是否有回货数量，显示回货确认日期、收货日期、板房收货确认、预收日期、入库日期 */
    CASE WHEN ISNULL(a1.rtnqty,0)>0 THEN i.revconfirmdate ELSE NULL END AS revconfirmdate,                               
    CASE WHEN ISNULL(a1.rtnqty,0)>0 THEN k.rtndate ELSE NULL END AS rtndate,                              
    CASE WHEN ISNULL(a1.rtnqty,0)>0 THEN k.confirmsenddate ELSE NULL END AS confirmsenddate,                               
    CASE WHEN ISNULL(a1.rtnqty,0)>0 THEN j.ysindate ELSE NULL END AS ysindate,                              
    CASE WHEN ISNULL(a1.rtnqty,0)>0 THEN j.rkdate ELSE NULL END AS rkdate ,
    DATEDIFF(day,a1.dporevdate,f.poconfirmdate)   as pouseday,                                                    
    DATEDIFF(day,f.poconfirmdate,i.revconfirmdate)as  potosuprevday,                                
    DATEDIFF(day,f.poconfirmdate,isnull(i.revconfirmdate,getdate()))-2 as potosuprevoverday,
    DATEDIFF(day,i.revconfirmdate,j.ysindate)  as revtowlcday,                                
    DATEDIFF(day,j.ysindate ,j.rkdate) as ystorkday ,                                  
    l.prellqty  ,z.banllqty ,a1.makedeptdesc ,o.unqualified, o.result,
    Cast(case when ISNULL(applycancelflag,0)<>1 AND DateDiff(hh,a1.reqdate,ISNULL(i.revconfirmdate,'1900-01-01'))<=0 then 1 else 0 end as Bit) as cycletimeOK,                
    Cast(case when ISNULL(applycancelflag,0)<>1 AND DateDiff(hh,a1.reqdate,ISNULL(i.revconfirmdate,'1900-01-01'))>0 then 1 else 0 end as Bit) as cycletimeNotOK                                                                                            
from #tmppretoreq a1                                 
left join(/* 采购单|开单日期、确认日期(F)、供应商复期 */                                                  
    select b.req_serial,b.req_line,min(a.indate) as poindate,min(confirmdate) as poconfirmdate ,min(podate) as podate
    from poreq_head a(nolock)                                 
    inner join poreq_detail b(nolock) on a.preq_number=b.preq_number                                                      
    group by b.req_serial,b.req_line) f on a1.req_serial=f.req_serial and a1.req_line=f.req_line
left join(/* 回货单|回货确认日期(G)*/                                                 
    select b.req_serial,b.req_line,min(a.confirmdate) as revconfirmdate
    from rev_head a(nolock)
    inner join rev_detail b(nolock) on a.rev_number=b.rev_number
    group by b.req_serial,b.req_line) i on a1.req_serial=i.req_serial and a1.req_line=i.req_line                                  
left join(      /* 收货单|收货日期(I)、板房收货确认 */                                   
    select b.req_serial,b.req_line,min(a.rtndate) as rtndate ,min(confirmsenddate) as confirmsenddate
    from rtn_head a(nolock)                                 
    inner join rtn_detail b(nolock) on a.rtn_number=b.rtn_number                                                      
    group by b.req_serial,b.req_line ) k on a1.req_serial=k.req_serial and a1.req_line=k.req_line                                 
left join(      /* 预收单|预收日期(H)、入库单|入库日期(J)*/                                                 
    select b.OrderSerial as req_serial,b.Orderline as req_line,min(b.checkdate) as ysindate,min(c.checkdate) as rkdate
    from  MaterialReceivble_Head b(nolock)                                 
    left join  MaterialCollect_Head c(nolock) on b.docno=c.recno                                        
    group by b.OrderSerial,b.Orderline) j on a1.req_serial=j.req_serial and a1.req_line=j.req_line                                 
left join(      /* 数量|领用数量(按申请) */                                                 
    select SUM(Length) as prellqty,pre_number,pre_line                                                                               
    from  MaterialSend_DetailD b(nolock)                                                    
    group by b.pre_number,b.pre_line) l on a1.pre_number=l.pre_number and a1.pre_line=l.pre_line                                 
left join(      /* 数量|领用数量(按板单) */                                                 
    select SUM(Length) as banllqty,matno,colorid,colordesc,styleno
    from  MaterialSend_DetailD b(nolock)                                                    
    group by matno,colorid,colordesc,styleno) z on a1.item_code=z.matno and a1.color_name=z.colorid and a1.color_desc=z.colordesc and ( a1.banid=z.styleno)                  
     /*left join dsg_checkout_detail o ON o.orderserial=a1.req_serial and o.orderline=a1.req_line  */                              
left join( /*QA检验合格、不合格*/                              
     /*select orderserial,orderline,unqualified,result,MAX(a.checkdate) as checkdate                              
      from dsg_checkout_detail b(nolock)                               
      Inner join dsg_checkout_head a(nolock) on a.det_number=b.det_number                              
      group by orderserial,orderline,unqualified,result --20170711 cyueyong*/    
    select b.orderserial,b.orderline,unqualified,result,a.checkdate                              
    from dsg_checkout_detail b(nolock)                               
    Inner join dsg_checkout_head a(nolock) on a.det_number=b.det_number    
    inner join(    
        select orderserial,orderline,MAX(a.checkdate) as checkdate                              
        from dsg_checkout_detail b(nolock)                               
        Inner join dsg_checkout_head a(nolock) on a.det_number=b.det_number                             
        group by orderserial,orderline) c on c.orderserial=b.orderserial and c.orderline=b.orderline    
    where a.checkdate=c.checkdate)o n o.orderserial=a1.req_serial and o.orderline=a1.req_line                                 
            
where 1=1 
        
drop table #tmppretor