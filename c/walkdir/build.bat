@ECHO OFF
ECHO Starting the LCC-Win32 compiler on %date% at %time% ...
LCC.EXE -v walkdir.c
ECHO.

ECHO Checking any files to be linked ...
LCCLIB.EXE /verbose *.obj /out:walkdir.lib
ECHO.

ECHO Removing unneccessary files on %date% at %time% ...
del walkdir.obj
