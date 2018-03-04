' #########################################################################

    GLOBAL hwndMDIClient AS HWND
    GLOBAL hwndFrame     AS HWND
    GLOBAL hStatus       AS HWND
    GLOBAL hToolbar      AS HWND
    GLOBAL hAccel        AS HACCEL
    GLOBAL hInst         AS HINSTANCE
    GLOBAL MainMenu      AS HANDLE
    GLOBAL FileMenu      AS HANDLE
    GLOBAL CWinMenu      AS HANDLE
    GLOBAL HelpMenu      AS HANDLE

    CONST  szFrame$      =  "mdi_frame"
    CONST  szChild$      =  "mdi_child"

    CONST  IDM_NEW       =  1001
    CONST  IDM_HTOOL     =  1002
    CONST  IDM_HSTATUS   =  1003
    CONST  IDM_EXIT      =  1004

    CONST  IDM_CASCADE   =  2001
    CONST  IDM_TILEH     =  2002
    CONST  IDM_TILEV     =  2003
    CONST  IDM_ARRANGE   =  2004
    CONST  IDM_RESTORE   =  2005
    CONST  IDM_MINWIN    =  2006
    CONST  IDM_CLOSE     =  2007

    CONST  IDM_ABOUT     =  3001

    CONST  IDW_FIRST     =  4000

' #########################################################################

FUNCTION WinMain(               _
    hInstance     AS HINSTANCE, _
    hPrevInstance AS HINSTANCE, _
    lpCmdLine     AS LPSTR,     _
    nCmdShow      AS int        _
    ) AS int

    STATIC icex AS INITCOMMONCONTROLSEX
    STATIC msg  AS MSG

    ' initialize common controls
    icex.dwSize = sizeof(INITCOMMONCONTROLSEX)
    icex.dwICC  = ICC_COOL_CLASSES | ICC_BAR_CLASSES
    InitCommonControlsEx(&icex)

    ' handle parent registration error
    IF NOT InitializeApplication() THEN
        FUNCTION = FALSE
    END IF

    hwndFrame = CreateWindowEx(WS_EX_LEFT, szFrame$,                      _
        "MDI - Rebar Version", WS_OVERLAPPEDWINDOW, CW_USEDEFAULT,        _
        CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, FileMenu, NULL,      _
        hInst, NULL)

    CenterWindow(hwndFrame)
    ShowWindow(hwndFrame, SW_SHOWNORMAL)
    UpdateWindow(hwndFrame)

    WHILE GetMessage(&msg, (HWND) NULL, 0, 0)
        IF (NOT TranslateMDISysAccel(hwndMDIClient, &msg)) and            _
        (NOT TranslateAccelerator(hwndFrame, hAccel, &msg)) THEN
            TranslateMessage(&msg)
            DispatchMessage(&msg)
        END IF
    WEND

    FUNCTION = msg.wParam
END FUNCTION

' #########################################################################
'
'   this is *very* important!
'   must have LRESULT CALLBACK or
'   will crash under Windows 98 SE
'
' #########################################################################

FUNCTION MPFrameWndProc(     _
    hWnd          AS HWND,   _
    uMsg          AS UINT,   _
    wParam        AS WPARAM, _
    lParam        AS LPARAM  _
    ) AS LRESULT CALLBACK

    STATIC ps      AS PAINTSTRUCT
    STATIC cc      AS CLIENTCREATESTRUCT
    STATIC hDC     AS HDC
    STATIC rc      AS RECT
    STATIC tHeight
    STATIC sHeight

    SELECT CASE uMsg
    CASE WM_COMMAND
        SELECT CASE wParam
        CASE IDM_NEW
            CreateChild("Untitled")
        CASE IDM_HTOOL
            IF IsWindowVisible(hToolbar) THEN
                ShowWindow(hToolbar, SW_HIDE)
                CheckMenuItem(FileMenu, IDM_HTOOL, MF_BYCOMMAND or        _
                    MF_CHECKED)
                SendMessage(hwndFrame, WM_SIZE, 0, 0)
            ELSE
                ShowWindow(hToolbar, SW_SHOW)
                CheckMenuItem(FileMenu, IDM_HTOOL, MF_BYCOMMAND or        _
                    MF_UNCHECKED)
                SendMessage(hwndFrame, WM_SIZE, 0, 0)
            END IF
        CASE IDM_HSTATUS
            IF IsWindowVisible(hStatus) THEN
                ShowWindow(hStatus, SW_HIDE)
                CheckMenuItem(FileMenu, IDM_HSTATUS, MF_BYCOMMAND or      _
                    MF_CHECKED)
                SendMessage(hwndFrame, WM_SIZE, 0, 0)
            ELSE
                ShowWindow(hStatus, SW_SHOW)
                CheckMenuItem(FileMenu, IDM_HSTATUS, MF_BYCOMMAND or      _
                    MF_UNCHECKED)
                SendMessage(hwndFrame, WM_SIZE, 0, 0)
            END IF
        CASE IDM_EXIT
            SendMessage(hwndFrame, WM_SYSCOMMAND, SC_CLOSE, NULL)
        CASE IDM_CASCADE
            SendMessage(hwndMDIClient, WM_MDICASCADE, 0, 0)
        CASE IDM_TILEH
            SendMessage(hwndMDIClient, WM_MDITILE, MDITILE_HORIZONTAL, 0)
        CASE IDM_TILEV
            SendMessage(hwndMDIClient, WM_MDITILE, MDITILE_VERTICAL, 0)
        CASE IDM_ARRANGE
            SendMessage(hwndMDIClient, WM_MDIICONARRANGE, 0, 0)
        CASE IDM_RESTORE
            EnumChildWindows(hwndMDIClient, EnumChildProc, 0)
        CASE IDM_MINWIN
            EnumChildWindows(hwndMDIClient, EnumChildProc, 1)
        CASE IDM_CLOSE
            EnumChildWindows(hwndMDIClient, EnumChildProc, 2)
        CASE IDM_ABOUT
            CreateChild("Created by Hutch, converted by dl")
        END SELECT

    CASE WM_CREATE
        hStatus = CreateStatusWindow(WS_VISIBLE | WS_CHILD |              _
            SBS_SIZEGRIP, (LPCTSTR) NULL, hWnd, 0)
        hToolbar = CreateRebar(hWnd)

        ' handle child registration error
        IF NOT RegisterChild() THEN
            FUNCTION = FALSE
        END IF

        ' handle menu registration error
        IF NOT ApplyMenu(hWnd) THEN
            FUNCTION = FALSE
        END IF

        cc.hWindowMenu  = GetSubMenu(MainMenu, 1)
        cc.idFirstChild = IDW_FIRST
        hwndMDIClient = CreateWindowEx(WS_EX_CLIENTEDGE, "MDICLIENT",     _
            NULL, WS_CHILD | WS_CLIPCHILDREN | WS_VISIBLE | WS_VSCROLL |  _
            WS_HSCROLL, 0, 0, 0, 0, hWnd, NULL, hInst, &cc)

    CASE WM_SIZE
        GetWindowRect(hToolbar, &rc)
        MoveWindow(hToolbar, 0, 0, 0, rc.bottom - rc.top, TRUE)
        MoveWindow(hStatus, 0, 0, 0, 0, TRUE)

        IF IsWindowVisible(hToolbar) THEN
            GetWindowRect(hToolbar, &rc)
            rc.bottom = rc.bottom - rc.top
            tHeight = rc.bottom
        ELSE
            tHeight = 0
        END IF

        IF IsWindowVisible(hStatus) THEN
            GetWindowRect(hStatus, &rc)
            rc.bottom = rc.bottom - rc.top
            sHeight = rc.bottom
        ELSE
            sHeight = 0
        END IF

        GetClientRect(hWnd, &rc)
        sHeight = (rc.bottom - tHeight) - sHeight

        MoveWindow(hwndMDIClient, 0, tHeight, rc.right, sHeight, TRUE)
        FUNCTION = 0

    CASE WM_PAINT
        hDC = BeginPaint(hWnd, &ps)
        Paint_Proc(hWnd, hDC)
        EndPaint(hWnd, &ps)
        FUNCTION = 0

    CASE WM_DESTROY
        PostQuitMessage((int) NULL)
        FUNCTION = 0
    END SELECT

    FUNCTION = DefFrameProc(hWnd, hwndMDIClient, uMsg, wParam, lParam)
END FUNCTION

' #########################################################################
'
'   this is *very* important!
'   must have LRESULT CALLBACK or
'   will crash under Windows 98 SE
'
' #########################################################################

FUNCTION MPMDIChildWndProc( _
    hWnd   AS HWND,         _
    uMsg   AS UINT,         _
    wParam AS WPARAM,       _
    lParam AS LPARAM        _
    ) AS LRESULT CALLBACK

    SELECT CASE uMsg
    CASE WM_CREATE
    CASE WM_KEYUP
        IF wParam = VK_F6 THEN
            SendMessage(hwndMDIClient, WM_MDINEXT, NULL, 0)
        END IF
    END SELECT

    FUNCTION = DefMDIChildProc(hWnd, uMsg, wParam, lParam)
END FUNCTION

' #########################################################################

FUNCTION Paint_Proc( _
    hWnd AS HWND,    _
    hDC as HDC       _
    ) AS BOOL

    FUNCTION = 0
END FUNCTION

' #########################################################################

FUNCTION InitializeApplication() AS BOOL
    STATIC wc AS WNDCLASSEX

    ' register the frame window class
    wc.cbSize        = sizeof(WNDCLASSEX)
    wc.style         = CS_HREDRAW or CS_VREDRAW or CS_BYTEALIGNWINDOW
    wc.lpfnWndProc   = MPFrameWndProc
    wc.cbClsExtra    = (int) NULL
    wc.cbWndExtra    = (int) NULL
    wc.hInstance     = hInst
    wc.hbrBackground = (HBRUSH) NULL    ' fixes flicker
    wc.lpszMenuName  = NULL
    wc.lpszClassName = szFrame$
    wc.hIcon         = LoadIcon(NULL, IDI_APPLICATION)
    wc.hCursor       = LoadCursor(NULL, IDC_ARROW)
    wc.hIconSm       = LoadIcon(NULL, IDI_APPLICATION)
    IF NOT RegisterClassEx(&wc) THEN
        FUNCTION = FALSE
    END IF

    FUNCTION = TRUE
END FUNCTION

' #########################################################################

FUNCTION RegisterChild() AS BOOL
    STATIC wc AS WNDCLASSEX

    ' register the MDI child window class
    wc.cbSize        = sizeof(WNDCLASSEX)
    wc.style         = CS_HREDRAW or CS_VREDRAW or CS_BYTEALIGNWINDOW
    wc.lpfnWndProc   = MPMDIChildWndProc
    wc.cbClsExtra    = (int) NULL
    wc.cbWndExtra    = (int) NULL
    wc.hInstance     = hInst
    wc.hbrBackground = (HBRUSH) (COLOR_BTNFACE + 1)
    wc.lpszMenuName  = NULL
    wc.lpszClassName = szChild$
    wc.hIcon         = LoadIcon(NULL, IDI_WINLOGO)
    wc.hCursor       = LoadCursor(NULL, IDC_ARROW)
    wc.hIconSm       = LoadIcon(NULL, IDI_WINLOGO)
    IF NOT RegisterClassEx(&wc) THEN
        FUNCTION = FALSE
    END IF

    FUNCTION = TRUE
END FUNCTION

' #########################################################################

FUNCTION CreateRebar(hwndOwner AS HWND) AS HWND
    STATIC rbi    AS REBARINFO
    STATIC rbBand AS REBARBANDINFO
    STATIC hwndRB AS HWND
    STATIC hwndTB AS HWND
    '| CCS_NODIVIDER 
    hwndRB = CreateWindowEx(WS_EX_TOOLWINDOW, REBARCLASSNAME, NULL,       _
        WS_BORDER | WS_CHILD | WS_VISIBLE | WS_CLIPCHILDREN |             _
        WS_CLIPSIBLINGS | RBS_VARHEIGHT | RBS_AUTOSIZE | RBS_BANDBORDERS  _
        | CCS_ADJUSTABLE | CCS_TOP, 0, 0, 0, 0, hwndOwner, NULL, hInst,   _
        NULL)

    ' initialize and send the REBARINFO structure
    rbi.cbSize = sizeof(REBARINFO)
    rbi.fMask  = 0
    rbi.himl   = (HIMAGELIST) NULL
    SendMessage(hwndRB, RB_SETBARINFO, 0, (LPARAM) &rbi)

    ' initialize structure members that both bands will share
    rbBand.cbSize  = sizeof(REBARBANDINFO)    ' Required
    rbBand.fMask   = RBBIM_STYLE | RBBIM_CHILD | RBBIM_CHILDSIZE |        _
        RBBIM_SIZE
    rbBand.fStyle  = RBBS_CHILDEDGE OR RBBS_GRIPPERALWAYS

    hwndTB = CreateToolbar(hwndOwner)
    rbBand.hwndChild  = (HWND) hwndTB
    rbBand.cyChild    = 20
    rbBand.cyMaxChild = 20
    rbBand.cxMinChild = 20
    rbBand.cyMinChild = 20
    rbBand.cx         = 500

    SendMessage(hwndRB, RB_INSERTBAND, (WPARAM) -1, (LPARAM) &rbBand)

    FUNCTION = hwndRB
END FUNCTION

' #########################################################################

FUNCTION CreateToolbar(hwndOwner AS HWND) AS HWND
    STATIC hwndTB  AS HWND
    STATIC tbb[2]  AS TBBUTTON
    STATIC iString

    hwndTB = CreateWindow(TOOLBARCLASSNAME, NULL, WS_CHILD | TBSTYLE_LIST _
        | CCS_ADJUSTABLE | TBSTYLE_ALTDRAG | TBSTYLE_WRAPABLE |           _
        TBSTYLE_FLAT | CCS_TOP | CCS_NOPARENTALIGN | CCS_NODIVIDER |      _
        WS_CLIPSIBLINGS | WS_CLIPCHILDREN, 0, 0, 0, 15, hwndOwner, NULL,  _
        hInst, NULL)

    ' send the TB_BUTTONSTRUCTSIZE message, which is required for
    ' backward compatibility
    SendMessage(hwndTB, TB_BUTTONSTRUCTSIZE, sizeof(TBBUTTON), 0)

    ' fill the TBBUTTON array with button information, and add the
    ' buttons to the toolbar
    iString = SendMessage(hwndTB, TB_ADDSTRING, 0, (LPARAM) "New Dialog")
    tbb[0].idCommand = IDM_NEW
    tbb[0].fsState = TBSTATE_ENABLED
    tbb[0].fsStyle = TBSTYLE_BUTTON | TBSTYLE_AUTOSIZE
    tbb[0].dwData  = 0
    tbb[0].iString = iString
    tbb[0].iBitmap = -2

    iString = SendMessage(hwndTB, TB_ADDSTRING, 0, (LPARAM) "Exit")
    tbb[1].idCommand = IDM_EXIT
    tbb[1].fsState = TBSTATE_ENABLED
    tbb[1].fsStyle = TBSTYLE_BUTTON | TBSTYLE_AUTOSIZE
    tbb[1].dwData  = 0
    tbb[1].iString = iString
    tbb[1].iBitmap = -2

    SendMessage(hwndTB, TB_SETBUTTONSIZE, 0, MAKELONG(16, 16))
    SendMessage(hwndTB, TB_ADDBUTTONS, 2, (LPTBBUTTON) &tbb)
    SendMessage(hwndTB, TB_AUTOSIZE, 0, 0)
    ShowWindow(hwndTB, SW_SHOWNORMAL)

    FUNCTION = hwndTB
END FUNCTION

' #########################################################################

SUB CenterWindow (hWnd AS HWND)
    STATIC wRect AS RECT
    STATIC x     AS DWORD
    STATIC y     AS DWORD

    GetWindowRect(hWnd, &wRect)
    x = (GetSystemMetrics(SM_CXSCREEN) - (wRect.right - wRect.left)) / 2
    y = (GetSystemMetrics(SM_CYSCREEN) - (wRect.bottom - wRect.top +      _
        GetSystemMetrics(SM_CYCAPTION))) / 2
    SetWindowPos(hWnd, NULL, x, y, 0, 0, SWP_NOSIZE OR SWP_NOZORDER)
END SUB

' #########################################################################

FUNCTION ApplyMenu(hwndOwner AS HWND) AS BOOL
    ' create menu handles
    MainMenu = CreateMenu()
    FileMenu = CreateMenu()
    CWinMenu = CreateMenu()
    HelpMenu = CreateMenu()

    ' create file menu
    AppendMenu(FileMenu, MF_STRING,    IDM_NEW,     "&New Dialog")
    AppendMenu(FileMenu, MF_SEPARATOR, 0, "")
    AppendMenu(FileMenu, MF_STRING,    IDM_HTOOL,   "&Hide Toolbar")
    AppendMenu(FileMenu, MF_STRING,    IDM_HSTATUS, "&Hide Statusbar")
    AppendMenu(FileMenu, MF_SEPARATOR, 0, "")
    AppendMenu(FileMenu, MF_STRING,    IDM_EXIT,    "E&xit")

    ' create window menu
    AppendMenu(CWinMenu, MF_STRING,    IDM_CASCADE, "&Cascade")
    AppendMenu(CWinMenu, MF_STRING,    IDM_TILEH,   "Tile &Horizontally")
    AppendMenu(CWinMenu, MF_STRING,    IDM_TILEV,   "&Tile Vertically")
    AppendMenu(CWinMenu, MF_STRING,    IDM_ARRANGE, "&Arrange Icons")
    AppendMenu(CWinMenu, MF_SEPARATOR, 0, "")
    AppendMenu(CWinMenu, MF_STRING,    IDM_RESTORE, "&Restore All")
    AppendMenu(CWinMenu, MF_STRING,    IDM_MINWIN,  "&Minimize All")
    AppendMenu(CWinMenu, MF_STRING,    IDM_CLOSE,   "C&lose All")

    ' create help window
    AppendMenu(HelpMenu, MF_STRING,    IDM_ABOUT,   "&About")

    ' attach menus to menubar
    InsertMenu(MainMenu, 0, MF_POPUP, FileMenu, "&File")
    InsertMenu(MainMenu, 1, MF_POPUP, CWinMenu, "&Window")
    InsertMenu(MainMenu, 2, MF_POPUP, HelpMenu, "&Help")

    ' activate menu
    IF NOT SetMenu(hwndOwner, MainMenu) THEN
        FUNCTION = FALSE
    END IF

    FUNCTION = TRUE
END FUNCTION

' #########################################################################

FUNCTION CreateChild(lpWindowName$) AS HWND
    FUNCTION = CreateWindowEx(WS_EX_MDICHILD, szChild$, lpWindowName$,    _
        WS_VISIBLE | MDIS_ALLCHILDSTYLES, CW_USEDEFAULT, CW_USEDEFAULT,   _
        CW_USEDEFAULT, CW_USEDEFAULT, hwndMDIClient, NULL, hInst, NULL)
END FUNCTION

' #########################################################################

FUNCTION EnumChildProc( _
    hwnd AS HWND,       _
    lParam AS LPARAM    _
    ) AS BOOL CALLBACK

    SELECT CASE lParam
    CASE 0
        ShowWindow(hwnd, SW_RESTORE)
    CASE 1
        ShowWindow(hwnd, SW_MINIMIZE)
    CASE 2
        SendMessage(hwndMDIClient, WM_MDIDESTROY, hwnd, 0)
    END SELECT

    FUNCTION = TRUE
END FUNCTION

' #########################################################################
