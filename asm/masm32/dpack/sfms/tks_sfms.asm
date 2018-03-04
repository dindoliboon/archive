; #########################################################################

    .386
    .model flat, stdcall
    option casemap :none   ; case sensitive

; #########################################################################

    includelib \masm32\lib\kernel32.lib
    includelib \masm32\lib\advapi32.lib

    ExitProcess   PROTO :DWORD
    RegDeleteKeyA PROTO :DWORD,:DWORD

; #########################################################################

    .data
        szKeyDir          db "Software\Microsoft\Windows\"
                          db "CurrentVersion\Explorer\MenuOrder",0
        HKEY_CURRENT_USER equ 80000001h

; #########################################################################

    .code

start:
    push offset szKeyDir
    push HKEY_CURRENT_USER
    call RegDeleteKeyA

    push 0
    call ExitProcess

; #########################################################################

end start
