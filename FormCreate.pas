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
    { private �錾 }
    //CSV�t�@�C���Ǎ��f�[�^
    CsvData: array of array of String;
    //CSV�t�@�C���Ǎ��}�X�^
    CsvMaster: array of array of String;

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
  public
    { public �錾 }
  end;

var
  F_FormCreate: TF_FormCreate;

const
  CSV_FILE_NAME = '�f�[�^�ꗗ.csv';

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
  DispWareki(StrToIntDef(et_year.Text,0));
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

  //���[�t�@�C���R�s�[

  //�W�v

  //�W�v�t�@�C���쐬

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
    begin  //�a��ԊґO
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

    //�s���擾
    RowCount := CsvData1.Count;

    //�f�[�^��z��ɕۑ�
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

        //�ꎞ�ۑ��e�L�X�g���N���A
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
//  �}�X�^�ǂݍ���
//----------------------------------------------------------------------------//
function TF_FormCreate.MastarReadFromCsv: Boolean;
begin

end;


end.
