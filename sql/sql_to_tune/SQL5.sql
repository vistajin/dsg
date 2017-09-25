SELECT DISTINCT a.papermanager,a.PMPerson,a.newbanid                          
     INTO #tmptb                                                                           
     FROM PPPaperDept a(nolock)                                                                
    WHERE 1=1                                                  
      AND a.bantype in('头板','板型款')                            
 
   and a.AccDate>='2017-08-01'
   and a.AccDate<='2017-08-25 23:59:59'
                           
   SELECT DISTINCT b.papermanager,b.PMPerson,b.newbanid                          
   INTO #tmpzjqs                             
   FROM PPPaperDept b(nolock)                                                                 
   WHERE 1=1                                                  
     AND b.bantype='齐色'                          
     AND b.newbanid NOT IN                          
  (SELECT DISTINCT newbanid FROM PPPaperDept a(nolock)                                                                
   WHERE 1=1                                                  
  AND a.bantype='头板' )                           
 
   and b.AccDate>='2017-08-01'
   and b.AccDate<='2017-08-25 23:59:59'
                                
  SELECT DISTINCT a.papermanager,a.PMPerson,a.newbanid                                
  INTO #tmpPaperQty                          
  FROM(                                             --头板                          
   SELECT * FROM #tmptb                                                                                                 
   UNION                          
   SELECT * FROM #tmpzjqs                        --直接齐色                          
   )a INNER JOIN                                                                 
       b_styleno b(nolock) on a.newbanid=b.banid                           
  WHERE 1=1                            
 
                                                                 
  SELECT a.papermanager,a.PMPerson,a.newbanid,                                                                
   ISNULL(s01.BanxingScore,0)+ISNULL(s02.CollartypeScore,0)+ISNULL(s03.Design_styleScore,0)+                                         
   ISNULL(s04.DresslengthScore,0)+ISNULL(s05.FabcharacterScore,0)+ISNULL(s06.FabnameScore,0)+                                                                
   ISNULL(s07.SexTypeScore,0)+ISNULL(s08.SleeveLengthScore,0)+ISNULL(s09.SleevetypeScore,0)+                                                 
   ISNULL(s10.Styletype2Score,0)+ISNULL(s11.ThicknessScore,0)+ISNULL(s12.Waist_typeScore,0)               
   AS generalScore,                  
   ISNULL(s01.BanxingScore,0) BanxingScore,ISNULL(s02.CollartypeScore,0) CollartypeScore,                  
   ISNULL(s03.Design_styleScore,0) Design_styleScore,ISNULL(s04.DresslengthScore,0) DresslengthScore,                  
   ISNULL(s05.FabcharacterScore,0) FabcharacterScore,ISNULL(s06.FabnameScore,0) FabnameScore,                                                                
   ISNULL(s07.SexTypeScore,0) SexTypeScore,ISNULL(s08.SleeveLengthScore,0) SleeveLengthScore,                  
   ISNULL(s09.SleevetypeScore,0) SleevetypeScore,ISNULL(s10.Styletype2Score,0) Styletype2Score,                  
   ISNULL(s11.ThicknessScore,0) ThicknessScore,ISNULL(s12.Waist_typeScore,0) Waist_typeScore                                                                  
  INTO #tmpReceiveScore                                                                 
  FROM #tmpPaperQty a(nolock) INNER JOIN                                                                 
    dsg_bi.dbo.Ban_Lastver_MBT07 b(nolock) on a.newbanid=b.matioid INNER JOIN                                                                
    ban_makebill_head c(nolock) on b.mb_number=c.mb_number LEFT JOIN                                                                
    Paper_Banxing s01(nolock) on c.Stylenametype=s01.Stylenametype AND c.banxing=s01.banxing LEFT JOIN                                                                
    Paper_Collartype s02(nolock) on c.Stylenametype=s02.Stylenametype AND c.Collartype=s02.Collartype LEFT JOIN                                          
    Paper_Design_style s03(nolock) on c.Stylenametype=s03.Stylenametype AND c.Design_style=s03.Design_style LEFT JOIN                                                                
    Paper_Dresslength s04(nolock) on c.Stylenametype=s04.Stylenametype AND c.BX_length=s04.Dresslength LEFT JOIN                                                                
    Paper_Fabcharacter s05(nolock) on c.Stylenametype=s05.Stylenametype AND c.Fabcharacter=s05.Fabcharacter LEFT JOIN                                                      
    Paper_Fabname s06(nolock) on c.Stylenametype=s06.Stylenametype AND c.Fabname=s06.Fabname LEFT JOIN                                                                
    Paper_SexType s07(nolock) on c.Stylenametype=s07.Stylenametype AND c.Sex=s07.SexType LEFT JOIN                                                                
    Paper_SleeveLength s08(nolock) on c.Stylenametype=s08.Stylenametype AND c.outsidesleeve=s08.SleeveLength LEFT JOIN               
    Paper_Sleevetype s09(nolock) on c.Stylenametype=s09.Stylenametype AND c.Pants_type=s09.Sleevetype LEFT JOIN                                                                
    Paper_Styletype2 s10(nolock) on c.Stylenametype=s10.Stylenametype AND c.Styletype2=s10.Styletype2 LEFT JOIN                                                                
    Paper_Thickness s11(nolock) on c.Stylenametype=s11.Stylenametype AND c.Thickness=s11.Thickness LEFT JOIN                     
    Paper_Waist_type s12(nolock) on c.Stylenametype=s12.Stylenametype AND c.Waist_type=s12.Waist_type                                                     
  WHERE 1=1                                                                
 
                                                                
  SELECT a.papermanager,a.PMPerson,a.newbanid as receiveBanid,                        
         CASE WHEN ISNULL(b.newBaseScore,0)>0 THEN b.newBaseScore                         
              WHEN ABS(ISNULL(b.addBaseScorePercent,0))>0 THEN a.generalScore*(1+b.addBaseScorePercent)                      
              ELSE ISNULL(a.generalScore,0)                         
         END AS generalScore,                        
         (CASE WHEN ISNULL(b.newBaseScore,0)>0 THEN b.newBaseScore                         
               WHEN ISNULL(b.addBaseScorePercent,0)>0 THEN a.generalScore*(1+b.addBaseScorePercent)                        
               ELSE ISNULL(a.generalScore,0)                         
          END)*0.3 AS qtyScore,                  
        a.BanxingScore,a.CollartypeScore,                  
        a.Design_styleScore,a.DresslengthScore,                  
        a.FabcharacterScore,a.FabnameScore,                                                                
        a.SexTypeScore,a.SleeveLengthScore,                  
        a.SleevetypeScore,a.Styletype2Score,                  
        a.ThicknessScore,a.Waist_typeScore                                                                            
  INTO #tmpQtyScore                                                                
  FROM #tmpReceiveScore a LEFT JOIN                        
       Paper_Perform_newBaseScore b ON a.newbanid=b.banid                                                                
  WHERE 1=1                                                                
 
           
 SELECT *          
 INTO #tmpPaperQat FROM          
 (                                                                 
  SELECT DISTINCT a.papermanager,a.PMPerson,a.newbanid,d.paperRedoCount                                                                
  FROM (                                
     --纸样资料最后一次‘落单’资讯                                
     SELECT papermanager,PMPerson,newbanid,MIN(qsdate) qsdate                                
       FROM(                                
           select a.papermanager,a.PMPerson,a.newbanid,a.qsdate                                 
           from PPPaperDept a(nolock)                                
           where a.bantype='落单'    
             and a.qsdate>=dsg_bi.dbo.Calc_PaperTryFirstOK(a.newbanid) --签收时间须在试衣OK之后                                
           UNION                                
           select d.seniordesc,b.ComDateUser,c.newbanid,b.qsdate                                 
           from PPPaperDept_detail b(nolock) INNER JOIN                                 
                PPPaperDept c(nolock) ON b.PP_Number=c.PP_Number LEFT JOIN                                 
                s_users d(nolock) ON b.ComDateUser=d.username                                
           where c.bantype='落单'     
             and b.qsdate>=dsg_bi.dbo.Calc_PaperTryFirstOK(c.newbanid) --签收时间须在试衣OK之后                                   
           )a                                  
     GROUP BY  papermanager,PMPerson,newbanid                                   
   ) a  INNER JOIN                                                                     
     b_styleno c(nolock) on a.newbanid=c.banid INNER JOIN                                 
     --最早一次试衣OK资讯                                                               
    (SELECT banid,paperRedoCount,min(scandatetime) scandatetime                                               
     FROM dsg_bi.dbo.Ban_RedoInfo (nolock)                                                                
     WHERE ISNULL(IsResultOk,'')='1'            
       AND bantypedesc='落单'                                 
     GROUP BY banid,paperRedoCount                                                                
    )d on a.newbanid=d.banid                                                                
  WHERE 1=1 and a.qsdate>=d.scandatetime   --签收时间须在试衣OK之后          
  
   and a.qsdate>='2017-08-01'
   and a.qsdate<='2017-08-25 23:59:59'
             
  UNION ALL           
  SELECT DISTINCT a.papermanager,a.PMPerson,a.newbanid,d.paperRedoCount                                                                 
  FROM (                                
     --纸样资料最后一次‘制单’资讯                                
     SELECT papermanager,PMPerson,newbanid,Min(qsdate) qsdate                                
       FROM(                                
           select a.papermanager,a.PMPerson,a.newbanid,a.qsdate                                 
           from PPPaperDept a(nolock)                                
           where a.bantype='制单'    
             and a.qsdate>=dsg_bi.dbo.Calc_PaperTryFirstOK(a.newbanid) --签收时间须在试衣OK之后                                
           UNION                                
           select d.seniordesc,b.ComDateUser,c.newbanid,b.qsdate                                 
           from PPPaperDept_detail b(nolock) INNER JOIN                                 
                PPPaperDept c(nolock) ON b.PP_Number=c.PP_Number LEFT JOIN                                 
                s_users d(nolock) ON b.ComDateUser=d.username                                
           where c.bantype='制单'    
             and b.qsdate>=dsg_bi.dbo.Calc_PaperTryFirstOK(c.newbanid) --签收时间须在试衣OK之后                                    
           )a                                  
     GROUP BY  papermanager,PMPerson,newbanid                                   
     ) a  INNER JOIN                                                                     
     b_styleno c(nolock) on a.newbanid=c.banid INNER JOIN                                 
     --最早一次试衣OK资讯                                                               
    (SELECT banid,paperRedoCount,min(scandatetime) scandatetime                                                
     FROM dsg_bi.dbo.Ban_RedoInfo (nolock)                                                                
     WHERE ISNULL(IsResultOk,'')='1'            
       AND bantypedesc='制单'                                 
     GROUP BY banid,paperRedoCount                                                                
    )d on a.newbanid=d.banid                                                                
  WHERE 1=1 and a.qsdate>=d.scandatetime   --签收时间须在试衣OK之后                  
 
   and a.qsdate>='2017-08-01'
   and a.qsdate<='2017-08-25 23:59:59'
)a           
 
                                   
  SELECT a.papermanager,a.PMPerson,a.newbanid,                                                                
   ISNULL(s01.BanxingScore,0)+ISNULL(s02.CollartypeScore,0)+ISNULL(s03.Design_styleScore,0)+                             
   ISNULL(s04.DresslengthScore,0)+ISNULL(s05.FabcharacterScore,0)+ISNULL(s06.FabnameScore,0)+                                                                
   ISNULL(s07.SexTypeScore,0)+ISNULL(s08.SleeveLengthScore,0)+ISNULL(s09.SleevetypeScore,0)+                                                                
   ISNULL(s10.Styletype2Score,0)+ISNULL(s11.ThicknessScore,0)+ISNULL(s12.Waist_typeScore,0)                                               
   AS generalScore,                  
   ISNULL(s01.BanxingScore,0) BanxingScore,ISNULL(s02.CollartypeScore,0) CollartypeScore,                  
   ISNULL(s03.Design_styleScore,0) Design_styleScore,ISNULL(s04.DresslengthScore,0) DresslengthScore,                  
   ISNULL(s05.FabcharacterScore,0) FabcharacterScore,ISNULL(s06.FabnameScore,0) FabnameScore,                                                                
   ISNULL(s07.SexTypeScore,0) SexTypeScore,ISNULL(s08.SleeveLengthScore,0) SleeveLengthScore,     
   ISNULL(s09.SleevetypeScore,0) SleevetypeScore,ISNULL(s10.Styletype2Score,0) Styletype2Score,                  
   ISNULL(s11.ThicknessScore,0) ThicknessScore,ISNULL(s12.Waist_typeScore,0) Waist_typeScore                                                                   
  INTO #tmpFinishScore0                                                                 
  FROM #tmpPaperQat a(nolock) INNER JOIN                                                                 
    dsg_bi.dbo.Ban_Lastver_MBT07 b(nolock) on a.newbanid=b.matioid INNER JOIN                                                                
    ban_makebill_head c(nolock) on b.mb_number=c.mb_number LEFT JOIN                                                       
    Paper_Banxing s01(nolock) on c.Stylenametype=s01.Stylenametype AND c.banxing=s01.banxing LEFT JOIN                                                                
    Paper_Collartype s02(nolock) on c.Stylenametype=s02.Stylenametype AND c.Collartype=s02.Collartype LEFT JOIN                                                                
    Paper_Design_style s03(nolock) on c.Stylenametype=s03.Stylenametype AND c.Design_style=s03.Design_style LEFT JOIN                                
    Paper_Dresslength s04(nolock) on c.Stylenametype=s04.Stylenametype AND c.BX_length=s04.Dresslength LEFT JOIN                                                                
    Paper_Fabcharacter s05(nolock) on c.Stylenametype=s05.Stylenametype AND c.Fabcharacter=s05.Fabcharacter LEFT JOIN                                                                
    Paper_Fabname s06(nolock) on c.Stylenametype=s06.Stylenametype AND c.Fabname=s06.Fabname LEFT JOIN                                 
    Paper_SexType s07(nolock) on c.Stylenametype=s07.Stylenametype AND c.Sex=s07.SexType LEFT JOIN                                                                
    Paper_SleeveLength s08(nolock) on c.Stylenametype=s08.Stylenametype AND c.outsidesleeve=s08.SleeveLength LEFT JOIN                                                                
    Paper_Sleevetype s09(nolock) on c.Stylenametype=s09.Stylenametype AND c.Pants_type=s09.Sleevetype LEFT JOIN                                                       
    Paper_Styletype2 s10(nolock) on c.Stylenametype=s10.Stylenametype AND c.Styletype2=s10.Styletype2 LEFT JOIN                                                                
    Paper_Thickness s11(nolock) on c.Stylenametype=s11.Stylenametype AND c.Thickness=s11.Thickness LEFT JOIN                                                                
    Paper_Waist_type s12(nolock) on c.Stylenametype=s12.Stylenametype AND c.Waist_type=s12.Waist_type                                                                
  WHERE 1=1                                           
 
                                                                 
  SELECT a.papermanager,a.PMPerson,a.newbanid,                                                                
   CASE WHEN ISNULL(b.newBaseScore,0)>0 THEN b.newBaseScore                         
        WHEN ABS(ISNULL(b.addBaseScorePercent,0))>0 THEN a.generalScore*(1+b.addBaseScorePercent)                        
        ELSE ISNULL(a.generalScore,0)                         
   END AS generalScore,                  
   a.BanxingScore,a.CollartypeScore,                  
   a.Design_styleScore,a.DresslengthScore,                  
   a.FabcharacterScore,a.FabnameScore,                                                                
   a.SexTypeScore,a.SleeveLengthScore,                  
   a.SleevetypeScore,a.Styletype2Score,                  
   a.ThicknessScore,a.Waist_typeScore                                                                    
  INTO #tmpFinishScore                                                                 
  FROM #tmpFinishScore0 a LEFT JOIN                        
       Paper_Perform_newBaseScore b(nolock) ON a.newbanid=b.banid                                                                
  WHERE 1=1                                                                
 
                                                                
  SELECT c.papermanager,c.PMPerson,c.newbanid as finishBanid,c.paperRedoCount,d.generalScore,                                                                
   CASE WHEN (ISNULL(c.paperRedoCount,0)>=0) and (ISNULL(c.paperRedoCount,0)<1) THEN d.generalScore*0.7  -- 一次通过                                                                
     WHEN (ISNULL(c.paperRedoCount,0)>=1) and (ISNULL(c.paperRedoCount,0)<2) THEN d.generalScore*0.3  -- 二次通过                                                               
     WHEN (ISNULL(c.paperRedoCount,0)>=2) and (ISNULL(c.paperRedoCount,0)<3) THEN d.generalScore*0.1  -- 三次通过                                                                
     WHEN (ISNULL(c.paperRedoCount,0)>=3) and (ISNULL(c.paperRedoCount,0)<4) THEN d.generalScore*(-0.3) -- 四次通过                                                                
     WHEN (ISNULL(c.paperRedoCount,0)>=4) and (ISNULL(c.paperRedoCount,0)<5) THEN d.generalScore*(-0.8) -- 五次通过                                                                
     WHEN ISNULL(c.paperRedoCount,0)>=5 THEN d.generalScore*(-1)  -- 六次通过                                                                
   END AS qatScore,                  
   d.BanxingScore,d.CollartypeScore,                  
   d.Design_styleScore,d.DresslengthScore,                  
   d.FabcharacterScore,d.FabnameScore,                                                                
   d.SexTypeScore,d.SleeveLengthScore,                  
   d.SleevetypeScore,d.Styletype2Score,                  
   d.ThicknessScore,d.Waist_typeScore                                                                    
  INTO #tmpQatScore                                                              
  FROM #tmpPaperQat c LEFT JOIN                                                                
    #tmpFinishScore d on c.papermanager=d.papermanager AND c.PMPerson=d.PMPerson AND c.newbanid=d.newbanid                                                                
  WHERE 1=1                                                                
 
                                                                 
  SELECT DISTINCT a.paperMgr,a.paperEngineer,a.sc_number,a.styleno,                            
     CASE WHEN isnull(a.banid,'')<>'' THEN a.banid ELSE b.banid END as banid,                          
     b.PPType                                                               
  INTO #tmpPaperOtherQty                                                                 
  FROM PaperStylenoState a(nolock) INNER JOIN                                   
    b_styleno b(nolock) on a.sc_number=b.sc_number                                                                  
  WHERE 1=1                                    
    AND ISNULL(a.paperEngineer,'')<>''                                                                        
 
   and a.finishDate>='2017-08-01'
   and a.finishDate<='2017-08-25 23:59:59'
                                                                 
  SELECT a.paperMgr as papermanager,a.paperEngineer as PMPerson,a.banid,a.styleno,a.PPType,                                                                
   ISNULL(s01.BanxingScore,0)+ISNULL(s02.CollartypeScore,0)+ISNULL(s03.Design_styleScore,0)+                                         
   ISNULL(s04.DresslengthScore,0)+ISNULL(s05.FabcharacterScore,0)+ISNULL(s06.FabnameScore,0)+                                                                
   ISNULL(s07.SexTypeScore,0)+ISNULL(s08.SleeveLengthScore,0)+ISNULL(s09.SleevetypeScore,0)+                                                 
   ISNULL(s10.Styletype2Score,0)+ISNULL(s11.ThicknessScore,0)+ISNULL(s12.Waist_typeScore,0)                                               
   AS generalScore,                  
   ISNULL(s01.BanxingScore,0) BanxingScore,ISNULL(s02.CollartypeScore,0) CollartypeScore,                  
   ISNULL(s03.Design_styleScore,0) Design_styleScore,ISNULL(s04.DresslengthScore,0) DresslengthScore,                  
   ISNULL(s05.FabcharacterScore,0) FabcharacterScore,ISNULL(s06.FabnameScore,0) FabnameScore,                                                                
   ISNULL(s07.SexTypeScore,0) SexTypeScore,ISNULL(s08.SleeveLengthScore,0) SleeveLengthScore,                  
   ISNULL(s09.SleevetypeScore,0) SleevetypeScore,ISNULL(s10.Styletype2Score,0) Styletype2Score,                  
   ISNULL(s11.ThicknessScore,0) ThicknessScore,ISNULL(s12.Waist_typeScore,0) Waist_typeScore                                         
  INTO #tmpOtherGeneralScore                                                                 
  FROM #tmpPaperOtherQty a(nolock) INNER JOIN                  
    dsg_bi.dbo.Ban_Lastver_MBT07 b(nolock) on Substring(a.banid,1,12)=Substring(b.matioid,1,12) INNER JOIN                                                                
    ban_makebill_head c(nolock) on b.mb_number=c.mb_number LEFT JOIN                                                                
    Paper_Banxing s01(nolock) on c.Stylenametype=s01.Stylenametype AND c.banxing=s01.banxing LEFT JOIN                                                                
    Paper_Collartype s02(nolock) on c.Stylenametype=s02.Stylenametype AND c.Collartype=s02.Collartype LEFT JOIN                                                             
    Paper_Design_style s03(nolock) on c.Stylenametype=s03.Stylenametype AND c.Design_style=s03.Design_style LEFT JOIN                                                                
    Paper_Dresslength s04(nolock) on c.Stylenametype=s04.Stylenametype AND c.BX_length=s04.Dresslength LEFT JOIN                                                                
    Paper_Fabcharacter s05(nolock) on c.Stylenametype=s05.Stylenametype AND c.Fabcharacter=s05.Fabcharacter LEFT JOIN                                                                
    Paper_Fabname s06(nolock) on c.Stylenametype=s06.Stylenametype AND c.Fabname=s06.Fabname LEFT JOIN                                                                
    Paper_SexType s07(nolock) on c.Stylenametype=s07.Stylenametype AND c.Sex=s07.SexType LEFT JOIN                                      
    Paper_SleeveLength s08(nolock) on c.Stylenametype=s08.Stylenametype AND c.outsidesleeve=s08.SleeveLength LEFT JOIN                                                                
    Paper_Sleevetype s09(nolock) on c.Stylenametype=s09.Stylenametype AND c.Pants_type=s09.Sleevetype LEFT JOIN                                                                
    Paper_Styletype2 s10(nolock) on c.Stylenametype=s10.Stylenametype AND c.Styletype2=s10.Styletype2 LEFT JOIN                                                                
    Paper_Thickness s11(nolock) on c.Stylenametype=s11.Stylenametype AND c.Thickness=s11.Thickness LEFT JOIN                                                                
    Paper_Waist_type s12(nolock) on c.Stylenametype=s12.Stylenametype AND c.Waist_type=s12.Waist_type                                                     
  WHERE 1=1                                                                
 
                                             
  SELECT a.papermanager,a.PMPerson,a.banid,a.styleno,a.generalScore,                          
         CASE WHEN (a.PPType='ODM单' OR a.PPType='板型款') THEN a.generalScore*0.3 ELSE a.generalScore*0.2 END AS otherScore,                  
        a.BanxingScore,a.CollartypeScore,                  
        a.Design_styleScore,a.DresslengthScore,                  
        a.FabcharacterScore,a.FabnameScore,                                                                
        a.SexTypeScore,a.SleeveLengthScore,                  
        a.SleevetypeScore,a.Styletype2Score,                  
        a.ThicknessScore,a.Waist_typeScore                            
  INTO #tmpOtherScore                                                                
  FROM #tmpOtherGeneralScore a                                                                 
  WHERE 1=1                                                                
 
                                                                
     SELECT papermanager,PMPerson,Banid,ISNULL(paperRedoCount,0) as paperRedoCount,                              
            ISNULL(generalScore,0) AS generalScore,                              
            ISNULL(qtyScore,0) AS qtyScore,ISNULL(qatScore,0) AS qatScore,                              
            ISNULL(otherScore,0) AS otherScore                            
     INTO #tmpAdjustScore                       
     FROM Paper_Perform_Adjust a(nolock)                                                                 
  WHERE 1=1                                                                
 
   and a.activeDate>='2017-08-01'
   and a.activeDate<='2017-08-25 23:59:59'
                                                                
  SELECT '未分配部门' as PaperDept,papermanager,PMPerson,receiveBanid as Banid,paperRedoCount,generalScore,                                                                
   SUM(qtyScore) AS qtyScore,SUM(qatScore) AS qatScore,SUM(otherScore) AS otherScore,                                    
   SUM(qtyScore+qatScore+otherScore) AS totalScore,SUM(qtyScore+qatScore+otherScore)*50 AS totalAmont,                          
   SUM(receiveQty) as receiveQty,SUM(finishQty) as finishQty,SUM(otherQty) as otherQty,                  
          BanxingScore,CollartypeScore,Design_styleScore,DresslengthScore,                  
          FabcharacterScore,FabnameScore,SexTypeScore,SleeveLengthScore,                  
          SleevetypeScore,Styletype2Score,ThicknessScore,Waist_typeScore                     
  INTO #tmpResultDetail                                                                  
  FROM                                                                
  (                                                                
    SELECT papermanager,PMPerson,receiveBanid,generalScore,                                                        
          SUM(paperRedoCount) as paperRedoCount,                                                                
          SUM(qtyScore) as qtyScore,SUM(qatScore) as qatScore,SUM(otherScore) as otherScore,                          
          SUM(receiveQty) as receiveQty,SUM(finishQty) as finishQty,SUM(otherQty) as otherQty,                  
          BanxingScore,CollartypeScore,Design_styleScore,DresslengthScore,                  
          FabcharacterScore,FabnameScore,SexTypeScore,SleeveLengthScore,                  
          SleevetypeScore,Styletype2Score,ThicknessScore,Waist_typeScore                                              
    FROM                                
    (                                                        
     SELECT a.papermanager,a.PMPerson,                          
            a.receiveBanid,                          
            0 as paperRedoCount,                                                                
            ISNULL(a.generalScore,0) as generalScore,                                    
            ISNULL(a.qtyScore,0) as qtyScore,0 as qatScore,0 as otherScore,                          
            1 as receiveQty,0 as finishQty,0 as otherQty,                  
            BanxingScore,CollartypeScore,Design_styleScore,DresslengthScore,                  
            FabcharacterScore,FabnameScore,SexTypeScore,SleeveLengthScore,                  
            SleevetypeScore,Styletype2Score,ThicknessScore,Waist_typeScore                                                 
     FROM #tmpQtyScore a                                      
     UNION                                                                
     SELECT b.papermanager,b.PMPerson,                          
            b.finishBanid,                          
            ISNULL(paperRedoCount,0) as paperRedoCount,                                                             
            ISNULL(b.generalScore,0) as generalScore,                                    
            0 as qtyScore,ISNULL(b.qatScore,0) as qatScore,0 as otherScore,                          
            0 as receiveQty,1 as finishQty,0 as otherQty,                  
            BanxingScore,CollartypeScore,Design_styleScore,DresslengthScore,                  
            FabcharacterScore,FabnameScore,SexTypeScore,SleeveLengthScore,                  
            SleevetypeScore,Styletype2Score,ThicknessScore,Waist_typeScore                                                                              
     FROM #tmpQatScore b                                                          
     UNION                                                                
     SELECT c.papermanager,c.PMPerson,                          
            c.styleno as otherBanid,                          
            0 as paperRedoCount,                                                             
     ISNULL(c.generalScore,0) as generalScore,                                    
            0 as qtyScore,0 as qatScore,ISNULL(c.otherScore,0) as otherScore,                          
            0 as receiveQty,0 as finishQty,1 as otherQty,                  
            BanxingScore,CollartypeScore,Design_styleScore,DresslengthScore,                  
            FabcharacterScore,FabnameScore,SexTypeScore,SleeveLengthScore,                  
            SleevetypeScore,Styletype2Score,ThicknessScore,Waist_typeScore                                                  
     FROM #tmpOtherScore c                              
     UNION                              
     SELECT papermanager,PMPerson,                          
            Banid,                          
            ISNULL(paperRedoCount,0) as paperRedoCount,                              
            ISNULL(generalScore,0) AS generalScore,                              
            ISNULL(qtyScore,0) AS qtyScore,ISNULL(qatScore,0) AS qatScore,                              
            ISNULL(otherScore,0) AS otherScore,                          
            0 as receiveQty,0 as finishQty,1 as otherQty,                  
            0 as BanxingScore,0 as CollartypeScore,0 as Design_styleScore,0 as DresslengthScore,                  
            0 as FabcharacterScore,0 as FabnameScore,0 as SexTypeScore,0 as SleeveLengthScore,                  
            0 as SleevetypeScore,0 as Styletype2Score,0 as ThicknessScore,0 as Waist_typeScore                                           
     FROM #tmpAdjustScore d                                                
    )w                                                        
    GROUP BY papermanager,PMPerson,receiveBanid,generalScore,                  
          BanxingScore,CollartypeScore,Design_styleScore,DresslengthScore,                  
          FabcharacterScore,FabnameScore,SexTypeScore,SleeveLengthScore,                  
          SleevetypeScore,Styletype2Score,ThicknessScore,Waist_typeScore                                                                    
  )z                                                               
  GROUP BY papermanager,PMPerson,receiveBanid,paperRedoCount,generalScore ,                  
          BanxingScore,CollartypeScore,Design_styleScore,DresslengthScore,                  
          FabcharacterScore,FabnameScore,SexTypeScore,SleeveLengthScore,                  
          SleevetypeScore,Styletype2Score,ThicknessScore,Waist_typeScore                         
  ORDER BY PMPerson,receiveBanid                                                                
          
                                                                  
  UPDATE #tmpResultDetail SET PaperDept='纸样一部'                                                                
  WHERE papermanager in('刘健华','刘家高','刘怀球','刘召雄')                                                            
                                                                  
  UPDATE #tmpResultDetail SET PaperDept='纸样二部'                                                                
  WHERE papermanager in('郭雄坚','金伦澈','潘志通','张国英','古永新','谢树全','赖剑辉','陈奕儒','钟旺生','王丽娟','李爱民','')                                                                   
                                                                
  UPDATE #tmpResultDetail SET PaperDept='造型部'                                                                
  WHERE papermanager in('吴生科','赵重起')                                                                  
 
                                                                
   SELECT * FROM #tmpResultDetail                                                         
    WHERE 1=1                                                         
      AND (ABS(ISNULL(qtyScore,0))>0 OR ABS(ISNULL(qatScore,0))>0 OR ABS(ISNULL(otherScore,0))>0)                                            
    ORDER BY PaperDept DESC,papermanager,PMPerson,Banid                                                                
  
