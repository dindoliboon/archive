@ECHO OFF
BC.EXE test
LRC.EXE test.rc
LCC.EXE -ansic -Zp1 -O test.c
LCCLNK.EXE -x -subsystem windows -s test.obj tinyptc.lib test.res -o test.exe
