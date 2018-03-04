; #########################################################################

    .386
    .model flat, stdcall
    option casemap:none

; #########################################################################

    include \masm32\include\windows.inc
    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc
    include \masm32\include\advapi32.inc
    include \masm32\include\masm32.inc
    include \masm32\include\gdi32.inc
    include \masm32\include\shell32.inc

    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\kernel32.lib
    includelib \masm32\lib\advapi32.lib
    includelib \masm32\lib\masm32.lib
    includelib \masm32\lib\gdi32.lib
    includelib \masm32\lib\shell32.lib
    includelib dcolor.lib

; #########################################################################

getrgb MACRO ref, r, g, b
    mov eax, ref
    shr eax, 16
    and eax, 0FFh
    mov b, eax

    mov eax, ref
    shr eax, 8
    and eax, 0FFh
    mov g, eax

    mov eax, ref
    and eax, 0FFh
    mov r, eax
ENDM

szText MACRO Name, Text:VARARG
    LOCAL lbl

    jmp lbl
    Name db Text,0
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

; #########################################################################

    WinMain         PROTO :DWORD,:DWORD,:DWORD,:DWORD
    DlgProc         PROTO :DWORD,:DWORD,:DWORD,:DWORD
    FGColorProc     PROTO :DWORD,:DWORD,:DWORD,:DWORD
    FormatProc      PROTO :DWORD,:DWORD,:DWORD,:DWORD
    additem         PROTO :DWORD,:DWORD,:DWORD
    LoadList        PROTO :DWORD,:DWORD
    ShowColorDialog PROTO :DWORD,:DWORD,:DWORD
    PickerProc      PROTO :DWORD,:DWORD,:DWORD,:DWORD
    ColorGridPanel  PROTO :DWORD,:DWORD
    PreviewProc     PROTO :DWORD,:DWORD,:DWORD,:DWORD
    clearbuffer     PROTO :DWORD
    GetFGColor      PROTO
    GetBGColor      PROTO
    GetDesktop      PROTO
    GetDesktopLV    PROTO
    InstallHook     PROTO
    UninstallHook   PROTO
    FormatColor     PROTO
    ChangeColors    PROTO :DWORD,:DWORD
    wsprintfA       PROTO C :DWORD,:VARARG

; #########################################################################

    WM_SHELLNOTIFY equ WM_USER + 5

    IDI_TRAY       equ 100
    IDM_CONFIG     equ 101
    IDM_STARTUP    equ 102
    IDM_DESKICON   equ 103
    IDM_HELP       equ 104
    IDM_EXIT       equ 105

    wsprintf       equ <wsprintfA>

; #########################################################################

.data
    szFormat    db 'HTML Hex,Assembly Hex,C/C++ Hex,BASIC Hex,Long Integer,', 0
    szSubKey    db 'Software\DL Software\D-Color\', 0
    szRunKey    db 'Software\Microsoft\Windows\CurrentVersion\Run', 0
    szVisible   db 'Visible', 0
    htm         db '#%.2lX%.2lX%.2lX', 0
    szHelp      db 'help\index.htm', 0
    szOpen      db 'open',0
    szh         db "h", 0
    baz         db "&H", 0
    cpp         db "0x", 0
    szLArrow    db '<<', 0
    szRArrow    db '>>', 0
    szSavFmt    db 'Format', 0
    szClassName db 'D-Color_Class', 0
    szAppName   db 'D-Color 1.0', 0
    szRegName   db 'D-Color', 0
    szTBCreated db 'TaskbarCreated', 0
    szStart     db 'The freeware solution to change the appearance of the icons on your desktop. Accomplished using 100% 32-bit Windows assembly.', 0
    szCGHelp    db 'You can select any color by holding down the left or right mouse buttons and dragging the dropper over ANY part of the screen!', 0
    szColor     db 'Transparent,Black,White,Maroon,Green,Dark Green,Brown,Orange,Olive,Navy,Purple,Teal,Gray,Silver,Red,Lime,Yellow,Blue,Light Blue,Fuchsia,Aqua,', 0
    ComboColor  dd HTTRANSPARENT,00000000h,00ffffffh,00000080h,00008000h,00004000h,00004080h,000080ffh,00008080h
                dd 00800000h,00800080h,00808000h,00808080h,00c0c0c0h,000000ffh,0000ff00h,0000ffffh
                dd 00ff0000h,00ff8000h,00ff00ffh,00ffff00h
    ComboEnd    dd 0
    hSelFormat  dd 0
    Clear       db 256 dup(' '), 0
    lSelected   BOOL FALSE
    rSelected   BOOL FALSE

.data?
    DrawItem    DRAWITEMSTRUCT <?>
    note        NOTIFYICONDATA <?>
    tm          TEXTMETRIC     <?>
    wRect       RECT           <?>
    hFGColor    dd ?
    hBGColor    dd ?
    hInstance   dd ?
    hPopupMenu  dd ?
    hWnd        dd ?
    hConfig     dd ?
    lpColor     dd ?
    lpFormat    dd ?
    hIcon       dd ?
    hPreview    dd ?
    hFormat     dd ?
    hSelFGColor dd ?
    hSelBGColor dd ?
    YP          dd ?
    Len         dd ?
    hBrush      dd ?
    hColorGrid  dd ?
    lpPreview   dd ?
    lpPicker    dd ?
    hPicker     dd ?
    TB_CREATED  dd ?
    hKey        dd ?
    hValue      dd ?
    hStartup    dd ?
    Misc        db 256  dup (?)
    szBuffer    db 1025 dup (?)
    szFileName  db 1025 dup (?)

.code
start:

; #########################################################################

    ; remove if there is another instance
    invoke FindWindow, addr szClassName, NULL
    .if eax
        invoke ExitProcess, 0
    .endif

    mov Misc[255], 0
    mov szBuffer[1024], 0
    mov szFileName[1024], 0

    invoke GetModuleHandle, NULL
    mov hInstance, eax

    invoke GetModuleFileName, hInstance, addr szFileName, 1024

    invoke WinMain, hInstance, NULL, NULL, SW_HIDE

    invoke ExitProcess, eax

; #########################################################################

WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD
    LOCAL wc   :WNDCLASSEX
    LOCAL msg  :MSG
    LOCAL Wty  :DWORD
    LOCAL Wtx  :DWORD

    mov wc.cbSize,        sizeof WNDCLASSEX
    mov wc.style,         CS_HREDRAW or CS_VREDRAW or CS_DBLCLKS
    mov wc.lpfnWndProc,   offset WndProc
    mov wc.cbClsExtra,    NULL
    mov wc.cbWndExtra,    NULL
    m2m wc.hInstance, hInst
    mov wc.hbrBackground, NULL
    mov wc.lpszMenuName,  NULL
    mov wc.lpszClassName, offset szClassName
    mov wc.hIcon,         NULL
    mov wc.hIconSm,       NULL
        invoke LoadCursor, NULL, IDC_ARROW
    mov wc.hCursor,       eax
    invoke RegisterClassEx, addr wc

    invoke GetSystemMetrics,SM_CXSCREEN
    mov Wtx, eax

    invoke GetSystemMetrics,SM_CYSCREEN
    mov Wty, eax

    invoke CreateWindowEx, NULL, addr szClassName, addr szAppName, NULL, Wtx, \
                           Wty, 0, 0, NULL, NULL, hInst, NULL
    mov hWnd, eax

StartLoop:
    invoke GetMessage, addr msg, 0, 0, 0
    cmp ax, 0
    je  EndLoop

    invoke IsDialogMessage, hConfig, addr msg
    cmp eax, 0
    jne StartLoop
    invoke TranslateMessage, addr msg

    invoke DispatchMessage, addr msg
    jmp StartLoop

EndLoop:
    ret
WinMain endp

; #########################################################################

WndProc proc hWin:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    LOCAL pt   :POINT

    .if uMsg == WM_CREATE
        ; load resource menu
        invoke LoadMenu, hInstance, 100
        invoke  GetSubMenu, eax, 0
        mov hPopupMenu, eax

        ; create shell icon
        mov note.cbSize, sizeof NOTIFYICONDATA
        m2m note.hwnd, hWin
        mov note.uID, IDI_TRAY
        mov note.uFlags, NIF_ICON + NIF_MESSAGE + NIF_TIP
        mov note.uCallbackMessage, WM_SHELLNOTIFY
            invoke LoadIcon, hInstance, 100
        mov note.hIcon, eax
        invoke lstrcpy, addr note.szTip, addr szAppName
        invoke Shell_NotifyIcon, NIM_ADD, addr note

        invoke InstallHook

        invoke RegOpenKeyEx, HKEY_CURRENT_USER, addr szSubKey, NULL, KEY_QUERY_VALUE, addr hKey
        .if !eax
            invoke RegQueryInfoKey, hKey, 0, 0, 0, 0, 0, 0, 0, 0, addr hValue, 0, 0
            invoke RegQueryValueEx, hKey, addr szVisible, 0, 0, addr szBuffer, addr hValue
            .if !eax
                invoke atodw, addr szBuffer
                .if !eax
                    invoke GetDesktop
                    invoke ShowWindow, eax, SW_HIDE
                .else
                    invoke GetDesktop
                    invoke ShowWindow, eax, SW_RESTORE
                .endif
            .endif
        .endif
        invoke RegCloseKey, hKey

        invoke GetDesktop
        invoke IsWindowVisible, eax
        .if eax
            invoke CheckMenuItem, hPopupMenu, IDM_DESKICON, MF_BYCOMMAND or MF_CHECKED
        .else
            invoke CheckMenuItem, hPopupMenu, IDM_DESKICON, MF_BYCOMMAND or MF_UNCHECKED
        .endif

        invoke RegOpenKeyEx, HKEY_CURRENT_USER, addr szRunKey, NULL, KEY_QUERY_VALUE, addr hKey
        .if !eax
            invoke RegQueryInfoKey, hKey, 0, 0, 0, 0, 0, 0, 0, 0, addr hValue, 0, 0
            invoke RegQueryValueEx, hKey, addr szRegName, 0, 0, addr szBuffer, addr hValue
            .if !eax
                mov hStartup, TRUE
                invoke CheckMenuItem, hPopupMenu, IDM_STARTUP, MF_BYCOMMAND or MF_CHECKED
            .else
                mov hStartup, FALSE
                invoke CheckMenuItem, hPopupMenu, IDM_STARTUP, MF_BYCOMMAND or MF_UNCHECKED
            .endif
        .else
            mov hStartup, TRUE
            invoke CheckMenuItem, hPopupMenu, IDM_STARTUP, MF_BYCOMMAND or MF_UNCHECKED
        .endif
        invoke RegCloseKey, hKey

        invoke RegisterWindowMessage, addr szTBCreated
        mov TB_CREATED, eax
    .elseif uMsg == WM_DESTROY
        invoke RegOpenKey, HKEY_CURRENT_USER, addr szSubKey, addr hKey
        .if eax == ERROR_SUCCESS
            invoke RegCreateKey, HKEY_CURRENT_USER, addr szSubKey, addr hKey
            .if eax == ERROR_SUCCESS
                invoke dwtoa, hSelFormat, addr szBuffer
                invoke RegSetValueEx, hKey, addr szSavFmt, 0, REG_DWORD, addr szBuffer, 4
            .endif
        .endif
        invoke RegCloseKey, hKey
        invoke UninstallHook

        invoke DestroyMenu, hPopupMenu
        invoke Shell_NotifyIcon, NIM_DELETE, addr note

        invoke DestroyWindow, hConfig

        invoke PostQuitMessage, NULL
    .elseif uMsg == WM_COMMAND
        mov eax, wParam
        .if ax == IDM_CONFIG
                .if !hConfig
                    invoke CreateDialogParam, hInstance, 100, hWin, addr DlgProc, NULL
                .else
                    invoke ShowWindow, hConfig, SW_SHOW
                .endif
                invoke SetForegroundWindow, hConfig
        .elseif ax == IDM_STARTUP
            .if hStartup
                invoke CheckMenuItem, hPopupMenu, IDM_STARTUP, MF_BYCOMMAND or MF_UNCHECKED
                mov hStartup, FALSE

                invoke RegOpenKey, HKEY_CURRENT_USER, addr szRunKey, addr hKey
                invoke RegDeleteValue, hKey, addr szRegName
                invoke RegCloseKey, hKey
            .else
                invoke CheckMenuItem, hPopupMenu, IDM_STARTUP, MF_BYCOMMAND or MF_CHECKED
                mov hStartup, TRUE

                invoke RegOpenKey, HKEY_CURRENT_USER, addr szRunKey, addr hKey
                .if eax == ERROR_SUCCESS
                    invoke RegCreateKey, HKEY_CURRENT_USER, addr szRunKey, addr hKey
                    .if eax == ERROR_SUCCESS
                        invoke lnstr, addr szFileName
                        invoke RegSetValueEx, hKey, addr szRegName, 0, REG_SZ, addr szFileName, eax
                    .endif
                .endif
                invoke RegCloseKey, hKey
            .endif
        .elseif ax == IDM_DESKICON
            invoke GetDesktop
            invoke IsWindowVisible, eax
            .if eax
                invoke GetDesktop
                invoke ShowWindow, eax, SW_HIDE
                invoke CheckMenuItem, hPopupMenu, IDM_DESKICON, MF_BYCOMMAND or MF_UNCHECKED

                invoke RegCreateKey, HKEY_CURRENT_USER, addr szSubKey, addr hKey
                .if !eax
                    invoke dwtoa, FALSE, addr szBuffer
                    invoke RegSetValueEx, hKey, addr szVisible, 0, REG_DWORD, addr szBuffer, 4
                .endif
                invoke RegCloseKey, hKey
            .else
                invoke GetDesktop
                invoke ShowWindow, eax, SW_RESTORE
                invoke CheckMenuItem, hPopupMenu, IDM_DESKICON, MF_BYCOMMAND or MF_CHECKED

                invoke RegCreateKey, HKEY_CURRENT_USER, addr szSubKey, addr hKey
                .if !eax
                    invoke dwtoa, TRUE, addr szBuffer
                    invoke RegSetValueEx, hKey, addr szVisible, 0, REG_DWORD, addr szBuffer, 4
                .endif
                invoke RegCloseKey, hKey
            .endif
        .elseif ax == IDM_HELP
            invoke GetAppPath, addr szBuffer
            invoke lstrcat, addr szBuffer, addr szHelp
            invoke ShellExecuteA, 0, addr szOpen, addr szBuffer, 0, 0, 0
        .elseif ax == IDM_EXIT
            invoke DestroyWindow, hWin
        .endif
    .elseif uMsg == WM_SHELLNOTIFY
        .if wParam == IDI_TRAY
            .if lParam == WM_RBUTTONDOWN
                invoke GetCursorPos, addr pt
                invoke SetForegroundWindow, hWin
                invoke TrackPopupMenu, hPopupMenu, TPM_RIGHTALIGN or TPM_RIGHTBUTTON, pt.x, pt.y, NULL, hWin, NULL
                invoke PostMessage, hWin, WM_NULL, 0, 0
            .elseif lParam == WM_LBUTTONDBLCLK
                .if !hConfig
                    invoke CreateDialogParam, hInstance, 100, hWin, addr DlgProc, NULL
                .else
                    invoke ShowWindow, hConfig, SW_SHOW
                .endif
                invoke SetForegroundWindow, hConfig
            .endif
        .endif
        invoke Shell_NotifyIcon, NIM_ADD, addr note
    .else
        mov eax, TB_CREATED
        .if uMsg == eax
            invoke Shell_NotifyIcon, NIM_ADD, addr note
            invoke UninstallHook
            invoke InstallHook
        .else
            invoke DefWindowProc, hWin, uMsg, wParam, lParam        
            ret
        .endif
    .endif

    xor eax, eax
    ret
WndProc endp

; #########################################################################

DlgProc proc uses ebx hDlg:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    .if uMsg == WM_INITDIALOG
        mov eax, hDlg
        mov hConfig, eax

        invoke GetFGColor
        mov hSelFGColor, eax

        invoke GetBGColor
        mov hSelBGColor, eax

        invoke GetDlgItem, hDlg, 103
        mov hPreview, eax

        invoke GetDlgItem, hDlg, 107
        mov hFGColor, eax

        invoke GetDlgItem, hDlg, 110
        mov hBGColor, eax

        invoke GetDlgItem, hDlg, 112
        mov hFormat, eax

        invoke SetWindowLong, hPreview, GWL_WNDPROC, addr PreviewProc
        mov lpPreview, eax

        invoke SetWindowLong, hFGColor, GWL_WNDPROC, addr FGColorProc
        mov lpColor, eax

        invoke SetWindowLong, hBGColor, GWL_WNDPROC, addr FGColorProc
        mov lpColor, eax

        invoke SetWindowLong, hFormat, GWL_WNDPROC, addr FormatProc
        mov lpFormat, eax

        invoke LoadList, hFGColor, offset szColor
        invoke LoadList, hBGColor, offset szColor
        invoke LoadList, hFormat, offset szFormat

        invoke SendMessage, hFGColor, CB_SETCURSEL, 0, 0
        invoke SendMessage, hBGColor, CB_SETCURSEL, 0, 0
        invoke SendMessage, hFormat, CB_SETCURSEL, 0, 0
    
        invoke SendMessage, hDlg, WM_COMMAND, 0, hFGColor
        invoke SendMessage, hDlg, WM_COMMAND, 0, hBGColor

        invoke SendMessage, hFGColor, CB_SETITEMHEIGHT, -1, 14
        invoke SendMessage, hFGColor, CB_SETITEMHEIGHT, 0, 13

        invoke SendMessage, hBGColor, CB_SETITEMHEIGHT, -1, 14
        invoke SendMessage, hBGColor, CB_SETITEMHEIGHT, 0, 13

        invoke SendMessage, hFormat, CB_SETITEMHEIGHT, -1, 14
        invoke SendMessage, hFormat, CB_SETITEMHEIGHT, 0, 13

        invoke GetDlgItem, hDlg, 116
        mov hColorGrid, eax
        invoke ShowWindow, hColorGrid, SW_HIDE

        invoke SetWindowLong, hColorGrid, GWL_WNDPROC, addr PickerProc
        mov lpPicker, eax

        invoke GetDlgItem, hDlg, 117
        mov hPicker, eax

        invoke SetWindowLong, eax, GWL_WNDPROC, addr PickerProc
        mov lpPicker, eax

        invoke LoadImage, hInstance, 100, IMAGE_ICON, 44, 38, LR_DEFAULTSIZE
        mov hIcon, eax

        invoke GetDlgItem, hDlg, 101
        invoke SendMessage, eax, STM_SETICON, hIcon, 0

        invoke GetDlgItem, hDlg, 104
        invoke SetWindowText, eax, addr szStart

        invoke LoadImage, hInstance, 100, IMAGE_BITMAP, 208, 68, LR_DEFAULTCOLOR
        mov hIcon, eax

        invoke SendMessage, hColorGrid, STM_SETIMAGE, IMAGE_BITMAP, hIcon

        invoke LoadImage, hInstance, 200, IMAGE_ICON, 16, 16, LR_DEFAULTSIZE
        mov hIcon, eax

        invoke GetDlgItem, hDlg, 117
        invoke SendMessage, eax, STM_SETICON, hIcon, 0

        invoke RegOpenKeyEx, HKEY_CURRENT_USER, addr szSubKey, NULL, KEY_QUERY_VALUE, addr hKey
        .if !eax
            invoke RegQueryInfoKey, hKey, 0, 0, 0, 0, 0, 0, 0, 0, addr hValue, 0, 0
            invoke RegQueryValueEx, hKey, addr szSavFmt, 0, 0, addr szBuffer, addr hValue
            .if !eax
                invoke atodw, addr szBuffer
                invoke SendMessage, hFormat, CB_SETCURSEL, eax, 0
            .endif
        .endif
        invoke RegCloseKey, hKey

        invoke FormatColor

        xor eax,eax
        ret
    .elseif uMsg == WM_COMMAND
        .if wParam == 108
            invoke IsWindowVisible, hColorGrid
            .if eax
                invoke ColorGridPanel, hDlg, SW_SHOW
            .else
                invoke ColorGridPanel, hDlg, SW_HIDE
            .endif
        .elseif wParam == 113
            invoke ChangeColors, hSelFGColor, hSelBGColor
            invoke SendMessage, hDlg, WM_CLOSE, 0, 0
        .elseif wParam == 114
            invoke SendMessage, hDlg, WM_CLOSE, 0, 0
        .elseif wParam == 115
            invoke ChangeColors, hSelFGColor, hSelBGColor
        .endif
    .elseif uMsg == WM_CTLCOLORSTATIC
        mov eax, hPreview
        .if eax == lParam
            invoke SetBkMode, wParam, OPAQUE
            invoke SetBkMode, wParam, TRANSPARENT
            invoke SetBkColor, wParam, hSelBGColor
            invoke SetTextColor, wParam, hSelFGColor
            .if hSelBGColor == HTTRANSPARENT
                invoke GetSysColorBrush, COLOR_BTNFACE
            .else
                invoke CreateSolidBrush, hSelBGColor
            .endif
            ret
        .endif
    .elseif uMsg == WM_CLOSE
        invoke ShowWindow, hConfig, SW_HIDE
    .elseif uMsg == WM_DESTROY
        invoke EndDialog, hDlg, 0
    .endif

    xor eax, eax
    ret
DlgProc endp

; #########################################################################

FGColorProc proc uses ebx esi edi ecx hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    .if uMsg == WM_COMMAND
        HIWORD wParam
        .if ebx == CBN_SELCHANGE
            invoke SendMessage, hWin, CB_GETCURSEL, 0, 0
            m2m ebx, eax

            mov eax, hFGColor
            .if eax == hWin
                add ebx, 1
                m2m hSelFGColor, ComboColor[ebx*4]
            .else
                m2m hSelBGColor, ComboColor[ebx*4]
            .endif
        .endif
        invoke FormatColor
        invoke InvalidateRect,hPreview,NULL,TRUE             ;Redraw the static
    .elseif uMsg == WM_DRAWITEM
        mov     esi, lParam
        mov     edi, offset DrawItem
        mov     ecx, sizeof DrawItem
        rep     movsb
        .if DrawItem.itemID != -1
            invoke SendMessage, hWin, CB_GETLBTEXT, DrawItem.itemID, addr Misc
            mov     Len, eax
            invoke GetTextMetrics, DrawItem.hdc, addr tm
            mov     eax, DrawItem.rcItem.bottom
            add     eax, DrawItem.rcItem.top
            sub     eax, tm.tmHeight
            shr     eax, 1
            mov     YP, eax

            .if DrawItem.itemState & ODS_SELECTED
                invoke   GetSysColorBrush, COLOR_HIGHLIGHT
                mov     hBrush, eax
                invoke FillRect, DrawItem.hdc, addr DrawItem.rcItem, eax
                invoke   GetSysColor, COLOR_HIGHLIGHTTEXT
                invoke SetTextColor, DrawItem.hdc, eax
                invoke   GetSysColor, COLOR_HIGHLIGHT
                invoke SetBkColor, DrawItem.hdc, eax
            .else
                invoke   GetSysColorBrush, COLOR_WINDOW
                mov     hBrush, eax
                invoke FillRect, DrawItem.hdc, addr DrawItem.rcItem, eax
                invoke   GetSysColor, COLOR_BTNTEXT
                invoke SetTextColor, DrawItem.hdc, eax;DrawItem.itemData
                invoke   GetSysColor, COLOR_WINDOW
                invoke SetBkColor, DrawItem.hdc, eax
            .endif

            add     DrawItem.rcItem.left, 20
            invoke TextOut, DrawItem.hdc, DrawItem.rcItem.left, YP, addr Misc, Len
            mov     DrawItem.rcItem.left, 2
            mov     DrawItem.rcItem.right, 16
            add     DrawItem.rcItem.top, 2
            sub     DrawItem.rcItem.bottom, 2
            invoke DeleteObject, hBrush
            invoke CreateSolidBrush, 00000000h
            mov     hBrush, eax
            invoke FrameRect, DrawItem.hdc, addr DrawItem.rcItem, eax
            inc     DrawItem.rcItem.left
            inc     DrawItem.rcItem.top
            dec     DrawItem.rcItem.right
            dec     DrawItem.rcItem.bottom
            mov     ebx, DrawItem.itemID 

            mov eax, hFGColor
            .if eax == hWin
                add ebx, 1
            .endif
            mov eax, hBGColor

            .if eax == hWin && DrawItem.itemID == 0
                add ebx, 2
            .endif

            invoke SetBkColor, DrawItem.hdc, dword ptr ComboColor[ebx*4]
            invoke DrawText, DrawItem.hdc, addr Clear, 6, addr DrawItem.rcItem, DT_LEFT or DT_SINGLELINE
            invoke DeleteObject, hBrush
        .endif

        mov     DrawItem.itemState, ODS_DEFAULT
        mov     DrawItem.hdc, 0
    .endif

    invoke CallWindowProc, lpColor, hWin, uMsg, wParam, lParam
    ret
FGColorProc endp

; #########################################################################

FormatProc proc uses ebx esi edi ecx hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    .if uMsg == WM_COMMAND
        HIWORD wParam
        .if ebx == CBN_SELCHANGE
            invoke FormatColor
        .endif
    .endif

    invoke CallWindowProc, lpFormat, hWin, uMsg, wParam, lParam
    ret
FormatProc endp

; #########################################################################

PickerProc proc hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    LOCAL pt :POINT

    .if uMsg == WM_LBUTTONDOWN
        mov lSelected, TRUE
        invoke ShowWindow, hPicker, SW_HIDE
        invoke LoadCursor, hInstance, 100
        invoke SetCursor, eax
        invoke SetCapture, hWin
        xor eax,eax
        ret
    .elseif uMsg == WM_LBUTTONUP
        mov lSelected, FALSE
        invoke ShowWindow, hPicker, SW_SHOW
        invoke SetCursor, NULL
        invoke ReleaseCapture
        xor eax,eax
        ret
    .elseif uMsg == WM_RBUTTONDOWN
        mov rSelected, TRUE
        invoke ShowWindow, hPicker, SW_HIDE
        invoke LoadCursor, hInstance, 100
        invoke SetCursor, eax
        invoke SetCapture, hWin
        xor eax,eax
        ret
    .elseif uMsg == WM_RBUTTONUP
        mov rSelected, FALSE
        invoke ShowWindow, hPicker, SW_SHOW
        invoke SetCursor, NULL
        invoke ReleaseCapture
        xor eax,eax
        ret
    .elseif uMsg == WM_MOUSEMOVE
        .if lSelected == TRUE || rSelected == TRUE
            invoke GetCursorPos, addr pt
            invoke GetWindowDC, NULL
            invoke GetPixel, eax, pt.x, pt.y
            .if lSelected
                mov hSelFGColor, eax
            .else
                mov hSelBGColor, eax
            .endif
            invoke InvalidateRect,hPreview,NULL,TRUE

            invoke FormatColor

            xor eax, eax
            ret
        .endif
    .endif

    invoke CallWindowProc, lpPicker, hWin, uMsg, wParam, lParam
    ret
PickerProc endp

; #########################################################################

PreviewProc proc hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    LOCAL tmp :DWORD

    .if uMsg == WM_LBUTTONUP
        m2m tmp, hSelFGColor
        m2m hSelFGColor, hSelBGColor
        m2m hSelBGColor, tmp
        invoke InvalidateRect, hWin, NULL, TRUE

        xor eax,eax
        ret
    .endif

    invoke CallWindowProc, lpPreview, hWin, uMsg, wParam, lParam
    ret
PreviewProc endp

; #########################################################################

LoadList PROC uses esi hList:DWORD, Input:DWORD
    LOCAL cnt :DWORD

    mov esi, Input
    xor eax, eax
    mov cnt, 0
Getlen:
    .if byte ptr[esi+eax] == 2ch
        mov Len, eax
        add Len, 1 
        add cnt, 1
        .if cnt > 0 ;20
            mov eax, hList
            .if eax != hFGColor || cnt != 1
                invoke lstrcpyn, offset Misc, esi, Len
                invoke SendMessage, hList, CB_ADDSTRING, 0, offset Misc
            .endif
        .endif
        add esi, Len
        xor eax, eax
        jmp Getlen
    .elseif byte ptr[esi+eax] == 0h
        invoke SendMessage, hList, CB_SETTOPINDEX, 0, 0
        jmp @1
    .endif
    inc eax
    jmp Getlen
    @1:

    xor eax, eax
    ret
LoadList ENDP

; #########################################################################

ColorGridPanel proc hDlg:DWORD, visible:DWORD
    invoke GetDlgItem, hDlg, 106
    invoke ShowWindow, eax, visible

    invoke GetDlgItem, hDlg, 107
    invoke ShowWindow, eax, visible

    invoke GetDlgItem, hDlg, 109
    invoke ShowWindow, eax, visible

    invoke GetDlgItem, hDlg, 110
    invoke ShowWindow, eax, visible

    invoke GetDlgItem, hDlg, 111
    invoke ShowWindow, eax, visible

    invoke GetDlgItem, hDlg, 112
    invoke ShowWindow, eax, visible

    .if visible == SW_HIDE
        mov eax, SW_SHOW
    .else
        mov eax, SW_HIDE
    .endif

    invoke ShowWindow, hColorGrid, eax

    invoke GetDlgItem, hDlg, 104
    .if visible == SW_HIDE
        invoke SetWindowText, eax, addr szCGHelp
    .else
        invoke SetWindowText, eax, addr szStart
    .endif

    invoke GetDlgItem, hDlg, 108
    .if visible == SW_HIDE
        invoke SetWindowText, eax, addr szLArrow
    .else
        invoke SetWindowText, eax, addr szRArrow
    .endif

    xor eax, eax
    ret
ColorGridPanel endp

; #########################################################################

clearbuffer proc lpbuffer:DWORD

    mov ecx, 32
    mov eax, 0
    mov edi, lpbuffer
    rep stosb

    xor eax, eax
    ret
clearbuffer endp

; #########################################################################

FormatColor proc
    LOCAL b2[128] :BYTE
    LOCAL b1[128] :BYTE
    LOCAL r       :DWORD
    LOCAL g       :DWORD
    LOCAL b       :DWORD
    LOCAL cnt

    invoke SendMessage, hFormat, CB_GETCURSEL, 0, 0
    mov hSelFormat, eax

    invoke clearbuffer, addr b1
    invoke clearbuffer, addr b2

    .if hSelFormat == 0 || hSelFormat == 1 || hSelFormat == 2 || hSelFormat == 3
        invoke dw2hex, hSelBGColor, addr b2
        .if hSelFormat == 0
            getrgb hSelBGColor, r,g,b
            invoke wsprintf, addr b1, addr htm, r, g, b
        .elseif hSelFormat == 1
            invoke lstrcat, addr b1, addr b2
            invoke lstrcat, addr b1, addr szh
        .elseif hSelFormat == 2
            invoke lstrcat, addr b1, addr cpp
            invoke lstrcat, addr b1, addr b2
        .else
            invoke lstrcat, addr b1, addr baz
            invoke lstrcat, addr b1, addr b2
        .endif
        invoke SetWindowText, hBGColor, addr b1
    .elseif hSelFormat == 4
        invoke dwtoa, hSelBGColor, addr b2
        invoke SetWindowText, hBGColor, addr b2
    .endif

    invoke clearbuffer, addr b1
    invoke clearbuffer, addr b2

    .if hSelFormat == 0 || hSelFormat == 1 || hSelFormat == 2 || hSelFormat == 3
        invoke dw2hex, hSelFGColor, addr b2
        .if hSelFormat == 0
            getrgb hSelFGColor, r,g,b
            invoke wsprintf, addr b1, addr htm, r, g, b
        .elseif hSelFormat == 1
            invoke lstrcat, addr b1, addr b2
            invoke lstrcat, addr b1, addr szh
        .elseif hSelFormat == 2
            invoke lstrcat, addr b1, addr cpp
            invoke lstrcat, addr b1, addr b2
        .else
            invoke lstrcat, addr b1, addr baz
            invoke lstrcat, addr b1, addr b2
        .endif
        invoke SetWindowText, hFGColor, addr b1
    .elseif hSelFormat == 4
        invoke dwtoa, hSelFGColor, addr b2
        invoke SetWindowText, hFGColor, addr b2
    .endif

    xor eax, eax
    ret
FormatColor endp

; #########################################################################

end start
