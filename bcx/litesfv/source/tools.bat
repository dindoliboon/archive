@ECHO OFF
IF EXIST %1.%2 CALL noconsole.exe %1.%2
IF EXIST %1.%2 CALL upx --best %1.%2
IF EXIST %1.%2 CALL upxs %1.%2
IF EXIST %1.%2 CALL fs -c %1.%2
