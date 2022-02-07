unit InputData;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid,
  FMX.Layouts, FMX.StdCtrls, FMX.Edit;

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
    procedure FormCreate(Sender: TObject);
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
    procedure Grid1SetValue(Sender: TObject; const ACol, ARow: Integer;
      const Value: TValue);
    procedure Grid1GetValue(Sender: TObject; const ACol, ARow: Integer;
      var Value: TValue);
  private
    { private 宣言 }
    Data1: Array of Array of TValue;
    Data2: Array of Array of TValue;
    ColPos: Array of Integer;

    //初期化処理
    procedure InitProc;
    //Grid初期化処理
    procedure InitGrid;
    procedure ViewportPositionChange1( Sender : TObject;
     const OldPosition, NewPosition : TPointF; const Changed : Boolean );
    procedure ViewportPositionChange2( Sender : TObject;
     const OldPosition, NewPosition : TPointF; const Changed : Boolean );
    //データ記録処理
    procedure RecordProc;
    //和暦変換
    procedure DispWareki(year: Integer);
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
//  onFocusChanged
//----------------------------------------------------------------------------//
procedure TF_InputData.FormFocusChanged(Sender: TObject);
var
  DStr: String;
begin
  DStr := '0';
  if (True) then
  begin
    DStr := '1';
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
      InitProc;
    end;
    VKF9: begin  //データ記録処理
      RecordProc;
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
  //入力年の桁数を取得
  yearDigit := Length((Sender as TEdit).Text);

  if (yearDigit >= 1) and
     (yearDigit <= 2) then
  begin  //和暦入力
    DispWareki(StrToIntDef(et_year.Text,0));
  end
  else
  if (yearDigit = 4) then
  begin  //西暦入力
    DispWareki(StrToIntDef(et_year.Text,0));
  end
  else
  begin  //入力に誤りがある場合
    MessageDlg('西暦年を入力してください。',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes], 0);
    DelayedSetFocus(et_year);
  end;
end;

//----------------------------------------------------------------------------//
//  onClick
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

procedure TF_InputData.bt_datadispClick(Sender: TObject);
begin
  //CSVデータの読み込み

  //Gridにデータ表示
end;

procedure TF_InputData.bt_canselClick(Sender: TObject);
begin
  //初期化処理
  InitProc;
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
    et_year.Enabled := False;
    bt_file.Enabled := True;
    bt_datadisp.Enabled := True;
    et_path.Enabled := True;
    lb_nendo.Visible := False;
    et_year.Visible := False;
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

  //表示・非表示処理
  lb_nengo.Visible := False;
  lb_period0.Visible := False;
  lb_period1.Visible := False;
  lb_period2.Visible := False;
  lb_nendo.Visible := True;
  et_year.Visible := True;

  bt_file.Enabled := False;
  bt_datadisp.Enabled := False;
  bt_record.Enabled := False;
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
      Data1[C, R] := '';
      StringGrid1.Cells[C, R] := '';
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
//  データ記録処理
//----------------------------------------------------------------------------//
procedure TF_InputData.RecordProc;
begin
  if not (bt_record.Enabled) then
  begin
    Exit;
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
end.
