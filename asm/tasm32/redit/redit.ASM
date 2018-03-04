         title   Rich Text Editor
         comment "*********************************************************"
         comment "* Copyright (r) Gary T. Desrosiers, All Rights Reserved *"
         comment "*********************************************************"
         .386
         .model  flat,STDCALL
         locals
         %nolist
         include win32.inc
         include richedit.inc
         %list
GenErr   macro   Resource:req,Title:=<ERROR>,Flags:=<MB_OK or MB_ICONEXCLAMATION>
         mov     eax,Resource
         lea     ebx,Title
         mov     ecx,Flags
         call    ErrorMsg
         endm
EditMsg  macro   msg:req,wparam:=<0>,lparam:=<0>
         call    SendMessage,[hwndedit],msg,wparam,lparam
         endm
;*******************************************************************
;*  RESOURCE EQUATES                                               *
;*******************************************************************
;
; Non-menu resources
;
IDI_ICON1        equ 101 ;application icon resource id
IDR_MENU1        equ 102 ;id of menu
IDD_FIND         equ 103 ;dialog id of find dialog
IDD_FINDREPLACE  equ 104 ;dialog id of find/replace dialog
IDC_FIND         equ 105 ;find edit window in find and find/replace dialogs
IDC_CASE         equ 106 ;checkbox in find and find/replace dialogs
IDC_WORDS        equ 107 ;checkbox in find and find/replace dialogs
IDB_FIND         equ 108 ;find button in find/replace dialog
IDB_REPLACE      equ 109 ;replace button in find/replace dialog
IDB_REPLACEALL   equ 110 ;replace all button in find/replace dialog
IDC_REPLACEWITH  equ 111 ;edit window for replacement text in find/replace dlg
IDD_ABOUTBOX     equ 112 ;dialog id of about dialog
IDR_ACCEL        equ 113 ;accelerator table id
IDB_LIGHTBULB    equ 114 ;bitmap of lightbulb for tips dialog
IDD_TIP          equ 115 ;dialog id of tips dialog
IDC_BULB         equ 116 ;static control where lightbulb bitmap is blt'ed
IDC_TIPSEDIT     equ 117 ;edit window id of tips dialog
IDC_STARTUP      equ 118 ;checkbox in tips dialog
IDC_NEXTTIP      equ 119 ;next tip button in tips dialog
IDB_DYKT         equ 120 ;bitmap id of "Did You Know That..."
IDC_DYKT         equ 121 ;static control where above bitmap is blt'ed
IDB_TOOLBAR      equ 122 ;bitmap id of toolbar bitmap
ID_TOOLBAR       equ 123 ;id of toolbar
IDB_NEXTTIP      equ 124 ;id of nexttip button in tips dialog
IDD_LINENUMBER   equ 125 ;id of goto linenumber dialog
IDC_LINENUMBER   equ 126 ;id of edit ctrl in goto linenumber dialog

;
; File menu (menu 0)
;
IDM_FILE_BASE    equ 1000
IDM_NEW          equ 1001
IDM_OPEN         equ 1002
IDM_CLOSE        equ 1003
IDM_SAVE         equ 1004
IDM_SAVEAS       equ 1005
IDM_PRINT        equ 1006
IDM_SAVESETTINGS equ 1007
IDM_EXIT         equ 1008
;
; Edit menu (menu 1)
;
IDM_EDIT_BASE    equ 2000
IDM_UNDO         equ 2001
IDM_CUT          equ 2002
IDM_COPY         equ 2003
IDM_PASTE        equ 2004
IDM_DEL          equ 2005
IDM_FIND         equ 2006
IDM_FINDNEXT     equ 2007
IDM_REPLACE      equ 2008
IDM_REPLACENEXT  equ 2009
IDM_GOTOLINE     equ 2010
IDM_SELALL       equ 2011
;
; Format menu (menu 2)
;
IDM_FORMAT_BASE  equ 3000
IDM_FONT         equ 3001
IDM_BOLD         equ 3002
IDM_ITALIC       equ 3003
IDM_UNDERLINE    equ 3004
IDM_STRIKEOUT    equ 3005
IDM_LEFT         equ 3006
IDM_CENTER       equ 3007
IDM_RIGHT        equ 3008
IDM_SUPERSCRIPT  equ 3009
IDM_SUBSCRIPT    equ 3010
;
; Help menu (menu 3)
;
IDM_HELP_BASE    equ 4000
IDM_HELP         equ 4001
IDM_ABOUT        equ 4002
IDM_TIPS         equ 4003
;
; Internal (not .rc defined) resource equates
;
ID_TIMER1        equ 901
ID_STATUSBAR     equ 902
ID_EDITWINDOW    equ 903
;
; NUM_TIPS should match the number of strings defines in .rc with resource
; ids in the 20000 range
NUM_TIPS         equ 20
;
; Status bar section equates.
;
SBPART_MESSAGE1  equ 0           ;general messages
SBPART_MESSAGE2  equ 1           ;line #
SBPART_TIME      equ 2           ;time of day
SBPARTS          equ 3           ;total # parts
;
;User defined messages
;
WM_INVOKETIPS  equ WM_USER       ;sent at startup to invoke tips dlg
WM_TRACKCURSOR equ WM_USER+1     ;sent to track cursor pos of edit
WM_OPENCOMMANDARGS equ WM_USER+2 ;sent if arguments specified on cmd line
;
; RC defined error message equates
;
ERROR_CREATE_TOOLBAR          equ 30001
ERROR_CREATE_STATUSBAR        equ 30002
ERROR_ALREADY_RUNNING         equ 30003
ERROR_COULD_NOT_OPEN_FILE     equ 30004
ERROR_FILE_SIZE               equ 30005
ERROR_NOREAD                  equ 30006
ERROR_CREATE_FILE             equ 30007
ERROR_SAVE_BEFORE_QUIT        equ 30008
ERROR_FILE_MODIFIED           equ 30009
ERROR_CREATE_EDITWINDOW       equ 30010
ERROR_NOT_FOUND               equ 30011
;
; Miscellaneous Equates
;
TRUE     equ     1
FALSE    equ     0
;
;*******************************************************************
;*  DATA                                                           *
;*******************************************************************
         .data
msg      MSGSTRUCT   <?>  ;GetMessage/DispatchMessage structure
;
; Simple Text (all others are in the resource file)
;
szNULL   db      0
ttl      db      ' - Rich Text Editor',0
ttll     equ     ($-ttl)
szHelp   db      '\redit.hlp',0
class    db      'redit',0
richedit db      'RICHEDIT',0
szRichEd db      'RICHED32.DLL',0
ERROR    db      'ERROR',0
statcls  db      'msctls_statusbar32',0
szOpenTitle  db  'Open File',0
szSaveTitle  db  'Save File As',0
szFilter db      'Text Files',0,'*.txt',0,'Rich Text Files',0,'*.rtf',0,'All Files',0,'*.*',0,0
szExt    db      '*.txt',0
RTF      db      'RTF'
szSect   db      'Tip',0
szStrtup db      'Startup',0
szTipnum db      'TipNum',0
szLeft   db      'Left',0
szTop    db      'Top',0
szBottom db      'Bottom',0
szRight  db      'Right',0
szCourier db     'Courier',0
szFont   db      'Font',0
szPoint  db      'Point',0
szColor  db      'Color',0
szEffects db     'Effects',0
szMask   db      'Mask',0
szMult   db      'MultipleInstances',0
szSaveSettings db 'SaveSettings',0
szUntitled db    '(Untitled)',0
szUntitledl equ  ($-szUntitled)-1
szRedit  db      'REDIT',0
szREGSZ  db      'REG_SZ',0
;
;
tmsg     equ     $
tmsghour db      2 dup(?)
         db      ':'
tmsgmin  db      2 dup(?)
         db      ':'
tmsgsec  db      2 dup(?)
         db      ' '
tmsgampm db      '?' ;'A'/'P'
         db      'M',0
;
lmsg     db      'Line '
lmsgline db      '---- Col '
lmsgcol  db      '----',0
lmsgl    equ     ($-lmsg)
;
; Static Buffers
;
szBuf    db      256 dup(?)
szBufl   equ     ($-szBuf)-1
;
szFind   db      32 dup(0)
szFindl  equ     ($-szBuf)-1
szRep    db      32 dup(0)
szRepl   equ     ($-szRep)-1
;
szSaving db      'File modified: '
szFile   db      256 dup(0)
szFilel  equ     ($-szFile)-1
;
szError  db      256 dup(?)
szErrorl equ     ($-szError)-1
;
szWin    db      64 dup(?)
szWinl   equ     ($-szWin)-1
;
parts    dd      SBPARTS dup(0)
;
; many and assorted handles
;
newhwnd  dd      0
hwndstat dd      0
hwndtool dd      0
hwndedit dd      0
hREdDll  dd      0
hInst    dd      0
hMenu    dd      0
hAccel   dd      0
hBulb    dd      0
hDYKT    dd      0
hFile    dd      0
hReg     dd      0
;
; Misc storage
;
pw       dd      0
ph       dd      0
;
bBold    dd      MF_UNCHECKED
bItalic  dd      MF_UNCHECKED
bUnderline dd    MF_UNCHECKED
bStrikeout dd    MF_UNCHECKED
;
fFind    dd      0
;
tempword dd      0
;
xPerInch dd      0
yPerInch dd      0
;
lpType   dd      0
lpcbData dd      0
lpdwDisp dd      0
;
tb       TBBUTTON    <0,IDM_NEW,TBSTATE_ENABLED,TBSTYLE_BUTTON,?,0,0>
         TBBUTTON    <1,IDM_OPEN,TBSTATE_ENABLED,TBSTYLE_BUTTON,?,0,0>
         TBBUTTON    <2,IDM_SAVE,TBSTATE_ENABLED,TBSTYLE_BUTTON,?,0,0>
         TBBUTTON    <3,IDM_PRINT,TBSTATE_ENABLED,TBSTYLE_BUTTON,?,0,0>
         TBBUTTON    <0,0,TBSTATE_ENABLED,TBSTYLE_SEP,?,0,0>
         TBBUTTON    <4,IDM_LEFT,TBSTATE_ENABLED,TBSTYLE_BUTTON,?,0,0>
         TBBUTTON    <5,IDM_CENTER,TBSTATE_ENABLED,TBSTYLE_BUTTON,?,0,0>
         TBBUTTON    <6,IDM_RIGHT,TBSTATE_ENABLED,TBSTYLE_BUTTON,?,0,0>
         TBBUTTON    <0,0,TBSTATE_ENABLED,TBSTYLE_SEP,?,0,0>
         TBBUTTON    <7,IDM_UNDO,TBSTATE_ENABLED,TBSTYLE_BUTTON,?,0,0>
         TBBUTTON    <8,IDM_CUT,TBSTATE_ENABLED,TBSTYLE_BUTTON,?,0,0>
         TBBUTTON    <9,IDM_COPY,TBSTATE_ENABLED,TBSTYLE_BUTTON,?,0,0>
         TBBUTTON    <10,IDM_PASTE,TBSTATE_ENABLED,TBSTYLE_BUTTON,?,0,0>
         TBBUTTON    <11,IDM_DEL,TBSTATE_ENABLED,TBSTYLE_BUTTON,?,0,0>
         TBBUTTON    <0,0,TBSTATE_ENABLED,TBSTYLE_SEP,?,0,0>
         TBBUTTON    <12,IDM_BOLD,TBSTATE_ENABLED,TBSTYLE_BUTTON,?,0,0>
         TBBUTTON    <13,IDM_ITALIC,TBSTATE_ENABLED,TBSTYLE_BUTTON,?,0,0>
         TBBUTTON    <14,IDM_UNDERLINE,TBSTATE_ENABLED,TBSTYLE_BUTTON,?,0,0>
         TBBUTTON    <0,0,TBSTATE_ENABLED,TBSTYLE_SEP,?,0,0>
tbb      TBBUTTON    <15,IDM_ABOUT,TBSTATE_ENABLED,TBSTYLE_BUTTON,?,0,0>
tbbl     equ         $-tbb
;
; Structure storage
;
ofs      OFSTRUCT    <?>  ;OpenFile structure
doci     DOCINFO     <?>  ;Docinfo (printing support)
docil    equ    $-doci
ofn      OPENFILENAME <?> ;Open file common dialog structure
ofnl     equ    $-ofn
pd       PRINTDLG <?>     ;print common dialog structure
pdl      equ    $-pd
time     SYSTEMTIME  <?>  ;For GetLocalTime
rect     RECT        <?>  ;rectangle
tm       TEXTMETRIC  <?>  ;Text Metrics
ps       PAINTSTRUCT <?>  ;Paint structure used by tips dialog
wc       WNDCLASS    <?>  ;Window class (RegisterClass) structure
eStream  EDITSTREAM  <?>  ;for EM_STREAMIN/EM_STREAMOUT
charfm   CHARFORMAT  <?>  ;for EM_GETCHARFORMAT/EM_SETCHARFORMAT
charfml  equ   $-charfm
cf       CHOOSEFONT  <?> ;keep CHOOSFONT/LOGFONT together (ChooseFont comm dlg)
cfl      equ   $-cf      ;...
lf       LOGFONT     <?> ;...
lfl      equ   $-lf      ;...
pf       PARAFORMAT  <0> ;for EM_SETPARAFORMAT
pfl      equ   $-pf
ft       FINDTEXT    <?> ;for EM_EXGETSEL/EM_EXSETSEL
fr       FORMATRANGE <0> ;for EM_FORMATRANGE
;
FRSTRUC   struc          ;Find and Find/Replace dialog argument
FRText    dd   0         ;points to text to find
FRRepText dd   0         ;points to text to replace
FRFlags   dd   0         ;FR_WHOLEWORD, FR_MATCHCASE checkbox flags
FRSTRUC   ends
;
FindRepData FRSTRUC <?>
;*******************************************************************
;*  CODE                                                           *
;*******************************************************************
         .code
WinMain  proc
         call    ProcessCommandLine
         call    InitCommonControls ;Initialize the common ctrl lib
         push    offset szRichEd
         call    LoadLibrary     ;Load the RichEd32.dll
         mov     [hREdDll],eax
         call    GetModuleHandle,0 ;get hmod (in eax)
         mov     [hInst],eax     ;hInstance is same as HMODULE
findcls:
         call    FindWindow,offset class,0
         or      eax,eax
         jz      regclass
         call    RegGetInt,offset szMult,TRUE
         cmp     eax,TRUE
         je      regclass
         GenErr  ERROR_ALREADY_RUNNING,,MB_ABORTRETRYIGNORE
         cmp     eax,IDABORT
         je      end_loop
         cmp     eax,IDRETRY
         je      findcls
         ;It's IDIGNORE
regclass:
;
; Initialize the WndClass structure and register our class
;
         mov     [wc.clsStyle],CS_HREDRAW or CS_VREDRAW or CS_GLOBALCLASS
         mov     [wc.clsLpfnWndProc],offset WndProc
         mov     [wc.clsCbClsExtra],0
         mov     [wc.clsCbWndExtra],0
         mov     eax,[hInst]
         mov     [wc.clsHInstance],eax
         call    LoadIcon,eax,IDI_ICON1
         mov     [wc.clsHIcon],eax
         call    LoadCursor,0,IDC_ARROW
         mov     [wc.clsHCursor],eax
         mov     [wc.clsHbrBackground],COLOR_WINDOW+1
         mov     dword ptr [wc.clsLpszMenuName],0
         mov     dword ptr [wc.clsLpszClassName],offset class
         call    RegisterClass,offset wc
;
; Get our menu resource
;
         call    LoadMenu,[hInst],IDR_MENU1
         mov     [hMenu],eax
;
; Create the main window
;
         call    RegGetInt,offset szLeft,CW_USEDEFAULT
         mov     [rect.rcLeft],eax
         call    RegGetInt,offset szTop,CW_USEDEFAULT
         mov     [rect.rcTop],eax
         call    RegGetInt,offset szBottom,CW_USEDEFAULT
         mov     [rect.rcBottom],eax
         call    RegGetInt,offset szRight,CW_USEDEFAULT
         mov     [rect.rcRight],eax
         cmp     eax,CW_USEDEFAULT
         jne     calcwh
         mov     ebx,eax
         jmp     crewin
calcwh:  mov     eax,[rect.rcBottom]
         sub     eax,[rect.rcTop]
         mov     ebx,[rect.rcRight]
         sub     ebx,[rect.rcLeft]
crewin:  push    0               ;lpParam
         push    [hInst]         ;hInstance
         push    [hMenu]         ;menu
         push    0               ;parent hwnd
         push    eax             ;height
         push    ebx             ;width
         push    [rect.rcTop]    ;y
         push    [rect.rcLeft]   ;x
         push    WS_OVERLAPPEDWINDOW ;Style
         push    offset ttl      ;Title string
         push    offset class    ;Class name
         push    0               ;extra style
         call    CreateWindowEx
         mov     [newhwnd],eax
;
; Show the window and go into message dispatch loop
;
         call    ShowWindow,[newhwnd],SW_SHOWNORMAL
         call    UpdateWindow,[newhwnd]
         call    LoadAccelerators,[hInst],IDR_ACCEL
         mov     [hAccel],eax
msg_loop:
         call    GetMessage,offset msg,0,0,0
         cmp     ax,0
         je      end_loop
         call    TranslateAccelerator,[newhwnd],[hAccel],offset msg
         cmp     eax,0
         jne     msg_loop
         call    TranslateMessage,offset msg
         call    DispatchMessage,offset msg
         jmp     msg_loop
end_loop:
         call    ExitProcess,[msg.msgWPARAM]
WinMain  endp
Public   WinMain
;*******************************************************************
;*  WNDPROC                                                        *
;*******************************************************************
WndProc  proc    uses ebx edi esi
         arg     @@hwnd:DWORD,@@wmsg:DWORD,@@wparam:DWORD,@@lparam:DWORD
         mov     eax,[@@wmsg]
         cmp     eax,WM_TIMER
         je      wmtimer
         cmp     eax,WM_SIZE
         je      wmsize
         cmp     eax,WM_CREATE
         je      wmcreate
         cmp     eax,WM_COMMAND
         je      wmcommand
         cmp     eax,WM_DESTROY
         je      wmdestroy
         cmp     eax,WM_NOTIFY
         je      wmnotify
         cmp     eax,WM_MENUSELECT
         je      wmmenuselect
         cmp     eax,WM_INVOKETIPS
         je      wmuser
         cmp     eax,WM_SETFOCUS
         je      wmsetfocus
         cmp     eax,WM_TRACKCURSOR
         je      wmtrackcursor
         cmp     eax,WM_QUERYENDSESSION
         je      wmqueryendsession
         cmp     eax,WM_CLOSE
         je      wmclose
         cmp     eax,WM_INITMENUPOPUP
         je      wminitmenupopup
         cmp     eax,WM_OPENCOMMANDARGS
         je      doopenargs
         jmp     defwndproc

wmcommand:
         mov     edi,[@@wparam]
         and     edi,0ffffh
         cmp     edi,IDM_EDIT_BASE
         jg      wmcmd001
         cmp     edi,IDM_FILE_BASE
         jl      defwndproc
         sub     edi,IDM_FILE_BASE+1
         shl     edi,2
         jmp     offset file_tbl[edi]
file_tbl:dd      offset donew
         dd      offset doopen
         dd      offset donew
         dd      offset dosave
         dd      offset dosaveas
         dd      offset doprint
         dd      offset dosavesettings
         dd      offset doexit
wmcmd001:cmp     edi,IDM_FORMAT_BASE
         jg      wmcmd002
         sub     edi,IDM_EDIT_BASE+1
         shl     edi,2
         jmp     offset edit_tbl[edi]
edit_tbl:dd      offset doundo
         dd      offset docut
         dd      offset docopy
         dd      offset dopaste
         dd      offset dodel
         dd      offset dofind
         dd      offset dofindnext
         dd      offset doreplace
         dd      offset doreplacenext
         dd      offset dogotoline
         dd      offset doselall
wmcmd002:cmp     edi,IDM_HELP_BASE
         jg      wmcmd003
         sub     edi,IDM_FORMAT_BASE+1
         shl     edi,2
         jmp     offset frmt_tbl[edi]
frmt_tbl:dd      offset dofont
         dd      offset dobold
         dd      offset doitalic
         dd      offset dounderline
         dd      offset dostrikeout
         dd      offset doleft
         dd      offset docenter
         dd      offset doright
         dd      offset dosuperscript
         dd      offset dosubscript
wmcmd003:cmp     edi,IDM_TIPS
         jg      defwndproc
         sub     edi,IDM_HELP_BASE+1
         shl     edi,2
         jmp     offset help_tbl[edi]
help_tbl:dd      offset dohelp
         dd      offset doabout
         dd      offset dotips

dogotoline:
         call    DialogBoxParam,[hInst],IDD_LINENUMBER,[@@hwnd],offset LineNumberDlg,offset tempword
         cmp     eax,IDCANCEL
         je      return0
         mov     eax,[tempword]
         dec     eax
         EditMsg EM_LINEINDEX,eax,0
         EditMsg EM_SETSEL,eax,eax
         jmp     return0

dosavesettings:
         call    RegGetInt,offset szSaveSettings,FALSE
         xor     eax,1
         call    RegSetInt,offset szSaveSettings,eax
         jmp     return0

dosuperscript:
         EditMsg EM_GETCHARFORMAT,TRUE,<offset charfm>
         mov     [charfm.CF_dwMask],CFM_OFFSET
         mov     [charfm.CF_yOffset],50
         EditMsg EM_SETCHARFORMAT,SCF_SELECTION,<offset charfm>
         call    EnableDisableToolbar
         jmp     return0

dosubscript:
         EditMsg EM_GETCHARFORMAT,TRUE,<offset charfm>
         mov     [charfm.CF_dwMask],CFM_OFFSET
         mov     [charfm.CF_yOffset],-50
         EditMsg EM_SETCHARFORMAT,SCF_SELECTION,<offset charfm>
         call    EnableDisableToolbar
         jmp     return0

dofindnext:
         EditMsg EM_EXGETSEL,0,<offset ft.FT_chrg>
         call    Find,[@@hwnd],TRUE,[FindRepData.FRFlags],[FindRepData.FRText]
         call    EnableDisableToolbar
         jmp     return0

doreplace:
         mov     [FindRepData.FRText],offset szFind
         mov     [FindRepData.FRRepText],offset szRep
         mov     [FindRepData.FRFlags],0
         call    DialogBoxParam,[hInst],IDD_FINDREPLACE,[@@hwnd],offset FindRepDlg,offset FindRepData
         cmp     eax,IDCANCEL
         je      return0
         cmp     eax,IDB_FIND
         jne     doreplace1
         call    Find,[@@hwnd],FALSE,[FindRepData.FRFlags],[FindRepData.FRText]
         call    EnableDisableToolbar
         jmp     return0
doreplace1:
         cmp     eax,IDB_REPLACE
         jne     doreplace2
         call    Find,[@@hwnd],FALSE,[FindRepData.FRFlags],[FindRepData.FRText]
         cmp     eax,TRUE
         jne     return0
         EditMsg EM_REPLACESEL,TRUE,[FindRepData.FRRepText]
         call    GetMenu,[@@hwnd];enable the replace next command
         call    EnableMenuItem,eax,IDM_REPLACENEXT,MF_BYCOMMAND or MF_ENABLED
         call    EnableDisableToolbar
         jmp     return0
doreplace2:
         cmp     eax,IDB_REPLACEALL
         jne     return0
         call    Find,[@@hwnd],FALSE,[FindRepData.FRFlags],[FindRepData.FRText]
reploop: EditMsg EM_REPLACESEL,TRUE,[FindRepData.FRRepText]
         call    Find,[@@hwnd],TRUE,[FindRepData.FRFlags],[FindRepData.FRText]
         cmp     eax,TRUE
         je      reploop
         call    EnableDisableToolbar
         jmp     return0

doreplacenext:
         call    Find,[@@hwnd],TRUE,[FindRepData.FRFlags],[FindRepData.FRText]
         cmp     eax,TRUE
         jne     return0
         EditMsg EM_REPLACESEL,TRUE,[FindRepData.FRRepText]
         call    EnableDisableToolbar
         jmp     return0

dofind:
         mov     [FindRepData.FRText],offset szFind
         mov     [FindRepData.FRRepText],0
         mov     [FindRepData.FRFlags],0
         call    DialogBoxParam,[hInst],IDD_FIND,[@@hwnd],offset FindDlg,offset FindRepData
         cmp     eax,-1          ;canceled?
         je      return0         ;yes, then return
         call    Find,[@@hwnd],FALSE,[FindRepData.FRFlags],[FindRepData.FRText]
         call    EnableDisableToolbar
         jmp     return0

doexit:
         call    SendMessage,[@@hwnd],WM_CLOSE,0,0
         jmp     return0

donew:
         call    StartNewDocument,[@@hwnd]
         call    SetWindowText,[hwndedit],offset szNULL
         EditMsg EM_SETMODIFY,FALSE
         mov     byte ptr[szFile],0
         call    SetTitle
         jmp     return0

docopy:
         EditMsg WM_COPY
         jmp     return0

docut:
         EditMsg WM_CUT
         jmp     return0

dopaste:
         EditMsg WM_PASTE
         call    EnableDisableToolbar
         jmp     return0

dohelp:
         lea     esi,szHelp
         call    ModPath         ;help file is in windows dir
         call    WinHelp,[@@hwnd],esi,HELP_CONTENTS,0
         jmp     return0

doabout:
         push    0               ;LPARAM to pass to dialog
         push    offset AboutDlg ;DLGPROC lpDialogFunc
         push    [@@hwnd]        ;window handle of this window
         push    IDD_ABOUTBOX    ;Dialog ID
         push    [hInst]         ;Module Instance
         call    DialogBoxParam  ;Invoke Dialog
         jmp     return0

wmuser:
         call    RegGetInt,offset szStrtup,1
         cmp     eax,1           ;if he doesn't want the tips
         jne     return0         ; then bypass
dotips:
         push    0               ;LPARAM to pass to dialog
         push    offset TipsDlg  ;DLGPROC lpDialogFunc
         push    [@@hwnd]        ;window handle of this window
         push    IDD_TIP         ;Dialog ID
         push    [hInst]         ;Module Instance
         call    DialogBoxParam  ;Invoke Dialog
         jmp     return0

doopen:
;
; Call the GetOpenFileName common dialog to retrieve the path in szFile
;
         mov     ecx,ofnl
         mov     edi,offset ofn
         xor     eax,eax
         cld
         rep     stosb
         mov     [ofn.lStructSize],ofnl
         mov     eax,[@@hwnd]
         mov     [ofn.hwndOwner],eax
         mov     eax,[hInst]
         mov     [ofn.hInstance],eax
         mov     [ofn.lpstrFilter],offset szFilter
         mov     [ofn.lpstrFile],offset szFile
         mov     [ofn.nMaxFile],length szFile
         mov     [ofn.lpstrInitialDir],0
         mov     [ofn.lpstrTitle],offset szOpenTitle
         mov     [ofn.lpstrDefExt],offset szExt
         mov     [ofn.Flags],OFN_PATHMUSTEXIST or OFN_FILEMUSTEXIST
         call    GetOpenFileName,offset ofn
         cmp     eax,FALSE       ;Cancel'ed or error occurred
         je      return0
;
; Open the file and read in data
;
doopenargs:
         call    StartNewDocument,[@@hwnd]
         call    OpenFile,offset szFile,offset ofs,offset OF_READ
         cmp     eax,-1          ;error?
         jne     opnok
         GenErr  ERROR_COULD_NOT_OPEN_FILE
         jmp     return0
opnok:   mov     [hFile],eax
         mov     [eStream.ES_dwCookie],eax
         mov     [eStream.ES_pfnCallback],offset EditStreamReadCallback
         mov     [eStream.ES_dwError],0
         movsx   esi,[ofn.nFileExtension]
         add     esi,offset szFile
         call    strupr          ;convert to uppercase for compare
         lea     edi,RTF         ;open file as rich text
         mov     ecx,3           ;if it has the .rtf
         cld                     ;extension, otherwise open
         repe    cmpsb           ;it as text
         jecxz   opnrtf
         EditMsg EM_STREAMIN,SF_TEXT,<offset eStream>
         jmp     opnclos
opnrtf:  EditMsg EM_STREAMIN,SF_RTF,<offset eStream>
opnclos: call    CloseHandle,[hFile]
         EditMsg EM_SETMODIFY,FALSE
         call    SetTitle
doopenx: jmp     return0

dosave:
         mov     al,[szFile]
         cmp     al,0
         jne     dosave2
         mov     [ofn.Flags],OFN_PATHMUSTEXIST or OFN_FILEMUSTEXIST
         jmp     dosave1
dosaveas:
         mov     [ofn.Flags],OFN_OVERWRITEPROMPT or OFN_CREATEPROMPT
dosave1:
;
; Call the GetSaveFileName common dialog to determine the save path
;
         mov     ecx,ofnl
         mov     edi,offset ofn
         xor     eax,eax
         cld
         rep     stosb           ;clear the open file name structure
         mov     [ofn.lStructSize],ofnl
         mov     eax,[@@hwnd]
         mov     [ofn.hwndOwner],eax
         mov     eax,[hInst]
         mov     [ofn.hInstance],eax
         mov     [ofn.lpstrFilter],offset szFilter
         mov     [ofn.lpstrFile],offset szFile
         mov     [ofn.nMaxFile],length szFile
         mov     [ofn.lpstrInitialDir],0
         mov     [ofn.lpstrTitle],offset szSaveTitle
         mov     [ofn.lpstrDefExt],offset szExt
         call    GetSaveFileName,offset ofn
         cmp     eax,FALSE       ;Cancel'ed or error occurred
         je      return0
dosave2:
         push    0               ;template file
         push    FILE_ATTRIBUTE_NORMAL ;flags&attributes
         push    CREATE_ALWAYS   ;creation disposition
         push    0               ;security attributes
         push    FILE_SHARE_WRITE;share mode
         push    GENERIC_WRITE   ;desired access
         push    offset szFile   ;filename to create
         call    CreateFile      ;create and/or open file
         cmp     eax,-1          ;error?
         jne     savcrok
         GenErr  ERROR_CREATE_FILE
         jmp     return0
savcrok: mov     [hFile],eax
         mov     [eStream.ES_dwCookie],eax
         mov     [eStream.ES_dwError],0
         mov     [eStream.ES_pfnCallback],offset EditStreamSaveCallback
         movsx   esi,[ofn.nFileExtension]
         add     esi,offset szFile
         call    strupr          ;convert to uppercase for compare
         lea     edi,RTF
         mov     ecx,3           ;if .rtf, then save as rich text
         cld                     ;otherwise save as text
         repe    cmpsb
         jecxz   savrtf
         EditMsg EM_STREAMOUT,SF_TEXT,<offset eStream>
         jmp     savclos
savrtf:  EditMsg EM_STREAMOUT,SF_RTF,<offset eStream>
savclos: call    CloseHandle,[hFile]
         call    EnableDisableToolbar
         EditMsg EM_SETMODIFY,FALSE
         call    SetTitle
         jmp     return0

doprint:
;
; Call the PrintDlg common dialog function
;
         mov     ecx,pdl
         mov     edi,offset pd
         xor     eax,eax
         cld
         rep     stosb           ;clear the print dialog structure
         mov     [pd.pdlStructSize],pdl
         mov     eax,[@@hwnd]
         mov     [pd.pdhwndOwner],eax
         mov     eax,[hInst]
         mov     [pd.pdhInstance],eax
         mov     [pd.pdFlags],PD_RETURNDC or PD_NOSELECTION or PD_PRINTSETUP
         call    PrintDlg,offset pd
         cmp     eax,FALSE
         je      return0
         mov     [doci.cbSize],docil
         mov     [doci.lpszDocName],offset ttl
         mov     [doci.lpszOutput],0
         mov     [doci.fwType],0
         mov     eax,[pd.pdhDC]
         mov     [fr.FR_hdc],eax
         mov     [fr.FR_hdcTarget],0
         call    GetDeviceCaps,[fr.FR_hdc],LOGPIXELSX
         mov     [xPerInch],eax
         call    GetDeviceCaps,[fr.FR_hdc],LOGPIXELSY
         mov     [yPerInch],eax
         mov     [rect.rcLeft],0
         mov     [rect.rcTop],0
         call    GetDeviceCaps,[fr.FR_hdc],HORZRES
         mov     ecx,1440
         mul     ecx
         div     [xPerInch]
         mov     [rect.rcRight],eax
         call    GetDeviceCaps,[fr.FR_hdc],VERTRES
         mov     ecx,1440
         mul     ecx
         div     [yPerInch]
         mov     [rect.rcBottom],eax
         mov     ecx,16
         mov     edi,offset fr.FR_rcPage
         mov     esi,offset rect
         cld
         rep     movsb
         call    StartDoc,[pd.pdhDC],offset doci
         EditMsg WM_GETTEXTLENGTH
         mov     [fr.FR_chrg.CR_cpMax],eax
         mov     [fr.FR_chrg.CR_cpMin],0
whileloop:
         call    StartPage,[pd.pdhDC]
         cmp     eax,0
         jle     prtabort
         mov     ecx,16
         mov     esi,offset rect
         mov     edi,offset fr.FR_rc
         cld
         rep     movsb
         EditMsg EM_FORMATRANGE,TRUE,<offset fr>
         mov     [fr.FR_chrg.CR_cpMin],eax
         call    EndPage,[pd.pdhDC]
         cmp     eax,0
         jle     prtabort
         mov     eax,[fr.FR_chrg.CR_cpMin]
         cmp     eax,0
         jle     whiledone
         cmp     eax,[fr.FR_chrg.CR_cpMax]
         jl      whileloop
whiledone:
         EditMsg EM_FORMATRANGE,0,0
         call    EndDoc,[pd.pdhDC]
         call    DeleteDC,[pd.pdhDC]
         jmp     return0
prtabort:
         call    AbortDoc,[fr.FR_hdc]
         jmp     return0


dodel:
         EditMsg WM_KEYDOWN,VK_DELETE
         call    EnableDisableToolbar
         jmp     return0

doselall:
         EditMsg EM_SETSEL,0,-1
         call    EnableDisableToolbar
         jmp     return0

doundo:
         EditMsg WM_UNDO
         call    EnableDisableToolbar
         jmp     return0

dofont:
         mov     edi,offset cf
         xor     eax,eax
         mov     ecx,cfl+lfl
         cld
         rep     scasb           ;clear structures
;
; First, fill in the CHOOSEFONT/LOGFONT structure with the attributes
; of the current char/selection so that the ChooseFont dialog will
; reflect the selections correct attributes
;
         EditMsg EM_GETCHARFORMAT,TRUE,<offset charfm>
         call    GetDC,[@@hwnd]
         push    eax
         call    GetDeviceCaps,eax,LOGPIXELSY
         mov     [tempword],eax
         pop     eax
         call    ReleaseDC,[@@hwnd],eax
         mov     eax,[charfm.CF_yHeight]
         mul     [tempword]
         mov     ecx,1440
         div     ecx
         neg     eax
         mov     [lf.lfHeight],eax
         mov     [lf.lfWeight],FW_NORMAL
         test    [charfm.CF_dwEffects],CFE_BOLD
         jz      @@1
         mov     [lf.lfWeight],FW_BOLD
@@1:     mov     [lf.lfItalic],FALSE
         test    [charfm.CF_dwEffects],CFE_ITALIC
         jz      @@2
         mov     [lf.lfItalic],TRUE
@@2:     mov     [lf.lfUnderline],FALSE
         test    [charfm.CF_dwEffects],CFE_UNDERLINE
         jz      @@3
         mov     [lf.lfUnderline],TRUE
@@3:     mov     [lf.lfStrikeOut],FALSE
         test    [charfm.CF_dwEffects],CFE_STRIKEOUT
         jz      @@4
         mov     [lf.lfStrikeOut],TRUE
@@4:     mov     al,[charfm.CF_bCharSet]
         mov     [lf.lfCharSet],al
         mov     al,[charfm.CF_bPitchAndFamily]
         mov     [lf.lfPitchAndFamily],al
         mov     eax,[charfm.CF_crTextColor]
         mov     [cf.CF_rgbColors],eax
         mov     esi,offset charfm.CF_szFaceName
         call    strlen
         inc     ecx
         mov     edi,offset lf.lfFaceName
         cld
         rep     movsb
         mov     [cf.CF_lStructSize],cfl
         mov     eax,[@@hwnd]
         mov     [cf.CF_hwndOwner],eax
         mov     [cf.CF_lpLogFont],offset lf
         mov     [cf.CF_Flags],CF_SCREENFONTS or CF_INITTOLOGFONTSTRUCT or CF_FORCEFONTEXIST or CF_EFFECTS
         call    ChooseFont,offset cf ;Invoke common ChooseFont dialog
         cmp     eax,FALSE
         je      return0
;
; Now, fill in the CHARFORMAT structure from the CHOOSEFONT and LOGFONT
; structures before changing the current char/selection's attributes thru
; a call to EM_SETCHARFORMAT
;
         mov     [charfm.CF_cbSize],charfml
         EditMsg EM_GETCHARFORMAT,TRUE,<offset charfm>
         mov     [charfm.CF_dwEffects],0 ;reset the effects, they will all be specified
         or      [charfm.CF_dwMask],CFM_STRIKEOUT
         mov     al,[lf.lfStrikeOut]
         cmp     al,FALSE
         je      nostrik
         or      [charfm.CF_dwEffects],CFE_STRIKEOUT
nostrik: or      [charfm.CF_dwMask],CFM_ITALIC
         mov     al,[lf.lfItalic]
         cmp     al,FALSE
         je      noital
         or      [charfm.CF_dwEffects],CFE_ITALIC
noital:  or      [charfm.CF_dwMask],CFM_UNDERLINE
         mov     al,[lf.lfUnderline]
         cmp     al,FALSE
         je      nounder
         xor     [charfm.CF_dwEffects],CFE_UNDERLINE
nounder: or      [charfm.CF_dwMask],CFM_BOLD
         mov     eax,[lf.lfWeight]
         cmp     eax,FW_BOLD         ;400 = FW_NORMAL 700 = FW_BOLD
         jl      nobold
         or      [charfm.CF_dwEffects],CFE_BOLD
nobold:  mov     eax,[cf.CF_rgbColors]
         mov     [charfm.CF_crTextColor],eax
         mov     al,[lf.lfCharSet]
         mov     [cf.CF_bCharSet],al
         mov     al,[lf.lfPitchAndFamily]
         mov     [cf.CF_bPitchAndFamily],al
         or      [charfm.CF_dwMask],CFM_FACE or CFM_SIZE or CFM_COLOR
         mov     eax,[cf.CF_iPointSize]
         shl     eax,1             ;convert from 1/10 pt to twips (which is points*20)
         mov     [charfm.CF_yHeight],eax
         mov     esi,offset lf.lfFaceName
         call    strlen          ;length of facename string in ecx
         mov     edi,offset charfm.CF_szFaceName
         inc     ecx             ;move ending null too
         cld
         rep     movsb           ;move facename from LOGFONT to CHARFORMAT
         EditMsg EM_SETCHARFORMAT,SCF_SELECTION,<offset charfm>
         jmp     return0

dobold:
         mov     [charfm.CF_cbSize],charfml
         EditMsg EM_GETCHARFORMAT,TRUE,<offset charfm>
         mov     eax,[charfm.CF_dwEffects]
         xor     eax,CFE_BOLD
         mov     [charfm.CF_dwEffects],eax
         EditMsg EM_SETCHARFORMAT,SCF_SELECTION,<offset charfm>
         call    EnableDisableToolbar
         jmp     return0

doitalic:
         mov     [charfm.CF_cbSize],charfml
         EditMsg EM_GETCHARFORMAT,TRUE,<offset charfm>
         mov     eax,[charfm.CF_dwEffects]
         xor     eax,CFE_ITALIC
         mov     [charfm.CF_dwEffects],eax
         EditMsg EM_SETCHARFORMAT,SCF_SELECTION,<offset charfm>
         call    EnableDisableToolbar
         jmp     return0

dounderline:
         mov     [charfm.CF_cbSize],charfml
         EditMsg EM_GETCHARFORMAT,TRUE,<offset charfm>
         mov     eax,[charfm.CF_dwEffects]
         xor     eax,CFE_UNDERLINE
         mov     [charfm.CF_dwEffects],eax
         EditMsg EM_SETCHARFORMAT,SCF_SELECTION,<offset charfm>
         call    EnableDisableToolbar
         jmp     return0

dostrikeout:
         mov     [charfm.CF_cbSize],charfml
         EditMsg EM_GETCHARFORMAT,TRUE,<offset charfm>
         mov     eax,[charfm.CF_dwEffects]
         xor     eax,CFE_STRIKEOUT
         mov     [charfm.CF_dwEffects],eax
         EditMsg EM_SETCHARFORMAT,SCF_SELECTION,<offset charfm>
         call    EnableDisableToolbar
         jmp     return0

doleft:
         mov     [pf.PF_cbSize],pfl
         mov     [pf.PF_dwMask],PFM_ALIGNMENT
         mov     [pf.PF_wAlignment],PFA_LEFT
         EditMsg EM_SETPARAFORMAT,0,<offset pf>
         call    EnableDisableToolbar
         jmp     return0

docenter:
         mov     [pf.PF_cbSize],pfl
         mov     [pf.PF_dwMask],PFM_ALIGNMENT
         mov     [pf.PF_wAlignment],PFA_CENTER
         EditMsg EM_SETPARAFORMAT,0,<offset pf>
         call    EnableDisableToolbar
         jmp     return0

doright:
         mov     [pf.PF_cbSize],pfl
         mov     [pf.PF_dwMask],PFM_ALIGNMENT
         mov     [pf.PF_wAlignment],PFA_RIGHT
         EditMsg EM_SETPARAFORMAT,0,<offset pf>
         call    EnableDisableToolbar
         jmp     return0


wminitmenupopup:
         mov     eax,[@@lparam]
         cmp     eax,0           ;index 0 = file menu
         je      Menu0_File
         cmp     eax,1           ;index 1 = edit menu
         je      Menu1_Edit
         cmp     eax,2           ;index 2 = format menu
         je      Menu2_Format
         jmp     return0
Menu0_File:
         call    RegGetInt,offset szSaveSettings,FALSE
         mov     ebx,MF_UNCHECKED
         cmp     eax,FALSE
         je      Menu0
         mov     ebx,MF_CHECKED
Menu0:   call    CheckMenuItem,[@@wparam],IDM_SAVESETTINGS,ebx
         jmp     return0

Menu1_Edit:
         call    EnableDisableEditMenu,[@@wparam]
         call    EnableDisableToolbar
         jmp     return0
Menu2_Format:
         call    UpdateFormatMenuItems,[@@hwnd]
         jmp     return0


wmsetfocus:
         test    [hwndedit],-1
         jz      focus1
         call    SetFocus,[hwndedit]
         jmp     return0
focus1:  call    SetFocus,[@@hwnd]
         jmp     return0

wmnotify:
         mov     ebx,[@@lparam]    ;get pointer to NMHDR
         mov     eax,[(NMHDR ptr ebx).code]
         cmp     eax,TTN_NEEDTEXT
         je      ttnneedtext
         cmp     eax,TBN_QUERYDELETE
         je      tbnquerydelete
         cmp     eax,TBN_GETBUTTONINFO
         je      tbngetbuttoninfo
         cmp     eax,TBN_QUERYINSERT
         je      tbnqueryinsert
         cmp     eax,TBN_TOOLBARCHANGE
         je      tbntoolbarchange
         cmp     eax,EN_MSGFILTER
         je      enmsgfilter
         cmp     eax,EN_SELCHANGE
         je      enselchange
         cmp     eax,EN_DROPFILES
         je      endropfiles
         jmp     defwndproc

endropfiles:
         mov     ebx,[@@lparam]  ;address of ENDROPFILES structure
         call    DragQueryFile,[(ENDROPFILES ptr ebx).DF_hDrop],0,offset szFile,szFilel
         cmp     eax,0           ;Chars from DragQueryFile <= 0
         jle     return0         ;return 0 to ignore the drop
         call    PostMessage,[@@hwnd],WM_OPENCOMMANDARGS,0,0 ;open droped file
         jmp     return1         ;return 1 to accept the drop

enmsgfilter:
         mov     ebx,[@@lparam]    ;get pointer to msgfilter
         mov     eax,[(MSGFILTER ptr ebx).MF_msg]
         cmp     eax,WM_MOUSEMOVE
         je      return0          ;dont want these
enselchange:
         call    PostMessage,[@@hwnd],WM_TRACKCURSOR,0,0
         call    SetTitle
         jmp     return0

tbnquerydelete:
         jmp     return1

tbngetbuttoninfo:
         jmp     return0

tbnqueryinsert:
         jmp     return1

tbncusthelp:
         jmp     defwndproc

tbntoolbarchange:
;tell the toolbar to size itself
         call    SendMessage,[hwndtool],TB_AUTOSIZE,0,0
         jmp     defwndproc

ttnneedtext:
         mov     eax,[(NMHDR ptr ebx).idFrom] ;resource id
         ;Load the tip from STRINGTABLE
         call    LoadString,[hInst],eax,offset szBuf,szBufl
         mov     ebx,[@@lparam]    ;now just give him our buffer addr.
         mov     [(TOOLTIPTEXT ptr ebx).lpszText],offset szBuf
         jmp     return0

wmcreate:
;
; Create an EDIT window
;
         push    0               ;lpParam
         push    [hInst]         ;hInstance
         push    ID_EDITWINDOW   ;edit window id
         push    [@@hwnd]        ;parent hwnd
         push    0               ;height
         push    0               ;width
         push    0               ;y
         push    0               ;x
         push    WS_CHILD or WS_VISIBLE or ES_WANTRETURN or ES_SAVESEL or ES_MULTILINE or WS_VSCROLL or WS_HSCROLL or ES_AUTOVSCROLL
         push    offset szNULL   ;Title string
         push    offset richedit ;Class name
         push    WS_EX_CLIENTEDGE;extra style
         call    CreateWindowEx
         cmp     eax,0           ;Create go ok?
         jne     edcreatok       ;yes continue
         GenErr  ERROR_CREATE_EDITWINDOW
         jmp     wmcrexit
edcreatok:
         mov     [hwndedit],eax
;
; tell edit window what notifications to send
;
         EditMsg EM_SETEVENTMASK,0,<ENM_CHANGE or ENM_SELCHANGE or ENM_MOUSEEVENTS or ENM_KEYEVENTS or ENM_DROPFILES>
;
; Tell edit window to accept drops
;
         call    DragAcceptFiles,[hwndedit],TRUE
;
; Create the status bar window
;
         mov     [hwndstat],0    ;zero handle
         push    0               ;lpParam
         push    [hInst]         ;hInstance
         push    ID_STATUSBAR    ;menu
         push    [@@hwnd]        ;parent hwnd
         push    0               ;height
         push    0               ;width
         push    0               ;y
         push    0               ;x
         push    WS_CHILD or WS_BORDER or WS_VISIBLE or SBS_SIZEGRIP ;style
         push    offset szNULL   ;Title string is null
         push    offset statcls  ;Use the new STATUSCLASSNAME
         push    0               ;extra style
         call    CreateWindowEx
         cmp     eax,0           ;Create go ok?
         jne     creatok         ;yes continue
         GenErr  ERROR_CREATE_STATUSBAR
         jmp     wmcrexit
creatok:
         mov     [hwndstat],eax  ;save the handle to statusbar
;
; Now create the toolbar
;
	     call    CreateToolbarEx,[@@hwnd],WS_CHILD or WS_BORDER or WS_VISIBLE or TBSTYLE_TOOLTIPS or CCS_ADJUSTABLE,ID_TOOLBAR,16,[hInst],IDB_TOOLBAR,offset tb,20,16,15,16,15,20
         cmp     eax,0           ;handle null?
         jne     tbok            ;no, then toolbar created
         GenErr  ERROR_CREATE_TOOLBAR
         jmp     wmcrexit
tbok:
         mov     [hwndtool],eax  ;save the handle to toolbar
;
; Post message to do tips dialog
;
         call    PostMessage,[@@hwnd],WM_INVOKETIPS,0,0
;
; Enable or disable the toolbar buttons
;
         call    EnableDisableToolbar
;
; Determine state of initial document; new or open file specified as arg
;
         test    [szFile],0ffh
         jz      wmcrnew
         call    PostMessage,[@@hwnd],WM_OPENCOMMANDARGS,0,0
         jmp     wmcrargs
wmcrnew:
         call    PostMessage,[@@hwnd],WM_COMMAND,IDM_NEW,0
wmcrargs:
;
; Finally, setup timer
;
         call    SetTimer,[@@hwnd],ID_TIMER1,100,0 ;timer every second
wmcrexit:
         jmp     return0


wmtimer:
         cmp     [@@wparam],ID_TIMER1 ;is it our timer?
         jne     wmtimex         ;no, then exit
         call    fmtime          ;format and display the time
wmtimex: jmp     return0

wmdestroy:
         call    KillTimer,[@@hwnd],ID_TIMER1
         push    [hREdDll]
         call    FreeLibrary
         call    RegGetInt,offset szSaveSettings,FALSE
         cmp     eax,FALSE
         je      wmdestroyx
         EditMsg EM_GETCHARFORMAT,TRUE,<offset charfm>
         call    RegCreateKeyEx,HKEY_CURRENT_USER,offset szRedit,0,offset szREGSZ,0,KEY_ALL_ACCESS,0,offset hReg,offset lpdwDisp
         mov     esi,offset charfm.CF_szFaceName
         call    strlen
         mov     [lpcbData],ecx
         call    RegSetValueEx,[hReg],offset szFont,0,REG_SZ,offset charfm.CF_szFaceName,[lpcbData]
         call    RegCloseKey,[hReg]
         call    RegSetInt,offset szColor,[charfm.CF_crTextColor]
         call    RegSetInt,offset szPoint,[charfm.CF_yHeight]
         call    GetWindowRect,[newhwnd],offset rect
         call    RegSetInt,offset szLeft,[rect.rcLeft]
         call    RegSetInt,offset szRight,[rect.rcRight]
         call    RegSetInt,offset szTop,[rect.rcTop]
         call    RegSetInt,offset szBottom,[rect.rcBottom]
         call    RegSetInt,offset szMask,[charfm.CF_dwMask]
         call    RegSetInt,offset szEffects,[charfm.CF_dwEffects]
wmdestroyx:
         call    PostQuitMessage,0
         jmp     return0

wmsize:
         cmp     [hwndstat],0    ;is status valid?
         jz      wmsizex         ;no, then exit
         mov     eax,[@@lparam]  ;height/width of new window
         mov     ebx,eax
         and     ebx,0000ffffh   ;ebx = LOWORD(lparam) = width
         shr     eax,16          ;eax = HIWORD(lparam) = height
         push    TRUE            ;repaint is true
         push    eax             ;height
         push    ebx             ;width
         push    eax             ;y
         push    0               ;x
         push    [hwndstat]      ;handle to statusbar
         call    MoveWindow      ;adjust window
         mov     eax,[@@lparam]  ;get width
         cwde                    ;lowword
         shr     eax,2           ;/4
         mov     ecx,eax         ;save factor
         add     eax,ecx
         mov     [parts],eax     ;make part 1 1/4 the width
         add     eax,ecx
         mov     [parts+4],eax   ;and also part2, .. etc
         add     eax,ecx
         mov     [parts+8],-1    ;the last part extends to the end
         call    SendMessage,[hwndstat],SB_SETPARTS,SBPARTS,offset parts
         cmp     [hwndtool],0    ;is there a valid toolbar?
         jz      wmsizex         ;no, then exit
         call    SendMessage,[hwndtool],TB_AUTOSIZE,0,0
;
; move and size the EDIT window
;

         call    GetWindowRect,[hwndtool],offset rect ;rectangle of toolbar
         mov     eax,[rect.rcBottom]
         sub     eax,[rect.rcTop]
         push    eax              ;save height of toolbar
         call    GetWindowRect,[hwndstat],offset rect ;rectangle of statusbar
         mov     eax,[rect.rcBottom]
         sub     eax,[rect.rcTop];eax = height of statusbar
         pop     edx             ;edx = height of toolbar
         mov     ebx,[@@lparam]  ;width of new client area
         and     ebx,0ffffh      ;ebx = width
         mov     ecx,[@@lparam]
         shr     ecx,16          ;height of new client area
         sub     ecx,eax         ;edit window - size of statusbar
         sub     ecx,edx         ; and - size of toolbar
         push    TRUE            ;repaint is true
         push    ecx             ;height
         push    ebx             ;width
         push    edx             ;y
         push    0               ;x
         push    [hwndedit]      ;handle to statusbar
         call    MoveWindow      ;adjust window
wmsizex: jmp     return0

wmmenuselect:
         mov     eax,[@@wparam]
         and     eax,0ffff0000h
         cmp     eax,0ffff0000h  ;special case, menu canceled
         jne     wmms1
         mov     eax,[@@lparam]
         cmp     eax,0
         jne     wmms1
         mov     byte ptr[szBuf],0 ;clear status area when exit from menu
         jmp     wmms2
wmms1:   mov     eax,[@@wparam]
         cwde
         add     eax,10000       ;resource base #
         call    LoadString,[hInst],eax,offset szBuf,szBufl
         cmp     eax,0
         jne     wmms2
         push    offset szNULL
         jmp     wmms3
wmms2:   push    offset szBuf
wmms3:   push    SBPART_MESSAGE1
         push    SB_SETTEXT
         push    [hwndstat]
         call    SendMessage
         jmp     return0

wmtrackcursor:
         EditMsg EM_GETSEL
         push    eax
         EditMsg EM_LINEINDEX,-1
         pop     ecx
         sub     ecx,eax
         inc     ecx
         push    ecx
         EditMsg EM_LINEFROMCHAR,eax
         inc     eax             ;1-relative
         mov     [tempword],eax
         lea     ebx,tempword
         lea     edx,lmsgline
         mov     ecx,4
         call    cvdec
         pop     [tempword]
         lea     ebx,tempword
         lea     edx,lmsgcol
         mov     ecx,4
         call    cvdec
         call    SendMessage,[hwndstat],SB_SETTEXT,SBPART_MESSAGE2,offset lmsg
         call    EnableDisableToolbar
         jmp     return0

wmclose:
         call    CheckSav,[@@hwnd]
         cmp     eax,IDCANCEL
         je      return0
         call    DestroyWindow,[hwndedit]
         call    DestroyWindow,[@@hwnd]
         jmp     return0

wmqueryendsession:
         call   CheckSav,[@@hwnd]
         cmp    eax,IDCANCEL
         je     return0
         jmp    return1

defwndproc:
         call    DefWindowProc,[@@hwnd],[@@wmsg],[@@wparam],[@@lparam]
         jmp     finish

return1: mov     eax,1
         jmp     finish
return0: xor     eax,eax
finish:  ret
WndProc  endp
public   WndProc

;*******************************************************************
;*  FIND dialog proc                                               *
;*******************************************************************
FindDlg  proc    uses ebx edi esi
         arg     @@hdlg:DWORD,@@wmsg:DWORD,@@wparam:DWORD,@@lparam:DWORD
         LOCAL   hEdit:DWORD
         cmp     [@@wmsg],WM_INITDIALOG ;if message is INITDIALOG then
         je      FindDlgInit
         cmp     [@@wmsg],WM_COMMAND
         je      FindDlgCmd
         jmp     FindDlgDone
FindDlgInit:
         mov     eax,[@@lparam]  ;save off address of
         mov     [tempword],eax  ;structure
         call    GetDlgItem,[@@hdlg],IDC_FIND ;get handle of edit box
		 mov	 [hEdit],eax     ;save for further operations
         call    SetFocus,eax    ;set focus to this field
         call    SendMessage,[hEdit],EM_LIMITTEXT,32,0 ;limit text size
         mov     ebx,[tempword]
         mov     eax,[(FRSTRUC ptr ebx).FRText]
         call    SetDlgItemText,[@@hdlg],IDC_FIND,eax
		 call    SendMessage,[hEdit],EM_SETSEL,0,-1 ;select text
         mov     eax,[@@hdlg]
         call    CenterWindow
         mov     eax,FALSE       ;FALSE because we set the focus
         jmp     FindDlgRet      ;go and return
FindDlgCmd:
         mov     eax,[@@wparam]  ;Otherwise, see if it's OK or CANCEL
         cmp     eax,IDCANCEL    ;That was pressed
         je      FindEnd         ;and if not either of these
         cmp     eax,IDOK        ;then just
         jne     FindDlgDone     ;return
         mov     ebx,[tempword]  ;get address of structure
         mov     eax,[(FRSTRUC ptr ebx).FRText]
         call    GetDlgItemText,[@@hdlg],IDC_FIND,eax,32 ;Get the text stored in edit
         call    IsDlgButtonChecked,[@@hdlg],IDC_WORDS
         mov     ebx,[tempword]
         shl     eax,FR_WHOLEWORD-1
         mov     [(FRSTRUC ptr ebx).FRFlags],eax
         call    IsDlgButtonChecked,[@@hdlg],IDC_CASE
         mov     ebx,[tempword]
         shl     eax,FR_MATCHCASE-1
         or      [(FRSTRUC ptr ebx).FRFlags],eax
FindEnd: call    EndDialog,[@@hdlg],[@@wparam] ;end the dialog with wparam as return
         mov     eax,TRUE        ;return
         jmp     FindDlgRet      ;with TRUE
FindDlgDone:
         mov     eax,FALSE       ;return with FALSE
FindDlgRet:
         ret                     ;return
FindDlg  endp
public   FindDlg

;*******************************************************************
;*  Goto LineNumber Dialog proc                                    *
;*******************************************************************
LineNumberDlg  proc    uses ebx edi esi
         arg     @@hdlg:DWORD,@@wmsg:DWORD,@@wparam:DWORD,@@lparam:DWORD
         cmp     [@@wmsg],WM_INITDIALOG ;if message is INITDIALOG then
         je      LineNumberInit
         cmp     [@@wmsg],WM_COMMAND
         je      LineNumberCmd
         jmp     LineNumberDone
LineNumberInit:
         call    GetDlgItem,[@@hdlg],IDC_LINENUMBER ;get handle of edit box
         push    eax             ;save handle of edit1
         call    SetFocus,eax    ;set focus to this field
         pop     eax
         call    SendMessage,eax,EM_LIMITTEXT,32,0 ;limit text size
         mov     eax,[@@hdlg]
         call    CenterWindow
         mov     eax,FALSE       ;FALSE because we set the focus
         jmp     LineNumberRet   ;go and return
LineNumberCmd:
         mov     eax,[@@wparam]  ;Otherwise, see if it's OK or CANCEL
         cmp     eax,IDCANCEL    ;That was pressed
         je      LineNumberEnd   ;and if not either of these
         cmp     eax,IDOK        ;then just
         jne     LineNumberDone  ;return
         call    GetDlgItemInt,[@@hdlg],IDC_LINENUMBER,0,FALSE
         mov     [tempword],eax  ;save new number
LineNumberEnd:
         call    EndDialog,[@@hdlg],[@@wparam] ;end the dialog with wparam as return
         mov     eax,TRUE        ;return
         jmp     FindDlgRet      ;with TRUE
LineNumberDone:
         mov     eax,FALSE       ;return with FALSE
LineNumberRet:
         ret                     ;return
LineNumberDlg  endp
public   LineNumberDlg

;*******************************************************************
;*  Find / Replace dialog proc                                     *
;*******************************************************************
FindRepDlg proc    uses ebx edi esi
         arg     @@hdlg:DWORD,@@wmsg:DWORD,@@wparam:DWORD,@@lparam:DWORD
         cmp     [@@wmsg],WM_INITDIALOG ;if message is INITDIALOG then
         je      FRDlgInit
         cmp     [@@wmsg],WM_COMMAND
         je      FRDlgCmd
         jmp     FRDlgDone
FRDlgInit:
         mov     eax,[@@lparam]    ;save off address of
         mov     [tempword],eax  ;buffer
         call    GetDlgItem,[@@hdlg],IDC_FIND ;get handle of edit box
         push    eax             ;save handle of edit1
         call    SetFocus,eax    ;set focus to this field
         pop     eax
         call    SendMessage,eax,EM_LIMITTEXT,32,0 ;limit text size
         call    GetDlgItem,[@@hdlg],IDC_REPLACEWITH
         call    SendMessage,eax,EM_LIMITTEXT,32,0 ;limit text size
         mov     ebx,[tempword]
         mov     eax,[(FRSTRUC ptr ebx).FRText]
         call    SetDlgItemText,[@@hdlg],IDC_FIND,eax
         mov     ebx,[tempword]
         mov     eax,[(FRSTRUC ptr ebx).FRRepText]
         call    SetDlgItemText,[@@hdlg],IDC_REPLACEWITH,eax
         mov     eax,[@@hdlg]
         call    CenterWindow
         mov     eax,FALSE       ;FALSE because we set the focus
         jmp     FRDlgRet      ;go and return
FRDlgCmd:
         cmp     [@@wparam],IDB_FIND
         je      FRDlgTerm
         cmp     [@@wparam],IDB_REPLACE
         je      FRDlgTerm
         cmp     [@@wparam],IDB_REPLACEALL
         je      FRDlgTerm
         cmp     [@@wparam],IDCANCEL
         jne     FRDlgDone
FRDlgTerm:
         mov     ebx,[tempword]
         mov     eax,[(FRSTRUC ptr ebx).FRText]
         call    GetDlgItemText,[@@hdlg],IDC_FIND,eax,32
         mov     ebx,[tempword]
         mov     eax,[(FRSTRUC ptr ebx).FRRepText]
         call    GetDlgItemText,[@@hdlg],IDC_REPLACEWITH,eax,32
         call    IsDlgButtonChecked,[@@hdlg],IDC_WORDS
         shl     eax,FR_WHOLEWORD-1
         mov     ebx,[tempword]
         mov     [(FRSTRUC ptr ebx).FRFlags],eax
         call    IsDlgButtonChecked,[@@hdlg],IDC_CASE
         mov     ebx,[tempword]
         shl     eax,FR_MATCHCASE-1
         or      [(FRSTRUC ptr ebx).FRFlags],eax
         call    EndDialog,[@@hdlg],[@@wparam] ;end the dialog with wparam as return
         mov     eax,TRUE        ;return
         jmp     FRDlgRet      ;with TRUE
FRDlgDone:
         mov     eax,FALSE       ;return with FALSE
FRDlgRet:
         ret                     ;return
FindRepDlg  endp
public   FindRepDlg


;*******************************************************************
;*  Checks or Unchecks the menu item based on the flags            *
;*******************************************************************
UpdateFormatMenuItems proc
         arg     @@hwnd:DWORD
         EditMsg EM_GETPARAFORMAT,0,<offset pf>
         cmp     [pf.PF_wAlignment],PFA_LEFT
         je      @@10
         xor     al,al
         jmp     @@101
@@10:    and     [pf.PF_wAlignment],PFA_LEFT
@@101:   call    CheckUncheck,[@@hwnd],IDM_LEFT
         cmp     [pf.PF_wAlignment],PFA_CENTER
         je      @@11
         xor     al,al
         jmp     @@111
@@11:    and     [pf.PF_wAlignment],PFA_CENTER
@@111:   call    CheckUncheck,[@@hwnd],IDM_CENTER
         cmp     [pf.PF_wAlignment],PFA_RIGHT
         je      @@12
         xor     al,al
         jmp     @@121
@@12:    and     [pf.PF_wAlignment],PFA_RIGHT
@@121:   call    CheckUncheck,[@@hwnd],IDM_RIGHT
         mov     [charfm.CF_cbSize],charfml
         EditMsg EM_GETCHARFORMAT,TRUE,<offset charfm>
         test    [charfm.CF_dwEffects],CFE_BOLD
         call    CheckUncheck,[@@hwnd],IDM_BOLD
         test    [charfm.CF_dwEffects],CFE_ITALIC
         call    CheckUncheck,[@@hwnd],IDM_ITALIC
         test    [charfm.CF_dwEffects],CFE_UNDERLINE
         call    CheckUncheck,[@@hwnd],IDM_UNDERLINE
         test    [charfm.CF_dwEffects],CFE_STRIKEOUT
         call    CheckUncheck,[@@hwnd],IDM_STRIKEOUT
         mov     eax,[charfm.CF_yOffset]
         cmp     eax,0
         jg      @@1             ;if greater than zero, then superscript
         xor     al,al           ;set the zero flag to indicate unchecked
@@1:     call    CheckUncheck,[@@hwnd],IDM_SUPERSCRIPT
         mov     eax,[charfm.CF_yOffset]
         cmp     eax,0
         jl      @@2             ;if less than zero, then is subscript
         xor     al,al           ;set the zero flag to indicate unchecked
@@2:     call    CheckUncheck,[@@hwnd],IDM_SUBSCRIPT
         ret
UpdateFormatMenuItems endp

;*******************************************************************
;*  Checks or Unchecks the menu item based on the flags            *
;*******************************************************************
CheckUncheck proc
         arg     @@hwnd:DWORD,@@MenuID:DWORD
         mov     ebx,MF_UNCHECKED or MF_BYCOMMAND
         mov     edx,FALSE
         jz      cunc1
         mov     ebx,MF_CHECKED or MF_BYCOMMAND
         mov     edx,TRUE
cunc1:   push    edx             ;last arg of SendMessage
         call    GetMenu,[@@hwnd]
         call    CheckMenuItem,eax,[@@MenuID],ebx
         call    SendMessage,[hwndtool],TB_CHECKBUTTON,[@@MenuID]
         ret
CheckUncheck endp

;*******************************************************************
;*  Edit Stream Read Callback procedure                            *
;*******************************************************************
EditStreamReadCallback proc uses ebx edi esi
         arg     @@dwCookie:DWORD,@@pbBuff:DWORD,@@cb:DWORD,@@pcb:DWORD
         call    ReadFile,[@@dwCookie],[@@pbBuff],[@@cb],[@@pcb],0
         mov     ebx,[@@pcb]
         mov     eax,[ebx]       ;Get count read so far
         cmp     eax,[@@cb]      ;compare to amount needed
         jg      EditRet         ;if read < size, then more to read later
         mov     eax,0           ;otherwise, file completely read
EditRet: ret
EditStreamReadCallback endp
public EditStreamReadCallback
;*******************************************************************
;*  Edit Stream Save Callback procedure                            *
;*******************************************************************
EditStreamSaveCallback proc uses ebx edi esi
         arg     @@dwCookie:DWORD,@@pbBuff:DWORD,@@cb:DWORD,@@pcb:DWORD
         call    WriteFile,[@@dwCookie],[@@pbBuff],[@@cb],[@@pcb],0
         mov     eax,0           ;otherwise, file completely read
         ret
EditStreamSaveCallback endp
public EditStreamSaveCallback

;*******************************************************************
;*  ABOUTBOX DIALOG PROCEDURE                                      *
;*******************************************************************
AboutDlg proc    uses ebx edi esi
         arg     @@hdlg:DWORD,@@wmsg:DWORD,@@wparam:DWORD,@@lparam:DWORD
         cmp     [@@wmsg],WM_COMMAND ;Is message is a WM_COMMAND?
         je      AboutCmd        ;do command
         cmp     [@@wmsg],WM_INITDIALOG
         je      AboutInit       ;process init
         jmp     AboutDone       ;No, then just return
AboutCmd:
         mov     eax,[@@wparam]  ;Otherwise, see if it's OK or CANCEL
         cmp     eax,IDOK        ;That was pressed
         je      @@1             ;and if not either of these
         cmp     eax,IDCANCEL    ;then just
         jne     AboutDone       ;return
@@1:     call    EndDialog,[@@hdlg],[@@wparam] ;end the dialog
         mov     eax,TRUE        ;return
         jmp     AboutRet        ;with TRUE
AboutInit:
         mov     eax,[@@hdlg]
         call    CenterWindow
         mov     eax,TRUE
         jmp     AboutRet
AboutDone:
         mov     eax,FALSE       ;return with FALSE
AboutRet:
         ret                     ;return
AboutDlg endp
public   AboutDlg

;*******************************************************************
;*  TIPS DIALOG PROCEDURE                                          *
;*******************************************************************
TipsDlg  proc    uses ebx edi esi
         arg     @@hdlg:DWORD,@@wmsg:DWORD,@@wparam:DWORD,@@lparam:DWORD
         LOCAL   temp:DWORD
         LOCAL   hDC:DWORD
         LOCAL   hMemDC:DWORD
         cmp     [@@wmsg],WM_COMMAND ;Is message is a WM_COMMAND?
         je      TipsCmd          ;process commands
         cmp     [@@wmsg],WM_PAINT ;paint ?
         je      TipsPaint       ;process paint
         cmp     [@@wmsg],WM_INITDIALOG
         je      TipsInit        ;do initialization
         cmp     [@@wmsg],WM_CTLCOLOREDIT
         je      TipsColor
         cmp     [@@wmsg],WM_CTLCOLORBTN
         je      TipsColorBtn
         jmp     TipsDone        ;otherwise, done
TipsInit:
         call    RegGetInt,offset szStrtup,1
         call    CheckDlgButton,[@@hdlg],IDC_STARTUP,eax ;set Startup check based on ini setting
         call    LoadBitmap,[hInst],IDB_LIGHTBULB ;Load the lightbulb bitmap
         mov     [hBulb],eax     ;save handle ti'll dialog closes
         call    LoadBitmap,[hInst],IDB_DYKT   ;Load the "Did You Know ? ..." bitmap
         mov     [hDYKT],eax     ;save handle ti'll dialog closes
         mov     eax,TRUE
         mov     eax,[@@hdlg]
         call    CenterWindow
         jmp     TipsRet
TipsCmd: mov     eax,[@@wparam]  ;Otherwise, see if it's OK or CANCEL
         cmp     eax,IDB_NEXTTIP ;next tip pressed?
         je      TipsNext        ;then do it
         cmp     eax,IDOK        ;That was pressed
         je      TipsEnd         ;and if not either of these
         cmp     eax,IDCANCEL    ;then just
         jne     TipsDone        ;return

TipsEnd: call    IsDlgButtonChecked,[@@hdlg],IDC_STARTUP
         call    RegSetInt,offset szStrtup,eax
         call    DeleteObject,[hBulb] ;remove the bitmap resource
         call    DeleteObject,[hDYKT] ;remove the bitmap resource
         call    EndDialog,[@@hdlg],[@@wparam] ;end the dialog
         mov     eax,TRUE        ;return
         jmp     TipsRet         ;with TRUE

TipsNext:
         call    InvalidateRect,[@@hdlg],0,FALSE
         mov     eax,TRUE
         jmp     TipsRet

TipsColor:
         call    SetBkColor,[@@wparam],00808080h  ;Background color is gray
         call    SetTextColor,[@@wparam],0000ffffh ;text color of edit box is yellow
         call    GetStockObject,GRAY_BRUSH ;select the gray brush for background
         jmp     TipsRet ;return with brush in eax

TipsColorBtn:
         call    SetBkColor,[@@wparam],00c0c0c0h  ;light gray color of buttons/checkbox
         call    GetStockObject,LTGRAY_BRUSH  ;select the light gray brush
         jmp     TipsRet ;return with brush in eax

TipsPaint:
         call    BeginPaint,[@@hdlg],offset ps ;Start the paint process
         mov     [hDC],eax
         call    GetWindowRect,[@@hdlg],offset rect ;Get the dimensions of the dialog
         call    ScreenToClient,[@@hdlg],offset rect  ;convert to client form
         call    GetStockObject,LTGRAY_BRUSH   ;select the light gray brush
         mov     [temp],eax      ;for FillRect below
         call    SelectObject,[hDC],eax   ;select the brush into the dc
         call    FillRect,[hDC],offset rect,[temp] ;fill rectangle with the brush
; Display the LightBulb bitmap
         call    GetDlgItem,[@@hdlg],IDC_BULB ;get handle of where to put bitmap
         call    GetDC,eax       ;get dc of this item
         mov     [temp],eax
         call    CreateCompatibleDC,eax ;create a compatible dc in memory
         mov     [hMemDC],eax
         call    SelectObject,[hMemDC],[hBulb]  ;select the lightbulb bitmap into the dc
         call    BitBlt,[temp],0,0,40,53,[hMemDC],0,0,SRCCOPY ;copy the bitmap
         call    DeleteDC,[hMemDC] ;delete the memory dc
         call    DeleteDC,[temp]   ;delete the dc of IDC_BULB
; Display the "Did you know" bitmap
         call    GetDlgItem,[@@hdlg],IDC_DYKT ;get handle of where to put bitmap
         call    GetDC,eax        ;get dc of this item
         mov     [temp],eax
         call    CreateCompatibleDC,eax ;create a compatible dc in memory
         mov     [hMemDC],eax
         call    SelectObject,[hMemDC],[hDYKT] ;select the lightbulb bitmap into the dc
         call    BitBlt,[temp],0,0,218,24,[hMemDC],0,0,SRCCOPY ;copy the bitmap
         call    DeleteDC,[hMemDC]        ;delete the memory dc
         call    DeleteDC,[temp]          ;delete the dc of IDC_BULB
; Get the message of the day number
         call    RegGetInt,offset szTipnum,0
         push    eax             ;save tip number in stack for later
         inc     eax             ;tip+1
; Save the number +1 back to the registry
         call    RegSetInt,offset szTipnum,eax
         pop     eax             ;restore original tip number
         xor     edx,edx         ;zero upper
         mov     ecx,NUM_TIPS    ;modulus
         div     ecx             ;compute mod(NUM_TIPS)
         add     edx,20000       ;base # of tips resource strings
         call    LoadString,[hInst],edx,offset szBuf,szBufl ;Load the tip from STRINGTABLE
         call    SetDlgItemText,[@@hdlg],IDC_TIPSEDIT,offset szBuf
         call    EndPaint,[@@hdlg],offset ps ;painting is done
         mov     eax,TRUE
         jmp     TipsRet
TipsDone:
         mov     eax,FALSE       ;return with FALSE
TipsRet:
         ret                     ;return
TipsDlg  endp
public   TipsDlg



;*******************************************************************
;*  STRLEN                                                         *
;*  esi = input string pointer                                     *
;*  returns ecx with the string length                             *
;*******************************************************************
strlen   proc
         mov     ecx,256           ;reasonable max length
         xor     eax,eax           ;looking for 0
         mov     edi,esi           ;address of string in edi for scasb
         cld                       ;look forword
         repnz   scasb             ;scan for terminating null
         sub     edi,esi           ;calc length
         mov     ecx,edi           ;result in ecx
         dec     ecx               ;length does not include term null
done:    ret
strlen   endp


;*******************************************************************
;*  STRUPR                                                         *
;*  esi = input string pointer                                     *
;*  returns string converted to upper case                         *
;*******************************************************************
strupr   proc
         push    esi               ;save pointer
         call    strlen            ;get length in ecx
         mov     edi,esi           ;dest = source
struplp: lodsb                     ;get byte in al
         cmp     al,'a'            ;convert
         jl      strupst           ;only
         cmp     al,'z'            ;a-z
         jg      strupst           ;to upper case
         and     al,0dfh           ;and off lower case bit
strupst: stosb                     ;store al
         loop    struplp           ;for length of string
         pop     esi               ;restore string ptr
         ret                       ;return to caller
strupr   endp


;*******************************************************************
;*  CVDEC                                                          *
;*  ebx = source integer                                           *
;*  edx = dest address                                             *
;*  destroys eax,ecx,esi,edi                                       *
;*******************************************************************
cvdec    proc
;
; ebx = source
; edx = dest
; ecx = even # bytes to convert
;
         LOCAL   tempbuf:TBYTE
         fild    word ptr[ebx]   ;integer load
         fbstp   [tempbuf]       ;convert to bcd
         lea     ebx,tempbuf     ;address of the above conversion
         shr     ecx,1
         dec     ecx
         mov     esi,ecx
         xor     edi,edi
cvloop:  mov     al,[ebx+esi]
         mov     cl,al
         and     al,0fh
         shr     cl,4
         or      al,30h
         or      cl,30h
         mov     [edx+edi],cl
         inc     edi
         mov     [edx+edi],al
         inc     edi
         dec     esi
         jns     cvloop
         ret
cvdec    endp

;*******************************************************************
;*  Format the time and send it to the status bar                  *
;*******************************************************************
fmtime   proc
         cmp     [hwndstat],0    ;valid statusbar?
         jz      ftimex          ;no, then exit
         call    GetLocalTime,offset time ;time from win32
         mov     byte ptr[tmsgampm],'A' ;default to AM
         mov     ax,[time.wHour] ;get hour
         cmp     ax,12           ;>12?
         jle     isAM            ;it's AM
         mov     byte ptr[tmsgampm],'P' ;reset to PM
         sub     ax,12           ;-12
         mov     [time.wHour],ax ;save it
isAM:    lea     ebx,time.wHour  ;integer load the hour
         lea     edx,tmsghour    ;dest
         mov     ecx,2           ;#bytes
         call    cvdec           ;convert to displayable ascii decimal
         lea     ebx,time.wMinute ;integer load the minute
         lea     edx,tmsgmin     ;dest
         mov     ecx,2           ;#bytes
         call    cvdec           ;convert to displayable ascii decimal
         lea     ebx,time.wSecond ;integer load the Second
         lea     edx,tmsgsec     ;dest
         mov     ecx,2           ;#bytes
         call    cvdec           ;convert to displayable ascii decimal
         ;Display time in statusbar
         call    SendMessage,[hwndstat],SB_SETTEXT,SBPART_TIME,offset tmsg
ftimex:  ret
fmtime   endp

;*******************************************************************
;*  Center window whose handle is in eax                           *
;*******************************************************************
CenterWindow proc
         local   hwndthis:DWORD
         local   hwndparent:DWORD
         mov     [hwndthis],eax  ;save this hwnd
         call    GetParent,eax   ;get parents hwnd
         mov     [hwndparent],eax;save parents hwnd
         call    GetWindowRect,eax,offset rect
         call    ClientToScreen,[hwndparent],offset pw
         mov     eax,[rect.rcBottom]
         sub     eax,[rect.rcTop]
         shr     eax,1
         mov     [ph],eax        ;save parent height
         mov     eax,[rect.rcRight]
         sub     eax,[rect.rcLeft]
         shr     eax,1
         mov     [pw],eax        ;save parent width
         call    GetWindowRect,[hwndthis],offset rect
         call    ClientToScreen,[hwndparent],offset pw
         push    FALSE           ;repaint = false
         mov     eax,[rect.rcBottom]
         sub     eax,[rect.rcTop]
         push    eax             ;height
         shr     eax,1           ;eax = child window height
         mov     edx,[ph]
         sub     edx,eax         ;edx = new y position
         mov     eax,[rect.rcRight]
         sub     eax,[rect.rcLeft]
         push    eax             ;width
         shr     eax,1           ;eax = child window width
         mov     ebx,[pw]
         sub     ebx,eax         ;ebx = new x position
         push    edx             ;y
         push    ebx             ;x
         push    [hwndthis]      ;hwnd to move
         call    MoveWindow      ;center window
         ret
CenterWindow endp


;*******************************************************************
;*  Set the title string in the main window                        *
;*******************************************************************
SetTitle proc
         EditMsg EM_GETMODIFY
         push    eax
         mov     esi,offset szFile
         call    strlen
         cmp     ecx,0
         jne     setttl
         lea     esi,szUntitled
         mov     ecx,szUntitledl
setttl:  mov     edi,offset szBuf
         pop     eax
         cmp     eax,FALSE
         je      notdirty
         mov     ax,' *'
         mov     [edi],ax
         add     edi,2
notdirty:
         cld
         rep     movsb
         mov     esi,offset ttl
         mov     ecx,ttll
         rep     movsb
         call    SendMessage,[newhwnd],WM_SETTEXT,0,offset szBuf
         ret
SetTitle endp

;*******************************************************************
;*  Generate error message                                         *
;*  eax = message # to display                                     *
;*  ebx = Title                                                    *
;*  ecx = MessageBox Flags                                         *
;*******************************************************************
ErrorMsg proc
         push    ecx
         push    ebx             ;save these for after LoadString call
         push    szErrorl        ;size of our buffer
         push    offset szError  ;buffer to load string into
         push    eax             ;resource #
         push    [hInst]         ;Instance
         call    LoadString      ;Load the tip from STRINGTABLE
         cmp     eax,0           ;Did we get a string?
         jne     Error1          ;yes, continue
         lea     eax,szNULL      ;null string
Error1:  push    offset szError
         push    0
         call    MessageBox
         ret
ErrorMsg endp

;*******************************************************************
;*  Check if the file needs saving and prompt user for action      *
;*******************************************************************
CheckSav proc
         arg     @@hwnd:DWORD
         EditMsg EM_GETMODIFY
         cmp     eax,FALSE
         je      Checkx
         GenErr  ERROR_SAVE_BEFORE_QUIT,szSaving,<MB_YESNOCANCEL or MB_ICONQUESTION>
         cmp     eax,IDYES
         je      CheckDoSave
         ret
CheckDoSave:
         call    SendMessage,[@@hwnd],WM_COMMAND,IDM_SAVE,0
Checkx:  mov     eax,IDNO
         ret
CheckSav endp

;*******************************************************************
;*  Enable or disable the items in the edit menu                   *
;*******************************************************************
EnableDisableEditMenu proc
         arg     @@wparam:DWORD
         EditMsg EM_CANUNDO
         cmp     eax,TRUE
         jne     ede1
         push    MF_ENABLED
         jmp     ede2
ede1:    push    MF_GRAYED
ede2:    push    IDM_UNDO
         push    [@@wparam]
         call    EnableMenuItem
         call    IsClipboardFormatAvailable,CF_TEXT
         cmp     eax,TRUE
         jne     ede3
         push    MF_ENABLED
         jmp     ede4
ede3:    push    MF_GRAYED
ede4:    push    IDM_PASTE
         push    [@@wparam]
         call    EnableMenuItem
         EditMsg EM_GETSEL
         mov     ebx,eax
         shr     ebx,16
         cwde
         cmp     eax,ebx         ;if no selection then gray otherwise enable
         je      ede5
         mov     [tempword],MF_ENABLED
         jmp     ede6
ede5:    mov     [tempword],MF_GRAYED
ede6:    push    [tempword]
         push    IDM_CUT
         push    [@@wparam]
         call    EnableMenuItem
         push    [tempword]
         push    IDM_COPY
         push    [@@wparam]
         call    EnableMenuItem
         ret
EnableDisableEditMenu endp

;*******************************************************************
;*  Enable or disable the items in the toolbar                     *
;*******************************************************************
EnableDisableToolbar proc
         EditMsg EM_CANUNDO
         cmp     eax,TRUE
         jne     edt1
         push    TRUE
         jmp     edt2
edt1:    push    FALSE
edt2:    push    IDM_UNDO
         push    TB_ENABLEBUTTON
         push    [hwndtool]
         call    SendMessage
         call    IsClipboardFormatAvailable,CF_TEXT
         cmp     eax,TRUE
         jne     edt3
         push    TRUE
         jmp     edt4
edt3:    push    FALSE
edt4:    push    IDM_PASTE
         push    TB_ENABLEBUTTON
         push    [hwndtool]
         call    SendMessage
         EditMsg EM_GETSEL
         mov     ebx,eax
         shr     ebx,16
         cwde
         cmp     eax,ebx         ;if no selection then gray otherwise enable
         je      edt5
         mov     [tempword],TRUE
         jmp     edt6
edt5:    mov     [tempword],FALSE
edt6:    push    [tempword]
         push    IDM_CUT
         push    TB_ENABLEBUTTON
         push    [hwndtool]
         call    SendMessage
         push    [tempword]
         push    IDM_COPY
         push    TB_ENABLEBUTTON
         push    [hwndtool]
         call    SendMessage
         call    UpdateFormatMenuItems,[newhwnd]
         ret
EnableDisableToolbar endp


;*******************************************************************
;*  Find                                                           *
;*    returns TRUE or FALSE based on finding szText                *
;*******************************************************************
Find     proc
         arg     @@hwnd:DWORD,@@Next:DWORD,@@Flags:DWORD,@@szText:DWORD
         EditMsg EM_EXGETSEL,0,<offset ft.FT_chrg>
         mov     eax,[@@Next]
         cmp     eax,TRUE
         jne     @@1
         mov     esi,[@@szText]
         call    strlen
         add     ecx,[ft.FT_chrg.CR_cpMin]
         mov     [ft.FT_chrg.CR_cpMin],ecx
@@1:     mov     eax,[@@szText]
         mov     [ft.FT_lpstrText],eax
         mov     [ft.FT_chrg.CR_cpMax],-1 ;search text from cursor to end
         EditMsg EM_FINDTEXT,[@@Flags],<offset ft> ;do search
         cmp     eax,-1          ;nothing found?
         jne     @@2
         call    LoadString,[hInst],ERROR_NOT_FOUND,offset szBuf,szBufl
         call    SendMessage,[hwndstat],SB_SETTEXT,SBPART_MESSAGE1,offset szBuf
         call    MessageBeep,0
         jmp     Find0
@@2:     mov     [ft.FT_chrg.CR_cpMin],eax
         mov     esi,[@@szText]
         call    strlen
         add     ecx,[ft.FT_chrg.CR_cpMin]
         mov     [ft.FT_chrg.CR_cpMax],ecx
         EditMsg EM_EXSETSEL,0,<offset ft.FT_chrg>
         call    GetMenu,[@@hwnd]
         call    EnableMenuItem,eax,IDM_FINDNEXT,MF_BYCOMMAND or MF_ENABLED
         mov     eax,TRUE
         jmp     FindX
Find0:   mov     eax,FALSE
FindX:   ret
Find     endp


;*******************************************************************
;*  ProcessCommandLine                                             *
;*    parses the command line (if one exists) entered into szFile  *
;     converting to upper case and filling in the needed ofn words *
;*******************************************************************
ProcessCommandLine proc
         local   arglen:DWORD,szArg:DWORD
         call    GetCommandLine  ;get commandline from os
         mov     [szArg],eax     ;save addr of args
         mov     esi,eax         ;addr into esi for strlen call
         call    strlen          ;get length of string in ecx
         mov     edi,[szArg]     ;addr of string for scasb
         mov     eax,20h         ;look for space
         repnz   scasb           ;in arg string
         jecxz   pcl_ret         ;just return if no arg
         mov     [arglen],ecx    ;save length of arg
         mov     [szArg],edi     ;save arg starting point
         mov     esi,edi         ;move from +1 after space
         inc     ecx             ;to null terminator
         mov     edi,offset szFile
         cld
         rep     movsb           ;move arg to szFile
         lea     esi,szFile      ;convert
         call    strupr          ;to upper case
         mov     edi,[szArg]     ;address of arg
         mov     eax,'.'         ;look for dot
         mov     ecx,[arglen]    ;separator
         repnz   scasb           ;in filename
         jecxz   pcl_ret         ;just return if not found
         mov     eax,[arglen]    ;calc offset
         sub     eax,ecx         ;to suffix
         mov     [ofn.nFileExtension],ax
pcl_ret: ret
ProcessCommandLine endp



;*******************************************************************
;*  SetInitialFormatting                                           *
;*    Sets the initial characteristics to font=courier, black, 10pt*
;*******************************************************************
SetInitialFormatting proc
         mov     edi,offset charfm
         mov     ecx,charfml
         mov     eax,0
         cld
         rep     stosb
         call    RegCreateKeyEx,HKEY_CURRENT_USER,offset szRedit,0,offset szREGSZ,0,KEY_ALL_ACCESS,0,offset hReg,offset lpdwDisp
         mov     [lpcbData],LF_FACESIZE
         call    RegQueryValueEx,[hReg],offset szFont,0,offset lpType,offset charfm.CF_szFaceName,offset lpcbData
         cmp     eax,0
         je      @@1
         mov     esi,offset szCourier
         call    strlen          ;length of facename string in ecx
         mov     edi,offset charfm.CF_szFaceName
         inc     ecx             ;move ending null too
         cld
         rep     movsb           ;move facename from LOGFONT to CHARFORMAT
@@1:     call    RegGetInt,offset szColor,0
         mov     [charfm.CF_crTextColor],eax
         call    RegGetInt,offset szPoint,200
         mov     [charfm.CF_yHeight],eax
         call    RegGetInt,offset szMask,CFM_OFFSET or CFM_BOLD or CFM_ITALIC or CFM_UNDERLINE or CFM_STRIKEOUT or CFM_FACE or CFM_SIZE or CFM_COLOR
         mov     [charfm.CF_dwMask],eax
         call    RegGetInt,offset szEffects,0
         mov     [charfm.CF_dwEffects],eax
         call    RegCloseKey,[hReg]
         mov     [charfm.CF_cbSize],charfml
         EditMsg EM_SETCHARFORMAT,SCF_SELECTION,<offset charfm>
         ret
SetInitialFormatting endp

;*******************************************************************
;*  ModPath                                                        *
;*    Modifies the path to point to the absolute windows path      *
;*******************************************************************
ModPath  proc
         call    strlen
         push    ecx
         push    esi
         call    GetWindowsDirectory,offset szWin,szWinl
         lea     esi,szWin
         call    strlen
         mov     edi,ecx
         add     edi,offset szWin
         pop     esi
         pop     ecx
         cld
         rep     movsb
         lea     esi,szWin
         ret
ModPath  endp


;*******************************************************************
;*  StartNewDocument                                               *
;*******************************************************************
StartNewDocument proc
         arg     @@hwnd:DWORD
         call    CheckSav,[@@hwnd]
         EditMsg EM_SETMODIFY,FALSE
         call    EnableDisableToolbar
         call    SetTitle
         call    SetInitialFormatting
         ret
StartNewDocument endp


;*******************************************************************
;*  RegGetInt                                                      *
;*    Return the integer value in eax from the registry            *
;*******************************************************************
RegGetInt proc
         arg     @@szValueName:DWORD,@@Default:DWORD
         call    RegCreateKeyEx,HKEY_CURRENT_USER,offset szRedit,0,offset szREGSZ,0,KEY_ALL_ACCESS,0,offset hReg,offset lpdwDisp
         mov     [lpcbData],4
         mov     eax,[@@szValueName]
         lea     ebx,offset @@Default
         call    RegQueryValueEx,[hReg],eax,0,offset lpType,ebx,offset lpcbData
         call    RegCloseKey,[hReg]
         mov     eax,[@@Default]
         ret
RegGetInt endp

;*******************************************************************
;*  RegSetInt                                                      *
;*     Sets the specified value in the registry                    *
;*******************************************************************
RegSetInt proc
         arg     @@szValueName:DWORD,@@Value:DWORD
         call    RegCreateKeyEx,HKEY_CURRENT_USER,offset szRedit,0,offset szREGSZ,0,KEY_ALL_ACCESS,0,offset hReg,offset lpdwDisp
         mov     [lpcbData],4
         mov     eax,[@@szValueName]
         lea     ebx,@@Value
         call    RegSetValueEx,[hReg],eax,0,REG_DWORD,ebx,[lpcbData]
         call    RegCloseKey,[hReg]
         ret
RegSetInt endp

         ends
         end     WinMain

