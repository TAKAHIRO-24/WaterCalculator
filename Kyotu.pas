unit Kyotu;

interface

uses
  System.SysUtils, Vcl.Dialogs, IniFiles, System.Classes, FMX.Controls
  ,System.IOUtils
  ;

type  //���b�Z�[�W���X�g
  TMsgListType = record
    NO_CHECK_ROW             : Integer;
    PREVIOUS_MONTH_IS_EMPTY  : Integer;
    CURRENT_MONTH_IS_EMPTY   : Integer;
    LESS_THAN_PREVIOUS_MONTH : Integer;
    CHANGE_CHECKED           : Integer;
  end;

  //IniFile�ǂݎ��
  procedure GetIniFile;
  //�t�H�[�J�X�ړ�
  procedure DelayedSetFocus(control: TControl);
  //���b�Z�[�W�\��
  procedure MsgDlg(id: Integer; Msg: String); overload;
  procedure MsgDlg(id: Integer); overload;
  //IniFile��������
  function SetIniFile(IniType: Integer): Boolean;
  //�a��ϊ�
  function ChangeToWareki(year: Integer): String;
  //�J���}�t�����l������𐔒l�ɕϊ�
  function CommaToStr(cur: String): String;

var
  roomOwner: Array of Array of String;
  outputPos: Array of Array of String;

const
  //--------------------------------------------------------------------------//
  //���b�Z�[�W���X�g
  //MsgListType�̔ԍ���MsgList�̕�����͏��Ԃ��Ή����Ă���B
  MsgListType: TMsgListType = (
                               NO_CHECK_ROW             : 1;
                               PREVIOUS_MONTH_IS_EMPTY  : 2;
                               CURRENT_MONTH_IS_EMPTY   : 3;
                               LESS_THAN_PREVIOUS_MONTH : 4;
                               CHANGE_CHECKED           : 5;
                               );
  MsgList: Array[0..6] of String = (
                                     ''
                                    ,'�L�^�Ȃ��s�ł��B' + #13#10 + '�L�^����ɂ̓`�F�b�N�{�b�N�X��ON�ɂ��Ă��������B'
                                    ,'�O�����󔒂ł��B' + #13#10 + '���l����͂��Ă��������B'
                                    ,'�󔒂͓��͂ł��܂���B'
                                    ,'�O�����傫���l����͂��Ă��������B'
                                    ,'�`�F�b�N�{�b�N�X��ON�ɂ��܂����H'
                                    ,'�ۑ��\���R�[�h�����݂��܂���B' + #13#10 + '�L�^����s�͍��[�̃`�F�b�N�{�b�N�X��ON�ɂ��Ă��������B'
                                    );
  //--------------------------------------------------------------------------//
  //ini�t�@�C����
  IniFileName: array[0..4] of String = (
                                        ''
                                        ,'RoomOwner'
                                        ,'OutputPos'
                                        ,''
                                        ,''
                                        );

  //--------------------------------------------------------------------------//
  //�����ԍ���ini�t�@�C���̕����A�Ԃ̒u��
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
//  IniFile����̓ǂݎ��
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
      //�����ԍ��Ɨ��p�҂��擾
      SetLength(roomOwner, 3, 28);  //(room, owner)
      for i := 0 to 27 do
      begin
        roomOwner[0,i] := ReadString('�����ԍ�', 'room'+FormatFloat('00',i), '');
        roomOwner[1,i] := ReadString('���p��', 'owner'+FormatFloat('00',i), '');
        roomOwner[2,i] := ReadString('�N�Ԑ����������z', 'deposit'+FormatFloat('00',i), '');
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
      //�����ԍ���CSV�t�@�C���̈󎚈ʒu���擾
      SetLength(outputPos, 15, 28);  //(room, roomPos, month00, month01...month12)
      for i := 0 to 27 do
      begin
        //�����ԍ�
        outputPos[0,i] := changedRoomNumber[i];
        //�����ԍ��󎚈ʒu
        outputPos[1,i] := ReadString('����'+FormatFloat('00',i), 'room', '');
        //�e���̈󎚈ʒu
        for j := 0 to 12 do
        begin
          outputPos[j+2,i] := ReadString('����'+FormatFloat('00',i), 'month'+FormatFloat('00',j), '');
        end;
      end;
    finally
      Free;
    end;
  end;

end;

//----------------------------------------------------------------------------//
//  IniFile�ւ̏�������
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

  //�o�b�N�A�b�v�̍쐬
  //------------------------------------------//
  //ini�ۑ��f�B���N�g���擾
  IniDirPath := ExtractFileDir(ParamStr(0));

  //���݂�ini�t�@�C���p�X���擾
  IniFilePath := IniDirPath
               + '\'
               + IniFileName[IniType]
               + '.ini'
               ;

  //�o�b�N�A�b�v��t�H���_
  IniDirPath := IniDirPath
              + '\'
              + 'INI_BK'
              ;

  //�f�B���N�g�����݊m�F
  if not (DirectoryExists(IniDirPath)) then
  begin
    //�f�B���N�g���쐬
    ForceDirectories(IniDirPath);
  end;

  //�o�b�N�A�b�v���ini�t�@�C���p�X���擾
  IniFilePath2 := IniDirPath
                + '\'
                + IniFileName[IniType]
                + FormatDateTime('yyyymmddhhnnss', Now)
                + '.ini'
                ;

  //�t�@�C���̃R�s�[
  TFile.Copy(IniFilePath, IniFIlePath2, True);
  //------------------------------------------//


  //ini�t�@�C���I�u�W�F�N�g����
  iniFile := TIniFile.Create(ChangeFileExt(ExtractFilePath(ParamStr(0)), IniFileName[IniType] + '.ini'));

  with iniFile do
  begin
    try
      case IniType of
        //*********************//
        //    RoomOwner.ini    //
        //*********************//
        1: begin
          //�����ԍ��Ɨ��p�҂�ݒ�
          for i := 0 to 27 do
          begin
            WriteString('�����ԍ�', 'room'+FormatFloat('00',i), roomOwner[0,i]);
            WriteString('���p��', 'owner'+FormatFloat('00',i), roomOwner[1,i]);
            WriteString('�N�Ԑ����������z', 'deposit'+FormatFloat('00',i),roomOwner[2,i]);
          end;
        end;
        //*********************//
        //    OutputPos.ini    //
        //*********************//
        2: begin
          //�e���p�ҁE�e�����Ƃ�CSV�󎚈ʒu��ۑ�
          for i := 0 to 27 do
          begin
            //�����ԍ��󎚈ʒu
            WriteString('����'+FormatFloat('00',i), 'room', outputPos[1,i]);
            //�e���̈󎚈ʒu
            for j := 0 to 12 do
            begin
              WriteString('����'+FormatFloat('00',i), 'month'+FormatFloat('00',j), outputPos[j+2,i]);
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
//  �t�H�[�J�X�ړ�
//  �����@�F�@�R���|�[�l���g
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
//  ���b�Z�[�W�\��
//  �����@�F id: Integer �\��������
//         Msg: String �ǉ�������
//  �ߒl�@�F�@Boolean
//----------------------------------------------------------------------------//
procedure MsgDlg(id: Integer; Msg: String);
var
  MsgText: String;
begin
  //�e�L�X�g�쐬
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
//  �a��ϊ�
//  �����@�F ����N�i2021�j
//  �ߒl�@�F�@�a��N�i�ߘa03�j
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
//  �J���}�t�����l������𐔒l�ɕϊ�
//  �����@�F String
//  �ߒl�@�F�@Integer
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
    // '0'..'9','-','.'�ȊO�͖���
    if (cur[i] in NumTable) then
      begin
        CFlg := True;
        // '-'���擪�̎��ȊO�͖���
        if (cur[i] = '-') and (i > 1) then
          CFlg := False;
        // '.'�Q�ڈȍ~�͖���
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
