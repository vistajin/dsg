                                                                
--20170920 cyueyong 按领料规则重写存储过程                                                                
--20170610 Qx_12  不能查特急款资料批次                                        
                                        
                                                                   
CREATE PROC [dbo].[spMaterialByBatchIDSend]                                                                                                                                                                               
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
  /*              
   declare @rowcount int                 
 --取同时领料人数                
   SELECT count(distinct session_id)--,session_id ,DB_NAME(sp.dbid) as db ,qt.text ,hostname                  
    FROM sys.dm_exec_requests er                 
    INNER JOIN sys.sysprocesses sp ON er.session_id = sp.spid                 
    CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) AS qt                    
    WHERE   session_id > 50 and DB_NAME(sp.dbid)='dsg'                
    AND session_id NOT IN ( @@SPID ) and qt.text like '%--20170922计算进程数量%'                    
 if @rowcount>80                
       waitfor delay '00:00:00:10'                
 */                                                                                                                                                                                                                                          
  declare @sql varchar(max),@sql1 varchar(max),@sql2 varchar(max),@charenter varchar(5)                                                                                          
  declare @qx_12 bit                                                                       
  set @charenter=char(13)+char(10)                                                                
  set @qx_12=ISNULL((select isnull(qx_7,0) from s_function where userid=@loginid and funcid='frmStockSendLL_msqDetaild'),0)                                                           
                                                                                                                                     
if (@banid is not null) or (@styleno is not null)                                                                          
begin              
   set @sql='--20170922计算进程数量不可删除1              
    select y.item_code MatNo,y.item_desc MatDesc,y.color_name,y.color_desc,y.Season,y.styleno,              
    reqd.bantracknm,reqd.styleno as styleno1,reqd.banid,reqd.part,reqd.dsgdeptname,reqd.dsgstyle,              
            reqd.req_serial,reqd.req_line,reqd.pre_number,reqd.pre_line,reqd.needqty,reqd.fpqty,reqd.rtnqty,reqd.unit as preunit              
   into #tmpmaterialbatchidsend                     
   from dsg_bi.dbo.Ban_Material_Needs y              
   left join req_detaild reqd(nolock) on reqd.banid=y.matioid and reqd.item_code=y.item_code and reqd.color_name=y.itemcolorid              
   left join req_head reqh(nolock) on reqh.req_serial=reqd.req_serial              
   where 1=1 '              
                   
     if @qx_12=1  SET @sql = @sql +' and isnull(reqh.tjkflag,0)=0 '                                    
                                                               
         if @bantype is not null                                      
            set @sql=@sql+'  and y.bantype like '+@bantype+@charenter                                  
         else                                                          
           set @sql=@sql+'  and y.bantype=''齐色'' '+@charenter                  
                                                                              
                                                                                          
     if @banid is not null set @sql=@sql+'  and y.matioid like '+@banid+@charenter                                                                           
         if @styleno is not null set @sql=@sql+'  and y.styleno like '+@styleno+@charenter                          
     set @sql=@sql+' Select c.req_serial,c.req_line,c.pre_number,c.pre_line,SUM(a.length) as outlength         
                     into #tmpmaterialbatchidsend1        
                     from MaterialOut_Detail(nolock) a                                                          
       left join MaterialOut_Head(nolock) b on b.DocNo=a.DocNo                                        
       left join MaterialSend_DetailD(nolock) c on c.DocNo=b.SendNo and c.BatchID=a.BatchID                                        
       where c.req_serial+convert(varchar,c.req_line)+c.pre_number+convert(varchar,c.pre_line) in (select req_serial+convert(varchar,req_line)+pre_number+convert(varchar,pre_line) from #tmpmaterialbatchidsend) and                   
        c.resno is null and b.SendNo not like ''BCK%'' and c.pre_number is not null                                                       
       group by c.req_serial,c.req_line,c.pre_number,c.pre_line --已出库'+@charenter        
      set @sql=@sql+' Select a.req_serial,a.req_line,a.pre_number,a.pre_line,SUM(length) as sendlength        
                     into #tmpmaterialbatchidsend2                                                                 
                    from MaterialSend_DetailD(nolock) a                                          
                    inner join MaterialSend_head(nolock) c on c.docno=a.docno                                                                 
                    left join MaterialOut_Head(nolock) b on b.SendNo=a.DocNo                                       
                    where a.docno like ''SED%'' and a.resno is null and b.DocNo is null and a.pre_number is not null                  
                    and a.req_serial+convert(varchar,a.req_line)+a.pre_number+convert(varchar,a.pre_line) in (select req_serial+convert(varchar,req_line)+pre_number+convert(varchar,pre_line) from #tmpmaterialbatchidsend)                                  
  
                                                        
                     group by a.req_serial,a.req_line,a.pre_number,a.pre_line --未出库'+@charenter               
      set @sql=@sql+'Select distinct cast(0 as bit ) as selectflag,                                                                        
                 a.LocationID,reqd.MatNo,reqd.MatDesc,a.BatchID,a.volumeid,a.Package,                                                                                                              
          a.avnoresweight Qtyi,                                                                                                   
          a.Wunit as Qunit,a.storelength stocklength,                                                                                                  
                           a.storeweight stockweight,                                                                                
          a.Wunit,a.conversion,                                
          a.avnoreslength   as  Length,                                                                                                              
          a.lunit,                                                                     
          a.avnoreslength  as usablelength,                                                                       
          (case when isnull(a.colorid,'''')<>'''' then a.colorid else reqd.color_name end) colorid,                                                                        
          (case when isnull(a.colordesc,'''')<>'''' then a.colordesc else reqd.color_desc end) colordesc,                                                                                             
          a.mattype,reqd.Season,a.reqperson as person,                                                                                                              
          case when reqd.req_serial is null then a.dsgpoperson else reqd.bantracknm end as dsgpoperson,a.crockid,a.sampleqty,NULL as resno,NULL as resline,a.storeno,                                                    
          case when reqd.req_serial is null then reqd.styleno else reqd.styleno1 end as styleno,case when reqd.req_serial is null then a.banid else reqd.banid end as templetid ,                                                                             
  
    
      
        
          
             
                                                          
          case when a.storeno in (''B'',''C'') then ''主料'' when a.storeno=''A'' then ''辅料'' else '''' end as itemtype1,                        
          case when a.isoldmat=1 then ''新料'' else ''旧料'' end as isoldmat,                                                                                           
          a.OrderNo,a.SupplierDesc,a.supplierid,a.podeptdesc,a.supply_colorname, a.rev_number,                                                                                                              
          a.mattypename,a.mattypedesc,                                                                                      
          case when reqd.req_serial is null then a.banid else reqd.banid end as banid,                                                                                      
          case when reqd.req_serial is null then a.part else reqd.part end as part,                                                                                     
          case when reqd.req_serial is null then a.Designer else reqd.dsgdeptname end as Designer,                                                                                                                                
          case when reqd.req_serial is null then a.dsgstyle else reqd.dsgstyle end as dsgstyle,                                             
                                                                                                                                       
          reqd.req_serial,reqd.req_line,reqd.pre_number,reqd.pre_line,reqd.needqty,reqd.preunit,                                                                
          case when reqd.preunit<>a.Lunit and reqd.preunit=''磅'' then reqd.fpqty*a.sampleqty/a.conversion  else  reqd.fpqty end preneedqty,              
          (isnull(c.outlength,0)+ISNULL(d.sendlength,0)) bcklength,                                                                
          case when a.storeno in (''B'',''C'') and reqd.fpqty>0 and a.avnoreslength-((case when reqd.preunit<>a.Lunit and reqd.preunit=''磅'' then reqd.rtnqty*a.sampleqty/a.conversion else reqd.rtnqty end)-isnull(c.outlength,0)-ISNULL(d.sendlength,0))>=0 t
hen                
    
      
               ((case when reqd.preunit<>a.Lunit and reqd.preunit=''磅'' then reqd.rtnqty*a.sampleqty/a.conversion else reqd.rtnqty end)-isnull(c.outlength,0)-ISNULL(d.sendlength,0))                                                
               when a.storeno in (''B'',''C'') and reqd.fpqty>0 and a.avnoreslength-((case when reqd.preunit<>a.Lunit and reqd.preunit=''磅'' then reqd.rtnqty*a.sampleqty/a.conversion else reqd.rtnqty end)-isnull(c.outlength,0)-ISNULL(d.sendlength,0))<0 th
en                 
    
      
               a.avnoreslength                                                    
 when a.storeno in (''A'') and reqd.fpqty>0 and a.avnoreslength-(reqd.rtnqty-isnull(c.outlength,0)-ISNULL(d.sendlength,0))>=0                                                      
                    then  reqd.rtnqty-isnull(c.outlength,0)-ISNULL(d.sendlength,0)                                                      
               when a.storeno in (''A'') and reqd.fpqty>0 and a.avnoreslength-(reqd.rtnqty-isnull(c.outlength,0)-ISNULL(d.sendlength,0))<0                                                      
                    then  a.avnoreslength                                                             
               else 0  end as prerestqty'              
          IF @isImportPDAData='1'                                                                      
             set @sql=@sql+',m.pdaid,m.pkey '               
          set @sql=@sql+' into #tmpmaterialsend               
          from #tmpmaterialbatchidsend reqd              
          left join vm_batchsendqty a on a.orderserial=reqd.req_serial and a.line=reqd.req_line              
          left join MaterialLocationInfo (nolock) k  on a.LocationID = k.locationID              
          left join (Select req_serial,req_line,pre_number,pre_line,outlength from #tmpmaterialbatchidsend1        
                    ) c on c.req_serial=reqd.req_serial and c.req_line=reqd.req_line and c.pre_number=reqd.pre_number and c.pre_line=reqd.pre_line  --已出库                    
                                                                
          left join (Select req_serial,req_line,pre_number,pre_line,sendlength from #tmpmaterialbatchidsend2                                                                              
                    ) d on c.req_serial=reqd.req_serial and c.req_line=reqd.req_line and d.pre_number=reqd.pre_number and d.pre_line=reqd.pre_line  --未出库              
                    '               
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
      SET @sql = @sql + 'where k.lockflag=0 and a.storelength>0 and a.storeweight>0 '+@charenter              
              
      set @sql=@sql+' select * from #tmpmaterialsend '                                                                 
      --select @sql                                                                                                   
      exec(@sql)        
      if OBJECT_ID('tempdb..#tmpmaterialbatchidsend1') is not null                          
         drop table #tmpmaterialbatchidsend1         
      if OBJECT_ID('tempdb..#tmpmaterialbatchidsend2') is not null                          
         drop table #tmpmaterialbatchidsend2                          
     /*                                                                     
      set @sql='--20170922计算进程数量不可删除1                
               Select distinct cast(0 as bit ) as selectflag,                  
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
 
    
      
         
         
            
                                                       
          case when a.storeno in (''B'',''C'') then ''主料'' when a.storeno=''A'' then ''辅料'' else '''' end as itemtype1,                        
          case when a.isoldmat=1 then ''新料'' else ''旧料'' end as isoldmat,                                                                                           
          a.OrderNo,a.SupplierDesc,a.supplierid,a.podeptdesc,a.supply_colorname, a.rev_number,                                                                                                        
          a.mattypename,a.mattypedesc,                                                                                      
          case when reqd.req_serial is null then a.banid else reqd.banid end as banid,                                                                                      
          case when reqd.req_serial is null then a.part else reqd.part end as part,                                                                                     
          case when reqd.req_serial is null then a.Designer else reqd.dsgdeptname end as Designer,                                                                                                                                
          case when reqd.req_serial is null then a.dsgstyle else reqd.dsgstyle end as dsgstyle,                                                        
                                 
          reqd.pre_number,reqd.pre_line,reqd.needqty,pre.unit as preunit,                                                                
          case when pre.unit<>a.Lunit and pre.unit=''磅'' then reqd.fpqty*a.sampleqty/a.conversion  else  reqd.fpqty end preneedqty,              
          (isnull(c.outlength,0)+ISNULL(d.sendlength,0)) bcklength,                                                        
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
        left join vm_batchsendqty a on a.orderserial=reqd.req_serial and a.line=reqd.req_line                                                                                                                                                              
              left join  MaterialLocationInfo (nolock) k  on a.LocationID = k.locationID                                                                                                                  
              left join (Select c.pre_number,c.pre_line,SUM(a.length) as outlength from MaterialOut_Detail(nolock) a       
        left join MaterialOut_Head(nolock) b on b.DocNo=a.DocNo                                        
        left join MaterialSend_DetailD(nolock) c on c.DocNo=b.SendNo and c.BatchID=a.BatchID                                        
        where c.resno is null and b.SendNo not like ''BCK%'' and c.pre_number is not null                                                       
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
          SET @sql = @sql + 'where k.lockflag=0 '+@charenter                                                         
          if @qx_12=1  SET @sql = @sql +' and isnull(reqh.tjkflag,0)=0 '                               
                                                               
         if @bantype is not null                                                                   
            set @sql=@sql+'  and y.bantype like '+@bantype+@charenter                                  
         else                                                                  
      set @sql=@sql+'  and y.bantype=''齐色'' '+@charenter                                                                  
                                                                    
                                                                                          
         if @banid is not null set @sql=@sql+'  and y.matioid like '+@banid+@charenter                              
         if @styleno is not null set @sql=@sql+'  and y.styleno like '+@styleno+@charenter                          
                          
                          
   set @sql=@sql+' select * from #tmpmaterialsend '                                                                 
   --select @sql                                                                                                   
   exec(@sql)*/                                                                          end                                                                          
else                                                                      
begin                  
   --新布                  
   set @sql='--20170922计算进程数量不可删除2                
          Select cast(0 as bit ) as selectflag,a.BatchID,a.LocationID,a.MatNo,a.MatDesc,a.volumeid,a.Package,                                                                                                              
          a.avnoresweight Qtyi,                                                                                                              
          a.Wunit as Qunit,a.storelength stocklength,--库存数量                                                                        
                           a.storeweight stockweight,                                                                                                              
          a.Wunit,a.conversion,                                                            a.avnoreslength   as  Length,                                                                                                              
          a.Lunit,                                                                                                  
          a.avnoreslength  as usablelength,--实际可用                                                                                                     
          a.ColorID,a.ColorDesc, a.mattype,a.Season,a.reqperson as person,                                                                                                              
          case when reqd.req_serial is null then a.dsgpoperson else reqd.bantracknm end as dsgpoperson,a.crockid,a.sampleqty,NULL as resno,NULL as resline,a.storeno,                                                                                         
   
   
           
          case when reqd.req_serial is null then a.styleno else reqd.styleno end as styleno,case when reqd.req_serial is null then a.banid else reqd.banid end as templetid ,                                                                                  
  
    
      
          case when reqd.req_serial is null then a.dsgstyle else reqd.dsgstyle end as dsgstyle,                                                
          case when a.storeno in (''B'',''C'') then ''主料'' when a.storeno=''A'' then ''辅料'' else '''' end as itemtype1,                          
          ''新料'' as isoldmat,                                                                                                        
          a.OrderNo,a.rev_number,reqd.req_serial,reqd.req_line,reqd.pre_number,reqd.pre_line,reqd.unit as preunit,'                                                                                                                                            
  
    
                                    
                                                                    
         if @receivedpt='订购'                  
            set @sql=@sql+' case when reqd.unit<>a.Lunit and reqd.unit=''磅'' then (reqd.fpqty+reqd.qtyotherorder)*a.sampleqty/a.conversion                                                 
                    else                                                                 
                           (reqd.fpqty+reqd.qtyotherorder) end preneedqty,'                                                     
         else                                                                  
            set @sql=@sql+' case when reqd.unit<>a.Lunit and reqd.unit=''磅'' then reqd.fpqty*a.sampleqty/a.conversion                                                                
                         else                                                   
                            reqd.fpqty end preneedqty,'                  
     set @sql=@sql+' reqd.rtnqty,a.avnoreslength'                  
     IF @isImportPDAData='1'                                                                                      
        set @sql=@sql+',m.pdaid,m.pkey '                    
     set @sql=@sql+' into #tmpmaterialbatchidsend       
          from vm_batchsendqty a                  
     left join req_detaild(nolock) reqd on a.orderserial=reqd.req_serial and a.line=reqd.req_line                  
     left join  MaterialLocationInfo(nolock) k  on a.LocationID = k.locationID '+ @charenter                  
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
   set @sql=@sql+'       where a.isoldmat=1 and a.storelength>0 and a.storeweight>0 and a.avnoreslength >0 and a.avnoresweight>0 and k.lockflag=0 '+ @charenter                   
   if @BatchID is not null set @sql=@sql+'  and a.BatchID  like '+@BatchID+@charenter                                    
   if @LocationID is not null set @sql=@sql+'  and a.LocationID like '+@LocationID+@charenter                                                                                                                                                                  
 
    
       
        
         
             
              
                
                                                                                                                                   
   if @MatNo is not null set @sql=@sql+'  and a.MatNo  like '+@MatNo+@charenter                                                                                                                                 
   if @OrderNo is not null set @sql=@sql+'  and a.OrderNo like '+@OrderNo+@charenter                                                                             
   if @OrderUser is not null set @sql=@sql+'  and a.reqperson like '+@OrderUser+@charenter                                                                                                                                                                     
  
    
      
       
           
            
              
                
                                                                                                                       
   if @Supplier is not null set @sql=@sql+'  and a.SupplierID like '+@Supplier+@charenter                                                                                                                                                                      
  
    
      
        
          
              
                
                                                                                             
   if @Season is not null set @sql=@sql+ '  and a.Season  like '+@Season+@charenter                                                                                                                                                                            
  
    
      
       
   if @colorid is not null set @sql=@sql+ '  and a.colorid = '+ replace(@colorid,'%','')+@charenter                                                                                                                                                            
  
    
      
        
         
             
              
     
                                                                                 
 if @colordesc is not null set @sql=@sql+'  and a.colordesc like '+@colordesc+@charenter                                                                                            
 if @matdesc is not null set @sql=@sql+'  and a.matdesc like '+@matdesc+@charenter                                                                                                                                                                             
  
    
      
        
          
            
              
                
                                                                                                                                                                                                              
 if @mattype is not null set @sql=@sql+'  and a.mattype like '+@mattype+@charenter                                                                                                                                                            
 if @crockid is not null set @sql=@sql+'  and isnull(a.crockid,'''') like '+@crockid+@charenter                                                                                                                
 if @storeno is not null set @sql=@sql+'  and a.storeno= '+@storeno+@charenter                                                                                      
 if @revnumber is not null set @sql=@sql+'  and a.rev_number =  '+@revnumber+@charenter                                                                                                                                         
          
            
              
                
                 
   if @isnewmat=1 set @sql=@sql+ '  and a.isoldmat=1 '+@charenter                                                                                                                               
 if @isnewmat=2 set @sql=@sql+ '  and a.isoldmat=0 '+@charenter                          
 if @Flag=1 set @sql=@sql+'  and isnull(a.locationid,'''')<>'''''+@charenter                                                                                                                                                                                   
  
    
     
         
          
            
              
                
                                                                                   
 if @Flag=2 set @sql=@sql+'  and isnull(a.locationid,'''')='''''+@charenter                                                                                  
   if @qx_12=1 SET @sql = @sql +' and isnull(reqh.tjkflag,0)=0 '                           
                                                                                   
  if @Designer is not null set @sql=@sql+'  and ( reqd.dsgdeptname like '+@Designer+' or a.Designer like '+@Designer+')'+ @charenter                                                                                                                           
  
    
      
        
          
            
              
                
                  
                                                                                      
  if @TrackUser is not null set @sql=@sql+'  and (reqd.bantracknm like '+@TrackUser+' or a.dsgpoperson like '+@TrackUser+')'+ @charenter                                                                                          
    
      
        
          
            
              
                
                  
                                      
  if @reqname is not null set @sql=@sql+'  and (reqd.reqperson like '+@reqname + ')'+ @charenter                                                                    
  if @tracgpname is not null set @sql=@sql+'  and (reqd.rptgroupnm like '+@tracgpname + ')'+ @charenter                                                                                                                 
                         
 IF @docType <> '1'--by lw 2016.07.07 增加，如果是开领料单和退料出库单，只有以下用户可以开单                                                                
   AND @loginid NOT IN ( 'BF0011', 'BF1854', 'BF0625', 'BF0014', 'BF0632',                                                                                
         'BF0667', 'BF0028', 'BF0025', 'BF1683', 'BF0012',                      
         'BF1255', 'BF0030', 'BF0043', 'BF0675', 'BF0609',                                              
         'BF1287', 'BF0006', 'BF0013', 'BF0020', 'BF1781',                                                                                
         'BF1896', 'BF1921','SA' )                                                                                 
   SET @sql = @sql + '  AND a.LocationID <>''BA666666''' + @charenter                   
                       
    set @sql = @sql+' select * into #tmpmaterialsend  from ( '                                                                                                   
    set @sql=@sql+' Select a.*,(isnull(c.outlength,0)+ISNULL(d.sendlength,0)) bcklength,                                            
          case when a.storeno in (''B'',''C'') and a.preneedqty>0 and a.avnoreslength-((case when a.preunit<>a.Lunit and a.preunit=''磅'' then a.rtnqty*a.sampleqty/a.conversion                                                                
                                                                      else a.rtnqty end)-isnull(c.outlength,0)-ISNULL(d.sendlength,0))>=0                                                             
                                  then ((case when a.preunit<>a.Lunit and a.preunit=''磅'' then a.rtnqty*a.sampleqty/a.conversion                                                                
                                         else a.rtnqty end)-isnull(c.outlength,0)-ISNULL(d.sendlength,0))                                                                
               when a.storeno in (''B'',''C'') and a.preneedqty>0 and a.avnoreslength-((case when a.preunit<>a.Lunit and a.preunit=''磅'' then a.rtnqty*a.sampleqty/a.conversion                                                                
                  else a.rtnqty end)-isnull(c.outlength,0)-ISNULL(d.sendlength,0))<0 then a.avnoreslength                                                      
               when a.storeno in (''A'') and a.preneedqty>0 and a.avnoreslength-(a.rtnqty-isnull(c.outlength,0)-ISNULL(d.sendlength,0))>=0                                                      
                    then  a.rtnqty-isnull(c.outlength,0)-ISNULL(d.sendlength,0)                                            
               when a.storeno in (''A'') and a.preneedqty>0 and a.avnoreslength-(a.rtnqty-isnull(c.outlength,0)-ISNULL(d.sendlength,0))<0                                                      
                    then  a.avnoreslength                                                                
               else 0  end as prerestqty                                                                                                                                                                                                           
    
      
        
          
           
               
                               
          from #tmpmaterialbatchidsend a                                                                                              
                                 
         left join (Select c.req_serial,c.req_line,c.pre_number,c.pre_line,SUM(a.length) as outlength from MaterialOut_Detail(nolock) a                                                          
        left join MaterialOut_Head(nolock) b on b.DocNo=a.DocNo                                        
        left join MaterialSend_DetailD(nolock) c on c.DocNo=b.SendNo and c.BatchID=a.BatchID                                        
        where c.req_serial+convert(varchar,c.req_line)+c.pre_number+convert(varchar,c.pre_line) in (select req_serial+convert(varchar,req_line)+pre_number+convert(varchar,pre_line) from #tmpmaterialbatchidsend) and                   
         c.resno is null and b.SendNo not like ''BCK%'' and c.pre_number is not null                                                       
        group by c.req_serial,c.req_line,c.pre_number,c.pre_line                  
       ) c on c.req_serial=a.req_serial and c.req_line=a.req_line and c.pre_number=a.pre_number and c.pre_line=a.pre_line   --已出库                  
                                                                
         left join (Select a.req_serial,a.req_line,a.pre_number,a.pre_line,SUM(length) as sendlength                                                                 
                    from MaterialSend_DetailD(nolock) a                                          
                    inner join MaterialSend_head(nolock) c on c.docno=a.docno                                                                 
                    left join MaterialOut_Head(nolock) b on b.SendNo=a.DocNo                                       
           where a.docno like ''SED%'' and a.resno is null and b.DocNo is null and a.pre_number is not null                  
                    and a.req_serial+convert(varchar,a.req_line)+a.pre_number+convert(varchar,a.pre_line) in (select req_serial+convert(varchar,req_line)+pre_number+convert(varchar,pre_line) from #tmpmaterialbatchidsend)                                  
  
                                                        
                     group by a.req_serial,a.req_line,a.pre_number,a.pre_line                                                                
                    ) d on d.req_serial=a.req_serial and d.req_line=a.req_line and d.pre_number=a.pre_number and d.pre_line=a.pre_line  --未出库                                                                 
                        '+@charenter                             
                                    
   --旧布                          
   set @sql1=' union all '+ @charenter                                                                                                     
    set @sql1=@sql1+'Select distinct cast(0 as bit ) as selectflag,a.BatchID,a.LocationID,a.MatNo,a.MatDesc,a.volumeid,a.Package,                                                                                                              
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
   
    
     
        
           
          a.dsgstyle,                                                
          case when a.storeno in (''B'',''C'') then ''主料'' when a.storeno=''A'' then ''辅料'' else '''' end as itemtype1,''旧料'' as isoldmat,                                                                                                                     
  
    
      
        
                               
          a.OrderNo,a.rev_number,reqd.req_serial,reqd.req_line,                                                      
          '''' pre_number,0 pre_line,'''' preunit,0 rtnqty,a.avnoreslength,0 preneedqty,0 bcklength,0 prerestqty'                          
                                                                                                   
        IF @isImportPDAData='1'                                                                                      
           set @sql=@sql1+',m.pdaid,m.pkey '                                                                          
                                                                                                                                                                
        set @sql1=@sql1+'  from vm_batchsendqty a                                               
         left join req_detaild reqd(nolock) on a.orderserial=reqd.req_serial and a.line=reqd.req_line                                                        
         --left join req_head reqh(nolock) on reqh.req_serial=reqd.req_serial                                                                                                                  
         left join  MaterialLocationInfo (nolock) k  on a.LocationID = k.locationID                                                                                                                                                                            
  
    
     
                        '+@charenter                                                                                      
    IF @isImportPDAData='1'                                                                                      
    begin        
     set @sql1=@sql1+' INNER JOIN (SELECT batchid,pdaid,pkey FROM dbo.pdadsgclothsendll_res (NOLOCK)                                                                                      
            WHERE userid='''+@loginid+''''+' AND isend=''0'' AND docType='''+@docType+'''' +' AND datediff(day,worktime,GETDATE())<7 '+@charenter                                                                                      
    IF @pdaDocNo IS NOT NULL                                                                                        
    BEGIN                                                                   
      SET @sql1 = @sql1 + ' and pkey like ' + @pdadocno + @charenter                                                                                  
    END                                                                                               
    SET @sql1 = @sql1 + ' ) m ON a.batchid=m.batchid ' + @charenter                                                                                      
   end                                                                                  
                                                                                                                                           
   SET @sql1 = @sql1 + 'where a.isoldmat=0 and a.storelength>0 and a.storeweight>0 and a.avnoreslength >0 and a.avnoresweight>0                                     
      and k.lockflag=0 '+@charenter                                                        
   if @qx_12=1 SET @sql1 = @sql1 +' and isnull(reqh.tjkflag,0)=0 '                           
   if @BatchID is not null set @sql1=@sql1+'  and a.BatchID  like '+@BatchID+@charenter                                    
  if @LocationID is not null set @sql1=@sql1+'  and a.LocationID like '+@LocationID+@charenter                                                                                     
                                                                                                                                                                                                                                    
  if @MatNo is not null set @sql1=@sql1+'  and a.MatNo  like '+@MatNo+@charenter                                                                                                                                 
  if @OrderNo is not null set @sql1=@sql1+'  and a.OrderNo like '+@OrderNo+@charenter                                                
  if @OrderUser is not null set @sql1=@sql1+'  and a.reqperson like '+@OrderUser+@charenter                                                                                                                                                                   
  
    
      
         
         
             
              
               
                                                                                                                   
  if @Supplier is not null set @sql1=@sql1+'  and a.SupplierID like '+@Supplier+@charenter                                         
  if @Season is not null set @sql1=@sql1+ '  and a.Season  like '+@Season+@charenter                                                                                         
               
                                                                                         
  if @Designer is not null set @sql1=@sql1+'  and ( reqd.dsgdeptname like '+@Designer+' or a.Designer like '+@Designer+')'+ @charenter                                                                                                                         
  
    
      
        
          
           
               
                
                  
                                                                                          
  if @TrackUser is not null set @sql1=@sql1+'  and (reqd.bantracknm like '+@TrackUser+' or a.dsgpoperson like '+@TrackUser+')'+ @charenter                                          
        
          
            
              
                
                  
                                                                                                                                                                                         
  if @colorid is not null set @sql1=@sql1+ '  and a.colorid = '+ replace(@colorid,'%','')+@charenter                                                                                                                                                           
  
   
       
        
          
            
              
                
                 
                                   
  if @colordesc is not null set @sql1=@sql1+'  and a.colordesc like '+@colordesc+@charenter                                                                                            
  if @matdesc is not null set @sql1=@sql1+'  and a.matdesc like '+@matdesc+@charenter                                                                                                                                                                          
  
    
      
        
          
            
              
                
                  
                                                                                                                                                                                                                  
  if @mattype is not null set @sql1=@sql1+'  and a.mattype like '+@mattype+@charenter                                                                                                                                                            
  if @crockid is not null set @sql1=@sql1+'  and isnull(a.crockid,'''') like '+@crockid+@charenter                                                                                                                
  if @storeno is not null set @sql1=@sql1+'  and a.storeno= '+@storeno+@charenter                        
  if @revnumber is not null set @sql1=@sql1+'  and a.rev_number =  '+@revnumber+@charenter                                                                                                                                                                    
   
    
      
       
           
            
              
                
                  
                                         
  if @reqname is not null set @sql1=@sql1+'  and (reqd.reqperson like '+@reqname + ')'+ @charenter                                                    
  if @tracgpname is not null set @sql1=@sql1+'  and (reqd.rptgroupnm like '+@tracgpname + ')'+ @charenter                                                                    
  if @isnewmat=1 set @sql1=@sql1+ '  and a.isoldmat=1 '+@charenter                                                                                          
  if @isnewmat=2 set @sql1=@sql1+ '  and a.isoldmat=0 '+@charenter                           
  if @Flag=1 set @sql1=@sql1+'  and isnull(a.locationid,'''')<>'''''+@charenter                                        
                      
                       
                                                                                        
  if @Flag=2 set @sql1=@sql1+'  and isnull(a.locationid,'''')='''''+@charenter                                                                                  
                                                                                  
  IF @docType <> '1'--by lw 2016.07.07 增加，如果是开领料单和退料出库单，只有以下用户可以开单                    
    AND @loginid NOT IN ( 'BF0011', 'BF1854', 'BF0625', 'BF0014', 'BF0632',                   
                          'BF0667', 'BF0028', 'BF0025', 'BF1683', 'BF0012',                                                              
                          'BF1255', 'BF0030', 'BF0043', 'BF0675', 'BF0609',                                                                                
                          'BF1287', 'BF0006', 'BF0013', 'BF0020', 'BF1781',                                                                                
                          'BF1896', 'BF1921','SA' )            
    SET @sql1 = @sql1 + '  AND a.LocationID <>''BA666666''' + @charenter                          
                              
   set @sql1=@sql1+' ) tmp select * from #tmpmaterialsend'                  
                          
   --set @sql2=' select * into #tmpmaterialsend from ('+@sql+@sql1+' ) tmp  select * from #tmpmaterialsend '                           
   --set @sql2=@sql2+' select * from #tmpmaterialsend '                          
   --exec(@sql2)                                                                
  --select @sql                  
   --print @sql1                   
   exec (@sql+@sql1)          
   --exec(' select * into #tmpmaterialsend from ('+@sql+@sql1+' ) tmp  select * from #tmpmaterialsend ')                          
                                                                                             
end                  
if OBJECT_ID('tempdb..#tmpmaterialbatchidsend') is not null                          
   drop table #tmpmaterialsend                                                                          
                                                                          
if OBJECT_ID('tempdb..#tmpmaterialsend') is not null                          
   drop table #tmpmaterialsend 