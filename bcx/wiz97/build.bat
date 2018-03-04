@ECHO OFF

:: convert, compile resources, compile c source, link into exe
bc.exe wiz97
lrc wiz97.rc
lcc.exe -ansic -Zp1 wiz97.c
lcclnk.exe -x -subsystem windows -o wiz97.exe -s wiz97.obj wiz97.res


:: comment below to keep existing files
del wiz97.c
del wiz97.obj
del wiz97.res
