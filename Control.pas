unit Control;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs;

type
  TF_Control = class(TForm)
    StyleBook1: TStyleBook;
    procedure FormCreate(Sender: TObject);
  private
    { private 宣言 }
    procedure InitProc;
  public
    { public 宣言 }
  end;

var
  F_Control: TF_Control;

implementation

uses
  Kyotu;

{$R *.fmx}

//----------------------------------------------------------------------------//
//  内部処理
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//  onCreate
//----------------------------------------------------------------------------//
procedure TF_Control.FormCreate(Sender: TObject);
begin
  InitProc;
end;

//----------------------------------------------------------------------------//
//  外部処理
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//  初期化処理
//----------------------------------------------------------------------------//
procedure TF_Control.InitProc;
begin
  GetIniFile;
end;

end.
