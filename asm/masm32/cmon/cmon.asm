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

    ;==========
    ; Libraries
    ;==========
    includelib \MASM32\LIB\masm32.lib
    includelib \MASM32\LIB\user32.lib
    includelib \MASM32\LIB\kernel32.lib

    ;============================
    ; For debugging purposes only
    ;============================
    ;include \masm32\dberror\errormac.asm

; #########################################################################

    ;=============
    ; Local macros
    ;=============
    cpy MACRO M1, M2
        mov eax, M2
        mov M1, eax
    ENDM

; #########################################################################

    .const
        MAXSIZE             equ 260     ; Max Buffer Size
        DM_BITSPERPEL	    equ 00040000h
        DM_PELSWIDTH	    equ 00080000h
        DM_PELSHEIGHT	    equ 00100000h
        DM_DISPLAYFLAGS	    equ 00200000h
        DM_DISPLAYFREQUENCY equ 00400000h

    .data
      szTitle   db "CMON Usage Notes", 0
      szInfo    db "CMON Usage Notes Changes the current display settings.", 13, 10, 13, 10
                db "CMON [width] [height] [color depth] [refresh rate] [save]", 13, 10, 13, 10
                db "width", 9, 9,     "- Accepts values from 640 and up", 13, 10
                db "height", 9, 9,    "- Accepts values from 480 and up", 13, 10
                db "color depth", 9,  "- Accepts values from 4 to 32", 13, 10
                db "refresh rate", 9, "- Accepts values from 56 and up", 13, 10
                db "save", 9, 9, "- Accepts values from 0 to 1", 13, 10, 13, 10
                db "color depth in detail:", 13, 10
                db 9, "4", 9,  "- stands for 16 colors", 13, 10
                db 9, "8", 9,  "- stands for 256 colors", 13, 10
                db 9, "16", 9, "- stands for 16-bit color", 13, 10
                db 9, "32", 9, "- stands for 32-bit color", 13, 10, 13, 10
                db "save in detail:", 13, 10
                db 9, "0", 9, "- resets but does not save settings", 13, 10
                db 9, "1", 9, "- resets and save settings", 13, 10, 13, 10
                db "* currently, save is optional and will default to 0.", 13, 10
                db "* if you screw up your monitor, its not my fault!!!!", 13, 10, 13, 10
                db "setting a screen to 800x600 with 16-bit colors at 85 Hz", 13, 10
                db "cmon 800 600 16 85", 0
                hInstance   dd 0                ; Program Instance
                counter     dd 1
                CHG_FLAG    dd 0
                ;CDS_RESET

    .data?
        dPixel      DWORD ?
        dWidth      DWORD ?
        dHeight     DWORD ?
        dRefresh    DWORD ?
        szCommand   db MAXSIZE dup (?)  ; Command Line
        dm          DEVMODE <>          ; Device Structure

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
    GrabLine:
        invoke GetCL, counter, addr szCommand
        .if eax == 1
            invoke atodw, addr szCommand
            .if counter == 1
                mov dWidth, eax
            .elseif counter == 2
                mov dHeight, eax
            .elseif counter == 3
                mov dPixel, eax
            .elseif counter == 4
                mov dRefresh, eax
            .elseif counter == 5
                .if eax == 1
                    mov CHG_FLAG, CDS_UPDATEREGISTRY
                .endif
            .endif
        .endif

    add counter, 1
    .if counter <= 5
        jmp GrabLine
    .endif

    ;=========================
    ; Check numbers real quick
    ;=========================
    .if dPixel   >= 4   && dPixel   <= 32   && \
        dWidth   >= 640 && dHeight  >= 480  && \
        dRefresh >= 56

        invoke EnumDisplaySettings, 0, 0, addr dm

        mov dm.dmSize, sizeof DEVMODE
        mov dm.dmFields, DM_BITSPERPEL or DM_PELSWIDTH or \
                         DM_PELSHEIGHT or DM_DISPLAYFREQUENCY

        cpy dm.dmPelsWidth,        dWidth
        cpy dm.dmPelsHeight,       dHeight
        cpy dm.dmBitsPerPel,       dPixel
        cpy dm.dmDisplayFrequency, dRefresh

        invoke ChangeDisplaySettings, addr dm, CDS_TEST
        .if eax == DISP_CHANGE_SUCCESSFUL
            invoke ChangeDisplaySettings, addr dm, CHG_FLAG
            invoke SendMessage, HWND_BROADCAST, WM_DISPLAYCHANGE, \
                SPI_SETNONCLIENTMETRICS, 0
        .endif
    .else
        invoke MessageBox, 0, addr szInfo, addr szTitle, MB_OK
    .endif

    ;=================
    ; Exit our program
    ;=================
    invoke ExitProcess, 0

; #########################################################################

end start
