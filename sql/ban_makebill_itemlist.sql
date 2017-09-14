/****** Object:  Table [dbo].[ban_makebill_itemlist]    Script Date: 2017-09-02 9:57:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ban_makebill_itemlist](
	[mb_number] [varchar](50) NOT NULL,
	[mb_line] [int] NOT NULL,
	[item_code] [varchar](100) NULL,
	[item_desc] [varchar](200) NULL,
	[itemtype] [varchar](4) NULL,
	[itemtypedesc] [varchar](20) NULL,
	[unitofuse] [varchar](50) NULL,
	[partid] [varchar](200) NULL,
	[unit] [varchar](20) NULL,
	[wasterate] [decimal](18, 4) NULL,
	[assigntype] [varchar](50) NULL,
	[assigncolorid] [varchar](50) NULL,
	[ifmao] [bit] NULL,
	[ifcasesize] [bit] NULL,
	[assignsizeid] [varchar](50) NULL,
	[qsize1] [numeric](18, 4) NULL,
	[qsize2] [numeric](18, 4) NULL,
	[qsize3] [numeric](18, 4) NULL,
	[qsize4] [numeric](18, 4) NULL,
	[qsize5] [numeric](18, 4) NULL,
	[qsize6] [numeric](18, 4) NULL,
	[qsize7] [numeric](18, 4) NULL,
	[qsize8] [numeric](18, 4) NULL,
	[qsize9] [numeric](18, 4) NULL,
	[qsize10] [numeric](18, 4) NULL,
	[qsize11] [numeric](18, 4) NULL,
	[qsize12] [numeric](18, 4) NULL,
	[qsize13] [numeric](18, 4) NULL,
	[qsize14] [numeric](18, 4) NULL,
	[qsize15] [numeric](18, 4) NULL,
	[qsize16] [numeric](18, 4) NULL,
	[qsize17] [numeric](18, 4) NULL,
	[qsize18] [numeric](18, 4) NULL,
	[qsize19] [numeric](18, 4) NULL,
	[qsize20] [numeric](18, 4) NULL,
	[msize1] [varchar](50) NULL,
	[msize2] [varchar](50) NULL,
	[msize3] [varchar](50) NULL,
	[msize4] [varchar](50) NULL,
	[msize5] [varchar](50) NULL,
	[msize6] [varchar](50) NULL,
	[msize7] [varchar](50) NULL,
	[msize8] [varchar](50) NULL,
	[msize9] [varchar](50) NULL,
	[msize10] [varchar](50) NULL,
	[msize11] [varchar](50) NULL,
	[msize12] [varchar](50) NULL,
	[msize13] [varchar](50) NULL,
	[msize14] [varchar](50) NULL,
	[msize15] [varchar](50) NULL,
	[msize16] [varchar](50) NULL,
	[msize17] [varchar](50) NULL,
	[msize18] [varchar](50) NULL,
	[msize19] [varchar](50) NULL,
	[msize20] [varchar](50) NULL,
	[des] [varchar](200) NULL,
	[element] [varchar](100) NULL,
	[gweight] [varchar](50) NULL,
	[fgweight] [varchar](50) NULL,
	[xgweight] [varchar](50) NULL,
	[costprice] [numeric](18, 4) NULL,
	[ispastesample] [bit] NULL,
	[orderid] [int] NULL,
	[clothpactid] [varchar](200) NULL,
	[providerid] [varchar](30) NULL,
	[jingsuo] [varchar](30) NULL,
	[zhisuo] [varchar](30) NULL,
	[weisuo] [varchar](30) NULL,
	[sourcetype] [varchar](10) NULL,
	[sourcetypedesc] [varchar](20) NULL,
	[wasteratenew] [numeric](18, 4) NULL,
	[useunsure] [bit] NULL,
	[matclass] [varchar](10) NULL,
	[jumprule] [varchar](15) NULL,
	[jumprule2] [varchar](15) NULL,
	[pogroup] [varchar](50) NULL,
	[provcode] [varchar](30) NULL,
	[colortype] [varchar](10) NOT NULL,
	[prejumprule] [numeric](18, 3) NULL,
	[afterjumprule] [numeric](18, 3) NULL,
	[marklength] [decimal](18, 4) NULL,
	[qty] [decimal](18, 1) NULL,
	[usrnm] [varchar](20) NULL,
	[consultmodel] [varchar](50) NULL,
	[basesizeuseqty] [numeric](18, 4) NULL,
	[FobBaseQty] [numeric](18, 4) NULL,
	[colorrate] [numeric](18, 4) NULL,
	[des1] [varchar](200) NULL,
	[des2] [varchar](200) NULL,
	[packqty] [decimal](18, 4) NULL,
	[matusetype] [varchar](50) NULL,
	[unituseqty] [numeric](18, 4) NULL,
	[perpackunituseqty] [numeric](18, 4) NULL,
	[modifydes] [varchar](200) NULL,
	[modifynm] [varchar](20) NULL,
	[modifydate] [datetime] NULL,
	[useqty] [decimal](18, 5) NULL,
	[model] [varchar](50) NULL,
	[assigncolorcaseid] [varchar](100) NULL,
	[multmatcolor] [varchar](260) NULL,
	[isaffirm] [varchar](6) NULL,
	[jumprate] [numeric](18, 4) NULL,
	[basesize] [varchar](20) NULL,
	[isfillcamlet] [bit] NULL,
	[extendsratev] [varchar](50) NULL,
	[extendsrateh] [varchar](50) NULL,
	[extractqty] [numeric](18, 4) NULL,
	[requireqty] [numeric](18, 4) NULL,
	[des3] [varchar](500) NULL,
	[des4] [varchar](300) NULL,
	[des5] [varchar](100) NULL,
	[des6] [varchar](100) NULL,
	[des7] [varchar](100) NULL,
	[des8] [varchar](100) NULL,
	[des9] [varchar](100) NULL,
	[des10] [varchar](100) NULL,
	[isupdatesizenum] [bit] NULL,
	[remotematcode] [varchar](60) NULL,
	[remotematname] [varchar](500) NULL,
	[des3name] [varchar](200) NULL,
	[partidname] [varchar](200) NULL,
	[dlqty] [numeric](18, 4) NULL,
	[purgroup] [varchar](50) NULL,
	[matsizeid] [varchar](20) NULL,
	[dhqhbflag] [bit] NULL,
	[dhqhbremark] [varchar](500) NULL,
	[psize1] [numeric](18, 4) NULL,
	[psize2] [numeric](18, 4) NULL,
	[psize3] [numeric](18, 4) NULL,
	[psize4] [numeric](18, 4) NULL,
	[psize5] [numeric](18, 4) NULL,
	[psize6] [numeric](18, 4) NULL,
	[psize7] [numeric](18, 4) NULL,
	[psize8] [numeric](18, 4) NULL,
	[psize9] [numeric](18, 4) NULL,
	[psize10] [numeric](18, 4) NULL,
	[psize11] [numeric](18, 4) NULL,
	[psize12] [numeric](18, 4) NULL,
	[psize13] [numeric](18, 4) NULL,
	[psize14] [numeric](18, 4) NULL,
	[psize15] [numeric](18, 4) NULL,
	[psize16] [numeric](18, 4) NULL,
	[psize17] [numeric](18, 4) NULL,
	[psize18] [numeric](18, 4) NULL,
	[psize19] [numeric](18, 4) NULL,
	[psize20] [numeric](18, 4) NULL,
	[colorftness] [varchar](50) NULL,
	[base_itemcode] [nvarchar](50) NULL,
	[ConfirmText] [varchar](500) NULL,
	[bfRemark] [nvarchar](150) NULL,
	[dlbytimesFlag] [bit] NULL,
	[dlbytimesQty] [int] NULL,
	[dlbytimesAddtimes] [int] NULL,
 CONSTRAINT [PK_ban_makebill_itemlist] PRIMARY KEY CLUSTERED 
(
	[mb_number] ASC,
	[mb_line] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ban_makebill_itemlist] ADD  CONSTRAINT [DF_ban_makebill_itemlist_colortype]  DEFAULT ('clGreen') FOR [colortype]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'色牢度等级' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ban_makebill_itemlist', @level2type=N'COLUMN',@level2name=N'colorftness'
GO