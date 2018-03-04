; #########################################################################

    .386
    .model flat, stdcall
    option casemap :none    ; case sensitive

; #########################################################################

    ;=========
    ; Includes
    ;=========
    include \MASM32\INCLUDE\windows.inc
    include \MASM32\INCLUDE\masm32.inc
    include \MASM32\INCLUDE\user32.inc
    include \MASM32\INCLUDE\kernel32.inc
    include aplib.inc

    ;==========
    ; Libraries
    ;==========
    includelib \MASM32\LIB\masm32.lib
    includelib \MASM32\LIB\user32.lib
    includelib \MASM32\LIB\kernel32.lib
    includelib aplib.lib

    ;============================
    ; For debugging purposes only
    ;============================
    ;include \masm32\dberror\errormac.asm

; #########################################################################

    ;=============
    ; Local macros
    ;=============
    print MACRO Quoted_Text : VARARG
        LOCAL Txt
        .data
            Txt db Quoted_Text, 0
        .code
            invoke StdOut, addr Txt
    ENDM

    ;=================
    ; Local prototypes
    ;=================
    Extract_Resource PROTO :DWORD,:DWORD,:DWORD,:DWORD

; #########################################################################

    .const
        MAXSIZE     equ 260             ; Max buffer size

    .data
        szEnter     db 13, 10, 0        ; Enter Key
        hInstance   dd 0                ; Program Instance

    .data?
        sMemory     HANDLE ?            ; Source
        sAllocMem   DWORD  ?
        dMemory     HANDLE ?            ; Destination
        dAllocMem   DWORD  ?
        wMemory     HANDLE ?            ; Working
        wAllocMem   DWORD  ?
        szFile1     db MAXSIZE dup (?)  ; Input File
        szFile2     db MAXSIZE dup (?)  ; Output File

    .code

start:

    ;=====================
    ; Get program instance
    ;=====================
    invoke GetModuleHandle, NULL
    mov hInstance, eax

    ;==================
    ; Grab command line
    ;==================
    invoke GetCL, 1, addr szFile1
    invoke exist, addr szFile1
    .if eax == 0
wrong:
        print "t2e 1.3a"
        invoke StdOut, addr szEnter
        print "Usage: t2e [input file.txt] [output file.exe]"
        invoke StdOut, addr szEnter
        jmp exit
    .endif

    invoke GetCL, 2, addr szFile2
    invoke lstrlen, addr szFile2
    .if eax == 0
        jmp wrong
    .endif

    ;===========================
    ; Extract stub, combine text
    ;===========================
    print "Compressing Data..."
    invoke Extract_Resource, 1, addr szFile1, addr szFile2, hInstance
    invoke StdOut, addr szEnter
    print "Finished!"

    ;=================
    ; Exit our program
    ;=================
exit:
    invoke ExitProcess, 0

; #########################################################################

Extract_Resource proc szRes  : DWORD,
                      szIn   : DWORD,
                      szOut  : DWORD,
                      hInst  : DWORD

    LOCAL hFindResource   : DWORD
    LOCAL hLoadResource   : DWORD
    LOCAL hSizeOfResource : DWORD
    LOCAL hLockResource   : DWORD
    LOCAL hlcreat         : DWORD
    LOCAL hFile           : DWORD
    LOCAL iDocSize        : DWORD
    LOCAL uDocSize        : DWORD

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

    ;============================
    ; Dump exe contents to a file
    ;============================
    invoke _lcreat, szOut, 0
    mov hlcreat, eax

    invoke _hwrite, hlcreat, hLockResource, hSizeOfResource

    ;===================
    ; Get text file size
    ;===================
    invoke filesize, szIn
    mov iDocSize, eax
    mov uDocSize, eax

    ;===============
    ; Open text file
    ;===============
    invoke _lopen, szIn, OF_READ
    mov hFile, eax

    ;================================
    ; Allocate memory for source file
    ;================================
    invoke GlobalAlloc, GMEM_MOVEABLE or GMEM_ZEROINIT, iDocSize
    mov sMemory, eax

    invoke GlobalLock, sMemory
    mov sAllocMem, eax

    ;================================
    ; Allocate memory for destination
    ;================================
    invoke GlobalAlloc, GMEM_MOVEABLE or GMEM_ZEROINIT, iDocSize
    mov dMemory, eax

    invoke GlobalLock, dMemory
    mov dAllocMem, eax

    ;===============
    ; Read text file
    ;===============
    invoke _lread, hFile, sAllocMem, iDocSize

    ;===================================
    ; Allocate memory for working buffer
    ;===================================
    invoke aP_workmem_size, iDocSize
    invoke GlobalAlloc, GMEM_MOVEABLE or GMEM_ZEROINIT, eax
    mov wMemory, eax

    invoke GlobalLock, wMemory
    mov wAllocMem, eax

    ;============================
    ; Compress text file contents
    ;============================
    invoke aP_pack, sAllocMem, dAllocMem, iDocSize, wAllocMem, NULL
    mov iDocSize, eax

    ;==================================================
    ; Dump data, compressed size, and uncompressed size
    ;==================================================
    invoke _hwrite, hlcreat, dAllocMem, iDocSize
    invoke _hwrite, hlcreat, addr iDocSize, sizeof iDocSize
    invoke _hwrite, hlcreat, addr uDocSize, sizeof uDocSize

    ;=======================
    ; Free files and buffers
    ;=======================
    invoke _lclose, hFile
    invoke _lclose, hlcreat
    invoke GlobalUnlock, wAllocMem
    invoke GlobalFree, wMemory
    invoke GlobalUnlock, dAllocMem
    invoke GlobalFree, dMemory
    invoke GlobalUnlock, sAllocMem
    invoke GlobalFree, sMemory

    ret

Extract_Resource endp

; #########################################################################

end start
