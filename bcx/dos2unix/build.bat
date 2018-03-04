@ECHO OFF
ECHO Started BCX translation process on %date% at %time% ...
BC.EXE dos2unix
ECHO.

ECHO Starting the LCC-Win32 compiler ...
LCC.EXE -v dos2unix.c
ECHO.

ECHO Checking any files to be linked ...
LCCLNK.EXE -v -o dos2unix.exe -subsystem console -s dos2unix.obj walkdir.lib
ECHO.

ECHO Removing unneccessary files on %date% at %time% ...
IF EXIST dos2unix.c DEL dos2unix.c
IF EXIST dos2unix.obj DEL dos2unix.obj
