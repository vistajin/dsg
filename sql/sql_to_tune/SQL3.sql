                                           														
		select matioid,sc_number,												
			max(isnull(mb_number,'')) as mb_number,											
			max(isnull(mbversion,'')) as mbversion 											
		 into #tmplastban	                       											
         from dsg.dbo.ban_makebill_head (nolock) 														
         where (salesSeason>'2017' or salesSeason='2016冬季' )														
           and isnull(sc_number,'')<>''														
           and matioid not like 'DNS%'		/*过滤掉电脑部测试的款*/												
           and matioid not like '%VP'			/*过滤掉唯品会的款*/											
         group by matioid,sc_number                                    														
														
 														
		SELECT b.mb_number,b.mb_line,b.item_code,b.des3 as parts												
		   INTO #tmpbanitem												
		   FROM dsg.dbo.ban_makebill_itemlist b(nolock) INNER JOIN												
				dsg.dbo.ban_makebill_head a (nolock) on a.mb_number = b.mb_number										
		  WHERE 1=1												
			and (a.salesSeason>'2017' or a.salesSeason='2016冬季')											
			/*需要包括辅料的资料，所以屏蔽											
			b.itemtypedesc='主料' 											
			and (item.seriestype in ('针织','梭织','牛仔','毛织'))											
			*/											
			AND b.des3 not like '%捆条%'			/*部位<>捆条*/								
			AND b.des3 not like '%领捆%'			/*部位<>领捆*/		   						
														
														
		select distinct a.season,a.salesSeason,a.mb_number,a.matioid,a.styleno,a.sc_number,												
			a.mbversion,a.makedeptdesc,a.PPType,a.dsgdeptconfirmdate											
		  into #tmpfirstmbt07												
		  from dsg_bi.dbo.Ban_Firstver_MBT07 a(nolock) 												
		 where ISNULL(cancelapplyflag,0)<>1			/*板单设计师未取消*/									
		   and (salesSeason>'2017' or salesSeason='2016冬季')  		 										
														
														
		SELECT item0.item_code,item0.item_desc,itemcate.seriestype												
		  INTO #tmpitem												
		  FROM dsg.dbo.b_item item0(nolock) Inner join									#NAME?			
		       dsg.dbo.b_itemcate itemcate(nolock) on item0.treeID = itemcate.treeID	#NAME?											
		 WHERE usestate='启用'       												
														
														
		SELECT c.season,c.salesSeason,c.banid,c.styleno,c.sc_number,												
			c.styledesc,c.makedeptname,c.makedeptdesc,c.trackgroupnm,c.tracknm											
		 INTO #tmpstyleno												
		   FROM dsg.dbo.b_styleno c(nolock)												
		 WHERE 1=1 												
			and (salesSeason>'2017' or salesSeason='2016冬季') 											
			and c.banid not in											
			(		#NAME?									
			 SELECT matioid FROM dsg.dbo.ban_makebill_head (nolock) WHERE ISNULL(cancelapplyflag,0)=1											
			 union  --过滤掉叶小姐看板取消款/有问题款登记里取消的											
			 SELECT banid FROM dsg.dbo.cancelstyle (nolock) WHERE reason like '%取消款%'											
			 union  --过滤掉大选取消的											
			 select banid from dsg.dbo.ban_cancel (nolock)											
			 union  --过滤掉订货资料里取消的 或者 暂停款											
			 select banid from dsg.dbo.od_head (nolock)											
			 where ISNULL(stylecancel,'')<>'' or ISNULL(IsStopFlag,0)=1											
			 union  --过滤掉订货资料里非采用的款，快单除外（款号以7开头）											
			 select banid from dsg.dbo.od_head (nolock)											
			 where ISNULL(IsActiveFlag,0)=0											
			   and styleno not like '7%'											
			)		   									
														
														
        select distinct b.mb_number,b.mb_line,														
			case when isnull(DigestionstoreFlag,0)=1 then '消化库存' 											
				 when isnull(YuliustoreFlag,0)=1 then '使用预留' 										
				 when isnull(DinggouFlag,0)=1 then '需订购' 										
				 when isnull(SjstigongFlag,0)=1 then '设计师提供' 										
				 when isnull(PiyinFlag,0)=1 then '匹印' 										
				 when isnull(xianpeiFlag,0)=1 then '现胚备布' 										
				 when isnull(xianhuoFlag,0)=1 then '现货备布' 										
				 when isnull(shigouFlag,0)=1 then '市购' 										
				 else ''										
			end as matsource											
		 into #tmpmatsource												
         from dsg.dbo.ban_makebill_itemcolor b(nolock) INNER JOIN														
		   dsg_bi.dbo.Ban_Lastver_MBT07 a (nolock) on a.mb_number = b.mb_number												
		  WHERE 1=1												
		  and (salesSeason>'2017' or salesSeason='2016冬季')												
														
														
        select matioid,sc_number,istransferseason,														
			MAX(mb_number) mb_number,MAX(mbversion) mbversion											
		 into #tmpts												
         from dsg.dbo.ban_makebill_head (nolock)														
         where (salesSeason>'2017' or salesSeason='2016冬季')														
           and isnull(istransferseason,'')<>''														
         group by matioid,sc_number,istransferseason														
														
														
		select item_code,fd.season,fd.remark,fh.indate,fh.confirmdate,fh.senddate												
		  into #tmpfgb 												
		  from	dsg.dbo.item_fenggebanapply_detail fd(nolock)  Inner join	  										
				dsg.dbo.item_fenggebanapply_head fh(nolock) on fd.fgb_number=fh.fgb_number 										
		 where confirmflag=1												
		   and (fd.season>'2017' or fd.season='2016冬季' or fd.season='2016秋季')												
														
 														
		select distinct a.DocNo AS resdocno,b.styleno,b.MatNo 												
		  into #tmpres												
		  from  dsg.dbo.MaterialSend_head a(nolock) INNER JOIN												
			   dsg.dbo.MaterialSend_DetailD b(nolock) ON a.DocNo=b.DocNo											
		 where a.DocNo like 'RES%'												
		   AND branchid='研发中心'												
		   AND CheckDate>'2016-01-01'												
														
														
        select banid,MAX(scandatetime) as bantryfactdate 														
          into #tmptd														
        FROM(  														
        select banid,scandatetime   														
          from dsg.dbo.ban_transscan (nolock)														
         where bantypedesc like '%落单%'														
           and fromdeptdesc like '%跟单%'														
           and ISNULL(fromuserid,'')<>''														
           and touserdeptdesc like '%纸样%'														
           and ISNULL(IsResultOk,0)=1														
         UNION														
        select banid,scandatetime   														
          from dsg.dbo.ban_transscan_gdb (nolock)														
         where bantypedesc like '%落单%'														
           and fromdeptdesc like '%跟单%'														
           and ISNULL(fromuserid,'')<>''														
           and touserdeptdesc like '%纸样%'														
           and ISNULL(IsResultOk,0)=1           														
         )a  														
         group by banid  	  													
														
														
         select banid,bantypeid,MAX(scandatetime) AS scandatetime														
           into #tmpys														
           from dsg.dbo.ban_transscan (nolock)														
          where bantypeid='MBT01'														
            and touserdeptdesc='工厂'														
         group by banid,bantypeid    														
														
       														
		select sc_number,estimatedate 												
		   into #tmpzs												
		   from dsg.dbo.ban_makebill_head (nolock)												
		  where mbtypeid='MBT01'												
		    and (salesSeason>'2017' or salesSeason='2016冬季')												
		    and ISNULL(estimatedate,'')<>''												
														
  														
		select b.season,a.MatNo,MIN(b.checkdate) AS FirstinStoreDate 												
		   into #tmpins  												
		   from dsg.dbo.materialcollect_detail a(nolock) inner join   												
				dsg.dbo.materialcollect_head b(nolock) on  a.DocNo=b.DocNo  										
		  where (b.season>'2016' or b.season='通用季')												
		  GROUP BY b.season,a.MatNo  												
														
                                                                       														
		SELECT  c.salesSeason,c.banid,c.styleno,c.sc_number,												
			c.styledesc,c.makedeptname,c.makedeptdesc,											
			a0.PPType,a0.dsgdeptconfirmdate,											
			b.item_code,b.parts,item.item_desc,item.seriestype,											
			ISNULL(ms.matsource,'') matsource,											
			ISNULL(ts.istransferseason,0) istransferseason,											
			fgb.indate fgbindate,fgb.confirmdate fgbconfirmdate,											
			fgb.senddate fgbsenddate,fgb.remark as fgbremark,											
			td.bantryfactdate,											
			ys.scandatetime,											
			zs.estimatedate,											
			res.resdocno,ins.FirstinStoreDate,											
			c.trackgroupnm,c.tracknm											
		INTO #tmpdb												
		FROM #tmplastban a2  Inner join				#NAME?								
			 #tmpbanitem b on a2.mb_number = b.mb_number Inner join					#NAME?						
			 #tmpfirstmbt07 a0 											
				ON a0.matioid=a2.matioid and a0.sc_number=a2.sc_number Inner join --头板+齐色板单的最早版本的设计经理审核日期										
			 #tmpitem item on b.item_code = item.item_code	LEFT JOIN				#NAME?						
			 #tmpstyleno c on a2.matioid=c.banid and a2.sc_number = c.sc_number	LEFT JOIN		#NAME?								
			 #tmpmatsource ms on ms.mb_number=b.mb_number and ms.mb_line=b.mb_line	LEFT JOIN	#NAME?									
			 #tmpts ts on ts.matioid=a2.matioid and ts.sc_number=a2.sc_number LEFT JOIN			#NAME?								
			 #tmpfgb fgb											#NAME?
				ON b.item_code=fgb.item_code and (c.season=fgb.season or fgb.season='通用季') LEFT JOIN										
			 #tmpres res on res.styleno=a2.matioid and res.MatNo=b.item_code LEFT JOIN	#NAME?										
			 #tmptd td on a0.matioid=td.banid LEFT JOIN				--原板(落单)试衣OK时间							
			 #tmpys ys on a0.matioid=ys.banid LEFT JOIN				#NAME?							
			 #tmpzs zs on a0.sc_number = zs.sc_number LEFT JOIN		#NAME?									
			 #tmpins ins											#NAME?
				ON (c.salesSeason=ins.season or ins.season='通用季') and (b.item_code= ins.MatNo)										
														
truncate table dsg_bi.dbo.Ban_Node_Datetime 														
														
	INSERT INTO dsg_bi.dbo.Ban_Node_Datetime(season,matioid,styleno,													
		  PPType,sc_number,styledesc,												
		  makedeptname,makedeptdesc,trackgroupnm,tracknm,item_code,item_desc,seriestype,parts,												
		  dsgdeptconfirmdate,fgbindate,fgbconfirmdate,fgbsenddate,fgbremark,												
		  bantryfactdate,scandatetime,estimatedate,matsource,istransferseason,												
		  resdocno,FirstinStoreDate)												
		select salesSeason,banid,styleno,												
			PPType,sc_number,											
			styledesc,makedeptname,makedeptdesc,trackgroupnm,tracknm,											
			item_code,item_desc,seriestype,parts,											
			MAX(dsgdeptconfirmdate) dsgdeptconfirmdate,	/*取设计经理审核最新日期*/										
			MAX(fgbindate) fgbindate,					/*取风格板录入最新日期*/						
			MAX(fgbconfirmdate) fgbconfirmdate,			/*取风格板审核最新日期*/								
			MAX(fgbsenddate) fgbsenddate,				/*取风格板发出最新日期*/							
			'',											
			MAX(bantryfactdate) bantryfactdate,			/*取原板试衣OK最新日期*/								
			MAX(scandatetime) scandatetime,				/*取原板发出最新日期*/							
			MAX(estimatedate) estimatedate,				/*取制单发单最新日期*/							
			matsource,istransferseason,resdocno,											
			MIN(FirstinStoreDate) FirstinStoreDate		/*面料入仓最早的入库单审核时间*/									
		from #tmpdb												
		where isnull(dsgdeptconfirmdate,'')<>''		/*只取有设计经理审核日期的款*/										
		group by salesSeason,banid,styleno,PPType,sc_number,												
			styledesc,makedeptname,makedeptdesc,trackgroupnm,tracknm,											
			item_code,item_desc,seriestype,parts,											
			matsource,istransferseason,resdocno                                                                                   											
		order by styleno 												
			 											
	drop table #tmplastban													
	drop table #tmpbanitem													
	drop table #tmpfirstmbt07													
	drop table #tmpitem													
	drop table #tmpstyleno													
	drop table #tmpmatsource													
	drop table #tmpts													
	drop table #tmpfgb													
	drop table #tmpres													
	drop table #tmptd 													
	drop table #tmpys 													
	drop table #tmpzs 													
	drop table #tmpins													
	drop table #tmpdb 													
  														
