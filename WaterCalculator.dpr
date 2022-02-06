program WaterCalculator;

uses
  System.StartUpCopy,
  FMX.Forms,
  Menu in 'Menu.pas' {F_Menu},
  Manual in 'Manual.pas' {F_Manual},
  InputData in 'InputData.pas' {F_InputData},
  FormCreate in 'FormCreate.pas' {F_FormCreate},
  Control in 'Control.pas' {F_Control},
  Kyotu in 'Kyotu.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TF_Menu, F_Menu);
  Application.CreateForm(TF_Manual, F_Manual);
  Application.CreateForm(TF_InputData, F_InputData);
  Application.CreateForm(TF_FormCreate, F_FormCreate);
  Application.CreateForm(TF_Control, F_Control);
  Application.Run;
end.
