/****** Object:  Table [dbo].[ban_makebill_goods_log]    Script Date: 2017-09-02 9:57:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ban_makebill_goods_log](
	[mb_number] [varchar](20) NOT NULL,
	[mb_line] [int] NOT NULL,
	[color_name] [varchar](20) NULL,
	[color_desc] [varchar](50) NULL,
	[remark] [varchar](100) NULL,
	[qty] [int] NULL,
	[size1] [int] NULL,
	[size2] [int] NULL,
	[size3] [int] NULL,
	[size4] [int] NULL,
	[size5] [int] NULL,
	[size6] [int] NULL,
	[size7] [int] NULL,
	[size8] [int] NULL,
	[size9] [int] NULL,
	[size10] [int] NULL,
	[size11] [int] NULL,
	[size12] [int] NULL,
	[size13] [int] NULL,
	[size14] [int] NULL,
	[size15] [int] NULL,
	[size16] [int] NULL,
	[size17] [int] NULL,
	[size18] [int] NULL,
	[size19] [int] NULL,
	[size20] [int] NULL,
	[custcolorname] [varchar](50) NULL,
	[editusername] [varchar](20) NULL,
	[editdatetime] [datetime] NULL,
	[edittype] [varchar](20) NULL,
	[editver] [int] NULL,
	[isqs] [bit] NULL,
	[istouban] [bit] NULL,
	[iscancelcolor] [bit] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO