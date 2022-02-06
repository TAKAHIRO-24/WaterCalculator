unit Kyotu;

interface

uses
  System.SysUtils, IniFiles;

  //IniFile�ǂݎ��
  procedure GetIniFile;
  //IniFile��������
  procedure SetIniFile;
  //�a��ϊ�
  function ChangeToWareki(year: Integer): String;

implementation

const
  PGNAME = 'WaterCalculator';

//----------------------------------------------------------------------------//
//  IniFile����̓ǂݎ��
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
      //�����ԍ��Ɨ��p�҂��擾
      SetLength(Data, 2, 28);  //(room, owner)
      for i := 0 to 27 do
      begin
        Data[0,i] := ReadString('�����ԍ�', 'room'+FormatFloat('00',i), '');
        Data[1,i] := ReadString('���p��', 'owner'+FormatFloat('00',i), '');
      end;
    finally
      Free;
    end;
  end;
end;

//----------------------------------------------------------------------------//
//  IniFile�ւ̏�������
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
      //�����ԍ��Ɨ��p�҂�ݒ�
      for i := 0 to 27 do
      begin
        WriteString('�����ԍ�', 'room'+FormatFloat('00',i),'');
        WriteString('���p��', 'owner'+FormatFloat('00',i),'');
      end;
    finally
      Free;
    end;
  end;
end;

//----------------------------------------------------------------------------//
//  �a��ϊ�
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
