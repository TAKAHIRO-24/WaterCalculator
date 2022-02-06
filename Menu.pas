unit Menu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Menus, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo;

type
  TF_Menu = class(TForm)
    StyleBook1: TStyleBook;
    GridPanelLayout1: TGridPanelLayout;
    bt_Manual: TButton;
    bt_InputData: TButton;
    bt_FormCreate: TButton;
    bt_Control: TButton;
    mm_Manual: TMemo;
    mm_InputData: TMemo;
    mm_FormCreate: TMemo;
    mm_Control: TMemo;
    ScaledLayout1: TScaledLayout;
    procedure FormCreate(Sender: TObject);
    procedure bt_ManualMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure bt_InputDataMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure bt_FormCreateMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure bt_ControlMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure bt_ManualMouseLeave(Sender: TObject);
    procedure bt_InputDataMouseLeave(Sender: TObject);
    procedure bt_FormCreateMouseLeave(Sender: TObject);
    procedure bt_ControlMouseLeave(Sender: TObject);
  private
    { private �錾 }
    procedure InitProc;
  public
    { public �錾 }
  end;

var
  F_Menu: TF_Menu;

implementation

{$R *.fmx}

//----------------------------------------------------------------------------//
//  ��������
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//  onCreate
//----------------------------------------------------------------------------//
procedure TF_Menu.FormCreate(Sender: TObject);
begin
  //��������
  InitProc;
end;

//----------------------------------------------------------------------------//
//  �}�E�X�I�[�o�[
//----------------------------------------------------------------------------//
procedure TF_Menu.bt_ManualMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
  mm_Manual.Visible := True;
end;

procedure TF_Menu.bt_InputDataMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
  mm_InputData.Visible := True;
end;

procedure TF_Menu.bt_FormCreateMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
  mm_FormCreate.Visible := True;
end;

procedure TF_Menu.bt_ControlMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
  mm_Control.Visible := True;
end;

//----------------------------------------------------------------------------//
//  �}�E�X���[�u
//----------------------------------------------------------------------------//
procedure TF_Menu.bt_ManualMouseLeave(Sender: TObject);
begin
  mm_Manual.Visible := False;
end;

procedure TF_Menu.bt_InputDataMouseLeave(Sender: TObject);
begin
  mm_InputData.Visible := False;
end;

procedure TF_Menu.bt_FormCreateMouseLeave(Sender: TObject);
begin
  mm_FormCreate.Visible := False;
end;

procedure TF_Menu.bt_ControlMouseLeave(Sender: TObject);
begin
  mm_Control.Visible := False;
end;

//----------------------------------------------------------------------------//
//  �O������
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//  ����������
//----------------------------------------------------------------------------//
procedure TF_Menu.InitProc;
begin
  //�\���E��\������
  mm_Manual.Visible := False;
  mm_InputData.Visible := False;
  mm_FormCreate.Visible := False;
  mm_Control.Visible := False;
end;

end.