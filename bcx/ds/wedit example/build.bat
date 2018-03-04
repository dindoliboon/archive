@ECHO OFF
ds.exe wedit /s /c
lrc.exe wedit.dlg
bc.exe wedit
lcc.exe wedit.c
lcclnk.exe -o wedit.exe -subsystem windows -s wedit.obj wedit.res
