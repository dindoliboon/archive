; #########################################################################

    .386
    .model flat, stdcall
    option casemap :none   ; case sensitive

; #########################################################################

    include \masm32\include\windows.inc
    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc
    include \masm32\include\shell32.inc

    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\kernel32.lib
    includelib \masm32\lib\shell32.lib

.data
    szShellTray db "Shell_TrayWnd", 0

.data?
    hCtl        dd ?

; #########################################################################

.code

start:

; #########################################################################

    invoke FindWindow, addr szShellTray, NULL
    .if eax
        mov hCtl, eax

        invoke IsWindowVisible, hCtl
        .if eax == 0
            invoke EnableWindow, hCtl, TRUE
            invoke ShowWindow, hCtl, SW_RESTORE
        .else
            invoke EnableWindow, hCtl, FALSE
            invoke ShowWindow, hCtl, SW_HIDE
        .endif
    .endif

    invoke ExitProcess, 0

; #########################################################################

end start
