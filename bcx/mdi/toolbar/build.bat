@ECHO OFF
bc.exe mdi
lcc.exe -ansic -Zp1 mdi.c
lcclnk.exe -x -subsystem windows -o mdi.exe -s mdi.obj
del *.obj
del *.c
