@ECHO OFF
echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo ³ Usage: BUILD Option                                               ³
echo ³ Note:  Option can be 1, 2, 3, or empty.                           ³
echo ³ ®®     1 - DirectDraw; 2 - GDI; 3 - VFW; empty - DirectDraw    ¯¯ ³
echo ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

:; Create mmx object file
:; NASM.EXE -f win32 mmx.asm

:; Create TinyPTC object files
LCC.EXE -ansic -Zp1 -O convert.c
LCC.EXE -ansic -Zp1 -O ddraw.c
LCC.EXE -ansic -Zp1 -O gdi.c
LCC.EXE -ansic -Zp1 -O tinyptc.c
LCC.EXE -ansic -Zp1 -O vfw.c

IF '%1' == '2' GOTO BuildGDI
IF '%1' == '3' GOTO BuildVFW

:; Create DirectDraw TinyPTC static library
:  BuildDirectDraw
LCCLIB.EXE /OUT:tinyptc.lib mmx.obj convert.obj ddraw.obj tinyptc.obj
GOTO theend

:; Create GDI TinyPTC static library
:  BuildGDI
LCCLIB.EXE /OUT:tinyptc.lib mmx.obj convert.obj ddraw.obj gdi.obj tinyptc.obj vfw.obj
GOTO theend

:; Create VideoForWindows TinyPTC static library
:  BuildVFW
LCCLIB.EXE /OUT:tinyptc.lib mmx.obj convert.obj ddraw.obj tinyptc.obj vfw.obj

: theend
