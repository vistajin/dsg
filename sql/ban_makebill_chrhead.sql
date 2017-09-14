/****** Object:  Table [dbo].[ban_makebill_chrhead]    Script Date: 2017-09-02 9:57:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ban_makebill_chrhead](
	[mb_number] [varchar](50) NULL,
	[item_code] [varchar](30) NULL,
	[chtype] [varchar](10) NULL,
	[styleno] [varchar](20) NULL,
	[element] [varchar](100) NULL,
	[jumpsize] [varchar](50) NULL,
	[jumptimes] [int] NULL,
	[jumpvalue1] [numeric](18, 4) NULL,
	[jumpvalue2] [numeric](18, 4) NULL,
	[cravgqty] [numeric](18, 1) NULL,
	[crtype] [varchar](20) NULL,
	[inuser] [varchar](20) NULL,
	[indate] [datetime] NULL,
	[confirmuser] [varchar](50) NULL,
	[confirmdate] [datetime] NULL,
	[confirmflag] [bit] NULL,
	[pengsong] [varchar](50) NULL,
	[sizegroup] [varchar](20) NULL,
	[remark] [varchar](500) NULL,
	[mcrbasesize] [numeric](18, 2) NULL,
	[wcrbasesize] [numeric](18, 2) NULL,
	[mcmbasesize] [numeric](18, 2) NULL,
	[wcmbasesize] [numeric](18, 2) NULL,
	[cbefbasesize] [numeric](18, 2) NULL,
	[caftbasesize] [numeric](18, 2) NULL,
	[jumprule_bef] [varchar](200) NULL,
	[jumprule_aft] [varchar](200) NULL,
	[jumpgroup] [varchar](200) NULL,
	[jumpgrouprule] [varchar](200) NULL,
	[rulenumber] [varchar](20) NULL,
	[mb_line] [int] NULL,
	[jumpsize2] [varchar](20) NULL,
	[crr_number] [varchar](20) NULL,
	[crmethord] [bit] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

/****** Object:  Index [mb_number]    Script Date: 2017-09-02 9:57:22 ******/
CREATE NONCLUSTERED INDEX [mb_number] ON [dbo].[ban_makebill_chrhead]
(
	[mb_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO