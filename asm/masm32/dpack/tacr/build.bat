@ECHO OFF
rc /v rsrc.rc
cvtres /machine:ix86 rsrc.res

ml /c /coff tacr.asm
link /merge:.rdata=.text /merge:.text=.data /subsystem:windows tacr.obj rsrc.obj
