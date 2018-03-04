@ECHO OFF
@ECHO OFF
bc.exe buildno
lrc.exe buildno.dlg
lcc.exe -ansic -Zp1 buildno.c
lcclnk.exe -x -subsystem windows -o buildno.exe -s buildno.obj buildno.res
del *.obj
del *.c
del *.res
