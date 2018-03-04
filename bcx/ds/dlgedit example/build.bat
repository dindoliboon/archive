@ECHO OFF
ds.exe dialogs.dlg /s /c
lrc.exe dialogs.dlg
bc.exe dialogs
lcc.exe dialogs.c
lcclnk.exe -o dialogs.exe -subsystem windows -s dialogs.obj dialogs.res
