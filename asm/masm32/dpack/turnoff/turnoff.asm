; #########################################################################

      .386
      .model flat, stdcall
      option casemap :none

; #########################################################################

    include \MASM32\INCLUDE\shell32.inc
    includelib \MASM32\LIB\shell32.lib

; #########################################################################

    WinMain PROTO :DWORD,:DWORD,:DWORD,:DWORD
    WndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD

; #########################################################################

.code

start:

    invoke SHShutDownDialog, 0

; #########################################################################

WinMain proc hInst     :DWORD,
             hPrevInst :DWORD,
             CmdLine   :DWORD,
             CmdShow   :DWORD

    ret
WinMain endp

; #########################################################################

WndProc proc hWin   :DWORD,
             uMsg   :DWORD,
             wParam :DWORD,
             lParam :DWORD
    ret

WndProc endp

; #########################################################################

end start
