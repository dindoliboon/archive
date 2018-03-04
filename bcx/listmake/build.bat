@ECHO OFF
ECHO Started BCX translation process on %date% at %time% ...
BC.EXE listmake
ECHO.

ECHO Starting the LCC-Win32 compiler ...
LCC.EXE -v listmake.c
ECHO.

ECHO Checking any files to be linked ...
LCCLNK.EXE -v -o listmake.exe -subsystem console -s listmake.obj walkdir.lib
ECHO.

ECHO Removing unneccessary files on %date% at %time% ...
IF EXIST listmake.c DEL listmake.c
IF EXIST listmake.obj DEL listmake.obj
