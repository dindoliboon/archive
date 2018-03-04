@ECHO OFF
bc.exe bide
lcc.exe -ansic -Zp1 bide.c
lcclnk.exe -x -subsystem windows -o bide.exe -s bide.obj
del *.obj
del *.c
