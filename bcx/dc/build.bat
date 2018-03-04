@ECHO OFF
SET name=dc

CALL PCALL.BAT %name%
UPX --best --crp-ms=999999 %name%.exe

DEL %name%.c
