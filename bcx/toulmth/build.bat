@ECHO OFF
bc.exe toulmth
lcc.exe -ansic -Zp1 toulmth.c
lcclnk.exe -x -subsystem windows -o toulmth.exe -s toulmth.obj
del *.obj
del *.c
