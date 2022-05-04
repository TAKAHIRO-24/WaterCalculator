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
    { private �錾 }
    Data1: Array of Array of TValue;
    Data2: Array of Array of TValue;
    ColPos: Array of Integer;

    //����������
    procedure InitProc;
    //Grid����������
    procedure InitGrid;
    //�f�[�^�L�^����
    procedure RecordProc;
  public
    { public �錾 }
  end;

var
  F_Control: TF_Control;

implementation

uses
  Kyotu;

{$R *.fmx}

//----------------------------------------------------------------------------//
//  ��������
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//  onKeyDown
//----------------------------------------------------------------------------//
procedure TF_Control.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  case Key of
    VKF3: begin  //����������
      bt_canselClick(Sender);
    end;
    VKF9: begin  //�f�[�^�L�^����
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
//  F3:�L�����Z��onClick
//----------------------------------------------------------------------------//
procedure TF_Control.bt_canselClick(Sender: TObject);
begin
  //����������
  InitProc;
end;

//----------------------------------------------------------------------------//
//  F9:�L�^onClick
//----------------------------------------------------------------------------//
procedure TF_Control.bt_recordClick(Sender: TObject);
begin
  RecordProc;
end;

//----------------------------------------------------------------------------//
//  �R���{�{�b�N�XonChange
//----------------------------------------------------------------------------//
procedure TF_Control.cmb_mastaChange(Sender: TObject);
begin
  InitProc;
end;

//----------------------------------------------------------------------------//
//  Grid�̒l���擾
//----------------------------------------------------------------------------//
procedure TF_Control.Grid1SetValue(Sender: TObject; const ACol, ARow: Integer;
  const Value: TValue);
begin
  Data1[ACol, ARow] := Value;
end;

//----------------------------------------------------------------------------//
//  Grid�ɒl��ݒ�
//----------------------------------------------------------------------------//
procedure TF_Control.Grid1GetValue(Sender: TObject; const ACol, ARow: Integer;
  var Value: TValue);
begin
  Value := Data1[ACol, ARow];
end;

//----------------------------------------------------------------------------//
//  �O������
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//  ����������
//----------------------------------------------------------------------------//
procedure TF_Control.InitProc;
begin
  //ini�t�@�C���ǂݍ���
  GetIniFile;

  //Grid����������
  InitGrid;
end;

//----------------------------------------------------------------------------//
//  Grid����������
//----------------------------------------------------------------------------//
procedure TF_Control.InitGrid;
const
  //�e�}�X�^��Grid��̉���
  ComponentWidth: Array[0..2] of Array[0..16] of Integer = (
                     //��ʃ}�X�^
                     (28,100,200,115,100,100,0,0,0,0,0,0,0,0,0,0,0)
                     //�Z���}�X�^
                    ,(28,150,300,165,0,0,0,0,0,0,0,0,0,0,0,0,0)
                     //�捞�}�X�^
                    ,(28,100,200,100,100,100,100,100,100,100,100,100,100,100,100,100,100)
                      );
  //�e�}�X�^��Grid��̃w�b�_�[
  ComponentHeader: Array[0..2] of Array[0..16] of String = (
                     //��ʃ}�X�^
                     ('','','','','','','','','','','','','','','','','')
                     //�Z���}�X�^
                    ,('','�����ԍ�','���p��','�N�Ԑ����������z','','','','','','','','','','','','','')
                     //�捞�}�X�^
                    ,('','�����ԍ�','���p��','�����ԍ�','3��','4��','5��','6��','7��','8��','9��','10��','11��','12��','1��','2��','3��')
                      );

var
  i: Integer;
  R, C: Integer;  //Row, Collumn
  Component: TComponent;
begin
  //�R���{�{�b�N�X�̒l�ɂ���ĕ\����ύX
  case (cmb_masta.ItemIndex) of
    //��ʃ}�X�^
    0: begin
      //Grid�̐ݒ�
      StringGrid1.RowCount := Length(roomOwner[0]);
      for i := 0 to StringGrid1.ColumnCount - 1 do
      begin
        Component := Self.FindComponent('Grd_column' + IntToStr(i));
        //����
        TStringColumn(Component).Width := ComponentWidth[cmb_masta.ItemIndex][i];
        //�w�b�_�[
        TStringColumn(Component).Header := ComponentHeader[cmb_masta.ItemIndex][i];
        //�ҏW��
        if (True) then
        begin  //�S�ĕҏW�s��
          TStringColumn(Component).ReadOnly := True;
        end;
      end;

      //�z���������
      SetLength(Data1, StringGrid1.ColumnCount, StringGrid1.RowCount);

      //Grid�̒l��������
      for C := 0 to StringGrid1.ColumnCount-1 do
      begin
        for R := 0 to StringGrid1.RowCount-1 do
        begin
          if (C = 0) then
          begin  //�`�F�b�N�{�b�N�X
            Data1[C, R] := 'False';
            StringGrid1.Cells[C, R] := 'False';
          end
          else
          begin  //���̑�
            Data1[C, R] := '';
            StringGrid1.Cells[C, R] := '';
          end;
        end;
      end;
    end;
    //�Z���}�X�^
    1: begin
      //Grid�̐ݒ�
      StringGrid1.RowCount := Length(roomOwner[0]);
      for i := 0 to StringGrid1.ColumnCount - 1 do
      begin
        Component := Self.FindComponent('Grd_column' + IntToStr(i));
        //����
        TStringColumn(Component).Width := ComponentWidth[cmb_masta.ItemIndex][i];
        //�w�b�_�[
        TStringColumn(Component).Header := ComponentHeader[cmb_masta.ItemIndex][i];
        //�ҏW��
        if (i in [1]) then
        begin  //�����ԍ��͕ҏW�s��
          TStringColumn(Component).ReadOnly := True;
        end
        else
        if (i in [2,3]) then
        begin  //���p�ҁA�N�Ԑ����������z�͕ҏW�\
          TStringColumn(Component).ReadOnly := False;
        end
        else
        begin  //���̑�
          TStringColumn(Component).ReadOnly := True;
        end;
      end;

      //�z���������
      SetLength(Data1, StringGrid1.ColumnCount, StringGrid1.RowCount);

      //Grid�̒l��������
      for C := 0 to StringGrid1.ColumnCount-1 do
      begin
        for R := 0 to StringGrid1.RowCount-1 do
        begin
          if (C = 0) then
          begin  //�`�F�b�N�{�b�N�X
            Data1[C, R] := 'False';
            StringGrid1.Cells[C, R] := 'False';
          end
          else
          if (C IN [1,2,3]) then
          begin  //�����ԍ��A���p�ҁA�N�Ԑ����������z
            Data1[C, R] := roomOwner[C-1, R];
            StringGrid1.Cells[C, R] := roomOwner[C-1, R];
          end
          else
          begin  //���̑�
            Data1[C, R] := '';
            StringGrid1.Cells[C, R] := '';
          end;
        end;
      end;
    end;
    //�捞�}�X�^
    2: begin
      //Grid�̐ݒ�
      StringGrid1.RowCount := Length(roomOwner[0]);
      for i := 0 to StringGrid1.ColumnCount - 1 do
      begin
        Component := Self.FindComponent('Grd_column' + IntToStr(i));
        //����
        TStringColumn(Component).Width := ComponentWidth[cmb_masta.ItemIndex][i];
        //�w�b�_�[
        TStringColumn(Component).Header := ComponentHeader[cmb_masta.ItemIndex][i];
        //�ҏW��
        if (i in [1,2]) then
        begin  //�����ԍ��A���p�҂͕ҏW�s��
          TStringColumn(Component).ReadOnly := True;
        end
        else
        begin  //���̑�
          TStringColumn(Component).ReadOnly := False;
        end;
      end;

      //�z���������
      SetLength(Data1, StringGrid1.ColumnCount, StringGrid1.RowCount);

      //Grid�̒l��������
      for C := 0 to StringGrid1.ColumnCount-1 do
      begin
        for R := 0 to StringGrid1.RowCount-1 do
        begin
          if (C = 0) then
          begin  //�`�F�b�N�{�b�N�X
            Data1[C, R] := 'False';
            StringGrid1.Cells[C, R] := 'False';
          end
          else
          if (C IN [1,2]) then
          begin  //�����ԍ��A���p��
            Data1[C, R] := roomOwner[C-1, R];
            StringGrid1.Cells[C, R] := roomOwner[C-1, R];
          end
          else
          begin  //�����ԍ��A�O�N�x3���`���N�x3��
            Data1[C, R] := outputPos[C-2,R];
            StringGrid1.Cells[C, R] := outputPos[C-2,R];
          end;
        end;
      end;
    end;
  end;

  // Grid�̃X�N���[���o�[������
  StringGrid1.ShowScrollBars  := false;
end;

//----------------------------------------------------------------------------//
//  �f�[�^�L�^����
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

  //�R���{�{�b�N�X�̒l�ɂ���ċL�^���e��ύX
  case (cmb_masta.ItemIndex) of
    //��ʃ}�X�^
    0: begin

    end;
    //�Z���}�X�^
    1: begin
      //Grid�f�[�^��z��ɕۑ�
      for R := Low(roomOwner[0]) to High(roomOwner[0]) do
      begin
        for C := Low(roomOwner) to High(roomOwner) do
        begin
          if (C in [1,2,3]) then
          begin  //�����ԍ��A���p�ҁA�N�Ԑ����������z
            roomOwner[C-1, R] := StringGrid1.Cells[C, R]
          end
          else
          begin
            //�ǂݔ�΂�
          end;
        end;
      end;
    end;
    //�捞�}�X�^
    2: begin
      //Grid�f�[�^��z��ɕۑ�
      for R := Low(outputPos[0]) to High(outputPos[0]) do
      begin
        for C := Low(outputPos) to High(outputPos) do
        begin
          if (C in [3..16]) then
          begin  //�����ԍ��A�O�N�x3���`���N�x3��
            outputPos[C-2, R] := StringGrid1.Cells[C, R]
          end
          else
          begin
            //�ǂݔ�΂�
          end;
        end;
      end;
    end;
  end;

  //ini�t�@�C����������
  ErrFlg := SetIniFile(cmb_masta.ItemIndex);

  if not (ErrFlg) then
  begin
    MsgDlg(0, '�ݒ�t�@�C���������݂ŃG���[���������܂����B');
    Exit;
  end;

  //��ʏ�����
  InitProc;

end;


end.
