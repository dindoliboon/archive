; #########################################################################

    .386
    .model flat, stdcall
    option casemap :none

; #########################################################################

    include \masm32\include\windows.inc
    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc

    includelib dcolor.lib
    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\kernel32.lib

; #########################################################################

    m2m MACRO M1, M2
        push M2
        pop  M1
    ENDM

    return MACRO arg
        mov eax, arg
        ret
    ENDM

; #########################################################################

    WinMain        PROTO :DWORD,:DWORD,:DWORD,:DWORD
    WndProc        PROTO :DWORD,:DWORD,:DWORD,:DWORD
    SetTextBkColor PROTO

; #########################################################################

.data
    szDisplayName db "tacr 2.1a loader", 0
    hWnd          dd 0
    hInstance     dd 0

; #########################################################################

.code

start:
    ; remove if there is another instance
    invoke FindWindow, addr szDisplayName, addr szDisplayName
    .if eax
        invoke SendMessage, eax, WM_DESTROY, 0, 0
        invoke ExitProcess, 0
    .endif

    invoke GetModuleHandle, NULL
    mov hInstance, eax

    invoke GetCurrentProcess
    invoke SetPriorityClass, eax, IDLE_PRIORITY_CLASS

    invoke GetCurrentThread
    invoke SetThreadPriority, eax, THREAD_PRIORITY_IDLE

    invoke WinMain, hInstance, NULL, NULL, SW_HIDE
    
    invoke ExitProcess, eax

; #########################################################################

WinMain proc hInst     :DWORD,
             hPrevInst :DWORD,
             CmdLine   :DWORD,
             CmdShow   :DWORD

    LOCAL wc   :WNDCLASSEX
    LOCAL msg  :MSG
    
    mov wc.cbSize,        sizeof WNDCLASSEX
    mov wc.style,         NULL
    mov wc.lpfnWndProc,   offset WndProc
    mov wc.cbClsExtra,    NULL
    mov wc.cbWndExtra,    NULL
    m2m wc.hInstance,     hInst
    mov wc.hbrBackground, NULL
    mov wc.lpszMenuName,  NULL
    mov wc.lpszClassName, offset szDisplayName
    mov wc.hIcon,         NULL
    mov wc.hCursor,       NULL
    mov wc.hIconSm,       0
    invoke RegisterClassEx, addr wc
    
    invoke CreateWindowEx, WS_EX_OVERLAPPEDWINDOW, addr szDisplayName, 
        addr szDisplayName, WS_OVERLAPPEDWINDOW, 0, 0, 0, 0, NULL, 
        NULL, hInst, NULL
    
    mov hWnd, eax

    StartLoop:
        invoke GetMessage, addr msg, NULL, 0, 0
        cmp eax, 0
        je ExitLoop
        invoke TranslateMessage, addr msg
        invoke DispatchMessage, addr msg
        jmp StartLoop
    ExitLoop:
    
    return msg.wParam
WinMain endp

; #########################################################################

WndProc proc hWin   :DWORD,
             uMsg   :DWORD,
             wParam :DWORD,
             lParam :DWORD

    .if uMsg == WM_CREATE
        invoke SetTextBkColor 
    .elseif uMsg == WM_DESTROY
        invoke PostQuitMessage, NULL
        return 0 
    .endif

    invoke DefWindowProc, hWin, uMsg, wParam, lParam

    ret
WndProc endp

; ########################################################################

end start
