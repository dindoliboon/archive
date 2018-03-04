@ECHO OFF
@ECHO OFF
bc.exe htmlse
lrc.exe htmlse.dlg
lcc.exe -ansic -Zp1 htmlse.c
lcclnk.exe -x -subsystem windows -o htmlse.exe -s htmlse.obj htmlse.res
del *.obj
del *.c
del *.res
