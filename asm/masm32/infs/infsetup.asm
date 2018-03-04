; #########################################################################

      .386
      .model flat, stdcall
      option casemap :none   		; case sensitive

; #########################################################################

      include \masm32\include\kernel32.inc
      include \masm32\include\shell32.inc

      includelib \masm32\lib\kernel32.lib
      includelib \masm32\lib\shell32.lib

; #########################################################################

    .code

start:

    jmp @F
      szAction   db 'install', 0
      szFilename db 'prg_infl.inf', 0
    @@:

    xor edi, edi

    invoke ShellExecuteA, edi, addr szAction, addr szFilename, edi, edi, edi
    invoke ExitProcess, 0

end start
