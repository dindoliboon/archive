;*************************************************************************
;
;       WIN32.INC - Win32 assembly language structures & constants
;
;
;*************************************************************************
;
; NOTE: this file only implements the structures and constants that
;       wap32.asm uses.  You may extend it for your own applications.
;
;*************************************************************************
;
;
;       C/C++ Run Time Library - Version 6.0
;
;       Copyright (c) 1985, 1993 by Borland International
;       All Rights Reserved.
;

UCHAR   EQU <db>
USHORT  EQU <dw>  ; used only if we really need 16 bits
UINT    EQU <dd>  ; 32 bits for WIN32
ULONG   EQU <dd>

;*******************************************************************
;
;       Window's externals
;
;*******************************************************************
extrn    AbortDoc:PROC
extrn    BeginPaint:PROC
extrn    BitBlt:PROC
extrn    CallWindowProcA:PROC
extrn    CheckDlgButton:PROC
extrn    CheckMenuItem:PROC
extrn    ChooseFontA:PROC
extrn    ClientToScreen:PROC
extrn    CloseClipboard:PROC
extrn    CloseHandle:PROC
extrn    CreateCompatibleDC:PROC
extrn    CreateFileA:PROC
extrn    CreateToolbar:PROC
extrn    CreateToolbarEx:PROC
extrn    CreateWindowExA:PROC
extrn    DefWindowProcA:PROC
extrn    DeleteDC:PROC
extrn    DeleteObject:PROC
extrn    DialogBoxParamA:PROC
extrn    DispatchMessageA:PROC
extrn    DestroyWindow:PROC
extrn    DragAcceptFiles:PROC
extrn    DragQueryFileA:PROC
extrn    EnableMenuItem:PROC
extrn    EndDialog:PROC
extrn    EndDoc:PROC
extrn    EndPaint:PROC
extrn    EndPage:PROC
extrn    Escape:PROC
extrn    ExitProcess:PROC
extrn    FillRect:PROC
extrn    FindWindowA:PROC
extrn    FreeLibrary:PROC
extrn    GetBitmapDimensionEx:PROC
extrn    GetClientRect:PROC
extrn    GetClipboardData:PROC
extrn    GetCommandLineA:PROC
extrn    GetDC:PROC
extrn    GetDeviceCaps:PROC
extrn    GetDlgItem:PROC
extrn    GetDlgItemInt:PROC
extrn    GetDlgItemTextA:PROC
extrn    GetFileSize:PROC
extrn    GetLocalTime:PROC
extrn    GetMenu:PROC
extrn    GetMessageA:PROC
extrn    GetModuleHandleA:PROC
extrn    GetOpenFileNameA:PROC
extrn    GetParent:PROC
extrn    GetPrivateProfileIntA:PROC
extrn    GetProfileIntA:PROC
extrn    GetProfileStringA:PROC
extrn    GetSaveFileNameA:PROC
extrn    GetStockObject:PROC
extrn    GetSystemMetrics:PROC
extrn    GetTextMetricsA:PROC
extrn    GetWindowLongA:PROC
extrn    GetWindowRect:PROC
extrn    GetWindowsDirectoryA:PROC
extrn    GlobalAlloc:PROC
extrn    GlobalFree:PROC
extrn    GlobalLock:PROC
extrn    GlobalUnlock:PROC
extrn    InitCommonControls:PROC
extrn    InvalidateRect:PROC
extrn    IsClipboardFormatAvailable:PROC
extrn    IsDlgButtonChecked:PROC
extrn    KillTimer:PROC
extrn    LoadAcceleratorsA:PROC
extrn    LoadBitmapA:PROC
extrn    LoadCursorA:PROC
extrn    LoadIconA:PROC
extrn    LoadLibraryA:PROC
extrn    LoadMenuA:PROC
extrn    LoadStringA:PROC
extrn    LocalAlloc:PROC
extrn    LocalFree:PROC
extrn    LocalLock:PROC
extrn    LocalUnlock:PROC
extrn    MessageBeep:PROC
extrn    MessageBoxA:PROC
extrn    MoveWindow:PROC
extrn    OleInitialize:PROC
extrn    OpenClipboard:PROC
extrn    OpenFile:PROC
extrn    PostMessageA:PROC
extrn    PostQuitMessage:PROC
extrn    PrintDlgA:PROC
extrn    ReadFile:PROC
extrn    RegisterClassA:PROC
extrn    RegSetValueExA:PROC
extrn    RegCreateKeyExA:PROC
extrn    RegQueryValueExA:PROC
extrn    RegCloseKey:PROC
extrn    ReleaseDC:PROC
extrn    SelectObject:PROC
extrn    SendMessageA:PROC
extrn    SetDlgItemTextA:PROC
extrn    SetFocus:PROC
extrn    SetBkColor:PROC
extrn    SetClipboardData:PROC
extrn    SetMapMode:PROC
extrn    SetTextColor:PROC
extrn    SetTimer:PROC
extrn    SetWindowLongA:PROC
extrn    SetWindowPos:PROC
extrn    SetWindowTextA:PROC
extrn    ScreenToClient:PROC
extrn    ShowWindow:PROC
extrn    StartDocA:PROC
extrn    StartPage:PROC
extrn    TextOutA:PROC
extrn    TranslateAcceleratorA:PROC
extrn    TranslateMessage:PROC
extrn    UpdateWindow:PROC
extrn    WinHelpA:PROC
extrn    WriteFile:PROC
extrn    WritePrivateProfileStringA:PROC
extrn    WriteProfileIntA:PROC
extrn    WriteProfileStringA:PROC

CallWindowProc   equ <CallWindowProcA>
ChooseFont       equ <ChooseFontA>
CreateFile       equ <CreateFileA>
CreateWindowEx   equ <CreateWindowExA>
DefWindowProc    equ <DefWindowProcA>
DialogBoxParam   equ <DialogBoxParamA>
DispatchMessage  equ <DispatchMessageA>
DragQueryFile    equ <DragQueryFileA>
FindWindow       equ <FindWindowA>
GetCommandLine   equ <GetCommandLineA>
GetDlgItemText   equ <GetDlgItemTextA>
GetMessage       equ <GetMessageA>
GetModuleHandle  equ <GetModuleHandleA>
GetWindowLong    equ <GetWindowLongA>
GetOpenFileName  equ <GetOpenFileNameA>
GetPrivateProfileInt equ <GetPrivateProfileIntA>
GetProfileInt    equ <GetProfileIntA>
GetProfileString equ <GetProfileStringA>
GetSaveFileName  equ <GetSaveFileNameA>
GetTextMetrics   equ <GetTextMetricsA>
GetWindowsDirectory equ <GetWindowsDirectoryA>
LoadBitmap       equ <LoadBitmapA>
LoadAccelerators equ <LoadAcceleratorsA>
LoadCursor       equ <LoadCursorA>
LoadIcon         equ <LoadIconA>
LoadLibrary      equ <LoadLibraryA>
LoadMenu         equ <LoadMenuA>
LoadString       equ <LoadStringA>
MessageBox       equ <MessageBoxA>
PostMessage      equ <PostMessageA>
PrintDlg         equ <PrintDlgA>
RegisterClass    equ <RegisterClassA>
RegSetValueEx    equ <RegSetValueExA>
RegCreateKeyEx   equ <RegCreateKeyExA>
RegQueryValueEx  equ <RegQueryValueExA>
SendMessage      equ <SendMessageA>
SetDlgItemText   equ <SetDlgItemTextA>
SetWindowLong    equ <SetWindowLongA>
SetWindowText    equ <SetWindowTextA>
StartDoc         equ <StartDocA>
TextOut          equ <TextOutA>
TranslateAccelerator equ <TranslateAcceleratorA>
WinHelp          equ <WinHelpA>
WritePrivateProfileString equ <WritePrivateProfileStringA>
WriteProfileInt  equ <WriteProfileIntA>
WriteProfileString equ <WriteProfileStringA>

COLORREF equ <ULONG>
;
; Registry
;

REG_NONE                =    ( 0 )   ; No value type
REG_SZ                  =    ( 1 )   ; Unicode nul terminated string
REG_EXPAND_SZ           =    ( 2 )   ; Unicode nul terminated string
REG_BINARY              =    ( 3 )   ; Free form binary
REG_DWORD               =    ( 4 )   ; 32-bit number
REG_DWORD_LITTLE_ENDIAN =    ( 4 )   ; 32-bit number (same as REG_DWORD)
REG_DWORD_BIG_ENDIAN    =    ( 5 )   ; 32-bit number
REG_LINK                =    ( 6 )   ; Symbolic Link (unicode)
REG_MULTI_SZ            =    ( 7 )   ; Multiple Unicode strings
REG_RESOURCE_LIST       =    ( 8 )   ; Resource list in the resource map
REG_FULL_RESOURCE_DESCRIPTOR = ( 9 ) ; Resource list in the hardware description
REG_RESOURCE_REQUIREMENTS_LIST = ( 10 )

 KEY_QUERY_VALUE        = 0001h
 KEY_SET_VALUE          = 0002h
 KEY_CREATE_SUB_KEY     = 0004h
 KEY_ENUMERATE_SUB_KEYS = 0008h
 KEY_NOTIFY             = 0010h
 KEY_CREATE_LINK        = 0020h

 KEY_READ              equ  (STANDARD_RIGHTS_READ       or\
                                  KEY_QUERY_VALUE            or\
                                  KEY_ENUMERATE_SUB_KEYS     or\
                                  KEY_NOTIFY) and not SYNCHRONIZE


 KEY_WRITE            equ   (STANDARD_RIGHTS_WRITE      or\
                                  KEY_SET_VALUE              or\
                                  KEY_CREATE_SUB_KEY) and not SYNCHRONIZE

 KEY_EXECUTE         equ    KEY_READ

 KEY_ALL_ACCESS      equ    (STANDARD_RIGHTS_ALL or \
                                  KEY_QUERY_VALUE  or \
                                  KEY_SET_VALUE     or \
                                  KEY_CREATE_SUB_KEY  or \
                                  KEY_ENUMERATE_SUB_KEYS or \
                                  KEY_NOTIFY         or \
                                  KEY_CREATE_LINK) and not SYNCHRONIZE

HKEY_CLASSES_ROOT      =     80000000h
HKEY_CURRENT_USER      =     80000001h
HKEY_LOCAL_MACHINE     =     80000002h
HKEY_USERS             =     80000003h
HKEY_PERFORMANCE_DATA  =     80000004h
HKEY_CURRENT_CONFIG    =     80000005h
HKEY_DYN_DATA          =     80000006h

;
; Statusbar messages
;
SB_SETTEXT       equ WM_USER+1
SB_SETPARTS      equ WM_USER+4
SB_SIMPLE        equ WM_USER+9
;
;
; Font Weights
;
FW_DONTCARE    =     0
FW_THIN        =     100
FW_EXTRALIGHT  =     200
FW_LIGHT       =     300
FW_NORMAL      =     400
FW_MEDIUM      =     500
FW_SEMIBOLD    =     600
FW_BOLD        =     700
FW_EXTRABOLD   =     800
FW_HEAVY       =     900

FW_ULTRALIGHT  equ     FW_EXTRALIGHT
FW_REGULAR     equ     FW_NORMAL
FW_DEMIBOLD    equ     FW_SEMIBOLD
FW_ULTRABOLD   equ     FW_EXTRABOLD
FW_BLACK       equ     FW_HEAVY


LOGPIXELSX  =  88    ; Logical pixels/inch in X
LOGPIXELSY  =  90    ; Logical pixels/inch in Y
HORZRES     =  8     ; Horizontal width in pixels
VERTRES     =  10    ; Vertical height in pixels



POINT struc
x dd ?
y dd ?
POINT ends

;
; Mapping Modes
;
MM_TEXT          =   1
MM_LOMETRIC      =   2
MM_HIMETRIC      =   3
MM_LOENGLISH     =   4
MM_HIENGLISH     =   5
MM_TWIPS         =   6
MM_ISOTROPIC     =   7
MM_ANISOTROPIC   =   8


;
; Virtual Keys
;
VK_LBUTTON    =    01h
VK_RBUTTON    =    02h
VK_CANCEL     =    03h
VK_MBUTTON    =    04h
VK_BACK       =    08h
VK_TAB        =    09h
VK_CLEAR      =    0Ch
VK_RETURN     =    0Dh
VK_SHIFT      =    10h
VK_CONTROL    =    11h
VK_MENU       =    12h
VK_PAUSE      =    13h
VK_CAPITAL    =    14h
VK_ESCAPE     =    1Bh
VK_SPACE      =    20h
VK_PRIOR      =    21h
VK_NEXT       =    22h
VK_END        =    23h
VK_HOME       =    24h
VK_LEFT       =    25h
VK_UP         =    26h
VK_RIGHT      =    27h
VK_DOWN       =    28h
VK_SELECT     =    29h
VK_PRINT      =    2Ah
VK_EXECUTE    =    2Bh
VK_SNAPSHOT   =    2Ch
VK_INSERT     =    2Dh
VK_DELETE     =    2Eh
VK_HELP       =    2Fh
VK_LWIN       =    5Bh
VK_RWIN       =    5Ch
VK_APPS       =    5Dh
VK_NUMPAD0    =    60h
VK_NUMPAD1    =    61h
VK_NUMPAD2    =    62h
VK_NUMPAD3    =    63h
VK_NUMPAD4    =    64h
VK_NUMPAD5    =    65h
VK_NUMPAD6    =    66h
VK_NUMPAD7    =    67h
VK_NUMPAD8    =    68h
VK_NUMPAD9    =    69h
VK_MULTIPLY   =    6Ah
VK_ADD        =    6Bh
VK_SEPARATOR  =    6Ch
VK_SUBTRACT   =    6Dh
VK_DECIMAL    =    6Eh
VK_DIVIDE     =    6Fh
VK_F1         =    70h
VK_F2         =    71h
VK_F3         =    72h
VK_F4         =    73h
VK_F5         =    74h
VK_F6         =    75h
VK_F7         =    76h
VK_F8         =    77h
VK_F9         =    78h
VK_F10        =    79h
VK_F11        =    7Ah
VK_F12        =    7Bh
VK_F13        =    7Ch
VK_F14        =    7Dh
VK_F15        =    7Eh
VK_F16        =    7Fh
VK_F17        =    80h
VK_F18        =    81h
VK_F19        =    82h
VK_F20        =    83h
VK_F21        =    84h
VK_F22        =    85h
VK_F23        =    86h
VK_F24        =    87h
VK_NUMLOCK    =    90h
VK_SCROLL     =    91h
VK_LSHIFT     =    0A0h
VK_RSHIFT     =    0A1h
VK_LCONTROL   =    0A2h
VK_RCONTROL   =    0A3h
VK_LMENU      =    0A4h
VK_RMENU      =    0A5h
VK_PROCESSKEY =    0E5h
VK_ATTN       =    0F6h
VK_CRSEL      =    0F7h
VK_EXSEL      =    0F8h
VK_EREOF      =    0F9h
VK_PLAY       =    0FAh
VK_ZOOM       =    0FBh
VK_NONAME     =    0FCh
VK_PA1        =    0FDh
VK_OEM_CLEAR  =    0FEh

;
; Find/Replace constants
;
FR_DOWN                   =      00000001h
FR_WHOLEWORD              =      00000002h
FR_MATCHCASE              =      00000004h
FR_FINDNEXT               =      00000008h
FR_REPLACE                =      00000010h
FR_REPLACEALL             =      00000020h
FR_DIALOGTERM             =      00000040h
FR_SHOWHELP                =     00000080h
FR_ENABLEHOOK              =     00000100h
FR_ENABLETEMPLATE          =     00000200h
FR_NOUPDOWN                =     00000400h
FR_NOMATCHCASE             =     00000800h
FR_NOWHOLEWORD             =     00001000h
FR_ENABLETEMPLATEHANDLE    =     00002000h
FR_HIDEUPDOWN              =     00004000h
FR_HIDEMATCHCASE           =     00008000h
FR_HIDEWHOLEWORD           =     00010000h

;
; Choosefont constants
;
CF_SCREENFONTS         =    00000001h
CF_PRINTERFONTS        =    00000002h
CF_BOTH                equ    (CF_SCREENFONTS or CF_PRINTERFONTS)
CF_SHOWHELP            =    00000004h
CF_ENABLEHOOK          =    00000008h
CF_ENABLETEMPLATE      =    00000010h
CF_ENABLETEMPLATEHANDLE =   00000020h
CF_INITTOLOGFONTSTRUCT  =   00000040h
CF_USESTYLE            =    00000080h
CF_EFFECTS             =    00000100h
CF_APPLY               =    00000200h
CF_ANSIONLY            =    00000400h
CF_SCRIPTSONLY         equ CF_ANSIONLY
CF_NOVECTORFONTS       =    00000800h
CF_NOOEMFONTS          equ CF_NOVECTORFONTS
CF_NOSIMULATIONS       =    00001000h
CF_LIMITSIZE           =    00002000h
CF_FIXEDPITCHONLY      =    00004000h
CF_WYSIWYG             =    00008000h
CF_FORCEFONTEXIST      =    00010000h
CF_SCALABLEONLY        =    00020000h
CF_TTONLY              =    00040000h
CF_NOFACESEL           =    00080000h
CF_NOSTYLESEL          =    00100000h
CF_NOSIZESEL           =    00200000h
CF_SELECTSCRIPT        =    00400000h
CF_NOSCRIPTSEL         =    00800000h
CF_NOVERTFONTS         =    01000000h
;
; LOGFONT
;
LOGFONT struc
    lfHeight ULONG ?
    lfWidth ULONG ?
    lfEscapement ULONG ?
    lfOrientation ULONG ?
    lfWeight ULONG ?
    lfItalic UCHAR ?
    lfUnderline UCHAR ?
    lfStrikeOut UCHAR ?
    lfCharSet UCHAR ?
    lfOutPrecision UCHAR ?
    lfClipPrecision UCHAR ?
    lfQuality UCHAR ?
    lfPitchAndFamily UCHAR ?
    lfFaceName UCHAR LF_FACESIZE dup(?)
LOGFONT ends
;
; CHOOSEFONT structure for ChooseFont function
;
CHOOSEFONT struc
   CF_lStructSize ULONG ?
   CF_hwndOwner ULONG ?
   CF_hDC ULONG ?
   CF_lpLogFont ULONG ?
   CF_iPointSize UINT ?
   CF_Flags ULONG ?
   CF_rgbColors COLORREF ?
   CF_lCustData ULONG ?
   CF_lpfnHook ULONG ?
   CF_lpTemplateName ULONG ?
   CF_hInstance ULONG ?
   CF_lpszStyle ULONG ?
   CF_nFontType USHORT ?
    USHORT ?
   CF_nSizeMin UINT ?
   CF_nSizeMax UINT ?
CHOOSEFONT ends
;
; new edit control styles
;
ES_SAVESEL                      =       00008000h
ES_SUNKEN               =               00004000h
ES_DISABLENOSCROLL      =       00002000h
ES_SELECTIONBAR =               01000000h

;
; Toolbar notification messages
;
TBN_FIRST             =  (-700)
TBN_GETBUTTONINFO     =  (TBN_FIRST-0)
TBN_BEGINDRAG         =  (TBN_FIRST-1)
TBN_ENDDRAG           =  (TBN_FIRST-2)
TBN_BEGINADJUST       =  (TBN_FIRST-3)
TBN_ENDADJUST         =  (TBN_FIRST-4)
TBN_RESET             =  (TBN_FIRST-5)
TBN_QUERYINSERT       =  (TBN_FIRST-6)
TBN_QUERYDELETE       =  (TBN_FIRST-7)
TBN_TOOLBARCHANGE     =  (TBN_FIRST-8)
TBN_CUSTHELP          =  (TBN_FIRST-9)

;
;Menu flags for Add/Check/EnableMenuItem()
;
MF_INSERT         =  00000000h
MF_CHANGE         =  00000080h
MF_APPEND         =  00000100h
MF_DELETE         =  00000200h
MF_REMOVE         =  00001000h
MF_BYCOMMAND      =  00000000h
MF_BYPOSITION     =  00000400h
MF_SEPARATOR      =  00000800h
MF_ENABLED        =  00000000h
MF_GRAYED         =  00000001h
MF_DISABLED       =  00000002h
MF_UNCHECKED      =  00000000h
MF_CHECKED        =  00000008h
MF_USECHECKBITMAPS = 00000200h
MF_STRING         =  00000000h
MF_BITMAP         =  00000004h
MF_OWNERDRAW      =  00000100h
MF_POPUP          =  00000010h
MF_MENUBARBREAK   =  00000020h
MF_MENUBREAK      =  00000040h
MF_UNHILITE       =  00000000h
MF_HILITE         =  00000080h
MF_DEFAULT        =  00001000h
MF_SYSMENU        =  00002000h
MF_HELP           =  00004000h
MF_RIGHTJUSTIFY   =  00004000h
MF_MOUSESELECT    =  00008000h
MF_END            =  00000080h
;
; Window field offsets for GetWindowLong()
;
GWL_WNDPROC        = (-4)
GWL_HINSTANCE      = (-6)
GWL_HWNDPARENT     = (-8)
GWL_STYLE          = (-16)
GWL_EXSTYLE        = (-20)
GWL_USERDATA       = (-21)
GWL_ID             = (-12)
;
; CreateFile flags
;
CREATE_NEW        =  1
CREATE_ALWAYS     =  2
OPEN_EXISTING     =  3
OPEN_ALWAYS       =  4
TRUNCATE_EXISTING =  5
DELETE                    =       (00010000h)
READ_CONTROL              =       (00020000h)
WRITE_DAC                 =       (00040000h)
WRITE_OWNER               =       (00080000h)
SYNCHRONIZE               =       (00100000h)
STANDARD_RIGHTS_REQUIRED  =       (000F0000h)
STANDARD_RIGHTS_READ      equ     (READ_CONTROL)
STANDARD_RIGHTS_WRITE     equ     (READ_CONTROL)
STANDARD_RIGHTS_EXECUTE   equ     (READ_CONTROL)
STANDARD_RIGHTS_ALL       =       (001F0000h)
SPECIFIC_RIGHTS_ALL       =       (0000FFFFh)
GENERIC_READ       =              (80000000H)
GENERIC_WRITE      =              (40000000H)
GENERIC_EXECUTE    =              (20000000H)
GENERIC_ALL        =              (10000000H)

FILE_READ_DATA       =     ( 0001h )    ; file & pipe
FILE_LIST_DIRECTORY  =     ( 0001h )    ; directory
FILE_WRITE_DATA      =     ( 0002h )    ; file & pipe
FILE_ADD_FILE        =     ( 0002h )    ; directory
FILE_APPEND_DATA     =     ( 0004h )    ; file
FILE_ADD_SUBDIRECTORY    = ( 0004h )    ; directory
FILE_CREATE_PIPE_INSTANCE  = ( 0004h )  ; named pipe
FILE_READ_EA          =    ( 0008h )    ; file & directory
FILE_READ_PROPERTIES  equ    FILE_READ_EA
FILE_WRITE_EA          =   ( 0010h )    ; file & directory
FILE_WRITE_PROPERTIES  equ   FILE_WRITE_EA
FILE_EXECUTE           =   ( 0020h )    ; file
FILE_TRAVERSE          =   ( 0020h )    ; directory
FILE_DELETE_CHILD      =   ( 0040h )    ; directory
FILE_READ_ATTRIBUTES    =  ( 0080h )    ; all
FILE_WRITE_ATTRIBUTES   =  ( 0100h )    ; all
FILE_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED+SYNCHRONIZE+1FFh)
FILE_GENERIC_READ =         (STANDARD_RIGHTS_READ+FILE_READ_DATA+FILE_READ_ATTRIBUTES+FILE_READ_EA+SYNCHRONIZE)
FILE_GENERIC_WRITE  =       (STANDARD_RIGHTS_WRITE+FILE_WRITE_DATA+FILE_WRITE_ATTRIBUTES+FILE_WRITE_EA+FILE_APPEND_DATA+SYNCHRONIZE)
FILE_GENERIC_EXECUTE =     (STANDARD_RIGHTS_EXECUTE+FILE_READ_ATTRIBUTES+FILE_EXECUTE+SYNCHRONIZE)

FILE_SHARE_READ               =  00000001h
FILE_SHARE_WRITE              =  00000002h
FILE_ATTRIBUTE_READONLY       =  00000001h
FILE_ATTRIBUTE_HIDDEN         =  00000002h
FILE_ATTRIBUTE_SYSTEM         =  00000004h
FILE_ATTRIBUTE_DIRECTORY      =  00000010h
FILE_ATTRIBUTE_ARCHIVE        =  00000020h
FILE_ATTRIBUTE_NORMAL         =  00000080h
FILE_ATTRIBUTE_TEMPORARY      =  00000100h
FILE_ATTRIBUTE_COMPRESSED     =  00000800h
FILE_NOTIFY_CHANGE_FILE_NAME  =  00000001h
FILE_NOTIFY_CHANGE_DIR_NAME   =  00000002h
FILE_NOTIFY_CHANGE_ATTRIBUTES =  00000004h
FILE_NOTIFY_CHANGE_SIZE       =  00000008h
FILE_NOTIFY_CHANGE_LAST_WRITE =  00000010h
FILE_NOTIFY_CHANGE_SECURITY   =  00000100h
MAILSLOT_NO_MESSAGE           =  ((DWORD)-1)
MAILSLOT_WAIT_FOREVER         =  ((DWORD)-1)
FILE_CASE_SENSITIVE_SEARCH    =  00000001h
FILE_CASE_PRESERVED_NAMES     =  00000002h
FILE_UNICODE_ON_DISK          =  00000004h
FILE_PERSISTENT_ACLS          =  00000008h
FILE_FILE_COMPRESSION         =  00000010h
FILE_VOLUME_IS_COMPRESSED     =  00008000h
IO_COMPLETION_MODIFY_STATE    =  0002h
IO_COMPLETION_ALL_ACCESS      = (STANDARD_RIGHTS_REQUIRED+SYNCHRONIZE+3h)
DUPLICATE_CLOSE_SOURCE        =  00000001h
DUPLICATE_SAME_ACCESS         =  00000002h
;
; Edit Control Styles
;
 ES_LEFT           =  0000h
 ES_CENTER         =  0001h
 ES_RIGHT          =  0002h
 ES_MULTILINE      =  0004h
 ES_UPPERCASE      =  0008h
 ES_LOWERCASE      =  0010h
 ES_PASSWORD       =  0020h
 ES_AUTOVSCROLL    =  0040h
 ES_AUTOHSCROLL    =  0080h
 ES_NOHIDESEL      =  0100h
 ES_OEMCONVERT     =  0400h
 ES_READONLY       =  0800h
 ES_WANTRETURN     =  1000h
 ES_NUMBER         =  2000h

;
; Edit Control Notification Codes
;
 EN_SETFOCUS       = 0100h
 EN_KILLFOCUS      = 0200h
 EN_CHANGE         = 0300h
 EN_UPDATE         = 0400h
 EN_ERRSPACE       = 0500h
 EN_MAXTEXT        = 0501h
 EN_HSCROLL        = 0601h
 EN_VSCROLL        = 0602h

;
; Local Memory Flags
;
LMEM_FIXED        =  0000h
LMEM_MOVEABLE     =  0002h
LMEM_NOCOMPACT    =  0010h
LMEM_NODISCARD    =  0020h
LMEM_ZEROINIT     =  0040h
LMEM_MODIFY       =  0080h
LMEM_DISCARDABLE  =  0F00h
LMEM_VALID_FLAGS  =  0F72h
LMEM_INVALID_HANDLE = 8000h


;
;Global Memory Flags
;
GMEM_FIXED        =  0000h
GMEM_MOVEABLE     =  0002h
GMEM_NOCOMPACT    =  0010h
GMEM_NODISCARD    =  0020h
GMEM_ZEROINIT     =  0040h
GMEM_MODIFY       =  0080h
GMEM_DISCARDABLE  =  0100h
GMEM_NOT_BANKED   =  1000h
GMEM_SHARE        =  2000h
GMEM_DDESHARE     =  2000h
GMEM_NOTIFY       =  4000h
GMEM_LOWER        equ  GMEM_NOT_BANKED
GMEM_VALID_FLAGS  =  7F72h
GMEM_INVALID_HANDLE  = 8000h

GHND             equ   (GMEM_MOVEABLE | GMEM_ZEROINIT)
GPTR             equ   (GMEM_FIXED | GMEM_ZEROINIT)

;
; Predefined Clipboard Formats
;
CF_TEXT         =     1
CF_BITMAP       =     2
CF_METAFILEPICT =     3
CF_SYLK         =     4
CF_DIF          =     5
CF_TIFF         =     6
CF_OEMTEXT      =     7
CF_DIB          =     8
CF_PALETTE      =     9
CF_PENDATA      =     10
CF_RIFF         =     11
CF_WAVE         =     12
CF_UNICODETEXT  =     13
CF_ENHMETAFILE  =     14
CF_HDROP         =   15
CF_LOCALE        =   16
CF_MAX           =   17
CF_OWNERDISPLAY  =   0080h
CF_DSPTEXT       =   0081h
CF_DSPBITMAP      =  0082h
CF_DSPMETAFILEPICT =  0083h
CF_DSPENHMETAFILE  = 008Eh

;
;
; Ternary raster operations
;
SRCCOPY        =     00CC0020h ;/* dest = source                   */
SRCPAINT       =     00EE0086h ;/* dest = source OR dest           */
SRCAND         =     008800C6h ;/* dest = source AND dest          */
SRCINVERT      =     00660046h ;/* dest = source XOR dest          */
SRCERASE       =     00440328h ;/* dest = source AND (NOT dest )   */
NOTSRCCOPY     =     00330008h ;/* dest = (NOT source)             */
NOTSRCERASE    =     001100A6h ;/* dest = (NOT src) AND (NOT dest) */
MERGECOPY      =     00C000CAh ;/* dest = (source AND pattern)     */
MERGEPAINT     =     00BB0226h ;/* dest = (NOT source) OR dest     */
PATCOPY        =     00F00021h ;/* dest = pattern                  */
PATPAINT       =     00FB0A09h ;/* dest = DPSnoo                   */
PATINVERT      =     005A0049h ;/* dest = pattern XOR dest         */
DSTINVERT      =     00550009h ;/* dest = (NOT dest)               */
BLACKNESS      =     00000042h ;/* dest = BLACK                    */
WHITENESS      =     00FF0062h ;/* dest = WHITE                    */



;
; Commands to pass to WinHelp()
;
HELP_CONTEXT     = 0001h
HELP_QUIT        = 0002h
HELP_INDEX       = 0003h
HELP_CONTENTS    = 0003h
HELP_HELPONHELP  = 0004h
HELP_SETINDEX    = 0005h
HELP_SETCONTENTS = 0005h
HELP_CONTEXTPOPUP = 0008h
HELP_FORCEFILE   = 0009h
HELP_KEY         = 0101h
HELP_COMMAND     = 0102h
HELP_PARTIALKEY  = 0105h
HELP_MULTIKEY    = 0201h
HELP_SETWINPOS   = 0203h
HELP_CONTEXTMENU = 000ah
HELP_FINDER      = 000bh
HELP_WM_HELP     = 000ch
HELP_SETPOPUP_POS = 000dh

HELP_TCARD             = 8000h
HELP_TCARD_DATA        = 0010h
HELP_TCARD_OTHER_CALLER  = 0011h

IDH_NO_HELP                =     28440
IDH_MISSING_CONTEXT        =     28441
IDH_GENERIC_HELP_BUTTON    =     28442
IDH_OK                     =     28443
IDH_CANCEL                 =     28444
IDH_HELP                   =     28445
;*******************************************************************
;
;       OFSTRUCT
;
;*******************************************************************
OF_READ             = 00000000h
OF_WRITE            = 00000001h
OF_READWRITE        = 00000002h
OF_SHARE_COMPAT     = 00000000h
OF_SHARE_EXCLUSIVE  = 00000010h
OF_SHARE_DENY_WRITE = 00000020h
OF_SHARE_DENY_READ  = 00000030h
OF_SHARE_DENY_NONE  = 00000040h
OF_PARSE            = 00000100h
OF_DELETE           = 00000200h
OF_VERIFY           = 00000400h
OF_CANCEL           = 00000800h
OF_CREATE           = 00001000h
OF_PROMPT           = 00002000h
OF_EXIST            = 00004000h
OF_REOPEN           = 00008000h
OFS_MAXPATHNAME     = 128

OFSTRUCT struc
    cBytes UCHAR ?
    fFixedDisk UCHAR ?
    nErrCode USHORT ?
    Reserved1 USHORT ?
    Reserved2 USHORT ?
    szPathName db OFS_MAXPATHNAME dup(?)
OFSTRUCT ends


;*******************************************************************
;
;       OPENFILENAME
;
;*******************************************************************
OPENFILENAME struc
   lStructSize ULONG ?
   hwndOwner ULONG ?
   hInstance ULONG ?
   lpstrFilter ULONG ?
   lpstrCustomFilter ULONG ?
   nMaxCustFilter ULONG ?
   nFilterIndex ULONG ?
   lpstrFile ULONG ?
   nMaxFile ULONG ?
   lpstrFileTitle ULONG ?
   nMaxFileTitle ULONG ?
   lpstrInitialDir ULONG ?
   lpstrTitle ULONG ?
   Flags ULONG ?
   nFileOffset USHORT ?
   nFileExtension USHORT ?
   lpstrDefExt ULONG ?
   lCustData ULONG ?
   lpfnHook ULONG ?
   lpTemplateName ULONG ?
OPENFILENAME ends

OFN_READONLY              =   00000001h
OFN_OVERWRITEPROMPT       =   00000002h
OFN_HIDEREADONLY          =   00000004h
OFN_NOCHANGEDIR           =   00000008h
OFN_SHOWHELP              =   00000010h
OFN_ENABLEHOOK            =   00000020h
OFN_ENABLETEMPLATE        =   00000040h
OFN_ENABLETEMPLATEHANDLE  =   00000080h
OFN_NOVALIDATE            =   00000100h
OFN_ALLOWMULTISELECT      =   00000200h
OFN_EXTENSIONDIFFERENT    =   00000400h
OFN_PATHMUSTEXIST         =   00000800h
OFN_FILEMUSTEXIST         =   00001000h
OFN_CREATEPROMPT          =   00002000h
OFN_SHAREAWARE            =   00004000h
OFN_NOREADONLYRETURN      =   00008000h
OFN_NOTESTFILECREATE      =   00010000h
OFN_NONETWORKBUTTON       =   00020000h
OFN_NOLONGNAMES           =   00040000h
OFN_EXPLORER              =   00080000h
OFN_NODEREFERENCELINKS    =   00100000h
OFN_LONGNAMES             =   00200000h
OFN_SHAREFALLTHROUGH      =   2
OFN_SHARENOWARN           =   1
OFN_SHAREWARN             =   0

;*******************************************************************
;
;       PRINTDLG
;
;*******************************************************************
PRINTDLG struc
   pdlStructSize ULONG ?
   pdhwndOwner ULONG ?
   pdhDevMode ULONG ?
   pdhDevNames ULONG ?
   pdhDC ULONG ?
   pdFlags ULONG ?
   pdnFromPage USHORT ?
   pdnToPage USHORT ?
   pdnMinPage USHORT ?
   pdnMaxPage USHORT ?
   pdnCopies USHORT ?
   pdhInstance ULONG ?
   pdlCustData ULONG  ?
   pdlpfnPrintHook ULONG ?
   pdlpfnSetupHook ULONG ?
   pdlpPrintTemplateName ULONG ?
   pdlpSetupTemplateName ULONG ?
   pdhPrintTemplate ULONG ?
   pdhSetupTemplate ULONG ?
PRINTDLG ends

PD_ALLPAGES              =    00000000h
PD_SELECTION             =    00000001h
PD_PAGENUMS              =    00000002h
PD_NOSELECTION           =    00000004h
PD_NOPAGENUMS            =    00000008h
PD_COLLATE               =    00000010h
PD_PRINTTOFILE           =    00000020h
PD_PRINTSETUP            =    00000040h
PD_NOWARNING             =    00000080h
PD_RETURNDC              =    00000100h
PD_RETURNIC              =    00000200h
PD_RETURNDEFAULT         =    00000400h
PD_SHOWHELP              =    00000800h
PD_ENABLEPRINTHOOK       =    00001000h
PD_ENABLESETUPHOOK       =    00002000h
PD_ENABLEPRINTTEMPLATE   =    00004000h
PD_ENABLESETUPTEMPLATE   =    00008000h
PD_ENABLEPRINTTEMPLATEHANDLE = 00010000h
PD_ENABLESETUPTEMPLATEHANDLE  = 00020000h
PD_USEDEVMODECOPIES         = 00040000h
PD_USEDEVMODECOPIESANDCOLLATE = 00040000h
PD_DISABLEPRINTTOFILE     =   00080000h
PD_HIDEPRINTTOFILE        =   00100000h
PD_NONETWORKBUTTON        =   00200000h

DOCINFO struc
    cbSize UINT ?
    lpszDocName ULONG ?
    lpszOutput ULONG ?
    lpszDatatype ULONG ?
    fwType ULONG ?
DOCINFO ends


;*******************************************************************
;
;       SYSTEMTIME
;
;*******************************************************************
SYSTEMTIME struc
    wYear USHORT ?
    wMonth USHORT ?
    wDayOfWeek USHORT ?
    wDay USHORT ?
    wHour USHORT ?
    wMinute USHORT ?
    wSecond USHORT ?
    wMilliseconds USHORT ?
SYSTEMTIME ends
;*******************************************************************
;
;       TBBUTTON
;
;*******************************************************************
TBBUTTON struc
    iBitmap UINT ?
    idCommand UINT ?
    fsState UCHAR ?
    fsStyle UCHAR ?
    bReserved db 2 dup(?)
    dwData ULONG ?
    iString UINT ?
TBBUTTON ends

STD_CUT             =    0
STD_COPY            =    1
STD_PASTE           =    2
STD_UNDO            =    3
STD_REDOW           =    4
STD_DELETE          =    5
STD_FILENEW         =    6
STD_FILEOPEN        =    7
STD_FILESAVE        =    8
STD_PRINTPRE        =    9
STD_PROPERTIES      =    10
STD_HELP            =    11
STD_FIND            =    12
STD_REPLACE         =    13
STD_PRINT           =    14

TBSTATE_CHECKED       =  01h
TBSTATE_PRESSED       =  02h
TBSTATE_ENABLED       =  04h
TBSTATE_HIDDEN        =  08h
TBSTATE_INDETERMINATE =  10h
TBSTATE_WRAP          =  20h

TBSTYLE_BUTTON        =  00h
TBSTYLE_SEP           =  01h
TBSTYLE_CHECK         =  02h
TBSTYLE_GROUP         =  04h
TBSTYLE_CHECKGROUP    =  TBSTYLE_GROUP+TBSTYLE_CHECK

TBSTYLE_TOOLTIPS      =  0100h
TBSTYLE_WRAPABLE      =  0200h
TBSTYLE_ALTDRAG       =  0400h

TB_ENABLEBUTTON       =  (WM_USER + 1)
TB_CHECKBUTTON        =  (WM_USER + 2)
TB_PRESSBUTTON        =  (WM_USER + 3)
TB_HIDEBUTTON         =  (WM_USER + 4)
TB_INDETERMINATE      =  (WM_USER + 5)
TB_ISBUTTONENABLED    =  (WM_USER + 9)
TB_ISBUTTONCHECKED    =  (WM_USER + 10)
TB_ISBUTTONPRESSED    =  (WM_USER + 11)
TB_ISBUTTONHIDDEN     =  (WM_USER + 12)
TB_ISBUTTONINDETERMINATE = (WM_USER + 13)
TB_SETSTATE           =  (WM_USER + 17)
TB_GETSTATE           =  (WM_USER + 18)
TB_ADDBITMAP          =  (WM_USER + 19)
TB_SAVERESTOREA       =  (WM_USER + 26)
TB_SAVERESTOREW       =  (WM_USER + 76)
TB_CUSTOMIZE          =  (WM_USER + 27)
TB_ADDSTRINGA         =  (WM_USER + 28)
TB_ADDSTRINGW         =  (WM_USER + 77)
TB_GETITEMRECT        =  (WM_USER + 29)
TB_BUTTONSTRUCTSIZE   =  (WM_USER + 30)
TB_SETBUTTONSIZE      =  (WM_USER + 31)
TB_SETBITMAPSIZE      =  (WM_USER + 32)
TB_AUTOSIZE           =  (WM_USER + 33)
TB_GETTOOLTIPS        =  (WM_USER + 35)
TB_SETTOOLTIPS        =  (WM_USER + 36)
TB_SETPARENT          =  (WM_USER + 37)
TB_SETROWS            =  (WM_USER + 39)
TB_GETROWS            =  (WM_USER + 40)
TB_SETCMDID           =  (WM_USER + 42)
TB_CHANGEBITMAP       =  (WM_USER + 43)
TB_GETBITMAP          =  (WM_USER + 44)
TB_GETBUTTONTEXTA     =  (WM_USER + 45)
TB_GETBUTTONTEXTW     =  (WM_USER + 75)
TB_REPLACEBITMAP      =  (WM_USER + 46)

;====== COMMON CONTROL STYLES =====

CCS_TOP            =     00000001h
CCS_NOMOVEY        =     00000002h
CCS_BOTTOM         =     00000003h
CCS_NORESIZE       =     00000004h
CCS_NOPARENTALIGN  =     00000008h
CCS_ADJUSTABLE     =     00000020h
CCS_NODIVIDER      =     00000040h

;*******************************************************************
;
;       NMHDR
;
;*******************************************************************
NMHDR struc
    hwndFrom UINT ?
    idFrom UINT ?
    code UINT ?
NMHDR ends

;*******************************************************************
;
;       TOOLTIPTEXT
;
;*******************************************************************
TOOLTIPTEXT struc
    hdr NMHDR <?>
    lpszText ULONG ?
    szText db 80 dup(?)
    hinst ULONG ?
    uFlags UINT ?
TOOLTIPTEXT ends

TTN_NEEDTEXT equ 0FFFFFDF8h
;*******************************************************************
;
;       TEXTMETRIC
;
;*******************************************************************
TEXTMETRIC struc
    tmHeight ULONG ?
    tmAscent ULONG ?
    tmDescent ULONG ?
    tmInternalLeading ULONG ?
    tmExternalLeading ULONG ?
    tmAveCharWidth ULONG ?
    tmMaxCharWidth ULONG ?
    tmWeight ULONG ?
    tmOverhang ULONG ?
    tmDigitizedAspectX ULONG ?
    tmDigitizedAspectY ULONG ?
    tmFirstChar UCHAR ?
    tmLastChar UCHAR ?
    tmDefaultChar UCHAR ?
    tmBreakChar UCHAR ?
    tmItalic UCHAR ?
    tmUnderlined UCHAR ?
    tmStruckOut UCHAR ?
    tmPitchAndFamily UCHAR ?
    tmCharSet UCHAR ?
TEXTMETRIC ends
;*******************************************************************
;
;       Rectangle
;
;*******************************************************************

RECT    struc
        rcLeft          UINT ?
        rcTop           UINT ?
        rcRight         UINT ?
        rcBottom        UINT ?
RECT    ends

;*******************************************************************
;
;  Window Class structure
;
;*******************************************************************

WNDCLASS struc
        clsStyle          UINT     ?
        clsLpfnWndProc    ULONG    ?
        clsCbClsExtra     UINT     ?
        clsCbWndExtra     UINT     ?
        clsHInstance      UINT     ?
        clsHIcon          UINT     ?
        clsHCursor        UINT     ?
        clsHbrBackground  UINT     ?
        clsLpszMenuName   ULONG    ?
        clsLpszClassName  ULONG    ?
        hIconSm           UINT     ?
WNDCLASS ends

PAINTSTRUCT STRUC
    PShdc         UINT             ?
    PSfErase      UINT             ?
    PSrcPaint     UCHAR            size RECT dup(?)
    PSfRestore    UINT             ?
    PSfIncUpdate  UINT             ?
    PSrgbReserved UCHAR            32 dup(?)
PAINTSTRUCT ENDS

MSGSTRUCT struc
    msgHWND          ULONG   ?
    msgMESSAGE       ULONG   ?
    msgWPARAM        ULONG   ?
    msgLPARAM        ULONG   ?
    msgTIME          ULONG   ?
    msgPT            POINT   <?>
MSGSTRUCT ends

MINMAXINFO struc
  res_x               dd ?
  res_y               dd ?
  maxsize_x           dd ?
  maxsize_y           dd ?
  maxposition_x       dd ?
  maxposition_y       dd ?
  mintrackposition_x  dd ?
  mintrackposition_y  dd ?
  maxtrackposition_x  dd ?
  maxtrackposition_y  dd ?
MINMAXINFO ends
;
;   System Metrics
;
SM_CXSCREEN         =    0
SM_CYSCREEN         =    1
SM_CXVSCROLL        =    2
SM_CYHSCROLL        =    3
SM_CYCAPTION        =    4
SM_CXBORDER         =    5
SM_CYBORDER         =    6
SM_CXDLGFRAME       =    7
SM_CYDLGFRAME       =    8
SM_CYVTHUMB         =    9
SM_CXHTHUMB         =    10
SM_CXICON           =    11
SM_CYICON           =    12
SM_CXCURSOR         =    13
SM_CYCURSOR         =    14
SM_CYMENU           =    15
SM_CXFULLSCREEN     =    16
SM_CYFULLSCREEN     =    17
SM_CYKANJIWINDOW    =    18
SM_MOUSEPRESENT     =    19
SM_CYVSCROLL        =    20
SM_CXHSCROLL        =    21
SM_DEBUG            =    22
SM_SWAPBUTTON       =    23
SM_RESERVED1        =    24
SM_RESERVED2        =    25
SM_RESERVED3        =    26
SM_RESERVED4        =    27
SM_CXMIN            =    28
SM_CYMIN            =    29
SM_CXSIZE           =    30
SM_CYSIZE           =    31
SM_CXFRAME          =    32
SM_CYFRAME          =    33
SM_CXMINTRACK       =    34
SM_CYMINTRACK       =    35
SM_CXDOUBLECLK      =    36
SM_CYDOUBLECLK      =    37
SM_CXICONSPACING    =    38
SM_CYICONSPACING    =    39
SM_MENUDROPALIGNMENT =    40
SM_PENWINDOWS       =    41
SM_DBCSENABLED      =    42
SM_CMOUSEBUTTONS    =    43
SM_CXFIXEDFRAME     equ      <SM_CXDLGFRAME>
SM_CYFIXEDFRAME     equ      <SM_CYDLGFRAME>
SM_CXSIZEFRAME      equ      <SM_CXFRAME>
SM_CYSIZEFRAME      equ      <SM_CYFRAME>
SM_SECURE           =    44
SM_CXEDGE           =    45
SM_CYEDGE           =    46
SM_CXMINSPACING     =    47
SM_CYMINSPACING     =    48
SM_CXSMICON         =    49
SM_CYSMICON         =    50
SM_CYSMCAPTION      =    51
SM_CXSMSIZE         =    52
SM_CYSMSIZE         =    53
SM_CXMENUSIZE       =    54
SM_CYMENUSIZE       =    55
SM_ARRANGE          =    56
SM_CXMINIMIZED      =    57
SM_CYMINIMIZED      =    58
SM_CXMAXTRACK       =    59
SM_CYMAXTRACK       =    60
SM_CXMAXIMIZED      =    61
SM_CYMAXIMIZED      =    62
SM_NETWORK          =    63
SM_CLEANBOOT        =    67
SM_CXDRAG           =    68
SM_CYDRAG           =    69
SM_SHOWSOUNDS       =    70
SM_CXMENUCHECK      =    71
SM_CYMENUCHECK      =    72
SM_SLOWMACHINE      =    73
SM_MIDEASTENABLED   =    74
SM_CMETRICS         =    75
;
;  Stock Logical Objects
;
WHITE_BRUSH         =  0
LTGRAY_BRUSH        =  1
GRAY_BRUSH          =  2
DKGRAY_BRUSH        =  3
BLACK_BRUSH         =  4
NULL_BRUSH          =  5
HOLLOW_BRUSH        =  5
WHITE_PEN           =  6
BLACK_PEN           =  7
NULL_PEN            =  8
DOT_MARKER          =  9
OEM_FIXED_FONT      = 10
ANSI_FIXED_FONT     = 11
ANSI_VAR_FONT       = 12
SYSTEM_FONT         = 13
DEVICE_DEFAULT_FONT = 14
DEFAULT_PALETTE     = 15
SYSTEM_FIXED_FONT   = 16

;
; Brush Styles
;
BS_SOLID        =   0
BS_NULL         =   1
BS_HOLLOW       =   BS_NULL
BS_HATCHED      =   2
BS_PATTERN      =   3
BS_INDEXED      =   4
BS_DIBPATTERN   =   5
;
; Hatch Styles
;
HS_HORIZONTAL   =   0       ; -----
HS_VERTICAL     =   1       ; |||||
HS_FDIAGONAL    =   2       ; \\\\\
HS_BDIAGONAL    =   3       ; /////
HS_CROSS        =   4       ; +++++
HS_DIAGCROSS    =   5       ; xxxxx
;
; Pen Styles
;
PS_SOLID        =   0
PS_DASH         =   1       ; -------
PS_DOT          =   2       ; .......
PS_DASHDOT      =   3       ; _._._._
PS_DASHDOTDOT   =   4       ; _.._.._
PS_NULL         =   5
PS_INSIDEFRAME  =   6

;
;  Window State Messages
;
IFNDEF  NOWM
WM_STATE            = 0000H

WM_NULL             = 0000h
WM_CREATE           = 0001h
WM_DESTROY          = 0002h
WM_MOVE             = 0003h
WM_SIZE             = 0005h
WM_ACTIVATE         = 0006h
WM_SETFOCUS         = 0007h
WM_KILLFOCUS        = 0008h
WM_ENABLE           = 000Ah
WM_SETREDRAW        = 000Bh
WM_SETTEXT          = 000Ch
WM_GETTEXT          = 000Dh
WM_GETTEXTLENGTH    = 000Eh
WM_PAINT            = 000Fh
WM_CLOSE            = 0010h
WM_QUERYENDSESSION  = 0011h
WM_QUIT             = 0012h
WM_QUERYOPEN        = 0013h
WM_ERASEBKGND       = 0014h
WM_SYSCOLORCHANGE   = 0015h
WM_ENDSESSION       = 0016h
WM_SYSTEMERROR      = 0017h
WM_SHOWWINDOW       = 0018h
WM_CTLCOLOR         = 0019h
WM_WININICHANGE     = 001Ah
WM_DEVMODECHANGE    = 001Bh
WM_ACTIVATEAPP      = 001Ch
WM_FONTCHANGE       = 001Dh
WM_TIMECHANGE       = 001Eh
WM_CANCELMODE       = 001Fh
WM_SETCURSOR        = 0020h
WM_MOUSEACTIVATE    = 0021h
WM_CHILDACTIVATE    = 0022h
WM_QUEUESYNC        = 0023h
WM_GETMINMAXINFO    = 0024h
WM_PAINTICON        = 0026h
WM_ICONERASEBKGND   = 0027h
WM_NEXTDLGCTL       = 0028h
WM_SPOOLERSTATUS    = 002Ah
WM_DRAWITEM         = 002Bh
WM_MEASUREITEM      = 002Ch
WM_DELETEITEM       = 002Dh
WM_VKEYTOITEM       = 002Eh
WM_CHARTOITEM       = 002Fh
WM_SETFONT          = 0030h
WM_GETFONT          = 0031h
WM_QUERYDRAGICON    = 0037h
WM_COMPAREITEM      = 0039h
WM_COMPACTING       = 0041h
WM_COMMNOTIFY       = 0044h
WM_WINDOWPOSCHANGING= 0046h
WM_WINDOWPOSCHANGED = 0047h
WM_POWER            = 0048h
WM_NOTIFY           = 004eh

WM_NCCREATE         = 0081h
WM_NCDESTROY        = 0082h
WM_NCCALCSIZE       = 0083h
WM_NCHITTEST        = 0084h
WM_NCPAINT          = 0085h
WM_NCACTIVATE       = 0086h
WM_GETDLGCODE       = 0087h
WM_NCMOUSEMOVE      = 00A0h
WM_NCLBUTTONDOWN    = 00A1h
WM_NCLBUTTONUP      = 00A2h
WM_NCLBUTTONDBLCLK  = 00A3h
WM_NCRBUTTONDOWN    = 00A4h
WM_NCRBUTTONUP      = 00A5h
WM_NCRBUTTONDBLCLK  = 00A6h
WM_NCMBUTTONDOWN    = 00A7h
WM_NCMBUTTONUP      = 00A8h
WM_NCMBUTTONDBLCLK  = 00A9h

WM_KEYFIRST         = 0100h
WM_KEYDOWN          = 0100h
WM_KEYUP            = 0101h
WM_CHAR             = 0102h
WM_DEADCHAR         = 0103h
WM_SYSKEYDOWN       = 0104h
WM_SYSKEYUP         = 0105h
WM_SYSCHAR          = 0106h
WM_SYSDEADCHAR      = 0107h
WM_KEYLAST          = 0108h

WM_INITDIALOG       = 0110h
WM_COMMAND          = 0111h
WM_SYSCOMMAND       = 0112h
WM_TIMER            = 0113h
WM_HSCROLL          = 0114h
WM_VSCROLL          = 0115h
WM_INITMENU         = 0116h
WM_INITMENUPOPUP    = 0117h
WM_MENUSELECT       = 011Fh
WM_MENUCHAR         = 0120h
WM_ENTERIDLE        = 0121h
WM_CTLCOLOREDIT     = 0133h
WM_CTLCOLORBTN      = 0135h
WM_CTLCOLORDLG      = 0136h
WM_CTLCOLORSTATIC   = 0138h

WM_MOUSEFIRST       = 0200h
WM_MOUSEMOVE        = 0200h
WM_LBUTTONDOWN      = 0201h
WM_LBUTTONUP        = 0202h
WM_LBUTTONDBLCLK    = 0203h
WM_RBUTTONDOWN      = 0204h
WM_RBUTTONUP        = 0205h
WM_RBUTTONDBLCLK    = 0206h
WM_MBUTTONDOWN      = 0207h
WM_MBUTTONUP        = 0208h
WM_MBUTTONDBLCLK    = 0209h
WM_MOUSELAST        = 0209h

WM_PARENTNOTIFY     = 0210h
WM_MDICREATE        = 0220h
WM_MDIDESTROY       = 0221h
WM_MDIACTIVATE      = 0222h
WM_MDIRESTORE       = 0223h
WM_MDINEXT          = 0224h
WM_MDIMAXIMIZE      = 0225h
WM_MDITILE          = 0226h
WM_MDICASCADE       = 0227h
WM_MDIICONARRANGE   = 0228h
WM_MDIGETACTIVE     = 0229h
WM_MDISETMENU       = 0230h
WM_DROPFILES        = 0233h


WM_CUT              = 0300h
WM_COPY             = 0301h
WM_PASTE            = 0302h
WM_CLEAR            = 0303h
WM_UNDO             = 0304h
WM_RENDERFORMAT     = 0305h
WM_RENDERALLFORMATS = 0306h
WM_DESTROYCLIPBOARD = 0307h
WM_DRAWCLIPBOARD    = 0308h
WM_PAINTCLIPBOARD   = 0309h
WM_VSCROLLCLIPBOARD = 030Ah
WM_SIZECLIPBOARD    = 030Bh
WM_ASKCBFORMATNAME  = 030Ch
WM_CHANGECBCHAIN    = 030Dh
WM_HSCROLLCLIPBOARD = 030Eh
WM_QUERYNEWPALETTE  = 030Fh
WM_PALETTEISCHANGING = 0310h
WM_PALETTECHANGED   = 0311h

WM_PENWINFIRST      equ 0380h
WM_PENWINLAST       equ 038Fh

WM_COALESCE_FIRST  equ 0390h
WM_COALESCE_LAST   equ 039Fh

;  private window messages start here
WM_USER             = 0400H
ENDIF           ; NOWM

; WM_MOUSEACTIVATE Return Codes
MA_ACTIVATE       =  1
MA_ACTIVATEANDEAT =  2
MA_NOACTIVATE     =  3

; Size message commands
SIZENORMAL       = 0
SIZEICONIC       = 1
SIZEFULLSCREEN   = 2
SIZEZOOMSHOW     = 3
SIZEZOOMHIDE     = 4

; ShowWindow() Commands
SW_HIDE            = 0
SW_SHOWNORMAL      = 1
SW_NORMAL          = 1
SW_SHOWMINIMIZED   = 2
SW_SHOWMAXIMIZED   = 3
SW_MAXIMIZE        = 3
SW_SHOWNOACTIVATE  = 4
SW_SHOW            = 5
SW_MINIMIZE        = 6
SW_SHOWMINNOACTIVE = 7
SW_SHOWNA          = 8
SW_RESTORE         = 9

; Old ShowWindow() Commands
HIDE_WINDOW        = 0
SHOW_OPENWINDOW    = 1
SHOW_ICONWINDOW    = 2
SHOW_FULLSCREEN    = 3
SHOW_OPENNOACTIVATE= 4

;  identifiers for the WM_SHOWWINDOW message
SW_PARENTCLOSING =  1
SW_OTHERZOOM     =  2
SW_PARENTOPENING =  3
SW_OTHERUNZOOM   =  4
;
; Key state masks for mouse messages
;
MK_LBUTTON       = 0001h
MK_RBUTTON       = 0002h
MK_SHIFT         = 0004h
MK_CONTROL       = 0008h
MK_MBUTTON       = 0010h
;
; Class styles
;
CS_VREDRAW         = 0001h
CS_HREDRAW         = 0002h
CS_KEYCVTWINDOW    = 0004H
CS_DBLCLKS         = 0008h
SBS_SIZEGRIP       = 0010h
CS_OWNDC           = 0020h
CS_CLASSDC         = 0040h
CS_PARENTDC        = 0080h
CS_NOKEYCVT        = 0100h
CS_SAVEBITS        = 0800h
CS_NOCLOSE         = 0200h
CS_BYTEALIGNCLIENT = 1000h
CS_BYTEALIGNWINDOW = 2000h
CS_GLOBALCLASS     = 4000h    ; Global window class

;
; Special CreateWindow position value
;
CW_USEDEFAULT   EQU    8000h

;
; Windows styles
;
WS_OVERLAPPED   = 000000000h
WS_ICONICPOPUP  = 0C0000000h
WS_POPUP        = 080000000h
WS_CHILD        = 040000000h
WS_MINIMIZE     = 020000000h
WS_VISIBLE      = 010000000h
WS_DISABLED     = 008000000h
WS_CLIPSIBLINGS = 004000000h
WS_CLIPCHILDREN = 002000000h
WS_MAXIMIZE     = 001000000h
WS_CAPTION      = 000C00000h     ; WS_BORDER | WS_DLGFRAME
WS_BORDER       = 000800000h
WS_DLGFRAME     = 000400000h
WS_VSCROLL      = 000200000h
WS_HSCROLL      = 000100000h
WS_SYSMENU      = 000080000h
WS_THICKFRAME   = 000040000h
WS_HREDRAW      = 000020000h
WS_VREDRAW      = 000010000h
WS_GROUP        = 000020000h
WS_TABSTOP      = 000010000h
WS_MINIMIZEBOX  = 000020000h
WS_MAXIMIZEBOX  = 000010000h

; Common Window Styles

WS_OVERLAPPEDWINDOW = WS_OVERLAPPED OR WS_CAPTION OR WS_SYSMENU OR WS_THICKFRAME OR WS_MINIMIZEBOX OR WS_MAXIMIZEBOX
WS_POPUPWINDOW  = WS_POPUP OR WS_BORDER OR WS_SYSMENU
WS_CHILDWINDOW  = WS_CHILD
WS_TILEDWINDOW  = WS_OVERLAPPEDWINDOW

WS_TILED        = WS_OVERLAPPED
WS_ICONIC       = WS_MINIMIZE
WS_SIZEBOX      = WS_THICKFRAME

;
;Extended Window Styles
;
WS_EX_DLGMODALFRAME   = 00000001h
WS_EX_NOPARENTNOTIFY  = 00000004h
WS_EX_TOPMOST         = 00000008h
WS_EX_ACCEPTFILES     = 00000010h
WS_EX_TRANSPARENT     = 00000020h
WS_EX_MDICHILD        = 00000040h
WS_EX_TOOLWINDOW      = 00000080h
WS_EX_WINDOWEDGE      = 00000100h
WS_EX_CLIENTEDGE      = 00000200h
WS_EX_CONTEXTHELP     = 00000400h
WS_EX_RIGHT           = 00001000h
WS_EX_LEFT            = 00000000h
WS_EX_RTLREADING      = 00002000h
WS_EX_LTRREADING      = 00000000h
WS_EX_LEFTSCROLLBAR   = 00004000h
WS_EX_RIGHTSCROLLBAR  = 00000000h
WS_EX_CONTROLPARENT   = 00010000h
WS_EX_STATICEDGE      = 00020000h
WS_EX_APPWINDOW       = 00040000h
WS_EX_OVERLAPPEDWINDOW = (WS_EX_WINDOWEDGE + WS_EX_CLIENTEDGE)
WS_EX_PALETTEWINDOW    = (WS_EX_WINDOWEDGE + WS_EX_TOOLWINDOW + WS_EX_TOPMOST)


; PeekMessage() Options
PM_NOREMOVE    = 0000h
PM_REMOVE      = 0001h
PM_NOYIELD     = 0002h

; SetWindowPos Flags
SWP_NOSIZE       =  0001h
SWP_NOMOVE       =  0002h
SWP_NOZORDER     =  0004h
SWP_NOREDRAW     =  0008h
SWP_NOACTIVATE   =  0010h
SWP_DRAWFRAME    =  0020h
SWP_SHOWWINDOW   =  0040h
SWP_HIDEWINDOW   =  0080h
SWP_NOCOPYBITS   =  0100h
SWP_NOREPOSITION =  0200h
;
;  Predefined cursor & icon IDs
;
IDC_ARROW       = 32512
IDC_IBEAM       = 32513
IDC_WAIT        = 32514
IDC_CROSS       = 32515
IDC_UPARROW     = 32516
IDC_SIZE        = 32640
IDC_ICON        = 32641
IDC_SIZENWSE    = 32642
IDC_SIZENESW    = 32643
IDC_SIZEWE      = 32644
IDC_SIZENS      = 32645

IDI_APPLICATION = 32512
IDI_HAND        = 32513
IDI_QUESTION    = 32514
IDI_EXCLAMATION = 32515
IDI_ASTERISK    = 32516

COLOR_SCROLLBAR           = 0
COLOR_BACKGROUND          = 1
COLOR_ACTIVECAPTION       = 2
COLOR_INACTIVECAPTION     = 3
COLOR_MENU                = 4
COLOR_WINDOW              = 5
COLOR_WINDOWFRAME         = 6
COLOR_MENUTEXT            = 7
COLOR_WINDOWTEXT          = 8
COLOR_CAPTIONTEXT         = 9
COLOR_ACTIVEBORDER        = 10
COLOR_INACTIVEBORDER      = 11
COLOR_APPWORKSPACE        = 12
COLOR_HIGHLIGHT           = 13
COLOR_HIGHLIGHTTEXT       = 14
COLOR_BTNFACE             = 15
COLOR_BTNSHADOW           = 16
COLOR_GRAYTEXT            = 17
COLOR_BTNTEXT             = 18

;
;  MessageBox type flags
;
MB_OK                   = 0000H
MB_OKCANCEL             = 0001H
MB_ABORTRETRYIGNORE     = 0002H
MB_YESNOCANCEL          = 0003H
MB_YESNO                = 0004H
MB_RETRYCANCEL          = 0005H

MB_ICONHAND             = 0010H
MB_ICONQUESTION         = 0020H
MB_ICONEXCLAMATION      = 0030H
MB_ICONASTERISK         = 0040H

MB_DEFBUTTON1           = 0000H
MB_DEFBUTTON2           = 0100H
MB_DEFBUTTON3           = 0200H

MB_APPLMODAL            = 0000H
MB_SYSTEMMODAL          = 1000H
MB_TASKMODAL            = 2000H

MB_NOFOCUS              = 8000H

;
;  Conventional dialog box and message box command IDs
;
IDOK     =   1
IDCANCEL =   2
IDABORT  =   3
IDRETRY  =   4
IDIGNORE =   5
IDYES    =   6
IDNO     =   7


;
;  Edit Control Messages
;
EM_GETSEL             =  00B0h
EM_SETSEL             =  00B1h
EM_GETRECT            =  00B2h
EM_SETRECT            =  00B3h
EM_SETRECTNP          =  00B4h
EM_SCROLL             =  00B5h
EM_LINESCROLL         =  00B6h
EM_SCROLLCARET        =  00B7h
EM_GETMODIFY          =  00B8h
EM_SETMODIFY          =  00B9h
EM_GETLINECOUNT       =  00BAh
EM_LINEINDEX          =  00BBh
EM_SETHANDLE          =  00BCh
EM_GETHANDLE          =  00BDh
EM_GETTHUMB           =  00BEh
EM_LINELENGTH         =  00C1h
EM_REPLACESEL         =  00C2h
EM_GETLINE            =  00C4h
EM_LIMITTEXT          =  00C5h
EM_CANUNDO            =  00C6h
EM_UNDO               =  00C7h
EM_FMTLINES           =  00C8h
EM_LINEFROMCHAR       =  00C9h
EM_SETTABSTOPS        =  00CBh
EM_SETPASSWORDCHAR    =  00CCh
EM_EMPTYUNDOBUFFER    =  00CDh
EM_GETFIRSTVISIBLELINE=  00CEh
EM_SETREADONLY        =  00CFh
EM_SETWORDBREAKPROC   =  00D0h
EM_GETWORDBREAKPROC   =  00D1h
EM_GETPASSWORDCHAR    =  00D2h
EM_SETMARGINS         =  00D3h
EM_GETMARGINS         =  00D4h
EM_SETLIMITTEXT       equ  <EM_LIMITTEXT>
EM_GETLIMITTEXT       =  00D5h
EM_POSFROMCHAR        =  00D6h
EM_CHARFROMPOS        =  00D7h

;
