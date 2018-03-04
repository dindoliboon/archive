; #########################################################################

    .386
    .model flat, stdcall
    option casemap :none    ; case sensitive

; #########################################################################

    include \masm32\include\windows.inc
    include \masm32\include\gdi32.inc
    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc
    include \masm32\include\masm32.inc
    include aplib.inc

    includelib \masm32\lib\gdi32.lib
    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\kernel32.lib
    includelib \masm32\lib\masm32.lib
    includelib aplib.lib

; #########################################################################

    ;=============
    ; Local macros
    ;=============
    return MACRO arg
        mov eax, arg
        ret
    ENDM

    ;=================
    ; Local prototypes
    ;=================
    WndProc          PROTO :DWORD,:DWORD,:DWORD,:DWORD
    TopXY            PROTO :DWORD,:DWORD
    EditProc         PROTO :DWORD,:DWORD,:DWORD,:DWORD

; #########################################################################

    .const
        MAXSIZE     equ 260

    .data
        szHelp      db 'use up/down arrow keys to navigate', 0

    .data?
        readcompAllocMem HANDLE ?
        readAllocMem     DWORD  ?
        decompMem        HANDLE ?
        decompAllocMem   DWORD  ?
        szFileName       db MAXSIZE dup (?)
        szAppPath        db MAXSIZE dup (?)
        hInstance        dd ?
        txtEdit          dd ?
        hWnd             dd ?
        lpEditProc       dd ?
        tmp              dd ?
        hFile            dd ?
        iDocSize         dd ?
        uDocSize         dd ?
        iFileSize        dd ?

    .code

start:

    ;=====================
    ; Get program instance
    ;=====================
    invoke GetModuleHandle, NULL
    mov hInstance, eax

    ;=========================
    ; Run and exit our program
    ;=========================
    invoke DialogBoxParam, hInstance, 100, 0, addr WndProc, 0
    invoke ExitProcess, 0

; #########################################################################

WndProc proc hDlg  :DWORD,
             uMsg  :DWORD,
             wParam :DWORD,
             lParam :DWORD

    LOCAL Wwd  :DWORD
    LOCAL Wht  :DWORD
    LOCAL Wtx  :DWORD
    LOCAL Wty  :DWORD

    .if uMsg == WM_INITDIALOG
        mov eax, hDlg
        mov hWnd, eax

        invoke GetDlgItem, hDlg, 101
        mov txtEdit, eax

        invoke SetWindowLong, txtEdit, GWL_WNDPROC, EditProc
        mov lpEditProc, eax

        invoke GetStockObject, ANSI_FIXED_FONT
        invoke SendMessage, txtEdit, WM_SETFONT, eax, 0

        invoke LoadCursor, NULL, IDC_ARROW
        invoke SetClassLong, txtEdit, GCL_HCURSOR, eax

        ;================================
        ; Center window at following size
        ;================================
        mov Wwd, 648
        mov Wht, 370

        invoke GetSystemMetrics, SM_CXSCREEN
        invoke TopXY, Wwd, eax
        mov Wtx, eax

        invoke GetSystemMetrics, SM_CYSCREEN
        invoke TopXY, Wht, eax
        mov Wty, eax

        invoke MoveWindow, hDlg, Wtx, Wty, Wwd, Wht, TRUE

        ;================
        ; Get name of EXE
        ;================
        invoke GetModuleFileName, NULL, addr szFileName, MAXSIZE
        invoke GetAppPath, addr szAppPath

        invoke lstrlen, addr szFileName
        mov iDocSize, eax

        invoke lstrlen, addr szAppPath
        sub iDocSize, eax

        invoke szRight, addr szFileName, addr szAppPath, iDocSize
        sub iDocSize, 3
        invoke lstrcpyn, addr szFileName, addr szAppPath, iDocSize
        invoke SetWindowText, hWnd, addr szFileName

        invoke LoadIcon, NULL, IDI_APPLICATION
        invoke SendMessage, hDlg, WM_SETICON, TRUE, eax

        ;================
        ; Obtain exe size
        ;================
        invoke GetModuleFileName, NULL, addr szAppPath, MAXSIZE
        invoke filesize, addr szAppPath
        mov iFileSize, eax

        ;======================
        ; Open file for reading
        ;======================
        invoke _lopen, addr szAppPath, OF_READ
        mov hFile, eax

        ;======================
        ; Get uncompressed size
        ;======================
        mov eax, iFileSize
        sub eax, 8
        invoke _llseek, hFile, eax, FILE_CURRENT
        invoke _lread, hFile, addr iDocSize, sizeof iDocSize

        ;====================
        ; Get compressed size
        ;====================
        invoke _lread, hFile, addr uDocSize, sizeof uDocSize
        invoke _lclose, hFile

        ;===============
        ; Open exe again
        ;===============
        invoke _lopen, addr szAppPath, OF_READ
        mov hFile, eax

        ;================================
        ; Obtain compressed text location
        ;    (iFileSize) - (8 + iDocSize)
        ;================================
        mov eax, iFileSize
        sub eax, iDocSize
        sub eax, 8
        invoke _llseek, hFile, eax, FILE_CURRENT

        ;============================
        ; Allocate memory for reading
        ;============================
        invoke GlobalAlloc, GMEM_MOVEABLE or GMEM_ZEROINIT, iDocSize
        mov readcompAllocMem, eax

        invoke GlobalLock, readcompAllocMem
        mov readAllocMem, eax

        ;=====================
        ; Read compressed text
        ;=====================
        invoke _lread, hFile, readAllocMem, iDocSize

        ;==================================
        ; Allocate memory for decompression
        ;==================================
        invoke GlobalAlloc, GMEM_MOVEABLE or GMEM_ZEROINIT, uDocSize
        mov decompMem, eax

        invoke GlobalLock, decompMem
        mov decompAllocMem, eax

        ;========================================
        ; Decompress text and update edit control
        ;========================================
        invoke aP_depack_asm_fast, readAllocMem, decompAllocMem
        invoke SendMessage, txtEdit, WM_SETTEXT, 0, decompAllocMem

        ;=====================
        ; Free file and memory
        ;=====================
        invoke _lclose, hFile
        invoke GlobalUnlock, decompAllocMem
        invoke GlobalFree, decompMem
        invoke GlobalUnlock, readAllocMem
        invoke GlobalFree, readcompAllocMem

        ;=========================
        ; Make edit active control
        ;=========================
        invoke SetFocus, txtEdit
        return 0
    .elseif uMsg == WM_CTLCOLORSTATIC
        ;==================================
        ; Paint edit box with system colors
        ;==================================
        invoke SetBkMode, wParam, OPAQUE
            invoke GetSysColor, COLOR_WINDOW
        invoke SetBkColor, wParam, eax
            invoke GetSysColor, COLOR_WINDOWTEXT
        invoke SetTextColor, wParam, eax
        invoke GetSysColorBrush, COLOR_WINDOW
        ret
    .elseif uMsg == WM_KEYDOWN
        .if wParam == VK_F1
            ; prevents flicker
            .if tmp != TRUE
                invoke SetWindowText, hDlg, addr szHelp
                mov tmp, TRUE
            .endif
        .endif
    .elseif uMsg == WM_KEYUP
        .if wParam == VK_F1
            mov tmp, FALSE
            invoke SetWindowText, hDlg, addr szFileName
        .endif
    .elseif uMsg == WM_CLOSE
        invoke EndDialog, hDlg, 0
        ret
    .endif

    xor eax, eax
    ret
WndProc endp

; #########################################################################

TopXY proc wDim:DWORD, sDim:DWORD

    shr sDim, 1      ; divide screen dimension by 2
    shr wDim, 1      ; divide window dimension by 2
    mov eax, wDim    ; copy window dimension into eax
    sub sDim, eax    ; sub half win dimension from half screen dimension
    return sDim

TopXY endp

; #########################################################################

EditProc proc hWin   :DWORD,
              uMsg   :DWORD,
              wParam :DWORD,
              lParam :DWORD

    .if uMsg == WM_RBUTTONDOWN
        return 0

    .elseif uMsg == WM_SETFOCUS
        return 0

    .elseif uMsg == WM_CHAR
        return 0

    .elseif uMsg == WM_GETTEXT
        return 0

    .elseif uMsg == EM_GETLINE
        return 0

    .elseif uMsg == EM_GETSEL
        return 0

    .elseif uMsg == WM_GETTEXTLENGTH
        return 0

    .elseif uMsg == WM_KEYUP
        .if wParam == VK_UP
        .elseif wParam == VK_DOWN
        .elseif wParam == VK_PRIOR
        .elseif wParam == VK_NEXT
        .else
            invoke SendMessage, hWnd, WM_KEYUP, VK_F1, 0
        .endif

    .elseif uMsg == WM_KEYDOWN
        .if wParam == VK_UP
            invoke SendMessage, txtEdit, WM_KEYDOWN, VK_PRIOR, 0
        .elseif wParam == VK_DOWN
            invoke SendMessage, txtEdit, WM_KEYDOWN, VK_NEXT, 0
        .elseif wParam == VK_PRIOR
        .elseif wParam == VK_NEXT
        .else
            invoke SendMessage, hWnd, WM_KEYDOWN, VK_F1, 0
            return 0
        .endif
    .endif

    invoke CallWindowProc, lpEditProc, hWin, uMsg, wParam, lParam
    ret

EditProc endp

; #########################################################################

end start
