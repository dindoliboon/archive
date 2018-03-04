@ECHO OFF
:: simple front end to use for encode/decode

ECHO -- Started on %date% at %time% --
IF "%1" == "/e" GOTO EncodeFile
IF "%1" == "/E" GOTO EncodeFile
IF "%1" == "/d" GOTO DecodeFile
IF "%1" == "/D" GOTO DecodeFile
GOTO InvalidFlag

:EncodeFile
IF NOT EXIST "%2" ECHO File does not exist
IF NOT EXIST "%2" GOTO EndProgram

ECHO Removing any existing output files...
IF EXIST eout.txt DEL eout.txt

ECHO Attempting to encode file...
IF NOT EXIST encode.exe ECHO Encoder does not exist
IF NOT EXIST encode.exe GOTO EndProgram
encode.exe %2

IF EXIST eout.txt ECHO Encoding successful!
IF NOT EXIST eout.txt ECHO Unknown encoding error occurred!
IF NOT EXIST eout.txt GOTO EndProgram

IF "%3" == "" GOTO EndProgram
ECHO Checking if backup file exists...
IF EXIST %3.bak DEL %3.bak
IF EXIST %3 RENAME %3 %3.bak
ECHO Renaming file...
IF NOT "%3" == "" RENAME eout.txt %3
GOTO EndProgram


:DecodeFile
IF NOT EXIST "%2" ECHO File does not exist
IF NOT EXIST "%2" GOTO EndProgram

ECHO Removing any existing output files...
IF EXIST dout.txt DEL dout.txt

ECHO Attempting to decode file...
IF NOT EXIST decode.exe ECHO Decoder does not exist
IF NOT EXIST decode.exe GOTO EndProgram
decode.exe %2

IF EXIST dout.txt ECHO Decoding successful!
IF NOT EXIST dout.txt ECHO Unknown decoding error occurred!
IF NOT EXIST dout.txt GOTO EndProgram

IF "%3" == "" GOTO EndProgram
ECHO Checking if backup file exists...
IF EXIST %3.bak DEL %3.bak
IF EXIST %3 RENAME %3 %3.bak
ECHO Renaming file...
IF NOT "%3" == "" RENAME dout.txt %3
GOTO EndProgram


:InvalidFlag
ECHO.
ECHO EDS [/e] [/d] [input] [output]
ECHO.
ECHO   /e      encodes a file
ECHO   /d      decodes a file
ECHO   input   file to encode/decode
echo   output  optional file name for saved data
ECHO.


:EndProgram
ECHO -- Finished on %date% at %time% --
