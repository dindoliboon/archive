@echo off
set file=unrar
e:\dev\masm\bin\ml.exe /c /coff /Cp /Fl /Sc /Sg %file%.asm
 e:\dev\masm\bin\link.exe /SECTION:.text,RWE /SUBSYSTEM:WINDOWS,4.0 %file%.obj
  if errorlevel 1 goto End
   del %file%.OBJ
    del %file%.LST

:End
 pause
 cls