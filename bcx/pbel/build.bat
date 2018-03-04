@ECHO OFF
bc.exe pbel
lcc.exe pbel.c
lcclnk.exe -o pbel.exe -subsystem console -s pbel.obj
ECHO Finished!
IF EXIST pbel.c DEL pbel.c
IF EXIST pbel.obj DEL pbel.obj
