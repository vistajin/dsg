USE [dsg_test]
GO

/****** Object:  StoredProcedure [dbo].[spMaterialByBatchID]    Script Date: 09/21/2017 19:48:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



                                  
--20170115 cyueyong 按领料规则重写存储过程                                  
--20170610 Qx_12  不能查特急款资料批次          
          
                                     
alter  PROC [dbo].[spMaterialByBatchID]                                                                                                                                                 
  @BatchID    varchar(50), ---批次                                                                                                                                                
  @LocationID varchar(20), ---仓库区位                                                                                                                                                  
  @OrderNo    varchar(20), ---订单号                                                                                                                                                
  @MatNo      varchar(50), ---物料编号                                                                                                                                                
  @OrderUser  varchar(20), ---订料组                                                                                                                                                
                                            
  @Supplier   varchar(20), ---供应商                                                                                                                                                
  @Season     varchar(20), ---季度                                                                                                                                                
  @Designer   varchar(20), ---设计师                                                                                                                                                
  @TrackUser  varchar(20), ---跟单员                                                                                                                                                
  @Flag       varchar(20), ---上架状态                                                                                                                                                 
                                            
  @mattype    varchar(20), --物料类型                                                                                                                                              
  @isnewmat   varchar(20),   --新旧布                                                                                                                                          
  @colorid    varchar(50),                                                                                                                                        
  @colordesc  varchar(50),                                                                                                                                        
  @matdesc    varchar(100),                                                                                                                                        
                                            
  @loginid    varchar(20),                                                                                                                                      
  @crockid    varchar(30),                                                                                                                                
  @noindocno  varchar(20),                                                                                                                        
  @storeno    varchar(20),                                                                                                                  
  @banid      varchar(50),                                                                                                                
                                            
  @revnumber  varchar(30),                                                                                
  @reqname    varchar(20),    --订购人                                                  
  @tracgpname varchar(20),     --跟单组长                               
  @ipaddress Varchar(20),                                                
  @isImportPDAData VARCHAR(10), --是否导入PDA数据 1：表示导入PDA数据 0：表示不导入PDA数据 by lw 2016.05.28                            
                                            
  @docType VARCHAR(10), --单据类型标记 0:表示开领料单; 1:表示开预留单;                                                     
  @pdaDocNo VARCHAR(50),  --PDA单号，把PDA同一时间点发送的批次认为是同一单据                               
  @styleno  varchar(50),                                    
  @bantype  varchar(20),                                  
  @receivedpt varchar(60)                                     
                                                                                             
as                                                                                                        
                                                                                             
  declare @sql varchar(max),@charenter varchar(5)                                                            
  declare @qx_12 bit                                         
  set @charenter=char(13)+char(10)                                  
  set @qx_12=ISNULL((select isnull(qx_7,0) from s_function where userid=@loginid and funcid='frmStockSendLL_msqDetaild'),0)                             
                                                                                                       
if (@banid is not null) or (@styleno is not null)                                            
begin                                            
      set @sql='Select distinct cast(0 as bit ) as selectflag,                                          
                 a.LocationID,y.item_code MatNo,y.item_desc MatDesc,a.BatchID,a.volumeid,a.Package,                                                                                
          a.avnoresweight Qtyi,                                                                     
          a.Wunit as Qunit,a.storelength stocklength,                                                                    
                           a.storeweight stockweight,                                                  
          a.Wunit,a.conversion,                                                                    
          a.avnoreslength   as  Length,                                                                                
          a.lunit,                                                   
          a.avnoreslength  as usablelength,                                         
          (case when isnull(a.colorid,'''')<>'''' then a.colorid else y.color_name end) colorid,                                          
          (case when isnull(a.colordesc,'''')<>'''' then a.colordesc else y.color_desc end) colordesc,                                                                                
          a.mattype,y.Season,a.reqperson as person,                                                                                
          case when reqd.req_serial is null then a.dsgpoperson else reqd.bantracknm end as dsgpoperson,a.crockid,a.sampleqty,NULL as resno,NULL as resline,a.storeno,                                                                  
          case when reqd.req_serial is null then y.styleno else reqd.styleno end as styleno,case when reqd.req_serial is null then a.banid else reqd.banid end as templetid ,                                                                                
          a.itemtype,                                  
          case when a.storeno in (''B'',''C'') then ''主料'' when a.storeno=''A'' then ''辅料'' else '''' end as itemtype1,                                               
          --y.itemtypedesc,                                                                                
         
          a.OrderNo,a.inoutdate,a.SupplierDesc,a.inLength as YLength,a.inWeight AS YWeight,a.supplierid,a.podeptdesc,a.supply_colorname, a.rev_number,                                                                                
          a.mattypename,a.mattypedesc,                                                        
          case when reqd.req_serial is null then a.banid else reqd.banid end as banid,                                                        
          case when reqd.req_serial is null then a.part else reqd.part end as part,                                                       
          case when reqd.req_serial is null then a.Designer else reqd.dsgdeptname end as Designer,                                                                                                  
          case when reqd.req_serial is null then a.dsgstyle else reqd.dsgstyle end as dsgstyle,                          
                                                                                                         
          reqd.pre_number,reqd.pre_line,reqd.needqty,pre.unit as preunit,                                  
          case when pre.unit<>a.Lunit and pre.unit=''磅'' then (pre.needqty-ISNULL(pre.cancleQty,0)-ISNULL(pre.cancleQty2,0))*a.sampleqty/a.conversion                                  
          else                                   
          (pre.needqty-ISNULL(pre.cancleQty,0)-ISNULL(pre.cancleQty2,0)) end preneedqty,(isnull(c.outlength,0)+ISNULL(d.sendlength,0)) bcklength,                                  
          case when a.storeno in (''B'',''C'') and a.avnoreslength-((case when pre.unit<>a.Lunit and pre.unit=''磅'' then pre.rtnqty*a.sampleqty/a.conversion else pre.rtnqty end)-isnull(c.outlength,0)-ISNULL(d.sendlength,0))>=0 then                   
               ((case when pre.unit<>a.Lunit and pre.unit=''磅'' then pre.rtnqty*a.sampleqty/a.conversion else pre.rtnqty end)-isnull(c.outlength,0)-ISNULL(d.sendlength,0))                  
               when a.storeno in (''B'',''C'') and a.avnoreslength-((case when pre.unit<>a.Lunit and pre.unit=''磅'' then pre.rtnqty*a.sampleqty/a.conversion else pre.rtnqty end)-isnull(c.outlength,0)-ISNULL(d.sendlength,0))<0 then                   
               a.avnoreslength                      
               when a.storeno in (''A'') and a.avnoreslength-(pre.rtnqty-isnull(c.outlength,0)-ISNULL(d.sendlength,0))>=0                        
                    then  pre.rtnqty-isnull(c.outlength,0)-ISNULL(d.sendlength,0)                        
               when a.storeno in (''A'') and a.avnoreslength-(pre.rtnqty-isnull(c.outlength,0)-ISNULL(d.sendlength,0))<0                        
                    then  a.avnoreslength                                   
               else a.avnoreslength  end as prerestqty'                                                        
          IF @isImportPDAData='1'                                        
             set @sql=@sql+',m.pdaid,m.pkey '                                                        
          --else                                           
             --set @sql=@sql+',null,null '                                                        
                                              
          set @sql=@sql+' into #tmpmaterialsend                                  
                        from dsg_bi.dbo.Ban_Material_Needs y                                             
              left join dsg_prelist_detail(nolock) pre on pre.banid=y.matioid and pre.item_code=y.item_code and pre.color_name=y.itemcolorid                                            
              left join req_detaild reqd(nolock) on reqd.pre_number=pre.pre_number and reqd.pre_line=pre.pre_line                          
              left join req_head reqh(nolock) on reqh.req_serial=reqd.req_serial                                            
              left join vm_batchstoreqty a on a.orderserial=reqd.req_serial and a.line=reqd.req_line                                                      
              left join materialtype (nolock) b on a.mattype=b.mattypeid                                                                              
              left join  MaterialLocationInfo (nolock) k  on a.LocationID = k.locationID                                  
     --Left join dsg_prelist_detail(nolock) pre on pre.pre_number=reqd.pre_number and pre.pre_line=reqd.pre_line                                  
              left join (Select c.pre_number,c.pre_line,SUM(a.length) as outlength from MaterialOut_Detail a                                  
         left join MaterialOut_Head b on b.DocNo=a.DocNo                                  
         left join MaterialSend_DetailD c on c.DocNo=b.SendNo and c.BatchID=a.BatchID                                   
         where c.resno is null     
         ' if @MatNo is not null set @sql=@sql+                                                                                            
           '  and a.MatNo  like '+@MatNo+@charenter     
           if @colorid is not null set @sql=@sql+'  and a.colorid  like '+@colorid+@charenter 
            set @sql=@sql+'                                  
         group by c.pre_number,c.pre_line                                  
        ) c on c.pre_number=reqd.pre_number and c.pre_line=reqd.pre_line    --已出库                                  
      left join (Select a.pre_number,a.pre_line,SUM(length) as sendlength                                   
          from MaterialSend_DetailD a            
         inner join MaterialSend_head c on c.docno=a.docno                            
         left join MaterialOut_Head b on b.SendNo=a.DocNo                                   
         where a.resno is null and b.DocNo is null    
               and c.indate>=getdate()-15                                     
         group by a.pre_number,a.pre_line                                  
        ) d on d.pre_number=reqd.pre_number and d.pre_line=reqd.pre_line  --未出库                                   
              '+@charenter                                  
                                                        
              IF @isImportPDAData='1'                                                        
              begin                                                        
                 set @sql=@sql+' INNER JOIN (SELECT batchid,pdaid,pkey FROM dbo.pdadsgclothsendll_res (NOLOCK)                       
                      WHERE userid='''+@loginid+''''+' AND isend=''0'' AND docType='''+@docType+'''' +' AND datediff(day,worktime,GETDATE())<7 '+@charenter                          
                                                                              
      IF @pdaDocNo IS NOT NULL                                                             
      BEGIN                                                            
       SET @sql = @sql + ' and pkey like ' + @pdadocno + @charenter                                                                
      END                                                                 
                 SET @sql = @sql + ' ) m ON a.batchid=m.batchid ' + @charenter                                                        
             end                                                                            
          SET @sql = @sql + 'where 1=1 and (k.lockflag is null or k.lockflag  <> ''1'') '+@charenter                           
          if @qx_12=1                                             
             SET @sql = @sql +' and isnull(reqh.tjkflag,0)=0 '                          
                                          
         if @bantype is not null                                     
            set @sql=@sql+'  and y.bantype like '+@bantype+@charenter                                     
         else                                    
            set @sql=@sql+'  and y.bantype=''齐色'' '+@charenter                                    
                                                
                                                            
         if @banid is not null set @sql=@sql+'  and y.matioid like '+@banid+@charenter                                             
         if @styleno is not null set @sql=@sql+'  and y.styleno like '+@styleno+@charenter                                                 
end                                            
else                                        
begin                                                                       
    set @sql='Select cast(0 as bit ) as selectflag,a.LocationID,a.MatNo,a.MatDesc,a.BatchID,a.volumeid,a.Package,                                                                                
          a.avnoresweight Qtyi,                                                                                
          a.Wunit as Qunit,a.storelength stocklength,--库存数量                                          
                           a.storeweight stockweight,                                                                                
          a.Wunit,a.conversion,                        
          a.avnoreslength   as  Length,                                                                                
          a.Lunit,                                                                    
          a.avnoreslength  as usablelength,--实际可用                                                                       
          a.ColorID,a.ColorDesc, a.mattype,a.Season,a.reqperson as person,                                                                                
          case when reqd.req_serial is null then a.dsgpoperson else reqd.bantracknm end as dsgpoperson,a.crockid,a.sampleqty,NULL as resno,NULL as resline,a.storeno,                                                                                
          case when reqd.req_serial is null then a.styleno else reqd.styleno end as styleno,case when reqd.req_serial is null then a.banid else reqd.banid end as templetid ,                                                                                
          a.itemtype,                                              
          case when a.storeno in (''B'',''C'') then ''主料'' when a.storeno=''A'' then ''辅料'' else '''' end as itemtype1,                                                                                
                                                                                          
          a.OrderNo,a.inoutdate,a.SupplierDesc,a.inLength as YLength,a.inWeight AS YWeight,a.supplierid,a.podeptdesc,a.supply_colorname, a.rev_number,                                                                                
          a.mattypename,a.mattypedesc,                                                        
          case when reqd.req_serial is null then a.banid else reqd.banid end as banid,                                                                                                                   
          case when reqd.req_serial is null then a.part else reqd.part end as part,                                                                                                  
          case when reqd.req_serial is null then a.Designer else reqd.dsgdeptname end as Designer,                                                                                                  
          case when reqd.req_serial is null then a.dsgstyle else reqd.dsgstyle end as dsgstyle,                                                                          
                                                                                                   
          reqd.pre_number,reqd.pre_line,pre.unit as preunit,'                                  
         if @receivedpt='订购'                                  
            set @sql=@sql+' case when pre.unit<>a.Lunit and pre.unit=''磅'' then (pre.needqty+reqd.qtyotherorder-ISNULL(pre.cancleQty,0)-ISNULL(pre.cancleQty2,0))*a.sampleqty/a.conversion                                  
                         else                                   
                         (pre.needqty+reqd.qtyotherorder-ISNULL(pre.cancleQty,0)-ISNULL(pre.cancleQty2,0)) end preneedqty,'                       
         else                                    
            set @sql=@sql+' case when pre.unit<>a.Lunit and pre.unit=''磅'' then (pre.needqty-ISNULL(pre.cancleQty,0)-ISNULL(pre.cancleQty2,0))*a.sampleqty/a.conversion                                  
                         else                                   
                         (pre.needqty-ISNULL(pre.cancleQty,0)-ISNULL(pre.cancleQty2,0)) end preneedqty,'                                  
          set @sql=@sql+'(isnull(c.outlength,0)+ISNULL(d.sendlength,0)) bcklength,                                  
          case when a.storeno in (''B'',''C'') and a.avnoreslength-((case when pre.unit<>a.Lunit and pre.unit=''磅'' then pre.rtnqty*a.sampleqty/a.conversion                                  
    else pre.rtnqty end)-isnull(c.outlength,0)-ISNULL(d.sendlength,0))>=0                               
                    then ((case when pre.unit<>a.Lunit and pre.unit=''磅'' then pre.rtnqty*a.sampleqty/a.conversion                                  
else pre.rtnqty end)-isnull(c.outlength,0)-ISNULL(d.sendlength,0))                                  
               when a.storeno in (''B'',''C'') and a.avnoreslength-((case when pre.unit<>a.Lunit and pre.unit=''磅'' then pre.rtnqty*a.sampleqty/a.conversion                                  
                  else pre.rtnqty end)-isnull(c.outlength,0)-ISNULL(d.sendlength,0))<0 then a.avnoreslength                        
               when a.storeno in (''A'') and a.avnoreslength-(pre.rtnqty-isnull(c.outlength,0)-ISNULL(d.sendlength,0))>=0                        
                    then  pre.rtnqty-isnull(c.outlength,0)-ISNULL(d.sendlength,0)              
               when a.storeno in (''A'') and a.avnoreslength-(pre.rtnqty-isnull(c.outlength,0)-ISNULL(d.sendlength,0))<0                        
                    then  a.avnoreslength                                  
               else a.avnoreslength  end as prerestqty '                                                       
    IF @isImportPDAData='1'                                                        
    set @sql=@sql+',m.pdaid,m.pkey '                                            
    --else                                                        
    --set @sql=@sql+','''', '                                                        
                                                                            
        set @sql=@sql+'  into #tmpmaterialsend                                   
                         from vm_batchstoreqty a                                                                      
         left join materialtype (nolock) b on a.mattype=b.mattypeid                                                                    
         left join req_detaild reqd(nolock) on a.orderserial=reqd.req_serial and a.line=reqd.req_line                          
         left join req_head reqh(nolock) on reqh.req_serial=reqd.req_serial                                                                                    
         left join  MaterialLocationInfo (nolock) k  on a.LocationID = k.locationID                                  
         Left join dsg_prelist_detail(nolock) pre on pre.pre_number=reqd.pre_number and pre.pre_line=reqd.pre_line                                   
         left join (Select c.pre_number,c.pre_line,SUM(a.length) as outlength from MaterialOut_Detail a                                  
            left join MaterialOut_Head b on b.DocNo=a.DocNo                                  
            left join MaterialSend_DetailD c on c.DocNo=b.SendNo and c.BatchID=a.BatchID                                   
            where c.resno is null and b.SendNo not like ''BCK%'' and c.pre_number is not null ' 
            if @MatNo is not null set @sql=@sql+' and a.MatNo like '+@MatNo+@charenter  
            if @colorid is not null set @sql=@sql+' and a.colorid like '+@colorid+@charenter  
            --------------------------------------Add filter in subselect----------------------------------------    
            if @BatchID is not null set @sql=@sql+ ' and a.BatchID like '+@BatchID+@charenter      
			if @LocationID is not null set @sql=@sql+ ' and a.LocationID like '+@LocationID+@charenter  
            if @docType='1' set @sql=@sql+' AND a.LocationID <>''BA666666'''+@charenter
            IF @docType <> '1' AND @loginid NOT IN ( 'BF0011', 'BF1854', 'BF0625', 'BF0014', 'BF0632',                                                  
                          'BF0667', 'BF0028', 'BF0025', 'BF1683', 'BF0012',                                
                          'BF1255', 'BF0030', 'BF0043', 'BF0675', 'BF0609',                                                  
                          'BF1287', 'BF0006', 'BF0013', 'BF0020', 'BF1781',                                                  
                          'BF1896', 'BF1921','SA' )
				SET @sql = @sql + ' AND a.LocationID <>''BA666666''' + @charenter
			if @Season is not null set @sql=@sql+' and a.Season  like '+@Season+@charenter
            if @colordesc is not null set @sql=@sql+ ' and a.colodesc like '+@colordesc+@charenter 
            if @matdesc is not null set @sql=@sql+' and a.matdesc like '+@matdesc+@charenter
            if @Flag=1 set @sql=@sql+'  and isnull(a.locationid,'''')<>'''''+@charenter
			if @Flag=2 set @sql=@sql+'  and isnull(a.locationid,'''')='''''+@charenter
			--if @storeno is not null set @sql=@sql+'  and a.storeno= '+@storeno+@charenter
            ------------------------------------End add filter in subselect--------------------------------------    
            set @sql=@sql+'                                  
            group by c.pre_number,c.pre_line                                  
             ) c on c.pre_number=reqd.pre_number and c.pre_line=reqd.pre_line    --已出库                                  
         left join (Select a.pre_number,a.pre_line,SUM(length) as sendlength                                   
                    from MaterialSend_DetailD a            
                    inner join MaterialSend_head c on c.docno=a.docno                                   
                    left join MaterialOut_Head b on b.SendNo=a.DocNo                                   
                    where c.indate>=getdate()-15 and a.resno is null and b.DocNo is null and a.docno like ''SED%'' and a.pre_number is not null                                                         
                     group by a.pre_number,a.pre_line                                  
                    ) d on d.pre_number=reqd.pre_number and d.pre_line=reqd.pre_line  --未出库                                   
                        '+@charenter                                                        
    IF @isImportPDAData='1'                                                        
    begin                                                        
    set @sql=@sql+' INNER JOIN (SELECT batchid,pdaid,pkey FROM dbo.pdadsgclothsendll_res (NOLOCK)                                                        
      WHERE userid='''+@loginid+''''+' AND isend=''0'' AND docType='''+@docType+'''' +' AND datediff(day,worktime,GETDATE())<7 '+@charenter                                                        
    IF @pdaDocNo IS NOT NULL                                                          
    BEGIN                                                            
    SET @sql = @sql + ' and pkey like ' + @pdadocno + @charenter                                                    
    END                                                                 
    SET @sql = @sql + ' ) m ON a.batchid=m.batchid ' + @charenter                                                        
   end                                                    
                                                                                                             
   SET @sql = @sql + 'where 1=1 and a.storelength>0 and a.storeweight>0 and a.avnoreslength >0 and a.avnoresweight>0                                                                                      
      and (k.lockflag is null or k.lockflag  <> ''1'') '+@charenter                          
   if @qx_12=1                                             
      SET @sql = @sql +' and isnull(reqh.tjkflag,0)=0 '                                                                
end                                            
                                            
                                                                                                                                                                                                                   
  if @BatchID is not null set @sql=@sql+                     
           '  and a.BatchID  like '+@BatchID+@charenter      
  if @LocationID is not null set @sql=@sql+                                                                                                                                                      
           '  and a.LocationID like '+@LocationID+@charenter                                                       
  if @docType='1'  set @sql=@sql+ --by lw 2016.06.27 增加，如果是开预留单，排除此货架                                                    
           '  AND a.LocationID <>''BA666666'''+@charenter                                                    
                                                    
  IF @docType <> '1'--by lw 2016.07.07 增加，如果是开领料单和退料出库单，只有以下用户可以开单                                  
    AND @loginid NOT IN ( 'BF0011', 'BF1854', 'BF0625', 'BF0014', 'BF0632',                                                  
                          'BF0667', 'BF0028', 'BF0025', 'BF1683', 'BF0012',                                
                          'BF1255', 'BF0030', 'BF0043', 'BF0675', 'BF0609',                                                  
                          'BF1287', 'BF0006', 'BF0013', 'BF0020', 'BF1781',                                                  
                          'BF1896', 'BF1921','SA' )                                                   
    SET @sql = @sql + '  AND a.LocationID <>''BA666666''' + @charenter                                                   
                                                                                                                                               
  if @MatNo is not null set @sql=@sql+                                                                                              
           '  and a.MatNo  like '+@MatNo+@charenter                                                    
                                             
  if @OrderNo is not null set @sql=@sql+                                                                                                                                                      
           '  and a.OrderNo like '+@OrderNo+@charenter                                                                                                                   
                                  
  if @OrderUser is not null set @sql=@sql+                                                                                                                                   
           '  and a.reqperson like '+@OrderUser+@charenter                                                                                                                                                  
                                                                                                      
  if @Supplier is not null set @sql=@sql+                                                                                                                                                      
           '  and a.SupplierID like '+@Supplier+@charenter                                                                                                                                      
                                                                                                                                        
  if @Season is not null set @sql=@sql+                               
           '  and a.Season  like '+@Season+@charenter                                                                                         
                                                                                                                                        
  if @Designer is not null set @sql=@sql+                                                                                                              
        '  and ( reqd.dsgdeptname like '+@Designer+' or a.Designer like '+@Designer+')'+ @charenter                                                                                                  
                                                                                                                                        
  if @TrackUser is not null set @sql=@sql+                                                                                                                                                      
           '  and (reqd.bantracknm like '+@TrackUser+' or a.dsgpoperson like '+@TrackUser+')'+ @charenter                                                                                                                                                     
 
                                                                                                                              
  if @colorid is not null set @sql=@sql+                                                                                                                                                      
           '  and a.colorid = '+ replace(@colorid,'%','')+@charenter                                                                      
                                                                                                                                        
 if @colordesc is not null set @sql=@sql+                                                                                                                                                      
           '  and a.colordesc like '+@colordesc+@charenter                                                              
  if @matdesc is not null set @sql=@sql+                                              
           '  and a.matdesc like '+@matdesc+@charenter                                                                                                                                        
                                                                
                                      
  if @Flag=1 set @sql=@sql+                                                                                                     
           '  and isnull(a.locationid,'''')<>'''''+@charenter                                                                                               
                                                                                                                                        
if @Flag=2 set @sql=@sql+                                                                    
           '  and isnull(a.locationid,'''')='''''+@charenter                                                                              
                                                                                                                                        
 if @isnewmat=1 set @sql=@sql+                                                                               
           '  and isnull(a.isoldmat,0)>0'+@charenter                                                                                                 
  if @isnewmat=2 set @sql=@sql+                                                                                                
           '  and isnull(a.isoldmat,0)=0'+@charenter                                                                                                    
                                                                                                               
  if @mattype is not null set @sql=@sql+                                                    
    '  and a.mattype like '+@mattype+@charenter                                  
                                                                                            
    if @crockid is not null set @sql=@sql+                                                                                                                                                      
           '  and isnull(a.crockid,'''') like '+@crockid+@charenter                                                                                                
                                                                                                                                          
    if @storeno is not null set @sql=@sql+                                              
           '  and a.storeno= '+@storeno+@charenter                                                        
                                                                                     
    if @revnumber is not null set @sql=@sql+                                                                                                                                                      
           '  and a.rev_number =  '+@revnumber+@charenter                                                                                    
                                                                                           
  if @reqname is not null set @sql=@sql+                                                                                                                                                      
       '  and (reqd.reqperson like '+@reqname + ')'+ @charenter                                                                                   
                                                               
  if @tracgpname is not null set @sql=@sql+                                                                                                                                                      
           '  and (reqd.rptgroupnm like '+@tracgpname + ')'+ @charenter                                                                                  
          
    
  
  
  
  
  
  
  
  
  
  
                                                                       
  set @sql=@sql+' select * from #tmpmaterialsend '                                   
  --select @sql                                                                     
exec(@sql) 


GO
