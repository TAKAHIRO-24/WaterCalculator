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
    { private �錾 }
    procedure InitProc;
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
procedure TF_Control.FormCreate(Sender: TObject);
begin
  InitProc;
end;

//----------------------------------------------------------------------------//
//  �O������
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//  ����������
//----------------------------------------------------------------------------//
procedure TF_Control.InitProc;
begin
  GetIniFile;
end;

end.
