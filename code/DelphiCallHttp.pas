unit Unit1;  
  
interface  
  
uses  
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,  
  Dialogs,msxml, StdCtrls;  
  
type  
  TForm1 = class(TForm)  
    btn1_callRestful: TButton;  
    mmo1: TMemo;  
    procedure btn1_callRestfulClick(Sender: TObject);  
  private  
    { Private declarations }  
  public  
    { Public declarations }  
  end;  
  
var  
  Form1: TForm1;  
  
implementation  
  
{$R *.dfm}  
  
procedure TForm1.btn1_callRestfulClick(Sender: TObject);  
var  
HttpReq : IXMLHTTPRequest;  
url, msg,rsp   : string;  
begin  
   url:= 'http://xxxxx.ittun.com/usspachRest/initCheck';  
   msg:='msg={"timecut":"20170727141009",  '+  
    ' "ip":"xxx", '+  
    ' "uniform_oper":"MY",    '+  
    ' "oper_no":"NNPT00",       '+  
    ' "uniform_passwd":"C4CA4238A0B923820DCC509A6FFDDD"     '+  
    ' }';  
    HttpReq := CoXMLHTTPRequest.Create;  
   //两种提交请求的方式：Get和Post,Get是通过URL地址传递参数如果是中文需要转码，需要添加时间戳 Post不需要添加时间戳  
   //get url := 'http://localhost:5269/api/webmemberapi/NewMemberRegister?timestamp='+inttostr(Windows.GetTickCount);  
   //vQryURL := 'http://10.202.31.103:1080/hs/api/iOrderService/queryOrderWithBill';  
   HttpReq.open('Post', url, False, EmptyParam, EmptyParam);  
   //http post  
   //HttpReq.setRequestHeader('Accept', 'application/json');  
   HttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');  
   //HttpReq.setRequestHeader('Content-Type', 'application/json');  
   //请求主体  
   try  
    HttpReq.Send(msg);  
    rsp := (HttpReq.responseText);  
    mmo1.Lines.Add(rsp) ;  
   except  
     on Ex:Exception do  
       ShowMessage(Ex.Message);  
   end;  
  
end;  
  
end. 
