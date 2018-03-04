@ECHO OFF
:; create resource file
rc /v rsrc.rc
cvtres /machine:ix86 rsrc.res

:; create run executable
ml.exe /c /coff /Cp /Gd /Sn run.asm
link.exe /machine:ix86 /merge:.rdata=.text /merge:.text=.data /opt:nowin98 /out:run.exe /release /subsystem:windows run.obj rsrc.obj
