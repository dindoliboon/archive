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

; ##########################################################################

    SetTextBkColor     proto
    CallWndProc        proto :DWORD,:DWORD,:DWORD
    PassHook           proto :DWORD,:DWORD,:DWORD,:DWORD
    DesktopProc        proto :DWORD,:DWORD,:DWORD,:DWORD
    GetDesktopListView proto

.data
    szProgman  db "progman", 0
    szProgram  db "program manager",0
    szShellDV  db "shelldll_defview", 0
    szShellLV  db "syslistview32", 0

.data?
    hHook     dd ?
    hInstance dd ?
    hDesktop  dd ?
    hSubclass dd ?

.code

; ##########################################################################

LibMain proc hInstDLL:DWORD, reason:DWORD, unused:DWORD
    push hInstDLL
    pop  hInstance

    .if reason == DLL_PROCESS_ATTACH
        invoke DisableThreadLibraryCalls, hInstDLL
    .elseif reason == DLL_PROCESS_DETACH
        .if hSubclass
            invoke SetWindowLong, hDesktop, GWL_WNDPROC, hSubclass
        .endif

        .if hHook
            invoke UnhookWindowsHookEx, hHook
        .endif
    .endif

    return TRUE
LibMain Endp

; ##########################################################################

SetTextBkColor proc
    invoke GetCurrentProcess
    invoke SetPriorityClass, eax, IDLE_PRIORITY_CLASS

    invoke GetCurrentThread
    invoke SetThreadPriority, eax, THREAD_PRIORITY_IDLE

    invoke GetDesktopListView
    invoke GetWindowThreadProcessId, eax, NULL
    invoke SetWindowsHookEx, WH_CALLWNDPROC, addr CallWndProc, hInstance, eax
    mov hHook, eax

    invoke GetDesktopListView
    invoke SendMessage, eax, LVM_SETTEXTBKCOLOR, 0, HTTRANSPARENT

    invoke GetDesktopListView
    invoke InvalidateRect, eax, NULL, TRUE
    
    ret
SetTextBkColor endp

; ##########################################################################

CallWndProc proc nCode:DWORD, wParam:DWORD, lParam:DWORD
    mov edx, lParam

    assume edx:PTR CWPSTRUCT
    mov eax, [edx].message
    invoke PassHook, [edx].hwnd, [edx].message, [edx].wParam, [edx].lParam
    assume edx:nothing

    invoke CallNextHookEx, hHook, nCode, wParam, lParam
    ret
CallWndProc endp

; ##########################################################################

PassHook proc hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    invoke GetDesktopListView
    mov hDesktop, eax

    .if eax == hWin
        .if hSubclass == NULL
            invoke SetWindowLong, hDesktop, GWL_WNDPROC, addr DesktopProc
            mov hSubclass, eax
        .endif
    .endif

    return TRUE
PassHook endp

; ##########################################################################

DesktopProc proc hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    .if uMsg == LVM_SETTEXTBKCOLOR
        mov lParam, HTTRANSPARENT
    .endif

    invoke CallWindowProc, hSubclass, hWin, uMsg, wParam, lParam
    ret
DesktopProc endp

; ##########################################################################

GetDesktopListView proc
    invoke FindWindow, addr szProgman, addr szProgram
    invoke FindWindowEx, eax, 0, addr szShellDV, NULL
    invoke FindWindowEx, eax, 0, addr szShellLV, NULL
    ret
GetDesktopListView endp

; ##########################################################################

End LibMain
