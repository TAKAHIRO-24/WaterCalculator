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
    procedure ButtonMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure ButtonMouseLeave(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
  private
    { private 宣言 }
    procedure InitProc;
  public
    { public 宣言 }
  end;

var
  F_Menu: TF_Menu;

implementation

uses
  Manual, InputData, FormCreate, Control;

{$R *.fmx}

//----------------------------------------------------------------------------//
//  内部処理
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//  onCreate
//----------------------------------------------------------------------------//
procedure TF_Menu.FormCreate(Sender: TObject);
begin
  //初期処理
  InitProc;
end;

//----------------------------------------------------------------------------//
//  onClick
//----------------------------------------------------------------------------//
procedure TF_Menu.ButtonClick(Sender: TObject);
var
  btName: String;
  F_FormObject: TForm;
begin
  try
    btName := TButton(Sender).Name;

    if (btName = 'bt_Manual') then
    begin
      F_FormObject := TF_Manual.Create(Self);
    end
    else
    if (btName = 'bt_InputData') then
    begin
      F_FormObject := TF_InputData.Create(Self);
    end
    else
    if (btName = 'bt_FormCreate') then
    begin
      F_FormObject := TF_FormCreate.Create(Self);
    end
    else
    if (btName = 'bt_Control') then
    begin
      F_FormObject := TF_Control.Create(Self);
    end;

    F_FormObject.ShowModal;
  finally
    F_FormObject.Free;
  end;
end;

//----------------------------------------------------------------------------//
//  マウスオーバー
//----------------------------------------------------------------------------//
procedure TF_Menu.ButtonMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
var
  btName: String;
  mmObject: TMemo;
begin
  btName := TButton(Sender).Name;

  if (btName = 'bt_Manual') then
  begin
    mmObject := mm_Manual;
  end
  else
  if (btName = 'bt_InputData') then
  begin
    mmObject := mm_InputData;
  end
  else
  if (btName = 'bt_FormCreate') then
  begin
    mmObject := mm_FormCreate;
  end
  else
  if (btName = 'bt_Control') then
  begin
    mmObject := mm_Control;
  end;

  mmObject.Visible := True;
end;

//----------------------------------------------------------------------------//
//  マウスリーブ
//----------------------------------------------------------------------------//
procedure TF_Menu.ButtonMouseLeave(Sender: TObject);
var
  btName: String;
  mmObject: TMemo;
begin
  btName := TButton(Sender).Name;

  if (btName = 'bt_Manual') then
  begin
    mmObject := mm_Manual;
  end
  else
  if (btName = 'bt_InputData') then
  begin
    mmObject := mm_InputData;
  end
  else
  if (btName = 'bt_FormCreate') then
  begin
    mmObject := mm_FormCreate;
  end
  else
  if (btName = 'bt_Control') then
  begin
    mmObject := mm_Control;
  end;

  mmObject.Visible := False;
end;

//----------------------------------------------------------------------------//
//  外部処理
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//  初期化処理
//----------------------------------------------------------------------------//
procedure TF_Menu.InitProc;
begin
  //表示・非表示制御
  mm_Manual.Visible := False;
  mm_InputData.Visible := False;
  mm_FormCreate.Visible := False;
  mm_Control.Visible := False;
end;

end.
