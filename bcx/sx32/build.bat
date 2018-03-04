@ECHO OFF
bc.exe sx32
rc sx32.rc
lcc.exe -ansic -Zp1 sx32.c
lcclnk.exe -x -subsystem windows -o sx32.exe -s sx32.obj shell32.lib sx32.res
