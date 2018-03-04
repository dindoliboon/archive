;###########################################################################
;###########################################################################
; ABOUT ASCII Artpad:
;	ASCII Artpad is a paint type program designed for Windows. It allows
;	you to use a point and click method of most paint programs except
;	instead of pixels you plot characters. The grid is 80 x 80 and even
;	allows you to use a palette of 20 colors plus one background color.
;	You can also zoom in to view the grid in 10x10, 20x20, or 40x40 mode.
;
;###########################################################################
; Program Info:
;	One executable that runs. As always.
;
;###########################################################################
;###########################################################################


;###########################################################################
;###########################################################################
; THE COMPILER OPTIONS
;###########################################################################
;###########################################################################

	.386
	.model flat, stdcall
	option casemap :none   ; case sensitive

;###########################################################################
;###########################################################################
; THE INCLUDES SECTION
;###########################################################################
;###########################################################################

	include \masm32\include\windows.inc
	include \masm32\include\comctl32.inc
	include \masm32\include\comdlg32.inc
	include \masm32\include\shell32.inc
	include \masm32\include\user32.inc
	include \masm32\include\kernel32.inc
	include \masm32\include\gdi32.inc
	
	includelib \masm32\lib\comctl32.lib
	includelib \masm32\lib\comdlg32.lib
	includelib \masm32\lib\shell32.lib
	includelib \masm32\lib\gdi32.lib
	includelib \masm32\lib\user32.lib
	includelib \masm32\lib\kernel32.lib

;###########################################################################
;###########################################################################
; LOCAL MACROS
;###########################################################################
;###########################################################################

	szText MACRO Name, Text:VARARG
		LOCAL lbl
		jmp lbl
		Name db Text,0
		lbl:
	ENDM

	m2m MACRO M1, M2
		push		M2
		pop		M1
	ENDM

	return MACRO arg
		mov	eax, arg
        	ret
	ENDM

	RGB MACRO red, green, blue
		xor	eax,eax
		mov	ah,blue
		shl	eax,8
		mov	ah,green
		mov	al,red
	ENDM

	hWrite MACRO handle, buffer, size
		mov	edi, handle
		add	edi, Dest_index
		mov	ecx, 0
		mov	cx, size
		add	Dest_index, ecx
		mov	esi, buffer
		movsb
	ENDM

	hRead MACRO handle, buffer, size
		mov	edi, handle
		add	edi, Spot
		mov	ecx, 0
		mov	cx, size
		add	Spot, ecx
		mov	esi, buffer
		movsb
	ENDM

;#################################################################################
;#################################################################################
; LOCAL PROTOTYPES
;#################################################################################
;#################################################################################

	;==================================
	; Main Program Procedures
	;==================================
	WinMain PROTO  		:DWORD,:DWORD,:DWORD,:DWORD
	WndProc PROTO  		:DWORD,:DWORD,:DWORD,:DWORD

	;====================================
	; Drawing Procedures
	;====================================
	PaintScreen PROTO
	DrawGridLines PROTO	:DWORD
	DrawImage PROTO		:DWORD
	DrawCurrent PROTO	:DWORD
	DrawPalette PROTO	:DWORD
	DrawOutlines PROTO	:DWORD
	PaintChar PROTO		:DWORD
	DrawGridPos PROTO		

	;======================================
	; File I/O Procedures
	;======================================
	LoadArt PROTO
	SaveArt PROTO
	LoadPalette PROTO
	SavePalette PROTO
	ExportText PROTO
	ExportRTF PROTO
	ExportHTML PROTO
	PrintImage PROTO	:DWORD

	;=====================================
	; Color changing dialog Procedures
	;=====================================
	ColorProc PROTO  	:DWORD,:DWORD,:DWORD,:DWORD
	DrawPreview PROTO	:DWORD,:DWORD
	GetColor PROTO		:DWORD	

	;=====================================
	; MISC Procedures
	;=====================================
	TestFixedWidth PROTO
	Calc_XY PROTO		:DWORD
	UpdateCurrent PROTO	:DWORD,:BYTE,:BYTE
	MoveGridPos PROTO	:BYTE
	InitPalette PROTO
	InitImage PROTO			
	AboutProc PROTO  	:DWORD,:DWORD,:DWORD,:DWORD
	CharProc PROTO  	:DWORD,:DWORD,:DWORD,:DWORD
	MiscCenterWnd PROTO	:DWORD,:DWORD
	PushButton PROTO 	:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
	EditSl PROTO 		:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
	ExtractResource PROTO	:DWORD,:DWORD,:DWORD
	ExpandResource PROTO	:DWORD,:DWORD,:DWORD
		
;#################################################################################
;#################################################################################
; BEGIN INITIALIZED DATA
;#################################################################################
;#################################################################################

    .data
    
	;==============================
	;Text for the Window Title
	;==============================
    	szDisplayName	db "ASCII Artpad",0
      
	;==============================
	;Windows handles and Misc
	;==============================
	msg  MSG	<?>	; For message handling
	CommandLine	dd 0	; for the commandline params
	hMainWnd	dd 0	; Handle to the main window
	hMenu		dd 0	; Handle to the menu
	hInst		dd 0	; Handle to an Instance
	hIcon		dd 0	; Handle to the icon
	hFile		dd 0	; Handle to the file that we open
	hAccel		dd 0	; Holds our accelerators for the menu
	hCursor		dd 0	; Holds our cursor handle for drawing
	Amount_Read	dd 0	; Holds the amount read or written to the file

	;========================================================
	; This is used to pass arguments to wvsprintfA it can 
	; hold up to 4 different args
	;========================================================
	dwArgs		dd 4 dup (0)

	;=========================================================
	; Handles to the buttons that adjust the characters
	;=========================================================
	hPrevChar	dd 0	; The previous character
	hNextChar	dd 0	; The next character

	;=============================
	; Handle to the move Icons
	;=============================
	hLeft		dd 0	; Move left
	hRight		dd 0	; Move right
	hUp		dd 0	; Move Up
	hDown		dd 0	; Move down

	;===========================================
	; These are the rects for the icon movers
	;===========================================
	Rect_Up		RECT	<213,1,227,15>		; Left, top, right, bottom
	Rect_Down	RECT	<213,419,227,433>	; Left, top, right, bottom
	Rect_Right	RECT	<424,202,438,216>	; Left, top, right, bottom
	Rect_Left	RECT	<3,202,17,216>		; Left, top, right, bottom

	;===========================================
	; This is the rect for prev and next and
	; current charcter buttons, & edit control
	;===========================================
	Rect_Prev	RECT	<448,24,505,41>		; Left, top, right, bottom
	Rect_Next	RECT	<568,24,625,41>		; Left, top, right, bottom
	Rect_Char	RECT	<522,18,551,47>		; Left, top, right, bottom

	;===========================================
	; This is the rect for the image
	;===========================================
	Rect_Image	RECT	<20,16,420,416>		; Left, top, right, bottom

	;=================================================
	; This is the rect for the background color
	;=================================================
	Rect_Back	RECT	<555,112,612,145>	; Left, top, right, bottom

	;=================================================
	; This is the rect for the preview in RGB dialog
	;=================================================
	Rect_Preview	RECT	<274,50,324,100>	; Left, top, right, bottom

	;=======================================
	; The current character they are using
	;=======================================
	CurChar		db 2 dup(0)	; All 256 ASCII codes possible we have a zero
					; terminater on the end for setting the text

	;=======================================
	; The current character they are drawing
	;=======================================
	DrawChar	db 2 dup(0)	; All 256 ASCII codes possible we have a zero
					; terminater on the end for setting the text

	;===============================
	; Variable for the Grid Drawing
	;===============================
	DrawLines	db 0	; Do they want a grid??

	;===================================
	; View Adjuster holds how much zoom
	;===================================
	ViewAdjust	db 0	; 0 = 1:1, 1 = 2:1, 2 = 3:1

	;===============================
	; The palette (DWORD for each)
	;===============================
	Palette		dd 21 dup (0)	; These are the colors

	;============================
	; Current X and Current Y
	;============================
	CurrentX	dd 0	; Holds grid X location
	CurrentY	dd 0	; Holds grid Y location

	;=====================================
	; Grid Adjusters for when they move
	;=====================================
	LeftAdjust	db 0	; Amount they have moved to the right
	TopAdjust	db 0	; Amount they have moved down

	;================================
	; Current Character Color index
	; and background color
	;================================
	Color_Char	db 0	; This holds the index into our palette
	Color_Background	dd 0	; This is a color in and of itself

	;=========================
	; For the RGB Dialog
	;=========================
	Sel_Color	dd 0	; The current color value they want to alter

	;=================================
	; This is a pointer to the mem we
	; will allocate for the image
	;=================================
	Image		dd 0	; Holds the address of our memory for the image

	;====================================================
	; This structure definition is for our image blocks
	;====================================================
	GRID_CHAR	STRUC

		Color	db 0	; Holds the color index
		Char	db 0	; Holds the char for that block

	GRID_CHAR	ENDS	

	;===============================
	; Strings for the application
	;===============================
	szClassName	db "AA_Class",0
	NoHomePage	db "Unable to open www.fastsoftware.com!",0
	Homepage	db "Http://www.fastsoftware.com/",0
	OpenErr		db "Unable to Open file!",0
	SaveErr		db "Unable to Save file!",0
	PrintErr	db "Unable to Print Image!",0
	ExportErr	db "Unable to Export file!",0
	szNoMem		db "Unable to allocate memory. Exiting application.",0
	szNoHelp	db "Unable to create help file!",0
	szOver255	db "You must enter numbers between 0 and 255.",0
	szNoPrev	db "You are at the lowest character possible.",0
	szNoNext	db "You are at the highest character possible.",0
	szNoFixed	db "WARNING: You are not using a fixed width font.",13,10,
			   "Your picture will not look the same as it does",13,10,
			   "in the artpad.",13,10,13,10,
			   "Do you still wish to continue?",0

	;=========================
	; Help file name and size
	;=========================
	Res_Name_HELP	db "HELP",0
    	Res_Dest_HELP	db "C:\AA.hlp",0
	Size_HELP    	dd 11222

	;=========================
	; For the grid pos
	;=========================
	GridPosBuffer	db 20 dup (0)

	;============================
	; For the RGB dialog values
	;============================
	RGBBuffer	db 10 dup (0)

	;============================
	; The printing buffer
	;============================
	szPrintBuffer	db 82 dup (0)

	;============================
	; For the Char dialog
	;============================
	CharIndex	db 2 dup (0)

	;===============================================
	; Our buffer to hold result of wvsprintf call
	; for all of the html formatting stuff
	;===============================================
	szHTMLBuffer	db 150 dup (0)

	;=======================================================
	; To open a file
	;=======================================================
	szArtFile	db MAX_PATH dup(0)
	szFileTitle	db MAX_PATH dup(0)
	szPalFile	db MAX_PATH dup(0)
	szExportFile	db MAX_PATH dup(0)
	ofn	OPENFILENAME <SIZEOF(OPENFILENAME), NULL, NULL,\
			OFFSET szArtFilter, NULL, NULL, 1h, OFFSET szArtFile,\
			800, OFFSET szFileTitle, 800, NULL, NULL,\
			OFN_PATHMUSTEXIST,0, 0, 0, 0, 0, 0>

	;=====================================================
	;Initialize the Font structure for generic app then
	; change what is necessary before calls
	;=====================================================
	Font	LOGFONT	<14,0,0,0,FW_NORMAL,\
			0,0,0,ANSI_CHARSET,OUT_DEFAULT_PRECIS,\
			CLIP_STROKE_PRECIS,DEFAULT_QUALITY,\
			DEFAULT_PITCH or FF_SWISS,"MS Sans Serif">

	;=====================================================
	;Initialize the Font structure for the ASCII art
	;=====================================================
	ArtFont	LOGFONT	<11,0,0,0,FW_NORMAL,\
			0,0,0,ANSI_CHARSET,OUT_STRING_PRECIS,\
			CLIP_STROKE_PRECIS,DEFAULT_QUALITY,\
			DEFAULT_PITCH or FF_DONTCARE,"MS Sans Serif">

	;======================================================
	; This is used for their font selection common dialog
	;======================================================	
	lpSelFont	CHOOSEFONT	<?>

	;======================================================
	; This is used for printing the artwork
	;======================================================	
	lpPD		PRINTDLGAPI	<?>

	;======================================================
	; This is used for the WM paint messages
	;======================================================	
	PS		PAINTSTRUCT	<?>

;#################################################################################
;#################################################################################
; BEGIN CONSTANTS
;#################################################################################
;#################################################################################

	;================================================
	; These are for opening and saving files
	;================================================
szArtFilter	SBYTE	"ASCII Art Files (*.aa)",0,"*.aa",0,0
szPalFilter	SBYTE	"ASCII Art Palette (*.aap)",0,"*.aap",0,0
szTextFilter	SBYTE	"Text Files (*.txt)",0,"*.txt",0,0
szRTFFilter	SBYTE	"Rich Text Files (*.rtf)",0,"*.rtf",0,0
szHTMLFilter	SBYTE	"HTML Files (*.htm)",0,"*.htm",0,0
szDefExt	SBYTE	"aa",0
szPalDefExt	SBYTE	"aap",0
szTextExt	SBYTE	"txt",0
szRTFExt	SBYTE	"rtf",0
szHTMLExt	SBYTE	"htm",0

	;==============================================
	; This Carriage Return and Line feed is for
	; when we export files. Place at the EOL
	;==============================================
CRLF		SBYTE	13,10

	;==============================================
	; These are for the HTML formatting 
	;==============================================
szHeaderTemp1	SBYTE	"<HTML>",13,10
		SBYTE	"<HEAD>",13,10
		SBYTE	"<TITLE> %s </TITLE>",13,10,0

szHeaderTemp2	SBYTE	"</HEAD>",13,10
		SBYTE	'<BODY BGCOLOR=#%.6lX><PRE><FONT FACE="%s">',13,10,0

szFontTemp	SBYTE	'<FONT COLOR=#%.6lX>',0
szEndFont	SBYTE	"</FONT>",0
szBoldStart	SBYTE	"<B>",0
szItalicStart	SBYTE	"<I>",0
szBoldEnd	SBYTE	"</B>",0
szItalicEnd	SBYTE	"</I>",0

	;================================
	; This is how we end every file
	;================================
szEnding	SBYTE	"</FONT></PRE></BODY></HTML>",0

	;==================================
	; These are for the special signs
	;==================================
GREATER_SIGN	SBYTE	"&gt;",0
LESS_SIGN	SBYTE	"&lt;",0
AMPERSAND_SIGN	SBYTE	"&amp;",0

	;===========================================
	; The button captions
	;===========================================
szPrevButton	SBYTE	"Prev Char",0
szNextButton	SBYTE	"Next Char",0

	;==========================================
	; Captions for the form that get displayed
	;==========================================
Cap_CurColors	SBYTE	"Current Colors"
Cap_CurChar	SBYTE	"Current Character"
Cap_Char	SBYTE	"Character"
Cap_Background	SBYTE	"Background"
Cap_Palette	SBYTE	"Palette"
Cap_Copyright	SBYTE	"Copyright 1999 by Lightning Software"
	
	;====================================
	; This is for the gird pos printout
	;====================================
Grid_Pos_Temp	SBYTE	"Pos ( %d, %d )",0

	;======================================
	; This is for the RGB in the dialog box
	;======================================
RGB_TEMP	SBYTE	"%d"

	;==============================================
	; These are the default colors for the palette
	; there are 20 entries
	;==============================================
DEFAULT_PAL	DWORD 00000000h	; Black
		DWORD 0000FF00h	; Green
		DWORD 000000FFh	; Red
		DWORD 00FF0000h	; Blue
		DWORD 00FF00FFh	; Purple
		DWORD 0000FFFFh	; Yellow
		DWORD 00004080h	; Brown
		DWORD 00800000h	; Dark Blue
		DWORD 00808080h	; Dark Gray
		DWORD 00C0C0C0h	; Light Gray
		DWORD 008080FFh	; Peach
		DWORD 00008000h	; Dark green
		DWORD 000080FFh	; Orange
		DWORD 00800080h	; Dark Purple
		DWORD 00008080h	; Olive
		DWORD 00FFFFFFh	; White
		DWORD 00C080FFh	; Pink
		DWORD 00400080h	; Maroon
		DWORD 00FFFF00h	; Bright Blue
		DWORD 0040FF00h	; Bright Green

	;======================================
	; This is the default background color
	;======================================
DEFAULT_BACK	DWORD	00FFFFFFh

	;==============================================
	; This is the default character color and char
	;==============================================
DEFAULT_COLOR	BYTE	0		; NOTE: INDEX
DEFAULT_CHAR	BYTE	32		; NOTE: A SPACE

;#################################################################################
;#################################################################################
; BEGIN EQUATES
;#################################################################################
;#################################################################################

	;=================
	;Utility Equates
	;=================
FALSE		equ	0
TRUE		equ	1

	;================
	; Button ID's
	;================
ID_PREV		equ	850	; Previous character
ID_NEXT		equ	875	; Next character
ID_CURCHAR	equ	895	; The current character

	;================
	; resource IDs
	;================
IDI_ICON	equ	01h		
IDM_MENU	equ	02h
IDA_ACCEL	equ	03h
IDD_ABOUT	equ	04h
IDD_DEMO	equ	40h
IDC_PAINT	equ	09h
IDC_SEL		equ	10h
IDD_COLOR	equ	101
IDC_RED		equ	1000
IDC_GREEN	equ	1001
IDC_BLUE	equ	1002
IDC_PREVIEW	equ	1003
IDD_CHAR	equ	41h

	;=================
	; Zoom Icons
	;=================
IDI_UP		equ	05h
IDI_DOWN	equ	06h
IDI_LEFT	equ	07h
IDI_RIGHT	equ	08h

	;================
	; Menu ID's
	;================
IDM_FILEMENU	equ	011h
IDM_OPTIONSMENU	equ	012h
IDM_VIEWMENU	equ	013h
IDM_HELPMENU	equ	014h

IDM_NEW		equ	20h
IDM_OPENFILE	equ	21h
IDM_SAVEFILEAS	equ	22h
IDM_SAVEFILE	equ	23h
IDM_PRINT	equ	24h
IDM_EXPORTTEXT	equ	25h
IDM_EXPORTRTF	equ	26h
IDM_EXPORTHTML	equ	27h
IDM_EXIT	equ	28h

IDM_CHANGEFONT	equ	29h
IDM_SAVEPALETTE	equ	30h
IDM_LOADPALETTE	equ	31h
IDM_RESTORE	equ	32h
IDM_SHOWLINES	equ	33h

IDM_VIEW1	equ	34h
IDM_VIEW2	equ	35h
IDM_VIEW3	equ	36h
IDM_VIEW4	equ	37h

IDM_CONTENTS	equ	38h
IDM_ABOUT	equ	39h

	;=========================
	; These are the max chars
	;=========================
MAX_WIDTH	equ	80
MAX_HEIGHT	equ	80
GRID_SIZE	equ	6400

	;==============================
	; These are for grid movement
	;==============================
GRID_UP		equ	0
GRID_DOWN	equ	1
GRID_LEFT	equ	2
GRID_RIGHT	equ	3

	;======================================
	; This is the amount of memory we need
	; for the image 1 byte for color index
	; * 1 byte for character == 2bytes *
	; 80x80 grid == 12,800
	;======================================
IMAGE_SIZE	equ	12800
PALETTE_SIZE	equ	80

;#################################################################################
;#################################################################################
; BEGIN THE CODE SECTION
;#################################################################################
;#################################################################################

  .code

start:
	invoke GetModuleHandle, NULL
	mov	hInst, eax

	invoke GetCommandLine
	mov	CommandLine, eax

	invoke WinMain,hInst,NULL,CommandLine,SW_SHOWDEFAULT
	invoke ExitProcess,eax

;#########################################################################

WinMain proc	hInstance	:DWORD,
		hPrevInst	:DWORD,
		CmdLine		:DWORD,
		CmdShow		:DWORD

	;====================
	; Put LOCALs on stack
	;====================
	LOCAL wc		:WNDCLASS
	LOCAL Wwd  		:DWORD
	LOCAL Wht  		:DWORD
	LOCAL hFont		:DWORD

	;==================================================
	; Fill WNDCLASS structure with required variables
	;==================================================
	mov	wc.style,CS_HREDRAW or CS_VREDRAW \
			or CS_BYTEALIGNWINDOW or CS_DBLCLKS
	mov	wc.lpfnWndProc,offset WndProc
	mov	wc.cbClsExtra,NULL
	mov	wc.cbWndExtra,NULL
	m2m	wc.hInstance,hInst   ;<< NOTE: macro not mnemonic
	mov	wc.hbrBackground,COLOR_BTNFACE
	mov	wc.lpszMenuName,NULL
	mov	wc.lpszClassName,offset szClassName
	invoke LoadIcon, hInst, IDI_ICON ; icon ID
	mov	hIcon,eax
	mov	wc.hIcon,eax
	invoke LoadCursor,hInst,IDC_PAINT
	mov	hCursor, eax
	mov	wc.hCursor,eax

	;================================
	; Register our class we created
	;================================
	invoke RegisterClass, ADDR wc

	;================================
	; Create window at following size
	;================================
	mov	Wwd, 640
	mov	Wht, 480
	
	;===========================================
	; Create the main screen
	;===========================================
	invoke CreateWindowEx,NULL,
			ADDR szClassName,
                        ADDR szDisplayName,
                        WS_POPUP or WS_SYSMENU or\
                        WS_MINIMIZEBOX or WS_CAPTION,
                        0,0,Wwd,Wht,
                        NULL,NULL,
                        hInst,NULL
        
	;===========================================
	; Put the window handle in for future uses 
	;===========================================
  	mov	hMainWnd, eax

	;============================================
	;Load the menu
	;============================================
	invoke LoadMenu,hInstance,IDM_MENU  ; menu ID
	mov	hMenu, eax
	invoke SetMenu,hMainWnd,hMenu

	;=================================
	; Load all of the icons
	;=================================
	invoke LoadIcon,hInst,IDI_UP    	; icon ID
	mov	hUp,eax
	invoke LoadIcon,hInst,IDI_DOWN    	; icon ID
	mov	hDown,eax
	invoke LoadIcon,hInst,IDI_RIGHT  	; icon ID
	mov	hRight,eax
	invoke LoadIcon,hInst,IDI_LEFT    	; icon ID
	mov	hLeft,eax

	;================================
	; Initialize the Common Controls
	;================================
	invoke InitCommonControls

	;=================================
	; Create our 2 buttons
	;=================================
	invoke PushButton,ADDR szPrevButton,hMainWnd,448,24,57,17,ID_PREV
	mov	hPrevChar, eax
	invoke PushButton,ADDR szNextButton,hMainWnd,568,24,57,17,ID_NEXT
	mov	hNextChar, eax

	;==========================================
	; Create the font we want for the buttons
	;==========================================
	mov	Font.lfWeight, FW_NORMAL
	mov	Font.lfHeight, 11
	invoke CreateFontIndirect, offset Font
	mov	hFont, eax
	
	;================================================
	; Set the buttons font to the one we made
	;================================================
	invoke SendMessage,hPrevChar,WM_SETFONT,hFont,0
	invoke SendMessage,hNextChar,WM_SETFONT,hFont,0

	;===============================
	; Set to show grid lines
	;===============================
	mov DrawLines, TRUE

	;================================
	; Initialize the grid adjusters
	;================================
	mov	LeftAdjust, 0
	mov	TopAdjust, 0

	;==================================
	; Set the default background color
	;==================================
	mov	eax, DEFAULT_BACK
	mov	Color_Background, eax

	;=================================
	; Set the default color index
	;=================================
	mov	al, DEFAULT_COLOR
	mov	Color_Char, al

	;=======================================
	; Set the current character 
	;=======================================
	mov	CurChar, 65		; Set to an 'A'

	;====================================
	; Initialize our palette and brushes
	;====================================
	invoke InitPalette

	;=====================================
	; Set the view adjust to 2 - 3:1
	;=====================================
	mov	ViewAdjust, 2

	;==========================================
	; Check and uncheck starting menu options
	;==========================================
	invoke CheckMenuItem,hMenu,IDM_SHOWLINES,MF_BYCOMMAND or MF_CHECKED
	invoke CheckMenuItem,hMenu,IDM_VIEW1,MF_BYCOMMAND or MF_UNCHECKED
	invoke CheckMenuItem,hMenu,IDM_VIEW2,MF_BYCOMMAND or MF_UNCHECKED
	invoke CheckMenuItem,hMenu,IDM_VIEW3,MF_BYCOMMAND or MF_CHECKED
	invoke CheckMenuItem,hMenu,IDM_VIEW4,MF_BYCOMMAND or MF_UNCHECKED

	;================================
	; Initialize the current X and Y
	;================================
	mov	CurrentX, 0
	mov	CurrentY, 0

	;==============================================
	; Allocate enough memeory to hold the file
	;==============================================
	invoke GlobalAlloc, GMEM_FIXED, IMAGE_SIZE
	mov	Image, eax

	;===================================
	; test for an error
	;===================================
	.if eax == 0
		;==========================
		; Give them an error msg
		;==========================
		invoke MessageBox, hMainWnd, ADDR szNoMem, NULL, MB_OK

		;==================
		; Return from here
		;==================
		return 0

	.endif

	;========================================
	; Initialize the grid's image
	;=========================================
	invoke InitImage

	;============================================
	; Extract our help file
	;============================================
	invoke ExtractResource, ADDR Res_Name_HELP, \
			ADDR Res_Dest_HELP, Size_HELP
	.if eax == 0
		;=========================
		; Give message box
		;=========================
		invoke MessageBox, hMainWnd, ADDR szNoHelp, ADDR szDisplayName, MB_OK

	.endif

	;============================================
	;Load the accelerators
	;============================================
	invoke LoadAccelerators, hInstance, IDA_ACCEL
	mov	hAccel,eax

	;================================
	; Center window at following size
	;================================
	invoke GetDesktopWindow
	invoke MiscCenterWnd, hMainWnd, eax	

	;================================
	; Show the window
	;================================
	invoke ShowWindow,hMainWnd,SW_SHOWNORMAL

	;===================================
	; Loop until PostQuitMessage is sent
	;===================================
  	.WHILE TRUE
		invoke	GetMessage, ADDR msg, NULL, 0, 0
		.BREAK .IF (!eax)
		invoke	TranslateAccelerator, hMainWnd, hAccel, ADDR msg
		.CONTINUE .IF (eax)	; skip if we handled
		invoke	TranslateMessage, ADDR msg
		invoke	DispatchMessage, ADDR msg
	.ENDW
getout:
	return msg.wParam

WinMain endp

;#########################################################################

WndProc proc	hWin   :DWORD,
		uMsg   :DWORD,
		wParam :DWORD,
		lParam :DWORD

;========================================
; LOCAL VARIABLES
;=========================================
LOCAL	Pt		:POINT
LOCAL	LastX		:DWORD
LOCAL	LastY		:DWORD

.if uMsg == WM_COMMAND
	;========================================
	; Setup to Process Menu Commands
	;========================================
	mov	eax,wParam	
	and	eax,0FFFFh
	mov	wParam, eax

	;=====================
	; menu commands
	;=====================
    	.if wParam == IDM_NEW
  		;=============================
  		; This is the FIlE-NEW code
  		;=============================

		;==================
		; Reset our image
		;==================
		invoke InitImage

		;=====================================
		; Set the view adjust to 2 - 3:1
		;=====================================
		mov	ViewAdjust, 2

		;=====================================
		; Set to show the grid lines
		;=====================================
		mov	DrawLines, TRUE

		;==========================================
		; Check and uncheck starting menu options
		;==========================================
		invoke CheckMenuItem,hMenu,IDM_SHOWLINES,MF_BYCOMMAND or MF_CHECKED
		invoke CheckMenuItem,hMenu,IDM_VIEW1,MF_BYCOMMAND or MF_UNCHECKED
		invoke CheckMenuItem,hMenu,IDM_VIEW2,MF_BYCOMMAND or MF_UNCHECKED
		invoke CheckMenuItem,hMenu,IDM_VIEW3,MF_BYCOMMAND or MF_CHECKED
		invoke CheckMenuItem,hMenu,IDM_VIEW4,MF_BYCOMMAND or MF_UNCHECKED

		;================================
		; Initialize the current X and Y
		;================================
		mov	CurrentX, 0
		mov	CurrentY, 0

		;==================
		; Update display
		;==================
		invoke PaintScreen


    	.elseif wParam == IDM_OPENFILE
  		;=============================
  		; This is the FIlE-OPEN code
  		;=============================

     		;========================
		; Get the open file name
		;========================
		mov	eax, offset szArtFilter
		mov	ofn.lpstrFilter, eax
		mov	eax, offset szDefExt
		mov	ofn.lpstrDefExt, eax
		mov	szArtFile, NULL
		mov	eax, offset szArtFile
		mov	ofn.lpstrFile, eax
		invoke GetOpenFileName, ADDR ofn

		;========================
		; Test for file
		;========================
		.if (eax)
			;===========================
			; Call the code to Load in
			;===========================
			invoke LoadArt
				
			;========================
			; Test for an error
			;========================
			.if eax == 0
		
				;==================
				; Give error msg
				;==================
				invoke MessageBox, hWin, ADDR OpenErr,\
					NULL,MB_OK			
					
				return 1

			.endif

			;===================================
			; We were good so update the screen
			;===================================
			invoke PaintScreen

		.endif

	.elseif wParam == IDM_SAVEFILEAS
  		;================================
  		; This is the FIlE-SAVE AS code
  		;================================
getname:
		;========================
		; Get the open file name
		;========================
		mov	eax, offset szArtFilter
		mov	ofn.lpstrFilter, eax
		mov	eax, offset szDefExt
		mov	ofn.lpstrDefExt, eax
		mov	szArtFile, NULL
		mov	eax, offset szArtFile
		mov	ofn.lpstrFile, eax
		invoke GetSaveFileName, ADDR ofn

		;=========================
		; Did they select a file?
		;=========================
		.if (eax) 
			;============================
			; Jump down to the save code
			;============================
			jmp	saveit

		.endif

   	.elseif wParam == IDM_SAVEFILE
  		;=============================
  		; This is the FIlE-SAVE code
  		;=============================

		;=============================
		; Do we need to get a name
		;=============================
		.if szArtFile == NULL
			;=======================
			; Yes goto save as code
			;=======================
			jmp	getname

		.endif
saveit:
		;===========================
		; Call the code to SaveIt
		;===========================
		invoke SaveArt
				
		;========================
		; Test for an error
		;========================
		.if eax == 0
		
			;==================
			; Give error msg
			;==================
			invoke MessageBox, hWin, ADDR SaveErr,\
				NULL,MB_OK			
					
			return 1

		.endif

		;===================================
		; We were good so update the screen
		;===================================
		invoke PaintScreen

   	.elseif wParam == IDM_PRINT
  		;=============================
  		; This is the FIlE-PRINT code
  		;=============================

		;====================================
		; See if the have a fixed width font
		;====================================
		invoke TestFixedWidth

		;=====================================
		; Quit this operation if they want to
		;=====================================
		.if eax == FALSE
			;==================
			; Just return out
			;==================
			ret
		
		.endif

		;==============================
		; Call the print Dialog 
		;==============================
		mov	lpPD.lStructSize, SIZEOF(PRINTDLGAPI)
		mov     eax, hMainWnd
		mov     lpPD.hWndOwner,eax
		mov     eax,hInst
		mov     lpPD.hInstance,eax
		mov     lpPD.Flags,PD_RETURNDC or PD_NOSELECTION or PD_PRINTSETUP
		invoke PrintDlg, offset lpPD

		;========================================
		; Return out if they don't want to print
		;========================================
		.if eax == FALSE
			;===============
			; Yup - get out
			;===============
			ret

		.endif

		;==============================
		; Call the code to print it
		;==============================
		invoke PrintImage, lpPD.hDC

		;===============================
		; Test for an error printing
		;===============================
		.if eax == 0
			;==============================
			; Yes there was an error so
			; give a message box to them
			;==============================
			invoke MessageBox, hWin, ADDR PrintErr,\
				NULL,MB_OK			

		.endif

   	.elseif wParam == IDM_EXPORTTEXT
  		;===================================
  		; This is the FIlE-EXPORT TEXT code
  		;===================================

     		;========================
		; Get the save file name
		;========================
		mov	eax, offset szTextFilter
		mov	ofn.lpstrFilter, eax
		mov	eax, offset szTextExt
		mov	ofn.lpstrDefExt, eax
		mov	szExportFile, NULL
		mov	eax, offset szExportFile
		mov	ofn.lpstrFile, eax
		invoke GetSaveFileName, ADDR ofn

		;========================
		; Test for file
		;========================
		.if (eax)
			;==============================
			; Call the code to Export Text
			;==============================
			invoke ExportText
				
			;========================
			; Test for an error
			;========================
			.if eax == 0
		
				;==================
				; Give error msg
				;==================
				invoke MessageBox, hWin, ADDR ExportErr,\
					NULL,MB_OK			
					
				return 1

			.endif

			;===================================
			; We were good so update the screen
			;===================================
			invoke PaintScreen

		.endif

   	.elseif wParam == IDM_EXPORTHTML
  		;===================================
  		; This is the FIlE-EXPORT HTML code
  		;===================================

		;====================================
		; See if the have a fixed width font
		;====================================
		invoke TestFixedWidth

		;=====================================
		; Quit this operation if they want to
		;=====================================
		.if eax == FALSE
			;==================
			; Just return out
			;==================
			ret
		
		.endif

     		;========================
		; Get the save file name
		;========================
		mov	eax, offset szHTMLFilter
		mov	ofn.lpstrFilter, eax
		mov	eax, offset szHTMLExt
		mov	ofn.lpstrDefExt, eax
		mov	szExportFile, NULL
		mov	eax, offset szExportFile
		mov	ofn.lpstrFile, eax
		invoke GetSaveFileName, ADDR ofn

		;========================
		; Test for file
		;========================
		.if (eax)
			;==============================
			; Call the code to Export HTML
			;==============================
			invoke ExportHTML
				
			;========================
			; Test for an error
			;========================
			.if eax == 0
		
				;==================
				; Give error msg
				;==================
				invoke MessageBox, hWin, ADDR ExportErr,\
					NULL,MB_OK			
					
				return 1

			.endif

			;===================================
			; We were good so update the screen
			;===================================
			invoke PaintScreen

		.endif

	.elseif wParam == IDM_EXIT
		;===========================
      		; THIS IS THE FILE-EXIT
      		;===========================
		invoke SendMessage,hWin,WM_SYSCOMMAND,SC_CLOSE,NULL

   	.elseif wParam == IDM_CHANGEFONT
  		;========================================
  		; This is the OPTIONS-Change Font code
  		;========================================
	
		;=======================================
		; Setup our choose font struct for the
		; call to the common dialog control
		;=======================================
		mov	lpSelFont.lStructSize, SIZEOF(CHOOSEFONT)
		m2m	lpSelFont.hWndOwner, hMainWnd
		mov	lpSelFont.lpLogFont, offset ArtFont
		mov	lpSelFont.Flags, CF_SCREENFONTS

		;========================================
		; Make the call to choose the font
		;========================================
		invoke ChooseFont, offset lpSelFont

		;==================================
		; Make a call to update the screen
		;==================================
		invoke PaintScreen

   	.elseif wParam == IDM_SAVEPALETTE
  		;========================================
  		; This is the OPTIONS-Save Palette code
  		;========================================

     		;========================
		; Get the open file name
		;========================
		mov	eax, offset szPalFilter
		mov	ofn.lpstrFilter, eax
		mov	eax, offset szPalDefExt
		mov	ofn.lpstrDefExt, eax
		mov	szPalFile, NULL
		mov	eax, offset szPalFile
		mov	ofn.lpstrFile, eax
		invoke GetSaveFileName, ADDR ofn

		;========================
		; Test for file
		;========================
		.if (eax)
			;===========================
			; Call the code to Save
			;===========================
			invoke SavePalette
				
			;========================
			; Test for an error
			;========================
			.if eax == 0
		
				;==================
				; Give error msg
				;==================
				invoke MessageBox, hWin, ADDR SaveErr,\
					NULL,MB_OK			
					
				return 1

			.endif

			;===================================
			; We were good so update the screen
			;===================================
			invoke PaintScreen

		.endif

   	.elseif wParam == IDM_LOADPALETTE
  		;========================================
  		; This is the OPTIONS-LOAD Palette code
  		;========================================

     		;========================
		; Get the open file name
		;========================
		mov	eax, offset szPalFilter
		mov	ofn.lpstrFilter, eax
		mov	eax, offset szPalDefExt
		mov	ofn.lpstrDefExt, eax
		mov	szPalFile, NULL
		mov	eax, offset szPalFile
		mov	ofn.lpstrFile, eax
		invoke GetOpenFileName, ADDR ofn

		;========================
		; Test for file
		;========================
		.if (eax)
			;===========================
			; Call the code to Load in
			;===========================
			invoke LoadPalette
				
			;========================
			; Test for an error
			;========================
			.if eax == 0
		
				;==================
				; Give error msg
				;==================
				invoke MessageBox, hWin, ADDR OpenErr,\
					NULL,MB_OK			
					
				return 1

			.endif

			;===================================
			; We were good so update the screen
			;===================================
			invoke PaintScreen

		.endif

   	.elseif wParam == IDM_RESTORE
  		;========================================
  		; This is the OPTIONS-Restore colors code
  		;========================================

		;=====================
		; Re Init the palette
		;=====================
		invoke InitPalette

		;=====================
		; Update the display
		;=====================
		invoke PaintScreen

 	.elseif wParam == IDM_SHOWLINES
  		;==========================================
  		; This is the OPTIONS-Show grid lines code
  		;==========================================

		;=====================================
		; Check or uncheck the make caps item
		;=====================================
		.if DrawLines == TRUE
			;=============================
			; Make it False
			;=============================
			mov	DrawLines, FALSE
			invoke CheckMenuItem,hMenu,IDM_SHOWLINES,MF_BYCOMMAND or MF_UNCHECKED
	
		.else
			;============================
			; Tis' false so make true
			;============================
			mov	DrawLines, TRUE
			invoke CheckMenuItem,hMenu,IDM_SHOWLINES,MF_BYCOMMAND or MF_CHECKED

		.endif

		;===============================
		; Update our display
		;===============================
		invoke PaintScreen

  	.elseif wParam == IDM_VIEW1
  		;========================================
  		; This is the View - 1:1 code
  		;========================================

		;=============================
		; Set the View Adjust to 1:1
		;=============================
		mov	ViewAdjust, 0

		;=================================
		; Set the grid adjusters to zero
		;=================================
		mov	LeftAdjust, 0
		mov	TopAdjust, 0

		;=====================================
		; Check and uncheck needed menu items
		;=====================================
		invoke CheckMenuItem,hMenu,IDM_VIEW1,MF_BYCOMMAND or MF_CHECKED
		invoke CheckMenuItem,hMenu,IDM_VIEW2,MF_BYCOMMAND or MF_UNCHECKED
		invoke CheckMenuItem,hMenu,IDM_VIEW3,MF_BYCOMMAND or MF_UNCHECKED
		invoke CheckMenuItem,hMenu,IDM_VIEW4,MF_BYCOMMAND or MF_UNCHECKED

		;==================================
		; Make a call to update the screen
		;==================================
		invoke PaintScreen

  	.elseif wParam == IDM_VIEW2
  		;========================================
  		; This is the View - 2:1 code
  		;========================================

		;=============================
		; Set the View Adjust to 2:1
		;=============================
		mov	ViewAdjust, 1

		;=====================================
		; Make sure the grid adjusters can
		; fit what they want into the screen
		;=====================================
		.if LeftAdjust > 40
			mov	LeftAdjust, 40
		.endif
		.if TopAdjust > 40
			mov	TopAdjust, 40
		.endif

		;=====================================
		; Check and uncheck needed menu items
		;=====================================
		invoke CheckMenuItem,hMenu,IDM_VIEW1,MF_BYCOMMAND or MF_UNCHECKED
		invoke CheckMenuItem,hMenu,IDM_VIEW2,MF_BYCOMMAND or MF_CHECKED
		invoke CheckMenuItem,hMenu,IDM_VIEW3,MF_BYCOMMAND or MF_UNCHECKED
		invoke CheckMenuItem,hMenu,IDM_VIEW4,MF_BYCOMMAND or MF_UNCHECKED

		;==================================
		; Make a call to update the screen
		;==================================
		invoke PaintScreen

  	.elseif wParam == IDM_VIEW3
  		;========================================
  		; This is the View - 3:1 code
  		;========================================
	
		;=============================
		; Set the View Adjust to 3:1
		;=============================
		mov	ViewAdjust, 2

		;=====================================
		; Make sure the grid adjusters can
		; fit what they want into the screen
		;=====================================
		.if LeftAdjust > 60
			mov	LeftAdjust, 60
		.endif
		.if TopAdjust > 60
			mov	TopAdjust, 60
		.endif

		;=====================================
		; Check and uncheck needed menu items
		;=====================================
		invoke CheckMenuItem,hMenu,IDM_VIEW1,MF_BYCOMMAND or MF_UNCHECKED
		invoke CheckMenuItem,hMenu,IDM_VIEW2,MF_BYCOMMAND or MF_UNCHECKED
		invoke CheckMenuItem,hMenu,IDM_VIEW3,MF_BYCOMMAND or MF_CHECKED
		invoke CheckMenuItem,hMenu,IDM_VIEW4,MF_BYCOMMAND or MF_UNCHECKED

		;==================================
		; Make a call to update the screen
		;==================================
		invoke PaintScreen

  	.elseif wParam == IDM_VIEW4
  		;========================================
  		; This is the View - 4:1 code
  		;========================================
	
		;=============================
		; Set the View Adjust to 4:1
		;=============================
		mov	ViewAdjust, 3

		;=====================================
		; Check and uncheck needed menu items
		;=====================================
		invoke CheckMenuItem,hMenu,IDM_VIEW1,MF_BYCOMMAND or MF_UNCHECKED
		invoke CheckMenuItem,hMenu,IDM_VIEW2,MF_BYCOMMAND or MF_UNCHECKED
		invoke CheckMenuItem,hMenu,IDM_VIEW3,MF_BYCOMMAND or MF_UNCHECKED
		invoke CheckMenuItem,hMenu,IDM_VIEW4,MF_BYCOMMAND or MF_CHECKED

		;==================================
		; Make a call to update the screen
		;==================================
		invoke PaintScreen

   	.elseif wParam == IDM_CONTENTS
  		;========================================
  		; This is the HELP-Contents code
  		;========================================

		;===================================
		; Execute our help file
		;===================================
		invoke ShellExecute,hMainWnd,0,ADDR Res_Dest_HELP,0,0,SW_SHOWNORMAL

      .elseif wParam == IDM_ABOUT
		;===========================
      		;THIS IS THE HELP-ABOUT
      		;===========================
 		invoke DialogBoxParam, hInst, IDD_ABOUT, hMainWnd, ADDR AboutProc, NULL

;========== COMMAND BUTTONS =========================================================
	.elseif wParam == ID_PREV
		;====================================
		; Set the focus to the main window
		;====================================
		invoke SetFocus, hMainWnd

		;===================================
		; Give them the previous character 
		;===================================
		.if CurChar > 0
			;=================================
			; Decrement and set the charcter
			;=================================
			dec	CurChar
			invoke PaintScreen

			;==================================
			; Re-enable Next button if needed
			;==================================
			.if CurChar == 254
				;=========================
				; Yes make the call
				;=========================
				invoke EnableWindow, hNextChar, TRUE

			.endif

		.else
			;============================================
			; Give message box saying no more charcters
			;============================================
			invoke MessageBox, hMainWnd, ADDR szNoPrev, \
					ADDR szDisplayName, MB_OK

		.endif
	
	.elseif wParam == ID_NEXT
		;====================================
		; Set the focus to the main window
		;====================================
		invoke SetFocus, hMainWnd

		;===================================
		; Give them the next character 
		;===================================
		.if CurChar < 255
			;=================================
			; Increment and set the charcter
			;=================================
			inc	CurChar
			invoke PaintScreen

			;==================================
			; Re-enable Prev button if needed
			;==================================
			.if CurChar == 1
				;=========================
				; Yes make the call
				;=========================
				invoke EnableWindow, hPrevChar, TRUE

			.endif


		.else
			;============================================
			; Give message box saying no more charcters
			;============================================
			invoke MessageBox, hMainWnd, ADDR szNoNext, \
					ADDR szDisplayName, MB_OK

		.endif

	.elseif wParam == ID_CURCHAR
		;====================================
		; Set the focus to the main window
		; they are trying to get into our
		; edit control
		;====================================
		invoke SetFocus, hMainWnd

      .endif
;======================== end menu commands =============================
 
.elseif uMsg == WM_ERASEBKGND
	;===========================
	; Say we handled it
	;===========================
	return 1

.elseif uMsg == WM_ACTIVATE
	;===========================
	; Call to Paint the screen
	;===========================
	invoke PaintScreen

.elseif uMsg == WM_PAINT 
	;=====================================
	; Let windows know we took care of it
	;=====================================
	invoke BeginPaint, hMainWnd, ADDR PS
	invoke EndPaint, hMainWnd, ADDR PS
	invoke PaintScreen

	;====================================
	; Return just to make sure 
	;====================================
	return 0


.elseif uMsg == WM_MOUSEMOVE
	;=================================
	; Save their old X and Y coords
	;=================================
	m2m	LastX, CurrentX
	m2m	LastY, CurrentY

	;=================================
	; Update grid coords if needed
	;=================================
	mov	eax, lParam
	.if ax <= 420 && ax >= 20
		;===========================
		; Is it within Y coords
		;===========================
		shr	eax, 16
		.if ax >= 16 && ax <= 416
			;===========================
			; Yes we need to update so
			; call the calc_XY proc
			;===========================
			invoke Calc_XY, lParam

			;===========================
			; Update thegrid pos display
			;===========================
			invoke DrawGridPos

		.endif

	.endif

	;=============================================
	; Paint more charcters if they are holding
	; down the left mouse button 
	;=============================================
	mov	eax, wParam
	and	eax, MK_LBUTTON
	.if (eax)
		;=================================
		; Setup the point structure
		;=================================
		xor	ebx, ebx
		mov	eax, lParam
		mov	bx, ax
		mov	Pt.x, ebx
		shr	eax, 16
		mov	Pt.y, eax

		;======================================
		; Are they in our rectangle
		;======================================
		invoke PtInRect, offset Rect_Image, Pt.x, Pt.y

		.if eax == TRUE
			;==============================================
			; Are they in a different spot than last time
			;==============================================
			mov	eax, LastX
			mov	ebx, LastY
			.if eax == CurrentX && ebx == CurrentY
				;===================================
				; They haven't moved so do nothing
				;===================================
	
			.else
				;=========================================
				; Yes they were in so make and have moved
				; the calls to update the picture
				;=========================================
				invoke PaintChar, lParam
				invoke PaintScreen

				;==============================
				; Return out of here
				;==============================
				return 0

			.endif

		.endif

	.endif

.elseif uMsg == WM_LBUTTONDBLCLK
	;=======================================
	; They are in their image area so set up
	; their point in the point struct
	;=======================================
	mov	eax, lParam
	xor	ebx, ebx
	mov	bx, ax
	mov	Pt.x, ebx
	shr	eax, 16
	mov	Pt.y, eax
		
	;======================================
	; Are they in the character display
	;======================================
	invoke PtInRect, offset Rect_Char, Pt.x, Pt.y
	.if eax == TRUE
		;==================================
		; Yes they were in so make
		; the call to display the dialog
		;==================================
 		invoke DialogBoxParam, hInst, IDD_CHAR, hMainWnd, \
			ADDR CharProc, NULL

		;==============================
		; Return out of here
		;==============================
		return 0

	.endif

	;======================================
	; Are they in the actual image itself
	;======================================
	invoke PtInRect, offset Rect_Back, Pt.x, Pt.y
	.if eax == TRUE
		;==============================================
		; Yes so call dialog to change the color
		;==============================================
		m2m	Sel_Color, Color_Background
 		invoke DialogBoxParam, hInst, IDD_COLOR, hMainWnd, ADDR ColorProc, NULL

		;==============================================
		; Did they select a valid color
		;==============================================
		.if eax != -1
			;==================================
			; Yes so make new background color
			;==================================
			mov	Color_Background, eax

			;==================================
			; Update the display now
			;==================================
			invoke PaintScreen

			;===============================
			; Show that we processed
			;===============================
			return 0

		.endif

	.endif


	;==================================
	; Only check if it's in Pal half
	;==================================
	mov	eax, lParam
	.if ax >= 440
 		;==============================
		; They are in the palette half
		; so they may want to change a 
		; color in their palette
		;==============================
		invoke UpdateCurrent, lParam, FALSE, TRUE

		;====================================
		; Did we process the message
		;====================================
		.if eax != 0
			;===================================
			; Update the screen
			;===================================
			invoke PaintScreen

			;===================================
			; Return 0 to show we processed
			;===================================
			return 0

		.endif

	.endif

.elseif uMsg == WM_RBUTTONDOWN
	;========================================
	; Update the Current if they are greater
	; than the divider otherwise give
	; them the zoom menu
	;========================================
	mov	eax, lParam
	.if ax >= 440
		;==============================
		; They are in the palette half
		;==============================
		invoke UpdateCurrent, lParam, FALSE, FALSE

		;====================================
		; Did we process the message
		;====================================
		.if eax != 0
			;===================================
			; Update the screen
			;===================================
			invoke PaintScreen

			;===================================
			; Return 0 to show we processed
			;===================================
			return 0

		.endif

	.else
		;==================================
		; They are in their image so give
		; them the zoom menu for the image
		;==================================
		
		;===============================
		; Get the pop up menu handle
		;===============================
		invoke GetSubMenu, hMenu, 2
		push	eax
		
		;=================================
		; Convert Client to Screen Coords
		;=================================
		mov	eax, lParam
		xor	ebx, ebx
		mov	bx, ax
		mov	Pt.x, ebx
		shr	eax, 16
		mov	Pt.y, eax
		invoke ClientToScreen, hMainWnd, ADDR Pt
	
		;===========================
		; Call to track popup menu
		;===========================
		pop	eax
		invoke TrackPopupMenu, eax, 0, Pt.x, Pt.y, 0, hMainWnd, NULL

		;===================================
		; Return 0 to show we processed
		;===================================
		return 0

	.endif

.elseif uMsg == WM_LBUTTONDOWN
	;========================================
	; Update the Current if they are greater
	; than the divider otherwise update
	; the picture they are drawing
	;========================================
	mov	eax, lParam
	.if ax >= 440
		;==============================
		; They are in the palette half
		;==============================
		invoke UpdateCurrent, lParam, TRUE, FALSE

		;====================================
		; Did we process the message
		;====================================
		.if eax != 0
			;===================================
			; Update the screen
			;===================================
			invoke PaintScreen
	
			;===================================
			; Return 0 to show we processed
			;===================================
			return 0

		.endif

	.else
		;=======================================
		; They are in their image area so set up
		; their point in the point struct
		;=======================================
		xor	ebx, ebx
		mov	bx, ax
		mov	Pt.x, ebx
		shr	eax, 16
		mov	Pt.y, eax
		
		;======================================
		; Are they in the actual image itself
		;======================================
		invoke PtInRect, offset Rect_Image, Pt.x, Pt.y
		.if eax == TRUE
			;=========================================
			; Yes they were in so make and have moved
			; the calls to update the picture
			;=========================================
			invoke PaintChar, lParam
			invoke PaintScreen

			;==============================
			; Return out of here
			;==============================
			return 0

		.endif

		;======================================
		; Are they in the move grid Up box
		;======================================
		invoke PtInRect, offset Rect_Up, Pt.x, Pt.y
		.if eax == TRUE
			;==================================
			; Yes they were in so make
			; the call to move the grid
			;==================================
			invoke MoveGridPos, GRID_UP
			invoke PaintScreen

			;==============================
			; Return out of here
			;==============================
			return 0

		.endif

		;======================================
		; Are they in the move grid Down box
		;======================================
		invoke PtInRect, offset Rect_Down, Pt.x, Pt.y
		.if eax == TRUE
			;==================================
			; Yes they were in so make
			; the call to move the grid
			;==================================
			invoke MoveGridPos, GRID_DOWN
			invoke PaintScreen

			;==============================
			; Return out of here
			;==============================
			return 0

		.endif

		;======================================
		; Are they in the move grid Left box
		;======================================
		invoke PtInRect, offset Rect_Left, Pt.x, Pt.y
		.if eax == TRUE
			;==================================
			; Yes they were in so make
			; the call to move the grid
			;==================================
			invoke MoveGridPos, GRID_LEFT
			invoke PaintScreen

			;==============================
			; Return out of here
			;==============================
			return 0

		.endif

		;======================================
		; Are they in the move grid Right box
		;======================================
		invoke PtInRect, offset Rect_Right, Pt.x, Pt.y
		.if eax == TRUE
			;==================================
			; Yes they were in so make
			; the call to move the grid
			;==================================
			invoke MoveGridPos, GRID_RIGHT
			invoke PaintScreen

			;==============================
			; Return out of here
			;==============================
			return 0

		.endif

	.endif

.elseif uMsg == WM_KEYDOWN
	;====================================
	; They may want to move the grid
	;====================================
	mov	eax, wParam
	.if eax == VK_UP
		;==========================
		; They want to move up
		;==========================
		invoke MoveGridPos, GRID_UP
	
	.elseif eax == VK_DOWN
		;==========================
		; They want to move down
		;==========================
		invoke MoveGridPos, GRID_DOWN

	.elseif eax == VK_RIGHT
		;==========================
		; They want to move right
		;==========================
		invoke MoveGridPos, GRID_RIGHT

	.elseif eax == VK_LEFT
		;==========================
		; They want to move left
		;==========================
		invoke MoveGridPos, GRID_LEFT

	.else
		;=============================
		; Was nothing we care about
		;=============================
		return 0

	.endif

	;==========================
	; We processed so update
	;==========================
	invoke PaintScreen

	;==========================
	; Return from here
	;==========================
	return 1

.elseif uMsg == WM_DESTROY
	;==============================================
	; Free the mem we allocated
	;==============================================
	invoke GlobalFree, Image

	;==============================================
	; Delete the help file we wrote out
	;==============================================
	invoke DeleteFile, ADDR Res_Dest_HELP

	;===========================
	; Kill the application
	;===========================
	invoke PostQuitMessage,NULL
 	return 0 
 
.endif

invoke DefWindowProc,hWin,uMsg,wParam,lParam

ret

WndProc endp
;########################################################################
; End of Main Windows Callback Procedure
;########################################################################

;########################################################################
;########################################################################
; MY FUNCTIONS
;########################################################################
;########################################################################

;########################################################################
; TestFixedWidth Function
;########################################################################
TestFixedWidth proc
	
	;================================================
	; This function tests to see if they are using
	; a fixed width font in their artwork. If they
	; are not it lets them know the picture will not
	; look the same and gives them the choice to
	; continue or not
	;================================================

	;==========================
	; LOCAL Variables
	;==========================
	LOCAL	hDC	:DWORD
	LOCAL	hFont	:DWORD
	LOCAL	TM	:TEXTMETRIC

	;===========================
	; Get the DC for the window
	;===========================
	invoke GetDC, hMainWnd
	mov	hDC, eax

	;=========================
	; We need to create first
	;=========================
	invoke CreateFontIndirect, offset ArtFont
	mov	hFont, eax

	;===================================
	; Select the font and preserve old
	;===================================
	invoke SelectObject, hDC, hFont
	push	eax

	;====================================
	; Get the text metrics for this font
	;====================================
	invoke GetTextMetrics, hDC, ADDR TM
	
	;=======================================
	; Give them the warning if they are not
	; using fixed -width font al;ong with
	; an opportunity to cancel the job
	;=======================================
	mov	eax, TM.tmAveCharWidth
	mov	ebx, TM.tmMaxCharWidth
	.if eax != ebx
		;===============================
		; Nope so give message box
		;===============================
		invoke MessageBox, hMainWnd, ADDR szNoFixed,
			ADDR szDisplayName, MB_YESNO

		;===============================
		; Do they not want to continue
		;===============================
		.if eax == IDNO
			;====================
			; Nope so close down
			;====================
			;==================================
			; Restore old obj and delete font
			;==================================
			pop	eax
			invoke SelectObject, hDC, eax
			invoke DeleteObject, hFont

			;==================================
			; Release the DC we obtained
			;==================================
			invoke ReleaseDC, hMainWnd, hDC

			;====================
			; Jump to the err end
			;====================
			jmp	err

		.endif

	.endif

	;==================================
	; Restore old obj and delete font
	;==================================
	pop	eax
	invoke SelectObject, hDC, eax
	invoke DeleteObject, hFont

	;==================================
	; Release the DC we obtained
	;==================================
	invoke ReleaseDC, hMainWnd, hDC

done:
	return TRUE

err:

	return FALSE	
         
TestFixedWidth endp
;########################################################################
; END of TestFixedWidth
;########################################################################

;########################################################################
; LoadArt Function
;########################################################################
LoadArt proc
	
	;================================================
	; This function loads in an art file and init's
	; everything needed to resume drawing 
	;	FORMAT:
	;		- Palatte entries (20)
	;		- Background color
	;		- Cur Color Index
	;		- Current Character
	;		- Font structure
	;		- Grid Array (80x80x2)
	;================================================

	;=================================
	; Create the file
	;=================================
	invoke CreateFile, offset szArtFile, GENERIC_READ, \
		FILE_SHARE_READ, NULL,OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,NULL
	mov	hFile, eax

	;===============================
	; Test for an error
	;===============================
	.if eax == INVALID_HANDLE_VALUE
		jmp err
	.endif

	;===================================
	; Put the file palette into memory
	;===================================
	invoke ReadFile, hFile, offset Palette, PALETTE_SIZE, offset Amount_Read, NULL

	;===============================
	; test for an error
	;===============================
	.if eax == 0 || Amount_Read != PALETTE_SIZE
		jmp	err
	.endif

	;===================================
	; Put the back color into memory
	;===================================
	invoke ReadFile, hFile, offset Color_Background, 4, offset Amount_Read, NULL

	;===============================
	; test for an error
	;===============================
	.if eax == 0 || Amount_Read != 4
		jmp	err
	.endif

	;===================================
	; Put the char color into memory
	;===================================
	invoke ReadFile, hFile, offset Color_Char, 1, offset Amount_Read, NULL

	;===============================
	; test for an error
	;===============================
	.if eax == 0 || Amount_Read != 1
		jmp	err
	.endif

	;===================================
	; Put the current char into memory
	;===================================
	invoke ReadFile, hFile, offset CurChar, 1, offset Amount_Read, NULL

	;===============================
	; test for an error
	;===============================
	.if eax == 0 || Amount_Read != 1
		jmp	err
	.endif

	;===================================
	; Put the font info into the struc
	;===================================
	invoke ReadFile, hFile, offset ArtFont, SIZEOF(LOGFONT), offset Amount_Read, NULL

	;===============================
	; test for an error
	;===============================
	.if eax == 0 || Amount_Read != SIZEOF(LOGFONT)
		jmp	err
	.endif

	;===================================
	; Put the file Image into memory
	;===================================
	invoke ReadFile, hFile, Image, IMAGE_SIZE, offset Amount_Read, NULL

	;===============================
	; test for an error
	;===============================
	.if eax == 0 || Amount_Read != IMAGE_SIZE
		jmp	err
	.endif

	;============================
	; Close the handle
	;============================
	invoke CloseHandle,hFile


done:
	return TRUE

err:

	return FALSE	
         
LoadArt endp
;########################################################################
; END of LoadArt				    
;########################################################################

;########################################################################
; SaveArt Function
;########################################################################
SaveArt proc
	
	;================================================
	; This function saves an art file including the
	; palette that they were using
	;	FORMAT:
	;		- Palatte entries (20)
	;		- Background color
	;		- Cur Color Index
	;		- Current Character
	;		- Font structure
	;		- Grid Array (80x80x2)
	;================================================

	;=================================
	; Create the file
	;=================================
	invoke CreateFile, offset szArtFile, GENERIC_WRITE, \
		FILE_SHARE_WRITE, NULL,OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL,NULL
	mov	hFile, eax

	;===============================
	; Test for an error
	;===============================
	.if eax == INVALID_HANDLE_VALUE
		jmp err
	.endif

	;===================================
	; Write out palette data to file
	;===================================
	invoke WriteFile, hFile, offset Palette, PALETTE_SIZE, offset Amount_Read, NULL

	;===============================
	; test for an error
	;===============================
	.if eax == 0 || Amount_Read != PALETTE_SIZE
		jmp	err
	.endif

	;===================================
	; Put the back color into the file
	;===================================
	invoke WriteFile, hFile, offset Color_Background, 4, offset Amount_Read, NULL

	;===============================
	; test for an error
	;===============================
	.if eax == 0 || Amount_Read != 4
		jmp	err
	.endif

	;===================================
	; Put the char color into the file
	;===================================
	invoke WriteFile, hFile, offset Color_Char, 1, offset Amount_Read, NULL

	;===============================
	; test for an error
	;===============================
	.if eax == 0 || Amount_Read != 1
		jmp	err
	.endif

	;===================================
	; Put the current char into the file
	;===================================
	invoke WriteFile, hFile, offset CurChar, 1, offset Amount_Read, NULL

	;===============================
	; test for an error
	;===============================
	.if eax == 0 || Amount_Read != 1
		jmp	err
	.endif

	;===================================
	; Put the font info into the file
	;===================================
	invoke WriteFile, hFile, offset ArtFont, SIZEOF(LOGFONT), offset Amount_Read, NULL

	;===============================
	; test for an error
	;===============================
	.if eax == 0 || Amount_Read != SIZEOF(LOGFONT)
		jmp	err
	.endif

	;===================================
	; Write out Image data to file
	;===================================
	invoke WriteFile, hFile, Image, IMAGE_SIZE, offset Amount_Read, NULL

	;===============================
	; test for an error
	;===============================
	.if eax == 0 || Amount_Read != IMAGE_SIZE
		jmp	err
	.endif

	;============================
	; Close the handle
	;============================
	invoke CloseHandle,hFile


done:
	return TRUE

err:

	return FALSE	
         
SaveArt endp
;########################################################################
; END of SaveArt				    
;########################################################################

;########################################################################
; LoadPalette Function
;########################################################################
LoadPalette proc
	
	;================================================
	; This function loads in a palette file
	;	FORMAT:
	;		- Palatte entries (20)
	;		- Background color
	;		- Cur Color Index
	;================================================

	;=================================
	; Create the file
	;=================================
	invoke CreateFile, offset szPalFile, GENERIC_READ, \
		FILE_SHARE_READ, NULL,OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,NULL
	mov	hFile, eax

	;===============================
	; Test for an error
	;===============================
	.if eax == INVALID_HANDLE_VALUE
		jmp err
	.endif

	;===================================
	; Put the file palette into memory
	;===================================
	invoke ReadFile, hFile, offset Palette, PALETTE_SIZE, offset Amount_Read, NULL

	;===============================
	; test for an error
	;===============================
	.if eax == 0 || Amount_Read != PALETTE_SIZE
		jmp	err
	.endif

	;===================================
	; Put the back color into memory
	;===================================
	invoke ReadFile, hFile, offset Color_Background, 4, offset Amount_Read, NULL

	;===============================
	; test for an error
	;===============================
	.if eax == 0 || Amount_Read != 4
		jmp	err
	.endif

	;===================================
	; Put the char color into memory
	;===================================
	invoke ReadFile, hFile, offset Color_Char, 1, offset Amount_Read, NULL

	;===============================
	; test for an error
	;===============================
	.if eax == 0 || Amount_Read != 1
		jmp	err
	.endif

	;============================
	; Close the handle
	;============================
	invoke CloseHandle,hFile


done:
	return TRUE

err:

	return FALSE	
         
LoadPalette endp
;########################################################################
; END of LoadPalette				    
;########################################################################

;########################################################################
; SavePalette Function
;########################################################################
SavePalette proc
	
	;================================================
	; This function saves a palette file
	;	FORMAT:
	;		- Palatte entries (20)
	;		- Background color
	;		- Cur Color Index
	;================================================

	;=================================
	; Create the file
	;=================================
	invoke CreateFile, offset szPalFile, GENERIC_WRITE, \
		FILE_SHARE_WRITE, NULL,OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL,NULL
	mov	hFile, eax

	;===============================
	; Test for an error
	;===============================
	.if eax == INVALID_HANDLE_VALUE
		jmp err
	.endif

	;===================================
	; Write out palette data to file
	;===================================
	invoke WriteFile, hFile, offset Palette, PALETTE_SIZE, offset Amount_Read, NULL

	;===============================
	; test for an error
	;===============================
	.if eax == 0 || Amount_Read != PALETTE_SIZE
		jmp	err
	.endif

	;===================================
	; Put the back color into the file
	;===================================
	invoke WriteFile, hFile, offset Color_Background, 4, offset Amount_Read, NULL

	;===============================
	; test for an error
	;===============================
	.if eax == 0 || Amount_Read != 4
		jmp	err
	.endif

	;===================================
	; Put the char color into the file
	;===================================
	invoke WriteFile, hFile, offset Color_Char, 1, offset Amount_Read, NULL

	;===============================
	; test for an error
	;===============================
	.if eax == 0 || Amount_Read != 1
		jmp	err
	.endif

	;============================
	; Close the handle
	;============================
	invoke CloseHandle,hFile


done:
	return TRUE

err:

	return FALSE	
         
SavePalette endp
;########################################################################
; END of SavePalette				    
;########################################################################

;########################################################################
; ExportText Function
;########################################################################
ExportText proc
	
	;================================================
	; This function saves the image as a text file
	;================================================

	;=================================
	; Local Variables
	;=================================
	LOCAL	Index1		:BYTE
	LOCAL	Index2		:BYTE

	;=================================
	; Create the file
	;=================================
	invoke CreateFile, offset szExportFile, GENERIC_WRITE, \
		FILE_SHARE_WRITE, NULL,OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL,NULL
	mov	hFile, eax

	;===============================
	; Test for an error
	;===============================
	.if eax == INVALID_HANDLE_VALUE
		jmp err
	.endif

	;======================================
	; We need to write out 80 lines
	;======================================
	mov	Index1, 0
	.while Index1 < 80
		;====================================
		; Now loop through 80 chars per line
		;====================================
		mov	Index2, 0
		.while Index2 < 80
			;===============================================
			; Calculate the row we are at in the image
			;===============================================
			xor	eax, eax
			xor	ebx, ebx
			mov	al, Index1
			mov	ecx, 80
			mul	ecx
			shl	eax, 1

			;============================================
			; Now calculate the column we are in
			;============================================
			mov	bl, Index2
			shl	bl, 1
			
			;===========================================
			; Add these amounts + the image address
			;===========================================
			add	eax, ebx
			mov	ecx, Image
			add	eax, ecx
			inc	eax		; Go past color index

			;===========================
			; Write the character out
			;===========================
			invoke WriteFile, hFile, eax, \
				1, offset Amount_Read, NULL

			;===============================
			; test for an error
			;===============================
			.if eax == 0 || Amount_Read != 1
				jmp	err
			.endif
			
			;====================
			; Increment the index
			; for the cols
			;====================
			inc	Index2
		.endw

		;===========================
		; Write the CRLF out
		;===========================
		invoke WriteFile, hFile, offset CRLF, \
			2, offset Amount_Read, NULL

		;===============================
		; test for an error
		;===============================
		.if eax == 0 || Amount_Read != 2
			jmp	err
		.endif

		;====================
		; Increment the index
		; for the rows
		;====================
		inc	Index1

	.endw

	;============================
	; Close the handle
	;============================
	invoke CloseHandle,hFile


done:
	return TRUE

err:

	return FALSE	
         
ExportText endp
;########################################################################
; END of ExportText
;########################################################################

;########################################################################
; ExportHTML Function
;########################################################################
ExportHTML proc
	
	;================================================
	; This function saves the image as an HTML file
	;================================================

	;=================================
	; Local Variables
	;=================================
	LOCAL	Index1		:BYTE
	LOCAL	Index2		:BYTE
	LOCAL	PrevIndex	:BYTE
	LOCAL	OpenFont	:BYTE

	;=======================================
	; Set prev index to impossible number
	; so that we write out the first color
	;=======================================
	mov	PrevIndex, 69

	;================================
	; Set the font open to false
	;================================
	mov	OpenFont, FALSE

	;=================================
	; Create the file
	;=================================
	invoke CreateFile, offset szExportFile, GENERIC_WRITE, \
		FILE_SHARE_WRITE, NULL,OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL,NULL
	mov	hFile, eax

	;===============================
	; Test for an error
	;===============================
	.if eax == INVALID_HANDLE_VALUE
		jmp err
	.endif

	;=====================================
	; Copy into the buffer our header
	; with the title
	;=====================================
	mov	dwArgs, offset szFileTitle
	invoke wvsprintfA,ADDR szHTMLBuffer,ADDR szHeaderTemp1, offset dwArgs

	;=====================================
	; Write this out to the file
	;=====================================
	invoke WriteFile, hFile, offset szHTMLBuffer, eax, offset Amount_Read, NULL

	;======================================
	; Turn the BGR val into an RGB one
	;======================================
	mov	eax, Color_Background
	xor	ebx, ebx
	mov	bl, al
	shl	ebx, 8
	mov	bl, ah
	shl	ebx, 8
	shr	eax, 16
	mov	bl, al

	;=====================================
	; Copy into buffer the second part
	; of the header
	;=====================================
	mov	dwArgs, ebx
	mov	dwArgs[4], offset ArtFont.lfFaceName
	invoke wvsprintfA,ADDR szHTMLBuffer,ADDR szHeaderTemp2, offset dwArgs

	;=====================================
	; Write this out to the file
	;=====================================
	invoke WriteFile, hFile, offset szHTMLBuffer, eax, offset Amount_Read, NULL

	;=====================================
	; Are they using BOLD for this font
	;=====================================
	mov	eax, ArtFont.lfWeight
	xor	eax, FW_BOLD
	.if	zero? 
		;=====================================
		; Yes so write the opening Bold out
		;=====================================
		invoke WriteFile, hFile, offset szBoldStart, 3, offset Amount_Read, NULL

	.endif

	;=====================================
	; Are they using Italic for this font
	;=====================================
	.if ArtFont.lfItalic != 0
		;=====================================
		; Yes so write the opening Italic out
		;=====================================
		invoke WriteFile, hFile, offset szItalicStart, 3, offset Amount_Read, NULL

	.endif

	;======================================
	; We need to write out 80 lines
	;======================================
	mov	Index1, 0
	.while Index1 < 80
		;====================================
		; Now loop through 80 chars per line
		;====================================
		mov	Index2, 0
		.while Index2 < 80
			;===============================================
			; Calculate the row we are at in the image
			;===============================================
			xor	eax, eax
			xor	ebx, ebx
			mov	al, Index1
			mov	ecx, 80
			mul	ecx
			shl	eax, 1

			;============================================
			; Now calculate the column we are in
			;============================================
			mov	bl, Index2
			shl	bl, 1
			
			;===========================================
			; Add these amounts + the image address
			;===========================================
			add	eax, ebx
			mov	ecx, Image
			add	eax, ecx
			push	eax
			
			;=====================================
			; Is the color index the same as the
			; previous one
			;=====================================
			xor	ebx, ebx
			mov	bl, BYTE PTR[eax]
			push	ebx
			.if PrevIndex != bl
				;===============================
				; Yes we need to change colors
				;===============================

				;================================
				; Save this new color index
				;================================
				mov	PrevIndex, bl

				;=================================
				; Close off current font if there
				; is one that is open
				;=================================
				.if OpenFont == TRUE
					;============================
					; Yes so close off the font
					;============================
					invoke WriteFile, hFile, offset szEndFont, 7, \
						offset Amount_Read, NULL

					;========================
					; Set Open font to false
					;========================
					mov	OpenFont, FALSE

				.endif

				;=================================
				; Make a RGB from the BGR value
				;=================================
				pop	ebx
				shl	ebx, 2
				mov	eax, offset Palette
				add	ebx, eax
				mov	eax, DWORD PTR [ebx]
				xor	ebx, ebx
				mov	bl, al
				shl	ebx, 8
				mov	bl, ah
				shl	ebx, 8
				shr	eax, 16
				mov	bl, al

				;=================================
				; Call wvsprintf to format
				;=================================
				mov	dwArgs, ebx
				invoke wvsprintfA,ADDR szHTMLBuffer,\
					ADDR szFontTemp, offset dwArgs

				;=================================
				; Write out the color information
				; in the font tag
				;=================================
				invoke WriteFile, hFile, ADDR szHTMLBuffer,\
					eax, offset Amount_Read, NULL

				;========================
				; Set Open font to false
				;========================
				mov	OpenFont, TRUE

			.else
				;=================================
				; Pop preserved val off the stack
				;=================================
				pop	ebx

			.endif

			;=====================================
			; Go past the color index to the char
			;=====================================
			pop	eax
			inc	eax

			;===========================
			; Write the character out
			; test to see if it is a
			; special case first
			;===========================
			mov	bl, BYTE PTR[eax]
			.if bl == '&'
				;=========================
				; Yes it was an ampersand
				;=========================
				invoke WriteFile, hFile, offset AMPERSAND_SIGN, \
					5, offset Amount_Read, NULL

			.elseif bl == '<'
				;=======================
				; Yes a less than sign
				;=======================
				invoke WriteFile, hFile, offset LESS_SIGN, \
					4, offset Amount_Read, NULL

			.elseif bl == '>'
				;=========================
				; Yes a greater than sign
				;=========================
				invoke WriteFile, hFile, offset GREATER_SIGN, \
					4, offset Amount_Read, NULL

			.else
				;=======================
				; No so just write out
				;=======================
				invoke WriteFile, hFile, eax, \
					1, offset Amount_Read, NULL
			
			.endif

			;====================
			; Increment the index
			; for the cols
			;====================
			inc	Index2
		.endw

		;===========================
		; Write the CRLF out
		;===========================
		invoke WriteFile, hFile, offset CRLF, \
			2, offset Amount_Read, NULL

		;====================
		; Increment the index
		; for the rows
		;====================
		inc	Index1

	.endw

	;=================================
	; Close off current font if there
	; is one that is open
	;=================================
	.if OpenFont == TRUE
		;============================
		; Yes so close off the font
		;============================
		invoke WriteFile, hFile, offset szEndFont, 7, \
			offset Amount_Read, NULL

		;========================
		; Set Open font to false
		;========================
		mov	OpenFont, FALSE

	.endif

	;=====================================
	; Were they using BOLD for this font
	;=====================================
	mov	eax, ArtFont.lfWeight
	xor	eax, FW_BOLD
	.if zero?
		;=====================================
		; Yes so write the opening Bold out
		;=====================================
		invoke WriteFile, hFile, offset szBoldEnd, 4, offset Amount_Read, NULL

	.endif

	;=====================================
	; Were they using Italic for this font
	;=====================================
	.if ArtFont.lfItalic != 0
		;=====================================
		; Yes so write the opening Italic out
		;=====================================
		invoke WriteFile, hFile, offset szItalicEnd, 4, offset Amount_Read, NULL

	.endif

	;=====================================
	; Write out the ending
	;=====================================
	invoke WriteFile, hFile, offset szEnding, 20, offset Amount_Read, NULL

	;============================
	; Close the handle
	;============================
	invoke CloseHandle,hFile


done:
	return TRUE

err:

	return FALSE	
         
ExportHTML endp
;########################################################################
; END of ExportHTML
;########################################################################

;########################################################################
; PrintImage Function
;########################################################################
PrintImage proc	hDC:DWORD
	
	;================================================
	; This function prints the image in black/white
	;================================================

	;======================
	; LOCAL Variables
	;======================
	LOCAL	doci		:DOCINFO
	LOCAL	Index1		:BYTE
	LOCAL	Index2		:BYTE
	LOCAL	hFont		:DWORD
	LOCAL	Place		:DWORD
	LOCAL	top		:DWORD
	LOCAL	sze		:SIZEL

	;================================================
	; First we need to setup the Docinfo structure
	;================================================
	mov	doci.cbSize, SIZEOF(DOCINFO)
	mov     doci.lpszDocName,offset szDisplayName
	mov     doci.lpszOutput,0
	mov     doci.fwType,0

	;===============================================
	; Now we need to start the print job document
	;===============================================
	invoke StartDoc,hDC, ADDR doci

	;=============================
	; Test for an error
	;=============================
	.if eax == SP_ERROR
		;======================
		; Delete the DC
		;======================
		invoke DeleteDC, hDC

		;======================
		; Jump to the error ret
		;======================
		jmp	err

	.endif

	;===================================
	; Set the color, align, and BK mode
	;===================================
	invoke SetTextColor, hDC, 0
	invoke SetTextAlign, hDC, TA_TOP or TA_LEFT
	invoke SetBkMode, hDC, TRANSPARENT
	invoke SetTextCharacterExtra, hDC, 10

	;=========================
	; We need to create first
	;=========================
	mov	ArtFont.lfHeight, -36
	invoke CreateFontIndirect, offset ArtFont
	mov	hFont, eax

	;===================================
	; Select the font and preserve old
	;===================================
	invoke SelectObject, hDC, hFont
	push	eax

	;=========================
	; Set starting top value
	;=========================
	mov	top, 100

	;======================
	; Start the page
	;======================
	invoke StartPage, hDC

	;======================================
	; We need to write out 80 lines
	;======================================
	mov	Index1, 0
	.while Index1 < 80
		;=========================
		; Set the place holder
		;=========================
		m2m	Place, offset szPrintBuffer

		;====================================
		; Now loop through 80 chars per line
		;====================================
		mov	Index2, 0
		.while Index2 < 80
			;===============================================
			; Calculate the row we are at in the image
			;===============================================
			xor	eax, eax
			xor	ebx, ebx
			mov	al, Index1
			mov	ecx, 80
			mul	ecx
			shl	eax, 1

			;============================================
			; Now calculate the column we are in
			;============================================
			mov	bl, Index2
			shl	bl, 1
			
			;===========================================
			; Add these amounts + the image address
			;===========================================
			add	eax, ebx
			mov	ecx, Image
			add	eax, ecx
			inc	eax		; Go past color index

			;===========================
			; Store the character 
			;===========================
			mov	cl, BYTE PTR [eax]
			mov	ebx, Place
			mov	BYTE PTR [ebx], cl
			inc	Place

			;====================
			; Increment the index
			; for the cols
			;====================
			inc	Index2

		.endw
	
		;===========================
		; Write the string out
		;===========================
		invoke TextOut, hDC, 255, top, offset szPrintBuffer, 80

		;===========================
		; Get the text extent point
		;===========================
		invoke GetTextExtentPoint32, hDC, offset szPrintBuffer, \
			80, ADDR sze

		;==========================
		; Adjust the top
		;==========================
		mov	eax, sze.y
		add	top, eax

		;====================
		; Increment the index
		; for the rows
		;====================
		inc	Index1

	.endw

	;======================
	; End the page
	;======================
	invoke EndPage, hDC

	;==================================
	; Restore old obj and delete font
	;==================================
	pop	eax
	invoke SelectObject, hDC, eax
	invoke DeleteObject, hFont

	;======================
	; End the print job
	;======================
	invoke EndDoc, hDC

	;======================
	; Delete the DC
	;======================
	invoke DeleteDC, hDC

done:
	return TRUE

err:

	return FALSE	
         
PrintImage endp
;########################################################################
; END of PrintImage
;########################################################################

;########################################################################
; MoveGridPos Function
;########################################################################
MoveGridPos proc	Direction:BYTE
	
	;================================================
	; This function adjusts their position on the
	; grid by one in the direction specified
	;================================================

	;===========================================
	; Select the proper direction to manipulate
	;===========================================
	.if Direction == GRID_UP
		;=========================
		; They want to move up
		;=========================
		.if TopAdjust > 0
			;===============================
			; Adjust the top coord by -1
			;===============================
			dec	TopAdjust
	
		.else
			;================================
			; Do Nothing they are at the top
			;================================

		.endif

	.elseif Direction == GRID_DOWN
		;=========================
		; They want to move DOWN
		;=========================

		;==============================================
		; They can only move so far down depending on
		; the view zoom so adjust based on that
		;==============================================
		.if ViewAdjust == 1 		; 2:1
			;==============================
			; They can move down one
			;==============================
			.if TopAdjust < 40
				inc	TopAdjust

			.endif

		.elseif ViewAdjust == 2 	; 3:1
			;==============================
			; They can move down one
			;==============================
			.if TopAdjust < 60
				inc	TopAdjust

			.endif

		.elseif ViewAdjust == 3 	; 4:1
			;==============================
			; They can move down one
			;==============================
			.if TopAdjust < 70
				inc	TopAdjust

			.endif

		.endif

	.elseif Direction == GRID_LEFT
		;=========================
		; They want to move Left
		;=========================
		.if LeftAdjust > 0
			;===============================
			; Adjust the left coord by -1
			;===============================
			dec	LeftAdjust
	
		.else
			;================================
			; Do Nothing they are at the left
			;================================

		.endif

	.elseif Direction == GRID_RIGHT
		;=========================
		; They want to move RIGHT
		;=========================

		;==============================================
		; They can only move so far right depending on
		; the view zoom so adjust based on that
		;==============================================
		.if ViewAdjust == 1 && LeftAdjust < 40		; 2:1
			;==============================
			; They can move right one
			;==============================
			inc	LeftAdjust

		.elseif ViewAdjust == 2 && LeftAdjust < 60	; 3:1
			;==============================
			; They can move right one
			;==============================
			inc	LeftAdjust

		.elseif ViewAdjust == 3 && LeftAdjust < 70	; 4:1
			;==============================
			; They can move right one
			;==============================
			inc	LeftAdjust

		.endif

	.endif

done:
	return TRUE

err:

	return FALSE	
         
MoveGridPos endp
;########################################################################
; END of MoveGridPos				    
;########################################################################

;########################################################################
; Calc_XY Function
;########################################################################
Calc_XY proc	Coords:DWORD
	
	;================================================
	; This function calculates the current X and Y
	; based upon the coords passed to it it stores
	; them in the globals CurrentX and CurrentY
	;================================================

	;===============================
	; First get the coords into eax
	;===============================
	mov	eax, Coords
	
	;===============================
	; Extract the XCoord
	;===============================
	push	eax
	and	eax, 0000FFFFh
	
	;==============================
	; Subtract the image offset
	;==============================
	sub	eax, 20

	;==============================
	; Now setup our divisor for 
	; a 1:1 view on the grid
	;==============================
	mov	ebx, 5
	
	;==============================
	; Adjust for the viewing zoom
	;==============================
	mov	cl, ViewAdjust
	shl	ebx, cl	
	push	ebx

	;===============================
	; Now divide the adjusted coord
	;===============================
	xor	edx, edx
	div	ebx

	;================================
    	; This is our new current X
	;================================
	add	al, LeftAdjust	; Adjust for their movement if any
	mov	CurrentX, eax

	;================================
	; Restore the view adjust into
	; ebx, the Coords into eax
	;================================
	pop	ebx
	pop	eax

	;===============================
	; Extract the YCoord
	;===============================
	shr	eax, 16

	;==============================
	; Subtract the image offset
	;==============================
	sub	eax, 16

	;===============================
	; Now divide the adjusted coord
	;===============================
	xor	edx, edx  
	div	ebx

	;================================
	; This is our new current Y
	;================================
	inc	eax		; Adjust for flipped coord system
	add	al, TopAdjust	; Adjust for their movement if any
	mov	CurrentY, eax

done:
	return TRUE

err:

	return FALSE	
         
Calc_XY endp
;########################################################################
; END of Calc_XY				    
;########################################################################

;########################################################################
; UpdateCurrent Function
;########################################################################
UpdateCurrent proc	Coords:DWORD, Use_Char:BYTE, Change:BYTE
	
	;===================================================
	; This function updates the current charcter or
	; background color depending on the users selection
	;===================================================

	;===============================
	; Local Variables
	;===============================
	LOCAL	XCoord	:WORD
	LOCAL	YCoord	:WORD
	LOCAL	Row		:BYTE
	LOCAL	Column	:BYTE

	;=================================
	; First extracxt the coords
	;=================================
	mov	eax, Coords
	mov	XCoord, ax
	shr	eax, 16
	mov	YCoord, ax

	;=================================
	; Now select the proper row
	;=================================
	mov	cl, 0
	.while cl < 5
		;==========================
		; Setup the test Y coord
		;==========================
		xor	eax, eax
		mov	al, 40
		mul	cl
		add	eax, 208

		;===========================
		; Setup the bounding Y coord
		;===========================
		mov	edx, eax
		add	edx, 30

		;========================
		; Setup our YCoord
		;========================
		xor	ebx, ebx
		mov	bx, YCoord
		.if ebx >= eax && ebx <= edx
			;=============================
			; We found one so save Row 
			; and jump out of here
			;=============================
			mov	Row, cl
			jmp	good_y

		.endif

		;=====================
		; Increment the row
		;=====================
		inc	cl

	.endw

	;==========================================
	; We didn't jump over so that means we had
	; nothing and we need to just return
	;==========================================
	jmp	err

good_y:

	;=================================
	; Now select the proper column
	;=================================
	mov	cl, 0
	.while cl < 4
		;==========================
		; Setup the test X coord
		;==========================
		xor	eax, eax
		mov	al, 48
		mul	cl
		add	eax, 448

		;===========================
		; Setup the bounding X coord
		;===========================
		mov	edx, eax
		add	edx, 30

		;========================
		; Setup our X Coord
		;========================
		xor	ebx, ebx
		mov	bx, XCoord
		.if ebx >= eax && ebx <= edx
			;=============================
			; We found one so save Column 
			; and jump out of here
			;=============================
			mov	Column, cl
			jmp	good_x

		.endif

		;=====================
		; Increment the row
		;=====================
		inc	cl

	.endw

	;==========================================
	; We didn't jump over so that means we had
	; nothing and we need to just return
	;==========================================
	jmp	err

good_x:
	;=============================================
	; We had a click in a palette box so we need
	; to either place it in the character or in
	; the background color variables
	;=============================================

	;====================================
	; First do we need to change it??
	;====================================
	.if Change == TRUE
		;=================================
		; Adjust to proper palette offset
		;=================================
		xor	eax, eax
		mov	al, Row
		shl	al, 2
		add	al, Column
		shl	eax, 2
		mov	ebx, offset Palette
		add	ebx, eax

		;=====================================
		; Put the color entry into Sel_Color
		;=====================================
		mov	eax, DWORD PTR [ebx]
		mov	Sel_Color, eax

		;=====================================
		; Save address just in case
		;=====================================
		push	ebx

		;====================================
		; They want to change this color 
		;====================================
 		invoke DialogBoxParam, hInst, IDD_COLOR, hMainWnd, ADDR ColorProc, NULL

		;====================================
		; Did they select a new color??
		;====================================
		.if eax != -1
			;=====================================
			; Restore the address
			;=====================================
			pop	ebx

			;===================================
			; Assign it into the color
			;===================================
			mov	DWORD PTR [ebx], eax

			;===================================
			; Jump down and Return out of here
			;===================================
			jmp	done

		.endif

		;========================================
		; Restore the address so we don't crash
		;========================================
		pop	ebx

		;=======================================
		; Don't change anything
		;=======================================
		jmp	err

	.endif

	;====================================
	; Where do we put it??
	;====================================
	.if Use_Char == TRUE
		;==========================
		; Calculate the index
		;==========================
		xor	eax, eax
		mov	al, Row
		shl	al, 2
		add	al, Column

		;================================
		; Place the index in Char Color
		;================================
		mov	Color_Char, al

	.else
		;===============================
		; Place in the Background color
		;===============================

		;=================================
		; Adjust to proper palette offset
		;=================================
		xor	eax, eax
		mov	al, Row
		shl	al, 2
		add	al, Column
		shl	eax, 2
		mov	ebx, offset Palette
		add	ebx, eax

		;==================================
		; Put the color entry into eax
		;==================================
		mov	eax, DWORD PTR [ebx]

		;==================================
		; Put it into the background color
		;==================================
		mov	Color_Background, eax

	.endif

done:
	return TRUE

err:

	return FALSE	
         
UpdateCurrent endp
;########################################################################
; END of UpdateCurrent				    
;########################################################################

;########################################################################
; PaintChar Function
;########################################################################
PaintChar proc	Coords:DWORD
	
	;================================================
	; This function loads paints the current charcter
	; in the current color at the grid position that
	; is indicated by the Coords.
	;================================================

	;===============================
	; Local Variables
	;===============================
	LOCAL	XCoord	:DWORD
	LOCAL	YCoord	:DWORD

	;=================================================
	; First extracxt the coords adjust for the offset
	; of the image on the screen
	;=================================================
	mov	eax, Coords
	xor	ebx, ebx
	mov	bx, ax
	sub	bx, 20
	mov	XCoord, ebx
	shr	eax, 16
	mov	bx, ax
	sub	bx, 16
	mov	YCoord, ebx

	;=====================================
	; Calculate the amount to divide by
	; based on the view adjuster
	;=====================================
	mov	ebx, 5
	mov	cl, ViewAdjust
	shl	ebx, cl

	;===============================================
	; SAVE THIS VALUE
	;===============================================
	push	ebx

	;===============================================
	; Now obtain our X grid Coord Adjust if needed
	;===============================================
	mov	eax, XCoord
	xor	edx, edx
	div	ebx
	add	al, LeftAdjust
	mov	XCoord, eax
	
	;===============================================
	; Now obtain our Y grid Coord Adjust if needed
	;===============================================
	mov	eax, YCoord
	xor	edx, edx
	pop	ebx
	div	ebx
	add	al, TopAdjust
	mov	YCoord, eax

	;=======================================
	; Calculate an offset based on the rows
	;=======================================
	mov	eax, YCoord
	mov	ebx, 80
	mul	ebx
	shl	eax, 1

	;=======================================
	; Calculate an offset based on the cols
	;=======================================
	mov	ebx, XCoord
	shl	ebx, 1

	;========================================
	; Goto that start of the image memory
	;========================================
	mov	ecx, Image
	
	;===========================================
	; Add two offsets to the start of the image
	;===========================================
	add	eax, ebx
	add	ecx, eax

	;===========================================
	; Set the color and the charcter
	;===========================================
	mov	bl, CurChar
	mov	(GRID_CHAR PTR [ecx]).Char, bl
	mov	bl, Color_Char
	mov	(GRID_CHAR PTR [ecx]).Color, bl

done:
	return TRUE

err:

	return FALSE	
         
PaintChar endp
;########################################################################
; END of PaintChar				    
;########################################################################

;########################################################################
; PaintScreen Function
;########################################################################
PaintScreen proc
	
	;============================================
	; Code to update the display it is called
	; whenever the screen needs painting
	;============================================

	;============================
	; LOCAL VARIABLES
	;============================
	LOCAL	hDC		:DWORD
	LOCAL	hMemDC		:DWORD
	LOCAL	ScreenRect	:RECT
	LOCAL	hBitmap		:DWORD
	LOCAL	Pt		:POINT

	;=================================
	; Get the client rectangle
	;=================================
	invoke GetClientRect, hMainWnd, ADDR ScreenRect

	;============================
	; get the DC
	;============================
	invoke GetDC, hMainWnd
	mov	hDC, eax
	
	;============================
	; Create a compatible DC
	;============================
	invoke CreateCompatibleDC, hDC
	mov	hMemDC, eax

	;==============================
	; Now create a Bitmap for that
	; offscreen DC
	;==============================
	mov	eax, ScreenRect.right
	sub	eax, ScreenRect.left
	mov	ebx, ScreenRect.bottom
	sub	ebx, ScreenRect.top
	invoke CreateCompatibleBitmap, hDC,	eax, ebx
	mov	hBitmap, eax
		
	;=============================
	; Select that bitmap into the
	; object, preserve old
	;=============================
	invoke SelectObject, hMemDC, hBitmap
	push	eax

	;=============================
	; Erase the Background
	;=============================
	invoke GetSysColor, COLOR_BTNFACE
	invoke CreateSolidBrush, eax
	push	eax
	invoke FillRect, hMemDC, ADDR ScreenRect, eax
	pop	eax
	invoke DeleteObject,eax

	;============================
	; Set text and bkgnd mode
	;============================
	invoke SetTextColor, hMemDC, 00000000h
	invoke SetBkMode, hMemDC, TRANSPARENT

	;===================================================
	; First outline the stuff needed
	;===================================================
	invoke DrawOutlines, hMemDC

	;===================================================
	; Make the call to draw the current selections
	;===================================================
	invoke DrawCurrent, hMemDC

	;===================================================
	; Make the call to draw the palette stuff
	;===================================================
	invoke DrawPalette, hMemDC

	;===================================================
	; Make the call to draw the image on the screen
	;===================================================
	invoke DrawImage, hMemDC

	;===================================================
	; Make the call to draw the grid lines if needed
	;===================================================
	.if DrawLines == TRUE
		;============================
		; Yes they want a grid
		;============================
		invoke DrawGridLines, hMemDC

	.endif

	;=====================================
	; Draw all of the move Icons
	;=====================================
	invoke DrawIconEx,hMemDC,212,0,hUp,16,16,NULL,\
			NULL,DI_NORMAL
	invoke DrawIconEx,hMemDC,212,418,hDown,16,16,NULL,\
			NULL,DI_NORMAL
	invoke DrawIconEx,hMemDC,423,201,hRight,16,16,NULL,\
			NULL,DI_NORMAL
	invoke DrawIconEx,hMemDC,2,201,hLeft,16,16,NULL,\
			NULL,DI_NORMAL

	;===========================
	; Copy buffer to actual
	;===========================
	mov	eax, ScreenRect.right
	sub	eax, ScreenRect.left
	mov	ebx, ScreenRect.bottom
	sub	ebx, ScreenRect.top
	invoke BitBlt,hDC, ScreenRect.left, ScreenRect.top, eax, ebx,\
			hMemDC, 0, 0, SRCCOPY

	;============================
	; Select old int hMemDC
	;============================
	pop	eax
	invoke SelectObject, hMemDC, eax

	;============================
	; Delete the Compatible DC
	;============================
	invoke DeleteDC, hMemDC

	;===============================
	; Delete the Compatible Bitmap
	;===============================
	invoke DeleteObject, hBitmap

	;================================
	; release the device context
	;================================
	invoke ReleaseDC, hMainWnd, hDC

done:
	return TRUE

err:

	return FALSE	
         
PaintScreen endp
;########################################################################
; END of PaintScreen				    
;########################################################################

;########################################################################
; DrawGridLines Function
;########################################################################
DrawGridLines proc	DC:DWORD
	
	;============================================
	; This code will draw our gridlines on the
	; image it is only called if needed
	;============================================

	;=================================
	; Local variables
	;=================================
	LOCAL	hPen		:DWORD
	LOCAL	Index		:BYTE
	LOCAL	YCoord		:DWORD
	LOCAL	XCoord		:DWORD
	LOCAL	Wide		:BYTE
	LOCAL	Height		:BYTE

	;=============================================
	; First we need to complement the current
	; background color to get the gird line color
	;=============================================
	mov	eax, Color_Background
	xor	eax, 0FFFFFFFFh

	;============================================
	; Now create a pen of that color	
	;============================================
	invoke CreatePen, PS_SOLID, 1, eax
	mov	hPen, eax

	;========================================
	; Select our new pen and save the old one
	; on the stack for later
	;========================================
	invoke SelectObject, DC, eax
	push	eax

	;============================================
	; Loop through and draw the horizontal lines
	;============================================
	mov	Index, 1
	mov	Wide, MAX_WIDTH
	mov	cl, ViewAdjust
	shr	Wide, cl
	mov	cl, Wide
	.while Index < cl
		;===========================
		; Preserve our width count
		;===========================
		push	ecx

		;========================
		; Calculate the Y coord
		; taking into accaoun the
		; zoom level
		;========================
		xor	eax, eax
		mov	ebx, 5
		mov	cl, ViewAdjust
		mov	al, Index
		shl	ebx, cl		; Accomodate Zoom Level
		mul	ebx
		add	eax, 16
		mov	YCoord, eax

		;===================================
		; Move to and draw the line
		;===================================		
		invoke MoveToEx, DC, 20, YCoord, NULL
		invoke LineTo, DC, 421, YCoord	

		;===========================
		; Restore our width count
		;===========================
		pop	ecx

		;===========================
		; Increment the counter
		;===========================
		inc	Index

	.endw

	;============================================
	; Loop through and draw the horizontal lines
	;============================================
	mov	Index, 1
	mov	Height, MAX_WIDTH
	mov	cl, ViewAdjust
	shr	Height, cl
	mov	cl, Height
	.while Index < cl
		;===========================
		; Preserve our height count
		;===========================
		push	ecx

		;========================
		; Calculate the X coord
		; taking into accaoun the
		; zoom level
		;========================
		xor	eax, eax
		mov	ebx, 5
		mov	cl, ViewAdjust
		mov	al, Index
		shl	ebx, cl		; Accomodate Zoom Level
		mul	ebx
		add	eax, 20
		mov	XCoord, eax

		;===================================
		; Move to and draw the line
		;===================================		
		invoke MoveToEx, DC, XCoord, 16, NULL
		invoke LineTo, DC, XCoord, 417	

		;===========================
		; Restore our height count
		;===========================
		pop	ecx

		;===========================
		; Increment the counter
		;===========================
		inc	Index

	.endw

	;====================================
	; Select the old object back in
	;====================================
	pop	eax
	invoke SelectObject, DC, eax
	
	;==================================
	; Delete our Pen we created
	;==================================
	invoke DeleteObject, hPen

done:
	return TRUE

err:

	return FALSE	
         
DrawGridLines endp
;########################################################################
; END of DrawGridLines				    
;########################################################################

;########################################################################
; DrawGridPos Function
;########################################################################
DrawGridPos proc
	
	;================================================
	; This function draws the grid pos for updates
	; when they are moving thier mouse around
	;================================================

	;==========================
	; Local Variables
	;==========================
	LOCAL	hDC		:DWORD
	LOCAL	hFont		:DWORD
	LOCAL	hPen		:DWORD
	LOCAL	hBitmap		:DWORD
	LOCAL	hMemDC		:DWORD

	;==========================
	; Get the device context
	;==========================
	invoke GetDC, hMainWnd
	mov	hDC, eax

	;============================
	; Create a compatible DC
	;============================
	invoke CreateCompatibleDC, hDC
	mov	hMemDC, eax

	;==============================
	; Now create a Bitmap for that
	; offscreen DC
	;==============================
	invoke CreateCompatibleBitmap, hDC,	110, 13
	mov	hBitmap, eax
		
	;=============================
	; Select that bitmap into the
	; object, preserve old
	;=============================
	invoke SelectObject, hMemDC, hBitmap
	push	eax

	;=============================================
	; First we need to complement the current
	; background color to get the fill color
	;=============================================
	mov	eax, Color_Background
	xor	eax, 0FFFFFFFFh
	push	eax

	;===================================
	; Create the pen with this color
	;===================================
	invoke CreatePen, PS_SOLID, 2, eax
	mov	hPen, eax

	;========================================
	; Select our new pen and save the old one
	; on the stack for later
	;========================================
	invoke SelectObject, hMemDC, hPen
	pop	ebx
	push	eax

	;=====================================
	; Fill in around the image borders
	;=====================================
	invoke CreateSolidBrush, ebx
	push	eax
	invoke SelectObject, hMemDC, eax
	push	eax
	invoke Rectangle, hMemDC, 0, 0, 110, 13
	pop	eax
	invoke SelectObject, hMemDC, eax
	pop	eax
	invoke DeleteObject,eax

	;====================================
	; Select the old object back in
	;====================================
	pop	eax
	invoke SelectObject, hMemDC, eax
	
	;==================================
	; Delete our Pen we created
	;==================================
	invoke DeleteObject, hPen

	;=============================================
	; Set the text color
	;=============================================
	invoke SetTextColor, hMemDC, Color_Background

	;=============================================
	; Set the background mode and color
	;=============================================
	invoke SetBkMode, hMemDC, OPAQUE
	mov	eax, Color_Background
	xor	eax, 0FFFFFFFFh
	invoke SetBkColor, hMemDC, eax

	;=================================================
	; Create and Select the Font preserve old on stack
	;=================================================
	mov	Font.lfWeight, FW_BOLD
	mov	Font.lfHeight, 11
	invoke CreateFontIndirect, offset Font
	mov	hFont, eax
	invoke SelectObject, hMemDC, hFont
	push	eax

	;===================================
	; Print out the Cur pos 
	;===================================
	mov	eax, CurrentX
	mov	dwArgs, eax
	mov	dwArgs[4], 80		; Invert the Y value
	mov	eax, CurrentY
	sub	dwArgs[4], eax
	invoke wvsprintfA, ADDR GridPosBuffer, ADDR Grid_Pos_Temp, offset dwArgs
	invoke TextOut, hMemDC, 0, 0, ADDR GridPosBuffer, eax
	
	;===========================
	; Copy buffer to actual
	;===========================
	invoke BitBlt,hDC, 5, 418, 110, 13,\
			hMemDC, 0, 0, SRCCOPY

	;===============================
	; Restore old object 
	;===============================
	pop	eax
	invoke SelectObject, hMemDC, eax

	;===============================
	; Delete the FONT object
	;===============================
	invoke DeleteObject, hFont

	;============================
	; Select old int hMemDC
	;============================
	pop	eax
	invoke SelectObject, hMemDC, eax

	;============================
	; Delete the Compatible DC
	;============================
	invoke DeleteDC, hMemDC

	;===============================
	; Delete the Compatible Bitmap
	;===============================
	invoke DeleteObject, hBitmap

	;================================
	; release the device context
	;================================
	invoke ReleaseDC, hMainWnd, hDC

done:
	return TRUE

err:

	return FALSE	
         
DrawGridPos endp
;########################################################################
; END of DrawGridPos				    
;########################################################################

;########################################################################
; DrawImage Function
;########################################################################
DrawImage proc	DC:DWORD
	
	;===============================================
	; This code will draw our image onto the screen
	;===============================================

	;===============================
	; Local Variables
	;===============================
	LOCAL	hBrush		:DWORD
	LOCAL	TextRect	:RECT
	LOCAL	hFont		:DWORD
	LOCAL	Cols		:BYTE
	LOCAL	ColIndex	:BYTE
	LOCAL	Rows		:BYTE
	LOCAL	RowIndex	:BYTE
	LOCAL	PrevIndex	:BYTE
	LOCAL	Adjust		:DWORD

	;============================
	; Initialize the PrevIndex
	;============================
	mov	PrevIndex, 99	; This is an impossible index so that it will
					; select the first time through for sure

	;=====================================
	; Create the brush for filling in
	; the background
	;=====================================
	invoke CreateSolidBrush, Color_Background
	mov	hBrush, eax
	
	;===============================
	; Select and preserve the brush
	;===============================
	invoke SelectObject, DC, eax
	push	eax

	;====================================
	; Fill until we reach the border
	;====================================
	invoke ExtFloodFill, DC, 50, 50, 0, FLOODFILLBORDER

	;====================================
	; Select the old object back in
	;====================================
	pop	eax
	invoke SelectObject, DC, eax
	
	;==================================
	; Delete our Brush we created
	;==================================
	invoke DeleteObject, hBrush
	
	;=================================================
	; Create and Select the Font based on zoom
	;=================================================
	.if ViewAdjust == 0
		;=========================
		; We are viewing 1:1
		;=========================
		mov	ArtFont.lfHeight, -5
		invoke CreateFontIndirect, offset ArtFont
		mov	hFont, eax

	.elseif ViewAdjust == 1
		;=========================
		; We are viewing 2:1
		;=========================
		mov	ArtFont.lfHeight, -11
		invoke CreateFontIndirect, offset ArtFont
		mov	hFont, eax


	.elseif ViewAdjust == 2
		;=========================
		; We are viewing 3:1
		;=========================
		mov	ArtFont.lfHeight, -16
		invoke CreateFontIndirect, offset ArtFont
		mov	hFont, eax

	.elseif ViewAdjust == 3
		;=========================
		; We are viewing 4:1
		;=========================
		mov	ArtFont.lfHeight, -32
		invoke CreateFontIndirect, offset ArtFont
		mov	hFont, eax

	.endif

	;===================================
	; Select the font and preserve old
	;===================================
	invoke SelectObject, DC, hFont
	push	eax

	;==================================================
	; Calculate the number of rows we need to draw
	; the cols are the same amount we are in a square
	;==================================================
	mov	eax, MAX_HEIGHT
	mov	cl, ViewAdjust
	shr	eax, cl
	mov	Rows, al
	mov	Cols, al
	
	;===================================
	; Calculate an adjustment value
	;===================================
	mov	eax, 5
	mov	cl, ViewAdjust
	shl	eax, cl
	mov	Adjust, eax

	;===================================
	; Set starting vals for rectangle
	;===================================
	mov	eax, 16
	mov	ecx, 20
	mov	TextRect.top, eax
	add	eax, Adjust
	mov	TextRect.bottom, eax
	mov	TextRect.left, ecx
	add	ecx, Adjust
	mov	TextRect.right, ecx

	;==============================================
	; Loop through all of the rows
	;==============================================
	mov	RowIndex, 0 
	mov	bl, Rows
	.while RowIndex < bl

		;==========================================
		; Set starting vals for rectangle columns
		;==========================================
		mov	TextRect.left, 20 	
		mov	eax, Adjust
		mov	ColIndex, 0 
		add	eax, 20
		mov	bl, Cols
		mov	TextRect.right, eax
		.while ColIndex < bl
			;===============================================
			; Calculate the row we are at in the image
			;===============================================
			xor	eax, eax
			xor	ebx, ebx
			mov	al, RowIndex
			mov	ecx, 80
			add	al, TopAdjust
			mul	ecx
			shl	eax, 1

			;============================================
			; Now calculate the column we are in
			;============================================
			mov	bl, ColIndex
			mov	ecx, Image
			add	bl, LeftAdjust
			shl	bl, 1
			
			;===========================================
			; Add these amounts + the image address
			;===========================================
			add	ax, bx
			add	eax, ecx

			;===============================
			; Set the character to print
			;===============================
			xor	ebx, ebx
			mov	bl, (GRID_CHAR PTR [eax]).Char
			mov	DrawChar[0], bl

			;===============================
			; Get the Color index to use
			;===============================
			mov	bl, (GRID_CHAR PTR [eax]).Color

			;=============================================
			; Set the and text color if needed
			;=============================================
			.if bl != PrevIndex
				mov	PrevIndex, bl
				shl	ebx, 2
				mov	eax, offset Palette
				add	ebx, eax
				mov	eax, DWORD PTR [ebx]
				invoke SetTextColor, DC, eax
			
			.endif

			;===================================
			; Paint the Cur Character 
			;===================================
			invoke DrawText, DC, ADDR DrawChar, 1, ADDR TextRect, DT_CENTER or \
					DT_VCENTER or DT_SINGLELINE

			;===============================
			; Increment the Col index
			;===============================
			inc	ColIndex

			;===================================
			; Adjust our rect by one row over 
			;===================================
			mov	eax, Adjust
			add	TextRect.left, eax
			mov	bl, Cols
			add	TextRect.right, eax

		.endw

		;===================================
		; Adjust our rect by one row down 
		;===================================
		mov	eax, Adjust
		add	TextRect.top, eax
		add	TextRect.bottom, eax

		;===============================
		; Increment the row index
		;===============================
		inc	RowIndex
		
		;================================
		; Place Rows in bl for loop test
		;================================
		mov	bl, Rows

	.endw

	;===============================
	; Restore old object 
	;===============================
	pop	eax
	invoke SelectObject, DC, eax

	;===============================
	; Delete the FONT object
	;===============================
	invoke DeleteObject, hFont

done:
	return TRUE

err:

	return FALSE	
         
DrawImage endp
;########################################################################
; END of DrawImage				    
;########################################################################

;########################################################################
; DrawCurrent Function
;########################################################################
DrawCurrent proc	DC:DWORD
	
	;===============================================
	; This code will draw our current captions and
	; the current colors onto the screen
	;===============================================

	;============================
	; Local Variables
	;============================
	LOCAL	hFont		:DWORD
	LOCAL	TextRect	:RECT
	LOCAL	hPen		:DWORD
	LOCAL	hBrush		:DWORD

	;============================================
	; Draw our Buttons on the display
	;============================================
	invoke DrawFrameControl, DC, ADDR Rect_Prev, DFC_BUTTON, DFCS_BUTTONPUSH
	invoke DrawFrameControl, DC, ADDR Rect_Next, DFC_BUTTON, DFCS_BUTTONPUSH

	;=============================================
	; Fill in the rect for our edit control
	;=============================================
	RGB	255,255,255
	invoke CreateSolidBrush, eax
	push	eax
	invoke FillRect, DC, ADDR Rect_Char, eax
	pop	eax
	invoke DeleteObject,eax

	;=============================================
	; Draw a sunken rect for our edit control
	;=============================================
	invoke DrawEdge, DC, ADDR Rect_Char, EDGE_SUNKEN,BF_RECT

	;=============================================
	; Set the and text color
	;=============================================
	RGB	0,0,192
	invoke SetTextColor, DC, eax
		
	;=================================================
	; Create and Select the Font preserve old on stack
	;=================================================
	mov	Font.lfWeight, FW_BOLD
	mov	Font.lfHeight, -16
	invoke CreateFontIndirect, offset Font
	mov	hFont, eax
	invoke SelectObject, DC, hFont
	push	eax

	;===================================
	; Paint the Cur Character Caption
	;===================================
	mov	TextRect.top, 56
	mov	TextRect.left, 464 
	mov	TextRect.right, 609
	mov	TextRect.bottom, 76
	invoke DrawText,DC,ADDR Cap_CurChar,\
		 SIZEOF Cap_CurChar, ADDR TextRect, DT_LEFT

	;===================================
	; Paint the Current Colors 
	;===================================
	mov	TextRect.top, 88
	mov	TextRect.left, 480
	mov	TextRect.right, 597
	mov	TextRect.bottom, 108
	invoke DrawText,DC,ADDR Cap_CurColors,\
		 SIZEOF Cap_CurColors, ADDR TextRect, DT_LEFT

	;===================================
	; Paint the Current Colors 
	;===================================
	mov	TextRect.top, 184
	mov	TextRect.left, 505
	mov	TextRect.right, 563
	mov	TextRect.bottom, 204
	invoke DrawText,DC,ADDR Cap_Palette,\
		 SIZEOF Cap_Palette, ADDR TextRect, DT_LEFT

	;===============================
	; Restore old object 
	;===============================
	pop	eax
	invoke SelectObject, DC, eax

	;===============================
	; Delete the FONT object
	;===============================
	invoke DeleteObject, hFont

	;=============================================
	; Set the text color to black
	;=============================================
	invoke SetTextColor, DC, 0

	;=================================================
	; Create and Select the Font preserve old on stack
	;=================================================
	mov	ArtFont.lfHeight, -16
	invoke CreateFontIndirect, offset ArtFont
	mov	hFont, eax
	invoke SelectObject, DC, hFont
	push	eax

	;===================================
	; Paint the Current Character 
	;===================================
	invoke DrawText,DC,ADDR CurChar,\
		 1, ADDR Rect_Char, DT_CENTER or DT_VCENTER or DT_SINGLELINE

	;===============================
	; Restore old object 
	;===============================
	pop	eax
	invoke SelectObject, DC, eax

	;===============================
	; Delete that font
	;===============================
	invoke DeleteObject, hFont

	;=================================================
	; Create and Select the Font preserve old on stack
	;=================================================
	mov	Font.lfWeight, FW_BOLD
	mov	Font.lfHeight, -13
	invoke CreateFontIndirect, offset Font
	mov	hFont, eax
	invoke SelectObject, DC, hFont
	push	eax


	;===================================
	; Paint the Character
	;===================================
	mov	TextRect.top, 152
	mov	TextRect.left, 450
	mov	TextRect.right, 518
	mov	TextRect.bottom, 168
	invoke DrawText,DC,ADDR Cap_Char,\
		 SIZEOF Cap_Char, ADDR TextRect, DT_LEFT

	;===================================
	; Paint the Background
	;===================================
	mov	TextRect.left, 542
	mov	TextRect.right, 636
	invoke DrawText,DC,ADDR Cap_Background,\
		 SIZEOF Cap_Background, ADDR TextRect, DT_LEFT

	;===============================
	; Restore old object 
	;===============================
	pop	eax
	invoke SelectObject, DC, eax

	;===============================
	; Delete that font
	;===============================
	invoke DeleteObject, hFont

	;========================================
	; Create our new pen of the color black
	;========================================
	invoke CreatePen, PS_SOLID, 2, 0
	mov	hPen, eax

	;========================================
	; Select our new pen and save the old one
	; on the stack for later
	;========================================
	invoke SelectObject, DC, hPen
	push	eax

	;=====================================
	; Create the brush for filling in
	; the background
	;=====================================
	invoke CreateSolidBrush, Color_Background
	mov	hBrush, eax
	invoke SelectObject, DC, eax
	push	eax

	;======================================
	; Make a call to draw the rectangle
	; outlined in the pen color and filled
	; in with the brush color
	;======================================
	invoke Rectangle, DC, 555, 112, 612, 145

	;====================================
	; Select the old object back in
	;====================================
	pop	eax
	invoke SelectObject, DC, eax
	
	;==================================
	; Delete our Brush we created
	;==================================
	invoke DeleteObject, hBrush

	;=====================================
	; Obtain the current character color
	;=====================================
	xor	eax, eax
	mov	al, Color_Char
	shl	eax, 2
	mov	ebx, offset Palette
	add	ebx, eax
	mov	eax, DWORD PTR [ebx]

	;=====================================
	; Create the brush for filling in
	; the current character
	;=====================================
	invoke CreateSolidBrush, eax
	mov	hBrush, eax

	;===============================
	; Select brush and preserve old
	;===============================
	invoke SelectObject, DC, eax
	push	eax

	;======================================
	; Make a call to draw the rectangle
	; outlined in the pen color and filled
	; in with the brush color
	;======================================
	invoke Rectangle, DC, 456, 112, 513, 145

	;====================================
	; Select the old object back in
	;====================================
	pop	eax
	invoke SelectObject, DC, eax
	
	;==================================
	; Delete our Brush we created
	;==================================
	invoke DeleteObject, hBrush

	;====================================
	; Select the old object back in
	;====================================
	pop	eax
	invoke SelectObject, DC, eax

	;==================================
	; Delete our Pen we created
	;==================================
	invoke DeleteObject, hPen

	;=============================================
	; Set the text color
	;=============================================
	invoke SetTextColor, DC, Color_Background
		
	;=================================================
	; Create and Select the Font preserve old on stack
	;=================================================
	mov	Font.lfWeight, FW_BOLD
	mov	Font.lfHeight, 11
	invoke CreateFontIndirect, offset Font
	mov	hFont, eax
	invoke SelectObject, DC, hFont
	push	eax

	;===================================
	; Print out the Cur pos 
	;===================================
	mov	eax, CurrentX
	mov	dwArgs, eax
	mov	dwArgs[4], 80		; Invert the Y value
	mov	eax, CurrentY
	sub	dwArgs[4], eax
	invoke wvsprintfA, ADDR GridPosBuffer, ADDR Grid_Pos_Temp, offset dwArgs
	invoke TextOut, DC, 5, 418, ADDR GridPosBuffer, eax
	
	;===============================
	; Restore old object 
	;===============================
	pop	eax
	invoke SelectObject, DC, eax

	;===============================
	; Delete the FONT object
	;===============================
	invoke DeleteObject, hFont

	;=============================================
	; Set the text color
	;=============================================
	invoke GetSysColor, COLOR_GRAYTEXT
	invoke SetTextColor, DC, eax
	
	;=================================================
	; Create and Select the Font preserve old on stack
	;=================================================
	mov	Font.lfWeight, FW_NORMAL
	invoke CreateFontIndirect, offset Font
	mov	hFont, eax
	invoke SelectObject, DC, hFont
	push	eax

	;===================================
	; Paint the Copyright 
	;===================================
	mov	TextRect.top, 416
	mov	TextRect.left, 448 
	mov	TextRect.right, 624
	mov	TextRect.bottom, 429
	invoke DrawText,DC,ADDR Cap_Copyright,\
		 SIZEOF Cap_Copyright, ADDR TextRect, DT_LEFT

	;=============================================
	; Set the text color to black
	;=============================================
	invoke SetTextColor, DC, 0

	;===============================
	; Draw captions for buttons
	;===============================
	invoke DrawText,DC,ADDR szPrevButton,SIZEOF szPrevButton - 1, \
		ADDR Rect_Prev, DT_CENTER or DT_VCENTER or DT_SINGLELINE
	invoke DrawText,DC,ADDR szNextButton,SIZEOF szNextButton - 1, \
		ADDR Rect_Next, DT_CENTER or DT_VCENTER or DT_SINGLELINE

	;===============================
	; Restore old object 
	;===============================
	pop	eax
	invoke SelectObject, DC, eax

	;===============================
	; Delete the FONT object
	;===============================
	invoke DeleteObject, hFont
	
done:
	return TRUE

err:

	return FALSE	
         
DrawCurrent endp
;########################################################################
; END of DrawCurrent				    
;########################################################################

;########################################################################
; DrawPalette Function
;########################################################################
DrawPalette proc	DC:DWORD
	
	;===============================================
	; This code will draw our palette caption and
	; the colors for the palette on the screen
	;===============================================

	;=========================
	; Local Variables
	;=========================
	LOCAL	Row		:BYTE
	LOCAL	Column		:BYTE
	LOCAL	hPen		:DWORD
	LOCAL	YCoord		:DWORD
	LOCAL	XCoord		:DWORD

	;========================================
	; Create our new pen of the color black
	;========================================
	invoke CreatePen, PS_SOLID, 2, 0
	mov	hPen, eax

	;========================================
	; Select our new pen and save the old one
	; on the stack for later
	;========================================
	invoke SelectObject, DC, hPen
	push	eax

	;==========================================
	; Loop through every row for the palette
	;==========================================
	mov	Row, 0
	.while Row < 5
		;=======================================
		; Adjust for the row that we are in
		; This is the Y coordinate
		;=======================================
		mov	ebx, 208	; Lowest Y coord Possible
		mov	eax, 40	; Height + Spacing between each
		mul	Row		; The current row we are on
		add	eax, ebx
		mov	YCoord, eax

		;==========================================
		; Now loop through every column in the row
		;==========================================
		mov	Column, 0
		.while Column < 4
			;=======================================
			; Adjust for the column that we are in
			; This is the X coordinate
			;=======================================
			mov	ebx, 448	; Lowest X coord possible
			mov	eax, 48 	; Width + Spacing Between each
			mul	Column		; Current column we are in
			add	eax, ebx
			mov	XCoord, eax

			;===========================================
			; Figure out which palette index we are on
			;===========================================
			xor	eax, eax	
			mov	al, Row
			shl	eax, 2
			add	al, Column
			shl	eax, 2

			;=============================
			; Load in address of Palette
			;=============================
			mov	ebx, offset Palette

			;=====================================
			; Adjust array to proper Color index
			;=====================================
			add	ebx, eax

			;=============================
			; Place the color into eax
			;=============================
			mov	eax, DWORD PTR [ebx]

			;=============================
			; Make the call to create 
			;=============================
			invoke CreateSolidBrush, eax
			push	eax

			;===============================
			; Select the brush into our DC
			; and preserve the old object
			;===============================
			invoke SelectObject, DC, eax
			push	eax

			;======================================
			; Make a call to draw the rectangle
			; outlined in the pen color and filled
			; in with the brush color
			;======================================
			mov	eax, XCoord
			mov	ecx, eax
			add	ecx, 30
			mov	ebx, YCoord
			mov	edx, ebx
			add	edx, 30
			invoke Rectangle, DC, eax, ebx, ecx, edx

			;===============================
			; Select the old object back in
			;===============================
			pop	eax
			invoke SelectObject, DC, eax
		
			;===============================
			; Delete our brush we created
			;===============================
			pop	eax
			invoke DeleteObject, eax

			;=======================
			; Increment the column
			;=======================
			inc	Column

		.endw

		;=======================
		; Increment the row
		;=======================
		inc	Row

	.endw

	;====================================
	; Select the old object back in
	;====================================
	pop	eax
	invoke SelectObject, DC, eax
	
	;==================================
	; Delete our Pen we created
	;==================================
	invoke DeleteObject, hPen

done:
	return TRUE

err:

	return FALSE	
         
DrawPalette endp
;########################################################################
; END of DrawPalette				    
;########################################################################

;########################################################################
; DrawOutlines Function
;########################################################################
DrawOutlines proc	DC:DWORD
	
	;===============================================
	; This code will draw the outlines around our
	; form and around the image they are drawing
	;===============================================

	;===============================
	; Local Variables
	;===============================
	LOCAL	hPen		:DWORD
	LOCAL	hBrush		:DWORD

	;========================================
	; Create our new pen of the color black
	;========================================
	invoke CreatePen, PS_SOLID, 3, 0
	mov	hPen, eax

	;========================================
	; Select our new pen and save the old one
	; on the stack for later
	;========================================
	invoke SelectObject, DC, hPen
	push	eax

	;======================================
	; Draw the outlining frame for form
	; and the dividers for the palette
	;======================================
	invoke MoveToEx, DC, 632, 432, NULL
	invoke LineTo, DC, 632, 0	
	invoke MoveToEx, DC, 632, 1, NULL
	invoke LineTo, DC, 0, 1	
	invoke MoveToEx, DC, 1, 0, NULL
	invoke LineTo, DC, 1, 432	
	invoke MoveToEx, DC, 0, 432, NULL
	invoke LineTo, DC, 632, 432	
	invoke MoveToEx, DC, 440, 0, NULL
	invoke LineTo, DC, 440, 432	
	invoke MoveToEx, DC, 440, 176, NULL
	invoke LineTo, DC, 632, 176	
	invoke MoveToEx, DC, 440, 80, NULL
	invoke LineTo, DC, 632, 80	

	;====================================
	; Select the old object back in
	;====================================
	pop	eax
	invoke SelectObject, DC, eax
	
	;==================================
	; Delete our Pen we created
	;==================================
	invoke DeleteObject, hPen

	;========================================
	; Create our new pen of the color black
	;========================================
	invoke CreatePen, PS_SOLID, 1, 0
	mov	hPen, eax

	;========================================
	; Select our new pen and save the old one
	; on the stack for later
	;========================================
	invoke SelectObject, DC, hPen
	push	eax

	;=======================================
	; Outline our image
	;=======================================
	invoke MoveToEx, DC, 19, 15, NULL
	invoke LineTo, DC, 421, 15	
	invoke LineTo, DC, 421, 417	
	invoke LineTo, DC, 19, 417	
	invoke LineTo, DC, 19, 15	

	;=============================================
	; First we need to complement the current
	; background color to get the fill color
	;=============================================
	mov	eax, Color_Background
	xor	eax, 0FFFFFFFFh

	;=====================================
	; Fill in around the image borders
	;=====================================
	invoke CreateSolidBrush, eax
	push	eax
	invoke SelectObject, DC, eax
	push	eax
	invoke ExtFloodFill, DC, 10, 10, 0, FLOODFILLBORDER
	pop	eax
	invoke SelectObject, DC, eax
	pop	eax
	invoke DeleteObject,eax

	;====================================
	; Select the old object back in
	;====================================
	pop	eax
	invoke SelectObject, DC, eax
	
	;==================================
	; Delete our Pen we created
	;==================================
	invoke DeleteObject, hPen

done:
	return TRUE

err:

	return FALSE	
         
DrawOutlines endp
;########################################################################
; END of DrawOutlines				    
;########################################################################

;########################################################################
; InitPalette Function
;########################################################################
InitPalette proc
	
	;================================================
	; This function initializes our palette to
	; the default colors for it. It also creates a 
	; solid brush and stores it in a special array.
	;================================================

	;======================================
	; Start off by obtaining the address
	; of the default and the main
	;======================================
	mov	eax, offset Palette	
	mov	ebx, offset DEFAULT_PAL

	;=====================================
	; Loop through all 20 colors
	;=====================================
	mov	cl, 0
	.while cl < 20
		;=============================
		; Transer the default value
		;=============================
		mov	edx, DWORD PTR [ebx]
		mov	DWORD PTR [eax], edx

		;========================
		; Increment our pointers
		;========================
		add	eax, 4
		add	ebx, 4

		;======================
		; Increment our counter
		;======================
		inc	cl

	.endw

done:
	return TRUE

err:

	return FALSE	
         
InitPalette endp
;########################################################################
; END of InitPalette				    
;########################################################################

;########################################################################
; InitImage Function
;########################################################################
InitImage proc
	
	;===================================================
	; This function initializes our image to all spaces
	; for the character with a color index of 0
	;===================================================
	
	;==========================
	; Start a counter variable
	;==========================
	mov	ecx, 0

	;===============================
	; Loop through all 6400 entries
	;===============================
	.while ecx < GRID_SIZE
		;========================
		; Load starting offset
		;========================
		mov	eax, Image

		;============================
		; Move counter into ebx and 
		; shift left by 1 since 
		; there are two bytes per
		;============================
		mov	ebx, ecx
		shl	ebx, 1

		;=============================
		; Add the offset to the start
		;=============================
		add	eax, ebx
		
		;================================
		; Set to the default color index
		;================================
		mov	bl, DEFAULT_COLOR
		mov	(GRID_CHAR PTR [eax]).Color, bl

		;================================
		; Set the default character
		;================================
		mov	bl, DEFAULT_CHAR
		mov	(GRID_CHAR PTR [eax]).Char, bl

		;================================
		; Incrment the counter
		;================================
		inc	ecx

	.endw

done:
	return TRUE

err:

	return FALSE	
         
InitImage endp
;########################################################################
; END of InitImage				    
;########################################################################

;########################################################################
; Handle the about box
;########################################################################
AboutProc proc	hDlg   :DWORD,
		uMsg   :DWORD,
		wParam :DWORD,
		lParam :DWORD
	
	;=================================
	; The equate for the homepage code
	;=================================
	IDHOME		equ	0

	;=========================
	; Get the message into eax
	;=========================
	mov	eax, uMsg
	.IF (eax == WM_INITDIALOG)
		invoke MiscCenterWnd, hDlg, hMainWnd

	.ELSEIF (eax == WM_COMMAND) && (wParam == IDOK) 
		invoke EndDialog, hDlg, TRUE

	.ELSEIF (eax == WM_COMMAND) && (wParam == IDCANCEL) 
		invoke EndDialog, hDlg, FALSE

	.ELSEIF (eax == WM_COMMAND) && (wParam == IDHOME)
		;===================================
		; Execute our homepage
		;===================================
		invoke ShellExecute,0,0,ADDR Homepage,0,0,0

		.if eax <= 32
			;======================
			; Tell them we can't 
			; open the homepage
			;======================
			invoke MessageBox, hMainWnd, offset NoHomePage, NULL, MB_OK

		.endif

	.ELSE
		mov	eax, FALSE	; show message not processed
		jmp	Return
	.ENDIF
	mov	eax, TRUE		; show message was processed
	
	Return:	ret

AboutProc endp
;########################################################################
; END ABOUTPROC
;########################################################################

;########################################################################
; Handle the coloring dialog box
;########################################################################
ColorProc proc	hDlg   :DWORD,
		uMsg   :DWORD,
		wParam :DWORD,
		lParam :DWORD

	;==========================
	; Local Variables
	;==========================
	LOCAL	hDC		:DWORD

	;=========================
	; Get the message into eax
	;=========================
	mov	eax, uMsg
	.IF (eax == WM_INITDIALOG)
		;=============================
		; Center the Dialog Box
		;=============================
		invoke MiscCenterWnd, hDlg, hMainWnd

		;======================================
		; Extract the red component from the
		; color they want to alter
		;======================================
		xor	ebx, ebx
		mov	eax, Sel_Color
		mov	bl, al

		;======================================
		; Place it into the holding buffer
		;======================================
		mov	dwArgs, ebx
		invoke wvsprintfA, ADDR RGBBuffer, ADDR RGB_TEMP, offset dwArgs

		;=========================================
		; Get the handle of the red edit control
		;=========================================
		invoke GetDlgItem, hDlg, IDC_RED

		;===============================================
		; Set the color value into the red edit control
		;===============================================
		invoke SendMessage, eax, WM_SETTEXT, 0, ADDR RGBBuffer

		;======================================
		; Extract the green component from the
		; color they want to alter
		;======================================
		xor	ebx, ebx
		mov	eax, Sel_Color
		mov	bl, ah

		;======================================
		; Place it into the holding buffer
		;======================================
		mov	dwArgs, ebx
		invoke wvsprintfA, ADDR RGBBuffer, ADDR RGB_TEMP, offset dwArgs

		;=========================================
		; Get the handle of the green edit control
		;=========================================
		invoke GetDlgItem, hDlg, IDC_GREEN

		;=================================================
		; Set the color value into the green edit control
		;=================================================
		invoke SendMessage, eax, WM_SETTEXT, 0, ADDR RGBBuffer

		;======================================
		; Extract the BLUE component from the
		; color they want to alter
		;======================================
		xor	ebx, ebx
		mov	eax, Sel_Color
		shr	eax, 16
		mov	bl, al

		;======================================
		; Place it into the holding buffer
		;======================================
		mov	dwArgs, ebx
		invoke wvsprintfA, ADDR RGBBuffer, ADDR RGB_TEMP, offset dwArgs

		;=========================================
		; Get the handle of the blue edit control
		;=========================================
		invoke GetDlgItem, hDlg, IDC_BLUE

		;=================================================
		; Set the color value into the blue edit control
		;=================================================
		invoke SendMessage, eax, WM_SETTEXT, 0, ADDR RGBBuffer

	.ELSEIF (eax == WM_COMMAND) && (wParam == IDC_PREVIEW)
		;==========================================
		; Get the color they have specified
		;==========================================
		invoke GetColor, hDlg

		;==========================================
		; Draw the preview if successfull
		;==========================================
		.if eax != -1				
			;==========================================
			; Save that color
			;==========================================
			push	eax

			;==========================================
			; Get a DC into our dialog box
			;==========================================
			invoke GetDC, hDlg
			mov	hDC, eax

			;==========================================
			; Draw the preview color
			;==========================================
			pop	eax
			invoke DrawPreview, hDC, eax

			;==========================================
			; Release the device context
			;==========================================
			invoke ReleaseDC, hDlg, hDC

		.endif
		
	.ELSEIF (eax == WM_COMMAND) && (wParam == IDOK) 
		;=====================================
		; Get the color they have specified
		;=====================================
		invoke GetColor, hDlg

		;=====================================
		; Were we successfull at getting it
		;=====================================
		.if eax != -1
			;========================================
			; Yes, so End the Dialog Proc with color
			; as our return value
			;========================================
			invoke EndDialog, hDlg, eax

		.endif

	.ELSEIF (eax == WM_COMMAND) && (wParam == IDCANCEL)
		;================================
		; End the Dialog Proc with a -1
		; to show no change color
		;================================
		invoke EndDialog, hDlg, -1

	.ELSE
		;==================================
		; Show that we didn't process
		;==================================
		mov	eax, FALSE	
		jmp	Return

	.ENDIF

	;==================================
	; Show that we did process
	;==================================
	mov	eax, TRUE
	
	;==================================
	; Return from this message
	;==================================
	Return:	ret

ColorProc endp
;########################################################################
; END ColorProc
;########################################################################

;########################################################################
; Handle the Character Palette dialog box
;########################################################################
CharProc proc	hDlg   :DWORD,
		uMsg   :DWORD,
		wParam :DWORD,
		lParam :DWORD

	;==========================
	; Local Variables
	;==========================
	LOCAL	hDC		:DWORD
	LOCAL	hPen		:DWORD
	LOCAL	Index1		:BYTE
	LOCAL	Index2		:BYTE
	LOCAL	hFont		:DWORD

	;=========================
	; Get the message into eax
	;=========================
	mov	eax, uMsg
	.IF (eax == WM_INITDIALOG)
		;=============================
		; Center the Dialog Box
		;=============================
		invoke MiscCenterWnd, hDlg, hMainWnd

	.ELSEIF eax == WM_PAINT
		;======================================
		; Draw all of the characters for them
		;======================================

		;==========================
		; Get the DC
		;==========================
		invoke GetDC, hDlg
		mov	hDC, eax

		;========================================
		; Create our new pen of the color black
		;========================================
		invoke CreatePen, PS_SOLID, 1, 0
		mov	hPen, eax

		;========================================
		; Select our new pen and save the old one
		; on the stack for later
		;========================================
		invoke SelectObject, hDC, hPen
		push	eax

		;=============================
		; Make the call to create 
		;=============================
		RGB 255,255,255
		invoke CreateSolidBrush, eax
		push	eax

		;===============================
		; Select the brush into our DC
		; and preserve the old object
		;===============================
		invoke SelectObject, hDC, eax
		push	eax

		;===========================
		; Draw the Rect and fill
		;===========================
		invoke Rectangle, hDC, 10, 10, 476, 173

		;===============================
		; Select the old object back in
		;===============================
		pop	eax
		invoke SelectObject, hDC, eax
		
		;===============================
		; Delete our brush we created
		;===============================
		pop	eax
		invoke DeleteObject, eax

		;====================================
		; Select the old object back in
		;====================================
		pop	eax
		invoke SelectObject, hDC, eax
	
		;==================================
		; Delete our Pen we created
		;==================================
		invoke DeleteObject, hPen

		;==================================
		; Set the text color and BK mode
		;==================================
		invoke SetTextColor, hDC, 0
		invoke SetBkMode, hDC, TRANSPARENT
		
		;===================================
		; Create the ASrt font for this
		;===================================
		mov	ArtFont.lfHeight, -16
		invoke CreateFontIndirect, offset ArtFont
		mov	hFont, eax
		invoke SelectObject, hDC, eax
		push	eax

		;============================================
		; Loop through and draw all of the characters
		; that we need to show
		;============================================
		mov	Index1, 0
		mov	Index2, 0
		mov	CharIndex, 33
		.while Index1 < 5
			;==========================
			; reset Index2
			;==========================
			mov	Index2, 0

			.while Index2 < 19
				;================================
				; Calulate the X position
				;================================
				xor	eax, eax
				mov	al, Index2
				mov	ecx, 20
				mul	ecx
				add	eax, 60
				push	eax

				;================================
				; Calulate the Y position
				;================================
				xor	eax, eax
				mov	al, Index1
				mov	ecx, 30
				mul	ecx
				add	eax, 20

				;======================================
				; Draw the character on the screen
				;======================================
				pop	ebx
				invoke TextOut, hDC, ebx , eax, \
					ADDR CharIndex, 1

				;================================
				; Inc the second & char indexes
				;================================
				inc	Index2
				inc	CharIndex

			.endw

			;=====================
			; Inc the first index
			;=====================
			inc	Index1

		.endw

		;============================
		; Select old and delete
		;============================
		pop	eax
		invoke SelectObject, hDC, eax
		invoke DeleteObject, hFont

		;============================
		; Release the Device Context
		;============================
		invoke ReleaseDC, hDlg, hDC

		;=============================
		; Show we processed it
		;=============================
		return	0

	.ELSEIF eax == WM_LBUTTONUP
		;============================================
		; Close and select the charcter they wanted
		;============================================
		mov	eax, lParam

		;================================
		; Start with the X coord calcs
		;================================
		.if ax < 60 || ax > 450
			;======================
			; They couldn't be in
			;======================
			return 0

		.endif
		mov	bx, ax
		xor	eax, eax
		mov	ax, bx
		sub	eax, 60
		xor	edx, edx
		mov	ecx, 20
		div	ecx
		push	eax

		;==============================
		; Now eliminate Y coords
		;==============================
		mov	eax, lParam
		shr	eax, 16
		.if ax < 20 || ax > 160
			;======================
			; They couldn't be in
			;======================
			return 0

		.endif
		sub	eax, 20
		mov	ecx, 30
		xor	edx, edx
		div	ecx
		mov	ecx, 19
		mul	ecx
		pop	ebx
		add	eax, ebx

		;==================================
		; Add the offset to the CharIndex
		; starting point
		;==================================
		add	eax, 33

		;======================================
		; Set the CurChar value based on this
		;======================================
		mov	CurChar, al

		;=======================================
		; End the Dialog Box
		;=======================================
		invoke EndDialog, hDlg, TRUE

	.ELSEIF (eax == WM_COMMAND) && (wParam == IDCANCEL)
		;================================
		; End the Dialog Proc with a -1
		; to show no change color
		;================================
		invoke EndDialog, hDlg, FALSE

	.ELSE
		;==================================
		; Show that we didn't process
		;==================================
		mov	eax, FALSE	
		jmp	Return

	.ENDIF

	;==================================
	; Show that we did process
	;==================================
	mov	eax, TRUE
	
	;==================================
	; Return from this message
	;==================================
	Return:	ret

CharProc endp
;########################################################################
; END CharProc
;########################################################################

;########################################################################
; DrawPreview Function
;########################################################################
DrawPreview proc	hDC:DWORD, Color:DWORD
	
	;================================================
	; This function draws the color preview in our
	; color changing dialog box
	;================================================

	;==============================
	; Local Variables
	;==============================
	LOCAL	hPen		:DWORD

	;========================================
	; Create our new pen of the color black
	;========================================
	RGB	0,0,0		; BLACK
	invoke CreatePen, PS_SOLID, 2, eax
	mov	hPen, eax

	;========================================
	; Select our new pen and save the old one
	; on the stack for later
	;========================================
	invoke SelectObject, hDC, hPen
	push	eax

	;=============================
	; Make the call to create 
	;=============================
	invoke CreateSolidBrush, Color
	push	eax

	;===============================
	; Select the brush into our DC
	; and preserve the old object
	;===============================
	invoke SelectObject, hDC, eax
	push	eax

	;======================================
	; Make a call to draw the rectangle
	; outlined in the pen color and filled
	; in with the brush color
	;======================================
	invoke Rectangle, hDC, Rect_Preview.left, Rect_Preview.top,\
		 Rect_Preview.right, Rect_Preview.bottom

	;===============================
	; Select the old object back in
	;===============================
	pop	eax
	invoke SelectObject, hDC, eax
		
	;===============================
	; Delete our brush we created
	;===============================
	pop	eax
	invoke DeleteObject, eax

	;====================================
	; Select the old object back in
	;====================================
	pop	eax
	invoke SelectObject, hDC, eax
	
	;==================================
	; Delete our Pen we created
	;==================================
	invoke DeleteObject, hPen

done:
	return TRUE

err:

	return FALSE	
         
DrawPreview endp
;########################################################################
; END of DrawPreview				    
;########################################################################

;########################################################################
; GetColor Function
;########################################################################
GetColor proc	hDlg:DWORD
	
	;================================================
	; This function retrieves the color that they
	; have entered in the edit control if valid
	; it returns it otherwise it returns -1
	;================================================

	;==============================
	; Local Variables
	;==============================
	LOCAL	Color		:DWORD
	LOCAL	Good		:DWORD

	;=======================================================
	; Get the blue value they specified as an unsigned int
	;=======================================================
	invoke GetDlgItemInt, hDlg, IDC_BLUE, ADDR Good, FALSE

	;==================================
	; Was the conversion good
	;==================================
	.if Good == TRUE && eax < 256
		;=================================
		; Yes they entered a valid number
		;=================================
		mov	Color, eax

	.else
		;========================
		; Jump to err and return
		;========================
		jmp	err

	.endif

	;=======================================================
	; Get the Green value they specified as an unsigned int
	;=======================================================
	invoke GetDlgItemInt, hDlg, IDC_GREEN, ADDR Good, FALSE

	;==================================
	; Was the conversion good
	;==================================
	.if Good == TRUE && eax < 256
		;=================================
		; Yes they entered a valid number
		;=================================
		mov	ebx, Color
		shl	ebx, 8
		mov	bl, al
		mov	Color, ebx

	.else
		;========================
		; Jump to err and return
		;========================
		jmp	err

	.endif

	;=======================================================
	; Get the red value they specified as an unsigned int
	;=======================================================
	invoke GetDlgItemInt, hDlg, IDC_RED, ADDR Good, FALSE

	;==================================
	; Was the conversion good
	;==================================
	.if Good == TRUE && eax < 256
		;=================================
		; Yes they entered a valid number
		;=================================
		mov	ebx, Color
		shl	ebx, 8
		mov	bl, al
		mov	Color, ebx

	.else
		;========================
		; Jump to err and return
		;========================
		jmp	err

	.endif


done:
	;===========================
	; Good so return the color
	;===========================
	return Color

err:
	;=========================
	; Give message box
	;=========================
	invoke MessageBox, hDlg, ADDR szOver255, NULL, MB_OK


	return -1	
         
GetColor endp
;########################################################################
; END of GetColor				    
;########################################################################

;########################################################################
; Misc Center Window from SIB by Steve Gibson. Thanks Steve!				    
;########################################################################
MiscCenterWnd proc	hChild:DWORD,
			hParent:DWORD

		; Define the local variables
		LOCAL	rcP:RECT, rcC:RECT, xNew:DWORD, yNew:DWORD

invoke	GetWindowRect, hParent, ADDR rcP

.IF (eax)
	invoke	GetWindowRect, hChild, ADDR rcC
	.IF (eax)
		mov	eax, rcP.right	;center horizontally
		sub	eax, rcP.left	;x=Px+(Pdx-Cdx)/2
		sub	eax, rcC.right
		add	eax, rcC.left
		sar	eax, 1
		add	eax, rcP.left
	
		; check if off screen at left
		.IF (sign?)
			mov	eax, 0
		.ENDIF
		mov	xNew, eax

		invoke	GetSystemMetrics, SM_CXFULLSCREEN
		sub	eax, rcC.right
		add	eax, rcC.left
		
		; check if off screen at right
		.IF (eax < xNew)	
			mov	xNew, eax
		.ENDIF

		mov	eax, rcP.bottom	; center vertically
		sub	eax, rcP.top	; y=Py+(Pdy-Cdy)/2
		sub	eax, rcC.bottom
		add	eax, rcC.top
		sar	eax, 1
		add	eax, rcP.top

		; check if off screen at top
		.IF (sign?)		
			mov	eax, 0
		.ENDIF
		mov	yNew,eax

		invoke	GetSystemMetrics, SM_CYFULLSCREEN
		sub	eax, rcC.bottom
		add	eax, rcC.top
		.IF (eax < yNew)
			mov	yNew, eax
		.ENDIF

		invoke	SetWindowPos, hChild, NULL, xNew, yNew, 0, 0,\
				SWP_NOSIZE + SWP_NOZORDER

	.ENDIF
.ENDIF

Return:	ret

MiscCenterWnd	ENDP
;########################################################################
; END MISC CENTER WINDOW
;########################################################################

;########################################################################
; PUSHBUTTON PROCEDURE
;########################################################################
PushButton proc lpText:DWORD,hParent:DWORD,
                a:DWORD,b:DWORD,wd:DWORD,ht:DWORD,ID:DWORD

; PushButton PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
; invoke PushButton,ADDR szCaption,hWnd,20,20,100,25,500

    szText btnClass,"BUTTON"

    invoke CreateWindowEx,0,
            ADDR btnClass,lpText,
            WS_CHILD or WS_VISIBLE,
            a,b,wd,ht,hParent,ID,
            hInst,NULL

    ret

PushButton endp
;########################################################################
; END of PUSHBUTTON PROCEDURE
;########################################################################

;########################################################################
; EditSl PROCEDURE
;########################################################################
EditSl proc szMsg:DWORD,a:DWORD,b:DWORD,
               wd:DWORD,ht:DWORD,hParent:DWORD,ID:DWORD

; EditSl PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
; invoke EditSl,adrTxt,200,10,150,250,hWnd,700

    szText slEdit,"EDIT"

    invoke CreateWindowEx,WS_EX_CLIENTEDGE,ADDR slEdit,szMsg,
                WS_VISIBLE or WS_CHILDWINDOW or \
                ES_NOHIDESEL or ES_CENTER,
              a,b,wd,ht,hParent,ID,hInst,NULL

    ret

EditSl endp
;########################################################################
; END of EditSl PROCEDURE
;########################################################################

;########################################################################
; EXTRACTRESOURCE procedure                            
;########################################################################
ExtractResource	proc lpFile:DWORD, lpFileName:DWORD, file_size:DWORD

	;=============================================
	; Finds and loads resources, then writes 
	; them to specified file must delete by hand 
	; on close of app
	;=============================================

	;====================================
	; Local Variables
	;====================================
	LOCAL		hRes:DWORD
	LOCAL		hResFile:DWORD	

	;=====================================
	; Find the file
	;=====================================
	invoke FindResource,hInst,lpFile,RT_RCDATA
	mov	hRes, eax

	;=====================================
	; test for an error loading
	;=====================================
	.if eax == NULL
		jmp	errr
	.endif

	;=====================================
	; Find the size
	;=====================================
	invoke SizeofResource,hInst,hRes
	mov	file_size, eax

	;=====================================
	; test for an error loading
	;=====================================
	.if eax == NULL
		jmp	errr
	.endif

	;=====================================
	; Load it into memory
	;=====================================
	invoke LoadResource, hInst, hRes

	;=====================================
	; test for an error loading
	;=====================================
	.if eax == NULL
		jmp	errr
	.endif

	;=====================================
	; Lock the resource
	;=====================================
	invoke LockResource,eax
	mov	hRes, eax

	;===========================================
	; test for an error locking the resource
	;===========================================
	.if eax == NULL
		jmp	errr
	.endif

	;============================================
	; Expand and write the resource out
	;============================================
	invoke ExpandResource, hRes, lpFileName, file_size

	;======================================
	; Test for an error expanding
	;======================================
	.if eax == 0
		jmp	errr

	.endif

done:
	return TRUE

errr:

	return FALSE	

ExtractResource	endp
;########################################################################
; END OF ExtractResource FUNCTION
;########################################################################

;########################################################################
; ExpandFile Function
;########################################################################
ExpandResource proc hSrc_Memory:DWORD, lpDestName:DWORD, Src_Size:DWORD
	
	;=========================================
	; Code to decompress the chosen resource
	;=========================================

	;=====================================
	; define all of the local variables
	;=====================================
	LOCAL	Char_In:BYTE
	LOCAL Char_Out:BYTE
	LOCAL Prev_Char1:BYTE
	LOCAL Prev_Char2:BYTE
	LOCAL Bit_Mask:BYTE
	LOCAL pcTable:DWORD
	LOCAL Num_In_Mask:BYTE
	LOCAL	hDest_Memory:DWORD
	LOCAL	Spot:DWORD
	LOCAL Dest_index:DWORD
	LOCAL hRFile:DWORD


	;==============================================
	; Allocate worst case scenario memory
	; for compression program
	;==============================================
	mov	eax, Src_Size
	shl	eax, 4
	invoke GlobalAlloc, GMEM_FIXED, eax
	mov	hDest_Memory, eax
	mov	Dest_index, 0

	;===============================
	; test for an error
	;===============================
	.if eax == 0
		jmp	err
	.endif

	;======================================
	; Allocate memory for our table
	;======================================
	invoke GlobalAlloc, GMEM_FIXED,  32768
	mov	pcTable, eax

	;========================================
	; Set to ascii 32 because it's most used
	;=========================================
	invoke RtlFillMemory, pcTable, 32768, 20h

	;=====================================
	; Initialize file vars just in case
	;=====================================
	mov	Dest_index, 0
	mov	Spot, 0
	mov	Bit_Mask, 0
	mov	Prev_Char1, 0
	mov	Prev_Char2, 0
	mov	Num_In_Mask, 0

	;======================================
	; get the byte from file
	;======================================
	jmp	tstEOF
top:	mov	eax, Spot
	.if eax <= Src_Size
		mov	ebx, hSrc_Memory
		add	ebx, Spot
		mov	al, BYTE PTR [ebx]
		mov	Char_In, al
		inc	Spot
		
	.endif

	;==================================
	; Put it into the mask for the loop
	;===================================
	mov	Bit_Mask, al

	;====================================
	; Loop for every bit in the mask
	;====================================
	mov	Num_In_Mask, 0
msk:
	cmp	Num_In_Mask, 8
	je	StopFor

	;====================================
	; Find out if we predicted this char
	;====================================
	mov	al, Bit_Mask
	mov	dx, 1
	mov	cl, Num_In_Mask
	mov	ah, 0
	shl	dx, cl
	test	ax,dx
	je	notpred

	;===================================
	; Yes, we predicted it, so process
	;===================================
	mov	bl, Prev_Char1
	mov	bh, 0
	mov	dl, Prev_Char2
	mov	dh, 0
	shl	bx, 7
	xor	bx, dx
	push	bx
	xor	ebx, ebx
	pop	bx
	mov	eax, pcTable
	add	eax, ebx
	mov	cl, BYTE PTR [eax]
	mov	Char_Out, cl

	;=============================
	; Jump over not pred
	;=============================
	jmp	donepred		


	;===============================
	; We didn't predict this one
	;===============================
notpred:
	;=============================
	; Read in the character we
	; will write out
	;=============================
	mov	eax, Spot
	.if eax <= Src_Size
		mov	ebx, hSrc_Memory
		add	ebx, Spot
		mov	cl, BYTE PTR [ebx]
		mov	Char_Out, cl
		inc	Spot

	.endif
		
	;============================
	; Update the table
	;============================	
	mov	bl, Prev_Char1
	mov	bh, 0
	mov	dl, Prev_Char2
	mov	dh, 0
	shl	bx, 7
	xor	bx, dx
	push	bx
	xor	ebx, ebx
	pop	bx
	mov	eax, pcTable
	add	eax, ebx
	mov	cl, Char_Out
	mov	BYTE PTR [eax], cl
	
donepred:
	;=============================
	; Write the character out to
	; our destination memory
	;=============================
	mov	ebx, hDest_Memory
	add	ebx, Dest_index
	mov	cl, Char_Out
	mov	BYTE PTR [ebx], cl
	inc	Dest_index

	;=============================
	; Shift the characters over
	;=============================
	mov	al, Prev_Char2
	mov	bl, Char_Out
	mov	Prev_Char2, bl
	mov	Prev_Char1, al

	;==========================
	; Inc and go back to mask
	; processing
	;==========================
	inc	Num_In_Mask
	jmp	msk	

	;===========================
	; Get another byte and do 
	; it again
	;===========================
StopFor:

	;=============================
	; Test to see if we are over
	; limit for source
	;=============================
tstEOF:
	mov	eax, Spot
	.if eax > Src_Size
		jmp	done
	.endif

	;===============
	; Do it again
	;===============
	jmp	top

done:
	;======================================
	; Create the file to write to
	;======================================
	invoke CreateFile, lpDestName, GENERIC_READ or GENERIC_WRITE, \
		FILE_SHARE_READ, NULL,OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL,NULL
	mov	hRFile, eax

	;===============================
	; Test for an error
	;===============================
	.if eax == INVALID_HANDLE_VALUE
		jmp err
	.endif

	;======================================
	; Write to the file
	;======================================
	dec	Dest_index
	dec	Dest_index
	invoke WriteFile, hRFile, hDest_Memory, 19763, hSrc_Memory, NULL

	;======================================
	; Tets for an error
	;======================================
	.if eax == 0
		;=========================
		; Jump to error
		;=========================
		jmp	err

	.endif

	;======================================
	; Close the handle to the file
	;======================================
	invoke CloseHandle, hRFile

	;===============================
	; Release the allocated memory
	;===============================
	invoke GlobalFree, hDest_Memory
	invoke GlobalFree, pcTable


	return TRUE

err:

	return FALSE	
         
ExpandResource endp
;########################################################################
; END of ExpandResource				    
;########################################################################

;######################################
; THIS IS THE END OF THE PROGRAM CODE #
;######################################
end start

