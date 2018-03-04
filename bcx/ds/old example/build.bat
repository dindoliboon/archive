@ECHO OFF
lrc.exe dialogs.dlg
ds.exe dialogs /s /c
bc.exe dialogs
lcc.exe dialogs.c
lcclnk.exe -o dialogs.exe -subsystem windows -s dialogs.obj dialogs.res
