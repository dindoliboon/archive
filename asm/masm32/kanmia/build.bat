@echo off
rc /v rsrc.rc
cvtres /machine:ix86 rsrc.res
ml /c /coff kanmia.asm
:: /MERGE:.rdata=.text /MERGE:.text=.data 
Link /MERGE:.rdata=.text /MERGE:.text=.data /SUBSYSTEM:WINDOWS kanmia.obj rsrc.obj
fs -rn:c:\winnt\command\64.com kanmia.exe
