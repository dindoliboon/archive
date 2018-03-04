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

    HookProc      proto :DWORD,:DWORD,:DWORD
    DesktopProc   proto :DWORD,:DWORD,:DWORD,:DWORD
    GetDesktop    proto
    GetDesktopLV  proto
    InstallHook   proto
    UninstallHook proto
    ChangeColors  proto :DWORD,:DWORD

; ##########################################################################

.const
    WM_HOOKADD equ WM_USER + 1
    WM_HOOKRMV equ WM_USER + 2

.data
    szTrans    db "-1", 0
    szProgman  db "progman", 0
    szProgram  db "program manager",0
    szShellDV  db "shelldll_defview", 0
    szShellLV  db "syslistview32", 0
    szSubKey   db "Software\DL Software\D-Color\", 0
    szFore     db "FG Color", 0
    szBack     db "BG Color", 0

.data?
    FGColor    dd ?
    BGColor    dd ?
    hDesktop   dd ?
    hHook      dd ?
    hOldProc   dd ?
    hInstance  dd ?
    hKey       dd ?
    hValue     dd ?
    szBuffer   db 20 dup (?)

.code

; ##########################################################################

DllMain proc hInstDLL:DWORD, fdwReason:DWORD, lpvReserved:DWORD
    .if fdwReason == DLL_PROCESS_ATTACH
        push hInstDLL
        pop hInstance
    .elseif fdwReason == DLL_PROCESS_DETACH
        invoke UninstallHook
    .endif

    return TRUE
DllMain endp

; ##########################################################################

InstallHook proc
    invoke GetDesktopLV
    mov hDesktop, eax

    ; Get current desktop colors
    invoke SendMessage, hDesktop, LVM_GETTEXTBKCOLOR, 0, 0
    mov BGColor, eax

    invoke SendMessage, hDesktop, LVM_GETTEXTCOLOR, 0, 0
    mov FGColor, eax

    ; check if they stored recent colors
    invoke RegOpenKeyEx, HKEY_CURRENT_USER, addr szSubKey, NULL, KEY_QUERY_VALUE, addr hKey
    .if !eax
        invoke RegQueryInfoKey, hKey, 0, 0, 0, 0, 0, 0, 0, 0, addr hValue, 0, 0
        invoke RegQueryValueEx, hKey, addr szFore, 0, 0, addr szBuffer, addr hValue
        .if !eax
            invoke atodw, addr szBuffer
            mov FGColor, eax
        .endif

        invoke RegQueryInfoKey, hKey, 0, 0, 0, 0, 0, 0, 0, 0, addr hValue, 0, 0
        invoke RegQueryValueEx, hKey, addr szBack, 0, 0, addr szBuffer, addr hValue
        .if !eax
            invoke atodw, addr szBuffer
            mov BGColor, eax

            invoke lstrcmp, addr szBuffer, addr szTrans
            .if !eax
                mov BGColor, HTTRANSPARENT
            .endif
        .endif
    .endif
    invoke RegCloseKey, hKey

    invoke GetWindowThreadProcessId, hDesktop, NULL
    invoke SetWindowsHookEx, WH_GETMESSAGE, HookProc, hInstance, eax
    mov hHook, eax

    invoke PostMessage, hDesktop, WM_HOOKADD, 0, 0

    invoke PostMessage, hDesktop, LVM_SETTEXTBKCOLOR, 0, BGColor
    invoke PostMessage, hDesktop, LVM_SETTEXTCOLOR, 0, FGColor
    invoke InvalidateRect, hDesktop, NULL, TRUE

    xor eax, eax
    ret
InstallHook endp

; ##########################################################################

UninstallHook proc
    invoke SendMessage, hDesktop, WM_HOOKRMV, 0, 0

    .if hHook
        invoke UnhookWindowsHookEx, hHook
        mov hHook, NULL
    .endif

    ret
UninstallHook endp

; ##########################################################################

GetDesktop proc
    invoke FindWindow, addr szProgman, addr szProgram
    ret
GetDesktop endp

; ##########################################################################

GetDesktopLV proc
    invoke GetDesktop
    invoke FindWindowEx, eax, 0, addr szShellDV, NULL
    invoke FindWindowEx, eax, 0, addr szShellLV, NULL
    ret
GetDesktopLV endp

; ##########################################################################

HookProc proc nCode:DWORD, wParam:DWORD, lParam:DWORD
    .if nCode == HC_ACTION
        mov edx, lParam
        assume edx:PTR MSG
        .if [edx].message == WM_HOOKADD
            invoke SetWindowLong, hDesktop, GWL_WNDPROC, addr DesktopProc
            mov hOldProc, eax
        .endif
        assume edx:nothing
    .endif

    invoke CallNextHookEx, hHook, nCode, wParam, lParam
    ret
HookProc endp

; ##########################################################################

DesktopProc proc hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    .if uMsg == LVM_SETTEXTBKCOLOR
        push BGColor
        pop  lParam
    .elseif uMsg == LVM_SETTEXTCOLOR
        push FGColor
        pop  lParam
    .elseif uMsg == WM_HOOKRMV
        invoke SetWindowLong, hDesktop, GWL_WNDPROC, hOldProc
    .endif

    invoke CallWindowProc, hOldProc, hWin, uMsg, wParam, lParam
    ret
DesktopProc endp

; ##########################################################################

ChangeColors proc hColor1:DWORD, hColor2:DWORD
    push hColor1
    pop  FGColor

    push hColor2
    pop  BGColor

    invoke RegCreateKey, HKEY_CURRENT_USER, addr szSubKey, addr hKey
    .if !eax
        invoke dwtoa, FGColor, addr szBuffer
        invoke lnstr, addr szBuffer
        invoke RegSetValueEx, hKey, addr szFore, 0, REG_SZ, addr szBuffer, eax

        invoke dwtoa, BGColor, addr szBuffer
        invoke lnstr, addr szBuffer
        invoke RegSetValueEx, hKey, addr szBack, 0, REG_SZ, addr szBuffer, eax
    .endif
    invoke RegCloseKey, hKey

    invoke PostMessage, hDesktop, LVM_SETTEXTBKCOLOR, 0, BGColor
    invoke PostMessage, hDesktop, LVM_SETTEXTCOLOR, 0, FGColor
    invoke InvalidateRect, hDesktop, NULL, TRUE

    ret
ChangeColors endp

; ##########################################################################

GetFGColor proc
    return FGColor
GetFGColor endp

; ##########################################################################

GetBGColor proc
    return BGColor
GetBGColor endp

; ##########################################################################

End DllMain
