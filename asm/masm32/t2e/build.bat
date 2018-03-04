@ECHO OFF

:: create blank dos header
:: requires segmented exe linker
::\masm32\bin\ml /c dosstub.asm
::\masm32\bin\link16 dosstub.obj

:: create stub executable
\masm32\bin\rc /v stubres.rc
\masm32\bin\cvtres /machine:ix86 stubres.res
\masm32\bin\ml /c /coff stub.asm
\masm32\bin\Link /RELEASE /SUBSYSTEM:WINDOWS stub.obj stubres.obj
CALL release.bat 1
PAUSE

:: create t2e executable
\masm32\bin\rc /v rsrc.rc
\masm32\bin\cvtres /machine:ix86 rsrc.res
\masm32\bin\ml /c /coff t2e.asm
\masm32\bin\link /RELEASE /SUBSYSTEM:CONSOLE t2e.obj rsrc.obj
CALL release.bat 2

DEL *.obj
DEL *.res
