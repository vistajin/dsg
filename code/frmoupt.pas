UNIT frmoupt;

INTERFACE

USES
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DBGridEh, DBGridEhImpExp;

TYPE
  Tfmoupt = CLASS(TForm)
    RadioGroup1: TRadioGroup;
    btnOUt: TBitBtn;
    btncancel: TBitBtn;
    R1: TRadioButton;
    R5: TRadioButton;
    R4: TRadioButton;
    R3: TRadioButton;
    R2: TRadioButton;
    SDLG: TSaveDialog;
    PROCEDURE btnOUtClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  Private
    { Private declarations }
  Public
    Adbg: Tdbgrideh;
    { Public declarations }
  END;

  procedure EhGridExport(DefaultFile:string;GridExport:TDBGridEh);

VAR
  fmoupt: Tfmoupt;

IMPLEMENTATION

{$R *.dfm}

procedure EhGridExport(DefaultFile:string;GridExport:TDBGridEh);
begin
  with Tfmoupt.Create(nil) do
  begin
    Adbg:=GridExport;
    if Trim(DefaultFile)<>'' then
      SDLG.FileName:=DefaultFile;
    ShowModal;
  end;
end;

PROCEDURE Tfmoupt.btnOUtClick(Sender: TObject);
var
  bSuccess:Boolean;
BEGIN
  bSuccess:=False;
  IF r1.Checked THEN
  BEGIN
//    sdlg.InitialDir := dm.ep;
    sdlg.DefaultExt := 'XLS';
    sdlg.Filter := '*.XLS|*.XLS';
    if SDLG.FileName='' then
      sdlg.FileName := '导出数据.xls';
    IF sdlg.Execute THEN
    BEGIN

      IF sdlg.FileName <> '' THEN
      BEGIN
        SaveDBGridEhToExportFile(TDBGridEhExportAsXLS, Adbg, sdlg.FileName,
          true);
        bSuccess:=True;
      END;
    END;
  END;

  IF r2.Checked THEN
  BEGIN
//    sdlg.InitialDir := dm.ep;
    sdlg.DefaultExt := 'txt';
    sdlg.Filter := '*.TXT|*.TXT';
    if SDLG.FileName='' then
      sdlg.FileName := '导出数据.txt';
    IF sdlg.Execute THEN
    BEGIN

      IF sdlg.FileName <> '' THEN
      BEGIN
        SaveDBGridEhToExportFile(TDBGridEhExportAsText, Adbg, sdlg.FileName,
          true);
        bSuccess:=True;
      END;
    END;
  END;

  IF r3.Checked THEN
  BEGIN
//    sdlg.InitialDir := dm.ep;
    sdlg.DefaultExt := 'csv';
    sdlg.Filter := '*.csv|*.csv';
    if SDLG.FileName='' then
      sdlg.FileName := '导出数据.csv';
    IF sdlg.Execute THEN
    BEGIN

      IF sdlg.FileName <> '' THEN
      BEGIN
        SaveDBGridEhToExportFile(TDBGridEhExportAsCSV, Adbg, sdlg.FileName,
          true);
        bSuccess:=True;
      END;
    END;
  END;

  IF r4.Checked THEN
  BEGIN
//    sdlg.InitialDir := dm.ep;
    sdlg.DefaultExt := 'html';
    sdlg.Filter := '*.html|*.html';
    if SDLG.FileName='' then
      sdlg.FileName := '导出数据.html';
    IF sdlg.Execute THEN
    BEGIN
      IF sdlg.FileName <> '' THEN
      BEGIN
        SaveDBGridEhToExportFile(TDBGridEhExportAsHTML, Adbg, sdlg.FileName,
          true);
        bSuccess:=True;
      END;
    END;
  END;

  IF r5.Checked THEN
  BEGIN
//    sdlg.InitialDir := dm.ep;
    sdlg.DefaultExt := 'rtf';
    sdlg.Filter := '*.rtf|*.rtf';
    if SDLG.FileName='' then
      sdlg.FileName := '导出数据.rtf';
    IF sdlg.Execute THEN
    BEGIN

      IF sdlg.FileName <> '' THEN
      BEGIN
        SaveDBGridEhToExportFile(TDBGridEhExportAsRTF, Adbg, sdlg.FileName,
          true);
        bSuccess:=True;
      END;
    END;
  END;
  if bSuccess then
    application.MessageBox(pchar('成功输出数据到' + sdlg.filename + '!'), '完成',0);

END;

procedure Tfmoupt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

END.
