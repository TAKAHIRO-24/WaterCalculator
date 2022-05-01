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
  private
    { private 宣言 }
    Data1: Array of Array of TValue;
    Data2: Array of Array of TValue;
    ColPos: Array of Integer;

    //Grid・CSVデータの一時保存用
    GridData: Array of Array of String;

    //初期化処理
    procedure InitProc;
    //Grid初期化処理
    procedure InitGrid;
    procedure ViewportPositionChange1( Sender : TObject;
     const OldPosition, NewPosition : TPointF; const Changed : Boolean );
    procedure ViewportPositionChange2( Sender : TObject;
     const OldPosition, NewPosition : TPointF; const Changed : Boolean );
    //部屋番号・利用者表示
    procedure RoomOwnerDisp;
    //データ記録処理
    procedure RecordProc;
    //和暦変換
    procedure DispWareki(year: Integer);
    //CSVデータ　取込
    procedure InputCsvData;
    //取込CSVデータ　画面表示
    procedure InputCsvDataDisp;

    //データチェック処理
    function CellDataCheck(C, R: Integer): Integer;
    //行・列からセルの位置情報を取得する
    function GetCellPositionName(C, R: Integer): String;
    //CSV作成
    function CreateCSV: Boolean;
    //集計年チェック
    function YearCheck: Boolean;
  public
    { public 宣言 }
  end;

var
  F_InputData: TF_InputData;

implementation

uses
  Kyotu;

{$R *.fmx}

//----------------------------------------------------------------------------//
//  内部処理
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
  //Gridにフォーカス
//  if (TControl(Sender).Name = 'StringGrid2') then
  if (F_InputData.ActiveControl.Name = 'StringGrid2') then
  begin
    if not (sw_update.IsChecked) then
    begin  //新規
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
    VKF3: begin  //初期化処理
      bt_canselClick(Sender);
    end;
    VKF9: begin  //データ記録処理
      bt_recordClick(Sender);
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
    MessageDlg('西暦年を入力してください。',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes], 0);
    DelayedSetFocus(et_year);
    Exit;
  end;

  //和暦表示
  DispWareki(StrToIntDef(et_year.Text,0));
end;

//----------------------------------------------------------------------------//
//  onTyping
//----------------------------------------------------------------------------//
procedure TF_InputData.et_yearTyping(Sender: TObject);
begin
  if (Length(et_year.Text) = 4) then
  begin  //西暦入力
    Exit;
  end
  else
  begin  //和暦入力
    lb_nengo.Text := '';
  end;

end;

//----------------------------------------------------------------------------//
//  F6:ファイル選択onClick
//----------------------------------------------------------------------------//
procedure TF_InputData.bt_fileClick(Sender: TObject);
begin
  if not (bt_file.Enabled) then
  begin
    Exit;
  end;

  OpenDialog1.Filter := 'Excelブック(*.xlsx)|*.XLSX|*.xls|*.XLS|CSV(コンマ区切り)(*.csv)|*.CSV';

  if not (OpenDialog1.Execute) then
  begin  //キャンセル押下
    Exit;
  end;

  //フォルダーパス表示
  et_path.Text := OpenDialog1.FileName;
end;

//----------------------------------------------------------------------------//
//  F7:データ抽出onClick
//----------------------------------------------------------------------------//
procedure TF_InputData.bt_datadispClick(Sender: TObject);
begin
  //CSVデータの読み込み
  InputCsvData;

  //Gridにデータ表示
  InputCsvDataDisp;
end;

//----------------------------------------------------------------------------//
//  F3:キャンセルonClick
//----------------------------------------------------------------------------//
procedure TF_InputData.bt_canselClick(Sender: TObject);
begin
  //初期化処理
  InitProc;
end;

//----------------------------------------------------------------------------//
//  F9:記録onClick
//----------------------------------------------------------------------------//
procedure TF_InputData.bt_recordClick(Sender: TObject);
begin
  RecordProc;
end;

//----------------------------------------------------------------------------//
//  onExit
//----------------------------------------------------------------------------//
procedure TF_InputData.sw_updateExit(Sender: TObject);
begin
  //利用者と部屋番号を表示
  RoomOwnerDisp;
end;

//----------------------------------------------------------------------------//
//  onSwitch
//----------------------------------------------------------------------------//
procedure TF_InputData.sw_updateSwitch(Sender: TObject);
begin
  if (sw_update.IsChecked) then
  begin  //更新
    lb_update.Text := '更新';
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
  begin  //新規
    lb_update.Text := '新規';
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
//  Gridの値を取得
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
//  Gridに値を設定
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
//  外部処理
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//  初期化処理
//----------------------------------------------------------------------------//
procedure TF_InputData.InitProc;
begin
  //初期化
  sw_update.IsChecked := False;
  lb_update.Text := '新規';
  et_year.Text := '';
  et_path.Text := '';

  //表示・非表示処理
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

  //Grid初期化処理
  InitGrid;

  //フォーカス設定
  DelayedSetFocus(sw_update);
end;

//----------------------------------------------------------------------------//
//  Grid初期化処理
//----------------------------------------------------------------------------//
procedure TF_InputData.InitGrid;
var
  R, C: Integer; //Row, Collumn
begin
  //配列を初期化
//  SetLength(Data1, StringGrid1.Content.ChildrenCount, StringGrid1.RowCount);
//  SetLength(Data2, StringGrid2.Content.ChildrenCount, StringGrid2.RowCount);
//  SetLength(ColPos, StringGrid2.COntent.ChildrenCount);
  SetLength(Data1, StringGrid1.ColumnCount, StringGrid1.RowCount);
  SetLength(Data2, StringGrid2.ColumnCount, StringGrid2.RowCount);

  //Gridの値を初期化
//  for C := 0 to StringGrid1.Content.ChildrenCount-1 do
  for C := 0 to StringGrid1.ColumnCount-1 do
  begin
    for R := 0 to StringGrid1.RowCount-1 do
    begin
      if (C = 0) then
      begin  //チェックボックス
        Data1[C, R] := 'False';
        StringGrid1.Cells[C, R] := 'False';
      end
      else
      begin  //その他
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


  // Gridのスクロールバーを消去
  StringGrid1.ShowScrollBars  := false;
  StringGrid2.ShowScrollBars  := false;

  // スクロール位置が変更になった時のメソッド割り当て
  StringGrid1.OnViewportPositionChange := ViewportPositionChange1;
  StringGrid2.OnViewportPositionChange := ViewportPositionChange2;
end;

//----------------------------------------------------------------------------//
//  Gridのスクロール同期処理
//----------------------------------------------------------------------------//
procedure TF_InputData.ViewportPositionChange1( Sender : TObject;
 const OldPosition, NewPosition : TPointF; const Changed : Boolean );
begin
  // 左TGridを動かしたら右TGridを動かす
  StringGrid2.ViewportPosition := StringGrid1.ViewportPosition;
end;

procedure TF_InputData.ViewportPositionChange2( Sender : TObject;
 const OldPosition, NewPosition : TPointF; const Changed : Boolean );
begin
  // 右TGridを動かしたら左TGridを動かす
  StringGrid1.ViewportPosition := StringGrid2.ViewportPosition;
end;

//----------------------------------------------------------------------------//
//  利用者・部屋番号表示処理
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
//  セル入力文字確定時処理EditingDone
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
          + '　' + '値：' + StringGrid2.Cells[ACol, ARow]);

    //チェックボックスなしの場合
    if (ErrCode = 1) then
    begin
      if (MessageDlg(MsgList[MsgListType.CHANGE_CHECKED], mtConfirmation, [mbYes, mbNo], 0) = 6) then
      begin
        StringGrid1.Cells[0,ARow] := 'True';
      end;
    end;

    //入力データ削除
    StringGrid2.Cells[ACol, ARow] := '';
  end;
end;

//----------------------------------------------------------------------------//
//  データ記録処理
//----------------------------------------------------------------------------//
procedure TF_InputData.RecordProc;
const
  MsgText = '記録処理が完了しました。'
          + #13#10
          + '画面を初期化しますか？'
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

  //チェック処理
  RowCount := 0;
  for R := 0 to StringGrid2.RowCount - 1 do
  begin
    //チェックボックスにチェックがない場合は次の行へ
    if (StringGrid1.Cells[0,R] = 'False') then
    begin
      Continue;
    end;

    //Gridの有効データ行数を取得
    Inc(RowCount);

    //セルの値が不正ではないか確認
    for C := 0 to StringGrid2.ColumnCount - 1 do
    begin
      ErrCode := CellDataCheck(C,R);
      if (ErrCode > 0) then
      begin
        MsgDlg(ErrCode
              ,GetCellPositionName(C, R)
              + ' ' + '値：' + StringGrid2.Cells[C, R]);
        StringGrid2.SelectCell(C, R);
        Exit;
      end;
    end;
  end;

  //Gridの有効データ行数が0行の場合処理を抜ける
  if (RowCount = 0) then
  begin
    MsgDlg(6, '');
    Exit;
  end;

  //配列初期化(部屋番号・利用者も保存)
  SetLength(GridData, 13+2, RowCount);
  //現在集計行
  CurrentRow := 0;

  //Gridデータを配列に保存(部屋番号・利用者も保存)
  for R := 0 to StringGrid2.RowCount - 1 do  //行
  begin
    //チェックボックスにチェックがない場合は次の行へ
    if (StringGrid1.Cells[0,R] = 'False') then
    begin
      Continue;
    end;

    for C := 0 to (StringGrid2.ColumnCount+2) - 1 do  //列
    begin
      if (C in [0,1]) then
      begin  //部屋番号・利用者
        GridData[C,CurrentRow] := StringGrid1.Cells[C+1,R];
      end
      else
      begin  //前年度3月～今年度3月
        GridData[C,CurrentRow] :=　StringGrid2.Cells[C-2,R];
      end;
    end;

    //集計行を次の行へ
    Inc(CurrentRow);
  end;

  //Excel保存
  if not (CreateCSV) then
  begin
    MsgDlg(0, 'CSV作成処理でエラーが発生しました。');
    Exit;
  end;

  //初期化
  if (MessageDlg(MsgText, mtConfirmation, [mbYes, mbNo], 0) = 6) then
  begin
    InitProc;
  end;
end;

//----------------------------------------------------------------------------//
//  和暦表示
//----------------------------------------------------------------------------//
procedure TF_InputData.DispWareki(year: Integer);
var
  wareki: String;
begin
  //和暦変換
  wareki := ChangeToWareki(year);

  //年号表示
  lb_nengo.Text := copy(wareki, 0, 2);
  //年表示
  et_year.Text := copy(wareki, 2, 4);
  //期間表示
  lb_period1.Text := wareki
                   + '年' + '04月';
  lb_period2.Text := copy(wareki, 0, 2)
                   + FormatFloat('00',StrToInt(copy(wareki, 3, 2)) + 1)
                   + '年' + '03月';

  //期間ラベル表示・非表示制御
  lb_nengo.Visible := True;
  lb_period0.Visible := True;
  lb_period1.Visible := True;
  lb_period2.Visible := True;
end;

//----------------------------------------------------------------------------//
//  データチェック処理
//----------------------------------------------------------------------------//
function TF_InputData.CellDataCheck(C, R: Integer): Integer;
begin

  Result := 0;

  if (StringGrid1.Cells[0,R] = 'False') then
  begin  //チェックボックスなし
    Result := MsgListType.NO_CHECK_ROW;
  end
  else
  if (C <> 0) and
     (StringGrid2.Cells[C-1,R].IsEmpty) then
  begin  //前月が空白
    Result := MsgListType.PREVIOUS_MONTH_IS_EMPTY;
  end
  else
  if (StringGrid2.Cells[C,R].IsEmpty) then
  begin  //空白
    Result := MsgListType.CURRENT_MONTH_IS_EMPTY;
  end
  else
  if (C <> 0) and
     (StrToIntDef(StringGrid2.Cells[C,R],0) < StrToIntDef(StringGrid2.Cells[C-1,R],0)) then
  begin  //前月より値が小さい
    Result := MsgListType.LESS_THAN_PREVIOUS_MONTH;
  end;
end;

//----------------------------------------------------------------------------//
//  部屋番号・入力月取得処理
//----------------------------------------------------------------------------//
function TF_InputData.GetCellPositionName(C, R: Integer): String;
var
  roomNumber: String;
  month: String;
begin
  //部屋番号取得
  roomNumber := roomOwner[0, R];
  //入力月取得
  month := StringGrid2.Columns[C].Header;

  Result := '部屋番号：' + roomNumber + '　' + '月：' + month;
end;

//----------------------------------------------------------------------------//
//  CSV作成処理
//----------------------------------------------------------------------------//
function TF_InputData.CreateCSV: Boolean;
const
  //CSVファイル出力用ヘッダー
  Header: Array[0..14] of String= (
                                   '部屋番号'
                                  ,'利用者名'
                                  ,'3月'
                                  ,'4月'
                                  ,'5月'
                                  ,'6月'
                                  ,'7月'
                                  ,'8月'
                                  ,'9月'
                                  ,'10月'
                                  ,'11月'
                                  ,'12月'
                                  ,'1月'
                                  ,'2月'
                                  ,'3月'
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

  //CSVファイル用
  CommaText := TStringList.Create;
  CsvList := TStringList.Create;

  //初期化
  CommaText.Clear;
  CsvList.Clear;

  try
    //CSV保存ディレクトリ取得
    CsvDirPath := ExtractFileDir(ParamStr(0));
    CsvDirPath := CsvDirPath
                + '\'
                + 'CSV'
                + '\'
                + lb_nengo.Text
                + et_year.Text
                + lb_nendo.Text
                ;

    //ディレクトリ存在確認
    if not (DirectoryExists(CsvDirPath)) then
    begin
      //ディレクトリ作成
      ForceDirectories(CsvDirPath);
    end;

    //CSVファイル名取得
    CsvFilePath := CsvDirPath
                 + '\'
                 + 'データ一覧'
                 + '.csv'
                 ;

//    CsvList.LoadFromFile(CsvFilePath);

    //出力用ファイル作成
    //ヘッダー作成
    for i := Low(Header) to High(Header) do
    begin
      CommaText.Add(Header[i]);
    end;

    //CSV一行保存
    CsvList.Add(CommaText.CommaText);
    //初期化
    CommaText.Clear;

    //明細作成
    for R := Low(GridData[0]) to High(GridData[0]) do
    begin
      for C := Low(GridData) to High(GridData) do
      begin
        CommaText.Add(GridData[C,R]);
      end;
      //CSV一行保存
      CsvList.Add(CommaText.CommaText);
      //初期化
      CommaText.Clear;
    end;

    //CSVファイル保存
    CsvList.SaveToFile(CsvFilePath);

    Result := True;
  finally
    CommaText.Free;
    CsvList.Free;
  end;
end;

//----------------------------------------------------------------------------//
//  CSVデータ取込処理
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
  //CSVデータを一時保存配列に保存
  ExcelApp := CreateOleObject('Excel.Application');
  try
    ExcelBook := ExcelApp.WorkBooks.Open(et_path.Text);
    try
      ExcelSheet := ExcelBook.WorkSheets[1];
      try
        //配列初期化(部屋番号、3月～3月を保存)
        SetLength(GridData, 14, 28);

        //現在行初期化
        CurrentRow := 0;

        for R := Low(outputPos[0]) to High(outputPos[0]) do
        begin
//          if (outputPos[0,R] <> ExcelSheet.range[outputPos[0,CurrentRow]].Value) then
          if (outputPos[0,R] <> ExcelSheet.range['A'+IntToStr(CurrentRow)].Value) then
          begin
            //部屋番号が異なる場合、outputPosを読み飛ばす
//            Inc(CurrentRow);
            Continue;
          end;

          for C := Low(outputPos) to High(outputPos) do
          begin
            if (C = 0) then
            begin  //部屋番号
              GridData[C,R] := outputPos[C,R];
            end
            else
            begin
              GridData[C,R] := ExcelSheet.range[outputPos[C,CurrentRow]].Value;
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
//  取込CSVファイル画面表示
//----------------------------------------------------------------------------//
procedure TF_InputData.InputCsvDataDisp;
var
  i: Integer;
  R, C: Integer;
  CurrentRow: Integer;
begin

  //現在行初期化
  CurrentRow := 0;

  for i := 0 to StringGrid1.RowCount - 1 do
  begin
    for R := Low(GridData[0]) to High(GridData[0]) do
    begin
      //部屋番号が一致するGrid個所に表示する
      if (StringGrid1.Cells[1,i] <> GridData[0,CurrentRow]) then
      begin
        Inc(CurrentRow);
        Continue;
      end;

      //部屋番号が一致するGridが見つかった場合は、Gridに列の値を保存
      for C := 1 to High(GridData) do
      begin
        StringGrid2.Cells[C-1,R] := GridData[C,CurrentRow];
      end;
      Inc(CurrentRow);
    end;
  end;
end;

//----------------------------------------------------------------------------//
//  集計年チェック
//----------------------------------------------------------------------------//
function TF_InputData.YearCheck: Boolean;
var
  yearDigit: Integer;
begin
  Result := False;

  //入力年の桁数を取得
  yearDigit := Length(et_year.Text);

  if (yearDigit >= 1) and
     (yearDigit <= 2) then
  begin  //和暦入力
    if (lb_nengo.Text.IsEmpty) or
       (et_year.Text.IsEmpty) then
    begin  //和暦返還前
      Result := False;
    end
    else
    begin  //和暦変換済み
      Result := True;
    end;
  end
  else
  if (yearDigit = 4) then
  begin  //西暦入力
    Result := True;
  end
  else
  begin  //入力に誤りがある場合
    Result := False;
  end;
end;



end.
