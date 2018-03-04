@ECHO OFF
rc /v rsrc.rc
cvtres /machine:ix86 rsrc.res
ml /c /coff tks_acc3.asm
link /merge:.rdata=.text /merge:.text=.data /subsystem:windows tks_acc3.obj rsrc.obj
del *.obj
del *.res
