@ECHO OFF
bc.exe logbox
lcc.exe -ansic -Zp1 logbox.c
lcclnk.exe -x -subsystem windows -o logbox.exe -s logbox.obj
del *.obj
del *.c
