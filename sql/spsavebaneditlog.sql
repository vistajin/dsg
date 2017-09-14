SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spsavebaneditlog]                                              
  @mbnumber varchar(100),                                              
  @loginid   varchar(20),                                              
  @edittype  varchar(20)                                              
as     
/*
  by Mark 2015-9-20 
  将 insert into ban_makebill_head_log  等14条插入语句，
--修改为 insert into dsg_log.dbo.ban_makebill_head_log
*/                                         
begin                                            
  declare @ver int                                         
                                          
  select @ver=MAX(ISNULL(editver,0))+1 from ban_makebill_head_log(nolock) where mb_number=@mbnumber                                        
                                          
                          
 --1.板单头                                            
 --insert into ban_makebill_head_log  
 insert into dsg_log.dbo.ban_makebill_head_log                                          
 (banno,bantypeid,bantypename,boxmarkremark,clothremark,clothverremark,confirmdate,confirmflag,confirmuser,costamt,costprice,                                          
countitemuser,custid,custname,designnm,devdept,dosamplenm,estimatedate,flconfirmdate,flconfirmflag,flconfirmuser,goodsperiod,                                          
indate,indept,inuser,itemremark,itemverremark,justboxmark,lockdate,lockuser,lockusername,matioid,                                          
mb_number,mbtypeid,mbtypename,mbversion,mlusecheckdate,mlusecheckflag,mlusecheckuser,                                          
mluseconfirmdate,mluseconfirmflag,mluseconfirmuser,modifydate,modifyuser,otherboxmark,papersamplenm,--picture1,picture2,                                          
pictureconfirmdate,pictureconfirmflag,pictureconfirmuser,pictureremark,picturespecailremark,pictureverisonremark,                                          
price,putyarduser,qty,qtyconfirmdate,qtyconfirmflag,qtyconfirmuser,remark,remark_cfx,remark_cmm,remark_dp,remark_dz,                                          
remark_fxqt,remark_mlk,remark_mtqt,remark_nk,remark_nm,remark_nmx,remark_qt,remark_rs,remark_sbx,remark_wbqt,remark_xs,                                          
remark_xsff,remark_xslc,remark_xsm,remark_yh,remark_zm,requiredate,season,series,sideboxmark,sizecheckuser,sizeconfirmdate,                                          
sizeconfirmflag,sizeconfirmuser,sizecount,sizedesc,sizedesunit,sizeedituser,sizegroup,sizepaperuser,stylecate_code,                                          
stylecate_desc,styledesc,styleno,trackgroupnm,tracknm,unit,vermodifydate,vermodifyuser,verremark,workdesconfirmdate,                                          
workdesconfirmflag,workdesconfirmuser,xsverremark,zlbillconfirmdate,zlbillconfirmflag,zlbillconfirmuser,zlconfirmdate,                                          
zlconfirmflag,zlconfirmuser,zlusecheckdate,zlusecheckflag,zlusecheckuser,zluseconfirmdate,zluseconfirmflag,zluseconfirmuser,                                          
batchno,zhenzhong,jima,stylenoverremark,sizeseriesid,isdlflag,dsgdeptconfirmflag,dsgdeptconfirmuser,dsgdeptconfirmdate,                           
sc_number,xxxfield,isforeflag,basesizem ,           
isbefflag,dsgdeptzjconfirmflag,dsgdeptzjconfirmdate, dsgdeptzjconfirmuser, isodm,seriesid,seriesname,styletype,zhekou,sex,design,          
dsgdeptname,cate_code,kuanlei,zhuti,dlseriesname,dlseriesid,banxing,secang,chanpinjiegou,Wash,xs,clientelestyleno,clientelestyl,          
ybinfo,isyb,iscontinuestyleno,iscontinue,yatang,qitang,miantang,isyxh1,isyxh,unitprice,cancelapplyflag,cancelapplyuser,cancelapplydate,          
cancelmanagercheckdate,cancelmanagercheckflag,cancelmanagercheckuser,cancelzjcheckdate,cancelzjcheckflag,cancelzjcheckuser,          
tcdataremark,PPType,iscolorqty,tracknmid,trackgroupnmid,papersamplenmid,dosamplenmid,sizecheckuserid,putyarduserid,sizepaperuserid,          
countitemuserid,trackconfirmdate,trackconfirmflag,trackconfirmuser,trackmanagerconfirmdate,trackmanagerconfirmflag,trackmanagerconfirmuser,          
tracknoagreedate,tracknoagreeuser,inuserid,indeptid,mbversiongd,taoztype,baneditinf,taozremark,sddno,sddname,sdddesc,trackdept,           
sjsconfirmflag,sjsconfirmdate,sjsconfirmuser,filecheckdeptflag,filecheckdeptdate,filecheckdeptuser,verremarkseason,isyxh2,       
issjbdlflag,filecheckdeptconfirmdate,filecheckdeptconfirmflag,filecheckdeptconfirmuser,iszyeditflag,ismjseditflag,ismzbeditflag,ismbgdeditflag,         
tracknoagreeremark,      
pyflag, pianyinflag, zhirongflag, tazuanflag, yinhuaotherflag, mjxflag, shenxflag, dingzhuflag, xiuhuaotherflag,    
 bianjiflag, peipidaiflag,  updatereason,reasondept, makedeptname,makedeptdesc,                         
editusername,editdatetime,edittype,editver)                                            
 select  banno,bantypeid,bantypename,boxmarkremark,clothremark,clothverremark,confirmdate,confirmflag,confirmuser,costamt,costprice,                                          
countitemuser,custid,custname,designnm,devdept,dosamplenm,estimatedate,flconfirmdate,flconfirmflag,flconfirmuser,goodsperiod,                                          
indate,indept,inuser,itemremark,itemverremark,justboxmark,lockdate,lockuser,lockusername,matioid,                                          
mb_number,mbtypeid,mbtypename,mbversion,mlusecheckdate,mlusecheckflag,mlusecheckuser,                                          
mluseconfirmdate,mluseconfirmflag,mluseconfirmuser,modifydate,modifyuser,otherboxmark,papersamplenm,--picture1,picture2,                                          
pictureconfirmdate,pictureconfirmflag,pictureconfirmuser,pictureremark,picturespecailremark,pictureverisonremark,                                          
price,putyarduser,qty,qtyconfirmdate,qtyconfirmflag,qtyconfirmuser,remark,remark_cfx,remark_cmm,remark_dp,remark_dz,                                          
remark_fxqt,remark_mlk,remark_mtqt,remark_nk,remark_nm,remark_nmx,remark_qt,remark_rs,remark_sbx,remark_wbqt,remark_xs,                                          
remark_xsff,remark_xslc,remark_xsm,remark_yh,remark_zm,requiredate,season,series,sideboxmark,sizecheckuser,sizeconfirmdate,                                          
sizeconfirmflag,sizeconfirmuser,sizecount,sizedesc,sizedesunit,sizeedituser,sizegroup,sizepaperuser,stylecate_code,                                          
stylecate_desc,styledesc,styleno,trackgroupnm,tracknm,unit,vermodifydate,vermodifyuser,verremark,workdesconfirmdate,                                    
workdesconfirmflag,workdesconfirmuser,xsverremark,zlbillconfirmdate,zlbillconfirmflag,zlbillconfirmuser,zlconfirmdate,                                          
zlconfirmflag,zlconfirmuser,zlusecheckdate,zlusecheckflag,zlusecheckuser,zluseconfirmdate,zluseconfirmflag,zluseconfirmuser,                                          
batchno,zhenzhong,jima,stylenoverremark  ,sizeseriesid,isdlflag,dsgdeptconfirmflag,dsgdeptconfirmuser,dsgdeptconfirmdate,                              
sc_number,xxxfield,isforeflag,basesizem ,             
isbefflag,dsgdeptzjconfirmflag,dsgdeptzjconfirmdate, dsgdeptzjconfirmuser, isodm,seriesid,seriesname,styletype,zhekou,sex,design,          
dsgdeptname,cate_code,kuanlei,zhuti,dlseriesname,dlseriesid,banxing,secang,chanpinjiegou,Wash,xs,clientelestyleno,clientelestyl,          
ybinfo,isyb,iscontinuestyleno,iscontinue,yatang,qitang,miantang,isyxh1,isyxh,unitprice,cancelapplyflag,cancelapplyuser,cancelapplydate,          
cancelmanagercheckdate,cancelmanagercheckflag,cancelmanagercheckuser,cancelzjcheckdate,cancelzjcheckflag,cancelzjcheckuser,          
tcdataremark,PPType,iscolorqty,tracknmid,trackgroupnmid,papersamplenmid,dosamplenmid,sizecheckuserid,putyarduserid,sizepaperuserid,          
countitemuserid,trackconfirmdate,trackconfirmflag,trackconfirmuser,trackmanagerconfirmdate,trackmanagerconfirmflag,trackmanagerconfirmuser,          
tracknoagreedate,tracknoagreeuser,inuserid,indeptid,mbversiongd,taoztype,baneditinf,taozremark,sddno,sddname,sdddesc,trackdept,           
sjsconfirmflag,sjsconfirmdate,sjsconfirmuser,filecheckdeptflag,filecheckdeptdate,filecheckdeptuser,verremarkseason,isyxh2,        
issjbdlflag,filecheckdeptconfirmdate,filecheckdeptconfirmflag,filecheckdeptconfirmuser,iszyeditflag,ismjseditflag,ismzbeditflag,ismbgdeditflag,         
tracknoagreeremark,      
pyflag, pianyinflag, zhirongflag, tazuanflag, yinhuaotherflag, mjxflag, shenxflag, dingzhuflag, xiuhuaotherflag,    
 bianjiflag, peipidaiflag,  updatereason,reasondept, makedeptname,makedeptdesc,                            
@loginid,GETDATE(), @edittype,@ver                                              
 from ban_makebill_head (nolock) where mb_number=@mbnumber                                         
                           
                                            
 --2.物料清单                                            
 --insert into ban_makebill_itemlist_log
 insert into dsg_log.dbo.ban_makebill_itemlist_log
 (afterjumprule,assigncolorcaseid,assigncolorid,assignsizeid,assigntype,basesize,basesizeuseqty,clothpactid,                                          
colorrate,colortype,consultmodel,costprice,des,des1,des10,des2,des3,des4,des5,des6,des7,des8,des9,element,extendsrateh,extendsratev,                                          
extractqty,fgweight,gweight,ifcasesize,ifmao,isaffirm,isfillcamlet,ispastesample,isupdatesizenum,item_code,item_desc,itemtype,itemtypedesc,                                          
jingsuo,jumprate,jumprule,jumprule2,marklength,matclass,matusetype,mb_line,mb_number,model,modifydate,modifydes,modifynm,msize1,                                          
msize10,msize11,msize12,msize13,msize14,msize15,msize16,msize17,msize18,msize19,msize2,msize20,msize3,msize4,msize5,msize6,msize7,                                          
msize8,msize9,multmatcolor,orderid,packqty,partid,perpackunituseqty,pogroup,prejumprule,provcode,providerid,qsize1,qsize10,qsize11,                                          
qsize12,qsize13,qsize14,qsize15,qsize16,qsize17,qsize18,qsize19,qsize2,qsize20,qsize3,qsize4,qsize5,qsize6,qsize7,qsize8,qsize9,qty,                                          
requireqty,sourcetype,sourcetypedesc,unit,unitofuse,unituseqty,useqty,useunsure,usrnm,wasterate,wasteratenew,weisuo,xgweight,zhisuo,                                          
remotematcode,remotematname,des3name,partidname,dlqty,purgroup,matsizeid,dhqhbflag,dhqhbremark,                      
editusername,editdatetime,edittype,editver)                                              
 select afterjumprule,assigncolorcaseid,assigncolorid,assignsizeid,assigntype,basesize,basesizeuseqty,clothpactid,                                          
colorrate,colortype,consultmodel,costprice,des,des1,des10,des2,des3,des4,des5,des6,des7,des8,des9,element,extendsrateh,extendsratev,                                          
extractqty,fgweight,gweight,ifcasesize,ifmao,isaffirm,isfillcamlet,ispastesample,isupdatesizenum,item_code,item_desc,itemtype,itemtypedesc,                                          
jingsuo,jumprate,jumprule,jumprule2,marklength,matclass,matusetype,mb_line,mb_number,model,modifydate,modifydes,modifynm,msize1,                                          
msize10,msize11,msize12,msize13,msize14,msize15,msize16,msize17,msize18,msize19,msize2,msize20,msize3,msize4,msize5,msize6,msize7,                                          
msize8,msize9,multmatcolor,orderid,packqty,partid,perpackunituseqty,pogroup,prejumprule,provcode,providerid,qsize1,qsize10,qsize11,                                          
qsize12,qsize13,qsize14,qsize15,qsize16,qsize17,qsize18,qsize19,qsize2,qsize20,qsize3,qsize4,qsize5,qsize6,qsize7,qsize8,qsize9,qty,                                          
requireqty,sourcetype,sourcetypedesc,unit,unitofuse,unituseqty,useqty,useunsure,usrnm,wasterate,wasteratenew,weisuo,xgweight,zhisuo,                                          
remotematcode,remotematname,des3name,partidname,dlqty,purgroup,matsizeid,dhqhbflag,dhqhbremark,                      
@loginid,GETDATE(), @edittype,@ver                                              
 from ban_makebill_itemlist (nolock) where mb_number=@mbnumber          
                                                                                         
                                   
 --3.物料清单颜色                                            
 --insert into ban_makebill_itemcolor_log
 insert into dsg_log.dbo.ban_makebill_itemcolor_log
 (cupno,isassigncolor,item_code,item_desc,itemcolordesc,itemcolorid,lsh,mb_line,mb_number,                                          
modifydate,modifydes,modifynm,stampcolordesc,stampcolorid,stylecolordesc,stylecolorid,washedcolordesc,washedcolorid,                            
digestionstoreflag,digestionstockflag ,ishasbbflag, editusername,editdatetime,edittype,editver)                                              
 select cupno,isassigncolor,item_code,item_desc,itemcolordesc,itemcolorid,lsh,mb_line,mb_number,                                          
modifydate,modifydes,modifynm,stampcolordesc,stampcolorid,stylecolordesc,stylecolorid,washedcolordesc,washedcolorid,                            
digestionstoreflag,digestionstockflag ,ishasbbflag,@loginid,GETDATE(), @edittype ,@ver                                             
 from ban_makebill_itemcolor (nolock) where mb_number=@mbnumber                                             
                                                                   
                          
 --4.物料清单图片                                            
 --insert into ban_makebill_itemlist_pic_log   
 insert into dsg_log.dbo.ban_makebill_itemlist_pic_log                                            
 select *,@loginid,GETDATE(), @edittype,@ver                                              
 from ban_makebill_itemlist_pic (nolock) where mb_number=@mbnumber                                             
                                        
                                           
 --5.数量                                            
 --insert into ban_makebill_goods_log
 insert into dsg_log.dbo.ban_makebill_goods_log
 (color_desc,color_name,custcolorname,mb_line,mb_number,qty,remark,size1,size10,size11,size12,size13,                                          
size14,size15,size16,size17,size18,size19,size2,size20,size3,size4,size5,size6,size7,size8,size9,          
istouban,iscancelcolor,isqs,          
editusername,editdatetime,edittype,editver)                                              
 select color_desc,color_name,custcolorname,mb_line,mb_number,qty,remark,size1,size10,size11,size12,size13,                                          
size14,size15,size16,size17,size18,size19,size2,size20,size3,size4,size5,size6,size7,size8,size9,          
istouban,iscancelcolor,isqs,          
@loginid,GETDATE(), @edittype,@ver                                              
 from ban_makebill_goods (nolock) where mb_number=@mbnumber                                             
                                            
                                             
 --6.嵌套配方                                            
 --insert into ban_makebill_qiantao_log
 insert into dsg_log.dbo.ban_makebill_qiantao_log
 (assigncolor,des3,element,ifcase,item_code,item_desc,itemtype,mb_itemline,mb_line,mb_number,                                          
modifydes,partid,posid,posname,remark,qsize1,qsize10,qsize11,qsize12,qsize13,qsize14,qsize15,qsize16,qsize17,qsize18,qsize19,qsize2,qsize20,                                          
qsize3,qsize4,qsize5,qsize6,qsize7,qsize8,qsize9,sourcetype,unit,wasterate,msize1,msize10,msize11,msize12,msize13,msize14,msize15,msize16,                                          
msize17,msize18,msize19,msize2,msize20,msize3,msize4,msize5,msize6,msize7,msize8,msize9,basesize,matsizeid,editusername,editdatetime,edittype,editver)                                          
 select assigncolor,des3,element,ifcase,item_code,item_desc,itemtype,mb_itemline,mb_line,mb_number,                                          
modifydes,partid,posid,posname,remark,qsize1,qsize10,qsize11,qsize12,qsize13,qsize14,qsize15,qsize16,qsize17,qsize18,qsize19,qsize2,qsize20,                                          
qsize3,qsize4,qsize5,qsize6,qsize7,qsize8,qsize9,sourcetype,unit,wasterate,msize1,msize10,msize11,msize12,msize13,msize14,msize15,msize16,                   
msize17,msize18,msize19,msize2,msize20,msize3,msize4,msize5,msize6,msize7,msize8,msize9,basesize,matsizeid,@loginid,GETDATE(), @edittype ,@ver                                             
 from ban_makebill_qiantao (nolock) where mb_number=@mbnumber                                          
                                             
 --7.嵌套第三层                                            
 --insert into ban_makebill_qiantao_detail_log
 insert into dsg_log.dbo.ban_makebill_qiantao_detail_log
 (mb_number,mb_itemline,mb_line,mb_colorline,isassigncolor,item_code,item_desc,itemtype,parentcolorid,                                          
 parentcolorname,colorid,colorname,modifydes,modifynm,modifydate,editusername,editdatetime,edittype,editver)                                      
 select mb_number,mb_itemline,mb_line,mb_colorline,isassigncolor,item_code,item_desc,itemtype,parentcolorid,                                          
 parentcolorname,colorid,colorname,modifydes,modifynm,modifydate,@loginid,GETDATE(), @edittype,@ver                                              
 from ban_makebill_qiantao_detail (nolock) where mb_number=@mbnumber                                             
                              
                                              
 --8.充绒充棉明细                                            
 --insert into ban_makebill_chrdetail_log
 insert into dsg_log.dbo.ban_makebill_chrdetail_log
 (chtype,item_code,jumptimes,mb_number,mb_line,posid,posname,size1,size10,size11,size12,size13,size14,                                          
size15,size16,size17,size18,size19,size2,size20,size3,size4,size5,size6,size7,size8,size9,          
vermodify,orderid,          
editusername,editdatetime,edittype,editver)                                       
 select chtype,item_code,jumptimes,mb_number,mb_line,posid,posname,size1,size10,size11,size12,size13,size14,                                          
size15,size16,size17,size18,size19,size2,size20,size3,size4,size5,size6,size7,size8,size9,          
vermodify,orderid,          
@loginid,GETDATE(), @edittype,@ver                                              
 from ban_makebill_chrdetail (nolock) where mb_number=@mbnumber                                             
                          
                                                        
 --9.充绒充棉头                                             
 --insert into ban_makebill_chrhead_log
 insert into dsg_log.dbo.ban_makebill_chrhead_log
 (caftbasesize,cbefbasesize,chtype,confirmdate,confirmflag,confirmuser,cravgqty,crtype,                                          
element,indate,inuser,item_code,jumpsize,jumptimes,jumpvalue1,jumpvalue2,mb_number,mb_line,mcmbasesize,mcrbasesize,pengsong,remark,                                          
sizegroup,styleno,wcmbasesize,wcrbasesize,jumpsize2,          
editusername,editdatetime,edittype,editver)                                              
 select caftbasesize,cbefbasesize,chtype,confirmdate,confirmflag,confirmuser,cravgqty,crtype,                                          
element,indate,inuser,item_code,jumpsize,jumptimes,jumpvalue1,jumpvalue2,mb_number,mb_line,mcmbasesize,mcrbasesize,pengsong,remark,                                          
sizegroup,styleno,wcmbasesize,wcrbasesize,jumpsize2,          
@loginid,GETDATE(), @edittype ,@ver                                             
 from ban_makebill_chrhead (nolock) where mb_number=@mbnumber                                             
                      
                                            
 --10.BOM                                            
 --insert into ban_makebill_bom_log
 insert into dsg_log.dbo.ban_makebill_bom_log
 (bansize,bomid,costprice,costtotal,element,gweight,item_code,item_desc,itemcolordesc,itemcolorid,                                          
itemtype,itemtypedesc,matioid,mb_number,model,partid,sourcetype,sourcetypedesc,stampcolordesc,stampcolorid,stylecolordesc,                                          
stylecolorid,styleno,sumqty,unit,useqty,washedcolordesc,washedcolorid,wasterate,          
goodsqty,sjqty,qtymiss,qtyother,          
editusername,editdatetime,edittype,editver)                                              
 select bansize,bomid,costprice,costtotal,element,gweight,item_code,item_desc,itemcolordesc,itemcolorid,                                          
itemtype,itemtypedesc,matioid,mb_number,model,partid,sourcetype,sourcetypedesc,stampcolordesc,stampcolorid,stylecolordesc,                                          
stylecolorid,styleno,sumqty,unit,useqty,washedcolordesc,washedcolorid,wasterate,          
goodsqty,sjqty,qtymiss,qtyother,          
@loginid,GETDATE(), @edittype ,@ver                                             
 from ban_makebill_bom (nolock) where mb_number=@mbnumber                                              
                                         
                                          
 --11.图片                                            
 --insert into ban_makebill_picture_log
 insert into dsg_log.dbo.ban_makebill_picture_log
 (mb_number,mb_line,pictureid,modifydate,remark,editusername,editdatetime,                  
 edittype,editver)                                              
 select mb_number,mb_line,pictureid,modifydate,remark,@loginid,GETDATE(), @edittype ,@ver                                             
 from ban_makebill_picture (nolock) where mb_number=@mbnumber                   
                                            
                                               
 --12.尺寸指示                                            
 --insert into ban_makebill_sizedes_log
 insert into dsg_log.dbo.ban_makebill_sizedes_log
 (aallowerrrange,allowerrrange,asize1,asize10,asize11,asize12,asize13,asize14,asize15,asize16,                                          
asize17,asize18,asize19,asize2,asize20,asize3,asize4,asize5,asize6,asize7,asize8,asize9,dufa,item_code,item_desc,itemtype,                                          
jumpgroup,jumpgrouprule,jumprule_aft,jumprule_bef,mb_line,mb_number,orderid,picturcode,remark,size1,size10,size11,size12,size13,                                          
size14,size15,size16,size17,size18,size19,size2,size20,size3,size4,size5,size6,size7,size8,size9,sizeid,sizename,                                          
washedrealcc,jm,jmname,szseriesid,szseriesconfirm,          
editusername,editdatetime,edittype,editver)                                              
 select aallowerrrange,allowerrrange,asize1,asize10,asize11,asize12,asize13,asize14,asize15,asize16,                                          
asize17,asize18,asize19,asize2,asize20,asize3,asize4,asize5,asize6,asize7,asize8,asize9,dufa,item_code,item_desc,itemtype,                            
jumpgroup,jumpgrouprule,jumprule_aft,jumprule_bef,mb_line,mb_number,orderid,picturcode,remark,size1,size10,size11,size12,size13,                                          
size14,size15,size16,size17,size18,size19,size2,size20,size3,size4,size5,size6,size7,size8,size9,sizeid,sizename,                                          
washedrealcc,jm,jmname,szseriesid,szseriesconfirm,          
@loginid,GETDATE(), @edittype,@ver                                              
 from ban_makebill_sizedes (nolock) where mb_number=@mbnumber                                              
                                          
                                            
 --13.尺寸指示明细                                            
 --insert into ban_makebill_sizedesc_pic_log    
 insert into dsg_log.dbo.ban_makebill_sizedesc_pic_log                                           
 select *,@loginid,GETDATE(), @edittype ,@ver                                             
 from ban_makebill_sizedesc_pic (nolock) where mb_number=@mbnumber                                        
                                            
                                          
 --14.工艺指示明细                                            
 --insert into ban_makebill_workdes_log   
 insert into dsg_log.dbo.ban_makebill_workdes_log                                        
 (cailiaofenlei,chezhong,colororder,dadici,dadidao,des1,des10,des11,des12,des2,des3,des4,des5,des6,des7,des8,des9,                                          
 dibutyci,fszs,gmci,gmdao,gongxu,grdegree,grzhuan,gy,gyid,gyyaodian,jfxl,jg,mark,mb_line,mb_number,mianbutyci,modifydate,                                          
 modifydes,modifynm,orderid,pictureid,process,shouxiu,swzf,tb,tscolor,tydegree,tytime,tzcolorid,usrnm,vlsh,ysci,ysdao,zhenshu,                                          
 zhikou,zhipu,zmcolorid,zuji,picturename,pictureremark,pictrueseriesid,editusername,editdatetime,edittype,editver)                                              
 select cailiaofenlei,chezhong,colororder,dadici,dadidao,des1,des10,des11,des12,des2,des3,des4,des5,des6,des7,des8,des9,                                          
 dibutyci,fszs,gmci,gmdao,gongxu,grdegree,grzhuan,gy,gyid,gyyaodian,jfxl,jg,mark,mb_line,mb_number,mianbutyci,modifydate,                                          
 modifydes,modifynm,orderid,pictureid,process,shouxiu,swzf,tb,tscolor,tydegree,tytime,tzcolorid,usrnm,vlsh,ysci,ysdao,zhenshu,                                     
 zhikou,zhipu,zmcolorid,zuji,picturename,pictureremark,pictrueseriesid,@loginid,GETDATE(), @edittype ,@ver                                       
 from ban_makebill_workdes (nolock) where mb_number=@mbnumber                                            
                                             
                                            
                                                
end
