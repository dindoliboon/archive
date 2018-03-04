; #########################################################################

    .386                    ; minimum processor needed for 32 bit
    .model flat, stdcall    ; FLAT memory model & STDCALL calling
    option casemap :none    ; set code to case sensitive

; #########################################################################

    include \masm32\include\windows.inc
    include \masm32\include\gdi32.inc    
    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc
    include \masm32\include\masm32.inc
    include \masm32\include\comctl32.inc
    include \masm32\include\comdlg32.inc

    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\masm32.lib
    includelib \masm32\lib\kernel32.lib
    includelib \masm32\lib\gdi32.lib
    includelib \masm32\lib\comctl32.lib
    includelib \masm32\lib\comdlg32.lib

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

    LOWORD MACRO bigword
        mov eax, bigword
        and eax, 0FFFFh
    ENDM

    HIWORD MACRO bigword
        mov ebx, bigword
        shr ebx, 16
    ENDM

    stralloc MACRO ln
        invoke GlobalAlloc, GMEM_MOVEABLE or GMEM_ZEROINIT, ln
        mov hGlobal, eax
        invoke GlobalLock, hGlobal
    ENDM

    strfree MACRO strhandle
        invoke GlobalUnlock, strhandle
        invoke GlobalFree, hGlobal
    ENDM

; #########################################################################

    WinMain        PROTO :DWORD,:DWORD,:DWORD,:DWORD
    WndProc        PROTO :DWORD,:DWORD,:DWORD,:DWORD
    TopXY          PROTO :DWORD,:DWORD
    RichEdMl       PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
    RichEdProc     PROTO :DWORD,:DWORD,:DWORD,:DWORD
    GetFileName    PROTO :DWORD,:DWORD,:DWORD
    SaveFileName   PROTO :DWORD,:DWORD,:DWORD
    ModifyControl  PROTO
    WordWrap       PROTO
    SetTitle       PROTO
    Confirmation   PROTO :DWORD

; #########################################################################

    .const
        MAX_SIZE       equ    260
        IDM_MENU       equ    1

        IDM_NEWWIN     equ    101
        IDM_NEW        equ    102
        IDM_OPEN       equ    103
        IDM_SAVE       equ    104
        IDM_SAVEDOS    equ    105
        IDM_SAVEUNIX   equ    106
        IDM_PAGESET    equ    107
        IDM_PRINT      equ    108
        IDM_PROPERTIES equ    109
        IDM_EXIT       equ    110

        IDM_UNDO       equ    201
        IDM_REDO       equ    202
        IDM_CUT        equ    203
        IDM_COPY       equ    204
        IDM_PASTE      equ    205
        IDM_CLEAR      equ    206
        IDM_SELECTALL  equ    207

        IDM_FONT       equ    301
        IDM_BGCOLOR    equ    302
        IDM_TOOL       equ    303
        IDM_STATUS     equ    304
        IDM_SELECTION  equ    305
        IDM_CLEARHIS   equ    306
        IDM_HISFILE    equ    307
        IDM_RELOAD     equ    308
        IDM_WORDWRAP   equ    309

        IDM_ADDFAV     equ    401
        IDM_ORGFAV     equ    402
        IDM_FAVFILE    equ    403

        IDM_FIND       equ    501
        IDM_FINDNEXT   equ    502
        IDM_REPLACE    equ    503
        IDM_GOTO       equ    504
        IDM_TIMEDATE   equ    505
        IDM_FILE       equ    506

        IDM_ABOUT      equ    601

        tbb TBBUTTON <STD_FILENEW,    IDM_NEW, TBSTATE_ENABLED, TBSTYLE_BUTTON, 0, 0>
            TBBUTTON <STD_FILEOPEN,   IDM_OPEN, TBSTATE_ENABLED, TBSTYLE_BUTTON, 0, 0>
            TBBUTTON <STD_FILESAVE,   IDM_SAVE, TBSTATE_ENABLED, TBSTYLE_BUTTON, 0, 0>
            TBBUTTON <0,              0, TBSTATE_ENABLED, TBSTYLE_SEP, 0, 0>
            TBBUTTON <STD_PRINT,      IDM_PRINT, TBSTATE_ENABLED, TBSTYLE_BUTTON, 0, 0>
            TBBUTTON <STD_PROPERTIES, IDM_PROPERTIES, TBSTATE_ENABLED, TBSTYLE_BUTTON, 0, 0>
            TBBUTTON <0,              0, TBSTATE_ENABLED, TBSTYLE_SEP, 0, 0>
            TBBUTTON <STD_CUT,        IDM_CUT, TBSTATE_ENABLED, TBSTYLE_BUTTON, 0, 0>
            TBBUTTON <STD_COPY,       IDM_COPY, TBSTATE_ENABLED, TBSTYLE_BUTTON, 0, 0>
            TBBUTTON <STD_PASTE,      IDM_PASTE, TBSTATE_ENABLED, TBSTYLE_BUTTON, 0, 0>
            TBBUTTON <STD_DELETE,     IDM_CLEAR, TBSTATE_ENABLED, TBSTYLE_BUTTON, 0, 0>
            TBBUTTON <0,              0, TBSTATE_ENABLED, TBSTYLE_SEP, 0, 0>
            TBBUTTON <STD_UNDO,       IDM_UNDO, TBSTATE_ENABLED, TBSTYLE_BUTTON, 0, 0>
            TBBUTTON <STD_REDOW,      IDM_REDO, TBSTATE_ENABLED, TBSTYLE_BUTTON, 0, 0>
            TBBUTTON <0,              0, TBSTATE_ENABLED, TBSTYLE_SEP, 0, 0>
            TBBUTTON <STD_FIND,       IDM_FIND, TBSTATE_ENABLED, TBSTYLE_BUTTON, 0, 0>
            TBBUTTON <STD_REPLACE,    IDM_REPLACE, TBSTATE_ENABLED, TBSTYLE_BUTTON, 0, 0>

    .data
        szLineFeed      db 10,0
        szDirty         db " ~ ",0
        szClean         db " - ",0
        szKanmia        db "Kanmia",0
        szUntitled      db "Untitled",0
        szRE            db "riched20.dll",0
        szREtext        db "richedit20a",0
        szTitleO        db "Open",0
        szTitleS        db "Save As",0
        szFilter        db "All Files",0,"*.*",0,
                           "Text Files",0,"*.txt",0,0
        szAbout         db "About Kanmia",0
        szAboutMsg      db "Kanmia 1.0 / March 2001",13,10,
                           "Coded in 32-bit Windows assembly",13,10,13,10,
                           "Thanks to exit for help with alpha version!",13,10,
                           "do_not_bug_me@tks.cjb.net",0

        CommandLine     dd 0
        hWnd            dd 0
        hMenu           dd 0
        hInstance       dd 0
        hRichEd         dd 0
        hStatus         dd 0
        hToolBar        dd 0
        hSelectBar      dd 0
	  hSaveDos        dd 1
        hWrap           dd 0
        hPopup          dd 0
        lpRichEd        dd 0

        hUnix           dd 0
        hUnixLine       dd 0
        hUnixCounter    dd 0
        hSaveWrap       dd 0

        ofn             OPENFILENAME <>

    .data?
        szFileName      db MAX_SIZE dup (?)
        szDisplayName   db MAX_SIZE dup (?)
        szBuffer        db MAX_SIZE dup (?)

    hGlobal       HANDLE ?
    hMem          DWORD  ?

; #########################################################################

    .code

start:

    invoke GetModuleHandle, NULL ; provides the instance handle
    mov hInstance, eax

    invoke GetCommandLine        ; provides the command line address
    mov CommandLine, eax

    invoke InitCommonControls

    invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT

    invoke ExitProcess,eax       ; cleanup & return to operating system

; #########################################################################

WinMain proc hInst     :DWORD,
             hPrevInst :DWORD,
             CmdLine   :DWORD,
             CmdShow   :DWORD

    ;====================
    ; Put LOCALs on stack
    ;====================
    LOCAL wc   :WNDCLASSEX
    LOCAL msg  :MSG

    LOCAL Wwd  :DWORD
    LOCAL Wht  :DWORD
    LOCAL Wtx  :DWORD
    LOCAL Wty  :DWORD

    szText szClassName,"Kanmia_Class"

    ;==================================================
    ; Fill WNDCLASSEX structure with required variables
    ;==================================================
    mov wc.cbSize,         sizeof WNDCLASSEX
    mov wc.style,          CS_DBLCLKS
    ;CS_HREDRAW or CS_VREDRAW \
    ; or CS_BYTEALIGNWINDOW
    mov wc.lpfnWndProc,    offset WndProc      ; address of WndProc
    mov wc.cbClsExtra,     NULL
    mov wc.cbWndExtra,     NULL
    m2m wc.hInstance,      hInst               ; instance handle
;        invoke GetStockObject,HOLLOW_BRUSH
;COLOR_BTNFACE+1
    mov wc.hbrBackground,  NULL
    mov wc.lpszMenuName,   NULL
    mov wc.lpszClassName,  offset szClassName  ; window class name
    invoke LoadIcon,hInst,1     ; icon ID   ; resource icon
    mov wc.hIcon,          eax
;    invoke LoadCursor,NULL,IDC_ARROW         ; system cursor
    mov wc.hCursor,        NULL
    mov wc.hIconSm,        0

    invoke RegisterClassEx, ADDR wc     ; register the window class

    ;================================
    ; Centre window at following size
    ;================================
    mov Wwd, 500
    mov Wht, 350

    invoke GetSystemMetrics,SM_CXSCREEN ; get screen width in pixels
    invoke TopXY,Wwd,eax
    mov Wtx, eax

    invoke GetSystemMetrics,SM_CYSCREEN ; get screen height in pixels
    invoke TopXY,Wht,eax
    mov Wty, eax

    ; ==================================
    ; Create the main application window
    ; ==================================
    invoke CreateWindowEx, 0, ADDR szClassName, NULL,
        WS_OVERLAPPEDWINDOW, Wtx,Wty,Wwd,Wht, NULL,NULL, hInst,NULL
    mov   hWnd,eax  ; copy return value into handle DWORD

    invoke LoadMenu,hInst,1                   ; load resource menu
    mov hMenu, eax
    invoke SetMenu,hWnd,eax                   ; set it to main window

    invoke ShowWindow,hWnd,SW_SHOWNORMAL      ; display the window
    invoke UpdateWindow,hWnd                  ; update the display

    ;===================================
    ; Loop until PostQuitMessage is sent
    ;===================================
    StartLoop:
        invoke GetMessage,ADDR msg,NULL,0,0         ; get each message
        cmp eax, 0                                  ; exit if GetMessage()
        je ExitLoop                                 ; returns zero
        invoke TranslateMessage, ADDR msg           ; translate it
        invoke DispatchMessage,  ADDR msg           ; send it to message proc
        jmp StartLoop
    ExitLoop:

    return msg.wParam

WinMain endp

; #########################################################################

WndProc proc hWin   :DWORD,
             uMsg   :DWORD,
             wParam :DWORD,
             lParam :DWORD

    LOCAL tba        :TBADDBITMAP
    LOCAL sbParts[4] :DWORD
    LOCAL sHeight    :DWORD
    LOCAL tHeight    :DWORD
    LOCAL rc         :RECT
    LOCAL hlcreat    :DWORD
    
    invoke ModifyControl

    .if uMsg == WM_COMMAND
    ;======== menu commands ========
        LOWORD wParam
        .if eax == IDM_NEWWIN
            invoke GetModuleFileName, NULL, addr szBuffer, MAX_SIZE
            invoke WinExec, addr szBuffer, SW_SHOWNORMAL
        .elseif eax == IDM_NEW
            invoke Confirmation, hRichEd
            .if eax == IDYES
                invoke SendMessage, hWin, WM_COMMAND, IDM_SAVE, 0
            .elseif eax == IDNO
                jmp @F
            .elseif eax == IDCANCEL
                return 0
            .endif

            invoke SendMessage,hRichEd,EM_GETMODIFY,0,0
            .if eax == 0
            @@:
                mov szFileName[0],0
                invoke SendMessage,hRichEd,WM_SETTEXT,0,0
                invoke SendMessage,hRichEd, EM_SETMODIFY, FALSE, 0
            .endif
        .elseif eax == IDM_OPEN
            invoke Confirmation, hRichEd
            .if eax == IDYES
                invoke SendMessage, hWin, WM_COMMAND, IDM_SAVE, 0
            .elseif eax == IDNO
                jmp @F
            .elseif eax == IDCANCEL
                return 0
            .endif

            invoke SendMessage,hRichEd,EM_GETMODIFY,0,0
            .if eax == 0
            @@:
                invoke GetFileName, hWin, addr szTitleO, addr szFilter
                .if eax != 0
                    invoke lstrcpy, addr szFileName, addr szBuffer
                    invoke Read_File_In,hRichEd,ADDR szFileName
                .endif
            .endif
        .elseif eax == IDM_SAVE
            invoke exist, addr szFileName
            .if eax == 1
                mov eax, hSaveDos
                .if eax == 1
                    invoke Write_To_Disk,hRichEd,ADDR szFileName
                .else
                    jmp saveunix
                .endif
                invoke SendMessage,hRichEd,EM_SETMODIFY,0,0
            .else
                mov eax, hSaveDos
                .if eax == 1
                    invoke SendMessage, hWin, WM_COMMAND, IDM_SAVEDOS, 0
                .else
                    invoke SendMessage, hWin, WM_COMMAND, IDM_SAVEUNIX, 0
                .endif
            .endif
        .elseif eax == IDM_SAVEDOS
            invoke SaveFileName, hWin, addr szTitleS, addr szFilter
            .if eax != 0
                invoke lstrcpy, addr szFileName, addr szBuffer
                invoke Write_To_Disk,hRichEd,ADDR szFileName
                invoke SendMessage,hRichEd,EM_SETMODIFY,0,0
                mov hSaveDos, 1
            .endif
            invoke SetFocus, hRichEd
        .elseif eax == IDM_SAVEUNIX
            invoke SaveFileName, hWin, addr szTitleS, addr szFilter
            .if eax != 0
                invoke lstrcpy, addr szFileName, addr szBuffer
            saveunix:
                invoke EnableWindow, hRichEd, FALSE
                mov eax, hWrap
                mov hSaveWrap, eax
                mov hWrap, 0
                invoke SendMessage, hWin, WM_SIZE, 0, 0

                invoke SendMessage, hRichEd, EM_GETLINECOUNT, 0, 0
                mov hUnix, eax
                mov hUnixCounter, 0

                invoke _lcreat, addr szFileName, 0
                mov hlcreat, eax

                ConvertLine:
                invoke SendMessage, hRichEd, EM_LINEINDEX, hUnixCounter, 0
                invoke SendMessage, hRichEd, EM_LINELENGTH, eax, 0
                mov hUnixLine, eax

                stralloc hUnixLine
                mov hMem, eax

                LOWORD hMem
                mov eax, hUnixLine
                mov [hMem], eax

                invoke SendMessage, hRichEd, EM_GETLINE, hUnixCounter, addr hMem
                mov hUnixLine, eax
                mov eax, offset hMem
                .if eax != NULL
                    invoke _hwrite, hlcreat, addr hMem, hUnixLine
                .endif
                strfree hMem
                add hUnixCounter, 1

                mov eax, hUnix
                .if hUnixCounter != eax
                    invoke _hwrite, hlcreat, addr szLineFeed, 1
                    jmp ConvertLine
                .endif

                invoke _lclose, hlcreat
                invoke SendMessage,hRichEd,EM_SETMODIFY,0,0

                mov eax, hSaveWrap
                mov hWrap, eax
                invoke SendMessage, hWin, WM_SIZE, 0, 0
                invoke EnableWindow, hRichEd, TRUE
                mov hSaveDos, 0
            .endif
            invoke SetFocus, hRichEd
        .elseif eax == IDM_EXIT
            invoke SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL
        .elseif eax == IDM_UNDO
            invoke SendMessage, hRichEd, EM_UNDO, 0 , 0
        .elseif eax == IDM_REDO
            invoke SendMessage, hRichEd, EM_REDO, 0 , 0
        .elseif eax == IDM_CUT
            invoke SendMessage, hRichEd, WM_CUT, 0 , 0
        .elseif eax == IDM_COPY
            invoke SendMessage, hRichEd, WM_COPY, 0 , 0
        .elseif eax == IDM_PASTE
            invoke SendMessage, hRichEd, WM_PASTE, 0 , 0
        .elseif eax == IDM_CLEAR
            invoke SendMessage, hRichEd, WM_CLEAR, 0 , 0
        .elseif eax == IDM_SELECTALL
            invoke SendMessage, hRichEd, EM_SETSEL, 0 , -1
        .elseif eax == IDM_SELECTION
            invoke SendMessage, hRichEd, EM_SETOPTIONS, ECOOP_XOR, ECO_SELECTIONBAR
            .if hSelectBar == 1
                mov hSelectBar, 0
            .else
                mov hSelectBar, 1
            .endif
        .elseif eax == IDM_TOOL
            invoke IsWindowVisible, hToolBar
            .if eax == 0
                invoke ShowWindow, hToolBar, SW_SHOW
            .else
                invoke ShowWindow, hToolBar, SW_HIDE
            .endif
            invoke SendMessage, hWin, WM_SIZE, 0, 0
        .elseif eax == IDM_STATUS
            invoke IsWindowVisible, hStatus
            .if eax == 0
                invoke ShowWindow, hStatus, SW_SHOW
            .else
                invoke ShowWindow, hStatus, SW_HIDE
            .endif
            invoke SendMessage, hWin, WM_SIZE, 0, 0
        .elseif eax == IDM_WORDWRAP
            .if hWrap == 1
                mov hWrap, 0
            .else
                mov hWrap, 1
            .endif
            ; Instead of destroying our rich edit, we can keep our
            ;  modifications like the dirty option, undo/redo editing
            ;  and we don't have to allocate memory!
            invoke SendMessage, hWin, WM_SIZE, 0, 0
;        .elseif eax == IDM_CONTENTS
;            invoke MessageBox, hWin, addr szHelpMsg, addr szHelp, MB_ICONWARNING or MB_OK
        .elseif eax == IDM_ABOUT
            invoke MessageBox, hWin, addr szAboutMsg, addr szAbout, MB_ICONINFORMATION or MB_OK
        .endif

        invoke SetTitle
    ;====== end menu commands ======

    .elseif uMsg == WM_CREATE
        invoke LoadLibrary, ADDR szRE

        invoke RichEdMl,0,0,250,200,hWin,800
        mov hRichEd, eax

        invoke SetWindowLong,hRichEd,GWL_WNDPROC,RichEdProc
        mov lpRichEd, eax

      ;edit_font equ <SYSTEM_FIXED_FONT>
      ; edit_font equ <ANSI_FIXED_FONT>
        invoke GetStockObject, SYSTEM_FIXED_FONT
        invoke SendMessage,hRichEd,WM_SETFONT,eax,0

        invoke SendMessage, hRichEd, EM_SETEDITSTYLE, SES_EMULATESYSEDIT, 0
        invoke SendMessage, hRichEd, EM_SETTEXTMODE, TM_PLAINTEXT or \
            TM_MULTILEVELUNDO or TM_MULTICODEPAGE, 0
        invoke SendMessage, hRichEd, EM_EXLIMITTEXT, 0, -1
        invoke CreateStatusWindow, WS_CHILD or WS_VISIBLE or \
                                   SBS_SIZEGRIP,0, hWin, 200
        mov hStatus, eax

        mov tba.hInst, HINST_COMMCTRL
        mov tba.nID, 2   ; btnsize 1=big 2=small
        invoke SendMessage,hToolBar,TB_ADDBITMAP,1,ADDR tba

        invoke CreateToolbarEx,hWin,WS_CHILD or WS_CLIPSIBLINGS or \
            TBSTYLE_FLAT or WS_VISIBLE, 300,17,HINST_COMMCTRL,
            IDB_STD_SMALL_COLOR,ADDR tbb, 17,16,16,0,0,sizeof(TBBUTTON)
        mov hToolBar, eax
        
        invoke SendMessage, hStatus, SB_SETTEXT, 0 or SBT_NOBORDERS, NULL
        invoke SendMessage, hStatus, SB_SETTEXT, 1 or 0, NULL
        invoke SendMessage, hStatus, SB_SETTEXT, 2 or 0, NULL
        invoke SendMessage, hStatus, SB_SETTEXT, 3 or 0, NULL
        invoke SendMessage, hWin, WM_COMMAND, IDM_SELECTION, 0
    .elseif uMsg == WM_SETFOCUS
        invoke SetFocus, hRichEd
    .elseif uMsg == WM_SIZE
        invoke ShowWindow, hRichEd, SW_HIDE
        invoke GetWindowRect, hToolBar, addr rc
        invoke SendMessage, hToolBar, TB_AUTOSIZE, 0, 0
        invoke MoveWindow, hStatus, 0, 0, 0, 0, TRUE
    
        invoke IsWindowVisible, hToolBar
        .if eax == 0
            mov tHeight, 0
        .else
            invoke GetWindowRect, hToolBar, addr rc
            mov eax, rc.bottom
            sub eax, 3
            sub eax, rc.top
            mov tHeight, eax
        .endif
    
        invoke IsWindowVisible, hStatus
        .if eax == 0
            mov sHeight, 0
        .else
            invoke GetWindowRect, hStatus, addr rc
            mov eax, rc.bottom
            sub eax, rc.top
            mov sHeight, eax
    
            invoke GetClientRect, hWin, addr rc
            mov eax, rc.right
            sub eax, rc.left
            .if wParam == SIZE_MAXIMIZED
                sub eax, 175
            .else
                sub eax, 192
            .endif
            mov [sbParts +  0],  eax	; msg
            add eax, 115
            mov [sbParts +  4],  eax	; Ln 1
            add eax, 30
            mov [sbParts +  8],  eax	; Col 1
            add eax, 30
            mov [sbParts +  12], eax	; Col 1
    
            invoke SendMessage, hStatus, SB_SETPARTS, 4, addr sbParts
        .endif
    
        invoke GetClientRect, hWin, addr rc
        mov eax, rc.bottom
        sub eax, tHeight
        sub eax, sHeight
    
        invoke MoveWindow, hRichEd, 0, tHeight, rc.right, eax, TRUE
        invoke WordWrap
        invoke ShowWindow, hRichEd, SW_SHOW
    .elseif uMsg == WM_CLOSE
            invoke Confirmation, hRichEd
            .if eax == IDYES
                invoke SendMessage, hWin, WM_COMMAND, IDM_SAVE, 0
            .elseif eax == IDNO
                jmp @F
            .elseif eax == IDCANCEL
                return 0
            .endif

            invoke SendMessage,hRichEd,EM_GETMODIFY,0,0
            .if eax == 0
            @@:
            .else
                return 0
            .endif
    .elseif uMsg == WM_DESTROY
        invoke PostQuitMessage,NULL
        return 0 
    .endif

    invoke DefWindowProc,hWin,uMsg,wParam,lParam

    ret

WndProc endp

; ########################################################################

TopXY proc wDim:DWORD, sDim:DWORD

    shr sDim, 1      ; divide screen dimension by 2
    shr wDim, 1      ; divide window dimension by 2
    mov eax, wDim    ; copy window dimension into eax
    sub sDim, eax    ; sub half win dimension from half screen dimension

return sDim

TopXY endp

; #########################################################################

RichEdMl proc a:DWORD,b:DWORD,wd:DWORD,ht:DWORD,hParent:DWORD,ID:DWORD
    invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr szREtext, 0,
        WS_VISIBLE or ES_SUNKEN or WS_CHILDWINDOW or WS_CLIPSIBLINGS or \
        ES_MULTILINE or WS_VSCROLL or ES_AUTOVSCROLL or ES_NOHIDESEL or \
        WS_HSCROLL or ES_AUTOHSCROLL or ES_DISABLENOSCROLL, a, b, wd, ht,
        hParent, ID, hInstance, NULL
    ret
RichEdMl endp

; #########################################################################

RichEdProc proc hCtl   :DWORD,
                 uMsg   :DWORD,
                 wParam :DWORD,
                 lParam :DWORD

    LOCAL pt         :POINT

    .if uMsg == WM_RBUTTONDOWN
        invoke GetMenu, hWnd
        invoke GetSubMenu, eax, 1
        mov hPopup, eax
        invoke GetCursorPos,addr pt
        invoke TrackPopupMenu, hPopup, TPM_LEFTALIGN or TPM_RIGHTBUTTON,
            pt.x, pt.y, 0, hWnd, NULL
        invoke SetFocus, hCtl
    .endif

    invoke CallWindowProc,lpRichEd,hCtl,uMsg,wParam,lParam

    ret

RichEdProc endp

; #########################################################################

ModifyControl proc
    LOCAL chrange : CHARRANGE

    invoke SendMessage, hRichEd, EM_CANUNDO, 0, 0
    .if eax == 0
        invoke EnableMenuItem, hMenu, IDM_UNDO, MF_GRAYED
        invoke SendMessage, hToolBar, TB_ENABLEBUTTON, IDM_UNDO, FALSE
    .else
        invoke EnableMenuItem, hMenu, IDM_UNDO, MF_ENABLED
        invoke SendMessage, hToolBar, TB_ENABLEBUTTON, IDM_UNDO, TRUE
    .endif

    invoke SendMessage, hRichEd, EM_CANREDO, 0, 0
    .if eax == 0
        invoke EnableMenuItem, hMenu, IDM_REDO, MF_GRAYED
        invoke SendMessage, hToolBar, TB_ENABLEBUTTON, IDM_REDO, FALSE
    .else
        invoke EnableMenuItem, hMenu, IDM_REDO, MF_ENABLED
        invoke SendMessage, hToolBar, TB_ENABLEBUTTON, IDM_REDO, TRUE
    .endif

    invoke SendMessage, hRichEd, EM_CANPASTE, 0, 0
    .if eax == 0
        invoke EnableMenuItem, hMenu, IDM_PASTE, MF_GRAYED
        invoke SendMessage, hToolBar, TB_ENABLEBUTTON, IDM_PASTE, FALSE
    .else
        invoke EnableMenuItem, hMenu, IDM_PASTE, MF_ENABLED
        invoke SendMessage, hToolBar, TB_ENABLEBUTTON, IDM_PASTE, TRUE
    .endif

    invoke SendMessage, hRichEd, EM_EXGETSEL, 0, addr chrange
    mov eax, chrange.cpMin
    .if eax == chrange.cpMax
        invoke EnableMenuItem, hMenu, IDM_COPY, MF_GRAYED
        invoke EnableMenuItem, hMenu, IDM_CUT, MF_GRAYED
        invoke EnableMenuItem, hMenu, IDM_CLEAR, MF_GRAYED
        invoke SendMessage, hToolBar, TB_ENABLEBUTTON, IDM_COPY, FALSE
        invoke SendMessage, hToolBar, TB_ENABLEBUTTON, IDM_CUT, FALSE
        invoke SendMessage, hToolBar, TB_ENABLEBUTTON, IDM_CLEAR, FALSE
    .else
        invoke EnableMenuItem, hMenu, IDM_COPY, MF_ENABLED
        invoke EnableMenuItem, hMenu, IDM_CUT, MF_ENABLED
        invoke EnableMenuItem, hMenu, IDM_CLEAR, MF_ENABLED
        invoke SendMessage, hToolBar, TB_ENABLEBUTTON, IDM_COPY, TRUE
        invoke SendMessage, hToolBar, TB_ENABLEBUTTON, IDM_CUT, TRUE
        invoke SendMessage, hToolBar, TB_ENABLEBUTTON, IDM_CLEAR, TRUE
    .endif

    .if hSelectBar == 1
        invoke CheckMenuItem, hMenu, IDM_SELECTION, MF_CHECKED
    .else
        invoke CheckMenuItem, hMenu, IDM_SELECTION, MF_UNCHECKED
    .endif

    .if hSaveDos == 1
        invoke CheckMenuItem, hMenu, IDM_SAVEDOS, MF_CHECKED
        invoke CheckMenuItem, hMenu, IDM_SAVEUNIX, MF_UNCHECKED
    .else
        invoke CheckMenuItem, hMenu, IDM_SAVEDOS, MF_UNCHECKED
        invoke CheckMenuItem, hMenu, IDM_SAVEUNIX, MF_CHECKED
    .endif

    .if hWrap == 1
        invoke CheckMenuItem, hMenu, IDM_WORDWRAP, MF_CHECKED
    .else
        invoke CheckMenuItem, hMenu, IDM_WORDWRAP, MF_UNCHECKED
    .endif

    invoke IsWindowVisible, hStatus
    .if eax == 0
        invoke CheckMenuItem, hMenu, IDM_STATUS, MF_UNCHECKED
    .else
        invoke CheckMenuItem, hMenu, IDM_STATUS, MF_CHECKED
    .endif

    invoke IsWindowVisible, hToolBar
    .if eax == 0
        invoke CheckMenuItem, hMenu, IDM_TOOL, MF_UNCHECKED
    .else
        invoke CheckMenuItem, hMenu, IDM_TOOL, MF_CHECKED
    .endif

    return 0
ModifyControl endp

; #########################################################################

WordWrap proc
    .if hWrap == 0
        invoke SendMessage, hRichEd, EM_SETTARGETDEVICE, NULL, 1
        invoke ShowScrollBar, hRichEd, SB_HORZ, TRUE
    .else
        invoke SendMessage, hRichEd, EM_SETTARGETDEVICE, NULL, 0
        invoke ShowScrollBar, hRichEd, SB_HORZ, FALSE
    .endif

    ret
WordWrap endp

; #########################################################################

SetTitle proc
    invoke StrLen, addr szFileName
    .if eax == 0
        invoke lstrcpy, addr szDisplayName, addr szUntitled
    .else
        invoke lstrcpy, addr szDisplayName, addr szFileName
    .endif

    invoke SendMessage, hRichEd, EM_GETMODIFY, 0, 0
    .if eax == 0
        invoke szCatStr, addr szDisplayName, addr szClean
    .else
        invoke szCatStr, addr szDisplayName, addr szDirty
    .endif

    invoke szCatStr, addr szDisplayName, addr szKanmia

    invoke GetWindowText, hWnd, addr szBuffer, MAX_SIZE
    invoke lstrcmp, addr szBuffer, addr szDisplayName
    .if eax != 0
        invoke SetWindowText, hWnd, addr szDisplayName
    .endif

    return 0
SetTitle endp

; ########################################################################

GetFileName proc hParent:DWORD,lpTitle:DWORD,lpFilter:DWORD
    mov szBuffer[0],0
    mov ofn.lStructSize,        sizeof OPENFILENAME
    m2m ofn.hWndOwner,          hParent
    m2m ofn.hInstance,          hInstance
    m2m ofn.lpstrFilter,        lpFilter
    m2m ofn.lpstrFile,          offset szBuffer
    mov ofn.nMaxFile,           sizeof szBuffer
    m2m ofn.lpstrTitle,         lpTitle
    mov ofn.Flags,              OFN_EXPLORER or OFN_FILEMUSTEXIST or \
                                OFN_LONGNAMES
    invoke GetOpenFileName,ADDR ofn
    ret
GetFileName endp

; #########################################################################

SaveFileName proc hParent:DWORD,lpTitle:DWORD,lpFilter:DWORD
    invoke lstrcpy, addr szBuffer, addr szFileName
    mov ofn.lStructSize,        sizeof OPENFILENAME
    m2m ofn.hWndOwner,          hParent
    m2m ofn.hInstance,          hInstance
    m2m ofn.lpstrFilter,        lpFilter
    m2m ofn.lpstrFile,          offset szBuffer
    mov ofn.nMaxFile,           sizeof szBuffer
    m2m ofn.lpstrTitle,         lpTitle
    mov ofn.Flags,              OFN_EXPLORER or OFN_LONGNAMES or OFN_OVERWRITEPROMPT or OFN_PATHMUSTEXIST
    invoke GetSaveFileName,ADDR ofn
    ret
SaveFileName endp

; #########################################################################

Confirmation proc hEditor:DWORD

    invoke SendMessage,hEditor,WM_GETTEXTLENGTH,0,0
      cmp eax, 0
      jne @F
      return 0
    @@:
    invoke SendMessage,hEditor,EM_GETMODIFY,0,0
      cmp eax, 0  ; zero = unmodified
      jne @F
      return 0
      @@:

    szText confirm,"Do you want to save the changes?"

    invoke MessageBox,hWnd,ADDR confirm,
                           ADDR szKanmia,
                           MB_YESNOCANCEL or MB_ICONWARNING

    ret

Confirmation endp

; #########################################################################

end start
