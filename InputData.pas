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
    { private �錾 }
    Data: Array of Array of TValue;
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
//  onKeyDown
//----------------------------------------------------------------------------//
procedure TF_InputData.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  case Key of
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
    InitProc;
  end;
end;

//----------------------------------------------------------------------------//
//  onClick
//----------------------------------------------------------------------------//
procedure TF_InputData.bt_canselClick(Sender: TObject);
begin
  //����������
  InitProc;
end;

//----------------------------------------------------------------------------//
//  Grid�̒l���擾
//----------------------------------------------------------------------------//
procedure TF_InputData.Grid2SetValue(Sender: TObject; const ACol, ARow: Integer;
  const Value: TValue);
begin
  Data[ACol, ARow] := Value;
end;

//----------------------------------------------------------------------------//
//  Grid�ɒl��ݒ�
//----------------------------------------------------------------------------//
procedure TF_InputData.Grid2GetValue(Sender: TObject; const ACol, ARow: Integer;
  var Value: TValue);
begin
  Value := Data[ACol, ARow];
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
  et_year.Text := '';
  //�\���E��\������
  lb_nengo.Visible := False;
  lb_period0.Visible := False;
  lb_period1.Visible := False;
  lb_period2.Visible := False;
  //Grid����������
  InitGrid;
  //�t�H�[�J�X�ݒ�
  et_year.SetFocus;
end;

//----------------------------------------------------------------------------//
//  Grid����������
//----------------------------------------------------------------------------//
procedure TF_InputData.InitGrid;
begin
  //�z���������
  SetLength(Data, Grid2.Content.ChildrenCount, Grid2.RowCount);
  SetLength(ColPos, Grid2.COntent.ChildrenCount);

  // Grid�̃X�N���[���o�[������
  Grid1.ShowScrollBars  := false;
  Grid2.ShowScrollBars  := false;

  // �X�N���[���ʒu���ύX�ɂȂ������̃��\�b�h���蓖��
  Grid1.OnViewportPositionChange := ViewportPositionChange1;
  Grid2.OnViewportPositionChange := ViewportPositionChange2;
end;

//----------------------------------------------------------------------------//
//  Grid�̃X�N���[����������
//----------------------------------------------------------------------------//
procedure TF_InputData.ViewportPositionChange1( Sender : TObject;
 const OldPosition, NewPosition : TPointF; const Changed : Boolean );
begin
  // ��TGrid�𓮂�������ETGrid�𓮂���
  Grid2.ViewportPosition := Grid1.ViewportPosition;
end;

procedure TF_InputData.ViewportPositionChange2( Sender : TObject;
 const OldPosition, NewPosition : TPointF; const Changed : Boolean );
begin
  // �ETGrid�𓮂������獶TGrid�𓮂���
  Grid1.ViewportPosition := Grid2.ViewportPosition;
end;

//----------------------------------------------------------------------------//
//  �f�[�^�L�^����
//----------------------------------------------------------------------------//
procedure TF_InputData.RecordProc;
begin

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
