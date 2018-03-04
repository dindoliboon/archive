@ECHO OFF
SET name=dc

BC %name%
LCC %name%.c
LCCLNK -subsystem console -o %name%.exe -s %name%.obj

DEL %name%.c
DEL %name%.obj
