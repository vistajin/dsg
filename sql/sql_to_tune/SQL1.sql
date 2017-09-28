CREATE procedure [dbo].[AutoDsgPubFilterCollectTo2qu] as
begin
	delete from  [192.168.2.33].DataWarehouse.dbo.PubFilterCollect
	where Wno >  DATEADD(DAY,-500,GETDATE())

	insert into  [192.168.2.33].DataWarehouse.dbo.PubFilterCollect
	(SampleNo,IsActiveFlag,PdaNo,Wno,Remark,StyleType,StyleSetDesc,Desc4,unitprice,StyleTermDesc )
	select banid,IsActiveFlag,PdaNo,indate,Remark,kuanlei,series,fengge,unitprice,goodsperiod
	from PubFilterCollect   (nolock)
	where  indate >  DATEADD(DAY,-500,GETDATE())
	--------------------------------------------------------------

	delete from  [192.168.2.33].DataWarehouse.dbo.PubFilterSample
	where Wno >  DATEADD(DAY,-200,GETDATE())

	insert into  [192.168.2.33].DataWarehouse.dbo.PubFilterSample
	(StyleSeriesID,SampleNo,Designer,DesignDept,StyleSetDesc,StyleSortDesc,StyleClassDesc,StyleType,StyleDesc,Desc3,
	 Desc4,WNo,EditUserID,UnitPrice1,UnitPrice2,StyleTermDesc,sc_number)
	select b.season,a.banid,b.designnm,b.dsgdeptname,b.series,b.sex,b.styletype,b.kuanlei,b.styledesc,a.caijian,
		 a.fengge,a.indate,a.inuser,a.UnitPrice2,a.UnitPrice1,b.goodsperiod,a.sc_number
	from od_head a   (nolock) 
	inner join b_styleno b(nolock) on a.sc_number=b.sc_number
	where  isnull(a.IsActiveFlag,0)=1 and  a.indate >  DATEADD(DAY,-200,GETDATE())
	--------------------------------------------------------------

	delete from  [192.168.2.33].DataWarehouse.dbo.pubfilterstyle
	where  sc_number > 'SC00080000'

	insert into [192.168.2.33].DataWarehouse.dbo.pubfilterstyle
	(StyleID,SampleNo,sc_number)
	select b.styleno,b.banid,a.sc_number
	from od_head a (nolock) 
	inner join b_styleno b(nolock) on a.sc_number=b.sc_number
	where  a.sc_number > 'SC00080000'

	/* By Mark 2015-8-21 增加过滤条件
	delete from  [192.168.2.33].DataWarehouse.dbo.PubFilterCollect

	insert into [192.168.2.33].DataWarehouse.dbo.PubFilterCollect
	(SampleNo,IsActiveFlag,PdaNo,Wno,Remark,StyleType,StyleSetDesc,Desc4,unitprice,StyleTermDesc )
	select banid,IsActiveFlag,PdaNo,indate,Remark,kuanlei,series,fengge,unitprice,goodsperiod
	from PubFilterCollect   (nolock)

	delete from  [192.168.2.33].DataWarehouse.dbo.PubFilterSample
	insert into [192.168.2.33].DataWarehouse.dbo.PubFilterSample
	(StyleSeriesID,SampleNo,Designer,DesignDept,StyleSetDesc,StyleSortDesc,StyleClassDesc,StyleType,StyleDesc,Desc3,
	 Desc4,WNo,EditUserID,UnitPrice1,UnitPrice2,StyleTermDesc,sc_number)
	select b.season,a.banid,b.designnm,b.dsgdeptname,b.series,b.sex,b.styletype,b.kuanlei,b.styledesc,a.caijian,
		  a.fengge,a.indate,a.inuser,a.UnitPrice2,a.UnitPrice1,b.goodsperiod,a.sc_number
	from od_head a   (nolock) inner join
		 b_styleno b(nolock) on a.sc_number=b.sc_number
	where isnull(a.IsActiveFlag,0)=1

	delete from  [192.168.2.33].DataWarehouse.dbo.pubfilterstyle
	insert into [192.168.2.33].DataWarehouse.dbo.pubfilterstyle
	(StyleID,SampleNo,sc_number)
	select b.styleno,b.banid,a.sc_number
	from od_head a   (nolock) inner join
		 b_styleno b(nolock) on a.sc_number=b.sc_number

	*/
end
