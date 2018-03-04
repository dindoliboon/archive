@ECHO OFF
SET name=dc

BC %name%
LCC %name%.c
LCCLNK -subsystem console -o %name%.exe -s %name%.obj
UPX --best --crp-ms=999999 %name%.exe

DEL %name%.c
DEL %name%.obj
