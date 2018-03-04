@ECHO OFF
dc.exe dialogs.dlg /s /c
bc.exe dialogs
lcc.exe dialogs.c
lcclnk.exe -o dialogs.exe -subsystem windows -s dialogs.obj
ECHO Finished!
