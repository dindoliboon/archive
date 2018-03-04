
OFN STRUCT
  lStructSize        dd      ?
  hWndOwner          dd      ?
  hInstance          dd      ?
  lpstrFilter        dd      ?
  lpstrCustomFilter  dd      ?
  nMaxCustFilter     dd      ?
  nFilterIndex       dd      ?
  lpstrFile          dd      ?
  nMaxFile           dd      ?
  lpstrFileTitle     dd      ?
  nMaxFileTitle      dd      ?
  lpstrInitialDir    dd      ?
  lpstrTitle         dd      ?
  ofn_Flags          dd      ?
  nFileOffset        dw      ?
  nFileExtension     dw      ?
  lpstrDefExt        dd      ?
  lCustData          dd      ?
  lpfnHook           dd      ?
  lpTemplateName     dd      ?
OFN ENDS


NULL equ 0
;typedef struct _WIN32_FIND_DATA { // wfd 
;    DWORD dwFileAttributes; 
;    FILETIME ftCreationTime; 
;    FILETIME ftLastAccessTime; 
;    FILETIME ftLastWriteTime; 
;    DWORD    nFileSizeHigh; 
;    DWORD    nFileSizeLow; 
;    DWORD    dwReserved0; 
;    DWORD    dwReserved1; 
;    TCHAR    cFileName[ MAX_PATH ]; 
;    TCHAR    cAlternateFileName[ 14 ]; 
;} WIN32_FIND_DATA; 

WIN32_FIND_DATA STRUCT
  dwFileAttributes  	dd  	?
  ftCreationTime  	dd	2 dup(?)
  ftLastAccessTime  	dd	2 dup(?)
  ftLastWriteTime  	dd      2 dup(?)
  nFileSizeHigh  	dd	?
  nFileSizeLow  	dd      ?
  dwReserved0  		dd      ?
  dwReserved1  		dd      ?
  cFileName  		db 	260 dup (?)
  cAlternate  		db 	14 dup (?)
WIN32_FIND_DATA ENDS


; offsets within PE header
signature                         equ 0
cputype                           equ 4
numObj                            equ 6
NtHeaderSize                      equ 20
Flags                             equ 22
entrypointRVA                     equ 40
imagebase                         equ 52
objalign                          equ 56
filealign                         equ 60
imagesize                         equ 80
headersize                        equ 84
checksum                          equ 88
edatadir			  equ 120
datadir				  equ 128
sizehdr				  equ 54h

; object record offsets
objname equ 0
objvsize equ 8
objrva equ 12
objpsize equ 16
objpoff equ 20
objflags equ 36

oflag_write equ 80000000h

;
; SetFilePointer stuff
;
FILE_BEGIN                        equ   0
FILE_CURRENT                      equ   1
FILE_END                          equ   2
;
; mapping stuff
;
PAGE_READONLY                     equ   2
PAGE_READWRITE                    equ   4     
PAGE_WRITECOPY                    equ   8     
SECTION_QUERY                     equ   1
SECTION_MAP_WRITE                 equ   2
SECTION_MAP_READ                  equ   4
SECTION_MAP_EXECUTE               equ   8
SECTION_MAP_EXTEND_SIZE           equ   10
FILE_MAP_COPY                     equ   SECTION_QUERY
FILE_MAP_WRITE                    equ   SECTION_MAP_WRITE
FILE_MAP_READ                     equ   SECTION_MAP_READ
MB_OK		EQU		000000000h
MB_OKCANCEL		EQU		000000001h
MB_ABORTRETRYIGNORE		EQU		000000002h
MB_YESNOCANCEL		EQU		000000003h
MB_YESNO		EQU		000000004h
MB_RETRYCANCEL		EQU		000000005h
MB_TYPEMASK		EQU		00000000fh
MB_ICONHAND		EQU		000000010h
MB_ICONQUESTION		EQU		000000020h
MB_ICONEXCLAMATION		EQU		000000030h
MB_ICONASTERISK		EQU		000000040h
MB_ICONMASK		EQU		0000000f0h
MB_ICONINFORMATION		EQU		000000040h
MB_ICONSTOP		EQU		000000010h
MB_DEFBUTTON1		EQU		000000000h
MB_DEFBUTTON2		EQU		000000100h
MB_DEFBUTTON3		EQU		000000200h
MB_DEFMASK		EQU		000000f00h
MB_APPLMODAL		EQU		000000000h
MB_SYSTEMMODAL		EQU		000001000h
MB_TASKMODAL		EQU		000002000h
MB_NOFOCUS		EQU		000008000h
IDNO                    EQU             7
IDYES                   EQU             6
IDCANCEL		EQU             2



;DLGPROC                TYPEDEF PROCDESC STDCALL
DLGPROC TEXTEQU <STDCALL>

SB_HORZ                 EQU     0
SB_VERT                 EQU     1
SB_CTL                  EQU     2
SB_BOTH                 EQU     3
SB_THUMBPOSITION        EQU     4
SB_ENDSCROLL            EQU     8

SW_HIDE                 EQU     00h
SW_SHOWNORMAL           EQU     01h
SW_SHOWMINIMIZED        EQU     02h
SW_SHOWMAXIMIZED        EQU     03h
SW_SHOW                 EQU     05h
SW_RESTORE              EQU     09h
SW_SHOWDEFAULT          EQU     0Ah

WNDCLASSEX_ EQU 4*12
WNDCLASSEXA             STRUCT
        wc_cbSize               dd           ?
        wc_style                dd            ?
        wc_lpfnWndProc          dd           ?
        wc_cbClsExtra           dd          ?
        wc_cbWndExtra           dd          ?
        wc_hInstance            dd       ?
        wc_hIcon                dd           ?
        wc_hCursor              dd         ?
        wc_hbrBackground        dd          ?
        wc_lpszMenuName         dd          ?
        wc_lpszClassName        dd          ?
        wc_hIconSm              dd           ?
WNDCLASSEXA             ENDS
WNDCLASSEX              TEXTEQU <WNDCLASSEXA>

LPMSG                   TYPEDEF DWORD

;GWL_ID                 EQU     0FFFFFFF4h

WM_CREATE               EQU     0001h
WM_DESTROY              EQU     0002h
WM_SIZE                 EQU     0005h
WM_SETTEXT              EQU     000Ch
WM_PAINT                EQU     000Fh
WM_CLOSE                EQU     0010h
WM_ERASEBKGND           EQU     0014h
WM_NOTIFY               EQU     004Eh
WM_HELP                 EQU     0053h
WM_CHAR                 EQU     0102h
WM_INITDIALOG           EQU     0110h
WM_COMMAND              EQU     0111h
WM_TIMER                EQU     0113h
WM_HSCROLL              EQU     0114h
WM_VSCROLL              EQU     0115h
WM_MENUSELECT           EQU     011Fh
WM_CTLCOLORDLG          EQU     0136h
WM_MOUSEMOVE            EQU     0200h
WM_LBUTTONDOWN          EQU     0201h
WM_LBUTTONUP            EQU     0202h
WM_LBUTTONDBLCLK        EQU     0203h
WM_RBUTTONDOWN          EQU     0204h
WM_RBUTTONUP            EQU     0205h
WM_RBUTTONDBLCLK        EQU     0206h
WM_CUT                  EQU     0300h
WM_COPY                 EQU     0301h
WM_PASTE                EQU     0302h
WM_CLEAR                EQU     0303h
WM_UNDO                 EQU     0304h
WM_USER                 EQU     0400h

WS_POPUP                EQU     080000000h
WS_CHILD                EQU     040000000h
WS_MINIMIZE             EQU     020000000h
WS_VISIBLE              EQU     010000000h
WS_MAXIMIZE             EQU     001000000h
WS_CAPTION              EQU     000C00000h
WS_BORDER               EQU     000800000h
WS_DLGFRAME             EQU     000400000h
WS_VSCROLL              EQU     000200000h
WS_HSCROLL              EQU     000100000h
WS_SYSMENU              EQU     000080000h
;WS_SIZEBOX             EQU     000040000h
WS_MINIMIZEBOX          EQU     000020000h
WS_MAXIMIZEBOX          EQU     000010000h
WS_OVERLAPPEDWINDOW     EQU     000CF0000h
WS_EX_NOPARENTNOTIFY    EQU     000000004h
WS_EX_WINDOWEDGE        EQU     000000100h
WS_EX_CLIENTEDGE        EQU     000000200h
WS_EX_OVERLAPPEDWINDOW  EQU     WS_EX_WINDOWEDGE + WS_EX_CLIENTEDGE

CS_VREDRAW              EQU     00001h
CS_HREDRAW              EQU     00002h
CS_PARENTDC             EQU     00080h
CS_BYTEALIGNWINDOW      EQU     02000h

BDR_RAISEDOUTER         EQU     01h
BDR_SUNKENOUTER         EQU     02h
BDR_RAISEDINNER         EQU     04h
BDR_SUNKENINNER         EQU     08h
EDGE_RAISED             EQU     BDR_RAISEDOUTER + BDR_RAISEDINNER
EDGE_SUNKEN             EQU     BDR_SUNKENOUTER + BDR_SUNKENINNER
EDGE_ETCHED             EQU     BDR_SUNKENOUTER + BDR_RAISEDINNER
EDGE_BUMP               EQU     BDR_RAISEDOUTER + BDR_SUNKENINNER
BF_LEFT                 EQU     01h
BF_TOP                  EQU     02h
BF_RIGHT                EQU     04h
BF_BOTTOM               EQU     08h
BF_RECT                 EQU     BF_LEFT + BF_TOP + BF_RIGHT + BF_BOTTOM


;
MSG                     struct
ms_hwnd                 dd      0             ;window handle
ms_message              dd      0             ;message id
ms_wParam               dd    0             ;additional parameter
ms_lParam               dd    0             ;additional parameter
ms_time                 dd     0             ;time stamp
ms_x                    dd   0             ;x coordinate
ms_y                    dd   0             ;y coordinate
MSG                     ends

IDOK                            equ     1
IDCANCEL                        equ     2
IDABORT                         equ     3
IDRETRY                         equ     4
IDIGNORE                        equ     5
IDYES                           equ     6
IDNO                            equ     7
IDCLOSE                         equ     8
IDHELP                          equ     9
COLOR_BTNFACE                        equ 15
DLGWINDOWEXTRA                       equ 30
IDC_ARROW                            equ 32512
WM_CTLCOLORDLG                       equ 136h

LOGBRUSH STRUCT
  lbStyle  DWORD      ?
  lbColor  DWORD      ?
  lbHatch  DWORD      ?
LOGBRUSH ENDS

OFN_HIDEREADONLY  equ 4
WM_SETICON equ 80h
ICON_BIG equ 1
ICON_SMALL equ 0
WM_SETFOCUS equ	7
WM_KEYFIRST			equ	0100h
WM_KEYDOWN			equ	0100h
WM_KEYUP			equ	0101h
WM_CHAR				equ	0102h
WM_DEADCHAR			equ	0103h
WM_SYSKEYDOWN			equ	0104h
WM_SYSKEYUP			equ	0105h
WM_SYSCHAR			equ	0106h
WM_SYSDEADCHAR			equ	0107h
WM_KEYLAST			equ	0108h

VK_RETURN equ 0dh