unit Manual;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs;

type
  TF_Manual = class(TForm)
    StyleBook1: TStyleBook;
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { private �錾 }
  public
    { public �錾 }
  end;

var
  F_Manual: TF_Manual;

implementation

{$R *.fmx}

//----------------------------------------------------------------------------//
//  onKeyDown
//----------------------------------------------------------------------------//
procedure TF_Manual.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  case Key of
    VKF12: begin  //�I��
      Close;
    end;
  end;
end;


end.
