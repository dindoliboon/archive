@ECHO OFF

:: requires upx and file scanner

IF %1 == 2 GOTO Optimize_t2e

:: optimize stub
fs.exe -rn:dosstub.exe stub.exe
fs.exe -rd stub.exe
upx.exe --best stub.exe
GOTO End_Program

:: optimize t2e
:Optimize_t2e
fs.exe -rn:dosstub.exe t2e.exe
fs.exe -rd t2e.exe
upx.exe --best t2e.exe

:End_Program
