program ConsoleTest;

uses
  Forms,
  ConsoleUnit in 'ConsoleUnit.pas' {ConsoleForm},
  ConsoleApp in 'ConsoleApp.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TConsoleForm, ConsoleForm);
  Application.Run;
end.
