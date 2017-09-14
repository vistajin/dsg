/****** Object:  Table [dbo].[ban_makebill_head]    Script Date: 2017-09-02 9:57:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ban_makebill_head](
	[mb_number] [varchar](50) NOT NULL,
	[matioid] [varchar](50) NOT NULL,
	[oldBanid] [varchar](50) NULL,
	[mbtypeid] [varchar](20) NULL,
	[mbtypename] [varchar](50) NULL,
	[mbversion] [varchar](10) NULL,
	[vermodifydate] [datetime] NULL,
	[vermodifyuser] [varchar](20) NULL,
	[verremark] [varchar](500) NULL,
	[custid] [varchar](20) NULL,
	[custname] [varchar](200) NULL,
	[indate] [datetime] NULL,
	[inuser] [varchar](20) NULL,
	[modifyuser] [varchar](50) NULL,
	[modifydate] [datetime] NULL,
	[lockuser] [varchar](20) NULL,
	[lockusername] [varchar](50) NULL,
	[lockdate] [datetime] NULL,
	[remark] [varchar](500) NULL,
	[bantypeid] [varchar](50) NULL,
	[bantypename] [varchar](50) NULL,
	[tracknm] [varchar](50) NULL,
	[trackgroupnm] [varchar](50) NULL,
	[confirmflag] [bit] NULL,
	[confirmuser] [varchar](20) NULL,
	[confirmdate] [datetime] NULL,
	[season] [varchar](50) NULL,
	[salesSeason] [varchar](20) NULL,
	[banno] [varchar](50) NULL,
	[unit] [varchar](10) NULL,
	[price] [numeric](18, 4) NULL,
	[series] [varchar](20) NULL,
	[goodsperiod] [varchar](20) NULL,
	[devdept] [varchar](20) NULL,
	[indept] [varchar](30) NULL,
	[styleno] [varchar](50) NULL,
	[styledesc] [varchar](200) NULL,
	[stylecate_code] [varchar](20) NULL,
	[stylecate_desc] [varchar](50) NULL,
	[costprice] [numeric](18, 4) NULL,
	[costamt] [numeric](18, 4) NULL,
	[qty] [int] NULL,
	[requiredate] [datetime] NULL,
	[estimatedate] [datetime] NULL,
	[sizedesunit] [varchar](10) NULL,
	[remark_xsff] [varchar](500) NULL,
	[remark_zm] [varchar](500) NULL,
	[remark_cmm] [varchar](500) NULL,
	[remark_xsm] [varchar](500) NULL,
	[remark_dp] [varchar](500) NULL,
	[remark_mtqt] [varchar](500) NULL,
	[remark_cfx] [varchar](500) NULL,
	[remark_sbx] [varchar](500) NULL,
	[remark_nmx] [varchar](500) NULL,
	[remark_fxqt] [varchar](500) NULL,
	[remark_nm] [varchar](500) NULL,
	[remark_nk] [varchar](500) NULL,
	[remark_dz] [varchar](500) NULL,
	[remark_yh] [varchar](500) NULL,
	[remark_rs] [varchar](500) NULL,
	[remark_wbqt] [varchar](500) NULL,
	[remark_xs] [varchar](500) NULL,
	[remark_xslc] [varchar](500) NULL,
	[remark_mlk] [varchar](500) NULL,
	[remark_qt] [varchar](600) NULL,
	[papersamplenm] [varchar](50) NULL,
	[dosamplenm] [varchar](50) NULL,
	[designnm] [varchar](50) NULL,
	[justboxmark] [varchar](500) NULL,
	[sideboxmark] [varchar](500) NULL,
	[otherboxmark] [varchar](500) NULL,
	[boxmarkremark] [varchar](500) NULL,
	[itemremark] [varchar](500) NULL,
	[clothremark] [varchar](500) NULL,
	[itemverremark] [varchar](500) NULL,
	[clothverremark] [varchar](500) NULL,
	[xsverremark] [varchar](500) NULL,
	[picture1] [image] NULL,
	[picture2] [image] NULL,
	[pictureremark] [varchar](2000) NULL,
	[picturespecailremark] [varchar](2000) NULL,
	[pictureverisonremark] [varchar](500) NULL,
	[pictureconfirmflag] [bit] NULL,
	[pictureconfirmdate] [datetime] NULL,
	[pictureconfirmuser] [varchar](20) NULL,
	[qtyconfirmflag] [bit] NULL,
	[qtyconfirmdate] [datetime] NULL,
	[qtyconfirmuser] [varchar](20) NULL,
	[sizeconfirmflag] [bit] NULL,
	[sizeconfirmuser] [varchar](20) NULL,
	[sizeconfirmdate] [datetime] NULL,
	[sizeDBCheckFlag] [bit] NULL,
	[sizeDBCheckUser] [varchar](20) NULL,
	[sizeDBCheckDate] [datetime] NULL,
	[flconfirmflag] [bit] NULL,
	[flconfirmdate] [datetime] NULL,
	[flconfirmuser] [varchar](20) NULL,
	[zlconfirmflag] [bit] NULL,
	[zlconfirmdate] [datetime] NULL,
	[zlconfirmuser] [varchar](20) NULL,
	[zluseconfirmflag] [bit] NULL,
	[zluseconfirmdate] [datetime] NULL,
	[zluseconfirmuser] [varchar](20) NULL,
	[zlusecheckflag] [bit] NULL,
	[zlusecheckdate] [datetime] NULL,
	[zlusecheckuser] [varchar](20) NULL,
	[zlbillconfirmflag] [bit] NULL,
	[zlbillconfirmuser] [varchar](20) NULL,
	[zlbillconfirmdate] [datetime] NULL,
	[mluseconfirmflag] [bit] NULL,
	[mluseconfirmdate] [datetime] NULL,
	[mluseconfirmuser] [varchar](20) NULL,
	[mlusecheckflag] [bit] NULL,
	[mlusecheckdate] [datetime] NULL,
	[mlusecheckuser] [varchar](20) NULL,
	[sizeedituser] [varchar](20) NULL,
	[putyarduser] [varchar](20) NULL,
	[sizepaperuser] [varchar](20) NULL,
	[sizecheckuser] [varchar](20) NULL,
	[countitemuser] [varchar](20) NULL,
	[sizegroup] [varchar](10) NULL,
	[sizecount] [int] NULL,
	[sizedesc] [varchar](200) NULL,
	[workdesconfirmflag] [bit] NULL,
	[workdesconfirmuser] [varchar](20) NULL,
	[workdesconfirmdate] [datetime] NULL,
	[batchno] [varchar](10) NULL,
	[zhenzhong] [varchar](20) NULL,
	[jima] [varchar](20) NULL,
	[stylenoverremark] [varchar](500) NULL,
	[outcustid] [varchar](10) NULL,
	[outcustname] [varchar](20) NULL,
	[sizeseriesid] [varchar](20) NULL,
	[isdlflag] [varchar](50) NULL,
	[dsgdeptconfirmflag] [bit] NULL,
	[dsgdeptconfirmuser] [varchar](20) NULL,
	[dsgdeptconfirmdate] [datetime] NULL,
	[sc_number] [varchar](50) NULL,
	[xxxfield] [varchar](50) NULL,
	[isforeflag] [bit] NULL,
	[isbefflag] [bit] NULL,
	[basesizem] [varchar](10) NULL,
	[picture3] [image] NULL,
	[picture4] [image] NULL,
	[dsgdeptzjconfirmflag] [bit] NULL,
	[dsgdeptzjconfirmuser] [varchar](20) NULL,
	[dsgdeptzjconfirmdate] [datetime] NULL,
	[isodm] [bit] NULL,
	[seriesid] [varchar](10) NULL,
	[seriesname] [varchar](50) NULL,
	[styletype] [varchar](10) NULL,
	[zhekou] [varchar](10) NULL,
	[sex] [varchar](10) NULL,
	[design] [varchar](20) NULL,
	[dsgdeptname] [varchar](20) NULL,
	[cate_code] [varchar](20) NULL,
	[kuanlei] [varchar](20) NULL,
	[zhuti] [varchar](100) NULL,
	[dlseriesname] [varchar](50) NULL,
	[dlseriesid] [varchar](20) NULL,
	[banxing] [varchar](10) NULL,
	[secang] [varchar](10) NULL,
	[chanpinjiegou] [varchar](30) NULL,
	[Wash] [varchar](50) NULL,
	[xs] [bit] NULL,
	[clientelestyleno] [varchar](50) NULL,
	[clientelestyl] [bit] NULL,
	[ybinfo] [varchar](50) NULL,
	[isyb] [bit] NULL,
	[iscontinuestyleno] [varchar](50) NULL,
	[iscontinue] [bit] NULL,
	[yatang] [bit] NULL,
	[qitang] [bit] NULL,
	[miantang] [bit] NULL,
	[isyxh1] [bit] NULL,
	[isyxh] [bit] NULL,
	[unitprice] [varchar](20) NULL,
	[cancelapplyflag] [bit] NULL,
	[cancelapplyuser] [varchar](20) NULL,
	[cancelapplydate] [datetime] NULL,
	[cancelmanagercheckflag] [bit] NULL,
	[cancelmanagercheckuser] [varchar](20) NULL,
	[cancelmanagercheckdate] [datetime] NULL,
	[cancelzjcheckflag] [bit] NULL,
	[cancelzjcheckuser] [varchar](20) NULL,
	[cancelzjcheckdate] [datetime] NULL,
	[tcdataremark] [varchar](200) NULL,
	[PPType] [varchar](20) NULL,
	[iscolorqty] [varchar](20) NULL,
	[tracknoagreeflag] [int] NULL,
	[tracknmid] [varchar](10) NULL,
	[trackgroupnmid] [varchar](10) NULL,
	[papersamplenmid] [varchar](10) NULL,
	[dosamplenmid] [varchar](10) NULL,
	[sizeedituserid] [varchar](10) NULL,
	[putyarduserid] [varchar](10) NULL,
	[sizepaperuserid] [varchar](10) NULL,
	[sizecheckuserid] [varchar](10) NULL,
	[countitemuserid] [varchar](10) NULL,
	[trackconfirmflag] [bit] NULL,
	[trackconfirmuser] [varchar](20) NULL,
	[trackconfirmdate] [datetime] NULL,
	[trackmanagerconfirmflag] [bit] NULL,
	[trackmanagerconfirmuser] [varchar](20) NULL,
	[trackmanagerconfirmdate] [datetime] NULL,
	[tracknoagreeuser] [varchar](20) NULL,
	[tracknoagreedate] [datetime] NULL,
	[inuserid] [varchar](20) NULL,
	[indeptid] [varchar](20) NULL,
	[mbversiongd] [varchar](10) NULL,
	[taoztype] [varchar](50) NULL,
	[baneditinf] [varchar](10) NULL,
	[taozremark] [varchar](50) NULL,
	[sddno] [varchar](20) NULL,
	[sddname] [varchar](20) NULL,
	[sdddesc] [varchar](200) NULL,
	[trackDeptID] [varchar](10) NULL,
	[trackdept] [varchar](20) NULL,
	[sjsconfirmflag] [bit] NULL,
	[sjsconfirmdate] [datetime] NULL,
	[sjsconfirmuser] [varchar](20) NULL,
	[filecheckdeptflag] [bit] NULL,
	[filecheckdeptdate] [datetime] NULL,
	[filecheckdeptuser] [varchar](20) NULL,
	[verremarkseason] [varchar](200) NULL,
	[isyxh2] [bit] NULL,
	[issjbdlflag] [int] NULL,
	[filecheckdeptconfirmflag] [bit] NULL,
	[filecheckdeptconfirmuser] [varchar](20) NULL,
	[filecheckdeptconfirmdate] [datetime] NULL,
	[iszyeditflag] [bit] NULL,
	[ismjseditflag] [bit] NULL,
	[ismzbeditflag] [bit] NULL,
	[ismbgdeditflag] [bit] NULL,
	[tracknoagreeremark] [varchar](200) NULL,
	[pyflag] [bit] NULL,
	[pianyinflag] [bit] NULL,
	[zhirongflag] [bit] NULL,
	[tazuanflag] [bit] NULL,
	[yinhuaotherflag] [bit] NULL,
	[mjxflag] [bit] NULL,
	[shenxflag] [bit] NULL,
	[dingzhuflag] [bit] NULL,
	[xiuhuaotherflag] [bit] NULL,
	[bianjiflag] [bit] NULL,
	[peipidaiflag] [bit] NULL,
	[updatereason] [varchar](2000) NULL,
	[reasondept] [varchar](200) NULL,
	[makedeptname] [varchar](20) NULL,
	[makedeptdesc] [varchar](20) NULL,
	[fabcharacter] [varchar](10) NULL,
	[Waist_type] [varchar](20) NULL,
	[Pants_type] [varchar](20) NULL,
	[BX_length] [varchar](20) NULL,
	[Design_style] [varchar](20) NULL,
	[fabname] [varchar](20) NULL,
	[issimilar] [bit] NULL,
	[issimilarno] [varchar](50) NULL,
	[partnerno] [varchar](50) NULL,
	[changememo] [varchar](500) NULL,
	[bx_no] [varchar](50) NULL,
	[overhead] [numeric](18, 4) NULL,
	[xsprice] [numeric](18, 4) NULL,
	[matcost] [numeric](18, 4) NULL,
	[total_price] [numeric](18, 4) NULL,
	[huagaoconfirmflag] [bit] NULL,
	[huagaoconfirmuser] [varchar](50) NULL,
	[huagaoconfirmdate] [datetime] NULL,
	[isdifcolorflag] [bit] NULL,
	[stylenametype] [varchar](20) NULL,
	[styletype2] [varchar](20) NULL,
	[outsidesleeve] [varchar](20) NULL,
	[thickness] [varchar](20) NULL,
	[Collartype] [varchar](20) NULL,
	[remark_pb] [varchar](500) NULL,
	[istransferseason] [bit] NULL,
	[OrderCheckFlag] [bit] NULL,
	[OrderCheckUserID] [varchar](20) NULL,
	[OrderCheckDate] [datetime] NULL,
	[OrderReason] [varchar](200) NULL,
	[ZDChangeReason] [varchar](100) NULL,
	[ZDChangeContent] [varchar](300) NULL,
	[ZDChangeReqDept] [varchar](50) NULL,
	[ZDChangeResDept] [varchar](50) NULL,
	[ODMfactory] [varchar](50) NULL,
	[ODMgroup] [nvarchar](50) NULL,
	[Des001] [varchar](50) NULL,
	[Des002] [varchar](50) NULL,
	[Des003] [varchar](50) NULL,
	[JianmianFlag] [bit] NULL,
	[ChongmianFlag] [bit] NULL,
	[zhubuFrFlag] [bit] NULL,
	[shuangdanFlag] [bit] NULL,
	[mianyiFlag] [bit] NULL,
 CONSTRAINT [PK_ban_makebill_head] PRIMARY KEY CLUSTERED 
(
	[mb_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO


/****** Object:  Index [cancelapplyflag]    Script Date: 2017-09-02 9:57:22 ******/
CREATE NONCLUSTERED INDEX [cancelapplyflag] ON [dbo].[ban_makebill_head]
(
	[cancelapplyflag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [ix_ban_makebill_head_sc_number]    Script Date: 2017-09-02 9:57:22 ******/
CREATE NONCLUSTERED INDEX [ix_ban_makebill_head_sc_number] ON [dbo].[ban_makebill_head]
(
	[sc_number] ASC,
	[mbtypeid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [matioid]    Script Date: 2017-09-02 9:57:22 ******/
CREATE NONCLUSTERED INDEX [matioid] ON [dbo].[ban_makebill_head]
(
	[matioid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [mbtypeid]    Script Date: 2017-09-02 9:57:22 ******/
CREATE NONCLUSTERED INDEX [mbtypeid] ON [dbo].[ban_makebill_head]
(
	[mbtypeid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [season]    Script Date: 2017-09-02 9:57:22 ******/
CREATE NONCLUSTERED INDEX [season] ON [dbo].[ban_makebill_head]
(
	[season] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [styleno]    Script Date: 2017-09-02 9:57:22 ******/
CREATE NONCLUSTERED INDEX [styleno] ON [dbo].[ban_makebill_head]
(
	[styleno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否相似款' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ban_makebill_head', @level2type=N'COLUMN',@level2name=N'issimilar'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'相似款单号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ban_makebill_head', @level2type=N'COLUMN',@level2name=N'issimilarno'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'对应的情侣装、亲子装、姐弟装单号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ban_makebill_head', @level2type=N'COLUMN',@level2name=N'partnerno'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改意见' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ban_makebill_head', @level2type=N'COLUMN',@level2name=N'changememo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'板型编号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ban_makebill_head', @level2type=N'COLUMN',@level2name=N'bx_no'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否撞色' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ban_makebill_head', @level2type=N'COLUMN',@level2name=N'isdifcolorflag'
GO