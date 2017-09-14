
/****** Object:  Table [dbo].[ban_makebill_chrdetail]    Script Date: 2017-09-02 9:57:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ban_makebill_chrdetail](
	[mb_number] [varchar](50) NULL,
	[item_code] [varchar](50) NULL,
	[posid] [varchar](50) NULL,
	[chtype] [varchar](10) NULL,
	[posname] [varchar](100) NULL,
	[size1] [numeric](18, 2) NULL,
	[size2] [numeric](18, 2) NULL,
	[size3] [numeric](18, 2) NULL,
	[size4] [numeric](18, 2) NULL,
	[size5] [numeric](18, 2) NULL,
	[size6] [numeric](18, 2) NULL,
	[size7] [numeric](18, 2) NULL,
	[size8] [numeric](18, 2) NULL,
	[size9] [numeric](18, 2) NULL,
	[size10] [numeric](18, 2) NULL,
	[size11] [numeric](18, 2) NULL,
	[size12] [numeric](18, 2) NULL,
	[size13] [numeric](18, 2) NULL,
	[size14] [numeric](18, 2) NULL,
	[size15] [numeric](18, 2) NULL,
	[size16] [numeric](18, 2) NULL,
	[size17] [numeric](18, 2) NULL,
	[size18] [numeric](18, 2) NULL,
	[size19] [numeric](18, 2) NULL,
	[size20] [numeric](18, 2) NULL,
	[jumptimes] [int] NULL,
	[vermodify] [varchar](200) NULL,
	[mb_line] [int] NULL,
	[orderid] [int] NULL,
	[tmpsize] [numeric](18, 2) NULL,
	[crmethordByPart] [nvarchar](30) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Index [mb_number]    Script Date: 2017-09-02 9:57:22 ******/
CREATE NONCLUSTERED INDEX [mb_number] ON [dbo].[ban_makebill_chrdetail]
(
	[mb_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO