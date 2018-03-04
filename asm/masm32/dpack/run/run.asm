; #########################################################################

    .386
    .model flat, stdcall
    option casemap :none   ; case sensitive

; #########################################################################

    ; kernel32.dll
    includelib kernel32.lib
    ExitProcess PROTO :DWORD

    ; shell32.dll
    includelib shell32.lib
    SHRunDialog PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD

; #########################################################################

.code

start:

    invoke SHRunDialog, 0, 0, 0, 0, 0, 0
    invoke ExitProcess, 0

end start
