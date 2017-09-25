/****** Object:  Table [dbo].[ban_makebill_bom_log]    Script Date: 2017-09-02 9:57:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ban_makebill_bom_log](
	[mb_number] [varchar](20) NOT NULL,
	[bomid] [bigint] NOT NULL,
	[matioid] [varchar](30) NULL,
	[styleno] [varchar](20) NULL,
	[item_code] [varchar](20) NULL,
	[item_desc] [varchar](200) NULL,
	[itemtype] [varchar](4) NULL,
	[itemtypedesc] [varchar](20) NULL,
	[partid] [varchar](200) NULL,
	[unit] [varchar](20) NULL,
	[model] [varchar](50) NULL,
	[wasterate] [decimal](18, 4) NULL,
	[useqty] [decimal](18, 5) NULL,
	[sumqty] [numeric](18, 4) NULL,
	[element] [varchar](100) NULL,
	[gweight] [varchar](50) NULL,
	[costprice] [numeric](18, 4) NULL,
	[costtotal] [numeric](18, 4) NULL,
	[sourcetype] [varchar](10) NULL,
	[sourcetypedesc] [varchar](20) NULL,
	[stylecolorid] [varchar](20) NULL,
	[stylecolordesc] [varchar](50) NULL,
	[bansize] [varchar](50) NULL,
	[itemcolorid] [varchar](20) NULL,
	[itemcolordesc] [varchar](50) NULL,
	[stampcolorid] [varchar](20) NULL,
	[stampcolordesc] [varchar](50) NULL,
	[washedcolorid] [varchar](20) NULL,
	[washedcolordesc] [varchar](50) NULL,
	[editusername] [varchar](20) NULL,
	[editdatetime] [datetime] NULL,
	[edittype] [varchar](20) NULL,
	[editver] [int] NULL,
	[goodsqty] [numeric](18, 4) NULL,
	[sjqty] [numeric](18, 4) NULL,
	[qtymiss] [numeric](18, 4) NULL,
	[qtyother] [numeric](18, 4) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO