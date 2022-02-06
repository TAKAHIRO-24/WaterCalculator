unit Kyotu;

interface

uses
  System.SysUtils, IniFiles;

  //IniFile読み取り
  procedure GetIniFile;
  //IniFile書き込み
  procedure SetIniFile;
  //和暦変換
  function ChangeToWareki(year: Integer): String;

implementation

const
  PGNAME = 'WaterCalculator';

//----------------------------------------------------------------------------//
//  IniFileからの読み取り
//----------------------------------------------------------------------------//
procedure GetIniFile;
var
  i: Integer;
  iniFile: TIniFile;
  Data: Array of Array of String;
begin
  iniFile := TIniFile.Create(ChangeFileExt(ExtractFilePath(ParamStr(0)), PGNAME+'.ini'));

  with iniFile do
  begin
    try
      //部屋番号と利用者を取得
      SetLength(Data, 2, 28);  //(room, owner)
      for i := 0 to 27 do
      begin
        Data[0,i] := ReadString('部屋番号', 'room'+FormatFloat('00',i), '');
        Data[1,i] := ReadString('利用者', 'owner'+FormatFloat('00',i), '');
      end;
    finally
      Free;
    end;
  end;
end;

//----------------------------------------------------------------------------//
//  IniFileへの書き込み
//----------------------------------------------------------------------------//
procedure SetIniFile;
var
  i: Integer;
  iniFile: TIniFile;
  Data: Array of Array of String;
begin
  iniFile := TIniFile.Create(ChangeFileExt(ExtractFilePath(ParamStr(0)), '.ini'));

  with iniFile do
  begin
    try
      //部屋番号と利用者を設定
      for i := 0 to 27 do
      begin
        WriteString('部屋番号', 'room'+FormatFloat('00',i),'');
        WriteString('利用者', 'owner'+FormatFloat('00',i),'');
      end;
    finally
      Free;
    end;
  end;
end;

//----------------------------------------------------------------------------//
//  和暦変換
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

end.
