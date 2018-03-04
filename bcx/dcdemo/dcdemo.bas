' **************************************************************************
'           BCX Source Code Generated using Dialog Converter 1.3
'                 For Use With BCX Translator Version 2.02+
' **************************************************************************

CONST CaptionName1$ = "DLGEdit Demo"
CONST ClassName1$ = "Class Name"

GLOBAL BCX_GetDiaUnit
GLOBAL BCX_cxBaseUnit
GLOBAL BCX_cyBaseUnit
GLOBAL BCX_ScaleX
GLOBAL BCX_ScaleY



FUNCTION WinMain()
LOCAL Wc  AS WNDCLASS
LOCAL Msg AS MSG

IF FindFirstInstance(ClassName1$) THEN EXIT FUNCTION

Wc.style           = CS_HREDRAW OR CS_VREDRAW OR CS_DBLCLKS
Wc.lpfnWndProc     = WndProc1
Wc.cbClsExtra      = 0
Wc.cbWndExtra      = 0
Wc.hInstance       = hInst
Wc.hIcon           = LoadIcon     ( NULL,IDI_WINLOGO )
Wc.hCursor         = LoadCursor      ( NULL, IDC_ARROW )
Wc.hbrBackground   = GetSysColorBrush(COLOR_BTNFACE)
Wc.lpszMenuName    = NULL
Wc.lpszClassName   = ClassName1$
RegisterClass(&Wc)


FormLoad (hInst)

' ******************[ This Message Pump Allows Tabbing ]******************

WHILE GetMessage ( &Msg, NULL, 0 ,0 )
 IF NOT IsWindow( GetActiveWindow() ) OR _
    NOT IsDialogMessage( GetActiveWindow(), &Msg ) THEN
  TranslateMessage ( &Msg )
  DispatchMessage  ( &Msg )
 END IF
WEND

' **************************************************************************
FUNCTION = Msg.wParam
END FUNCTION



CALLBACK FUNCTION WndProc1()
SELECT CASE Msg
' **************************************************************************
' CASE WM_COMMAND
' **************************************************************************
  CASE WM_CLOSE
  LOCAL id
  id = MessageBox(        _
       hWnd,              _
       "Are you sure?",   _
       "Quit Program!",   _
       MB_YESNO OR MB_ICONQUESTION )
  IF id = IDYES THEN DestroyWindow (hWnd)
  EXIT FUNCTION
' **************************************************************************
  CASE WM_DESTROY 
' **************************************************************************
  PostQuitMessage(0)
  EXIT FUNCTION
END SELECT
FUNCTION = DefWindowProc(hWnd,Msg,wParam,lParam)
END FUNCTION



SUB CenterWindow (hWnd AS HWND)
DIM wRect AS RECT
DIM x AS DWORD
DIM y AS DWORD
GetWindowRect (hWnd, &wRect)
x = (GetSystemMetrics ( SM_CXSCREEN)-(wRect.right-wRect.left))/2
y = (GetSystemMetrics ( SM_CYSCREEN)- _
    (wRect.bottom-wRect.top+GetSystemMetrics(SM_CYCAPTION)))/2
SetWindowPos (hWnd, NULL,x,y,0,0,SWP_NOSIZE OR SWP_NOZORDER)
END SUB



FUNCTION FindFirstInstance(ApplName$)
LOCAL hWnd AS HWND
hWnd = FindWindow (ApplName$,NULL)
IF hWnd THEN
  FUNCTION = TRUE
END IF
FUNCTION = FALSE
END FUNCTION



SUB FormLoad ( hInst as HANDLE )
' **************************************************************************
'               Scale Dialog Units To Screen Units
' **************************************************************************

BCX_GetDiaUnit = GetDialogBaseUnits()
BCX_cxBaseUnit = LOWORD(BCX_GetDiaUnit)
BCX_cyBaseUnit = HIWORD(BCX_GetDiaUnit)
BCX_ScaleX     = BCX_cxBaseUnit/4
BCX_ScaleY     = BCX_cyBaseUnit/8

' **************************************************************************

GLOBAL Form1 AS HANDLE

Form1 = CreateWindow(ClassName1$,CaptionName1$, _
DS_MODALFRAME OR WS_POPUP OR WS_CAPTION OR WS_SYSMENU, _
6*BCX_ScaleX, 18*BCX_ScaleY,(4+ 119)*BCX_ScaleX,(12+ 25)*BCX_ScaleY, _
NULL,NULL,hInst,NULL)

' **************************************************************************

GLOBAL  Static1 AS HANDLE
CONST   ID_Static1 =  101

Static1 = CreateWindowEx(0,"static","Hello World!", _
WS_CHILD OR SS_NOTIFY OR SS_LEFT OR WS_VISIBLE, _
 40*BCX_ScaleX, 7*BCX_ScaleY, 40*BCX_ScaleX, 8*BCX_ScaleY, _ 
Form1,ID_Static1,hInst,NULL)

SendMessage(Static1, WM_SETFONT, _
GetStockObject(DEFAULT_GUI_FONT),MAKELPARAM(FALSE,0))

' **************************************************************************

CenterWindow (Form1)   ' Center our Form on the screen
UpdateWindow (Form1)   ' Force update of all controls
ShowWindow   (Form1,1) ' Display our creation!
END SUB



