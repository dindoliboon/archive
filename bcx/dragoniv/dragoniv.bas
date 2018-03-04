                                                                    $COMMENT
****************************************************************************
   NAME: DL
   DATE: August 02, 2001
PROJECT: Dragon Image Viewer 1.0
PURPOSE: Views (BMP, GIF, JPG, WMF, EMF, and ICO) files by using the OLE
         features built-in Windows. Dragon stands for "Drag On", because
         you have to drag a image file ONTO the application window.

         Features include drag n' drop, always on top, full screen, accept
         file from command line, and the ability to move the image around
         the client area.

         KEYS & MOUSE COMMANDS
         Double left-click - Moves image to position (0, 0)
         Left mouse-down   - Allows you to drag image around client area
         Right-click       - Enables or disables ontop status
         Enter Key         - Switches between full-screen and window mode

         CODE BASED ON
         OLE Image Viewer, A BCX GUI Sample by Kevin Diggins
COMPILE: build.bat
****************************************************************************
                                                                    $COMMENT

    #include <ocidl.h>

    ! STDAPI  OleLoadPicture(LPSTREAM, LONG, BOOL, REFIID, LPVOID *);

    CONST szOnTop$       = " - *"
    CONST ClassName1$    = "dragon_class"
    CONST ClassName2$    = "image_class"
    CONST CaptionName1$  = "Dragon Image Viewer"
    CONST HIMETRIC_INCH  = 2540

    GLOBAL Form1     AS HWND
    GLOBAL Canvas1   AS HWND
    GLOBAL gpPicture AS LPPICTURE
    GLOBAL szChosen$
    GLOBAL hmWidth
    GLOBAL hmHeight
    GLOBAL nWidth
    GLOBAL nHeight
    GLOBAL bOnTop
    GLOBAL bFullScreen


' --------------------------------------------------------------------------
' PURPOSE: Initial entry point
' INPUT  : hInst as HINSTANCE, hPrev as HINSTANCE, CmdLine as LPSTR,
'          CmdShow as INTEGER
' OUTPUT : none
' --------------------------------------------------------------------------
FUNCTION WinMain()
    LOCAL Wc  AS WNDCLASS
    LOCAL Msg AS MSG

    ' store command-line arguments
    IF CmdLine$ = "" THEN
        szChosen$ = "dragoniv.gif"
    ELSE
        szChosen$ = CmdLine$
    END IF

    ' makes sure gpPicture is empty
    gpPicture = NULL

    ' register Form1
    Wc.style         = CS_HREDRAW OR CS_VREDRAW OR CS_DBLCLKS
    Wc.lpfnWndProc   = WndProc1
    Wc.cbClsExtra    = 0
    Wc.cbWndExtra    = 0
    Wc.hInstance     = hInst
    Wc.hIcon         = LoadIcon(hInst, MAKEINTRESOURCE(100))
    Wc.hCursor       = LoadCursor(NULL, IDC_ARROW)
    Wc.hbrBackground = CreateSolidBrush(RGB(0, 0, 0))
    Wc.lpszMenuName  = NULL
    Wc.lpszClassName = ClassName1$
    RegisterClass(&Wc)

    ' register Canvas1
    Wc.style         = CS_HREDRAW OR CS_VREDRAW OR CS_DBLCLKS
    Wc.lpfnWndProc   = WndProc2
    Wc.cbClsExtra    = 0
    Wc.cbWndExtra    = 0
    Wc.hInstance     = hInst
    Wc.hIcon         = NULL
    Wc.hCursor       = LoadCursor(NULL, IDC_SIZEALL)
    Wc.hbrBackground = CreateSolidBrush(RGB(0, 0, 0))
    Wc.lpszMenuName  = NULL
    Wc.lpszClassName = ClassName2$
    RegisterClass(&Wc)

    FormLoad(hInst)

' *******************[ This Message Pump Allows Tabbing ]*******************

    WHILE GetMessage(&Msg, NULL, 0, 0)
        IF NOT IsWindow(GetActiveWindow()) OR NOT _
            IsDialogMessage(GetActiveWindow(), &Msg) THEN
            TranslateMessage(&Msg)
            DispatchMessage(&Msg)
        END IF
    WEND

' **************************************************************************

    FUNCTION = Msg.wParam
END FUNCTION


' --------------------------------------------------------------------------
' PURPOSE: Processes messages sent to the main window
' INPUT  : hWnd as HWND, Msg as UINT, wParam as WPARAM, lParam as LPARAM
' OUTPUT : Depends on the message sent
' --------------------------------------------------------------------------
CALLBACK FUNCTION WndProc1
    STATIC ps  AS PAINTSTRUCT
    STATIC hdc AS HDC
    STATIC lrc AS RECT
    DIM    rc  AS RECT

    SELECT CASE Msg
' **************************************************************************
    CASE WM_PAINT
' **************************************************************************
        hdc = BeginPaint(Canvas1, &ps)

        IF gpPicture THEN
            GetClientRect(Canvas1, &rc)
            gpPicture->lpVtbl->Render(gpPicture, hdc, 0, 0, nWidth, _
                                      nHeight, 0, hmHeight, hmWidth, _
                                      - hmHeight, &rc)
        END IF

        EndPaint(Canvas1, &ps)

' **************************************************************************
    CASE WM_KEYUP
' **************************************************************************
        SELECT CASE wParam
        CASE VK_RETURN
            IF bFullScreen = FALSE THEN
                GetWindowRect(hWnd, &lrc)

                ' remove any borders
                SetWindowLong(hWnd, GWL_STYLE, WS_POPUP OR WS_VISIBLE OR _
                              WS_SYSMENU OR WS_CLIPCHILDREN)

                ' resize to the width & height of the screen
                SetWindowPos(hWnd, HWND_TOPMOST, 0, 0, _
                             GetSystemMetrics(SM_CXSCREEN), _
                             GetSystemMetrics(SM_CYSCREEN), _
                             SWP_SHOWWINDOW)

                ' center picture and enable full screen flag
                CenterWindow(Canvas1)
                bFullScreen = TRUE
            ELSE
                ' restore borders
                SetWindowLong(hWnd, GWL_STYLE, DS_MODALFRAME OR _
                              WS_MINIMIZEBOX OR WS_MAXIMIZEBOX OR _
                              WS_POPUP OR WS_CAPTION OR WS_SYSMENU OR _
                              WS_THICKFRAME OR WS_CLIPCHILDREN OR _
                              WS_VISIBLE)

                ' if window was not on top, restore it
                IF bOnTop = FALSE THEN
                    bOnTop = TRUE
                    SendMessage(hWnd, WM_RBUTTONDOWN, 0, 0)
                END IF

                ' restore original position
                SetWindowPos(hWnd, 0, lrc.left, lrc.top, _
                             lrc.right - lrc.left, _
                             lrc.bottom - lrc.top, _
                             SWP_NOZORDER)

                ' move image to location (0, 0)
                SendMessage(hWnd, WM_LBUTTONDBLCLK, 0, 0)
                bFullScreen = FALSE
            END IF
        END SELECT

' **************************************************************************
    CASE WM_DROPFILES
' **************************************************************************
        DragQueryFile((HDROP)wParam, 0, szChosen$, 2047)
        LoadPictureFile(szChosen$, Canvas1)

' **************************************************************************
    CASE WM_LBUTTONDOWN
' **************************************************************************
        ReleaseCapture()
        SendMessage(Canvas1, WM_SYSCOMMAND, SC_MOVE OR HTCAPTION, 0)

' **************************************************************************
    CASE WM_LBUTTONDBLCLK
' **************************************************************************
        SetWindowPos(Canvas1, 0, 0, 0, 0, 0, SWP_NOSIZE OR SWP_NOZORDER)

' **************************************************************************
    CASE WM_RBUTTONDOWN
' **************************************************************************
        IF bOnTop = TRUE THEN
            ' set original caption name
            SetWindowText(hWnd, CaptionName1$)

            ' remove topmost status without moving or resizing
            SetWindowPos (hWnd, HWND_NOTOPMOST, 0, 0, 0, 0, _
                          SWP_NOSIZE OR SWP_NOMOVE OR SWP_NOACTIVATE)
            bOnTop = FALSE
        ELSE
            ' add astrisk to show that the window is on top
            SetWindowText(hWnd, Combine$(CaptionName1$, szOnTop$))

            ' set the window on top without moving or resizing
            SetWindowPos (hWnd, HWND_TOPMOST, 0, 0, 0, 0, _
                          SWP_NOSIZE OR SWP_NOMOVE OR SWP_NOACTIVATE)
            bOnTop = TRUE
        END IF

' **************************************************************************
    CASE WM_CLOSE
' **************************************************************************
        DestroyWindow(hWnd)

' **************************************************************************
    CASE WM_DESTROY
' **************************************************************************
        PostQuitMessage(0)
    END SELECT

    FUNCTION = DefWindowProc(hWnd, Msg, wParam, lParam)
END FUNCTION


' --------------------------------------------------------------------------
' PURPOSE: Processes messages sent to the canvas window
' INPUT  : hWnd as HWND, Msg as UINT, wParam as WPARAM, lParam as LPARAM
' OUTPUT : Depends on the message sent
' --------------------------------------------------------------------------
CALLBACK FUNCTION WndProc2()
    SELECT CASE Msg
' **************************************************************************
    CASE WM_LBUTTONDOWN
' **************************************************************************
        SendMessage(Form1, WM_LBUTTONDOWN, 0, 0)

' **************************************************************************
    CASE WM_LBUTTONDBLCLK
' **************************************************************************
        SendMessage(Form1, WM_LBUTTONDBLCLK, 0, 0)

' **************************************************************************
    CASE WM_RBUTTONDOWN
' **************************************************************************
        SendMessage(Form1, WM_RBUTTONDOWN, 0, 0)
    END SELECT

    FUNCTION = DefWindowProc(hWnd, Msg, wParam, lParam)
END FUNCTION


' --------------------------------------------------------------------------
' PURPOSE: Moves window to center of the screen
' INPUT  : hWnd AS HWND
' OUTPUT : none
' --------------------------------------------------------------------------
SUB CenterWindow(hWnd AS HWND)
    DIM wRect AS RECT
    DIM x     AS DWORD
    DIM y     AS DWORD

    GetWindowRect(hWnd, &wRect)
    x = (GetSystemMetrics(SM_CXSCREEN) - (wRect.right - wRect.left)) / 2
    y = (GetSystemMetrics(SM_CYSCREEN) - (wRect.bottom - wRect.top)) / 2
    SetWindowPos(hWnd, NULL, x, y, 0, 0, SWP_NOSIZE OR SWP_NOZORDER)
END SUB


' --------------------------------------------------------------------------
' PURPOSE: Creates application windows, performs window loading
' INPUT  : hInst AS HINSTANCE
' OUTPUT : none
' --------------------------------------------------------------------------
SUB FormLoad(hInst as HINSTANCE)
    Form1 = CreateWindow(ClassName1$, CaptionName1$, DS_MODALFRAME OR _
            WS_MINIMIZEBOX OR WS_MAXIMIZEBOX OR WS_POPUP OR WS_CAPTION OR _
            WS_SYSMENU OR WS_THICKFRAME OR WS_CLIPCHILDREN, _
            0, 0, 350, 300, NULL, NULL, hInst, NULL)

    Canvas1 = CreateWindow(ClassName2$, "", WS_CHILD OR WS_VISIBLE, _
            0, 0, 100, 100, Form1, NULL, hInst, NULL)

    DragAcceptFiles(Form1, TRUE)

    ' set window on top
    SendMessage    (Form1, WM_RBUTTONDOWN, 0, 0)

    ' load picture from command line if any
    LoadPictureFile(szChosen$, Canvas1)

    CenterWindow(Form1)
    UpdateWindow(Form1)
    ShowWindow(Form1, SW_SHOWNORMAL)
END SUB


' --------------------------------------------------------------------------
' PURPOSE: This function loads a file into an IStream
' INPUT  : szFile$, hWnd AS HWND
' OUTPUT : none
' --------------------------------------------------------------------------
SUB LoadPictureFile(szFile$, hWnd AS HWND)
    STATIC hFile       AS HANDLE
    STATIC dwFileSize  AS DWORD
    STATIC pvData      AS LPVOID
    STATIC hGlobal     AS HGLOBAL
    STATIC dwBytesRead AS DWORD
    STATIC bRead       AS BOOL
    STATIC pstm        AS LPSTREAM
    STATIC hr          AS HRESULT
    DIM    rc          AS RECT
    DIM    crc         AS RECT

    ' open file
    hFile       = CreateFile(szFile, GENERIC_READ, 0, NULL, _
                  OPEN_EXISTING, 0, NULL)

    ' get file size
    dwFileSize  = GetFileSize(hFile, NULL)

    ' alloc memory based on file size
    pvData      = NULL
    hGlobal     = GlobalAlloc(GMEM_MOVEABLE, dwFileSize)

    pvData      = GlobalLock(hGlobal)

    ' read file and store in global memory
    dwBytesRead = 0
    bRead       = ReadFile(hFile, pvData, dwFileSize, &dwBytesRead, NULL)
    GlobalUnlock(hGlobal)
    CloseHandle(hFile)

    ' create IStream* from global memory
    pstm = NULL
    hr   = CreateStreamOnHGlobal(hGlobal, TRUE, &pstm)

    ' create IPicture from image file
    IF gpPicture THEN gpPicture->lpVtbl->Release(gpPicture)
    hr = OleLoadPicture(pstm, dwFileSize, FALSE, &IID_IPicture, _
         (LPVOID*)&gpPicture)
    pstm->lpVtbl->Release(pstm)

    ' obtain width of picture and resize client window
    IF gpPicture THEN
        MoveWindow(hWnd, 0, 0, 0, 0, TRUE)
        ObtainWidth()

        GetWindowRect(GetParent(hWnd), &rc)
        GetClientRect(GetParent(hWnd), &crc)

        rc.right  = (rc.right  - rc.left) - crc.right
        rc.bottom = (rc.bottom - rc.top)  - crc.bottom

        IF rc.left < 0 THEN rc.left = 0
        IF rc.top  < 0 THEN rc.top = 0

        SetWindowPos(Form1, 0, rc.left, rc.top, nWidth + rc.right, _
                     nHeight + rc.bottom, SWP_NOACTIVATE)
        SetWindowPos(hWnd,  0, 0, 0, nWidth, nHeight, SWP_NOACTIVATE)
    END IF

    ' force redraw
    InvalidateRect(hWnd, NULL, TRUE)
END SUB


' --------------------------------------------------------------------------
' PURPOSE: Quick alternative to JOIN$()
' INPUT  : sz1$, sz2$
' OUTPUT : address to combined string
' --------------------------------------------------------------------------
FUNCTION Combine$(sz1$, sz2$)
    FUNCTION = sz1$ & sz2$
END SUB


' --------------------------------------------------------------------------
' PURPOSE: Obtains the width and height of a picture in pixels
' INPUT  : none
' OUTPUT : none
' --------------------------------------------------------------------------
SUB ObtainWidth()
    DIM hdc AS HDC

    hdc = GetDC(Canvas1)

    ' get width and height of picture
    gpPicture->lpVtbl-> get_Width(gpPicture, &hmWidth)
    gpPicture->lpVtbl->get_Height(gpPicture, &hmHeight)

    ' convert himetric to pixels
    nWidth  = MulDiv(hmWidth,  _
                     GetDeviceCaps(hdc, LOGPIXELSX), HIMETRIC_INCH)
    nHeight = MulDiv(hmHeight, _
                     GetDeviceCaps(hdc, LOGPIXELSY), HIMETRIC_INCH)

    ReleaseDC(Canvas1, hdc)
END SUB

' **************************************************************************
'                              END OF PROGRAM !
' **************************************************************************
