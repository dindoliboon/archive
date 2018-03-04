@ECHO OFF
ECHO Started assembling process on %date% at %time% ...
ml /c /coff readme.asm

ECHO Checking any files to be linked ...
link -lib /out:readme.lib readme.obj

IF EXIST readme.lib ECHO readme.lib has been created!
ECHO.

ECHO Removing unneccessary files on %date% at %time% ...
IF EXIST readme.obj DEL readme.obj

: give user time to read screen
PAUSE
