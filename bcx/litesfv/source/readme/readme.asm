; //////////////////////////////////////////////////////////////////////////
; > readme.asm 1.01 10:16 PM 8/15/2001                      Read Me Dialog <
; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;
; Read me dialog with richedit 2.0+ control.
;
; History
;    1.0  -> 12:38 PM  8/15/2001
;    1.01 -> 10:14 PM  8/15/2001
;
; Copyright (c) 2001 DL
; All Rights Reserved.
;
; //////////////////////////////////////////////////////////////////////////

  .386
  .model flat, stdcall
  option casemap :none ; case sensitive

; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

  include \masm32\include\windows.inc
  include \masm32\include\gdi32.inc
  include \masm32\include\user32.inc
  include \masm32\include\kernel32.inc

  includelib \masm32\lib\gdi32.lib
  includelib \masm32\lib\user32.lib
  includelib \masm32\lib\kernel32.lib

  include rtfdata.asm

; //////////////////////////////////////////////////////////////////////////
;                                LOCAL MACROS
; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

  m2m MACRO M1, M2
    push M2
    pop  M1
  ENDM

  return MACRO arg
    mov eax, arg
    ret
  ENDM

; //////////////////////////////////////////////////////////////////////////
;                              LOCAL PROTOTYPES
; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

  RichMain PROTO :DWORD
  WndProc  PROTO :DWORD,:DWORD,:DWORD,:DWORD
  TopXY    PROTO :DWORD,:DWORD
  EditProc PROTO :DWORD,:DWORD,:DWORD,:DWORD

; //////////////////////////////////////////////////////////////////////////
;                                DATA SECTION
; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

  .data
    szTitle   db 'About LiteSFV', 0
    szEdit    db 'richedit20a',0
    szRichDll db 'riched20.dll',0
    hInstance dd 0
    txtEdit   dd 0
    hWnd      dd 0
    hDll      dd 0
    lpEdit    dd 0

; //////////////////////////////////////////////////////////////////////////
;                                CODE SECTION
; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    .code

start:

; --------------------------------------------------------------------------
; DESCRIPTION: Calls resume scanning
;       INPUT: hInst:DWORD
;      OUTPUT: Integer returned by msg.wParam
;       USAGE: invoke StartScan()
;     RETURNS: 0
; --------------------------------------------------------------------------
RichMain proc public hInst:DWORD
  ;====================
  ; Put LOCALs on stack
  ;====================
  LOCAL wc  :WNDCLASSEX
  LOCAL msg :MSG
  LOCAL Wwd :DWORD
  LOCAL Wht :DWORD
  LOCAL Wtx :DWORD
  LOCAL Wty :DWORD

  ;==================================================
  ; Fill WNDCLASSEX structure with required variables
  ;==================================================
  mov wc.cbSize,         sizeof WNDCLASSEX
  mov wc.style,          CS_HREDRAW or CS_VREDRAW or CS_BYTEALIGNWINDOW
  mov wc.lpfnWndProc,    offset WndProc
  mov wc.cbClsExtra,     NULL
  mov wc.cbWndExtra,     NULL
  m2m wc.hInstance,      hInst   ;<< NOTE: macro not mnemonic
  mov wc.hbrBackground,  NULL
  mov wc.lpszMenuName,   NULL
  mov wc.lpszClassName,  offset szTitle
  invoke LoadIcon, hInst, 100    ; icon ID
  mov wc.hIcon,          eax
  invoke LoadCursor, NULL, IDC_ARROW
  mov wc.hCursor,        eax
  mov wc.hIconSm,        0
  invoke RegisterClassEx, addr wc

  ;================================
  ; Center window at following size
  ;================================
  mov Wwd, 500
  mov Wht, 330

  invoke GetSystemMetrics, SM_CXSCREEN
  invoke TopXY, Wwd, eax
  mov Wtx, eax

  invoke GetSystemMetrics, SM_CYSCREEN
  invoke TopXY, Wht, eax
  mov Wty, eax

  invoke LoadLibrary, addr szRichDll
  mov hDll, eax

  ;=======================
  ; Create our main window
  ;=======================
  invoke CreateWindowEx, WS_OVERLAPPED, addr szTitle, addr szTitle, \
    WS_CAPTION or WS_SYSMENU or WS_OVERLAPPEDWINDOW, Wtx, Wty, Wwd, \
    Wht, NULL, NULL, hInst, NULL
  mov hWnd, eax

  invoke ShowWindow, hWnd, SW_SHOWNORMAL
  invoke UpdateWindow, hWnd

  ;===================================
  ; Loop until PostQuitMessage is sent
  ;===================================
  StartLoop:
    invoke GetMessage, addr msg, NULL, 0, 0
    cmp eax, 0
    je ExitLoop
    invoke TranslateMessage, addr msg
    invoke DispatchMessage, addr msg
    jmp StartLoop
  ExitLoop:

  invoke FreeLibrary, hDll
  return msg.wParam
RichMain endp

; --------------------------------------------------------------------------
; DESCRIPTION: Processes messages sent to the main window
;       INPUT: hWnd as HWND, Msg as UINT, wParam as WPARAM, lParam as LPARAM
;      OUTPUT: Depends on the message sent
;       USAGE: invoke WndProc, hWnd, WM_COMMAND, 0, 0
;     RETURNS: 0
; --------------------------------------------------------------------------
WndProc proc hWin   :DWORD,
             uMsg   :DWORD,
             wParam :DWORD,
             lParam :DWORD
  LOCAL Rc      :RECT
  LOCAL rLeft   :DWORD
  LOCAL rTop    :DWORD
  LOCAL rRight  :DWORD
  LOCAL rBottom :DWORD
  LOCAL stx     :SETTEXTEX

  .if uMsg == WM_CREATE
    invoke CreateWindowEx, WS_EX_CLIENTEDGE, ADDR szEdit, NULL, \
      WS_VISIBLE or WS_CHILDWINDOW or ES_SUNKEN or ES_MULTILINE or \
      WS_VSCROLL or ES_READONLY or ES_AUTOVSCROLL or ES_NOHIDESEL, \
      0, 0, 0, 0, hWin, 101, hInstance, NULL
    mov txtEdit, eax

    ; allows us to subclass the rich edit control
    invoke SetWindowLong, txtEdit, GWL_WNDPROC, addr EditProc
    mov lpEdit, eax

    ; setup rich edit control
    mov stx.flags, ST_SELECTION
    invoke SendMessage, txtEdit, EM_SETBKGNDCOLOR, 0, 0
    invoke SendMessage, txtEdit, EM_SETTEXTEX, addr stx, addr RTFDATA
    invoke SendMessage, txtEdit, EM_SETSEL, 0, 0
    invoke SetFocus, txtEdit
  .elseif uMsg == WM_DESTROY
    invoke PostQuitMessage, NULL
    return 0 
  .elseif uMsg == WM_SIZE
    invoke GetClientRect, hWin, addr Rc
    m2m rLeft, Rc.left
    m2m rTop, Rc.top
    m2m rRight, Rc.right
    m2m rBottom, Rc.bottom
    invoke MoveWindow, txtEdit, rLeft, rTop, rRight, rBottom, TRUE
  .endif

  invoke DefWindowProc, hWin, uMsg, wParam, lParam
  ret
WndProc endp

; --------------------------------------------------------------------------
; DESCRIPTION: Processes messages sent to the edit control
;       INPUT: hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
;      OUTPUT: Depends on the message sent
;       USAGE: invoke EditProc, hWnd, WM_COMMAND, 0, 0
;     RETURNS: 0
; --------------------------------------------------------------------------
EditProc proc hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
  invoke LoadCursor, NULL, IDC_ARROW
  invoke SetCursor, eax
  invoke HideCaret, hWin

  invoke CallWindowProc, lpEdit, hWin, uMsg, wParam, lParam
  ret
EditProc endp

; --------------------------------------------------------------------------
; DESCRIPTION: Divides the two numbers by two and subtracts the halfs
;       INPUT: wDim:DWORD, sDim:DWORD
;      OUTPUT: Integer with divided number
;       USAGE: invoke TopXY, 6, 40
;     RETURNS: 17
; --------------------------------------------------------------------------
TopXY proc wDim:DWORD, sDim:DWORD
  shr sDim, 1      ; divide screen dimension by 2
  shr wDim, 1      ; divide window dimension by 2
  mov eax, wDim    ; copy window dimension into eax
  sub sDim, eax    ; sub half win dimension from half screen dimension

  return sDim
TopXY endp

; //////////////////////////////////////////////////////////////////////////

end start

; //////////////////////////////////////////////////////////////////////////
; > 249 lines for MASM 6.15.8803                     End of Read Me Dialog <
; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
