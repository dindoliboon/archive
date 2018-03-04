@ECHO OFF
bc.exe nab
lcc.exe -ansic -Zp1 nab.c
lcclnk.exe -x -subsystem console -o nab.exe -s nab.obj
del *.obj
del *.c
