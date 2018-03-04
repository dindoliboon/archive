@ECHO OFF
bc.exe crcdemo
lcc.exe crcdemo.c
lcclnk.exe -o crcdemo.exe -subsystem console -s crcdemo.obj crc32.lib
ECHO Finished!
