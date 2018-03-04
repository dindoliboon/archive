@ECHO OFF

IF NOT EXIST ds.bas GOTO done
bc.exe ds
lcc.exe ds.c
lcclnk.exe -o ds.exe -subsystem console -s ds.obj
ECHO Finished!

:done
