program ProjJiraAutomation;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {Form1},
  UTask in 'UTask.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
