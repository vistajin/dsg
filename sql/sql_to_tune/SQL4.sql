SELECT
    distinct cast(c.isoldmat as bit) isoldmat,
    a.remark as senddetailremark,a.docno,a.line,a.dline,a.barcodeno,a.locationid,a.matno,
    a.batchid,a.volumeid,a.package,a.qtyi,a.qunit, a.sampleqty,
    a.wunit,a.conversion,a.lunit ,a.length sqlength,a.resno,a.resline,
    a.templetid, a.styleno,a.pre_number,a.pre_line,
    case when (a.conversion>0) then mm.weight/a.conversion*a.sampleqty else 0 end as sflength,
    --case when (a.conversion>0 AND a.storeno<>'A' ) then mm.weight/a.conversion*a.sampleqty else a.length end as sflength,
    b.MocType,b.SendDate,b.ReceiveDpt,b.makedeptdesc,b.usetype,b.SendUser,b.inuser,
    b.checkuser,b.checkdate,b.storecheckdate,b.confirmPrintCnt  printcount ,
    b.branchid,b.remark AS remarkm,
    isnull(b.tobldate, a.tobldate)  tobldate,
    isnull(b.bluserid , a.bluserid ) bluserid,
    isnull(b.blusername, a.blusername ) blusername,
    b.tojjdate tojjdate,  b.jjusername  jjusername, b.jjuserid,
    b.confirmPrintDate printdate, b.confirmPrintUser  printuser,
    b.isTempMatFlag,b.factory_desc,
    c.dsgpoperson,c.StoreNo,c.matDesc,c.poprice,c.colorid,c.colordesc,c.season,
    c.mattype,c.crockid,C.orderno,c.banid ,c.styleno as oldstyleno, c.dsgstyle,
    d.mattypename,d.mattypedesc,
    case  when e.checkdate='1900-01-01 00:00:00.000'  then null else e.CheckDate end    as outdate ,
    e.moctype as outmoctype,e.checkflag, e.pdauserid,e.docno as outno,
    e.factorycheckflag,e.factorycheckdate,e.factorycheckuser,
    f.length storelength,f.weight storeweight,
    case when f.Length-ISNULL(y.length,0)<0 then 0 else f.Length-ISNULL(y.length,0) end as avlength,
    case when f.weight-ISNULL(y.qtyi,0)<0 then 0 else f.weight-ISNULL(y.qtyi,0) end  as avweight ,
    h.username,q.username as checkname,mm.weight weight,w.username as pdausername,
    res.Senddate as yldate,res.senduser as yluser,
    cast((case when res.docno is null  then 1 else 0 end   ) as bit) as isusestoreflag,
    yy.username as  storecheckuser ,
    (Case when isnull(mc.length,0)>0 then mc.length else mr.length end) as inlength,
    (Case when isnull(mc.weight,0)>0 then mc.weight else mr.weight end) as inweight,
    mh.OrderTjkRemark,mh.checkdate as storeindate
FROM MaterialSend_DetailD a (nolock)
inner join MaterialSend_head (nolock) b on a.DocNo=b.DocNo
left join MaterialSend_Detail (nolock) g on a.DocNo=g.DocNo and a.line=g.line
left join MaterialOut_Head (nolock) e on b.docno=e.sendno
left join MaterialOut_Detail mm on e.docno=mm.docno and a.batchid=mm.batchid
left join materialbatchinfo c(NOLOCK) on a.batchid=c.batchid
left join MaterialstoreQty (nolock) f on a.batchid=f.batchid
left join(
    SELECT resh.docno,resh.Senddate,resh.senduser,resh.ReceiveDpt,resd.dline
    FROM MaterialSend_head (nolock) resh
    LEFT JOIN MaterialSend_DetailD (nolock) resd ON resh.docno=resd.docno) res on res.docno=a.resno and res.dline=a.resline
left join (
    select c.batchid,sum(c.length) as length,sum(c.qtyi) as qtyi
    from MaterialSend_DetailD (nolock) c
    left join MaterialSend_Head (nolock) d on c.docno=d.docno
    left join materialout_head (nolock) e on d.DocNo=e.SendNo
    where d.checkflag=1 and d.DocNo not like 'RES%' and e.DocNo is null and c.resno is null
    group by c.batchid) y on y.batchid=a.batchid
left join s_users (nolock) h on h.userid=b.inuser
left join s_users (nolock) w on w.userid=e.pdauserid
left join s_users (nolock) q on q.userid=b.checkuser
left join s_users(nolock) yy on yy.userid=b.storecheckuser
left join materialtype (nolock) d on c.mattype=d.mattypeid
left join MaterialCollect_detail  mc (nolock) on a.batchid=mc.batchid
left join MaterialCollect_head mh (nolock) on mc.docno=mh.docno
Left join MaterialReturnStore_Detail(nolock) mr on mr.newbatchid=a.batchid
Left join MaterialBeiLiao mbl on mbl.sendno=a.docno
where 1=1 and
    a.DocNo not like 'RES%'
    and b.sendDate>='2017-05-01 00:00:00'
    and b.SendDate<='2017-08-25 08:51:23'
    and b.DocNo like '%BCK%'
Order by b.senddate,a.docno,a.dline
