@ECHO OFF
lrc.exe loview.dlg
bc.exe loview
lcc.exe -ansic -Zp1 loview.c
lcclnk.exe -x -subsystem windows -o loview.exe -s loview.obj loview.res shell32.lib
