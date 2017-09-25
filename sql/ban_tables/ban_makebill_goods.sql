/****** Object:  Table [dbo].[ban_makebill_goods]    Script Date: 2017-09-02 9:57:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ban_makebill_goods](
	[mb_number] [varchar](20) NOT NULL,
	[mb_line] [int] NOT NULL,
	[color_name] [varchar](20) NULL,
	[color_desc] [varchar](50) NULL,
	[remark] [varchar](100) NULL,
	[TbQty] [int] NULL,
	[QsQty] [int] NULL,
	[LdQty] [int] NULL,
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
	[istouban] [bit] NULL,
	[iscancelcolor] [bit] NULL,
	[isqs] [bit] NULL,
	[ispb] [bit] NULL,
	[UploadFlag] [bit] NULL,
 CONSTRAINT [PK_ban_makebill_goods] PRIMARY KEY CLUSTERED 
(
	[mb_number] ASC,
	[mb_line] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO