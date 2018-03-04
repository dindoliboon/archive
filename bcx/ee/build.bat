@ECHO OFF
bc.exe episode
lrc.exe episode.dlg
lcc.exe episode.c
lcclnk.exe -x -subsystem windows -o episode.exe -s episode.obj episode.res
del *.obj
del *.c
del *.res
