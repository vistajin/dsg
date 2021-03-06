/****** Object:  Table [dbo].[ban_makebill_workdes]    Script Date: 2017-09-02 9:57:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ban_makebill_workdes](
	[mb_number] [varchar](20) NOT NULL,
	[mb_line] [int] NOT NULL,
	[gyid] [varchar](50) NULL,
	[gongxu] [varchar](50) NULL,
	[zhikou] [varchar](200) NULL,
	[chezhong] [varchar](100) NULL,
	[zhenshu] [varchar](200) NULL,
	[gyyaodian] [varchar](200) NULL,
	[mark] [varchar](10) NULL,
	[pictureid] [char](20) NULL,
	[orderid] [int] NULL,
	[des1] [varchar](50) NULL,
	[des2] [varchar](50) NULL,
	[vlsh] [int] NULL,
	[des3] [varchar](200) NULL,
	[des4] [varchar](200) NULL,
	[des5] [varchar](200) NULL,
	[des6] [varchar](200) NULL,
	[des7] [varchar](200) NULL,
	[des8] [varchar](200) NULL,
	[des9] [varchar](200) NULL,
	[des10] [varchar](200) NULL,
	[des11] [varchar](200) NULL,
	[des12] [varchar](200) NULL,
	[modifydes] [varchar](250) NULL,
	[modifynm] [varchar](20) NULL,
	[modifydate] [datetime] NULL,
	[usrnm] [varchar](20) NULL,
	[gy] [varchar](200) NULL,
	[fszs] [varchar](200) NULL,
	[swzf] [varchar](200) NULL,
	[jfxl] [varchar](200) NULL,
	[zuji] [varchar](200) NULL,
	[zhipu] [varchar](200) NULL,
	[tb] [varchar](200) NULL,
	[jg] [varchar](200) NULL,
	[colororder] [varchar](200) NULL,
	[dadici] [decimal](18, 0) NULL,
	[dadidao] [decimal](18, 0) NULL,
	[ysci] [decimal](18, 0) NULL,
	[ysdao] [decimal](18, 0) NULL,
	[gmci] [decimal](18, 0) NULL,
	[gmdao] [decimal](18, 0) NULL,
	[tscolor] [varchar](50) NULL,
	[tzcolorid] [varchar](50) NULL,
	[zmcolorid] [varchar](50) NULL,
	[tydegree] [decimal](18, 0) NULL,
	[tytime] [decimal](18, 0) NULL,
	[mianbutyci] [decimal](18, 0) NULL,
	[dibutyci] [decimal](18, 0) NULL,
	[grdegree] [decimal](18, 0) NULL,
	[grzhuan] [decimal](18, 0) NULL,
	[cailiaofenlei] [varchar](50) NULL,
	[shouxiu] [varchar](200) NULL,
	[process] [text] NULL,
	[picturename] [varchar](50) NULL,
	[pictureremark] [varchar](1000) NULL,
	[pictrueseriesid] [varchar](20) NULL,
 CONSTRAINT [PK_ban_makebill_workdes] PRIMARY KEY CLUSTERED 
(
	[mb_number] ASC,
	[mb_line] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO