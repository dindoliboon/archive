@ECHO OFF
LCC.EXE -v lv.c
LCCLNK.EXE -v -o lcc_rt_lv.exe -subsystem windows -s lv.obj shell32.lib

BCC32.EXE -tW -ebc_lv.exe lv.c
BCC32.EXE -tWR -ebc_rt_lv.exe lv.c

CL.EXE /Fevc_lv.exe lv.c shell32.lib user32.lib gdi32.lib
CL.EXE /MD /Fevc_lv.exe lv.c shell32.lib user32.lib gdi32.lib

DEL *.obj
DEL *.tds
