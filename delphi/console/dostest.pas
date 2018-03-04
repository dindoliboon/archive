program DosTest;

{this is a real mode dos program for testing ConsoleTest.dpr
Compile with Turbo Pascal or Borland Pascal
If the program does direct screen writes (i.e uses Crt; ) then
the output will be lost}

var
  i: Integer;

begin
  Writeln('Hello from real-mode dos');
  for i:= 1 to ParamCount do
    Writeln(ParamStr(i))
end.