; freakin' ads!
; #########################################################################

    .386
    .model flat, stdcall
    option casemap :none
    option dotname

; #########################################################################

    include \masm32\include\windows.inc
    include \masm32\include\masm32.inc
    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc
    include \masm32\include\advapi32.inc

    includelib \masm32\lib\masm32.lib
    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\kernel32.lib
    includelib \masm32\lib\advapi32.lib

; #########################################################################

    szText MACRO Name, Text:VARARG
        LOCAL lbl

        jmp lbl
        Name db Text, 00000000h
        lbl:
    ENDM

    m2m MACRO M1, M2
        push M2
        pop  M1
    ENDM

    return MACRO arg
        mov eax, arg
        ret
    ENDM

LOWORD MACRO bigword
    mov eax, bigword
    and eax, 0FFFFh
ENDM

HIWORD MACRO bigword
    mov ebx, bigword
    shr ebx, 16
ENDM

    HookProc      proto :DWORD,:DWORD,:DWORD
    InstallHook   proto
    UninstallHook proto

; ##########################################################################

.data
    szIE      db "IEFRAME", 0

.data?
    hHook     dd ?
    hInstance dd ?
    szBuffer  db 1025 dup (?)

.code

; ##########################################################################

DllMain proc hInstDLL:DWORD, fdwReason:DWORD, lpvReserved:DWORD
    .if fdwReason == DLL_PROCESS_ATTACH
        push hInstDLL
        pop hInstance
    .endif

    return TRUE
DllMain endp

; ##########################################################################

InstallHook proc
    invoke SetWindowsHookEx, WH_CBT, HookProc, hInstance, NULL
    mov hHook, eax

    xor eax, eax
    ret
InstallHook endp

; ##########################################################################

UninstallHook proc
    .if hHook
        invoke UnhookWindowsHookEx, hHook
        mov hHook, NULL
    .endif

    ret
UninstallHook endp

; ##########################################################################

HookProc proc uses ebx, nCode:DWORD, wParam:DWORD, lParam:DWORD
    LOCAL hwnd :DWORD
    LOCAL cnt  :DWORD

    mov cnt,  0
    mov hwnd, 0

    .if nCode == HCBT_CREATEWND
        invoke FindWindow, addr szIE, NULL
        .if eax
            invoke GetKeyState, VK_LCONTROL
            HIWORD eax
            add cnt, ebx

            invoke GetKeyState, VK_RCONTROL
            HIWORD eax
            add cnt, ebx

            invoke GetKeyState, VK_LSHIFT
            HIWORD eax
            add cnt, ebx

            invoke GetKeyState, VK_RSHIFT
            HIWORD eax
            add cnt, ebx

            push cnt
            pop  eax

            .if !eax
                invoke GetClassName, wParam, addr szBuffer, 1024

                invoke lstrcmpi, addr szBuffer, addr szIE
                .if eax == 0
                    return 1
                .endif
            .endif
        .endif
    .endif

    invoke CallNextHookEx, hHook, nCode, wParam, lParam
    ret
HookProc endp

; ##########################################################################

End DllMain
