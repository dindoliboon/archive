; #########################################################################
;
;   title   : Clear Screen
;   version : 1.0
;   date    : March 06, 2001
;   abstract: Removes all contents from a screen within a command
;             prompt session. Made for a friend who was using the
;             UNIX system call "clear" in his programs.
;   target  : DOS 5.0 or higher
;   tools   : Ralf Brown's Interrupt List
;             Microsoft Macro Assembler 6.15.8803
;             Microsoft Segmented Executable Linker 5.60.339
;   compile : ml.exe /c clear.asm
;           : link /tiny clear.obj
;   usage   : run clear.com
;
;   - dl (dl@tks.cjb.net)
;
; #########################################################################
