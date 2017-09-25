/****** Object:  Table [dbo].[ban_makebill_sizedes]    Script Date: 2017-09-02 9:57:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ban_makebill_sizedes](
	[mb_number] [varchar](20) NOT NULL,
	[mb_line] [int] NOT NULL,
	[sizeid] [varchar](20) NULL,
	[sizename] [varchar](100) NULL,
	[dufa] [varchar](50) NULL,
	[jumprule_bef] [varchar](15) NULL,
	[jumprule_aft] [varchar](15) NULL,
	[jumpgroup] [varchar](50) NULL,
	[jumpgrouprule] [varchar](100) NULL,
	[item_code] [varchar](20) NULL,
	[item_desc] [varchar](200) NULL,
	[itemtype] [varchar](2) NULL,
	[allowerrrange] [varchar](30) NULL,
	[aallowerrrange] [varchar](100) NULL,
	[remark] [varchar](30) NULL,
	[size1] [varchar](30) NULL,
	[size2] [varchar](30) NULL,
	[size3] [varchar](30) NULL,
	[size4] [varchar](30) NULL,
	[size5] [varchar](30) NULL,
	[size6] [varchar](30) NULL,
	[size7] [varchar](30) NULL,
	[size8] [varchar](30) NULL,
	[size9] [varchar](30) NULL,
	[size10] [varchar](30) NULL,
	[size11] [varchar](30) NULL,
	[size12] [varchar](30) NULL,
	[size13] [varchar](30) NULL,
	[size14] [varchar](30) NULL,
	[size15] [varchar](30) NULL,
	[size16] [varchar](30) NULL,
	[size17] [varchar](30) NULL,
	[size18] [varchar](30) NULL,
	[size19] [varchar](30) NULL,
	[size20] [varchar](30) NULL,
	[asize1] [varchar](30) NULL,
	[asize2] [varchar](30) NULL,
	[asize3] [varchar](30) NULL,
	[asize4] [varchar](30) NULL,
	[asize5] [varchar](30) NULL,
	[asize6] [varchar](30) NULL,
	[asize7] [varchar](30) NULL,
	[asize8] [varchar](30) NULL,
	[asize9] [varchar](30) NULL,
	[asize10] [varchar](30) NULL,
	[asize11] [varchar](30) NULL,
	[asize12] [varchar](30) NULL,
	[asize13] [varchar](30) NULL,
	[asize14] [varchar](30) NULL,
	[asize15] [varchar](30) NULL,
	[asize16] [varchar](30) NULL,
	[asize17] [varchar](30) NULL,
	[asize18] [varchar](30) NULL,
	[asize19] [varchar](30) NULL,
	[asize20] [varchar](30) NULL,
	[picturcode] [varchar](50) NULL,
	[orderid] [int] NULL,
	[washedrealcc] [varchar](20) NULL,
	[jm] [varchar](20) NULL,
	[jmname] [varchar](20) NULL,
	[szseriesid] [varchar](20) NULL,
	[szseriesconfirm] [bit] NULL,
 CONSTRAINT [PK_ban_makebill_sizedes] PRIMARY KEY CLUSTERED 
(
	[mb_number] ASC,
	[mb_line] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO