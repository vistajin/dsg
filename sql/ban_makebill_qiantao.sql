/****** Object:  Table [dbo].[ban_makebill_qiantao]    Script Date: 2017-09-02 9:57:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ban_makebill_qiantao](
	[mb_number] [varchar](50) NOT NULL,
	[mb_line] [int] NOT NULL,
	[mb_itemline] [int] NOT NULL,
	[item_code] [varchar](50) NULL,
	[item_desc] [varchar](100) NULL,
	[itemtype] [varchar](10) NULL,
	[modifydes] [varchar](100) NULL,
	[unit] [varchar](20) NULL,
	[wasterate] [numeric](18, 4) NULL,
	[element] [varchar](100) NULL,
	[posid] [varchar](50) NULL,
	[posname] [varchar](100) NULL,
	[sourcetype] [varchar](20) NULL,
	[assigncolor] [varchar](20) NULL,
	[ifcase] [bit] NULL,
	[des3] [varchar](200) NULL,
	[partid] [varchar](200) NULL,
	[remark] [varchar](200) NULL,
	[qsize1] [numeric](18, 4) NULL,
	[qsize2] [numeric](18, 4) NULL,
	[qsize3] [numeric](18, 4) NULL,
	[qsize4] [numeric](18, 4) NULL,
	[qsize5] [numeric](18, 4) NULL,
	[qsize6] [numeric](18, 4) NULL,
	[qsize7] [numeric](18, 4) NULL,
	[qsize8] [numeric](18, 4) NULL,
	[qsize9] [numeric](18, 4) NULL,
	[qsize10] [numeric](18, 4) NULL,
	[qsize11] [numeric](18, 4) NULL,
	[qsize12] [numeric](18, 4) NULL,
	[qsize13] [numeric](18, 4) NULL,
	[qsize14] [numeric](18, 4) NULL,
	[qsize15] [numeric](18, 4) NULL,
	[qsize16] [numeric](18, 4) NULL,
	[qsize17] [numeric](18, 4) NULL,
	[qsize18] [numeric](18, 4) NULL,
	[qsize19] [numeric](18, 4) NULL,
	[qsize20] [numeric](18, 4) NULL,
	[msize1] [varchar](50) NULL,
	[msize2] [varchar](50) NULL,
	[msize3] [varchar](50) NULL,
	[msize4] [varchar](50) NULL,
	[msize5] [varchar](50) NULL,
	[msize6] [varchar](50) NULL,
	[msize7] [varchar](50) NULL,
	[msize8] [varchar](50) NULL,
	[msize9] [varchar](50) NULL,
	[msize10] [varchar](50) NULL,
	[msize11] [varchar](50) NULL,
	[msize12] [varchar](50) NULL,
	[msize13] [varchar](50) NULL,
	[msize14] [varchar](50) NULL,
	[msize15] [varchar](50) NULL,
	[msize16] [varchar](50) NULL,
	[msize17] [varchar](50) NULL,
	[msize18] [varchar](50) NULL,
	[msize19] [varchar](50) NULL,
	[msize20] [varchar](50) NULL,
	[matsizeid] [varchar](10) NULL,
	[basesize] [varchar](10) NULL,
	[basesizeuseqty] [numeric](18, 4) NULL,
 CONSTRAINT [PK_ban_makebill_qiantao] PRIMARY KEY CLUSTERED 
(
	[mb_number] ASC,
	[mb_itemline] ASC,
	[mb_line] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO