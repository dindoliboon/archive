' **************************************************************************
'           BCX Source Code Generated using Dialog Converter 1.3
'                 For Use With BCX Translator Version 2.02+
' **************************************************************************
' Pipe Example from : Iczelion's Win32 Assembly Tutorial part 21
' **************************************************************************
' Programs must use int 21h to display text for this to work
' If you are using Windows 2000, you can run applications by calling
'    cmd /S /K runthis.exe
'    cmd /S /K dir c:\winnt\*.*
' 0.2 - Moved CloseHandle(hRead) one line up
'       Allows pressing enter to display results

    CONST CaptionName1$ = "Log Box"
    CONST ClassName1$ = "cls_logbox"

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
    CASE WM_COMMAND
' **************************************************************************
        IF LOWORD(wParam) = ID_Button1 and HIWORD(wParam) = BN_CLICKED THEN
            CALL Button1_Clicked()
        END IF
        EXIT FUNCTION
' **************************************************************************
    CASE WM_CLOSE
' **************************************************************************
        LOCAL id

        id = MessageBox( _
        hWnd,            _
        "Are you sure?", _
        "Quit Program!", _
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
    6*BCX_ScaleX, 18*BCX_ScaleY,(4+ 200)*BCX_ScaleX,(12+ 137)*BCX_ScaleY, _
    NULL,NULL,hInst,NULL)

' **************************************************************************

    GLOBAL  Static1 AS HANDLE
    CONST   ID_Static1 =  101

    Static1 = CreateWindowEx(0,"static","Shell which file:", _
    WS_CHILD OR SS_NOTIFY OR SS_LEFT OR WS_VISIBLE, _
    5*BCX_ScaleX, 5*BCX_ScaleY, 52*BCX_ScaleX, 8*BCX_ScaleY, _
    Form1,ID_Static1,hInst,NULL)

    SendMessage(Static1, WM_SETFONT, _
    GetStockObject(DEFAULT_GUI_FONT),MAKELPARAM(FALSE,0))

' **************************************************************************

    GLOBAL  Edit1 AS HANDLE
    CONST   ID_Edit1 = 102

    Edit1 = CreateWindowEx(WS_EX_CLIENTEDGE,"edit","run.bat", _
    WS_CHILD OR WS_TABSTOP OR WS_VISIBLE OR  ES_AUTOHSCROLL, _
    60*BCX_ScaleX, 5*BCX_ScaleY, 88*BCX_ScaleX, 12*BCX_ScaleY, _
    Form1,ID_Edit1,hInst,NULL)

    SendMessage(Edit1, WM_SETFONT, _
    GetStockObject(DEFAULT_GUI_FONT),MAKELPARAM(FALSE,0))

    GLOBAL lpEdit1_WndProc AS FARPROC
    lpEdit1_WndProc = SetWindowLong(Edit1,GWL_WNDPROC,Edit1_WndProc)

' **************************************************************************

    GLOBAL  Button1 AS HANDLE
    CONST   ID_Button1 =  103

    Button1 = CreateWindowEx(0,"button","Run", _
    WS_CHILD OR WS_TABSTOP OR BS_PUSHBUTTON OR WS_VISIBLE, _
    155*BCX_ScaleX, 4*BCX_ScaleY, 40*BCX_ScaleX, 14*BCX_ScaleY, _
    Form1,ID_Button1,hInst,NULL)

    SendMessage(Button1, WM_SETFONT, _
    GetStockObject(DEFAULT_GUI_FONT),MAKELPARAM(FALSE,0))

' **************************************************************************

    GLOBAL  Edit2 AS HANDLE
    CONST   ID_Edit2 = 104

    Edit2 = CreateWindowEx(WS_EX_CLIENTEDGE,"edit",NULL, _
    WS_CHILD OR WS_TABSTOP OR WS_VISIBLE OR ES_MULTILINE OR ES_AUTOVSCROLL _
    OR ES_AUTOHSCROLL OR ES_READONLY OR WS_VSCROLL  OR  WS_HSCROLL, _
    5*BCX_ScaleX, 25*BCX_ScaleY, 190*BCX_ScaleX, 107*BCX_ScaleY, _
    Form1,ID_Edit2,hInst,NULL)

    SendMessage(Edit2, WM_SETFONT, _
    GetStockObject(DEFAULT_GUI_FONT),MAKELPARAM(FALSE,0))

' **************************************************************************

    CenterWindow (Form1)   ' Center our Form on the screen
    UpdateWindow (Form1)   ' Force update of all controls
    ShowWindow   (Form1,1) ' Display our creation!
END SUB

' **************************************************************************

SUB Button1_Clicked()
    STATIC pa     AS SECURITY_ATTRIBUTES
    STATIC pi     AS PROCESS_INFORMATION
    STATIC sui    AS STARTUPINFO
    STATIC hRead  AS PHANDLE
    STATIC hWrite AS PHANDLE
    STATIC bRead  AS DWORD
    STATIC lpString$
    STATIC lpBuffer$

    pa.nLength              = sizeof(SECURITY_ATTRIBUTES)
    pa.lpSecurityDescriptor = NULL
    pa.bInheritHandle       = TRUE

    IF CreatePipe(&hRead, &hWrite, &pa, 0) <> 0 THEN
        sui.cb = sizeof(STARTUPINFO)
        GetStartupInfo(&sui)
        sui.hStdOutput  = hWrite 
        sui.hStdError   = hWrite 
        sui.dwFlags     = STARTF_USESHOWWINDOW | STARTF_USESTDHANDLES
        sui.wShowWindow = SW_HIDE
        GetWindowText(Edit1, lpString$, 2048)
        IF CreateProcess(NULL, lpString$, NULL, NULL, TRUE, (DWORD) NULL, NULL, NULL, &sui, &pi) <> 0 THEN
            SetWindowText(Edit2, "")
            DO
                CloseHandle(hWrite)
                RtlZeroMemory(lpBuffer$, 1024)
                IF ReadFile(hRead, lpBuffer$, 1023, &bRead, NULL) THEN
                    SendMessage(Edit2, EM_SETSEL, -1, 0)
                    SendMessage(Edit2, EM_REPLACESEL, FALSE, lpBuffer$)
                ELSE
                    EXIT LOOP
                END IF
            LOOP
            CloseHandle(hRead)
        END IF
    END IF
END SUB

' **************************************************************************

CALLBACK FUNCTION Edit1_WndProc()
    SELECT CASE Msg
    CASE WM_KEYUP
        IF wParam = VK_RETURN THEN CALL Button1_Clicked()
    EXIT FUNCTION

    END SELECT
    FUNCTION = CallWindowProc(lpEdit1_WndProc,hWnd,Msg,wParam,lParam)
END FUNCTION

' **************************************************************************
