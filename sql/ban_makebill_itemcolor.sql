/****** Object:  Table [dbo].[ban_makebill_itemcolor]    Script Date: 2017-09-02 9:57:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ban_makebill_itemcolor](
	[mb_number] [varchar](20) NOT NULL,
	[mb_line] [int] NOT NULL,
	[lsh] [int] NOT NULL,
	[isassigncolor] [bit] NULL,
	[stylecolorid] [varchar](20) NULL,
	[stylecolordesc] [varchar](50) NULL,
	[item_code] [varchar](20) NULL,
	[item_desc] [varchar](200) NULL,
	[itemcolorid] [varchar](50) NULL,
	[itemcolordesc] [varchar](50) NULL,
	[cupno] [varchar](20) NULL,
	[stampcolorid] [varchar](20) NULL,
	[stampcolordesc] [varchar](50) NULL,
	[washedcolorid] [varchar](50) NULL,
	[washedcolordesc] [varchar](50) NULL,
	[modifydes] [varchar](100) NULL,
	[modifynm] [varchar](20) NULL,
	[modifydate] [datetime] NULL,
	[digestionstockflag] [bit] NULL,
	[DigestionstoreFlag] [bit] NULL,
	[YuliustoreFlag] [bit] NULL,
	[SjstigongFlag] [bit] NULL,
	[PiyinFlag] [bit] NULL,
	[DinggouFlag] [bit] NULL,
	[ishasbbflag] [bit] NULL,
	[xianpeiFlag] [bit] NULL,
	[xianhuoFlag] [bit] NULL,
	[shigouFlag] [bit] NULL,
	[ccunumber] [varchar](20) NULL,
	[ccuissolidflag] [bit] NULL,
	[ccuitem_code] [varchar](20) NULL,
	[resDocno] [varchar](20) NULL,
	[beibuDocno] [varchar](20) NULL,
	[beibuQty] [numeric](18, 4) NULL,
	[beibuDate] [datetime] NULL,
	[clothCycle] [varchar](30) NULL,
	[purDept] [nvarchar](30) NULL,
	[venderName] [nvarchar](30) NULL,
	[isReplace] [bit] NULL,
	[rplColor] [bit] NULL,
	[rplCloth] [bit] NULL,
	[rplAddCloth] [bit] NULL,
	[psRemark] [nvarchar](100) NULL,
	[planNeedQty] [numeric](18, 4) NULL,
 CONSTRAINT [PK_ban_makebill_itemcolor] PRIMARY KEY CLUSTERED 
(
	[mb_number] ASC,
	[mb_line] ASC,
	[lsh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO