@ECHO OFF
rc /v rsrc.rc
cvtres /machine:ix86 rsrc.res
ml /c /coff aim.asm
link /merge:.rdata=.text /merge:.text=.data /subsystem:windows aim.obj rsrc.obj
del *.obj
del *.res
