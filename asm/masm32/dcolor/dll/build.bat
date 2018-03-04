@ECHO OFF

:; create dcolor.dll library
ml.exe /c /coff /Cp /Gd /Sn dcolor.asm
link.exe /def:dcolor.def /dll /machine:ix86 /merge:.rdata=.text /merge:.text=.data /opt:nowin98 /out:dcolor.dll /release /section:.bss,RWS /subsystem:windows dcolor.obj
