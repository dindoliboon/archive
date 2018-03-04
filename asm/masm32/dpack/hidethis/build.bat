@ECHO OFF
:; create resource file
rc /v rsrc.rc
cvtres /machine:ix86 rsrc.res

:; create hidethis executable
ml.exe /c /coff /Cp /Gd /Sn hidethis.asm
link.exe /machine:ix86 /merge:.rdata=.text /merge:.text=.data /opt:nowin98 /out:hidethis.exe /release /subsystem:windows hidethis.obj rsrc.obj
