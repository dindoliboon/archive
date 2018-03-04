@ECHO OFF
rc.exe script1.rc
cvtres /OUT:script1.res.obj script1.res
ds.exe script1 /s /c
bc.exe script1
lcc.exe script1.c
lcclnk.exe -o script1.exe -subsystem windows -s script1.obj script1.res.obj
