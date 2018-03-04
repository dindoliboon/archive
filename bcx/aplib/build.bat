@ECHO OFF
bc.exe apldemo
lcc.exe apldemo.c
lcclnk.exe -o apldemo.exe -subsystem console -s apldemo.obj aplib.lib
ECHO Finished!
