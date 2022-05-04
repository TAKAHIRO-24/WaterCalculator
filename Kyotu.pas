unit Kyotu;

interface

uses
  System.SysUtils, Vcl.Dialogs, IniFiles, System.Classes, FMX.Controls
  ,System.IOUtils
  ;

type  //メッセージリスト
  TMsgListType = record
    NO_CHECK_ROW             : Integer;
    PREVIOUS_MONTH_IS_EMPTY  : Integer;
    CURRENT_MONTH_IS_EMPTY   : Integer;
    LESS_THAN_PREVIOUS_MONTH : Integer;
    CHANGE_CHECKED           : Integer;
  end;

  //IniFile読み取り
  procedure GetIniFile;
  //フォーカス移動
  procedure DelayedSetFocus(control: TControl);
  //メッセージ表示
  procedure MsgDlg(id: Integer; Msg: String); overload;
  procedure MsgDlg(id: Integer); overload;
  //IniFile書き込み
  function SetIniFile(IniType: Integer): Boolean;
  //和暦変換
  function ChangeToWareki(year: Integer): String;
  //カンマ付き数値文字列を数値に変換
  function CommaToStr(cur: String): String;

var
  roomOwner: Array of Array of String;
  outputPos: Array of Array of String;

const
  //--------------------------------------------------------------------------//
  //メッセージリスト
  //MsgListTypeの番号とMsgListの文字列は順番が対応している。
  MsgListType: TMsgListType = (
                               NO_CHECK_ROW             : 1;
                               PREVIOUS_MONTH_IS_EMPTY  : 2;
                               CURRENT_MONTH_IS_EMPTY   : 3;
                               LESS_THAN_PREVIOUS_MONTH : 4;
                               CHANGE_CHECKED           : 5;
                               );
  MsgList: Array[0..6] of String = (
                                     ''
                                    ,'記録なし行です。' + #13#10 + '記録するにはチェックボックスをONにしてください。'
                                    ,'前月が空白です。' + #13#10 + '数値を入力してください。'
                                    ,'空白は入力できません。'
                                    ,'前月より大きい値を入力してください。'
                                    ,'チェックボックスをONにしますか？'
                                    ,'保存可能レコードが存在しません。' + #13#10 + '記録する行は左端のチェックボックスをONにしてください。'
                                    );
  //--------------------------------------------------------------------------//
  //iniファイル名
  IniFileName: array[0..4] of String = (
                                        ''
                                        ,'RoomOwner'
                                        ,'OutputPos'
                                        ,''
                                        ,''
                                        );

  //--------------------------------------------------------------------------//
  //部屋番号とiniファイルの部屋連番の置換
  changedRoomNumber: array[0..27] of String = (
                                                '201'  //00
                                               ,'202'  //01
                                               ,'203'  //02
                                               ,'205'  //03
                                               ,'301'  //04
                                               ,'302'  //05
                                               ,'303'  //06
                                               ,'305'  //07
                                               ,'401'  //08
                                               ,'402'  //09
                                               ,'403'  //10
                                               ,'405'  //11
                                               ,'501'  //12
                                               ,'502'  //13
                                               ,'503'  //14
                                               ,'505'  //15
                                               ,'601'  //16
                                               ,'602'  //17
                                               ,'603'  //18
                                               ,'605'  //19
                                               ,'701'  //20
                                               ,'702'  //21
                                               ,'703'  //22
                                               ,'705'  //23
                                               ,'801'  //24
                                               ,'802'  //25
                                               ,'803'  //26
                                               ,'805'  //27
                                               );


implementation

//----------------------------------------------------------------------------//
//  IniFileからの読み取り
//----------------------------------------------------------------------------//
procedure GetIniFile;
var
  i, j: Integer;
  iniFile: TIniFile;
begin

  //*********************//
  //    RoomOwner.ini    //
  //*********************//

  iniFile := TIniFile.Create(ChangeFileExt(ExtractFilePath(ParamStr(0)), IniFileName[1] + '.ini'));

  with iniFile do
  begin
    try
      //部屋番号と利用者を取得
      SetLength(roomOwner, 3, 28);  //(room, owner)
      for i := 0 to 27 do
      begin
        roomOwner[0,i] := ReadString('部屋番号', 'room'+FormatFloat('00',i), '');
        roomOwner[1,i] := ReadString('利用者', 'owner'+FormatFloat('00',i), '');
        roomOwner[2,i] := ReadString('年間水道料入金額', 'deposit'+FormatFloat('00',i), '');
      end;
    finally
      Free;
    end;
  end;

  //*********************//
  //    OutputPos.ini    //
  //*********************//

  iniFile := TIniFile.Create(ChangeFileExt(ExtractFilePath(ParamStr(0)), IniFileName[2] + '.ini'));

  with iniFile do
  begin
    try
      //部屋番号とCSVファイルの印字位置を取得
      SetLength(outputPos, 15, 28);  //(room, roomPos, month00, month01...month12)
      for i := 0 to 27 do
      begin
        //部屋番号
        outputPos[0,i] := changedRoomNumber[i];
        //部屋番号印字位置
        outputPos[1,i] := ReadString('部屋'+FormatFloat('00',i), 'room', '');
        //各月の印字位置
        for j := 0 to 12 do
        begin
          outputPos[j+2,i] := ReadString('部屋'+FormatFloat('00',i), 'month'+FormatFloat('00',j), '');
        end;
      end;
    finally
      Free;
    end;
  end;

end;

//----------------------------------------------------------------------------//
//  IniFileへの書き込み
//----------------------------------------------------------------------------//
function SetIniFile(IniType: Integer): Boolean;
var
  i, j: Integer;
  iniFile: TIniFile;
  IniFilePath: String;
  IniFilePath2: String;
  IniDirPath: String;
  Date: TDateTime;
begin

  Result := False;

  //バックアップの作成
  //------------------------------------------//
  //ini保存ディレクトリ取得
  IniDirPath := ExtractFileDir(ParamStr(0));

  //現在のiniファイルパスを取得
  IniFilePath := IniDirPath
               + '\'
               + IniFileName[IniType]
               + '.ini'
               ;

  //バックアップ先フォルダ
  IniDirPath := IniDirPath
              + '\'
              + 'INI_BK'
              ;

  //ディレクトリ存在確認
  if not (DirectoryExists(IniDirPath)) then
  begin
    //ディレクトリ作成
    ForceDirectories(IniDirPath);
  end;

  //バックアップ先のiniファイルパスを取得
  IniFilePath2 := IniDirPath
                + '\'
                + IniFileName[IniType]
                + FormatDateTime('yyyymmddhhnnss', Now)
                + '.ini'
                ;

  //ファイルのコピー
  TFile.Copy(IniFilePath, IniFIlePath2, True);
  //------------------------------------------//


  //iniファイルオブジェクト生成
  iniFile := TIniFile.Create(ChangeFileExt(ExtractFilePath(ParamStr(0)), IniFileName[IniType] + '.ini'));

  with iniFile do
  begin
    try
      case IniType of
        //*********************//
        //    RoomOwner.ini    //
        //*********************//
        1: begin
          //部屋番号と利用者を設定
          for i := 0 to 27 do
          begin
            WriteString('部屋番号', 'room'+FormatFloat('00',i), roomOwner[0,i]);
            WriteString('利用者', 'owner'+FormatFloat('00',i), roomOwner[1,i]);
            WriteString('年間水道料入金額', 'deposit'+FormatFloat('00',i),roomOwner[2,i]);
          end;
        end;
        //*********************//
        //    OutputPos.ini    //
        //*********************//
        2: begin
          //各利用者・各月ごとのCSV印字位置を保存
          for i := 0 to 27 do
          begin
            //部屋番号印字位置
            WriteString('部屋'+FormatFloat('00',i), 'room', outputPos[1,i]);
            //各月の印字位置
            for j := 0 to 12 do
            begin
              WriteString('部屋'+FormatFloat('00',i), 'month'+FormatFloat('00',j), outputPos[j+2,i]);
            end;
          end;
        end;
      end;
    finally
      Free;
    end;
  end;

  Result := True;
end;

//----------------------------------------------------------------------------//
//  フォーカス移動
//  引数　：　コンポーネント
//----------------------------------------------------------------------------//
procedure DelayedSetFocus(control: TControl);
begin
  TThread.CreateAnonymousThread(
    procedure
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          control.SetFocus;
        end
      );
    end
  ).Start;
end;

//----------------------------------------------------------------------------//
//  メッセージ表示
//  引数　： id: Integer 表示文字列
//         Msg: String 追加文字列
//  戻値　：　Boolean
//----------------------------------------------------------------------------//
procedure MsgDlg(id: Integer; Msg: String);
var
  MsgText: String;
begin
  //テキスト作成
  MsgText := MsgList[id];
  if not (Msg.IsEmpty) then
  begin
    MsgText := MsgText + #13#10 + Msg
  end;

  MessageDlg(MsgText, mtWarning, [mbOK], 0);
end;

procedure MsgDlg(id: Integer);
begin
  MsgDlg(id, '');
end;

//----------------------------------------------------------------------------//
//  和暦変換
//  引数　： 西暦年（2021）
//  戻値　：　和暦年（令和03）
//----------------------------------------------------------------------------//
function ChangeToWareki(year: Integer): String;
var
  Date: String;
  wareki: String;
begin
  Result := '';

  Date := FormatFloat('0000/00/00', StrToInt(IntToStr(year) + '0101')); //year/01/01
  wareki := FormatDateTime('ggee', StrToDate(Date));

  Result := wareki;
end;

//----------------------------------------------------------------------------//
//  カンマ付き数値文字列を数値に変換
//  引数　： String
//  戻値　：　Integer
//----------------------------------------------------------------------------//
function CommaToStr(cur: String): String;
const
  NumTable = ['0' .. '9', '-', '.'];
var
  dst: String;
  i: Byte;
  CFlg: Boolean;
begin
  for i := 1 to Length(cur) do
    // '0'..'9','-','.'以外は無視
    if (cur[i] in NumTable) then
      begin
        CFlg := True;
        // '-'が先頭の時以外は無視
        if (cur[i] = '-') and (i > 1) then
          CFlg := False;
        // '.'２個目以降は無視
        if (cur[i] = '.') and (Pos('.', dst) > 0) then
          CFlg := False;
        if CFlg then
          dst := dst + cur[i];
      end;
  if (Length(dst) = 0) then
    result := '0'
  else
    result := dst;
end;


end.
