SELECT
    a.sizegroup,a.styleno,a.styledesc,a.tracknm,a.goodsperiod,a.batchno,a.matioid,a.EstimateDate, b.basesizeuseqty,
    d.purgroup,e.stylecolorid,e.stylecolordesc,e.washedcolorid,e.washedcolordesc,
    b.des3,b.remotematcode,b.remotematname,e.itemcolorid,e.itemcolordesc,b.itemtype,b.msize1 as model,b.fgweight,b.gweight,
    b.unit,a.stylecate_desc,a.remark_xsff, b.des, c.dsgdeptname,c.dsgdeptdesc,a.sc_number,
    a.banxing,s.deptid,s.deptdesc ,m.makedeptdesc, a.verremark, d.base_itemcode,
    b.msize1,b.msize2,b.msize3,b.msize4,b.msize5,b.msize6,b.msize7,b.msize8,b.msize9,b.msize10,
    b.msize11,b.msize12,b.msize13,b.msize14,b.msize15,b.msize16,b.msize17,b.msize18,b.msize19,b.msize20,
    b.psize1,b.psize2,b.psize3,b.psize4,b.psize5,b.psize6,b.psize7,b.psize8,b.psize9,b.psize10,
    b.psize11,b.psize12,b.psize13,b.psize14,b.psize15,b.psize16,b.psize17,b.psize18,b.psize19,b.psize20,
    b.qsize1,b.qsize2,b.qsize3,b.qsize4,b.qsize5,b.qsize6,b.qsize7,b.qsize8,b.qsize9,b.qsize10,
    b.qsize11,b.qsize12,b.qsize13,b.qsize14,b.qsize15,b.qsize16,b.qsize17,b.qsize18,b.qsize19,b.qsize20,
    b.unituseqty,b.element,b.mb_line,a.mbversion,'' as qdremark,'' as cmremark,b.modifydes,d.providerid,d.defprovidercode,
    substring(a.season,3,2) as year,c.series,a.season,substring(a.season,5,4) as jidu,c.styletype,c.sex,
    a.mbtypeid,mbtypename,a.matioid,  a.trackgroupnm,b.item_code,b.item_desc, b.dlqty,
    b.qsize1 as useqty,a.inuser ,a.mb_number,a.dsgdeptconfirmflag,a.confirmflag ,e.modifydes as peiseremark,e.resDocno,
    case when isnull(e.digestionstoreflag,0)=1 then '是' else '否' end as digestionstoreflag,    /*物料来源|消化库存*/
    case when isnull(e.YuliustoreFlag,0)=1 then '是' else '否' end as YuliustoreFlag,            /*物料来源|用预留*/
    case when isnull(e.DinggouFlag,0)=1 then '是' else '否' end as DinggouFlag,                  /*物料来源|需订购*/
    case when isnull(e.PiyinFlag,0)=1 then '是' else '否' end as PiyinFlag,                      /*物料来源|匹印*/
    case when isnull(e.SjstigongFlag,0)=1 then '是' else '否' end as SjstigongFlag,              /*物料来源|设计师提供*/
    case when isnull(e.xianpeiFlag,0)=1 then '是' else '否' end as xianpeiFlag,                  /*物料来源|现胚备布*/
    case when isnull(e.xianhuoFlag,0)=1 then '是' else '否' end as xianhuoFlag,                  /*物料来源|现货备布*/
    case when isnull(e.shigouFlag,0)=1 then '是' else '否' end as shigouFlag,                    /*物料来源|市购*/
    case when isnull(d.costprice,0)>0 then '是' else '否' end as costpriceFlag,        /*是否有成本价*/
    e.psRemark,g.istouban
    ,h.batchID
    ,h.crockID
FROM ban_makebill_head a(nolock)
iNNER JOIN(
    select ISNULL(sc_number,'') as sc_number,max(isnull(mbversion,'')) as mbversion,mbtypeid,ISNULL(xxxfield,'')  as xxxfield
    from ban_makebill_head (nolock)
    group by ISNULL(sc_number,'') ,mbtypeid,ISNULL(xxxfield,'')) a1 on a.sc_number=a1.sc_number and isnull(a.mbversion,'') =a1.mbversion  and a.mbtypeid=a1.mbtypeid  and isnull(a.xxxfield,'')=a1.xxxfield
inner join ban_makebill_itemlist b(nolock) on a.mb_number = b.mb_number
left join ban_makebill_itemcolor e (nolock) on  b.mb_number=e.mb_number and b.mb_line=e.mb_line
LEFT JOIN b_styleno c(nolock) on a.sc_number = c.sc_number
left join b_item d(nolock) on b.item_code=d.item_code
left join b_itemcate f (nolock) on d.treeid=f.treeid
left join s_users s(nolock) on a.trackgroupnmid=s.hruserid
left join MC_dsgdept m(nolock) on a.devdept=m.dsgdeptdesc
LEFT JOIN ban_makebill_goods g on a.mb_number=g.mb_number and g.color_name=e.stylecolorid
left join BanBatchAndCrockID(NOLOCK) h on h.colorID=e.itemcolorid and h.banid=a.matioid and h.MatNo=b.item_code
WHERE 1=1
    AND isnull(e.isassigncolor,0)=1  --是否配色
    AND a.season  like '%2017秋季%'
    AND isnull(a.mbtypeid,'0')='MBT02'
order by styleno  ,e.stylecolorid   ,b.orderid

