@ECHO OFF
rc trayicon.rc
bc.exe trayicon
lcc.exe -ansic -Zp1 trayicon.c
lcclnk.exe -x -subsystem windows -o trayicon.exe -s trayicon.obj trayicon.res shell32.lib
del *.obj
del *.c
