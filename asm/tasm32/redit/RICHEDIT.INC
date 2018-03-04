;
;       RICHEDIT.H
;
;       Purpose:
;               RICHEDIT public definitions
;
;       Copyright (c) 1985-1995, Microsoft Corporation
;
LF_FACESIZE = 32

cchTextLimitDefault = 32767

; RichEdit messages

WM_CONTEXTMENU          =       007Bh
WM_PRINTCLIENT          =       0318h
EM_GETLIMITTEXT         =       (WM_USER + 37)
EM_POSFROMCHAR          =       (WM_USER + 38)
EM_CHARFROMPOS          =       (WM_USER + 39)
EM_SCROLLCARET          =       (WM_USER + 49)
EM_CANPASTE                     =       (WM_USER + 50)
EM_DISPLAYBAND          =       (WM_USER + 51)
EM_EXGETSEL                     =       (WM_USER + 52)
EM_EXLIMITTEXT          =       (WM_USER + 53)
EM_EXLINEFROMCHAR       =       (WM_USER + 54)
EM_EXSETSEL                     =       (WM_USER + 55)
EM_FINDTEXT                     =       (WM_USER + 56)
EM_FORMATRANGE          =       (WM_USER + 57)
EM_GETCHARFORMAT        =       (WM_USER + 58)
EM_GETEVENTMASK         =       (WM_USER + 59)
EM_GETOLEINTERFACE      =       (WM_USER + 60)
EM_GETPARAFORMAT        =       (WM_USER + 61)
EM_GETSELTEXT           =       (WM_USER + 62)
EM_HIDESELECTION        =       (WM_USER + 63)
EM_PASTESPECIAL         =       (WM_USER + 64)
EM_REQUESTRESIZE        =       (WM_USER + 65)
EM_SELECTIONTYPE        =       (WM_USER + 66)
EM_SETBKGNDCOLOR        =       (WM_USER + 67)
EM_SETCHARFORMAT        =       (WM_USER + 68)
EM_SETEVENTMASK         =       (WM_USER + 69)
EM_SETOLECALLBACK       =       (WM_USER + 70)
EM_SETPARAFORMAT        =       (WM_USER + 71)
EM_SETTARGETDEVICE      =       (WM_USER + 72)
EM_STREAMIN                     =       (WM_USER + 73)
EM_STREAMOUT            =       (WM_USER + 74)
EM_GETTEXTRANGE         =       (WM_USER + 75)
EM_FINDWORDBREAK        =       (WM_USER + 76)
EM_SETOPTIONS           =       (WM_USER + 77)
EM_GETOPTIONS           =       (WM_USER + 78)
EM_FINDTEXTEX           =       (WM_USER + 79)
EM_GETWORDBREAKPROCEX = (WM_USER + 80)
EM_SETWORDBREAKPROCEX = (WM_USER + 81)

; Far East specific messages
EM_SETPUNCTUATION       =       (WM_USER + 100)
EM_GETPUNCTUATION       =       (WM_USER + 101)
EM_SETWORDWRAPMODE      =       (WM_USER + 102)
EM_GETWORDWRAPMODE      =       (WM_USER + 103)
EM_SETIMECOLOR          =       (WM_USER + 104)
EM_GETIMECOLOR          =       (WM_USER + 105)
EM_SETIMEOPTIONS        =       (WM_USER + 106)
EM_GETIMEOPTIONS        =       (WM_USER + 107)


; new notifications

EN_MSGFILTER            =       0700h
EN_REQUESTRESIZE        =       0701h
EN_SELCHANGE            =       0702h
EN_DROPFILES            =       0703h
EN_PROTECTED            =       0704h

; PenWin specific
EN_CORRECTTEXT          =       0705h

; back to new notifications
EN_STOPNOUNDO           =       0706h

; Far East specific notification
EN_IMECHANGE            =       0707h

; back to new notifications
EN_SAVECLIPBOARD        =       0708h
EN_OLEOPFAILED          =       0709h

; event notification masks

ENM_NONE                        =       00000000h
ENM_CHANGE                      =       00000001h
ENM_UPDATE                      =       00000002h
ENM_SCROLL                      =       00000004h
ENM_KEYEVENTS           =       00010000h
ENM_MOUSEEVENTS         =       00020000h
ENM_REQUESTRESIZE       =       00040000h
ENM_SELCHANGE           =       00080000h
ENM_DROPFILES           =       00100000h
ENM_PROTECTED           =       00200000h

; PenWin specific
ENM_CORRECTTEXT         =       00400000h

; Far East specific notification mask
ENM_IMECHANGE           =       00800000h

; new edit control styles

ES_SAVESEL                      =       00008000h
ES_SUNKEN                       =       00004000h
ES_DISABLENOSCROLL      =       00002000h

; same as WS_MAXIMIZE, but that doesn't make sense so we re-use the value
ES_SELECTIONBAR         =   01000000h

; new edit control extended style
ES_EX_NOCALLOLEINIT     =       01000000h

; These flag are used in the only FE Windows.
ES_VERTICAL                     =       00400000h
ES_NOIME                        =       00080000h
ES_SELFIME                      =       00040000h

; edit control options
ECO_AUTOWORDSELECTION = 00000001h
ECO_AUTOVSCROLL         =       00000040h
ECO_AUTOHSCROLL         =       00000080h
ECO_NOHIDESEL           =       00000100h
ECO_READONLY            =       00000800h
ECO_WANTRETURN          =       00001000h
ECO_SAVESEL                     =       00008000h
ECO_SELECTIONBAR        =       01000000h

; used only in FE Windows version
ECO_VERTICAL            =       00400000h

; ECO operations
ECOOP_SET               =               0001h
ECOOP_OR                =               0002h
ECOOP_AND               =               0003h
ECOOP_XOR               =               0004h

; new word break function actions
WB_CLASSIFY             =       3
WB_MOVEWORDLEFT =       4
WB_MOVEWORDRIGHT =      5
WB_LEFTBREAK    =       6
WB_RIGHTBREAK   =       7

; Far East specific flags
WB_MOVEWORDPREV =       4
WB_MOVEWORDNEXT =       5
WB_PREVBREAK    =       6
WB_NEXTBREAK    =       7


PC_FOLLOWING    =       1
PC_LEADING              =       2
PC_OVERFLOW             =       3
PC_DELIMITER    =       4
WBF_WORDWRAP    =       010h
WBF_WORDBREAK   =       020h
WBF_OVERFLOW    =       040h
WBF_LEVEL1              =       080h
WBF_LEVEL2              =       100h
WBF_CUSTOM              =       200h


; word break flags (used with WB_CLASSIFY)
WBF_CLASS               =       0Fh
WBF_ISWHITE             =       10h
WBF_BREAKLINE   =       20h
WBF_BREAKAFTER  =       40h


; new data types


; all character format measurements are in twips
CHARFORMAT struc
        CF_cbSize UINT ?
        CF_dwMask ULONG ?
        CF_dwEffects ULONG ?
        CF_yHeight ULONG ?
        CF_yOffset ULONG ?                      ; > 0 for superscript, < 0 for subscript
        CF_crTextColor COLORREF ?
        CF_bCharSet UCHAR ?
        CF_bPitchAndFamily UCHAR ?
        CF_szFaceName UCHAR LF_FACESIZE dup(?)
        pad db 2 dup(?)
CHARFORMAT ends

; CHARFORMAT masks
CFM_BOLD        =       00000001h
CFM_ITALIC      =       00000002h
CFM_UNDERLINE =         00000004h
CFM_STRIKEOUT =         00000008h
CFM_PROTECTED =         00000010h
CFM_SIZE        =       80000000h
CFM_COLOR       =       40000000h
CFM_FACE        =       20000000h
CFM_OFFSET      =       10000000h
CFM_CHARSET     =       08000000h

; CHARFORMAT effects
CFE_BOLD        =       0001h
CFE_ITALIC      =       0002h
CFE_UNDERLINE = 0004h
CFE_STRIKEOUT = 0008h
CFE_PROTECTED = 0010h

; NOTE: CFE_AUTOCOLOR corresponds to CFM_COLOR, which controls it
CFE_AUTOCOLOR = 40000000h

yHeightCharPtsMost  = 1638

; EM_SETCHARFORMAT wParam masks
SCF_SELECTION = 0001h
SCF_WORD          =     0002h

CHARRANGE struc
        CR_cpMin ULONG ?
        CR_cpMax ULONG ?
CHARRANGE ends

TEXTRANGE struc
        TR_chrg CHARRANGE ?
        TR_lpstrText ULONG ?   ;allocated by caller, zero terminated by RichEdit
TEXTRANGE ends


EDITSTREAM struc
        ES_dwCookie ULONG ?             ; user value passed to callback as first parameter
        ES_dwError ULONG ?              ; last error
        ES_pfnCallback ULONG ?
EDITSTREAM ends

; stream formats

SF_TEXT         =       0001h
SF_RTF          =       0002h
SF_RTFNOOBJS =  0003h           ; outbound only
SF_TEXTIZED     =       0004h           ; outbound only

;Flag telling stream operations to operate on the selection only
; EM_STREAMIN will replace the current selection
; EM_STREAMOUT will stream out the current selection
SFF_SELECTION = 8000h

; Flag telling stream operations to operate on the common RTF keyword only
; EM_STREAMIN will accept the only common RTF keyword
; EM_STREAMOUT will stream out the only common RTF keyword
SFF_PLAINRTF =  4000h

FINDTEXT struc
        FT_chrg CHARRANGE ?
        FT_lpstrText ULONG ?
FINDTEXT ends

FINDTEXTEX struc
        FTX_chrg CHARRANGE  ?
        FTX_lpstrText ULONG ?
        FTX_chrgText CHARRANGE ?
FINDTEXTEX ends

FORMATRANGE struc
        FR_hdc ULONG ?
        FR_hdcTarget ULONG ?
        FR_rc RECT ?
        FR_rcPage RECT ?
        FR_chrg CHARRANGE  ?
FORMATRANGE ends

; all paragraph measurements are in twips

MAX_TAB_STOPS  =32
lDefaultTab  = 720

PARAFORMAT struc
        PF_cbSize UINT ?;
        PF_dwMask ULONG ?
        PF_wNumbering USHORT ?
        PF_wReserved USHORT ?
        PF_dxStartIndent ULONG ?
        PF_dxRightIndent ULONG ?
        PF_dxOffset ULONG ?
        PF_wAlignment USHORT ?
        PF_cTabCount USHORT ?
        PF_rgxTabs ULONG MAX_TAB_STOPS dup(?)
PARAFORMAT ends

; PARAFORMAT mask values
PFM_STARTINDENT         =       00000001h
PFM_RIGHTINDENT         =       00000002h
PFM_OFFSET                      =       00000004h
PFM_ALIGNMENT           =       00000008h
PFM_TABSTOPS            =       00000010h
PFM_NUMBERING           =       00000020h
PFM_OFFSETINDENT        =       80000000h

; PARAFORMAT numbering options
PFN_BULLET      =       0001h

; PARAFORMAT alignment options
PFA_LEFT         = 0001h
PFA_RIGHT        = 0002h
PFA_CENTER       = 0003h


MSGFILTER struc
        MF_nmhdr NMHDR   ?
        MF_msg UINT ?
        MF_wParam ULONG ?
        MF_lParam ULONG ?
MSGFILTER ends

REQRESIZE struc
        RR_nmhdr NMHDR ?
        RR_rc RECT ?
REQRESIZE ends

SELCHANGE struc
        SC_nmhdr NMHDR ?
        SC_chrg CHARRANGE ?
        SC_seltyp USHORT ?
SELCHANGE ends

SEL_EMPTY       =       0000h
SEL_TEXT        =       0001h
SEL_OBJECT      =       0002h
SEL_MULTICHAR = 0004h
SEL_MULTIOBJECT  = 0008h

ENDROPFILES struc
        DF_nmhdr NMHDR ?
        DF_hDrop ULONG ?
        DF_cp ULONG ?
        DF_fProtected ULONG ?
ENDROPFILES ends

ENPROTECTED struc
        EP_nmhdr NMHDR ?
        EP_msg UINT ?
        EP_wParam ULONG ?
        EP_lParam ULONG ?
        EP_chrg CHARRANGE ?
ENPROTECTED ends


ENSAVECLIPBOARD struc
        ESC_nmhdr NMHDR ?
        ESC_cObjectCount ULONG ?
    ESC_cch ULONG ?
ENSAVECLIPBOARD ends

ENOLEOPFAILED struc
        EO_nmhdr NMHDR ?
        EO_iob ULONG ?
        EO_lOper ULONG ?
        EO_hr ULONG ?
ENOLEOPFAILED ends

OLEOP_DOVERB =  1

; PenWin specific

ENCORRECTTEXT struc
        ECT_nmhdr NMHDR ?
        ECT_chrg CHARRANGE ?
        ECT_seltyp USHORT ?
ENCORRECTTEXT ends

; Far East specific
PUNCTUATION struc
        PUN_iSize UINT ?
        PUN_szPunctuation ULONG ?
PUNCTUATION ends

; Far East specific
COMPCOLOR struc
        CCOL_crText COLORREF ?
        CCOL_crBackground COLORREF ?
        CCOL_dwEffects ULONG ?
COMPCOLOR ends


; clipboard formats - use as parameter to RegisterClipboardFormat()
CF_RTF equ 'Rich Text Format'
CF_RTFNOOBJS equ 'Rich Text Format Without Objects'
CF_RETEXTOBJ equ 'RichEdit Text and Objects'

; Paste Special
REPASTESPECIAL struc
        RPS_dwAspect ULONG ?
        RPS_dwParam ULONG ?
REPASTESPECIAL ends

