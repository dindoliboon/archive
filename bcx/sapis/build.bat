@ECHO OFF
@ECHO OFF
bc.exe sapis
lrc.exe sapis.dlg
lcc.exe -ansic -Zp1 sapis.c
lcclnk.exe -x -subsystem windows -o sapis.exe -s sapis.obj sapis.res
del *.obj
del *.c
del *.res
