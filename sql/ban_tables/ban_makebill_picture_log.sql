/****** Object:  Table [dbo].[ban_makebill_picture_log]    Script Date: 2017-09-02 9:57:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ban_makebill_picture_log](
	[mb_number] [varchar](20) NOT NULL,
	[mb_line] [int] NOT NULL,
	[pictureid] [varchar](20) NULL,
	[picture] [image] NULL,
	[modifydate] [datetime] NULL,
	[remark] [varchar](200) NULL,
	[editusername] [varchar](20) NULL,
	[editdatetime] [datetime] NULL,
	[edittype] [varchar](20) NULL,
	[editver] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO