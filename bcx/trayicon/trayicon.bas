' #########################################################################

    CONST CaptionName1$ = "trayicon"    ' program title
    CONST ClassName1$   = "Class Name"  ' program class

    CONST WM_SHELLNOTIFY = WM_USER + 5  ' shell notify message
    CONST ID_BCX    = 1001              ' bcx
    CONST ID_BCXN   = 1002              ' bcx newsgroup
    CONST ID_LCC    = 1003              ' lcc-win32
    CONST ID_MSDN   = 1004              ' msdn library
    CONST ID_Exit   = 1005              ' exit

    GLOBAL note AS NOTIFYICONDATA       ' tray icon structure
    GLOBAL MainMenu AS  HANDLE          ' holds tray menu
    GLOBAL FileMenu AS  HANDLE          ' actual tray menu
    GLOBAL hInstance AS HANDLE          ' program instance
    GLOBAL TB_CREATED                   ' taskbar created message
       
' ##########################################################################

FUNCTION WinMain(       _
    hInst AS HINSTANCE, _
    hPrev AS HINSTANCE, _
    CmdLine AS LPSTR,   _
    CmdShow AS int      _
    )

    STATIC Wc  AS WNDCLASS
    STATIC Msg AS MSG

    hInstance = hInst

    Wc.style           = CS_HREDRAW OR CS_VREDRAW OR CS_DBLCLKS
    Wc.lpfnWndProc     = WndProc1
    Wc.cbClsExtra      = 0
    Wc.cbWndExtra      = 0
    Wc.hInstance       = hInst
    Wc.hIcon           = LoadIcon  (NULL,IDI_WINLOGO)
    Wc.hCursor         = LoadCursor(NULL, IDC_ARROW)
    Wc.hbrBackground = GetSysColorBrush(COLOR_BTNFACE)
    Wc.lpszMenuName    = NULL
    Wc.lpszClassName   = ClassName1$
    RegisterClass(&Wc)

    FormLoad (hInst)

    WHILE GetMessage (&Msg, NULL, 0 ,0)
        ' ******************************************************
        ' the following allows tabbing between controls on Form1
        ' ******************************************************
        IF NOT IsWindow(Form1) OR NOT IsDialogMessage(Form1, &Msg) THEN 
            TranslateMessage (&Msg)
            DispatchMessage  (&Msg)
        END IF
    WEND
    FUNCTION = Msg.wParam
END FUNCTION

' ##########################################################################

FUNCTION WndProc1(    _
    hWnd AS HWND,     _
    Msg as UINT,      _
    wParam AS WPARAM, _
    lParam AS LPARAM  _
    ) AS LRESULT CALLBACK

    GLOBAL pt AS POINT

    SELECT CASE Msg
    ' *********************
    ' process menu commands
    ' *********************
    CASE WM_COMMAND
        IF loword(wParam) = ID_BCX THEN
            ShellExecute(0, 0,                                             _
                "http://www.users.qwest.net/~sdiggins/bcx.htm", 0, 0, 0)
        ELSE IF loword(wParam) = ID_BCXN THEN
            ShellExecute(0, 0, "http://www.egroups.com/group/bcx", 0, 0,   _
                0)
        ELSE IF loword(wParam) = ID_LCC THEN
            ShellExecute(0, 0, "http://www.cs.virginia.edu/~lcc-win32", 0, _
                0, 0)
        ELSE IF loword(wParam) = ID_MSDN THEN
            ShellExecute(0, 0,                                             _
                "http://msdn.microsoft.com/library/default.asp", 0, 0, 0)
        ELSE IF loword(wParam) = ID_Exit THEN
            DestroyWindow(hWnd)
        END IF

    ' *************************************
    ' our "come-back" from explorer message
    ' *************************************
    CASE WM_CREATE
        TB_CREATED = RegisterWindowMessage("TaskbarCreated")

    ' *********************
    ' watch for right-click
    ' *********************
    CASE WM_SHELLNOTIFY
        IF lParam = WM_RBUTTONDOWN THEN
            GetCursorPos(&pt)
            SetForegroundWindow(hWnd)
            TrackPopupMenuEx(FileMenu, TPM_LEFTALIGN or TPM_RIGHTBUTTON,   _
                pt.x, pt.y, hWnd, NULL)
            PostMessage(hWnd, WM_NULL, 0, 0)
        END IF

    ' *******************************
    ' destroy program and remove icon
    ' *******************************
    CASE WM_DESTROY
        UnregisterClass(ClassName1$, hInstance)
        Shell_NotifyIconA(NIM_DELETE, &note)
        PostQuitMessage(0)
        Exit Function

    ' ***************
    ' call wm_destroy
    ' ***************
    CASE WM_CLOSE
        DestroyWindow(hWnd)
        Exit Function

    ' *************************************
    ' re-create icon after explorer crashes
    ' *************************************
    CASE TB_CREATED
        Shell_NotifyIcon(NIM_ADD, &note)
    END SELECT

    FUNCTION = DefWindowProc(hWnd,Msg,wParam,lParam)
END FUNCTION

' ##########################################################################

SUB FormLoad (hInst as HANDLE)
    GLOBAL Form1 AS HANDLE

    ' *******************
    ' create dummy window
    ' *******************
    Form1 = CreateWindow(ClassName1$, CaptionName1$, WS_POPUP |            _
        WS_SYSMENU, 0, 0, 0, 0, NULL, NULL, hInst, NULL)

    ' **************************
    ' setup tray icon properties
    ' **************************
    note.cbSize           = sizeof(NOTIFYICONDATA)
    note.hWnd             = Form1
    note.hIcon            = LoadIcon(NULL, MAKEINTRESOURCE(IDI_QUESTION))
    note.uFlags           = NIF_ICON or NIF_TIP or NIF_MESSAGE
    note.uCallbackMessage = WM_SHELLNOTIFY
    strcpy(note.szTip, CaptionName1$)
    Shell_NotifyIcon(NIM_ADD, &note)

    ' ********************
    ' start building menus
    ' ********************
    MainMenu   =  CreateMenu()
    FileMenu   =  CreateMenu()

    ' ***************
    ' build tray menu
    ' ***************
    AppendMenu(FileMenu,MF_STRING   ,ID_BCX,  "&BCX Homepage")
    AppendMenu(FileMenu,MF_STRING   ,ID_BCXN, "BCX &Newsgroup")
    AppendMenu(FileMenu,MF_SEPARATOR,0,       "")
    AppendMenu(FileMenu,MF_STRING   ,ID_LCC,  "&LCC-Win32 Homepage")
    AppendMenu(FileMenu,MF_SEPARATOR,0,       "")
    AppendMenu(FileMenu,MF_STRING   ,ID_MSDN, "&MSDN Library")
    AppendMenu(FileMenu,MF_SEPARATOR,0,       "")
    AppendMenu(FileMenu,MF_STRING   ,ID_Exit, "E&xit")

    ' *****************************
    ' attach file menu to main menu
    ' *****************************
    InsertMenu(MainMenu, 0, MF_POPUP, FileMenu ,"invisible menu")
END SUB

' ##########################################################################
