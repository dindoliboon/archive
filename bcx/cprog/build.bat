@ECHO OFF
bc.exe cprog
lcc.exe -ansic -Zp1 cprog.c
lcclnk.exe -x -subsystem console -o cprog.exe -s cprog.obj
del *.obj
del *.c
