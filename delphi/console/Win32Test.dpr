program Win32Test;
{$APPTYPE CONSOLE}
var
  i: Integer;
begin
  Writeln('Hello from Win32 Console');
  for i:= 1 to ParamCount do
    Writeln('Parameter ', i, ' = "', ParamStr(i), '"')
end.
