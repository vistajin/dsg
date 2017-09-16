SELECT       
           cast(0 as bit) as selectflag, a.pre_number,isnull(a.season,'') as season,a.reqdept,a.reqdeptdesc,    
     a.publicitemcheckflag,a.publicitemcheckdate,a.publicitemcheckuser, a.fadcheckflag,a.fadcheckdate,    
     a.fadcheckuser,    
     b.pre_line,b.dsgstyle,b.needqty,b.digestionstoreflag,b.digestionstockflag,b.isbefflag,b.base_itemcode,    
     b.item_code,b.item_desc,isnull(b.model,'') as model,isnull(b.color_name,'')as color_name,    
     isnull(b.color_desc,'') as color_desc,b.unit,b.weight,b.element,b.dsgdeptname,b.dsgdeptdesc,     
     b.dsgnamecode,b.dsgname,b.bantracknm as dsgpoperson,b.goodsperiod,b.banid,b.styleno,    
     b.ProviderID as nowsupply_desc,b.styledesc,b.bantracknm,b.rptgroupnm,b.qtymiss,b.qtyother,b.mattype,    
     b.item_codetype,b.batch , b.part,b.provcode,b.productarea,b.item_series as item_series ,    
     b.purchasergroup as purchasergroup,b.ybbflag,    
     isnull(b.reqremark,'') +'||'+isnull(b.remark,'')  as remark,    
     isnull(supply_colorname,'') as supply_colorname,isnull(supply_colordesc,'') as supply_colordesc,    
     isnull(qtyotherorder,0) as qtyotherorder,isorderluseflag,      
         
     d.remotematcode,d.isreqnosumflag,d.treeID,
     b.cancleQty,b.cancleQty2    
            
    INTO #tmpprelist                                                                                  
    FROM dsg_prelist_head a(nolock) inner join                                                                     
      dsg_prelist_detail b(nolock) on a.pre_number=b.pre_number left join                                                                        
    
      b_item d(nolock) on b.item_code=d.item_code left join                                                                       
      b_itemcate e(nolock) on d.treeID=e.treeid                                                                         
                       
    WHERE a.confirmflag=1 and a.bossflag=1 and b.reqjcomfirmflag=1     
   AND isnull(b.cancelflag,0)=0 and isnull(b.completeflag,0)=0      
   AND (((a.reqdept='ZHDGB' or b.dsgdeptname='ZHDGB') AND     
       a.publicitemcheckflag=1 and a.fadcheckflag=1)       
      or (a.reqdept<>'ZHDGB' and b.dsgdeptname<>'ZHDGB')       
    )       
   AND isnull(b.reqtcomfirmflag,0)=0  AND b.reqpconfirmflag=1     
   AND isnull(b.digestionstoreflag,0)=0 AND isnull(b.digestionstockflag,0)=0     
   AND isnull(b.YuliustoreFlag,0)=0     
 --  AND (isnull(b.gdcancleflag,0)=0  or  isnull(b.gdcanclecheckflag,0)=0 )     
       
  
   and a.season like '2018夏季'   and b.mattype='辅料'   and e.seriestype like '织带类'    
    SELECT a.*,    
     isnull(c1.yfpqty,0) yfpqty,    
     (a.needqty)-(isnull(c1.yfpqty,0))-(isnull(a.cancleQty,0))-(isnull(a.cancleQty2,0)) as kfpqty,    
     (a.needqty)-(isnull(c1.yfpqty,0))-(isnull(a.cancleQty,0))-(isnull(a.cancleQty2,0)) as fpqty,                                 
     cast(case when f.season is null then 0 else 1 end as bit) isorderl,                    
     g.synflag    
    INTO #tmp        
    FROM #tmpprelist a LEFT JOIN                                   
              
     (select  pre_number,pre_line ,sum(fpqty)as yfpqty      
    from req_detaild b(nolock)     
      group by b.pre_number,b.pre_line     
     )c1 on (a.pre_number=c1.pre_number and a.pre_line=c1.pre_line) left join    
                                  
     (select distinct a.season,b.item_code                                   
      from dsg_prelist_head a(nolock) inner join                                   
       dsg_prelist_detail b(nolock) on a.pre_number=b.pre_number                                    
      where (b.isorderluseflag=1 or b.qtyotherorder>0)  and isnull(b.cancelflag,0)=0                                
     ) f on a.season=f.season and a.item_code=f.item_code LEFT JOIN             
                
     (select *             
      from b_item_color(nolock)            
      where synflag=1            
     ) g on g.item_code=a.item_code and g.color_name=a.color_name and g.color_desc=a.color_desc    
       WHERE (a.needqty)-(isnull(c1.yfpqty,0))-(isnull(a.cancleQty,0))-(isnull(a.cancleQty2,0))>0                    
    

 select * from #tmp order by pre_number,pre_line 
     
         drop table #tmpprelist     
         drop table #tmp 
