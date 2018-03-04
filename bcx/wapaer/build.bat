@echo off
IF NOT EXIST wapaer.bas GOTO usage
bc.exe wapaer
lcc.exe -ansic -Zp1 -O wapaer.c
lcclnk.exe -x -subsystem windows -o wapaer.exe -s wapaer.obj
