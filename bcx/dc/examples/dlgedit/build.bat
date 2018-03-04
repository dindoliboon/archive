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
MOVE %name%.bas expDC_%name%.bas
CALL PWALL.BAT expDC_%name%

DC %name% -l2 -s -c
MOVE %name%.bas cmpDC_%name%.bas
CALL PWALL.BAT cmpDC_%name%

DC %name% -l3 -s -c
MOVE %name%.bas guiDC_%name%.bas
CALL PWALL.BAT guiDC_%name%

: generate dialog starter code
CALL "C:\Program Files\PellesC\Bin\povars32.bat"
PORC.EXE %name%.dlg

DC %name% -g2 -l1 -s -c
MOVE %name%.bas expDS_%name%.bas
CALL PWALL.BAT expDS_%name% %name%.res

DC %name% -g2 -l2 -s -c
MOVE %name%.bas cmpDS_%name%.bas
CALL PWALL.BAT cmpDS_%name% %name%.res

DC %name% -g2 -l3 -s -c
MOVE %name%.bas guiDS_%name%.bas
CALL PWALL.BAT guiDS_%name% %name%.res

DEL %name%.c
DEL %name%.res
