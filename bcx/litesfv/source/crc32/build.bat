@ECHO OFF
ECHO Started assembling process on %date% at %time% ...
ml /c /coff crc32.asm

ECHO Checking any files to be linked ...
link -lib /out:crc32.lib crc32.obj

IF EXIST crc32.lib ECHO crc32.lib has been created!
ECHO.

ECHO Removing unneccessary files on %date% at %time% ...
IF EXIST crc32.obj DEL crc32.obj

: give user time to read screen
PAUSE
