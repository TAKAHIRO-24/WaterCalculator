unit InputData;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid,
  FMX.Layouts, FMX.StdCtrls, FMX.Edit, Vcl.Dialogs, system.win.comobj, ExcelXP,
  ExcelCS;

type
  TF_InputData = class(TForm)
    StyleBook1: TStyleBook;
    ScaledLayout1: TScaledLayout;
    GridPanelLayout1: TGridPanelLayout;
    Panel1: TPanel;
    et_year: TEdit;
    lb_nendo: TLabel;
    lb_period1: TLabel;
    lb_period0: TLabel;
    lb_period2: TLabel;
    lb_nengo: TLabel;
    bt_cansel: TButton;
    bt_record: TButton;
    bt_file: TButton;
    sw_update: TSwitch;
    lb_update: TLabel;
    et_path: TEdit;
    OpenDialog1: TOpenDialog;
    bt_datadisp: TButton;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    IntegerColumn1: TIntegerColumn;
    StringColumn1: TStringColumn;
    IntegerColumn2: TIntegerColumn;
    IntegerColumn3: TIntegerColumn;
    IntegerColumn4: TIntegerColumn;
    IntegerColumn5: TIntegerColumn;
    IntegerColumn6: TIntegerColumn;
    IntegerColumn7: TIntegerColumn;
    IntegerColumn8: TIntegerColumn;
    IntegerColumn9: TIntegerColumn;
    IntegerColumn10: TIntegerColumn;
    IntegerColumn11: TIntegerColumn;
    IntegerColumn12: TIntegerColumn;
    IntegerColumn13: TIntegerColumn;
    IntegerColumn14: TIntegerColumn;
    CheckColumn1: TCheckColumn;
    ExcelApp: TExcelApplication;
    ExcelBook: TExcelWorkbook;
    ExcelSheet: TExcelWorksheet;
    bt_close: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Grid1SetValue(Sender: TObject; const ACol, ARow: Integer;
      const Value: TValue);
    procedure Grid1GetValue(Sender: TObject; const ACol, ARow: Integer;
      var Value: TValue);
    procedure Grid2SetValue(Sender: TObject; const ACol, ARow: Integer;
      const Value: TValue);
    procedure Grid2GetValue(Sender: TObject; const ACol, ARow: Integer;
      var Value: TValue);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure bt_canselClick(Sender: TObject);
    procedure et_yearExit(Sender: TObject);
    procedure bt_fileClick(Sender: TObject);
    procedure sw_updateSwitch(Sender: TObject);
    procedure bt_datadispClick(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure sw_updateExit(Sender: TObject);
    procedure bt_recordClick(Sender: TObject);
    procedure StringGrid2EditingDone(Sender: TObject; const ACol,
      ARow: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure et_yearTyping(Sender: TObject);
    procedure bt_closeClick(Sender: TObject);
  private
    { private ???? }
    Data1: Array of Array of TValue;
    Data2: Array of Array of TValue;
    ColPos: Array of Integer;

    //Grid?ECSV?f?[?^???????????p
    GridData: Array of Array of String;

    //??????????
    procedure InitProc;
    //Grid??????????
    procedure InitGrid;
    procedure ViewportPositionChange1( Sender : TObject;
     const OldPosition, NewPosition : TPointF; const Changed : Boolean );
    procedure ViewportPositionChange2( Sender : TObject;
     const OldPosition, NewPosition : TPointF; const Changed : Boolean );
    //?????????E???p???\??
    procedure RoomOwnerDisp;
    //?f?[?^?L?^????
    procedure RecordProc;
    //?a??????
    procedure DispWareki(year: Integer);
    //CSV?f?[?^?@????
    procedure InputCsvData;
    //????CSV?f?[?^?@?????\??
    procedure InputCsvDataDisp;

    //?f?[?^?`?F?b?N????
    function CellDataCheck(C, R: Integer): Integer;
    //?s?E???????Z???????u??????????????
    function GetCellPositionName(C, R: Integer): String;
    //CSV????
    function CreateCSV: Boolean;
    //?W?v?N?`?F?b?N
    function YearCheck: Boolean;
  public
    { public ???? }
  end;

var
  F_InputData: TF_InputData;

implementation

uses
  Kyotu;

{$R *.fmx}

//----------------------------------------------------------------------------//
//  ????????
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//  onCreate
//----------------------------------------------------------------------------//
procedure TF_InputData.FormCreate(Sender: TObject);
begin
  InitProc;
end;

//----------------------------------------------------------------------------//
//  onClose
//----------------------------------------------------------------------------//
procedure TF_InputData.FormClose(Sender: TObject; var Action: TCloseAction);
begin

end;

//----------------------------------------------------------------------------//
//  onFocusChanged
//----------------------------------------------------------------------------//
procedure TF_InputData.FormFocusChanged(Sender: TObject);
begin
  //Grid???t?H?[?J?X
//  if (TControl(Sender).Name = 'StringGrid2') then
  if (F_InputData.ActiveControl.Name = 'StringGrid2') then
  begin
    if not (sw_update.IsChecked) then
    begin  //?V?K
      RoomOwnerDisp;
    end;
  end;
end;

//----------------------------------------------------------------------------//
//  onKeyDown
//----------------------------------------------------------------------------//
procedure TF_InputData.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  case Key of
    VKF6: begin
      bt_fileClick(Sender);
    end;
    VKF3: begin  //??????????
      bt_canselClick(Sender);
    end;
    VKF9: begin  //?f?[?^?L?^????
      bt_recordClick(Sender);
    end;
    VKF12: begin  //?I??
      bt_closeClick(Sender);
    end;
  end;
end;

//----------------------------------------------------------------------------//
//  onExit
//----------------------------------------------------------------------------//
procedure TF_InputData.et_yearExit(Sender: TObject);
var
  yearDigit: Integer;
begin

  if not (YearCheck) then
  begin
    MessageDlg('?????N???????????????????B',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes], 0);
    DelayedSetFocus(et_year);
    Exit;
  end;

  //?a???\??
  DispWareki(StrToIntDef(et_year.Text,0));
end;

//----------------------------------------------------------------------------//
//  onTyping
//----------------------------------------------------------------------------//
procedure TF_InputData.et_yearTyping(Sender: TObject);
begin
  if (Length(et_year.Text) = 4) then
  begin  //????????
    Exit;
  end
  else
  begin  //?a??????
    lb_nengo.Text := '';
  end;

end;

//----------------------------------------------------------------------------//
//  F6:?t?@?C???I??onClick
//----------------------------------------------------------------------------//
procedure TF_InputData.bt_fileClick(Sender: TObject);
begin
  if not (bt_file.Enabled) then
  begin
    Exit;
  end;

  OpenDialog1.Filter := 'Excel?u?b?N(*.xlsx)|*.XLSX|*.xls|*.XLS|CSV(?R???}??????)(*.csv)|*.CSV';

  if not (OpenDialog1.Execute) then
  begin  //?L?????Z??????
    Exit;
  end;

  //?t?H???_?[?p?X?\??
  et_path.Text := OpenDialog1.FileName;
end;

//----------------------------------------------------------------------------//
//  F7:?f?[?^???oonClick
//----------------------------------------------------------------------------//
procedure TF_InputData.bt_datadispClick(Sender: TObject);
begin
  //CSV?f?[?^??????????
  InputCsvData;

  //Grid???f?[?^?\??
  InputCsvDataDisp;
end;

//----------------------------------------------------------------------------//
//  F3:?L?????Z??onClick
//----------------------------------------------------------------------------//
procedure TF_InputData.bt_canselClick(Sender: TObject);
begin
  //??????????
  InitProc;
end;

//----------------------------------------------------------------------------//
//  F9:?L?^onClick
//----------------------------------------------------------------------------//
procedure TF_InputData.bt_recordClick(Sender: TObject);
begin
  RecordProc;
end;

//----------------------------------------------------------------------------//
//  F12:?I??onClick
//----------------------------------------------------------------------------//
procedure TF_InputData.bt_closeClick(Sender: TObject);
begin
  Close;
end;

//----------------------------------------------------------------------------//
//  onExit
//----------------------------------------------------------------------------//
procedure TF_InputData.sw_updateExit(Sender: TObject);
begin
  //???p???????????????\??
  RoomOwnerDisp;
end;

//----------------------------------------------------------------------------//
//  onSwitch
//----------------------------------------------------------------------------//
procedure TF_InputData.sw_updateSwitch(Sender: TObject);
begin
  if (sw_update.IsChecked) then
  begin  //?X?V
    lb_update.Text := '?X?V';
    lb_nengo.Text := '';
    et_year.Text := '';
    lb_period1.Text := '';
    lb_period2.Text := '';
//    et_year.Enabled := False;
    et_year.Enabled := True;
    bt_file.Enabled := True;
    bt_datadisp.Enabled := True;
    et_path.Enabled := True;
//    lb_nendo.Visible := False;
//    et_year.Visible := False;
    lb_nendo.Visible := True;
    et_year.Visible := True;
    lb_period0.Visible := False;
  end
  else
  begin  //?V?K
    lb_update.Text := '?V?K';
    lb_nengo.Text := '';
    et_year.Text := '';
    lb_period1.Text := '';
    lb_period2.Text := '';
    et_year.Enabled := True;
    bt_file.Enabled := False;
    bt_datadisp.Enabled := False;
    et_path.Enabled := False;
    lb_nendo.Visible := True;
    et_year.Visible := True;
    lb_period0.Visible := False;
  end;
end;

//----------------------------------------------------------------------------//
//  Grid???l??????
//----------------------------------------------------------------------------//
procedure TF_InputData.Grid1SetValue(Sender: TObject; const ACol, ARow: Integer;
  const Value: TValue);
begin
  Data1[ACol, ARow] := Value;
end;

procedure TF_InputData.Grid2SetValue(Sender: TObject; const ACol, ARow: Integer;
  const Value: TValue);
begin
  Data2[ACol, ARow] := Value;
end;

//----------------------------------------------------------------------------//
//  Grid???l??????
//----------------------------------------------------------------------------//
procedure TF_InputData.Grid1GetValue(Sender: TObject; const ACol, ARow: Integer;
  var Value: TValue);
begin
  Value := Data1[ACol, ARow];
end;

procedure TF_InputData.Grid2GetValue(Sender: TObject; const ACol, ARow: Integer;
  var Value: TValue);
begin
  Value := Data2[ACol, ARow];
end;

//----------------------------------------------------------------------------//
//  ?O??????
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//  ??????????
//----------------------------------------------------------------------------//
procedure TF_InputData.InitProc;
begin
  //??????
  sw_update.IsChecked := False;
  lb_update.Text := '?V?K';
  et_year.Text := '';
  et_path.Text := '';

  //?\???E???\??????
  lb_nengo.Visible := False;
  lb_period0.Visible := False;
  lb_period1.Visible := False;
  lb_period2.Visible := False;
  lb_nendo.Visible := True;
  et_year.Visible := True;

  bt_file.Enabled := False;
  bt_datadisp.Enabled := False;
  bt_record.Enabled := True;
  et_path.Enabled := False;

  //Grid??????????
  InitGrid;

  //?t?H?[?J?X????
  DelayedSetFocus(sw_update);
end;

//----------------------------------------------------------------------------//
//  Grid??????????
//----------------------------------------------------------------------------//
procedure TF_InputData.InitGrid;
var
  R, C: Integer; //Row, Collumn
begin
  //?z??????????
//  SetLength(Data1, StringGrid1.Content.ChildrenCount, StringGrid1.RowCount);
//  SetLength(Data2, StringGrid2.Content.ChildrenCount, StringGrid2.RowCount);
//  SetLength(ColPos, StringGrid2.COntent.ChildrenCount);
  SetLength(Data1, StringGrid1.ColumnCount, StringGrid1.RowCount);
  SetLength(Data2, StringGrid2.ColumnCount, StringGrid2.RowCount);

  //Grid???l????????
//  for C := 0 to StringGrid1.Content.ChildrenCount-1 do
  for C := 0 to StringGrid1.ColumnCount-1 do
  begin
    for R := 0 to StringGrid1.RowCount-1 do
    begin
      if (C = 0) then
      begin  //?`?F?b?N?{?b?N?X
        Data1[C, R] := 'False';
        StringGrid1.Cells[C, R] := 'False';
      end
      else
      begin  //??????
        Data1[C, R] := '';
        StringGrid1.Cells[C, R] := '';
      end;
    end;
  end;

//  for C := 0 to StringGrid2.Content.ChildrenCount-1 do
  for C := 0 to StringGrid2.ColumnCount-1 do
  begin
    for R := 0 to StringGrid2.RowCount-1 do
    begin
      Data2[C, R] := '';
      StringGrid2.Cells[C, R] := '';
    end;
  end;


  // Grid???X?N???[???o?[??????
  StringGrid1.ShowScrollBars  := false;
  StringGrid2.ShowScrollBars  := false;

  // ?X?N???[?????u?????X???????????????\?b?h????????
  StringGrid1.OnViewportPositionChange := ViewportPositionChange1;
  StringGrid2.OnViewportPositionChange := ViewportPositionChange2;
end;

//----------------------------------------------------------------------------//
//  Grid???X?N???[??????????
//----------------------------------------------------------------------------//
procedure TF_InputData.ViewportPositionChange1( Sender : TObject;
 const OldPosition, NewPosition : TPointF; const Changed : Boolean );
begin
  // ??TGrid?????????????ETGrid????????
  StringGrid2.ViewportPosition := StringGrid1.ViewportPosition;
end;

procedure TF_InputData.ViewportPositionChange2( Sender : TObject;
 const OldPosition, NewPosition : TPointF; const Changed : Boolean );
begin
  // ?ETGrid??????????????TGrid????????
  StringGrid1.ViewportPosition := StringGrid2.ViewportPosition;
end;

//----------------------------------------------------------------------------//
//  ???p???E?????????\??????
//----------------------------------------------------------------------------//
procedure TF_InputData.RoomOwnerDisp;
var
  R, C: Integer;  // Row, Column
begin
  for C := 0 to 1 do
  begin
    for R := Low(roomOwner[C]) to High(roomOwner[C]) do
    begin
      StringGrid1.Cells[C+1,R] := roomOwner[C,R];
    end;
  end;
end;

//----------------------------------------------------------------------------//
//  ?Z???????????m????????EditingDone
//----------------------------------------------------------------------------//
procedure TF_InputData.StringGrid2EditingDone(Sender: TObject; const ACol,
  ARow: Integer);
var
  ErrCode: Integer;
begin
  ErrCode := CellDataCheck(ACol, ARow);
  if (ErrCode > 0) then
  begin
    MsgDlg(ErrCode
          ,GetCellPositionName(ACol, ARow)
          + '?@' + '?l?F' + StringGrid2.Cells[ACol, ARow]);

    //?`?F?b?N?{?b?N?X??????????
    if (ErrCode = 1) then
    begin
      if (MessageDlg(MsgList[MsgListType.CHANGE_CHECKED], mtConfirmation, [mbYes, mbNo], 0) = 6) then
      begin
        StringGrid1.Cells[0,ARow] := 'True';
      end;
    end;

    //?????f?[?^????
    StringGrid2.Cells[ACol, ARow] := '';
  end;
end;

//----------------------------------------------------------------------------//
//  ?f?[?^?L?^????
//----------------------------------------------------------------------------//
procedure TF_InputData.RecordProc;
const
  MsgText = '?L?^???????????????????B'
          + #13#10
          + '?????????????????????H'
          ;
var
  i: Integer;
  R, C: Integer;  // Row, Column
  ErrCode: Integer;
  RowCount: Integer;
  CurrentRow: Integer;
begin
  if not (bt_record.Enabled) then
  begin
    Exit;
  end;

  //?`?F?b?N????
  RowCount := 0;
  for R := 0 to StringGrid2.RowCount - 1 do
  begin
    //?`?F?b?N?{?b?N?X???`?F?b?N?????????????????s??
    if (StringGrid1.Cells[0,R] = 'False') then
    begin
      Continue;
    end;

    //Grid???L???f?[?^?s????????
    Inc(RowCount);

    //?Z?????l???s?????????????m?F
    for C := 0 to StringGrid2.ColumnCount - 1 do
    begin
      ErrCode := CellDataCheck(C,R);
      if (ErrCode > 0) then
      begin
        MsgDlg(ErrCode
              ,GetCellPositionName(C, R)
              + ' ' + '?l?F' + StringGrid2.Cells[C, R]);
        StringGrid2.SelectCell(C, R);
        Exit;
      end;
    end;
  end;

  //Grid???L???f?[?^?s????0?s??????????????????
  if (RowCount = 0) then
  begin
    MsgDlg(6, '');
    Exit;
  end;

  //?z????????(?????????E???p????????)
  SetLength(GridData, 13+2, RowCount);
  //?????W?v?s
  CurrentRow := 0;

  //Grid?f?[?^???z????????(?????????E???p????????)
  for R := 0 to StringGrid2.RowCount - 1 do  //?s
  begin
    //?`?F?b?N?{?b?N?X???`?F?b?N?????????????????s??
    if (StringGrid1.Cells[0,R] = 'False') then
    begin
      Continue;
    end;

    for C := 0 to (StringGrid2.ColumnCount+2) - 1 do  //??
    begin
      if (C in [0,1]) then
      begin  //?????????E???p??
        GridData[C,CurrentRow] := StringGrid1.Cells[C+1,R];
      end
      else
      begin  //?O?N?x3???`???N?x3??
        GridData[C,CurrentRow] :=?@StringGrid2.Cells[C-2,R];
      end;
    end;

    //?W?v?s???????s??
    Inc(CurrentRow);
  end;

  //Excel????
  if not (CreateCSV) then
  begin
    MsgDlg(0, 'CSV???????????G???[???????????????B');
    Exit;
  end;

  //??????
  if (MessageDlg(MsgText, mtConfirmation, [mbYes, mbNo], 0) = 6) then
  begin
    InitProc;
  end;
end;

//----------------------------------------------------------------------------//
//  ?a???\??
//----------------------------------------------------------------------------//
procedure TF_InputData.DispWareki(year: Integer);
var
  wareki: String;
begin
  //?a??????
  wareki := ChangeToWareki(year);

  //?N???\??
  lb_nengo.Text := copy(wareki, 0, 2);
  //?N?\??
  et_year.Text := copy(wareki, 2, 4);
  //?????\??
  lb_period1.Text := wareki
                   + '?N' + '04??';
  lb_period2.Text := copy(wareki, 0, 2)
                   + FormatFloat('00',StrToInt(copy(wareki, 3, 2)) + 1)
                   + '?N' + '03??';

  //???????x???\???E???\??????
  lb_nengo.Visible := True;
  lb_period0.Visible := True;
  lb_period1.Visible := True;
  lb_period2.Visible := True;
end;

//----------------------------------------------------------------------------//
//  ?f?[?^?`?F?b?N????
//----------------------------------------------------------------------------//
function TF_InputData.CellDataCheck(C, R: Integer): Integer;
begin

  Result := 0;

  if (StringGrid1.Cells[0,R] = 'False') then
  begin  //?`?F?b?N?{?b?N?X????
    Result := MsgListType.NO_CHECK_ROW;
  end
  else
  if (C <> 0) and
     (StringGrid2.Cells[C-1,R].IsEmpty) then
  begin  //?O????????
    Result := MsgListType.PREVIOUS_MONTH_IS_EMPTY;
  end
  else
  if (StringGrid2.Cells[C,R].IsEmpty) then
  begin  //????
    Result := MsgListType.CURRENT_MONTH_IS_EMPTY;
  end
  else
  if (C <> 0) and
     (StrToIntDef(StringGrid2.Cells[C,R],0) < StrToIntDef(StringGrid2.Cells[C-1,R],0)) then
  begin  //?O???????l????????
    Result := MsgListType.LESS_THAN_PREVIOUS_MONTH;
  end;
end;

//----------------------------------------------------------------------------//
//  ?????????E??????????????
//----------------------------------------------------------------------------//
function TF_InputData.GetCellPositionName(C, R: Integer): String;
var
  roomNumber: String;
  month: String;
begin
  //????????????
  roomNumber := roomOwner[0, R];
  //??????????
  month := StringGrid2.Columns[C].Header;

  Result := '?????????F' + roomNumber + '?@' + '???F' + month;
end;

//----------------------------------------------------------------------------//
//  CSV????????
//----------------------------------------------------------------------------//
function TF_InputData.CreateCSV: Boolean;
const
  //CSV?t?@?C???o???p?w?b?_?[
  Header: Array[0..14] of String= (
                                   '????????'
                                  ,'???p????'
                                  ,'3??'
                                  ,'4??'
                                  ,'5??'
                                  ,'6??'
                                  ,'7??'
                                  ,'8??'
                                  ,'9??'
                                  ,'10??'
                                  ,'11??'
                                  ,'12??'
                                  ,'1??'
                                  ,'2??'
                                  ,'3??'
                                  );
var
  i: Integer;
  R, C: Integer;
  CommaText: TStringList;
  CsvList : TStringList;
  CsvDirPath: String;
  CsvFilePath: String;
begin
  Result := False;

  //CSV?t?@?C???p
  CommaText := TStringList.Create;
  CsvList := TStringList.Create;

  //??????
  CommaText.Clear;
  CsvList.Clear;

  try
    //CSV?????f?B???N?g??????
    CsvDirPath := ExtractFileDir(ParamStr(0));
    CsvDirPath := CsvDirPath
                + '\'
                + 'CSV'
                + '\'
                + lb_nengo.Text
                + et_year.Text
                + lb_nendo.Text
                ;

    //?f?B???N?g???????m?F
    if not (DirectoryExists(CsvDirPath)) then
    begin
      //?f?B???N?g??????
      ForceDirectories(CsvDirPath);
    end;

    //CSV?t?@?C????????
    CsvFilePath := CsvDirPath
                 + '\'
                 + '?f?[?^????'
                 + '.csv'
                 ;

//    CsvList.LoadFromFile(CsvFilePath);

    //?o???p?t?@?C??????
    //?w?b?_?[????
    for i := Low(Header) to High(Header) do
    begin
      CommaText.Add(Header[i]);
    end;

    //CSV???s????
    CsvList.Add(CommaText.CommaText);
    //??????
    CommaText.Clear;

    //????????
    for R := Low(GridData[0]) to High(GridData[0]) do
    begin
      for C := Low(GridData) to High(GridData) do
      begin
        CommaText.Add(GridData[C,R]);
      end;
      //CSV???s????
      CsvList.Add(CommaText.CommaText);
      //??????
      CommaText.Clear;
    end;

    //CSV?t?@?C??????
    CsvList.SaveToFile(CsvFilePath);

    Result := True;
  finally
    CommaText.Free;
    CsvList.Free;
  end;
end;

//----------------------------------------------------------------------------//
//  CSV?f?[?^????????
//----------------------------------------------------------------------------//
procedure TF_InputData.InputCsvData;
var
  R, C: Integer;
  CurrentRow: Integer;
  TempValue: String;
  ExcelApp: Olevariant;
  ExcelBook: Olevariant;
  ExcelSheet: Olevariant;
begin
  //CSV?f?[?^???????????z????????
  ExcelApp := CreateOleObject('Excel.Application');
  try
    ExcelBook := ExcelApp.WorkBooks.Open(et_path.Text);
    try
      ExcelSheet := ExcelBook.WorkSheets[1];
      try
        //?z????????(?????????A3???`3????????)
        SetLength(GridData, 14, 28);

        //?????s??????
        CurrentRow := 0;

        for R := Low(outputPos[0]) to High(outputPos[0]) do
        begin

          if (outputPos[1,R].IsEmpty) then
          begin
            //???????u??????????????????????????
            Continue;
          end;

          TempValue := ExcelSheet.range[outputPos[1,R]].Value;

          if (outputPos[0,R] <> TempValue) then
          begin
            //?????????????????????AoutputPos????????????
            Continue;
          end;

          for C := Low(outputPos) to High(outputPos) do
          begin
            if (C = 0) then
            begin  //????????

            end
            else
            begin  //?????????A?O?N?x3???`???N?x3??
              GridData[C-1,CurrentRow] := ExcelSheet.range[outputPos[C,R]].Value;
            end;
          end;
          Inc(CurrentRow);
        end;
      finally
        ExcelSheet := unAssigned;
      end;
    finally
      ExcelBook := unAssigned;
    end;
  finally
//    ExcelApp := unAssigned;
    ExcelApp.Quit;
  end;
end;

//----------------------------------------------------------------------------//
//  ????CSV?t?@?C???????\??
//----------------------------------------------------------------------------//
procedure TF_InputData.InputCsvDataDisp;
var
  i: Integer;
  R, C: Integer;
begin

  for i := 0 to StringGrid1.RowCount - 1 do
  begin
    for R := Low(GridData[0]) to High(GridData[0]) do
    begin
      //?????????????v????Grid???????\??????
      if (StringGrid1.Cells[1,i] <> GridData[0,R]) then
      begin
        Continue;
      end;

      //?????????????v????Grid???????????????????AGrid???????l??????
      for C := 1 to High(GridData) do
      begin
        StringGrid2.Cells[C-1,i] := GridData[C,R];
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//
//  ?W?v?N?`?F?b?N
//----------------------------------------------------------------------------//
function TF_InputData.YearCheck: Boolean;
var
  yearDigit: Integer;
begin
  Result := False;

  //?????N????????????
  yearDigit := Length(et_year.Text);

  if (yearDigit >= 1) and
     (yearDigit <= 2) then
  begin  //?a??????
    if (lb_nengo.Text.IsEmpty) or
       (et_year.Text.IsEmpty) then
    begin  //?a???????O
      Result := False;
    end
    else
    begin  //?a??????????
      Result := True;
    end;
  end
  else
  if (yearDigit = 4) then
  begin  //????????
    Result := True;
  end
  else
  begin  //????????????????????
    Result := False;
  end;
end;



end.
