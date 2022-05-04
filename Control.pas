unit Control;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Layouts, FMX.StdCtrls, FMX.ListBox;

type
  TF_Control = class(TForm)
    StyleBook1: TStyleBook;
    ScaledLayout1: TScaledLayout;
    Panel1: TPanel;
    Panel2: TPanel;
    StringGrid1: TStringGrid;
    Grd_Column0: TCheckColumn;
    Grd_Column1: TStringColumn;
    Grd_Column2: TStringColumn;
    Grd_Column3: TStringColumn;
    Grd_Column4: TStringColumn;
    Grd_Column5: TStringColumn;
    cmb_masta: TComboBox;
    bt_cansel: TButton;
    bt_record: TButton;
    Grd_Column6: TStringColumn;
    Grd_Column8: TStringColumn;
    Grd_Column9: TStringColumn;
    Grd_Column10: TStringColumn;
    Grd_Column11: TStringColumn;
    Grd_Column12: TStringColumn;
    Grd_Column13: TStringColumn;
    Grd_Column14: TStringColumn;
    Grd_Column15: TStringColumn;
    Grd_Column7: TStringColumn;
    Grd_Column16: TStringColumn;
    procedure FormCreate(Sender: TObject);
    procedure Grid1SetValue(Sender: TObject; const ACol, ARow: Integer;
      const Value: TValue);
    procedure Grid1GetValue(Sender: TObject; const ACol, ARow: Integer;
      var Value: TValue);
    procedure bt_canselClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure bt_recordClick(Sender: TObject);
    procedure cmb_mastaChange(Sender: TObject);
  private
    { private 宣言 }
    Data1: Array of Array of TValue;
    Data2: Array of Array of TValue;
    ColPos: Array of Integer;

    //初期化処理
    procedure InitProc;
    //Grid初期化処理
    procedure InitGrid;
    //データ記録処理
    procedure RecordProc;
  public
    { public 宣言 }
  end;

var
  F_Control: TF_Control;

implementation

uses
  Kyotu;

{$R *.fmx}

//----------------------------------------------------------------------------//
//  内部処理
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//  onKeyDown
//----------------------------------------------------------------------------//
procedure TF_Control.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  case Key of
    VKF3: begin  //初期化処理
      bt_canselClick(Sender);
    end;
    VKF9: begin  //データ記録処理
      bt_recordClick(Sender);
    end;
  end;
end;

//----------------------------------------------------------------------------//
//  onCreate
//----------------------------------------------------------------------------//
procedure TF_Control.FormCreate(Sender: TObject);
begin
  InitProc;
end;

//----------------------------------------------------------------------------//
//  F3:キャンセルonClick
//----------------------------------------------------------------------------//
procedure TF_Control.bt_canselClick(Sender: TObject);
begin
  //初期化処理
  InitProc;
end;

//----------------------------------------------------------------------------//
//  F9:記録onClick
//----------------------------------------------------------------------------//
procedure TF_Control.bt_recordClick(Sender: TObject);
begin
  RecordProc;
end;

//----------------------------------------------------------------------------//
//  コンボボックスonChange
//----------------------------------------------------------------------------//
procedure TF_Control.cmb_mastaChange(Sender: TObject);
begin
  InitProc;
end;

//----------------------------------------------------------------------------//
//  Gridの値を取得
//----------------------------------------------------------------------------//
procedure TF_Control.Grid1SetValue(Sender: TObject; const ACol, ARow: Integer;
  const Value: TValue);
begin
  Data1[ACol, ARow] := Value;
end;

//----------------------------------------------------------------------------//
//  Gridに値を設定
//----------------------------------------------------------------------------//
procedure TF_Control.Grid1GetValue(Sender: TObject; const ACol, ARow: Integer;
  var Value: TValue);
begin
  Value := Data1[ACol, ARow];
end;

//----------------------------------------------------------------------------//
//  外部処理
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//  初期化処理
//----------------------------------------------------------------------------//
procedure TF_Control.InitProc;
begin
  //iniファイル読み込み
  GetIniFile;

  //Grid初期化処理
  InitGrid;
end;

//----------------------------------------------------------------------------//
//  Grid初期化処理
//----------------------------------------------------------------------------//
procedure TF_Control.InitGrid;
const
  //各マスタのGrid列の横幅
  ComponentWidth: Array[0..2] of Array[0..16] of Integer = (
                     //一般マスタ
                     (28,100,200,115,100,100,0,0,0,0,0,0,0,0,0,0,0)
                     //住居マスタ
                    ,(28,150,300,165,0,0,0,0,0,0,0,0,0,0,0,0,0)
                     //取込マスタ
                    ,(28,100,200,100,100,100,100,100,100,100,100,100,100,100,100,100,100)
                      );
  //各マスタのGrid列のヘッダー
  ComponentHeader: Array[0..2] of Array[0..16] of String = (
                     //一般マスタ
                     ('','','','','','','','','','','','','','','','','')
                     //住居マスタ
                    ,('','部屋番号','利用者','年間水道料入金額','','','','','','','','','','','','','')
                     //取込マスタ
                    ,('','部屋番号','利用者','部屋番号','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月','1月','2月','3月')
                      );

var
  i: Integer;
  R, C: Integer;  //Row, Collumn
  Component: TComponent;
begin
  //コンボボックスの値によって表示を変更
  case (cmb_masta.ItemIndex) of
    //一般マスタ
    0: begin
      //Gridの設定
      StringGrid1.RowCount := Length(roomOwner[0]);
      for i := 0 to StringGrid1.ColumnCount - 1 do
      begin
        Component := Self.FindComponent('Grd_column' + IntToStr(i));
        //横幅
        TStringColumn(Component).Width := ComponentWidth[cmb_masta.ItemIndex][i];
        //ヘッダー
        TStringColumn(Component).Header := ComponentHeader[cmb_masta.ItemIndex][i];
        //編集可否
        if (True) then
        begin  //全て編集不可
          TStringColumn(Component).ReadOnly := True;
        end;
      end;

      //配列を初期化
      SetLength(Data1, StringGrid1.ColumnCount, StringGrid1.RowCount);

      //Gridの値を初期化
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
    end;
    //住居マスタ
    1: begin
      //Gridの設定
      StringGrid1.RowCount := Length(roomOwner[0]);
      for i := 0 to StringGrid1.ColumnCount - 1 do
      begin
        Component := Self.FindComponent('Grd_column' + IntToStr(i));
        //横幅
        TStringColumn(Component).Width := ComponentWidth[cmb_masta.ItemIndex][i];
        //ヘッダー
        TStringColumn(Component).Header := ComponentHeader[cmb_masta.ItemIndex][i];
        //編集可否
        if (i in [1]) then
        begin  //部屋番号は編集不可
          TStringColumn(Component).ReadOnly := True;
        end
        else
        if (i in [2,3]) then
        begin  //利用者、年間水道料入金額は編集可能
          TStringColumn(Component).ReadOnly := False;
        end
        else
        begin  //その他
          TStringColumn(Component).ReadOnly := True;
        end;
      end;

      //配列を初期化
      SetLength(Data1, StringGrid1.ColumnCount, StringGrid1.RowCount);

      //Gridの値を初期化
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
          if (C IN [1,2,3]) then
          begin  //部屋番号、利用者、年間水道料入金額
            Data1[C, R] := roomOwner[C-1, R];
            StringGrid1.Cells[C, R] := roomOwner[C-1, R];
          end
          else
          begin  //その他
            Data1[C, R] := '';
            StringGrid1.Cells[C, R] := '';
          end;
        end;
      end;
    end;
    //取込マスタ
    2: begin
      //Gridの設定
      StringGrid1.RowCount := Length(roomOwner[0]);
      for i := 0 to StringGrid1.ColumnCount - 1 do
      begin
        Component := Self.FindComponent('Grd_column' + IntToStr(i));
        //横幅
        TStringColumn(Component).Width := ComponentWidth[cmb_masta.ItemIndex][i];
        //ヘッダー
        TStringColumn(Component).Header := ComponentHeader[cmb_masta.ItemIndex][i];
        //編集可否
        if (i in [1,2]) then
        begin  //部屋番号、利用者は編集不可
          TStringColumn(Component).ReadOnly := True;
        end
        else
        begin  //その他
          TStringColumn(Component).ReadOnly := False;
        end;
      end;

      //配列を初期化
      SetLength(Data1, StringGrid1.ColumnCount, StringGrid1.RowCount);

      //Gridの値を初期化
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
          if (C IN [1,2]) then
          begin  //部屋番号、利用者
            Data1[C, R] := roomOwner[C-1, R];
            StringGrid1.Cells[C, R] := roomOwner[C-1, R];
          end
          else
          begin  //部屋番号、前年度3月～今年度3月
            Data1[C, R] := outputPos[C-2,R];
            StringGrid1.Cells[C, R] := outputPos[C-2,R];
          end;
        end;
      end;
    end;
  end;

  // Gridのスクロールバーを消去
  StringGrid1.ShowScrollBars  := false;
end;

//----------------------------------------------------------------------------//
//  データ記録処理
//----------------------------------------------------------------------------//
procedure TF_Control.RecordProc;
var
  R, C: Integer;
  ErrFlg: Boolean;
begin
  //
  if not (bt_Record.Enabled) then
  begin
    Exit;
  end;

  //コンボボックスの値によって記録内容を変更
  case (cmb_masta.ItemIndex) of
    //一般マスタ
    0: begin

    end;
    //住居マスタ
    1: begin
      //Gridデータを配列に保存
      for R := Low(roomOwner[0]) to High(roomOwner[0]) do
      begin
        for C := Low(roomOwner) to High(roomOwner) do
        begin
          if (C in [1,2,3]) then
          begin  //部屋番号、利用者、年間水道料入金額
            roomOwner[C-1, R] := StringGrid1.Cells[C, R]
          end
          else
          begin
            //読み飛ばす
          end;
        end;
      end;
    end;
    //取込マスタ
    2: begin
      //Gridデータを配列に保存
      for R := Low(outputPos[0]) to High(outputPos[0]) do
      begin
        for C := Low(outputPos) to High(outputPos) do
        begin
          if (C in [3..16]) then
          begin  //部屋番号、前年度3月～今年度3月
            outputPos[C-2, R] := StringGrid1.Cells[C, R]
          end
          else
          begin
            //読み飛ばす
          end;
        end;
      end;
    end;
  end;

  //iniファイル書き込み
  ErrFlg := SetIniFile(cmb_masta.ItemIndex);

  if not (ErrFlg) then
  begin
    MsgDlg(0, '設定ファイル書き込みでエラーが発生しました。');
    Exit;
  end;

  //画面初期化
  InitProc;

end;


end.
