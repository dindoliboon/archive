@ECHO OFF
bc.exe ds
lcc.exe ds.c
lcclnk.exe -subsystem console -s ds.obj
