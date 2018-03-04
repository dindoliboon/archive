' #########################################################################

    GLOBAL hwndMDIClient AS HWND
    GLOBAL hwndFrame     AS HWND
    GLOBAL hStatus       AS HWND
    GLOBAL hToolbar      AS HWND
    GLOBAL hToolbox      AS HWND
    GLOBAL hTBtoolbar    AS HWND
    GLOBAL hCodegen      AS HWND
    GLOBAL hCGEdit       AS HWND
    GLOBAL hAccel        AS HACCEL
    GLOBAL hInst         AS HINSTANCE
    GLOBAL MainMenu      AS HANDLE
    GLOBAL FileMenu      AS HANDLE
    GLOBAL CWinMenu      AS HANDLE
    GLOBAL HelpMenu      AS HANDLE

    GLOBAL lpToolboxProc AS FARPROC
    GLOBAL lpCodegenProc AS FARPROC

    GLOBAL lpEditProc    AS FARPROC
    GLOBAL lpButtonProc  AS FARPROC
    GLOBAL lpStaticProc  AS FARPROC
    GLOBAL lpScrollProc  AS FARPROC
    GLOBAL lpComboProc   AS FARPROC
    GLOBAL lpListProc    AS FARPROC

    GLOBAL iButton
    GLOBAL iCheckbox
    GLOBAL iRadio
    GLOBAL iStatic
    GLOBAL iScrollBar
    GLOBAL iEdit
    GLOBAL iListBox
    GLOBAL iComboBox
    GLOBAL iControl

    CONST  szFrame$      =  "bide_frame"
    CONST  szChild$      =  "bide_child"

    CONST  IDM_NEW       =  1001
    CONST  IDM_HTOOL     =  1002
    CONST  IDM_HSTATUS   =  1003
    CONST  IDM_HTOOLBOX  =  1004
    CONST  IDM_EXIT      =  1005
    CONST  IDM_CGEN      =  1006

    CONST  IDM_CASCADE   =  2001
    CONST  IDM_TILEH     =  2002
    CONST  IDM_TILEV     =  2003
    CONST  IDM_ARRANGE   =  2004
    CONST  IDM_RESTORE   =  2005
    CONST  IDM_MINWIN    =  2006
    CONST  IDM_CLOSE     =  2007

    CONST  IDM_ABOUT     =  3001

    CONST  IDW_FIRST     =  4000

    CONST  IDC_SEL       =  5001
    CONST  IDC_EDT       =  5002
    CONST  IDC_GRP       =  5003
    CONST  IDC_BTN       =  5004
    CONST  IDC_CHK       =  5005
    CONST  IDC_RAD       =  5006
    CONST  IDC_CMB       =  5007
    CONST  IDC_LST       =  5008
    CONST  IDC_HSL       =  5009
    CONST  IDC_VSL       =  5010
    CONST  IDC_FRM       =  5011
    CONST  IDC_ICO       =  5012
    CONST  IDC_STC       =  5013
    CONST  IDC_RUN       =  5014

    TYPE CONTROLS
        hwnd AS HANDLE         ' save handles and sizes of controls
        rect AS RECT           ' for further processing ...
    END TYPE

    GLOBAL hctl     AS CONTROLS
    GLOBAL fDrawing
    GLOBAL cType

' #########################################################################

FUNCTION WinMain(               _
    hInstance     AS HINSTANCE, _
    hPrevInstance AS HINSTANCE, _
    lpCmdLine     AS LPSTR,     _
    nCmdShow      AS int        _
    ) AS int

    STATIC msg  AS MSG

    ' handle parent registration error
    IF NOT InitializeApplication() THEN
    FUNCTION = FALSE
    END IF

    hwndFrame = CreateWindowEx(WS_EX_LEFT, szFrame$,                      _
        "Bide - Form Designer", WS_OVERLAPPEDWINDOW, CW_USEDEFAULT,       _
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

    STATIC cc      AS CLIENTCREATESTRUCT
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
                CheckMenuItem(FileMenu, IDM_HTOOL, MF_BYCOMMAND |         _
                    MF_CHECKED)
                SendMessage(hwndFrame, WM_SIZE, 0, 0)
            ELSE
                ShowWindow(hToolbar, SW_SHOW)
                CheckMenuItem(FileMenu, IDM_HTOOL, MF_BYCOMMAND |         _
                    MF_UNCHECKED)
                SendMessage(hwndFrame, WM_SIZE, 0, 0)
            END IF

        CASE IDM_HSTATUS
            IF IsWindowVisible(hStatus) THEN
                ShowWindow(hStatus, SW_HIDE)
                CheckMenuItem(FileMenu, IDM_HSTATUS, MF_BYCOMMAND |       _
                    MF_CHECKED)
                SendMessage(hwndFrame, WM_SIZE, 0, 0)
            ELSE
                ShowWindow(hStatus, SW_SHOW)
                CheckMenuItem(FileMenu, IDM_HSTATUS, MF_BYCOMMAND |       _
                    MF_UNCHECKED)
                SendMessage(hwndFrame, WM_SIZE, 0, 0)
            END IF

        CASE IDM_HTOOLBOX
            IF IsWindowVisible(hToolbox) THEN
                ShowWindow(hToolbox, SW_HIDE)
                CheckMenuItem(FileMenu, IDM_HTOOLBOX, MF_BYCOMMAND |      _
                    MF_CHECKED)
            ELSE
                ShowWindow(hToolbox, SW_SHOW)
                CheckMenuItem(FileMenu, IDM_HTOOLBOX, MF_BYCOMMAND |      _
                    MF_UNCHECKED)
            END IF

        CASE IDM_EXIT
            SendMessage(hwndFrame, WM_SYSCOMMAND, SC_CLOSE, NULL)

        CASE IDM_CGEN
            IF NOT hCodegen THEN
                ' create code generator window
                CreateChild("Code Generator")
                hCodegen = FindWindowEx(hwndMDIClient, NULL, NULL,        _
                    "Code Generator")
                SetWindowLong(hCodegen, GWL_EXSTYLE, WS_EX_PALETTEWINDOW)
                GetClientRect(hCodegen, &rc)
                MoveWindow(hCodegen, rc.left, rc.top, rc.right - rc.left, _
                    rc.bottom - rc.top, TRUE)
                lpCodegenProc = SetWindowLong(hCodegen, GWL_WNDPROC,      _
                    CodegenProc)

                hCGEdit = CreateWindowEx(WS_EX_STATICEDGE, "edit", "",    _
                    WS_CHILD | WS_VISIBLE | WS_TABSTOP | WS_VSCROLL |     _
                    WS_HSCROLL | ES_AUTOHSCROLL | ES_AUTOVSCROLL |        _
                    ES_MULTILINE | ES_WANTRETURN | ES_READONLY, 0, 0, 0,  _
                    0, hCodegen, NULL, hInst, NULL)

                SendMessage(hCGEdit, WM_SETFONT,                          _
                    GetStockObject(DEFAULT_GUI_FONT), MAKELPARAM(FALSE,0))

                SendMessage(hCodegen, WM_SIZE, 0, 0)
            ELSE
                ShowWindow(hCodegen, SW_SHOWNORMAL)
            END IF

            SendMessage(hCGEdit, WM_SETTEXT, 0, (LPARAM) "")

            ' get parent's info first
            CreateCodeProc(hwndMDIClient, (LPARAM) -12345)

            ' get all child controls next
            EnumChildWindows(hwndMDIClient, CreateCodeProc, 0)

        CASE IDM_CASCADE
            SendMessage(hwndMDIClient, WM_MDICASCADE, 0, 0)

        CASE IDM_TILEH
            SendMessage(hwndMDIClient, WM_MDITILE,                        _
                MDITILE_HORIZONTAL, 0)

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
            CreateChild("Created by dl")
        END SELECT

    CASE WM_CREATE
        hToolbar = MakeToolbar(hWnd, hInst)
        hStatus = CreateStatusWindow(WS_VISIBLE | WS_CHILD |              _
            SBS_SIZEGRIP, (LPCTSTR) NULL, hWnd, 0)

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
            NULL, WS_CHILD | WS_CLIPCHILDREN | WS_VISIBLE |               _
            WS_VSCROLL | WS_HSCROLL, 0, 0, 0, 0, hWnd, NULL, hInst,       _
            &cc)

        ToolbarAddButton(hToolbar, IDM_NEW,  "New Dialog",                _
            TBSTYLE_BUTTON | TBSTYLE_AUTOSIZE)
        ToolbarAddButton(hToolbar, IDM_CGEN, "Code Generator",            _
            TBSTYLE_BUTTON | TBSTYLE_AUTOSIZE)
        ToolbarAddButton(hToolbar, 0, "", TBSTYLE_SEP)
        ToolbarAddButton(hToolbar, IDM_EXIT, "Exit", TBSTYLE_BUTTON |     _
            TBSTYLE_AUTOSIZE)

        ' create toolbox child window
        CreateChild("Toolbox")

        hToolbox = FindWindowEx(hwndMDIClient, NULL, NULL, "Toolbox")
        SetWindowLong(hToolbox, GWL_EXSTYLE, WS_EX_PALETTEWINDOW)
        MoveWindow(hToolbox, 0, 0, 130, 140, TRUE)

        hTBtoolbar = MakeToolbar(hToolbox, hInst)
        ToolbarAddButton(hTBtoolbar, IDC_RUN, "Runtime",                  _
            TBSTYLE_CHECKGROUP | TBSTYLE_AUTOSIZE)
        ToolbarAddButton(hTBtoolbar, IDC_SEL, "Select",                   _
            TBSTYLE_CHECKGROUP | TBSTYLE_AUTOSIZE)
        ToolbarAddButton(hTBtoolbar, IDC_EDT, "Edit",                     _
            TBSTYLE_CHECKGROUP | TBSTYLE_AUTOSIZE)
        ToolbarAddButton(hTBtoolbar, IDC_GRP, "Group",                    _
            TBSTYLE_CHECKGROUP | TBSTYLE_AUTOSIZE)
        ToolbarAddButton(hTBtoolbar, IDC_BTN, "Button",                   _
            TBSTYLE_CHECKGROUP | TBSTYLE_AUTOSIZE)
        ToolbarAddButton(hTBtoolbar, IDC_CHK, "Check",                    _
            TBSTYLE_CHECKGROUP | TBSTYLE_AUTOSIZE)
        ToolbarAddButton(hTBtoolbar, IDC_RAD, "Radio",                    _
            TBSTYLE_CHECKGROUP | TBSTYLE_AUTOSIZE)
        ToolbarAddButton(hTBtoolbar, IDC_CMB, "Combo",                    _
            TBSTYLE_CHECKGROUP | TBSTYLE_AUTOSIZE)
        ToolbarAddButton(hTBtoolbar, IDC_LST, "List",                     _
            TBSTYLE_CHECKGROUP | TBSTYLE_AUTOSIZE)
        ToolbarAddButton(hTBtoolbar, IDC_HSL, "HScroll",                  _
            TBSTYLE_CHECKGROUP | TBSTYLE_AUTOSIZE)
        ToolbarAddButton(hTBtoolbar, IDC_VSL, "VScroll",                  _
            TBSTYLE_CHECKGROUP | TBSTYLE_AUTOSIZE)
        ToolbarAddButton(hTBtoolbar, IDC_FRM, "Frame",                    _
            TBSTYLE_CHECKGROUP | TBSTYLE_AUTOSIZE)
        ToolbarAddButton(hTBtoolbar, IDC_ICO, "Icon",                     _
            TBSTYLE_CHECKGROUP | TBSTYLE_AUTOSIZE)
        ToolbarAddButton(hTBtoolbar, IDC_STC, "Static",                   _
            TBSTYLE_CHECKGROUP | TBSTYLE_AUTOSIZE)

        lpToolboxProc = SetWindowLong(hToolbox, GWL_WNDPROC, ToolboxProc)
        SendMessage(hToolbox, WM_SIZE, 0, 0)

    CASE WM_SIZE
        SendMessage(hToolbar, TB_AUTOSIZE, 0, 0)
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

    STATIC x
    STATIC y
    STATIC fDrag
    STATIC xStart
    STATIC yStart
    STATIC pt     AS POINT
    STATIC hdc    AS HDC

    SELECT CASE uMsg
    CASE WM_LBUTTONDOWN
        ' protect our custom windows
        IF hWnd = hToolbox or hWnd = hCodegen or cType = -1 THEN
            FUNCTION = 0
        END IF

        pt.x = LOWORD(lParam)
        pt.y = HIWORD(lParam)

        SetCapture(hWnd)
        xStart   = LOWORD(lParam)
        yStart   = HIWORD(lParam)
        fDrawing = TRUE
        FUNCTION = 0

    CASE WM_MOUSEMOVE
        x = LOWORD(lParam)              ' current X position
        y = HIWORD(lParam)              ' current Y position

        IF fDrawing THEN
            x = LOWORD(lParam)            ' current X position
            y = HIWORD(lParam)            ' current Y position
            hdc = GetDC(hWnd)
            SetROP2(hdc, R2_NOTXORPEN)
            DrawFocusRect(hdc, &hctl.rect)

            IF xStart > x THEN
                hctl.rect.left  = x
                hctl.rect.right = xStart
            ELSE                       ' going right
                hctl.rect.left  = xStart
                hctl.rect.right = x
            END IF

            IF yStart < y THEN
                hctl.rect.bottom = y
                hctl.rect.top    = yStart
            ELSE                                  ' going right
                hctl.rect.bottom = yStart
                hctl.rect.top    = y
            END IF

            DrawFocusRect(hdc, &hctl.rect)
            ReleaseDC(hWnd, hdc)
        END IF
        FUNCTION = 0

    CASE WM_LBUTTONUP
        x = LOWORD(lParam)              ' current X position
        y = HIWORD(lParam)              ' current Y position

        IF fDrag THEN
            fDrag = FALSE
            ReleaseCapture
            EXIT SELECT
        END IF

        IF fDrawing THEN
            ReleaseCapture()

            IF xStart > x THEN
                hctl.rect.left  = x
                hctl.rect.right = xStart
            ELSE    ' going right
                hctl.rect.left  = xStart
                hctl.rect.right = x
            END IF

            IF yStart < y THEN
                hctl.rect.bottom = y
                hctl.rect.top    = yStart
            ELSE    ' going right
                hctl.rect.bottom = yStart
                hctl.rect.top    = y
            END IF

            CreateControlEx(hWnd)

            hctl.rect.left = 0
            hctl.rect.top = 0
            hctl.rect.right = 0
            hctl.rect.bottom = 0
            DrawFocusRect(hdc, &hctl.rect)

            InvalidateRect(hWnd,0,TRUE)
            UpdateWindow(hWnd)
            ReleaseCapture()

            fDrawing = FALSE
        END IF
        FUNCTION = 0
    END SELECT

    FUNCTION = DefMDIChildProc(hWnd, uMsg, wParam, lParam)
END FUNCTION

' #########################################################################
'   abstract:   registers parent  window class
'   usage   :   InitializeApplication()
' #########################################################################

FUNCTION InitializeApplication() AS BOOL
    STATIC wc AS WNDCLASSEX

    ' register the frame window class
    wc.cbSize        = sizeof(WNDCLASSEX)
    wc.style         = CS_HREDRAW | CS_VREDRAW | CS_BYTEALIGNWINDOW
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
'   abstract:   registers child window class
'   usage   :   RegisterChild()
' #########################################################################

FUNCTION RegisterChild() AS BOOL
    STATIC wc AS WNDCLASSEX

    ' register the MDI child window class
    wc.cbSize        = sizeof(WNDCLASSEX)
    wc.style         = CS_HREDRAW | CS_VREDRAW | CS_BYTEALIGNWINDOW
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
'   abstract:   creates tooltip for any control
'   usage   :   MakeTooltip(hControl, "Tip Information", hInstance)
' #########################################################################

FUNCTION MakeTooltip(      _
    hwndOwner AS HWND,     _
    lpszText  AS LPSTR,    _
    hInst     AS HINSTANCE _
    ) AS BOOL

    STATIC hwndTT AS HWND
    STATIC ti     AS TOOLINFO
    STATIC uid    AS WPARAM
    STATIC rect   AS RECT

    ' initialize common controls
    IF NOT LoadCCLibrary(ICC_BAR_CLASSES) THEN
        FUNCTION = FALSE
    END IF

    ' create a tooltip window
    hwndTT = CreateWindowEx(WS_EX_TOPMOST, TOOLTIPS_CLASS, NULL,          _
        WS_POPUP | TTS_NOPREFIX | TTS_ALWAYSTIP, CW_USEDEFAULT,           _
        CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, hwndOwner, NULL,     _
        hInst, NULL)
    IF NOT hwndTT THEN
        FUNCTION = FALSE
    END IF

    SetWindowPos(hwndTT, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE |           _
    SWP_NOSIZE | SWP_NOACTIVATE)

    ' get coordinates of the main client area
    GetClientRect (hwndOwner, &rect)

    ' initialize members of the toolinfo structure
    ti.cbSize      = sizeof(TOOLINFO)
    ti.uFlags      = TTF_SUBCLASS
    ti.hwnd        = hwndOwner
    ti.hinst       = hInst
    ti.uId         = uid
    ti.lpszText    = lpszText

    ' tooltip control will cover the whole window
    ti.rect.left   = rect.left
    ti.rect.top    = rect.top
    ti.rect.right  = rect.right
    ti.rect.bottom = rect.bottom

    ' send an addtool message to the tooltip control window
    FUNCTION = SendMessage(hwndTT, TTM_ADDTOOL, 0, (LPARAM) (LPTOOLINFO)  _
        &ti)
END FUNCTION

' #########################################################################
'   abstract:   initializes windows common control library
'   usage   :   LoadCCLibrary(common_control_classes)
' #########################################################################

FUNCTION LoadCCLibrary(dwICC AS DWORD) AS BOOL
    STATIC iccex AS INITCOMMONCONTROLSEX

    iccex.dwICC  = dwICC
    iccex.dwSize = sizeof(INITCOMMONCONTROLSEX)

    IF NOT InitCommonControlsEx(&iccex) THEN
        FUNCTION = FALSE
    END IF

    FUNCTION = TRUE
END FUNCTION

' #########################################################################
'   abstract:   creates rebar frame
'   usage   :   MakeRebar(hParent, hInstance)
' #########################################################################

FUNCTION MakeRebar(    _
    hwndOwner AS HWND, _
    hInst AS HINSTANCE _
    ) AS HWND

    STATIC hwndRB AS HWND
    STATIC rbi    AS REBARINFO

    ' initialize common controls
    IF NOT LoadCCLibrary(ICC_BAR_CLASSES) THEN
        FUNCTION = FALSE
    END IF

    hwndRB = CreateWindowEx(WS_EX_TOOLWINDOW, REBARCLASSNAME, NULL,       _
        WS_BORDER | WS_CHILD | WS_VISIBLE | WS_CLIPCHILDREN |             _
        WS_CLIPSIBLINGS | RBS_VARHEIGHT | RBS_AUTOSIZE |                  _
        RBS_BANDBORDERS | CCS_ADJUSTABLE | CCS_TOP | CCS_NODIVIDER, 0, 0, _
        0, 0, hwndOwner, NULL, hInst, NULL)

    IF NOT hwndRB THEN
        FUNCTION = NULL
    END IF

    ' initialize and send the rebarinfo structure
    rbi.cbSize = sizeof(REBARINFO)
    rbi.fMask  = 0
    rbi.himl   = (HIMAGELIST) NULL
    SendMessage(hwndRB, RB_SETBARINFO, 0, (LPARAM) &rbi)

    FUNCTION = hwndRB
END FUNCTION

' #########################################################################
'   abstract:   adds a band to a rebar
'   usage   :   RebarAddBand(hParent, hControl, "Title of Band")
' #########################################################################

FUNCTION RebarAddBand(  _
    hwndOwner AS HWND,  _
    hwndChild AS HWND,  _
    lpTitle   AS LPSTR, _
    ) AS BOOL

    STATIC rbBand AS REBARBANDINFO

    ' initialize structure members that both bands will share
    rbBand.cbSize  = sizeof(REBARBANDINFO)
    rbBand.fMask   = RBBIM_TEXT | RBBIM_STYLE | RBBIM_CHILD |             _
                     RBBIM_CHILDSIZE | RBBIM_SIZE
    rbBand.fStyle  = RBBS_CHILDEDGE | RBBS_GRIPPERALWAYS

    ' set values unique to the band
    rbBand.lpText     = lpTitle
    rbBand.cch        = 2
    rbBand.hwndChild  = hwndChild
    rbBand.cxMinChild = 0
    rbBand.cyMinChild = 0
    rbBand.cx         = 200

    ' add the band to rebar
    FUNCTION = SendMessage(hwndOwner, RB_INSERTBAND, (WPARAM) -1,         _
        (LPARAM) &rbBand)
END FUNCTION

' #########################################################################
'   abstract:   creates toolbar
'   usage   :   MakeToolbar(hParent, hInstance)
' #########################################################################

FUNCTION MakeToolbar(      _
    hwndOwner AS HWND,     _
    hInst     AS HINSTANCE _
    ) AS HWND

    STATIC hwndTB  AS HWND

    hwndTB = CreateWindow(TOOLBARCLASSNAME, NULL, WS_CHILD | CCS_TOP |    _
        TBSTYLE_LIST | CCS_ADJUSTABLE | TBSTYLE_WRAPABLE | TBSTYLE_FLAT | _
        WS_VISIBLE, 0, 0, 0, 0, hwndOwner, NULL, hInst, NULL)

    IF NOT hwndTB THEN
        FUNCTION = NULL
    END IF

    FUNCTION = hwndTB
END FUNCTION

' #########################################################################
'   abstract:   adds buttons to toolbar
'   usage   :   ToolbarAddButton(hParent, idCommand, hInstance)
' #########################################################################

SUB ToolbarAddButton(      _
    hwndOwner AS HWND,     _
    idCommand AS INTEGER,  _
    lpTitle   AS LPSTR,    _
    dwStyle   AS BYTE      _
    )

    STATIC tbb      AS TBBUTTON

    ' send the TB_BUTTONSTRUCTSIZE message, which is required for
    ' backward compatibility
    SendMessage(hwndOwner, TB_BUTTONSTRUCTSIZE, sizeof(TBBUTTON), 0)

    ' fill the TBBUTTON array with button information, and add the
    ' buttons to the toolbar
    tbb.idCommand = idCommand
    tbb.fsState   = TBSTATE_ENABLED
    tbb.fsStyle   = dwStyle
    tbb.dwData    = 0
    tbb.iString   = SendMessage(hwndOwner, TB_ADDSTRING, 0, (LPARAM)      _
                    lpTitle)
    tbb.iBitmap   = -2

    SendMessage(hwndOwner, TB_SETBUTTONSIZE, 0, MAKELONG(16, 16))
    SendMessage(hwndOwner, TB_ADDBUTTONS, 1, (LPTBBUTTON) &tbb)
END SUB

' #########################################################################
'   abstract:   repositions any window to the center of the screen
'   usage   :   CenterWindow(hParent)
' #########################################################################

SUB CenterWindow(hWnd AS HWND)
    STATIC wRect AS RECT
    STATIC x     AS DWORD
    STATIC y     AS DWORD

    GetWindowRect(hWnd, &wRect)
    x = (GetSystemMetrics(SM_CXSCREEN) - (wRect.right - wRect.left)) / 2
    y = (GetSystemMetrics(SM_CYSCREEN) - (wRect.bottom - wRect.top +      _
        GetSystemMetrics(SM_CYCAPTION))) / 2
    SetWindowPos(hWnd, NULL, x, y, 0, 0, SWP_NOSIZE | SWP_NOZORDER)
END SUB

' #########################################################################
'   abstract:   creates default menu for mdi parent
'   usage   :   ApplyMenu(hParent)
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
    AppendMenu(FileMenu, MF_STRING,    IDM_HTOOLBOX,"&Hide Toolbox")
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
'   abstract:   creates child window
'   usage   :   CreateChild("Title of Window")
' #########################################################################

FUNCTION CreateChild(lpWindowName$) AS HWND
    FUNCTION = CreateWindowEx(WS_EX_MDICHILD, szChild$, lpWindowName$,    _
        WS_VISIBLE | MDIS_ALLCHILDSTYLES, CW_USEDEFAULT, CW_USEDEFAULT,   _
        CW_USEDEFAULT, CW_USEDEFAULT, hwndMDIClient, NULL, hInst, NULL)
END FUNCTION

' #########################################################################
'   abstract:   controls what can be done with child mdi windows
'   usage   :   EnumChildProc(hWindow, lParam)
' #########################################################################

FUNCTION EnumChildProc( _
    hwnd AS HWND,       _
    lParam AS LPARAM    _
    ) AS BOOL CALLBACK

    ' protect our custom parent and children windows
    IF hwnd = hToolbox or GetParent(hwnd) = hToolbox or                   _
    hwnd = hCodegen or GetParent(hwnd) = hCodegen THEN
        FUNCTION = TRUE
    END IF

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
'   abstract:   handles code generator messages
'   usage   :   CodegenProc(hWindow, wMsg, wParam, lParam)
' #########################################################################

CALLBACK FUNCTION CodegenProc()
    STATIC rc AS RECT

    SELECT CASE Msg
    CASE WM_SIZE
        GetClientRect(hWnd, &rc)
        MoveWindow(hCGEdit, 0, 0, rc.right - rc.left, rc.bottom - rc.top, _
            TRUE)
        FUNCTION = 0
    CASE WM_CLOSE
        ShowWindow(hCodegen, SW_HIDE)
        FUNCTION = 0
    END SELECT

    FUNCTION = CallWindowProc(lpCodegenProc, hWnd, Msg, wParam, lParam)
END FUNCTION

' #########################################################################
'   abstract:   handles toolbox messages
'   usage   :   ToolboxProc(hWindow, wMsg, wParam, lParam)
' #########################################################################

CALLBACK FUNCTION ToolboxProc()
    SELECT CASE Msg
    CASE WM_COMMAND
        SELECT CASE wParam
        CASE IDC_RUN : cType = -1
        CASE IDC_SEL : cType = 0
        CASE IDC_EDT : cType = 1
        CASE IDC_GRP : cType = 2
        CASE IDC_BTN : cType = 3
        CASE IDC_CHK : cType = 4
        CASE IDC_RAD : cType = 5
        CASE IDC_CMB : cType = 6
        CASE IDC_LST : cType = 7
        CASE IDC_HSL : cType = 8
        CASE IDC_VSL : cType = 9
        CASE IDC_FRM : cType = 10
        CASE IDC_ICO : cType = 11
        CASE IDC_STC : cType = 12
        END SELECT
        FUNCTION = 0

    CASE WM_CLOSE
        ShowWindow(hToolbox, SW_HIDE)
        CheckMenuItem(FileMenu, IDM_HTOOLBOX, MF_BYCOMMAND | MF_CHECKED)
        FUNCTION = 0

    CASE WM_SIZE
        SendMessage(hTBtoolbar, TB_AUTOSIZE, 0, 0)
        FUNCTION = 0
    END SELECT

    FUNCTION = CallWindowProc(lpToolboxProc, hWnd, Msg, wParam, lParam)
END FUNCTION

' #########################################################################
'   abstract:   creates a control at run-time
'   usage   :   CreateControlEx(hParent)
' #########################################################################

SUB CreateControlEx(     _
    hwndOwner AS HWND    _
    )

    STATIC hCtl   AS HWND
    STATIC xStyle AS DWORD
    STATIC cStyle AS DWORD
    STATIC cClass AS LPSTR
    STATIC cText  AS LPSTR

    SELECT CASE cType
        CASE -1
            ' do nothing
        CASE 0
            ' do nothing
        CASE 1
            xStyle = WS_EX_STATICEDGE
            cStyle = WS_VSCROLL | WS_HSCROLL | ES_AUTOHSCROLL |           _
                     ES_AUTOVSCROLL | ES_MULTILINE | ES_WANTRETURN
            cClass = "edit"
            cText  = "Edit"
        CASE 2
            xStyle = 0
            cStyle = BS_GROUPBOX
            cClass = "button"
            cText  = "Group"
        CASE 3
            xStyle = 0
            cStyle = BS_PUSHBUTTON
            cClass = "button"
            cText  = "Button"
        CASE 4
            xStyle = WS_EX_STATICEDGE
            cStyle = BS_AUTOCHECKBOX
            cClass = "button"
            cText  = "Check"
        CASE 5
            xStyle = WS_EX_STATICEDGE
            cStyle = BS_AUTORADIOBUTTON
            cClass = "button"
            cText  = "Radio"
        CASE 6
            xStyle = 0
            cStyle = WS_VSCROLL | CBS_DROPDOWN | CBS_SORT
            cClass = "combobox"
            cText  = "Combo"
        CASE 7
            xStyle = WS_EX_STATICEDGE
            cStyle = WS_VSCROLL | LBS_SORT | LBS_STANDARD
            cClass = "listbox"
            cText  = "List"
        CASE 8
            xStyle = 0
            cStyle = SBS_HORZ
            cClass = "scrollbar"
            cText  = "HScroll"
        CASE 9
            xStyle = 0
            cStyle = SBS_VERT
            cClass = "scrollbar"
            cText  = "VScroll"
        CASE 10
            xStyle = WS_EX_STATICEDGE
            cStyle = SS_BLACKFRAME | SS_NOTIFY
            cClass = "static"
            cText  = "Frame"
        CASE 11
            xStyle = WS_EX_STATICEDGE
            cStyle = SS_BITMAP | SS_NOTIFY
            cClass = "static"
            cText  = "Picture"
        CASE 12
            xStyle = WS_EX_STATICEDGE
            cStyle = SS_NOTIFY
            cClass = "static"
            cText  = "Label"
    END SELECT

    IF cType > 0 THEN
        hCtl = CreateWindowEx(xStyle, cClass, cText, WS_CHILD |           _
            WS_VISIBLE | WS_TABSTOP | cStyle, hctl.rect.left,             _
            hctl.rect.top, hctl.rect.right - hctl.rect.left,              _
            hctl.rect.bottom - hctl.rect.top, hwndOwner, NULL, hInst, NULL)

        SendMessage(hCtl, WM_SETFONT, GetStockObject(DEFAULT_GUI_FONT),   _
            MAKELPARAM(FALSE,0))

        SELECT CASE cClass
        CASE "edit"
            lpEditProc   = SetWindowLong(hCtl, GWL_WNDPROC, EditProc)
        CASE "button"
            lpButtonProc = SetWindowLong(hCtl, GWL_WNDPROC, ButtonProc)
        CASE "static"
            lpStaticProc = SetWindowLong(hCtl, GWL_WNDPROC, StaticProc)
        CASE "scrollbar"
            lpScrollProc = SetWindowLong(hCtl, GWL_WNDPROC, ScrollProc)
        CASE "combobox"
            SendMessage(hCtl, CB_ADDSTRING, 0, (LPARAM) "for")
            SendMessage(hCtl, CB_ADDSTRING, 0, (LPARAM) "your")
            SendMessage(hCtl, CB_ADDSTRING, 0, (LPARAM) "enjoyment")
            SendMessage(hCtl, CB_ADDSTRING, 0, (LPARAM) "I")
            SendMessage(hCtl, CB_ADDSTRING, 0, (LPARAM) "added")
            SendMessage(hCtl, CB_ADDSTRING, 0, (LPARAM) "some")
            SendMessage(hCtl, CB_ADDSTRING, 0, (LPARAM) "combobox")
            SendMessage(hCtl, CB_ADDSTRING, 0, (LPARAM) "strings")
            lpComboProc  = SetWindowLong(hCtl, GWL_WNDPROC, ComboProc)
        CASE "listbox"
            SendMessage(hCtl, LB_ADDSTRING, 0, (LPARAM) "for")
            SendMessage(hCtl, LB_ADDSTRING, 0, (LPARAM) "your")
            SendMessage(hCtl, LB_ADDSTRING, 0, (LPARAM) "enjoyment")
            SendMessage(hCtl, LB_ADDSTRING, 0, (LPARAM) "I")
            SendMessage(hCtl, LB_ADDSTRING, 0, (LPARAM) "added")
            SendMessage(hCtl, LB_ADDSTRING, 0, (LPARAM) "some")
            SendMessage(hCtl, LB_ADDSTRING, 0, (LPARAM) "listbox")
            SendMessage(hCtl, LB_ADDSTRING, 0, (LPARAM) "strings")
            lpListProc   = SetWindowLong(hCtl, GWL_WNDPROC, ListProc)
        END SELECT
    END IF
END SUB

' #########################################################################
'   abstract:   detects location of mouse in object
'   usage   :   HitTest(hControl, lParam)
' #########################################################################

FUNCTION HitTest(    _
    hCtl AS HWND,    _
    lParam AS LPARAM _
    )

    STATIC pt AS POINT
    STATIC rc AS RECT

    pt.x = LOWORD(lParam)
    pt.y = HIWORD(lParam)

    ScreenToClient (hCtl, &pt)
    GetWindowRect  (hCtl, &rc)

    MapWindowPoints(HWND_DESKTOP, GetParent(hCtl), (LPPOINT) &rc, 2)

    IF pt.y < 4 AND pt.x < 4 THEN
        FUNCTION = HTTOPLEFT
    ELSEIF pt.y < 4 AND pt.x >= (rc.right - rc.left - 4) THEN
        FUNCTION = HTTOPRIGHT
    ELSEIF pt.y >= (rc.bottom - rc.top - 4) AND pt.x >=                   _
        (rc.right - rc.left - 4) THEN
        FUNCTION = HTBOTTOMRIGHT
    ELSEIF pt.x < 4 AND pt.y >= (rc.bottom - rc.top - 4) THEN
        FUNCTION = HTBOTTOMLEFT
    ELSEIF pt.y < 4 THEN
        FUNCTION = HTTOP
    ELSEIF pt.x < 4 THEN
        FUNCTION = HTLEFT
    ELSEIF pt.x >= (rc.right - rc.left - 4) THEN
        FUNCTION = HTRIGHT
    ELSEIF pt.y >= (rc.bottom - rc.top - 4) THEN
        FUNCTION = HTBOTTOM
    ELSE
        FUNCTION = HTCLIENT
    END IF
END FUNCTION

' #########################################################################
'   abstract:   handles run-time controls
'   usage   :   EditProc(hControl, wMsg, wParam, lParam)
' #########################################################################

FUNCTION EditProc( _
    hCtl AS HWND,     _
    uMsg AS UINT,     _
    wParam AS WPARAM, _
    lParam AS LPARAM  _
    ) AS LRESULT CALLBACK

    SELECT CASE uMsg
    CASE WM_LBUTTONDOWN
        IF cType <> -1 THEN
            ReleaseCapture()
            SendMessage(hCtl, WM_NCLBUTTONDOWN, HTCAPTION, 0)
            FUNCTION = 0
        END IF
    CASE WM_LBUTTONUP
        IF cType <> -1 THEN
            ReleaseCapture()
            FUNCTION = 0
        END IF
    CASE WM_LBUTTONDBLCLK
        MessageBox(hCtl, "WM_LBUTTONDBLCLK", "edit", MB_OK)
        FUNCTION = 0
    CASE WM_RBUTTONDOWN
        IF cType <> -1 THEN
            DestroyWindow(hCtl)
            BringWindowToTop(hCtl)
            FUNCTION = 0
        END IF
    CASE WM_NCHITTEST
        IF cType <> -1 THEN
            FUNCTION = HitTest(hCtl,lParam)
        END IF
    CASE WM_SIZING   '* Gridize while sizing
        IF cType <> -1 THEN
            FUNCTION = 0
        END IF
    CASE WM_MOVING   '* Gridize while moving
        IF cType <> -1 THEN
            FUNCTION = 0
        END IF
    END SELECT

    FUNCTION = CallWindowProc(lpEditProc, hCtl, uMsg, wParam, lParam)
END FUNCTION

' #########################################################################
'   abstract:   handles run-time controls
'   usage   :   ButtonProc(hControl, wMsg, wParam, lParam)
' #########################################################################

FUNCTION ButtonProc( _
    hCtl AS HWND,     _
    uMsg AS UINT,     _
    wParam AS WPARAM, _
    lParam AS LPARAM  _
    ) AS LRESULT CALLBACK

    SELECT CASE uMsg
    CASE WM_LBUTTONDOWN
        IF cType <> -1 THEN
            ReleaseCapture()
            SendMessage(hCtl, WM_NCLBUTTONDOWN, HTCAPTION, 0)
            FUNCTION = 0
        END IF
    CASE WM_LBUTTONUP
        IF cType <> -1 THEN
            ReleaseCapture()
            FUNCTION = 0
        END IF
    CASE WM_LBUTTONDBLCLK
        MessageBox(hCtl, "WM_LBUTTONDBLCLK", "button", MB_OK)
        FUNCTION = 0
    CASE WM_RBUTTONDOWN
        IF cType <> -1 THEN
            DestroyWindow(hCtl)
            BringWindowToTop(hCtl)
            FUNCTION = 0
        END IF
    CASE WM_NCHITTEST
        IF cType <> -1 THEN
            FUNCTION = HitTest(hCtl,lParam)
        END IF
    CASE WM_SIZING   '* Gridize while sizing
        IF cType <> -1 THEN
            FUNCTION = 0
        END IF
    CASE WM_MOVING   '* Gridize while moving
        IF cType <> -1 THEN
            FUNCTION = 0
        END IF
    END SELECT

    FUNCTION = CallWindowProc(lpButtonProc, hCtl, uMsg, wParam, lParam)
END FUNCTION

' #########################################################################
'   abstract:   handles run-time controls
'   usage   :   StaticProc(hControl, wMsg, wParam, lParam)
' #########################################################################

FUNCTION StaticProc( _
    hCtl AS HWND,     _
    uMsg AS UINT,     _
    wParam AS WPARAM, _
    lParam AS LPARAM  _
    ) AS LRESULT CALLBACK

    SELECT CASE uMsg
    CASE WM_LBUTTONDOWN
        IF cType <> -1 THEN
            ReleaseCapture()
            SendMessage(hCtl, WM_NCLBUTTONDOWN, HTCAPTION, 0)
            FUNCTION = 0
        END IF
    CASE WM_LBUTTONUP
        IF cType <> -1 THEN
            ReleaseCapture()
            FUNCTION = 0
        END IF
    CASE WM_LBUTTONDBLCLK
        MessageBox(hCtl, "WM_LBUTTONDBLCLK", "static", MB_OK)
        FUNCTION = 0
    CASE WM_RBUTTONDOWN
        IF cType <> -1 THEN
            DestroyWindow(hCtl)
            BringWindowToTop(hCtl)
            FUNCTION = 0
        END IF
    CASE WM_NCHITTEST
        IF cType <> -1 THEN
            FUNCTION = HitTest(hCtl,lParam)
        END IF
    CASE WM_SIZING   '* Gridize while sizing
        IF cType <> -1 THEN
            FUNCTION = 0
        END IF
    CASE WM_MOVING   '* Gridize while moving
        IF cType <> -1 THEN
            FUNCTION = 0
        END IF
    END SELECT

    FUNCTION = CallWindowProc(lpStaticProc, hCtl, uMsg, wParam, lParam)
END FUNCTION

' #########################################################################
'   abstract:   handles run-time controls
'   usage   :   ComboProc(hControl, wMsg, wParam, lParam)
' #########################################################################

FUNCTION ComboProc( _
    hCtl AS HWND,     _
    uMsg AS UINT,     _
    wParam AS WPARAM, _
    lParam AS LPARAM  _
    ) AS LRESULT CALLBACK

    SELECT CASE uMsg
    CASE WM_LBUTTONDOWN
        IF cType <> -1 THEN
            ReleaseCapture()
            SendMessage(hCtl, WM_NCLBUTTONDOWN, HTCAPTION, 0)
            FUNCTION = 0
        END IF
    CASE WM_LBUTTONUP
        IF cType <> -1 THEN
            ReleaseCapture()
            FUNCTION = 0
        END IF
    CASE WM_LBUTTONDBLCLK
        MessageBox(hCtl, "WM_LBUTTONDBLCLK", "combobox", MB_OK)
        FUNCTION = 0
    CASE WM_RBUTTONDOWN
        IF cType <> -1 THEN
            DestroyWindow(hCtl)
            BringWindowToTop(hCtl)
            FUNCTION = 0
        END IF
    CASE WM_NCHITTEST
        IF cType <> -1 THEN
            FUNCTION = HitTest(hCtl,lParam)
        END IF
    CASE WM_SIZING   '* Gridize while sizing
        IF cType <> -1 THEN
            FUNCTION = 0
        END IF
    CASE WM_MOVING   '* Gridize while moving
        IF cType <> -1 THEN
            FUNCTION = 0
        END IF
    END SELECT

    FUNCTION = CallWindowProc(lpComboProc, hCtl, uMsg, wParam, lParam)
END FUNCTION

' #########################################################################
'   abstract:   handles run-time controls
'   usage   :   ListProc(hControl, wMsg, wParam, lParam)
' #########################################################################

FUNCTION ListProc( _
    hCtl AS HWND,     _
    uMsg AS UINT,     _
    wParam AS WPARAM, _
    lParam AS LPARAM  _
    ) AS LRESULT CALLBACK

    SELECT CASE uMsg
    CASE WM_LBUTTONDOWN
        IF cType <> -1 THEN
            ReleaseCapture()
            SendMessage(hCtl, WM_NCLBUTTONDOWN, HTCAPTION, 0)
            FUNCTION = 0
        END IF
    CASE WM_LBUTTONUP
        IF cType <> -1 THEN
            ReleaseCapture()
            FUNCTION = 0
        END IF
    CASE WM_LBUTTONDBLCLK
        MessageBox(hCtl, "WM_LBUTTONDBLCLK", "listbox", MB_OK)
        FUNCTION = 0
    CASE WM_RBUTTONDOWN
        IF cType <> -1 THEN
            DestroyWindow(hCtl)
            BringWindowToTop(hCtl)
            FUNCTION = 0
        END IF
    CASE WM_NCHITTEST
        IF cType <> -1 THEN
            FUNCTION = HitTest(hCtl,lParam)
        END IF
    CASE WM_SIZING   '* Gridize while sizing
        IF cType <> -1 THEN
            FUNCTION = 0
        END IF
    CASE WM_MOVING   '* Gridize while moving
        IF cType <> -1 THEN
            FUNCTION = 0
        END IF
    END SELECT

    FUNCTION = CallWindowProc(lpListProc, hCtl, uMsg, wParam, lParam)
END FUNCTION

' #########################################################################
'   abstract:   handles run-time controls
'   usage   :   ScrollProc(hControl, wMsg, wParam, lParam)
' #########################################################################

FUNCTION ScrollProc( _
    hCtl AS HWND,     _
    uMsg AS UINT,     _
    wParam AS WPARAM, _
    lParam AS LPARAM  _
    ) AS LRESULT CALLBACK

    SELECT CASE uMsg
    CASE WM_LBUTTONDOWN
        IF cType <> -1 THEN
            ReleaseCapture()
            SendMessage(hCtl, WM_NCLBUTTONDOWN, HTCAPTION, 0)
            FUNCTION = 0
        END IF
    CASE WM_LBUTTONUP
        IF cType <> -1 THEN
            ReleaseCapture()
            FUNCTION = 0
        END IF
    CASE WM_LBUTTONDBLCLK
        MessageBox(hCtl, "WM_LBUTTONDBLCLK", "listbox", MB_OK)
        FUNCTION = 0
    CASE WM_RBUTTONDOWN
        IF cType <> -1 THEN
            DestroyWindow(hCtl)
            BringWindowToTop(hCtl)
            FUNCTION = 0
        END IF
    CASE WM_NCHITTEST
        IF cType <> -1 THEN
            FUNCTION = HitTest(hCtl,lParam)
        END IF
    CASE WM_SIZING   '* Gridize while sizing
        IF cType <> -1 THEN
            FUNCTION = 0
        END IF
    CASE WM_MOVING   '* Gridize while moving
        IF cType <> -1 THEN
            FUNCTION = 0
        END IF
    END SELECT

    FUNCTION = CallWindowProc(lpScrollProc, hCtl, uMsg, wParam, lParam)
END FUNCTION

' #########################################################################

FUNCTION CreateCodeProc( _
    hwnd AS HWND,        _
    lParam AS LPARAM     _
    ) AS BOOL CALLBACK

    STATIC dwExStyle$
    STATIC lpClassName$
    STATIC lpWindowName$
    STATIC dwStyle$
    STATIC x$
    STATIC y$
    STATIC nWidth$
    STATIC nHeight$
    STATIC hMenu$
    STATIC lpKeyName$
    STATIC lpTemp$
    STATIC lpBuffer$ * 35840
    STATIC rc AS RECT
    STATIC a  AS LONG

    ' protect our custom parent and children windows
    IF hwnd = hToolbox or GetParent(hwnd) = hToolbox or                   _
    hwnd = hCodegen or GetParent(hwnd) = hCodegen THEN
        FUNCTION = TRUE
    END IF

    ' extended window style
    a = GetWindowLong(hwnd, GWL_EXSTYLE)
    dwExStyle$ = TRIM$(STR$(a))

    ' registered class name
    GetClassName(hwnd, lpClassName$, 2048)

    ' window name
    GetWindowText(hwnd, lpWindowName$, 2048)

    ' window style
    a = GetWindowLong(hwnd, GWL_STYLE)
    dwStyle$ = TRIM$(STR$(a))

    ' horizontal position of window
    GetWindowRect(hwnd, &rc)        ' get control
    a = rc.left
    GetWindowRect(GetParent(hwnd), &rc)    ' get parent
    x$ = TRIM$(STR$((a-rc.left)-2))

    ' vertical position of window
    GetWindowRect(hwnd, &rc)        ' get control
    a = rc.top
    GetWindowRect(GetParent(hwnd), &rc)    ' get parent
    y$ = TRIM$(STR$((a-rc.top)-20))

    ' window width
    GetWindowRect(hwnd, &rc)
    a = (rc.right-rc.left)
    nWidth$ = TRIM$(STR$(a))

    ' window height
    GetWindowRect(hwnd, &rc)
    a = (rc.bottom-rc.top)
    nHeight$ = TRIM$(STR$(a))

    a = GetWindowLong(hwnd, GWL_ID)
    hMenu$ = TRIM$(STR$(a))

    SELECT CASE(LCASE$(lpClassName$))
    CASE "button"
        INCR iButton
        lpKeyName$ = "Button" & TRIM$(STR$(iButton))
    CASE "checkbox"
        INCR iCheckbox
        lpKeyName$ = "Checkbox" & TRIM$(STR$(iCheckbox))
    CASE "radio"
        INCR iRadio
        lpKeyName$ = "Radio" & TRIM$(STR$(iRadio))
    CASE "static"
        INCR iStatic
        lpKeyName$ = "Static" & TRIM$(STR$(iStatic))
    CASE "scrollbar"
        INCR iScrollBar
        lpKeyName$ = "ScrollBar" & TRIM$(STR$(iScrollBar))
    CASE "edit"
        INCR iEdit
        lpKeyName$ = "Edit" & TRIM$(STR$(iEdit))
    CASE "listbox"
        INCR iListBox
        lpKeyName$ = "ListBox" & TRIM$(STR$(iListBox))
    CASE "combobox"
        INCR iComboBox
        lpKeyName$ = "ComboBox" & TRIM$(STR$(iComboBox))
    ELSE
        ' don't get mdi parent
        IF lParam = -12345 THEN
            FUNCTION = TRUE
        ELSE
            INCR iControl
            lpKeyName$ = "Form" & TRIM$(STR$(iControl))
        END IF
    END SELECT

    lpTemp$ = "GLOBAL  \Name AS HANDLE/CONST   ID_\Name =  \ID//\Name = CreateWindowEx(\ExStyles, `\Class`, `\Caption`, _/\Styles, \x, \y, \w, \h, _/Form1, ID_\Name, hInst, NULL)//SendMessage(\Name, WM_SETFONT, _/GetStockObject(DEFAULT_GUI_FONT), MAKELPARAM(FALSE, 0))/"
    lpTemp$ = REPLACE$(lpTemp$, "\Name", lpKeyName$)
    lpTemp$ = REPLACE$(lpTemp$, "\ID", hMenu$)
    lpTemp$ = REPLACE$(lpTemp$, "\ExStyles", dwExStyle$)
    lpTemp$ = REPLACE$(lpTemp$, "\Class", lpClassName$)
    lpTemp$ = REPLACE$(lpTemp$, "\Caption", lpWindowName$)
    lpTemp$ = REPLACE$(lpTemp$, "\Styles", dwStyle$)
    lpTemp$ = REPLACE$(lpTemp$, "\x", x$)
    lpTemp$ = REPLACE$(lpTemp$, "\y", y$)
    lpTemp$ = REPLACE$(lpTemp$, "\w", nWidth$)
    lpTemp$ = REPLACE$(lpTemp$, "\h", nHeight$)

    lpTemp$ = REPLACE$(lpTemp$, "/", JOIN$(2, CHR$(13), CHR$(10)))

    ' replace with " doesn't work for some reason
    'lpTemp$ = REPLACE$(lpTemp$, "`", CHR$(34))

    lpBuffer$ = ""
    SendMessage(hCGEdit, WM_GETTEXT, 35840, (LPARAM) lpBuffer$)
    lstrcat(lpBuffer$, lpTemp$)
    SendMessage(hCGEdit, WM_SETTEXT, 0, (LPARAM) lpBuffer$)

    FUNCTION = TRUE
END FUNCTION

' #########################################################################
