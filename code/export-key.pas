            gstAll:
              begin
                ExpCols := VisibleColumns;
//                FooterValues := AllocMem(SizeOf(Currency) * ExpCols.Count * DBGridEh.FooterRowCount);
                SetLength(FooterValues, ExpCols.Count * DBGridEh.FooterRowCount);
                WritePrefix;
                if dgTitles in Options then WriteTitle(VisibleColumns);
                First;
                while Eof = False do
                begin
                  WriteRecord(VisibleColumns);
                  CalcFooterValues;
                  Next;
                end;
                for i := 0 to FooterRowCount - 1 do WriteFooter(VisibleColumns, i);
              end;

procedure TDBGridEhExport.WriteRecord(ColumnsList: TColumnsEhList);
var i: Integer;
  AFont: TFont;
  NewBackground: TColor;
//    State:TGridDrawState;
begin
  AFont := TFont.Create;
  try
    for i := 0 to ColumnsList.Count - 1 do
    begin
      AFont.Assign(ColumnsList[i].Font);

      with FColCellParamsEh do
      begin
        Row := -1;
        Col := -1;
        State := [];
        Font := AFont;
        Background := ColumnsList[i].Color;
        NewBackground := ColumnsList[i].Color;
        Alignment := ColumnsList[i].Alignment;
        ImageIndex := ColumnsList[i].GetImageIndex;
        Text := ColumnsList[i].DisplayText;
        CheckboxState := ColumnsList[i].CheckboxState;

        if Assigned(DBGridEh.OnGetCellParams) then
          DBGridEh.OnGetCellParams(DBGridEh, ColumnsList[i], Font, NewBackground, State);

        ColumnsList[i].GetColCellParams(False, FColCellParamsEh);

        Background := NewBackground;

        WriteDataCell(ColumnsList[i], FColCellParamsEh);

      end;
    end;
  finally
    AFont.Free;
  end;
end;


procedure TDBGridEhExportAsText.WriteDataCell(Column: TColumnEh; FColCellParamsEh: TColCellParamsEh);
var s: AnsiString;
begin
  CheckFirstCell;
  s := AnsiString(FColCellParamsEh.Text);
  StreamWriteAnsiString(Stream, s);
//  Stream.Write(PChar(s)^, Length(s));
end;

procedure StreamWriteAnsiString(Stream: TStream; S: AnsiString);
{$IFDEF CIL}
var
  b: TBytes;
{$ENDIF}
begin
{$IFDEF CIL}
    b := BytesOf(AnsiString(S));
    Stream.Write(b, Length(b));
{$ELSE}
    Stream.Write(PAnsiChar(S)^, Length(S));
{$ENDIF}
end;

procedure TDBGridEhExportAsXLS.WriteDataCell(Column: TColumnEh; FColCellParamsEh: TColCellParamsEh);
begin
  if Column.Field = nil then
    WriteBlankCell
  else if Column.GetColumnType = ctKeyPickList then
    WriteStringCell(FColCellParamsEh.Text)
  else if Column.Field.IsNull then
    WriteBlankCell
  else
    with Column.Field do
      case DataType of
        ftSmallint, ftInteger, ftWord, ftAutoInc, ftBytes:
          WriteIntegerCell(AsInteger);
        ftFloat, ftCurrency, ftBCD{$IFDEF EH_LIB_6}, ftFMTBcd{$ENDIF}:
          WriteFloatCell(AsFloat);
      else
        WriteStringCell(FColCellParamsEh.Text);
      end;
end;

procedure TDBGridEhExportAsXLS.WriteBlankCell;
begin
  CXlsBlank[2] := FRow;
  CXlsBlank[3] := FCol;
  StreamWriteWordArray(Stream, CXlsBlank);
//  Stream.WriteBuffer(CXlsBlank, SizeOf(CXlsBlank));
  IncColRow;
end;

procedure TDBGridEhExportAsXLS.WriteFloatCell(const AValue: Double);
begin
  CXlsNumber[2] := FRow;
  CXlsNumber[3] := FCol;
  StreamWriteWordArray(Stream, CXlsNumber);
//  Stream.WriteBuffer(CXlsNumber, SizeOf(CXlsNumber));
  Stream.WriteBuffer(AValue, 8);
  IncColRow;
end;

procedure TDBGridEhExportAsXLS.WriteIntegerCell(const AValue: Integer);
var
  V: Integer;
begin
  CXlsRk[2] := FRow;
  CXlsRk[3] := FCol;
  StreamWriteWordArray(Stream, CXlsRk);
//  Stream.WriteBuffer(CXlsRk, SizeOf(CXlsRk));
  V := (AValue shl 2) or 2;
  Stream.WriteBuffer(V, 4);
  IncColRow;
end;

procedure TDBGridEhExportAsXLS.WriteStringCell(const AValue: string);
var
  L: Word;
begin
  L := Length(AnsiString(AValue));
  CXlsLabel[1] := 8 + L;
  CXlsLabel[2] := FRow;
  CXlsLabel[3] := FCol;
  CXlsLabel[5] := L;
  StreamWriteWordArray(Stream, CXlsLabel);
//  Stream.WriteBuffer(CXlsLabel, SizeOf(CXlsLabel));
  StreamWriteAnsiString(Stream, AnsiString(AValue));
//  Stream.WriteBuffer(Pointer(AValue)^, L);
  IncColRow;
end;

procedure StreamWriteWordArray(Stream: TStream; wr: array of Word);
var
  i: Integer;
begin
  for i := 0 to Length(wr)-1 do
{$IFDEF CIL}
    Stream.Write(wr[i]);
{$ELSE}
    Stream.Write(wr[i], SizeOf(wr[i]));
{$ENDIF}
end;

procedure StreamWriteAnsiString(Stream: TStream; S: AnsiString);
{$IFDEF CIL}
var
  b: TBytes;
{$ENDIF}
begin
{$IFDEF CIL}
    b := BytesOf(AnsiString(S));
    Stream.Write(b, Length(b));
{$ELSE}
    Stream.Write(PAnsiChar(S)^, Length(S));
{$ENDIF}
end;
			  
procedure TDBGridEhExport.CalcFooterValues;
var i, j: Integer;
  Field: TField;
  Footer: TColumnFooterEh;
begin
  for i := 0 to DBGridEh.FooterRowCount - 1 do
    for j := 0 to ExpCols.Count - 1 do
    begin
      Footer := ExpCols[j].UsedFooter(i);
      if Footer.FieldName <> '' then
        Field := DBGridEh.DataSource.DataSet.FindField(Footer.FieldName)
      else
        Field := DBGridEh.DataSource.DataSet.FindField(ExpCols[j].FieldName);
      if Field = nil then Continue;
      case Footer.ValueType of
        fvtSum:
          if (Field.IsNull = False) then
            FooterValues[i * ExpCols.Count + j] := FooterValues[i * ExpCols.Count + j] + Field.AsFloat;
        fvtCount:
          FooterValues[i * ExpCols.Count + j] := FooterValues[i * ExpCols.Count + j] + 1;
      end;
    end;
end;