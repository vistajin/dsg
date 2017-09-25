/****** Object:  Table [dbo].[ban_makebill_qiantao_detail]    Script Date: 2017-09-02 9:57:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ban_makebill_qiantao_detail](
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
 CONSTRAINT [PK_ban_makebill_qiantao_detail] PRIMARY KEY CLUSTERED 
(
	[mb_number] ASC,
	[mb_itemline] ASC,
	[mb_line] ASC,
	[mb_colorline] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO