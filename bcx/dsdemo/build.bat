@ECHO OFF

IF NOT EXIST dsdemo.bas GOTO done
bc.exe dsdemo
lrc.exe dlgdemo.dlg
lcc.exe dsdemo.c
lcclnk.exe -o dsdemo.exe -subsystem windows -s dsdemo.obj dlgdemo.res
ECHO Finished!

:done
