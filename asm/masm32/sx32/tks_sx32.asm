; #########################################################################

      .386
      .model flat, stdcall
      option casemap :none   		; case sensitive

; #########################################################################

      include \masm32\include\windows.inc
      include \masm32\include\kernel32.inc
      include \masm32\include\shell32.inc
      include \masm32\include\masm32.inc
      include \masm32\include\user32.inc

      ;============================
      ; For debugging purposes only
      ;============================
      ;include \masm32\dberror\errormac.asm

      includelib \masm32\lib\kernel32.lib
      includelib \masm32\lib\shell32.lib
      includelib \masm32\lib\masm32.lib
      includelib \masm32\lib\user32.lib

; #########################################################################

      Extract_Resource PROTO :DWORD,:DWORD,:DWORD
      Clear_Buffer     PROTO
      
; #########################################################################

    .const
        MAXSIZE    equ 260              ; Max buffer size
        MAXFILES   equ 3                ; Number of archived files

    .data
        szAction   db 'open', 0         ; Action
        hInstance  dd 0                 ; Program Instance
        hCurFiles  dd 0                 ; Current Proccessed File

    .data?
        szBuffer   db MAXSIZE dup (?)   ; Name of INF file
        szTmpPath  db MAXSIZE dup (?)   ; Application Path
        szTmpFile  db MAXSIZE dup (?)   ; String Table Buffer

    .code

start:

    ;=====================
    ; Get program instance
    ;=====================
    invoke GetModuleHandle, NULL
    mov hInstance, eax

    ;====================
    ; Find temporary path
    ;====================
    invoke GetTempPath, MAXSIZE, addr szTmpPath

    ;==================
    ; Extract all files
    ;==================
    ExtractAgain:
      add hCurFiles, 1
      mov byte ptr[szBuffer], 0
      invoke LoadString, hInstance, hCurFiles, addr szTmpFile, MAXSIZE
      invoke lstrcat, addr szBuffer, addr szTmpPath
      invoke lstrcat, addr szBuffer, addr szTmpFile
      invoke Extract_Resource, hCurFiles, addr szBuffer, hInstance

    .if hCurFiles != MAXFILES
      jmp ExtractAgain
    .endif
    
    ;==========================
    ; Run our Installation File
    ;==========================
    invoke ShellExecuteA, 0, addr szAction, addr szBuffer, 0, 0, 0

    ;=================
    ; Exit our program
    ;=================
    invoke ExitProcess, 0


Clear_Buffer proc
  mov byte ptr[szBuffer],0
  mov byte ptr[szTmpFile],0
Clear_Buffer endp


Extract_Resource proc szRes  : DWORD,
                      szOut  : DWORD,
                      hInst  : DWORD

  LOCAL hFindResource   : DWORD
  LOCAL hLoadResource   : DWORD
  LOCAL hSizeOfResource : DWORD
  LOCAL hLockResource   : DWORD
  LOCAL hlcreat         : DWORD

  ;========================
  ; Search for our resource
  ;========================
  invoke FindResource, hInst, szRes, RT_RCDATA
  mov hFindResource, eax

  ;==========================
  ; Load resource into memory
  ;==========================
  invoke LoadResource, hInst, hFindResource
  mov hLoadResource, eax

  ;==================
  ; Get resource size
  ;==================
  invoke SizeofResource, hInst, hFindResource
  mov hSizeOfResource, eax

  ;=======================
  ; Lock resource in place
  ;=======================
  invoke LockResource, hLoadResource
  mov hLockResource, eax

  ;========================
  ; Dump contents to a file
  ;========================
  invoke _lcreat, szOut, 0
  mov hlcreat, eax

  invoke _hwrite, hlcreat, hLockResource, hSizeOfResource
  invoke _lclose, hlcreat

  ret

Extract_Resource endp


end start
