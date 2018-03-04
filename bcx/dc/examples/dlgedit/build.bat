@ECHO OFF
SET name=dialogs

DEL expDC_%name%.bas
DEL cmpDC_%name%.bas
DEL guiDC_%name%.bas
DEL expDS_%name%.bas
DEL cmpDS_%name%.bas
DEL guiDS_%name%.bas

: generate dialog converter code

DC %name% -l1 -s -c
BC %name%
LCC %name%.c
MOVE %name%.bas expDC_%name%.bas
LCCLNK -subsystem windows -o expDC_%name%.exe -s %name%.obj

DC %name% -l2 -s -c
BC %name%
LCC %name%.c
MOVE %name%.bas cmpDC_%name%.bas
LCCLNK -subsystem windows -o cmpDC_%name%.exe -s %name%.obj

DC %name% -l3 -s -c
BC %name%
LCC %name%.c
MOVE %name%.bas guiDC_%name%.bas
LCCLNK -subsystem windows -o guiDC_%name%.exe -s %name%.obj

: generate dialog starter code
LRC.EXE %name%.dlg

DC %name% -g2 -l1 -s -c
BC %name%
LCC %name%.c
MOVE %name%.bas expDS_%name%.bas
LCCLNK -subsystem windows -o expDS_%name%.exe -s %name%.obj %name%.res

DC %name% -g2 -l2 -s -c
BC %name%
LCC %name%.c
MOVE %name%.bas cmpDS_%name%.bas
LCCLNK -subsystem windows -o cmpDS_%name%.exe -s %name%.obj %name%.res

DC %name% -g2 -l3 -s -c
BC %name%
LCC %name%.c
MOVE %name%.bas guiDS_%name%.bas
LCCLNK -subsystem windows -o guiDS_%name%.exe -s %name%.obj %name%.res

DEL %name%.c
DEL %name%.obj
DEL %name%.res
