@ECHO OFF

IF NOT EXIST makelink.bas GOTO fini
bc.exe makelink
lcc.exe -O makelink.c
lcclnk.exe -o makelink.exe -subsystem windows -s makelink.obj ole32.lib uuid.lib

:fini
