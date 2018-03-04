@ECHO OFF
rc /v rsrc.rc
cvtres /machine:ix86 rsrc.res
ml /c /coff tks_infl.asm
link /merge:.rdata=.text /merge:.text=.data /subsystem:windows tks_infl.obj rsrc.obj
del *.obj
del *.res
