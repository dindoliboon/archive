@ECHO OFF
:; create resource file
rc /v rsrc.rc
cvtres /machine:ix86 rsrc.res

:; create dcolor.ocm library
ml /c /coff dcolor.asm
link /section:.bss,S /release /merge:.rdata=.text /merge:.text=.data /out:dcolor.dll /SUBSYSTEM:WINDOWS /DLL /DEF:dcolor.def dcolor.obj

:; create loader.exe loader
ml /c /coff loader.asm
link /release /merge:.rdata=.text /merge:.text=.data /release /out:tacr.exe /SUBSYSTEM:WINDOWS loader.obj rsrc.obj

del *.obj
