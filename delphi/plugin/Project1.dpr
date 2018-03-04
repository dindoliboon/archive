program Project1;

uses
  Forms, SysUtils,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}
//I made this error for you to notice 
//there is a function here
//replace the current selected text

procedure ReplaceText(Text: PChar); far;
begin
	Form1.Memo1.SelText := StrPas(Text);
end;

exports ReplaceText;

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
