; #########################################################################

      .386
      .model flat, stdcall
      option casemap :none   		; case sensitive

; #########################################################################

      include \masm32\include\windows.inc
      include \masm32\include\kernel32.inc
      include \masm32\include\shell32.inc
      include \masm32\include\masm32.inc
      include \masm32\include\comdlg32.inc

      includelib \masm32\lib\kernel32.lib
      includelib \masm32\lib\shell32.lib
      includelib \masm32\lib\masm32.lib
      includelib \masm32\lib\comdlg32.lib

      includelib \masm32\lib\user32.lib
      include \masm32\include\user32.inc
      
; #########################################################################

    .const
        MAXSIZE    equ 260              ; Max buffer size

    .data
        szAction   db 'install', 0      ; Action
        szFilename db 'tks_infl.ini', 0 ; Name of INI file
        szAppName  db 'Setup', 0        ; Section Name
        szKeyName  db 'INF', 0          ; Key name
        szOpen     db 'Open', 0         ; Open Dialog Title
        szFilter   db 'INF Files',0,'*.inf',0,0
        hFile      dd 0                 ; File Handle
        hInst      dd 0                 ; Program Instance
        ofn        OPENFILENAME <>      ; OFN Structure

    .data?
        szBuffer   db MAXSIZE dup (?)   ; Name of INF file
        szAppPath  db MAXSIZE dup (?)   ; Application Path

    .code

start:

    ;=====================
    ; Get program instance
    ;=====================
    invoke GetModuleHandle, NULL
    mov hInst, eax

    ;=====================
    ; Get our command line
    ;=====================
    ;* Advanced INF Installer keeps
    ;* saying it can not find the file.
    invoke ArgCl, 1, addr szBuffer
    
    ;=========================
    ; Check if our file exists
    ;=========================
    invoke CreateFile, addr szBuffer, GENERIC_READ, FILE_SHARE_READ, NULL,\
                       OPEN_EXISTING, FILE_ATTRIBUTE_ARCHIVE, NULL
    mov hFile, eax
    .if eax == INVALID_HANDLE_VALUE
        invoke CloseHandle, hFile
    
        ;=======================================
        ; Combine application path with INI file
        ;=======================================
        mov byte ptr[szBuffer],0
        invoke GetAppPath, addr szAppPath
        invoke lstrcat, addr szBuffer, addr szAppPath
        invoke lstrcat, addr szBuffer, addr szFilename
    
        ;==============
        ; Read INI file
        ;==============
        invoke GetPrivateProfileString, addr szAppName, addr szKeyName, addr szFilename,
                                        addr szBuffer, MAXSIZE, addr szBuffer
    
        ;=========================
        ; Check if our file exists
        ;=========================
        invoke CreateFile, addr szBuffer, GENERIC_READ, FILE_SHARE_READ, NULL,\
                           OPEN_EXISTING, FILE_ATTRIBUTE_ARCHIVE, NULL
        mov hFile, eax
        .if eax == INVALID_HANDLE_VALUE
            invoke CloseHandle, hFile

            ;===================================================
            ; Check if the user wants to run a diffrent INF file
            ;===================================================
            mov byte ptr[szBuffer],0
            mov ofn.lStructSize, sizeof ofn
            push hInst
            pop  ofn.hWndOwner
            push hInst
            pop  ofn.hInstance
            mov  ofn.lpstrFilter, offset szFilter
            mov  ofn.lpstrFile, offset szBuffer
            mov  ofn.nMaxFile, MAXSIZE
            mov  ofn.Flags, OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST or\
                            OFN_LONGNAMES or OFN_EXPLORER or OFN_HIDEREADONLY
            mov  ofn.lpstrTitle, offset szOpen
            invoke GetOpenFileName, addr ofn
    
            ;=================
            ; No file selected
            ;=================
            .if eax == FALSE
                jmp exit
            .endif
        .endif
    .endif

    ;==========================
    ; Run our Installation File
    ;==========================
    invoke ShellExecuteA, 0, addr szAction, addr szBuffer, 0, 0, 0

    ;=================
    ; Exit our program
    ;=================
    exit:
        invoke ExitProcess, 0

end start
