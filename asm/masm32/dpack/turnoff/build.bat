@ECHO OFF
:; create resource file
rc /v rsrc.rc
cvtres /machine:ix86 rsrc.res

:; create turnoff executable
ml.exe /c /coff /Cp /Gd /Sn turnoff.asm
link.exe /machine:ix86 /merge:.rdata=.text /merge:.text=.data /opt:nowin98 /out:turnoff.exe /release /subsystem:windows turnoff.obj rsrc.obj
