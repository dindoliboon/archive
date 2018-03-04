@ECHO OFF
bc.exe pt
lrc.exe pt.dlg
lcc.exe -ansic -Zp1 -O pt.c
lcclnk.exe -x -subsystem windows -o pt.exe -s pt.obj pt.res winmm.lib
