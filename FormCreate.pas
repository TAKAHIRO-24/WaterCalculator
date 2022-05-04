unit FormCreate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Layouts,
  System.IOUtils, system.win.comobj, ExcelXP;

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
    { private �錾 }
    //CSV�t�@�C���Ǎ��f�[�^
    CsvData: array of array of String;
    //CSV�t�@�C���Ǎ��}�X�^
    CsvMaster: array of array of String;

    //�ꂩ�����Ƃ̐����g�p��
    WaterUsage1: array of array of String;
    //�񂩌����Ƃ̐����g�p��
    WaterUsage2: array of array of String;

    //���[�o�͗p
    OutputData: array of array of String;

    //������
    procedure InitProc;
    //�f�[�^�쐬
    procedure DataCreate;
    //�a��\��
    procedure DispWareki(year: Integer);
    //�W�v�N�`�F�b�N
    function YearCheck: Boolean;
    //�f�[�^�ǂݍ���
    function DataReadFromCsv: Boolean;
    //�}�X�^�ǂݍ���
    function MastarReadFromCsv: Boolean;
    function OutputDataCreate: Boolean;
    function OutputFileCreate: Boolean;
    //���������ϊ�
    function GetFee(WaterUsage: String): String;

  public
    { public �錾 }
  end;

var
  F_FormCreate: TF_FormCreate;

const
  CSV_FILE_NAME = '�f�[�^�ꗗ'; //�f�[�^�t�@�C��
  CSV_MASTER_NAME = 'master';  //���������}�X�^�t�@�C��
  TEMPLATE_FILE_NAME = '�����g�p�ʁE������������';  //�o�͒��[�t�@�C��

implementation

uses
  Kyotu;

{$R *.fmx}

//----------------------------------------------------------------------------//
//  onCreate
//----------------------------------------------------------------------------//
procedure TF_FormCreate.FormCreate(Sender: TObject);
begin
  //������
  InitProc;
end;

//----------------------------------------------------------------------------//
//  onKeyDown
//----------------------------------------------------------------------------//
procedure TF_FormCreate.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  case Key of
    VKF3: begin  //����������
      bt_canselClick(Sender);
    end;
    VKF9: begin  //�f�[�^�L�^����
      bt_createClick(Sender);
    end;
  end;
end;

//----------------------------------------------------------------------------//
//  F3Click
//----------------------------------------------------------------------------//
procedure TF_FormCreate.bt_canselClick(Sender: TObject);
begin
  //����������
  InitProc;
end;

//----------------------------------------------------------------------------//
//  F9Click
//----------------------------------------------------------------------------//
procedure TF_FormCreate.bt_createClick(Sender: TObject);
begin
  //�W�v����
  DataCreate;
end;

//----------------------------------------------------------------------------//
//  onExit
//----------------------------------------------------------------------------//
procedure TF_FormCreate.et_yearExit(Sender: TObject);
begin

  if not (YearCheck) then
  begin
    MessageDlg('����N����͂��Ă��������B',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes], 0);
    DelayedSetFocus(et_year);
    Exit;
  end;

  //�a��\��
  if (lb_nengo.Text.IsEmpty) or
     (et_year.Text.IsEmpty) then
  begin  //�a��ϊ��O
    DispWareki(StrToIntDef(et_year.Text,0));
  end;
end;

//----------------------------------------------------------------------------//
//  onTyping
//----------------------------------------------------------------------------//
procedure TF_FormCreate.et_yearTyping(Sender: TObject);
begin
  if (Length(et_year.Text) = 4) then
  begin  //�������
    Exit;
  end
  else
  begin  //�a�����
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
//  �a��\��
//----------------------------------------------------------------------------//
procedure TF_FormCreate.DispWareki(year: Integer);
var
  wareki: String;
begin
  //�a��ϊ�
  wareki := ChangeToWareki(year);

  //�N���\��
  lb_nengo.Text := copy(wareki, 0, 2);
  //�N�\��
  et_year.Text := copy(wareki, 3, 2);

  //���x���\���E��\������
  lb_nengo.Visible := True;
end;

//----------------------------------------------------------------------------//
//  ������
//----------------------------------------------------------------------------//
procedure TF_FormCreate.InitProc;
begin
  //������
  lb_nengo.Text := '';
  et_year.Text := '';

  //�\���E��\��
  lb_nengo.Visible := False;

  //�t�H�[�J�X
  DelayedSetFocus(et_year);
end;

//----------------------------------------------------------------------------//
//  �f�[�^�쐬
//----------------------------------------------------------------------------//
procedure TF_FormCreate.DataCreate;
var
  TemplateFilePath: String;
begin
  if not (bt_create.Enabled) then
  begin
    Exit;
  end;

  //�f�[�^�`�F�b�N
  if not (YearCheck) then
  begin
    MessageDlg('����N����͂��Ă��������B',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes], 0);
    DelayedSetFocus(et_year);
    Exit;
  end;

  //����\���̏ꍇ
  if (Length(et_year.Text) = 4) then
  begin
    DispWareki(StrToIntDef(et_year.Text,0));
  end;

  //�f�[�^�ǂݍ���
  if not (DataReadFromCsv) then
  begin
    MessageDlg('�f�[�^�Ǎ������ŃG���[���������܂����B',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes], 0);
    DelayedSetFocus(et_year);
    Exit;
  end;

  //�}�X�^�ǂݍ���
  if not (MastarReadFromCsv) then
  begin
    MessageDlg('�}�X�^�Ǎ������ŃG���[���������܂����B',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes], 0);
    DelayedSetFocus(et_year);
    Exit;
  end;

  //�W�v
  if not (OutputDataCreate) then
  begin
    MessageDlg('�W�v�f�[�^�쐬�����ŃG���[���������܂����B',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes], 0);
    DelayedSetFocus(et_year);
    Exit;
  end;

  //�W�v�t�@�C���쐬
  if not (OutputFileCreate) then
  begin
    MessageDlg('�t�@�C���쐬�����ŃG���[���������܂����B',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes], 0);
    DelayedSetFocus(et_year);
    Exit;
  end;

  //�������b�Z�[�W
  TemplateFilePath := ExtractFileDir(ParamStr(0))
                    + '\'
                    + 'CSV'
�@                   + '\'
                    + lb_nengo.Text
                    + et_year.Text
                    + lb_nendo.Text
                    + '\'
                    + TEMPLATE_FILE_NAME
                    ;
  MessageDlg('�f�[�^�W�v���������܂����B'
            +#13#10
            +'�t�@�C�������m�F���������B'
            +#13#10
            + TemplateFilePath
            ,TMsgDlgType.mtInformation, [TMsgDlgBtn.mbYes], 0);

  //����������
  InitProc;

end;

//----------------------------------------------------------------------------//
//  �W�v�N�`�F�b�N
//----------------------------------------------------------------------------//
function TF_FormCreate.YearCheck: Boolean;
var
  yearDigit: Integer;
begin
  Result := False;

  //���͔N�̌������擾
  yearDigit := Length(et_year.Text);

  if (yearDigit >= 1) and
     (yearDigit <= 2) then
  begin  //�a�����
    if (lb_nengo.Text.IsEmpty) or
       (et_year.Text.IsEmpty) then
    begin  //�a��ϊ��O
      Result := False;
    end
    else
    begin  //�a��ϊ��ς�
      Result := True;
    end;
  end
  else
  if (yearDigit = 4) then
  begin  //�������
    Result := True;
  end
  else
  begin  //���͂Ɍ�肪����ꍇ
    Result := False;
  end;
end;

//----------------------------------------------------------------------------//
//  �f�[�^�ǂݍ���
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
    //�t�@�C����ǂݍ���
    CsvDirPath := ExtractFileDir(ParamStr(0))
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
                 + '.csv'
                 ;

    //�t�@�C�����݊m�F
    if not (FileExists(CsvFilePath)) then
    begin
      showMessage('�捞�p�t�@�C�������݂��܂���B'
                 + #13#10
                 +'�f�[�^���͉�ʂ��t�@�C�����쐬���Ă��������B');
      Exit;
    end;

    CsvData1.LoadFromFile(CsvFilePath);

    //�s���擾
    RowCount := CsvData1.Count;

    //�f�[�^��z��ɕۑ�
    SetLength(CsvData, 15, RowCount-1);  //(�����ԍ�,���p�Җ�,3��,4��,5��,6��,7��,8��,9��,10��,11��,12��,1��,2��,3��)

    for R := 0 to RowCount - 1 do
    begin
      if (R = 0) then
      begin
        //��s�ڂ͗񖼂Ȃ̂œǂݔ�΂�
        Continue;
      end;

      //R�s�ڂ̃f�[�^���J���}��؂�Ŏ擾
      CsvData2.CommaText := CsvData1.Strings[R];

      for C := 0 to 14 do
      begin
        {�����ԍ��E���p�Җ��E3���E4���E5���E6���E7���E8���E9���E10���E11���E12���E1���E2���E3��}
        CsvData[C,R-1] := CsvData2.Strings[C];
      end;

      //�ꎞ�ۑ��e�L�X�g���N���A
      CsvData2.Clear;
    end;

    Result := True;

  finally
    CsvData1.Free;
    CsvData2.Free;
  end;

end;

//----------------------------------------------------------------------------//
//  �}�X�^�ǂݍ���
//----------------------------------------------------------------------------//
function TF_FormCreate.MastarReadFromCsv: Boolean;
var
  C, R: Integer;
  RowCount: Integer;
  CsvMaster1: TStringList;
  CsvMaster2: TStringList;
  CsvDirPath: String;
  CsvFilePath: String;
begin

  Result := False;

  CsvMaster1 := TStringList.Create;
  CsvMaster2 := TStringList.Create;

  try
    //�t�@�C����ǂݍ���
    CsvDirPath := ExtractFileDir(ParamStr(0))
                + '\'
                + 'CSV'
                + '\'
                + 'master'
                ;
    CsvFilePath := CsvDirPath
                 + '\'
                 + CSV_MASTER_NAME
                 + '.csv'
                 ;

    //�t�@�C�����݊m�F
    if not (FileExists(CsvFilePath)) then
    begin
      showMessage('�}�X�^�t�@�C�������݂��܂���B'
                 + #13#10
                 +'�V�X�e���Ǘ��҂ɂ��A�����������B');
      Exit;
    end;

    CsvMaster1.LoadFromFile(CsvFilePath);

    //�s���擾
    RowCount := CsvMaster1.Count;

    //�f�[�^��z��ɕۑ�
    SetLength(CsvMaster, 2, RowCount-5);  //(�g�p����, ���z)

    for R := 0 to RowCount - 1 do
    begin

      if (R in [0..4]) then
      begin
        //�P�`�T�s�ڂ̓^�C�g���E�񖼂Ȃ̂œǂݔ�΂�
        Continue;
      end;

      //R�s�ڂ̃f�[�^���J���}��؂�Ŏ擾
      CsvMaster2.CommaText := CsvMaster1.Strings[R];


      {�g�p���ʁE���������E�����g�p�ʁE���v�i�ō��݁j}
      //�g�p����
      CsvMaster[0,R-5] := CsvMaster2.Strings[0];
      //���v�i�ō��݁j
      CsvMaster[1,R-5] := CsvMaster2.Strings[3];

      //�ꎞ�ۑ��e�L�X�g���N���A
      CsvMaster2.Clear;
    end;
  finally
    CsvMaster1.Free;
    CsvMaster2.Free;
  end;

  Result := True;

end;

//----------------------------------------------------------------------------//
//  �W�v�f�[�^�쐬
//----------------------------------------------------------------------------//
function TF_FormCreate.OutputDataCreate: Boolean;
var
  i: Integer;
  C, R: Integer;
  Dummy: Integer;
  CurrentColumn: Integer;
begin

  Result := False;

  //�z�񏉊���
  SetLength(WaterUsage1, High(CsvData)-2, High(CsvData[0])+1);
  //���ݗ�
  CurrentColumn := 0;

  //�ꂩ�����Ƃ̐����g�p�ʂ��W�v
  {4���E5���E6���E7���E8���E9���E10���E11���E12���E1���E2���E3��}
  for R := Low(CsvData[0]) to High(CsvData[0]) do
  begin
    //���ݗ񏉊���
    CurrentColumn := 0;

    for C := Low(CsvData) to High(CsvData) do
    begin
      //���ڂƓ��ڂ͕����ԍ��Ɨ��p�Җ�
      if (C in [0,1]) then
      begin
        //�ǂݔ�΂�
      end
      else
      //�O��ڂ͍�N��3���Ȃ̂œǂݔ�΂�
      if (C in [2]) then
      begin
        //�ǂݔ�΂�
      end
      else
      //(4���E5���E6���E7���E8���E9���E10���E11���E12���E1���E2���E3��)
      begin
        //��������O���������A�����̗��p�ʂ����߂�
        Dummy := StrToIntDef(CsvData[C,R],0) - StrToIntDef(CsvData[C-1,R],0);
        WaterUsage1[CurrentColumn,R] := IntToStr(Dummy);
        Inc(CurrentColumn);
      end;
    end;
  end;


  //�z�񏉊���
  SetLength(WaterUsage2, High(WaterUsage1)+1, High(WaterUsage1[0])+1);
  //���ݗ�
  CurrentColumn := 0;

  //�񂩌����Ƃ̐����g�p�ʂ��W�v
  {4���`5���E6���`7���E8���`9���E10���`11���E12���`1���E2���`3��}
  for R := Low(WaterUsage1[0]) to High(WaterUsage1[0]) do
  begin
    //���ݗ񏉊���
    CurrentColumn := 0;

    for C := Low(WaterUsage1) to High(WaterUsage1) do
    begin
       if (C in [0,2,4,6,8,10]) then
       //(4���E6���E8���E10���E12���E2��)
       begin
         //2�������Ƃ̐����g�p�ʂ����߂�
         Dummy := StrToIntDef(WaterUsage1[C,R],0) + StrToIntDef(WaterUsage1[C+1,R],0);
         WaterUsage2[CurrentColumn,R] := IntToStr(Dummy);
         Inc(CurrentColumn);
       end
       else
       //(5���E7���E9���E11���E1���E3��)
       begin
         //�ǂݔ�΂�
       end;
    end;
  end;


  //�z�񏉊���
  SetLength(OutputData, 32, High(CsvData[0])+1);
  //���ݗ�
  CurrentColumn := 0;

  //�󎚗p�f�[�^�쐬
  {�����ԍ�,���O
  ,�S��,�T��,�S�`�T��,���z
  ,�U��,�V��,�U�`�V��,���z
  ,�W��,�X��,�W�`�X��,���z
  ,�P�O��,�P�P��,�P�O�`�P�P��,���z
  ,�P�Q��,�P��,�P�Q�`�P��,���z
  ,�Q��,�R��,�Q�`�R��,���z
  ,���v����,���v���z,�N�Ԑ����������z,�����E�ԋ��t���O�A���z�A���z�i�󎚗p�j}
  for R := Low(CsvData[0]) to High(CsvData[0]) do
  begin
    OutputData[0,R] := CsvData[0,R];  //�����ԍ�
    OutputData[1,R] := CsvData[1,R];  //���p��

    OutputData[2,R] := CsvData[3,R];  //4��
    OutputData[3,R] := CsvData[4,R];  //5��
    OutputData[4,R] := WaterUsage2[0,R];  //4�`5��
    OutputData[5,R] := GetFee(WaterUsage2[0,R]);  //���z

    OutputData[6,R] := CsvData[5,R];  //6��
    OutputData[7,R] := CsvData[6,R];  //7��
    OutputData[8,R] := WaterUsage2[1,R];  //6�`7��
    OutputData[9,R] := GetFee(WaterUsage2[1,R]);  //���z

    OutputData[10,R] := CsvData[7,R];  //8��
    OutputData[11,R] := CsvData[8,R];  //9��
    OutputData[12,R] := WaterUsage2[2,R];  //8�`9��
    OutputData[13,R] := GetFee(WaterUsage2[2,R]);  //���z

    OutputData[14,R] := CsvData[9,R];  //10��
    OutputData[15,R] := CsvData[10,R];  //11��
    OutputData[16,R] := WaterUsage2[3,R];  //10�`11��
    OutputData[17,R] := GetFee(WaterUsage2[3,R]);  //���z

    OutputData[18,R] := CsvData[11,R];  //12��
    OutputData[19,R] := CsvData[12,R];  //1��
    OutputData[20,R] := WaterUsage2[4,R];  //12�`1��
    OutputData[21,R] := GetFee(WaterUsage2[4,R]);  //���z

    OutputData[22,R] := CsvData[13,R];  //2��
    OutputData[23,R] := CsvData[14,R];  //3��
    OutputData[24,R] := WaterUsage2[5,R];  //2�`3��
    OutputData[25,R] := GetFee(WaterUsage2[5,R]);  //���z

    //���v�g�p��
    Dummy            := StrToIntDef(CommaToStr(WaterUsage2[0,R]),0)  // 4�` 5��
                      + StrToIntDef(CommaToStr(WaterUsage2[1,R]),0)  // 6�` 7��
                      + StrToIntDef(CommaToStr(WaterUsage2[2,R]),0)  // 8�` 9��
                      + StrToIntDef(CommaToStr(WaterUsage2[3,R]),0)  //10�`11��
                      + StrToIntDef(CommaToStr(WaterUsage2[4,R]),0)  //12�` 1��
                      + StrToIntDef(CommaToStr(WaterUsage2[5,R]),0)  // 2�` 3��
                      ;
    OutputData[26,R] := IntToStr(Dummy);
    //���v���z
    Dummy            := StrToIntDef(CommaToStr(OutputData[5,R]),0)   // 4�` 5��
                      + StrToIntDef(CommaToStr(OutputData[9,R]),0)   // 6�` 7��
                      + StrToIntDef(CommaToStr(OutputData[13,R]),0)  // 8�` 9��
                      + StrToIntDef(CommaToStr(OutputData[17,R]),0)  //10�`11��
                      + StrToIntDef(CommaToStr(OutputData[21,R]),0)  //12�` 1��
                      + StrToIntDef(CommaToStr(OutputData[25,R]),0)  // 2�` 3��
                      ;
    OutputData[27,R] := IntToStr(Dummy);
    //�N�Ԑ����������z
    for i := Low(roomOwner[0]) to High(roomOwner[0]) do
    begin
      //�����ԍ�����v����N�Ԑ����������z���擾
      if (CommaToStr(OutputData[0,R]) = CommaToStr(roomOwner[0,i])) then
      begin
        OutputData[28,R] := roomOwner[2,i];
        break;
      end
      else
      begin  //�f�t�H���g�l
        OutputData[28,R] := '42000';
      end;
    end;
    //�����E�ԋ��t���O�A���z�A���z�i�󎚗p�j
    Dummy := StrToIntDef(CommaToStr(OutputData[27,R]),0)
           - StrToIntDef(CommaToStr(OutputData[28,R]),0)
           ;
    if (Dummy > 0) then
    begin
      //�N�Ԑ����������z���������A�ǉ�������������ꍇ
      OutputData[29,R] := '�����z';
      OutputData[30,R] := FormatFloat('#,##0',Dummy) + '�~';
      OutputData[31,R] := '��' + FormatFloat('#,##0',Dummy);
    end
    else
    begin
      //�N�Ԑ����������z���傫���A�ԋ���������ꍇ
      OutputData[29,R] := '�ԋ��z';
      OutputData[30,R] := FormatFloat('#,##0',Dummy * -1) + '�~';
      OutputData[31,R] := FormatFloat('#,##0',Dummy * -1);
    end;
  end;


  Result := True;

end;

//----------------------------------------------------------------------------//
//  �W�v�t�@�C���쐬
//----------------------------------------------------------------------------//
function TF_FormCreate.OutputFileCreate: Boolean;
const
  //Excel�󎚈ʒu
  INPUT_POS: Array[0..29] of Array[0..31] of String = (
     ('A1','B1','C1','D1','E1','F1','G1','H1','I1','J1','K1','L1','M1','N1','O1','P1','Q1','R1','S1','T1','U1','V1','W1','X1','Y1','Z1','AA1','AB1','AC1','AD1','AE1','AF1')
    ,('A2','B2','C2','D2','E2','F2','G2','H2','I2','J2','K2','L2','M2','N2','O2','P2','Q2','R2','S2','T2','U2','V2','W2','X2','Y2','Z2','AA2','AB2','AC2','AD2','AE2','AF2')
    ,('A3','B3','C3','D3','E3','F3','G3','H3','I3','J3','K3','L3','M3','N3','O3','P3','Q3','R3','S3','T3','U3','V3','W3','X3','Y3','Z3','AA3','AB3','AC3','AD3','AE3','AF3')
    ,('A4','B4','C4','D4','E4','F4','G4','H4','I4','J4','K4','L4','M4','N4','O4','P4','Q4','R4','S4','T4','U4','V4','W4','X4','Y4','Z4','AA4','AB4','AC4','AD4','AE4','AF4')
    ,('A5','B5','C5','D5','E5','F5','G5','H5','I5','J5','K5','L5','M5','N5','O5','P5','Q5','R5','S5','T5','U5','V5','W5','X5','Y5','Z5','AA5','AB5','AC5','AD5','AE5','AF5')
    ,('A6','B6','C6','D6','E6','F6','G6','H6','I6','J6','K6','L6','M6','N6','O6','P6','Q6','R6','S6','T6','U6','V6','W6','X6','Y6','Z6','AA6','AB6','AC6','AD6','AE6','AF6')
    ,('A7','B7','C7','D7','E7','F7','G7','H7','I7','J7','K7','L7','M7','N7','O7','P7','Q7','R7','S7','T7','U7','V7','W7','X7','Y7','Z7','AA7','AB7','AC7','AD7','AE7','AF7')
    ,('A8','B8','C8','D8','E8','F8','G8','H8','I8','J8','K8','L8','M8','N8','O8','P8','Q8','R8','S8','T8','U8','V8','W8','X8','Y8','Z8','AA8','AB8','AC8','AD8','AE8','AF8')
    ,('A9','B9','C9','D9','E9','F9','G9','H9','I9','J9','K9','L9','M9','N9','O9','P9','Q9','R9','S9','T9','U9','V9','W9','X9','Y9','Z9','AA9','AB9','AC9','AD9','AE9','AF9')
    ,('A10','B10','C10','D10','E10','F10','G10','H10','I10','J10','K10','L10','M10','N10','O10','P10','Q10','R10','S10','T10','U10','V10','W10','X10','Y10','Z10','AA10','AB10','AC10','AD10','AE10','AF10')
    ,('A11','B11','C11','D11','E11','F11','G11','H11','I11','J11','K11','L11','M11','N11','O11','P11','Q11','R11','S11','T11','U11','V11','W11','X11','Y11','Z11','AA11','AB11','AC11','AD11','AE11','AF11')
    ,('A12','B12','C12','D12','E12','F12','G12','H12','I12','J12','K12','L12','M12','N12','O12','P12','Q12','R12','S12','T12','U12','V12','W12','X12','Y12','Z12','AA12','AB12','AC12','AD12','AE12','AF12')
    ,('A13','B13','C13','D13','E13','F13','G13','H13','I13','J13','K13','L13','M13','N13','O13','P13','Q13','R13','S13','T13','U13','V13','W13','X13','Y13','Z13','AA13','AB13','AC13','AD13','AE13','AF13')
    ,('A14','B14','C14','D14','E14','F14','G14','H14','I14','J14','K14','L14','M14','N14','O14','P14','Q14','R14','S14','T14','U14','V14','W14','X14','Y14','Z14','AA14','AB14','AC14','AD14','AE14','AF14')
    ,('A15','B15','C15','D15','E15','F15','G15','H15','I15','J15','K15','L15','M15','N15','O15','P15','Q15','R15','S15','T15','U15','V15','W15','X15','Y15','Z15','AA15','AB15','AC15','AD15','AE15','AF15')
    ,('A16','B16','C16','D16','E16','F16','G16','H16','I16','J16','K16','L16','M16','N16','O16','P16','Q16','R16','S16','T16','U16','V16','W16','X16','Y16','Z16','AA16','AB16','AC16','AD16','AE16','AF16')
    ,('A17','B17','C17','D17','E17','F17','G17','H17','I17','J17','K17','L17','M17','N17','O17','P17','Q17','R17','S17','T17','U17','V17','W17','X17','Y17','Z17','AA17','AB17','AC17','AD17','AE17','AF17')
    ,('A18','B18','C18','D18','E18','F18','G18','H18','I18','J18','K18','L18','M18','N18','O18','P18','Q18','R18','S18','T18','U18','V18','W18','X18','Y18','Z18','AA18','AB18','AC18','AD18','AE18','AF18')
    ,('A19','B19','C19','D19','E19','F19','G19','H19','I19','J19','K19','L19','M19','N19','O19','P19','Q19','R19','S19','T19','U19','V19','W19','X19','Y19','Z19','AA19','AB19','AC19','AD19','AE19','AF19')
    ,('A20','B20','C20','D20','E20','F20','G20','H20','I20','J20','K20','L20','M20','N20','O20','P20','Q20','R20','S20','T20','U20','V20','W20','X20','Y20','Z20','AA20','AB20','AC20','AD20','AE20','AF20')
    ,('A21','B21','C21','D21','E21','F21','G21','H21','I21','J21','K21','L21','M21','N21','O21','P21','Q21','R21','S21','T21','U21','V21','W21','X21','Y21','Z21','AA21','AB21','AC21','AD21','AE21','AF21')
    ,('A22','B22','C22','D22','E22','F22','G22','H22','I22','J22','K22','L22','M22','N22','O22','P22','Q22','R22','S22','T22','U22','V22','W22','X22','Y22','Z22','AA22','AB22','AC22','AD22','AE22','AF22')
    ,('A23','B23','C23','D23','E23','F23','G23','H23','I23','J23','K23','L23','M23','N23','O23','P23','Q23','R23','S23','T23','U23','V23','W23','X23','Y23','Z23','AA23','AB23','AC23','AD23','AE23','AF23')
    ,('A24','B24','C24','D24','E24','F24','G24','H24','I24','J24','K24','L24','M24','N24','O24','P24','Q24','R24','S24','T24','U24','V24','W24','X24','Y24','Z24','AA24','AB24','AC24','AD24','AE24','AF24')
    ,('A25','B25','C25','D25','E25','F25','G25','H25','I25','J25','K25','L25','M25','N25','O25','P25','Q25','R25','S25','T25','U25','V25','W25','X25','Y25','Z25','AA25','AB25','AC25','AD25','AE25','AF25')
    ,('A26','B26','C26','D26','E26','F26','G26','H26','I26','J26','K26','L26','M26','N26','O26','P26','Q26','R26','S26','T26','U26','V26','W26','X26','Y26','Z26','AA26','AB26','AC26','AD26','AE26','AF26')
    ,('A27','B27','C27','D27','E27','F27','G27','H27','I27','J27','K27','L27','M27','N27','O27','P27','Q27','R27','S27','T27','U27','V27','W27','X27','Y27','Z27','AA27','AB27','AC27','AD27','AE27','AF27')
    ,('A28','B28','C28','D28','E28','F28','G28','H28','I28','J28','K28','L28','M28','N28','O28','P28','Q28','R28','S28','T28','U28','V28','W28','X28','Y28','Z28','AA28','AB28','AC28','AD28','AE28','AF28')
    ,('A29','B29','C29','D29','E29','F29','G29','H29','I29','J29','K29','L29','M29','N29','O29','P29','Q29','R29','S29','T29','U29','V29','W29','X29','Y29','Z29','AA29','AB29','AC29','AD29','AE29','AF29')
    ,('A30','B30','C30','D30','E30','F30','G30','H30','I30','J30','K30','L30','M30','N30','O30','P30','Q30','R30','S30','T30','U30','V30','W30','X30','Y30','Z30','AA30','AB30','AC30','AD30','AE30','AF30')
  );

  //�w�b�_�[
  Header: Array[0..31] of String = (
        '�����ԍ�', '���O'
      , '�S��' , '�T��' , '�S�`�T��'  , '���z'
      , '�U��' , '�V��' , '�U�`�V��'  , '���z'
      , '�W��' , '�X��' , '�W�`�X��'  , '���z'
      , '�P�O��', '�P�P��', '�P�O�`�P�P��', '���z'
      , '�P�Q��', '�P��' , '�P�Q�`�P��' , '���z'
      , '�Q��' , '�R��' , '�Q�`�R��'  , '���z'
      , '���v�g�p��','���v���z','�N�Ԑ����������z','�����E�ԋ��t���O','���z','���z�i�󎚗p�j'
  );
var
  C, R: Integer;
  TemplateDirPath: String;
  TemplateFilePath1: String;
  TemplateFilePath2: String;
  TemplateFilePath: String;
  ExcelApp: Olevariant;
  ExcelBook: Olevariant;
  ExcelSheet: Olevariant;
begin

  TemplateDirPath := ExtractFileDir(ParamStr(0))
                   + '\'
                   + 'CSV'
                   ;
  //�������t�@�C����ǂݍ���
  TemplateFilePath1 := TemplateDirPath
�@                   + '\'
�@                   + 'master'
                    + '\'
                    + TEMPLATE_FILE_NAME
                    ;
  //������t�@�C�����쐬
  TemplateFilePath2 := TemplateDirPath
�@                   + '\'
                    + lb_nengo.Text
                    + et_year.Text
                    + lb_nendo.Text
                    + '\'
                    + TEMPLATE_FILE_NAME
                    ;

  //�����̃t�@�C��������ꍇ�̓��l�[������
  if (TFile.Exists(TemplateFilePath2+'.xlsx')) then
  begin
    RenameFile( TemplateFilePath2+'.xlsx'
              , TemplateFilePath2
              + FormatDateTime('yyyymmddhhnnss', Now)
              + '.xlsx'
              );
  end;

  //�t�@�C�����݊m�F
  if not (FileExists(TemplateFilePath1+'.xlsx')) then
  begin
    showMessage('���[�쐬�p�e���v���[�g�t�@�C�������݂��܂���B'
               + #13#10
               +'�V�X�e���Ǘ��҂ɂ��A�����������B');
    Exit;
  end;

  //�e���v���[�g�t�@�C������
  TFile.Copy(TemplateFilePath1+'.xlsx', TemplateFilePath2+'.xlsx');

  //���[�쐬
  ExcelApp := CreateOleObject('Excel.Application');
  try
    ExcelBook := ExcelApp.WorkBooks.Open(FileName := TemplateFilePath2+'.xlsx'
                                        ,ReadOnly := False
                                        );
    try
      //1���ڂ̃V�[�g�ɕۑ�
      ExcelSheet := ExcelBook.WorkSheets[1];

      try
        for R := low(OutputData[0]) to High(OutputData[0])+2 do
        begin
          //�W�v�N�x����
          if (R in [0]) then
          begin
            ExcelSheet.range[INPUT_POS[R,0]].Value := lb_nengo.Text
                                                    + et_year.Text
                                                    + lb_nendo.Text
                                                    ;
          end
          else
          //�w�b�_�[����
          if (R in [1]) then
          begin
//            for C := Low(OutputData) to High(OutputData) do
            for C := Low(Header) to High(Header) do
            begin
              ExcelSheet.range[INPUT_POS[R,C]].Value := Header[C];
            end;
          end
          else
          //���׈�
          begin
            for C := Low(OutputData) to High(OutputData) do
            begin
              ExcelSheet.range[INPUT_POS[R,C]].Value := OutputData[C,R-2];
            end;
          end;
        end;
      finally
        ExcelSheet := unAssigned;
      end;
    finally
      ExcelBook.Save;  //�㏑��
      ExcelBook.Close;
      ExcelBook := unAssigned;
    end;
  finally
    ExcelApp.Quit;
  end;

  Result := True;

end;

//----------------------------------------------------------------------------//
//  ���������ϊ�
//----------------------------------------------------------------------------//
function TF_FormCreate.GetFee(WaterUsage: String): String;
var
  i: Integer;
  Usage: Integer;
begin

  Result := '';

  //�}�X�^���琅���g�p�ʂƋ��z�̕ϊ����s��
  for i := Low(CsvMaster[0]) to High(CsvMaster[0]) do
  begin
    if (CommaToStr(CsvMaster[0,i]) = WaterUsage) then
    begin
      Result := CsvMaster[1,i];
      Exit;
    end;
  end;
end;

end.
