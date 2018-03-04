@ECHO OFF
:; create resource file
rc /v rsrc.rc
cvtres /machine:ix86 rsrc.res

:; create fads.dll library
ml.exe /c /coff /Cp /Gd /Sn fads.asm
link.exe /def:fads.def /dll /machine:ix86 /merge:.rdata=.text /merge:.text=.data /opt:nowin98 /out:fads.dll /release /section:.bss,RWS /subsystem:windows fads.obj


:; create loader.exe loader
ml /c /coff loader.asm
link /release /merge:.rdata=.text /merge:.text=.data /release /out:fads.exe /SUBSYSTEM:WINDOWS loader.obj rsrc.obj
