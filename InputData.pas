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
    Grid1: TGrid;
    Grid2: TGrid;
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
    Panel1: TPanel;
    et_year: TEdit;
    lb_nendo: TLabel;
    lb_period1: TLabel;
    lb_period0: TLabel;
    lb_period2: TLabel;
    lb_nengo: TLabel;
    Panel2: TPanel;
    bt_cansel: TButton;
    bt_record: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Grid2SetValue(Sender: TObject; const ACol, ARow: Integer;
      const Value: TValue);
    procedure Grid2GetValue(Sender: TObject; const ACol, ARow: Integer;
      var Value: TValue);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure bt_canselClick(Sender: TObject);
    procedure et_yearExit(Sender: TObject);
  private
    { private 宣言 }
    Data: Array of Array of TValue;
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
//  onKeyDown
//----------------------------------------------------------------------------//
procedure TF_InputData.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  case Key of
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
    InitProc;
  end;
end;

//----------------------------------------------------------------------------//
//  onClick
//----------------------------------------------------------------------------//
procedure TF_InputData.bt_canselClick(Sender: TObject);
begin
  //初期化処理
  InitProc;
end;

//----------------------------------------------------------------------------//
//  Gridの値を取得
//----------------------------------------------------------------------------//
procedure TF_InputData.Grid2SetValue(Sender: TObject; const ACol, ARow: Integer;
  const Value: TValue);
begin
  Data[ACol, ARow] := Value;
end;

//----------------------------------------------------------------------------//
//  Gridに値を設定
//----------------------------------------------------------------------------//
procedure TF_InputData.Grid2GetValue(Sender: TObject; const ACol, ARow: Integer;
  var Value: TValue);
begin
  Value := Data[ACol, ARow];
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
  et_year.Text := '';
  //表示・非表示処理
  lb_nengo.Visible := False;
  lb_period0.Visible := False;
  lb_period1.Visible := False;
  lb_period2.Visible := False;
  //Grid初期化処理
  InitGrid;
  //フォーカス設定
  et_year.SetFocus;
end;

//----------------------------------------------------------------------------//
//  Grid初期化処理
//----------------------------------------------------------------------------//
procedure TF_InputData.InitGrid;
begin
  //配列を初期化
  SetLength(Data, Grid2.Content.ChildrenCount, Grid2.RowCount);
  SetLength(ColPos, Grid2.COntent.ChildrenCount);

  // Gridのスクロールバーを消去
  Grid1.ShowScrollBars  := false;
  Grid2.ShowScrollBars  := false;

  // スクロール位置が変更になった時のメソッド割り当て
  Grid1.OnViewportPositionChange := ViewportPositionChange1;
  Grid2.OnViewportPositionChange := ViewportPositionChange2;
end;

//----------------------------------------------------------------------------//
//  Gridのスクロール同期処理
//----------------------------------------------------------------------------//
procedure TF_InputData.ViewportPositionChange1( Sender : TObject;
 const OldPosition, NewPosition : TPointF; const Changed : Boolean );
begin
  // 左TGridを動かしたら右TGridを動かす
  Grid2.ViewportPosition := Grid1.ViewportPosition;
end;

procedure TF_InputData.ViewportPositionChange2( Sender : TObject;
 const OldPosition, NewPosition : TPointF; const Changed : Boolean );
begin
  // 右TGridを動かしたら左TGridを動かす
  Grid1.ViewportPosition := Grid2.ViewportPosition;
end;

//----------------------------------------------------------------------------//
//  データ記録処理
//----------------------------------------------------------------------------//
procedure TF_InputData.RecordProc;
begin

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
