unit InputData;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid,
  FMX.Layouts;

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
    procedure FormCreate(Sender: TObject);
    procedure Grid2SetValue(Sender: TObject; const ACol, ARow: Integer;
      const Value: TValue);
    procedure Grid2GetValue(Sender: TObject; const ACol, ARow: Integer;
      var Value: TValue);
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
  public
    { public �錾 }
  end;

var
  F_InputData: TF_InputData;

implementation

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
  //Grid����������
  InitGrid;
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

end.