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
    { private �錾 }
    Data1: Array of Array of TValue;
    Data2: Array of Array of TValue;
    ColPos: Array of Integer;

    //����������
    procedure InitProc;
    //Grid����������
    procedure InitGrid;
    procedure ViewportPositionChange1( Sender : TObject;
     const OldPosition, NewPosition : TPointF; const Changed : Boolean );
    procedure ViewportPositionChange2( Sender : TObject;
     const OldPosition, NewPosition : TPointF; const Changed : Boolean );
    //�f�[�^�L�^����
    procedure RecordProc;
    //�a��ϊ�
    procedure DispWareki(year: Integer);
  public
    { public �錾 }
  end;

var
  F_InputData: TF_InputData;

implementation

uses
  Kyotu;

{$R *.fmx}

//----------------------------------------------------------------------------//
//  ��������
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
    VKF3: begin  //����������
      InitProc;
    end;
    VKF9: begin  //�f�[�^�L�^����
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
  //���͔N�̌������擾
  yearDigit := Length((Sender as TEdit).Text);

  if (yearDigit >= 1) and
     (yearDigit <= 2) then
  begin  //�a�����
    DispWareki(StrToIntDef(et_year.Text,0));
  end
  else
  if (yearDigit = 4) then
  begin  //�������
    DispWareki(StrToIntDef(et_year.Text,0));
  end
  else
  begin  //���͂Ɍ�肪����ꍇ
    MessageDlg('����N����͂��Ă��������B',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes], 0);
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

  OpenDialog1.Filter := 'Excel�u�b�N(*.xlsx)|*.XLSX|*.xls|*.XLS|CSV(�R���}��؂�)(*.csv)|*.CSV';

  if not (OpenDialog1.Execute) then
  begin  //�L�����Z������
    Exit;
  end;

  //�t�H���_�[�p�X�\��
  et_path.Text := OpenDialog1.FileName;
end;

procedure TF_InputData.bt_datadispClick(Sender: TObject);
begin
  //CSV�f�[�^�̓ǂݍ���

  //Grid�Ƀf�[�^�\��
end;

procedure TF_InputData.bt_canselClick(Sender: TObject);
begin
  //����������
  InitProc;
end;

//----------------------------------------------------------------------------//
//  onSwitch
//----------------------------------------------------------------------------//
procedure TF_InputData.sw_updateSwitch(Sender: TObject);
begin
  if (sw_update.IsChecked) then
  begin  //�X�V
    lb_update.Text := '�X�V';
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
  begin  //�V�K
    lb_update.Text := '�V�K';
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
//  Grid�̒l���擾
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
//  Grid�ɒl��ݒ�
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
//  �O������
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//  ����������
//----------------------------------------------------------------------------//
procedure TF_InputData.InitProc;
begin
  //������
  sw_update.IsChecked := False;
  lb_update.Text := '�V�K';
  et_year.Text := '';

  //�\���E��\������
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

  //Grid����������
  InitGrid;

  //�t�H�[�J�X�ݒ�
  DelayedSetFocus(sw_update);
end;

//----------------------------------------------------------------------------//
//  Grid����������
//----------------------------------------------------------------------------//
procedure TF_InputData.InitGrid;
var
  R, C: Integer; //Row, Collumn
begin
  //�z���������
//  SetLength(Data1, StringGrid1.Content.ChildrenCount, StringGrid1.RowCount);
//  SetLength(Data2, StringGrid2.Content.ChildrenCount, StringGrid2.RowCount);
//  SetLength(ColPos, StringGrid2.COntent.ChildrenCount);
  SetLength(Data1, StringGrid1.ColumnCount, StringGrid1.RowCount);
  SetLength(Data2, StringGrid2.ColumnCount, StringGrid2.RowCount);

  //Grid�̒l��������
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


  // Grid�̃X�N���[���o�[������
  StringGrid1.ShowScrollBars  := false;
  StringGrid2.ShowScrollBars  := false;

  // �X�N���[���ʒu���ύX�ɂȂ������̃��\�b�h���蓖��
  StringGrid1.OnViewportPositionChange := ViewportPositionChange1;
  StringGrid2.OnViewportPositionChange := ViewportPositionChange2;
end;

//----------------------------------------------------------------------------//
//  Grid�̃X�N���[����������
//----------------------------------------------------------------------------//
procedure TF_InputData.ViewportPositionChange1( Sender : TObject;
 const OldPosition, NewPosition : TPointF; const Changed : Boolean );
begin
  // ��TGrid�𓮂�������ETGrid�𓮂���
  StringGrid2.ViewportPosition := StringGrid1.ViewportPosition;
end;

procedure TF_InputData.ViewportPositionChange2( Sender : TObject;
 const OldPosition, NewPosition : TPointF; const Changed : Boolean );
begin
  // �ETGrid�𓮂������獶TGrid�𓮂���
  StringGrid1.ViewportPosition := StringGrid2.ViewportPosition;
end;

//----------------------------------------------------------------------------//
//  �f�[�^�L�^����
//----------------------------------------------------------------------------//
procedure TF_InputData.RecordProc;
begin
  if not (bt_record.Enabled) then
  begin
    Exit;
  end;
end;

//----------------------------------------------------------------------------//
//  �a��\��
//----------------------------------------------------------------------------//
procedure TF_InputData.DispWareki(year: Integer);
var
  wareki: String;
begin
  //�a��ϊ�
  wareki := ChangeToWareki(year);

  //�N���\��
  lb_nengo.Text := copy(wareki, 0, 2);
  //���ԕ\��
  lb_period1.Text := wareki
                   + '�N' + '04��';
  lb_period2.Text := copy(wareki, 0, 2)
                   + FormatFloat('00',StrToInt(copy(wareki, 3, 2)) + 1)
                   + '�N' + '03��';

  //���ԃ��x���\���E��\������
  lb_nengo.Visible := True;
  lb_period0.Visible := True;
  lb_period1.Visible := True;
  lb_period2.Visible := True;
end;
end.
