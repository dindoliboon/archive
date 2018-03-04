@ECHO OFF
lrc.exe wedit.dlg
ds.exe wedit /s /c
bc.exe wedit
lcc.exe wedit.c
lcclnk.exe -o wedit.exe -subsystem windows -s wedit.obj wedit.res
