-- =============================================		
-- Author:		<xm>
-- Create date: <2017-8-16>		
-- Description:	<自动产生板布回复批复的与制板单明细查询相关数据批次号和缸号>	
-- =============================================		
CREATE PROCEDURE [dbo].[getBanBatchAndCrockID]		
		
AS		
BEGIN		
  DECLARE @days int   		
  SET @days=180		
  truncate table BanBatchAndCrockID		
  INSERT INTO BanBatchAndCrockID		
  select distinct a.colorID,a.MatNo,b.banid, 		
       case when isnull(a.LastBatchID,'')<>'' then		
            dbo.GetstockPasterColorBatchCrokid(a.colorID,a.OrderNo,a.MatNo,'LastBatchID','') 		
       else		
            dbo.GetstockPasterColorBatchCrokid(a.colorID,a.OrderNo,a.MatNo,'batchID','') 		
       end AS batchid,		
       case when isnull(a.LastBatchID,'')<>'' then		
            dbo.GetstockPasterColorBatchCrokid(a.colorID,a.OrderNo,a.MatNo,'LastBatchID_crockid',a.LastBatchID)                                    		
       ELSE		
            dbo.GetstockPasterColorBatchCrokid(a.colorID,a.OrderNo,a.MatNo,'crockID','')       	                    	
       end as crockID   		
                                          		
       from materialPasterColor_detaild(nolock) a LEFT join		
            ( SELECT b.banid,b.item_code,b.color_name,d.req_number 		
              FROM req_detail(NOLOCK) a  LEFT JOIN 		
                   req_detaild(NOLOCK) b ON a.req_serial=b.req_serial AND a.req_line=b.req_line inner JOIN 		
                   (SELECT req_number,req_serial FROM req_head(NOLOCK))d ON a.req_serial=d.req_serial		
             )b ON a.OrderNo=b.req_number AND a.MatNo=b.item_code AND a.colorid=b.color_name		
WHERE datediff(day,backdate,getdate())<=@days		
END		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	 dbo.GetstockPasterColorBatchCrokid(a.colorID,a.OrderNo,a.MatNo,'batchID','') 	
		
		
		
	--(select top 1 crockid from materialPasterColor_detaild where lastbatchid=a.LastBatchID)	
	dbo.GetstockPasterColorBatchCrokid(a.colorID,a.OrderNo,a.MatNo,'LastBatchID_crockid',a.LastBatchID)                                    	
		
	dbo.GetstockPasterColorBatchCrokid(a.colorID,a.OrderNo,a.MatNo,'crockID','')       	                    
