unit FormCreate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Layouts;

type
  TF_FormCreate = class(TForm)
    StyleBook1: TStyleBook;
    Panel1: TPanel;
    Panel2: TPanel;
    bt_cansel: TButton;
    bt_close: TButton;
    et_year: TEdit;
    bt_create: TButton;
    lb_nengo: TLabel;
    lb_nendo: TLabel;
    ScaledLayout1: TScaledLayout;
    procedure et_yearExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure bt_canselClick(Sender: TObject);
    procedure bt_createClick(Sender: TObject);
    procedure et_yearKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure et_yearTyping(Sender: TObject);
  private
    { private 宣言 }
    //CSVファイル読込データ
    CsvData: array of array of String;
    //CSVファイル読込マスタ
    CsvMaster: array of array of String;

    //初期化
    procedure InitProc;
    //データ作成
    procedure DataCreate;
    //和暦表示
    procedure DispWareki(year: Integer);
    //集計年チェック
    function YearCheck: Boolean;
    //データ読み込み
    function DataReadFromCsv: Boolean;
    //マスタ読み込み
    function MastarReadFromCsv: Boolean;
  public
    { public 宣言 }
  end;

var
  F_FormCreate: TF_FormCreate;

const
  CSV_FILE_NAME = 'データ一覧.csv';

implementation

uses
  Kyotu;

{$R *.fmx}

//----------------------------------------------------------------------------//
//  onCreate
//----------------------------------------------------------------------------//
procedure TF_FormCreate.FormCreate(Sender: TObject);
begin
  //初期化
  InitProc;
end;

//----------------------------------------------------------------------------//
//  onKeyDown
//----------------------------------------------------------------------------//
procedure TF_FormCreate.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  case Key of
    VKF3: begin  //初期化処理
      bt_canselClick(Sender);
    end;
    VKF9: begin  //データ記録処理
      bt_createClick(Sender);
    end;
  end;
end;

//----------------------------------------------------------------------------//
//  F3Click
//----------------------------------------------------------------------------//
procedure TF_FormCreate.bt_canselClick(Sender: TObject);
begin
  //初期化処理
  InitProc;
end;

//----------------------------------------------------------------------------//
//  F9Click
//----------------------------------------------------------------------------//
procedure TF_FormCreate.bt_createClick(Sender: TObject);
begin
  //集計処理
  DataCreate;
end;

//----------------------------------------------------------------------------//
//  onExit
//----------------------------------------------------------------------------//
procedure TF_FormCreate.et_yearExit(Sender: TObject);
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
procedure TF_FormCreate.et_yearTyping(Sender: TObject);
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
//  onKeyDown
//----------------------------------------------------------------------------//
procedure TF_FormCreate.et_yearKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  case Key of
    VKRETURN: begin
//       et_yearExit(Sender);
    end;
  end;
end;

//----------------------------------------------------------------------------//
//  和暦表示
//----------------------------------------------------------------------------//
procedure TF_FormCreate.DispWareki(year: Integer);
var
  wareki: String;
begin
  //和暦変換
  wareki := ChangeToWareki(year);

  //年号表示
  lb_nengo.Text := copy(wareki, 0, 2);
  //年表示
  et_year.Text := copy(wareki, 3, 2);

  //ラベル表示・非表示制御
  lb_nengo.Visible := True;
end;

//----------------------------------------------------------------------------//
//  初期化
//----------------------------------------------------------------------------//
procedure TF_FormCreate.InitProc;
begin
  //初期化
  lb_nengo.Text := '';
  et_year.Text := '';

  //表示・非表示
  lb_nengo.Visible := False;

  //フォーカス
  DelayedSetFocus(et_year);
end;

//----------------------------------------------------------------------------//
//  データ作成
//----------------------------------------------------------------------------//
procedure TF_FormCreate.DataCreate;
begin
  if not (bt_create.Enabled) then
  begin
    Exit;
  end;

  //データチェック
  if not (YearCheck) then
  begin
    MessageDlg('西暦年を入力してください。',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes], 0);
    DelayedSetFocus(et_year);
    Exit;
  end;

  //西暦表示の場合
  if (Length(et_year.Text) = 4) then
  begin
    DispWareki(StrToIntDef(et_year.Text,0));
  end;

  //データ読み込み
  if not (DataReadFromCsv) then
  begin
    MessageDlg('データ読込処理でエラーが発生しました。',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes], 0);
    DelayedSetFocus(et_year);
    Exit;
  end;

  //マスタ読み込み
  if not (MastarReadFromCsv) then
  begin
    MessageDlg('マスタ読込処理でエラーが発生しました。',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes], 0);
    DelayedSetFocus(et_year);
    Exit;
  end;

  //帳票ファイルコピー

  //集計

  //集計ファイル作成

end;

//----------------------------------------------------------------------------//
//  集計年チェック
//----------------------------------------------------------------------------//
function TF_FormCreate.YearCheck: Boolean;
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

//----------------------------------------------------------------------------//
//  データ読み込み
//----------------------------------------------------------------------------//
function TF_FormCreate.DataReadFromCsv: Boolean;
var
  C, R: Integer;
  RowCount: Integer;
  CsvData1: TStringList;
  CsvData2: TStringList;
  CsvDirPath: String;
  CsvFilePath: String;
begin

  Result := False;

  CsvData1 := TStringList.Create;
  CsvData2 := TStringList.Create;

  try
    //ファイルを読み込み
    CsvDirPath := ExtractFilePath(ParamStr(0))
                + '\'
                + 'CSV'
                + '\'
                + lb_nengo.Text
                + et_year.Text
                + lb_nendo.Text
                ;
    CsvFilePath := CsvDirPath
                 + '\'
                 + CSV_FILE_NAME
                 ;
    CsvData1.LoadFromFile(CsvFilePath);

    //行数取得
    RowCount := CsvData1.Count;

    //データを配列に保存
    for R := 0 to RowCount - 1 do
    begin
      if (R = 0) then
      begin
        //一行目は列名なので読み飛ばす
        Continue;
      end;

      //R行目のデータをカンマ区切りで取得
      CsvData2.CommaText := CsvData1.Strings[R];

      for C := 0 to 14 do
      begin
        {部屋番号・利用者名・3月・4月・5月・6月・7月・8月・9月・10月・11月・12月・1月・2月・3月}
        CsvData[C,R-1] := CsvData2.Strings[C];

        //一時保存テキストをクリア
        CsvData2.Clear;
      end;
    end;

    Result := True;

  finally
    CsvData1.Free;
    CsvData2.Free;
  end;

end;

//----------------------------------------------------------------------------//
//  マスタ読み込み
//----------------------------------------------------------------------------//
function TF_FormCreate.MastarReadFromCsv: Boolean;
begin

end;


end.
