@ECHO OFF

\masm32\bin\ml /c /coff cmon.asm
\masm32\bin\link /merge:.rdata=.text /merge:.text=.data /RELEASE /SUBSYSTEM:WINDOWS cmon.obj

DEL *.obj
