@ECHO OFF
bc.exe ds
lcc.exe ds.c
lcclnk.exe -o ds.exe -subsystem console -s ds.obj
