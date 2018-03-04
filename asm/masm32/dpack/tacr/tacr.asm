; #########################################################################

    .386
    .model flat, stdcall
    option casemap :none   ; case sensitive

; #########################################################################

    include \masm32\include\windows.inc
    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc

    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\kernel32.lib

; #########################################################################

.data
    szProgman  db "progman", 0
    szProgram  db "program manager",0
    szShellDV  db "shelldll_defview", 0
    szShellLV  db "syslistview32", 0

.data?
    hDesktop   dd ?

; #########################################################################

    .code

start:

    invoke FindWindow, addr szProgman, addr szProgram
    invoke FindWindowEx, eax, 0, addr szShellDV, NULL
    invoke FindWindowEx, eax, 0, addr szShellLV, NULL
    mov hDesktop, eax

    invoke SendMessage, hDesktop, LVM_SETTEXTBKCOLOR, 0, HTTRANSPARENT
    invoke InvalidateRect, hDesktop, NULL, TRUE

    invoke ExitProcess, 0

; #########################################################################

end start
