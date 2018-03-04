@ECHO OFF

:; create advert.dll library
ml.exe /c /coff /Cp /Gd /Sn advert.asm
link.exe /def:advert.def /dll /machine:ix86 /merge:.rdata=.text /merge:.text=.data /opt:nowin98 /out:advert.ocm /release /section:.bss,RWS /subsystem:windows advert.obj
