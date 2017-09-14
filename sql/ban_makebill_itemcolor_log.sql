/****** Object:  Table [dbo].[ban_makebill_itemcolor_log]    Script Date: 2017-09-02 9:57:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ban_makebill_itemcolor_log](
	[mb_number] [varchar](20) NOT NULL,
	[mb_line] [int] NOT NULL,
	[lsh] [int] NOT NULL,
	[isassigncolor] [bit] NULL,
	[stylecolorid] [varchar](20) NULL,
	[stylecolordesc] [varchar](50) NULL,
	[item_code] [varchar](20) NULL,
	[item_desc] [varchar](200) NULL,
	[itemcolorid] [varchar](50) NULL,
	[itemcolordesc] [varchar](100) NULL,
	[cupno] [varchar](20) NULL,
	[stampcolorid] [varchar](20) NULL,
	[stampcolordesc] [varchar](50) NULL,
	[washedcolorid] [varchar](20) NULL,
	[washedcolordesc] [varchar](50) NULL,
	[modifydes] [varchar](100) NULL,
	[modifynm] [varchar](20) NULL,
	[modifydate] [datetime] NULL,
	[editusername] [varchar](20) NULL,
	[editdatetime] [datetime] NULL,
	[edittype] [varchar](20) NULL,
	[editver] [int] NULL,
	[digestionstoreflag] [bit] NULL,
	[digestionstockflag] [bit] NULL,
	[ishasbbflag] [bit] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO