@ECHO OFF
ml /c /coff infsetup.asm
link /merge:.rdata=.text /merge:.text=.data /subsystem:windows infsetup.obj
del *.obj
del *.res
