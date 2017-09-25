/****** Object:  Table [dbo].[ban_makebill_qiantao_detail_log]    Script Date: 2017-09-02 9:57:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ban_makebill_qiantao_detail_log](
	[mb_number] [varchar](50) NOT NULL,
	[mb_itemline] [int] NOT NULL,
	[mb_line] [int] NOT NULL,
	[mb_colorline] [int] NOT NULL,
	[isassigncolor] [bit] NULL,
	[item_code] [varchar](50) NULL,
	[item_desc] [varchar](100) NULL,
	[itemtype] [varchar](10) NULL,
	[parentcolorid] [varchar](50) NULL,
	[parentcolorname] [varchar](50) NULL,
	[colorid] [varchar](50) NULL,
	[colorname] [varchar](50) NULL,
	[modifydes] [varchar](100) NULL,
	[modifynm] [varchar](20) NULL,
	[modifydate] [datetime] NULL,
	[editusername] [varchar](20) NULL,
	[editdatetime] [datetime] NULL,
	[edittype] [varchar](20) NULL,
	[editver] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO