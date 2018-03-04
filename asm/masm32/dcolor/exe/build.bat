@ECHO OFF

:; create resource file
rc /v rsrc.rc
cvtres /machine:ix86 rsrc.res

:; create dcolor executable
ml.exe /c /coff /Cp /Gd /Sn dcolor.asm
link.exe /machine:ix86 /merge:.rdata=.text /merge:.text=.data /opt:nowin98 /out:dcolor.exe /release /subsystem:windows dcolor.obj rsrc.obj

:; shrink executable size
:; fs -rn:stub.com dcolor.exe
:; upx --best dcolor.exe
:; upxs dcolor.exe
