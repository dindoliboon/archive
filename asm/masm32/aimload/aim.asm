; #########################################################################

      .386
      .model flat, stdcall
      option casemap :none

; #########################################################################

      include \masm32\include\windows.inc

      include \masm32\include\user32.inc
      include \masm32\include\kernel32.inc

      includelib \masm32\lib\user32.lib
      includelib \masm32\lib\kernel32.lib

      include oscore.inc
      includelib oscore.lib

; #########################################################################

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

; #########################################################################

        WinMain PROTO :DWORD,:DWORD,:DWORD,:DWORD

; #########################################################################

    .data
        szOSCoreDLL   db "oscore.dll", 0
        szError       db "Error Occured", 0
        szLoad        db "Error: loading oscore.dll!", 0
        szSigned      db "Error: you can't be signed on!", 0
        szBuddyList   db "_Oscar_BuddyListWin", 0
        CommandLine   dd 0
        hInstance     dd 0
        hModule       dd 0
        hMute         dd 0

    .data
        szModuleName  db 1025 dup(?)

    .code

start:

; #########################################################################

    invoke GetModuleHandle, NULL
    mov hInstance, eax

    invoke FindWindow, addr szBuddyList, NULL
    .if eax
        invoke MessageBox, 0, addr szSigned, addr szError, MB_OK
        jmp cleanup
    .endif

    invoke GetCommandLine
    mov CommandLine, eax

    invoke LoadLibrary, addr szOSCoreDLL
    .if eax != NULL
        mov hModule, eax
        invoke OscoreRun, hModule, addr CommandLine, SW_SHOWNORMAL
    .else
        invoke MessageBox, 0, addr szLoad, addr szError, MB_OK
    .endif

cleanup:
    .if hModule
        invoke FreeLibrary, hModule
    .endif

    invoke ExitProcess, 0

; #########################################################################

end start
