@ECHO OFF
bc.exe decode
lcc.exe -ansic -O -Zp1 -unused decode.c
lcclnk.exe -x -subsystem console -o decode.exe -s decode.obj

bc.exe encode
lcc.exe -ansic -O -Zp1 -unused encode.c
lcclnk.exe -x -subsystem console -o encode.exe -s encode.obj
del *.obj
del *.c
