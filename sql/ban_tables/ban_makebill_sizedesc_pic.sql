/****** Object:  Table [dbo].[ban_makebill_sizedesc_pic]    Script Date: 2017-09-02 9:57:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ban_makebill_sizedesc_pic](
	[mb_number] [varchar](20) NOT NULL,
	[mb_line] [int] NOT NULL,
	[picturcode] [varchar](20) NULL,
	[picture] [image] NULL,
 CONSTRAINT [PK_ban_makebill_sizedesc_pic] PRIMARY KEY CLUSTERED 
(
	[mb_number] ASC,
	[mb_line] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO