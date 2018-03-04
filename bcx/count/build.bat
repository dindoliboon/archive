@ECHO OFF
ECHO Started BCX translation process on %date% at %time% ...
BC.EXE count
ECHO.

ECHO Starting the LCC-Win32 compiler ...
LCC.EXE -v count.c
ECHO.

ECHO Checking any files to be linked ...
LCCLNK.EXE -v -o count.exe -subsystem console -s count.obj walkdir.lib
ECHO.

ECHO Removing unneccessary files on %date% at %time% ...
IF EXIST count.c DEL count.c
IF EXIST count.obj DEL count.obj
