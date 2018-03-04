@ECHO OFF
ds.exe dialogs -s -c -a4
bc.exe dialogs
lrc.exe dialogs.dlg
lcc.exe -ansic -O -Zp1 -unused dialogs.c
lcclnk.exe -x -subsystem windows -o dialogs.exe -s dialogs.obj dialogs.res
del *.obj
del *.c
