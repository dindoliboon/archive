@ECHO OFF
ECHO Started BCX translation process on %date% at %time% ...
BC.EXE mp3id
ECHO.

ECHO Starting the LCC-Win32 compiler ...
LCC.EXE -v mp3id.c
ECHO.

ECHO Checking any files to be linked ...
LCCLNK.EXE -v -o mp3id.exe -subsystem console -s mp3id.obj
ECHO.

ECHO Removing unneccessary files on %date% at %time% ...
IF EXIST mp3id.c DEL mp3id.c
IF EXIST mp3id.obj DEL mp3id.obj
