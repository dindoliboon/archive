@ECHO OFF
: if your not using NT, you might not have enough environment space
SET bld_typ=-subsystem console
SET bld_nme=litesfv
SET bld_ext=exe
SET bld_otr=shell32.lib crc32.lib readme.lib

: compile all sources
ECHO Started BCX translation process on %date% at %time% ...
IF EXIST %bld_nme%.%bld_ext% DEL %bld_nme%.%bld_ext%
BC.EXE %bld_nme%
ECHO.

ECHO Searching for any resource files ...
: if you want to compile a resource, rename it to filename.rc
: dlg are not compiled because you might of used DC
IF EXIST %bld_nme%.rc LRC.EXE /v %bld_nme%.rc
ECHO.

ECHO Starting the LCC-Win32 compiler ...
IF EXIST %bld_nme%.c LCC.EXE -v %bld_nme%.c
ECHO.

ECHO Checking any files to be linked ...
IF EXIST %bld_nme%.res LCCLNK.EXE -v -o %bld_nme%.%bld_ext% %bld_typ% -s %bld_nme%.obj %bld_nme%.res %bld_otr%
IF NOT EXIST %bld_nme%.res LCCLNK.EXE -v -o %bld_nme%.%bld_ext% %bld_typ% -s %bld_nme%.obj %bld_otr%
IF EXIST %bld_nme%.%bld_ext% ECHO %bld_nme%.%bld_ext% has been created!
ECHO.

ECHO Running any external tools ...
IF EXIST tools.bat CALL tools.bat %bld_nme% %bld_ext%

: cleanup memory and hd
ECHO Removing unneccessary files on %date% at %time% ...
IF EXIST %bld_nme%.c DEL %bld_nme%.c
IF EXIST %bld_nme%.obj DEL %bld_nme%.obj
IF EXIST %bld_nme%.res DEL %bld_nme%.res
SET bld_typ=
SET bld_nme=
SET bld_ext=
SET bld_otr=

: give user time to read screen
PAUSE
