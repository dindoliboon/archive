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

    OCMOpen         proto :DWORD
    OCMClose        proto

; ##########################################################################

.code

; ##########################################################################

DllMain proc hInstDLL:DWORD, fdwReason:DWORD, lpvReserved:DWORD
    return TRUE
DllMain endp

; ##########################################################################

OCMOpen proc input:DWORD
    return TRUE
OCMOpen endp

; ##########################################################################

OCMClose proc
    return TRUE
OCMClose endp

; ##########################################################################

End DllMain
