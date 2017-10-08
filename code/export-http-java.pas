unit export;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DBGridEh, DBGridEhImpExp3, GridsEh,
  DB, DBXpress, SqlExpr, ADODB, msxml;

type
    TexportForm = class(TForm)
    btnExportExcel: TButton;
    sdlg: TSaveDialog;
    adbg: TDBGridEh;
    gblCon: TADOConnection;
    dset: TADODataSet;
    datasource: TDataSource;
    btnExportTxt: TButton;
    btnCallJavaExport: TButton;
    procedure btnExportExcelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnExportTxtClick(Sender: TObject);
    procedure btnCallJavaExportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

////////////////////////////
type
  TRec = record
    ds: TADODataSet;
    colList: TColumnsEhList;
    filename: String;
    start: Integer;
    length: Integer;
    rs: DBGridEhImpExp3.TArrStr;
end;
TPRec = ^TRec;
function ExportThreadFun(p: TPRec): DWORD; stdcall;
////////////////////////////

var
  exportForm: TexportForm;
  
implementation

{$R *.dfm}
  
procedure TexportForm.btnExportExcelClick(Sender: TObject);
var
  bSuccess: Boolean;
  ID: DWORD;
  //pp: TPRec;
  p: array of TRec;
  hThreads: array of THandle;
  threadNum: Integer;
  i: Integer;
  length: Integer;
  start: Integer;
  //adbgs: array of TDBGridEh;
  dsets: array of TADODataSet;
  rs: DBGridEhImpExp3.TArrStr;
  rsx: Integer;
  //adbg1: TDBGridEh;
  f : TFileStream;
  s: String;
  //b: TBytes;
begin
  bSuccess := False;
  threadNum := 0;
  //GetMem(pp, SizeOf(TRec));
  sdlg.DefaultExt := 'XLS';
  sdlg.Filter := '*.XLS|*.XLS';
  if SDLG.FileName='' then
    sdlg.FileName := 'exp.XLS';
  //ShowMessage('Select: ' + IntToStr(adbg.SelectedRows.Count));
  //DBGridEh_DoCopyAction(adbg, true);
  //adbg.DataSource.DataSet.
  //adbg1 := TDBGridEh.Create(adbg);
  //adbg.VisibleColumns.f;
  //ShowMessage('Total: ' + adbg.VisibleColumns.Items[0].DisplayText + IntToStr(adbg1.DataSource.DataSet.RecordCount));
  SetLength(rs, dset.RecordCount, adbg.VisibleColumns.Count);
          rsx := 0;
          {while not dset.Eof do
          begin
            rs[0, 0] := dset.Fields[0].AsString;
            dset.Next;
          end;}

          //f := TFileStream.Create('C:\Users\Vista\Desktop\exp\a.txt', fmCreate);
          with dset do
          begin
            DisableControls;
            try
              begin
                First;
                while Eof = False do
                begin
                  for i := 0 to adbg.VisibleColumns.Count - 1 do
                  begin
                    dset.Fields[i].Value;
                  end;
                  Next;
                end;
              end;
            finally
              EnableControls;
            end;
          end;
          //f.Free;
          ShowMessage(rs[9990, 5]);
  IF sdlg.Execute THEN
    BEGIN                 
      IF sdlg.FileName <> '' THEN
      BEGIN
        try
        
          ////////////////////////////////////////////////////////////
          {SetLength(rs, dset.RecordCount, adbg.VisibleColumns.Count);
          rsx := 0;
          with adbg.DataSource.DataSet do
          begin
            DisableControls;
            try
              begin
                First;
                while Eof = False do
                begin
                  for i := 0 to adbg.VisibleColumns.Count - 1 do
                  begin
                    rs[rsx, i] := adbg.VisibleColumns[i].DisplayText;
                  end;
                  rsx := rsx + 1;
                  Next;
                end;
              end;
            finally
              EnableControls;
            end;
          end;
          ShowMessage('RS: ' + rs[0, 1]);}
          ////////////////////////////////////////////////////////////


          length := 1000;
          start := 0;                      
          threadNum := dset.RecordCount div length;
          if dset.RecordCount mod length <> 0 then threadNum := threadNum + 1;
          //ShowMessage('Thread Number: ' + IntToStr(threadNum));
          //SaveDBGridEhToExportFile(TDBGridEhExportAsXLS, adbg, sdlg.FileName, true, start, length);
          SetLength(hThreads, threadNum);
          SetLength(p, threadNum);
          //SetLength(adbgs, threadNum);
          SetLength(dsets, threadNum);
          threadNum := 1;
          for i := 0 to threadNum - 1 do
          begin
            //adbgs[i] := TDBGridEh.Create(exportForm);
            //adbgs[i].DataSource := datasource.Create(exportForm);
            dsets[i] := TADODataSet.Create(nil);
            dsets[i].Recordset := dset.Recordset;
            //adbgs[i].DataSource.DataSet := dsets[i];
            //adbgs[i].Selection.
            //dset.Free;
            //ShowMessage('Total2: ' + IntToStr(adbgs[i].DataSource.DataSet.RecordCount));
            //ShowMessage('Total1: ' + IntToStr(adbg.DataSource.DataSet.RecordCount));

            //adbgs[i].DataSource.DataSet.TAdoDataSet.create(nil);
            //adbgs[i].DataSource.DataSet
            //p[i].ds := dset;
            p[i].rs := @rs;
            p[i].colList := adbg.VisibleColumns;
            p[i].filename := sdlg.FileName + '-' + IntToStr(i) + '.XLS';
            //ShowMessage('filename: ' + p[i].filename);
            p[i].start := start;
            p[i].length := 1000;
            //if start + length - 1 > dset.RecordCount then p[i].length := dset.RecordCount - start + 1;
            hThreads[i] := 0;
            hThreads[i] := CreateThread(nil, 0, @ExportThreadFun, @p[i], 0, ID);
            start := start + length;
            //sleep(100);
            //ShowMessage('start: ' + IntToStr(start));
            //WaitForSingleObject(hThreads[i], INFINITE);
          end;
          //ShowMessage('All threads created!');
          for i := 0 to threadNum - 1 do
          begin
            WaitForSingleObject(hThreads[0], INFINITE);
          end;
          bSuccess := True;
        finally
          for i := 0 to threadNum - 1 do
          begin
            if hThreads[i] <> 0 then CloseHandle(hThreads[i]);
          end;
          //if pp <> nil then FreeMem(pp);
        end;
      END;
    END;
  if bSuccess then
    application.MessageBox(pchar('成功输出数据到' + sdlg.filename + '!'), '完成',0);
end;

procedure TexportForm.FormCreate(Sender: TObject);
begin
  dset.Open;
  //ShowMessage(IntToStr(dset.RecordCount));
  //adbg.AutoFitColWidths := true;
  //application.MessageBox(pchar('load:' + format('%5.0d', [dset.RecordCount]) + '!'), '完成',0);



  
end;

procedure TexportForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dset.Close;
  Action := caFree;
end;

procedure TexportForm.btnExportTxtClick(Sender: TObject);
var
  bSuccess:Boolean;
  start:Integer;
  length:Integer;
  //MyThread: TThread;
begin
  //application.MessageBox(pchar('load:' + format('%5.0d', [TotalRowCount(adbg)]) + '!'), '完成',0);
  bSuccess:=False;
  start:=1;
  length:=500;
  BEGIN
    sdlg.DefaultExt := 'Txt';
    sdlg.Filter := '*.TXT|*.TEXT';
    if SDLG.FileName='' then
      sdlg.FileName := 'export.txt';
    IF sdlg.Execute THEN
    BEGIN
      IF sdlg.FileName <> '' THEN
      BEGIN
        //TMyThread.Create(False);
        //SaveDBGridEhToExportFile(TDBGridEhExportAsXLS, dset, adbg.VisibleColumns, sdlg.FileName, start, length);
        bSuccess:=True;
      END;
    END;
  END;
  if bSuccess then
    application.MessageBox(pchar('成功输出数据到' + sdlg.filename + '!'), '完成',0);
end;

function ExportThreadFun(p: TPRec): DWORD; stdcall;
begin
  SaveDBGridEhToExportFile(TDBGridEhExportAsXLS, p.rs, p.colList, p.filename, p.start, p.length);
  result := 0;
end;

procedure TexportForm.btnCallJavaExportClick(Sender: TObject);
var  
  HttpReq: IXMLHTTPRequest;
  url, msg, rsp: string;
  StartTime, EndTime: cardinal;
begin
  StartTime := GetTickCount;

  url:= 'http://localhost:8080/dsg-web/ExportSvlt?spName=spMatetialByBatchId';
  msg:='msg={"timecut":"20170727141009",  '+
    ' "ip":"xxx", ';
  HttpReq := CoXMLHTTPRequest.Create;
  HttpReq.open('Post', url, False, EmptyParam, EmptyParam);
  //http post
  //HttpReq.setRequestHeader('Accept', 'application/json');
  HttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
  //HttpReq.setRequestHeader('Content-Type', 'application/json');
  try
    HttpReq.Send(msg);
    rsp := (HttpReq.responseText);
    EndTime := GetTickCount;
    ShowMessage(rsp + ' Take time: ' + (IntToStr(EndTime - StartTime) + ' ms'));
   except
     on Ex:Exception do
       ShowMessage(Ex.Message);
   end;  
  
end;

end.
