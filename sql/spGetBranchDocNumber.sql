--exec spGetBranchDocNumber 'MATSTORE','stockoutnumber','OUT999','1',@outdocno OUTPUT
CREATE PROC [dbo].[spGetBranchDocNumber]
   @branchid nvarchar(20),--店铺
   @docname nvarchar(50), --单据类型
   @docpre nvarchar(10),  --单据前缀
   @isupdate int,         --是否更新最大值
   @docnumber nvarchar(20) output  --输出单据编号
as

  declare @curnumber varchar(20), --当前单据值
          @numberlen int,          --单据长度
          @branchorder nvarchar(10),--店铺序号值
          @isini int,
          @docno varchar(20),       --单据编号序号
          @temp  varchar(20),
          @nextvalue varchar(30)

select @curnumber=itemvalue from s_systemset where classname=@docname and typename=@docpre
set @curnumber=isnull(@curnumber,'1')

select @numberlen=itemvalue from s_systemset where classname=@docname and typename='length'
set @numberlen=isnull(@numberlen,'8')

set @nextvalue=dbo.Get36DigtalNextValue(len(@curnumber),@curnumber)
set @temp=replicate('0',convert(int,@numberlen))+ @nextvalue
set @docnumber=@docpre+substring(@temp,len(@temp)-(convert(int,@numberlen)-1),convert(int,@numberlen))

if @isupdate=1
	begin
		if exists(select * from s_systemset where classname=@docname and typename=@docpre)
			update s_systemset
				set itemvalue=@nextvalue
			from s_systemset
			where classname=@docname and typename=@docpre
		else
			insert into s_systemset
				(classname,typename,itemname,itemvalue)
			select @docname as classname,@docpre as typename,'' as itemname,convert(varchar(8),convert(int,@curnumber)+1) as itemvalue
	end