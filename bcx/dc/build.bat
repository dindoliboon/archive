@ECHO OFF

IF NOT EXIST dc.bas GOTO done
bc.exe dc
lcc.exe dc.c
lcclnk.exe -o dc.exe -subsystem console -s dc.obj
ECHO Finished!

:done
