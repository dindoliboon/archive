@ECHO OFF
@ECHO OFF
bc.exe str2chr
lrc.exe str2chr.dlg
lcc.exe -ansic -Zp1 str2chr.c
lcclnk.exe -x -subsystem windows -o str2chr.exe -s str2chr.obj str2chr.res
del *.obj
del *.c
del *.res
