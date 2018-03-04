' **************************************************************************
'            BCX Source Code Generated Using Dialog Starter 1.0
'                 For Use With BCX Translator Version 2.15+
' **************************************************************************
' Lo-View the strict bitmap viewer. Views bitmaps that meet the Windows 2000
' startup logo requirements.   Lo-View will apply animations to bitmaps that
'   meet the 640x480x16 (width  X  height  x  color depth) specifications.
' **************************************************************************
' Things to try:
'  - Open a bitmap that is 640x480x16
'  - Open a bitmap that does not meet the specifications above
'  - Open a non-bitmap file
'  - Left-click the client area of the main window
'  - Select the Lo-View executable as a bitmap file
'  - "Drag n' Drop" a single file onto the client area of the main window
'  - Load bitmap from command-line
'  - Pressing Enter while focus is on the main window
'  - Stare at the lame animation
'  - Use +, -, / keys to speed up, slow down, or restore speed, respectively
' History:
' - 6/14/01 - release
' - 8/30/01 - updated percentage bar (dropped exe size by 1/2 kb)
' **************************************************************************

    ' Global Constants (Dialog/Control IDs)
    CONST IDD_FORM1 = 100

    ' Global Variables (Dialog/Control Handles)
    GLOBAL hInstance AS HINSTANCE
    GLOBAL Form1 AS HWND
    GLOBAL Menu1 AS HMENU

    GLOBAL clrSecond AS COLORREF
    GLOBAL bg        AS COLORREF
    GLOBAL ofn       AS OPENFILENAME
    GLOBAL hBitmap   AS HBITMAP
    GLOBAL speed
    GLOBAL counter
    GLOBAL cnt
    GLOBAL szFile$

' ==========================================================================
'                    Bitmap specifications from Wotsit.org
' ==========================================================================
    CONST BMP_PALETTE    = 0x0036

    TYPE BMP_HEADER
        fIdentity$[2]
        fFileSize     AS LONG
        fReserved     AS LONG
        fOffset       AS LONG
        fHeaderSize   AS LONG
        fWidth        AS LONG
        fHeight       AS LONG
        fPlanes       AS WORD
        fBPP          AS WORD
        fCompression  AS LONG
        fDataSize     AS LONG
        fHResolution  AS LONG
        fVResolution  AS LONG
        fColors       AS LONG
        fImpColors    AS LONG
    END TYPE

    TYPE PALETTE
        fBlue     AS BYTE
        fGreen    AS BYTE
        fRed      AS BYTE
        fReserved AS BYTE
    END TYPE


' ==========================================================================
' PURPOSE: Inital entry point
' INPUT  : hInst AS HINSTANCE, hPrev AS HINSTANCE, CmdLine AS LPSTR, 
'          CmdShow AS INTEGER
' OUTPUT : integer value
' ==========================================================================
FUNCTION WinMain()
    ' Gives global access to hInstance
    hInstance = hInst

    ' Store command-line arguments
    szFile$ = CmdLine$

    ' Intialize our dialog, pointing it to the dialog procedure
    DialogBox(hInst, MAKEINTRESOURCE(IDD_FORM1), NULL, (DLGPROC) Form1_Proc)

    FUNCTION = FALSE
END FUNCTION


' ==========================================================================
' PURPOSE: Processes messages sent to Form1
' INPUT  : hWnd AS HWND,  Msg AS UINT,  wParam AS WPARAM, lParam AS LPARAM
' OUTPUT : integer value
' ==========================================================================
CALLBACK FUNCTION Form1_Proc()
    DIM hBrush      AS HBRUSH
    DIM hPen        AS HPEN
    DIM lb          AS LOGBRUSH
    DIM hPenOld     AS HPEN
    DIM hPenOld2    AS HPEN
    DIM hBrushOld   AS HBRUSH
    DIM hBrushOld2  AS HBRUSH
    DIM hBitmapOld  AS HBITMAP
    DIM hBitmapOld2 AS HBITMAP
    STATIC ps       AS PAINTSTRUCT
    STATIC hdc      AS HDC
    STATIC hdcMem   AS HDC
    STATIC cxClient
    STATIC cyClient

    SELECT CASE Msg
' **************************************************************************
    CASE WM_INITDIALOG
' **************************************************************************
        ' Retrieves the dialog/control handles
        Form1 = hWnd
        Menu1 = LoadMenu(hInstance, MAKEINTRESOURCE(1))

        ' Remove maximize window/size window from system menu
        DeleteMenu(GetSystemMenu(hWnd, FALSE), 4, MF_BYPOSITION)
        DeleteMenu(GetSystemMenu(hWnd, FALSE), 2, MF_BYPOSITION)

        ' Set other properties
        SetMenu(hWnd, Menu1)
        CenterWindow(hWnd)
        DragAcceptFiles(hWnd, TRUE)
        speed = 15

        ' Attempt to load startup bitmaps
        IF EXIST(szFile$) = -1 THEN
            OpenBitmap(szFile$)
        ELSE
            IF EXIST("help.bmp") = -1 THEN OpenBitmap("help.bmp")
        END IF

' **************************************************************************
    CASE WM_COMMAND
' **************************************************************************
        SELECT CASE LOWORD(wParam)
        CASE 1
            szFile$               = "*.bmp"

            ofn.lStructSize       = sizeof(OPENFILENAME)
            ofn.hwndOwner         = hWnd
            ofn.hInstance         = hInstance
            ! ofn.lpstrFilter     = "Bitmap Files (*.bmp)\0*.bmp\0All Files (*.*)\0*.*\0\0";
            ofn.lpstrCustomFilter = (LPSTR)NULL
            ofn.nMaxCustFilter    = 0
            ofn.nFilterIndex      = 0
            ofn.lpstrFile         = szFile$
            ofn.nMaxFile          = sizeof(szFile$)
            ofn.lpstrFileTitle    = ""
            ofn.nMaxFileTitle     = 0
            ofn.lpstrInitialDir   = CURDIR$
            ofn.lpstrTitle        = NULL
            ofn.Flags             = OFN_FILEMUSTEXIST | OFN_PATHMUSTEXIST | _
                                    OFN_EXPLORER | OFN_LONGNAMES
            ofn.nFileOffset       = 0
            ofn.nFileExtension    = 0
            ofn.lpstrDefExt       = "*.bmp"
            ofn.lCustData         = 0L
            ofn.lpfnHook          = NULL
            ofn.lpTemplateName    = NULL

            IF GetOpenFileName(&ofn) THEN
                OpenBitmap(szFile$)
            END IF
        CASE 2
            speed += 1
        CASE 3
            If speed < 1 THEN
                speed = 0
            ELSE
                speed -= 1
            END IF
        CASE 4
            DestroyWindow(hWnd)
        END SELECT

' **************************************************************************
    CASE WM_KEYUP
' **************************************************************************
        SELECT CASE wParam
        CASE VK_ADD
            SendMessage(hWnd, WM_COMMAND, MAKEWPARAM(2, 1), 0)
        CASE VK_SUBTRACT
            SendMessage(hWnd, WM_COMMAND, MAKEWPARAM(3, 1), 0)
        CASE VK_DIVIDE
            speed = 15
        END SELECT

' **************************************************************************
    CASE WM_DROPFILES
' **************************************************************************
        DragQueryFile((HDROP)wParam, 0, szFile$, 1023)
        OpenBitmap(szFile$)

' **************************************************************************
    CASE WM_LBUTTONDOWN
' **************************************************************************
        ' Allow bitmap selecting by clicking the form
        SendMessage(hWnd, WM_COMMAND, MAKEWPARAM(1, 1), 0)

' **************************************************************************
    CASE WM_TIMER
' **************************************************************************
        IF NOT hBitmap THEN EXIT FUNCTION

        hdc    = GetDC(hWnd)
        hdcMem = CreateCompatibleDC(hdc)
        hBitmapOld = SelectObject(hdcMem, hBitmap)

        IF cnt > 640 THEN
            cnt = 0
        ELSE
            cnt += speed

            ' Move bar right
            BitBlt(hdc, cnt, 416, 640, 10, hdcMem, 0, 416, SRCCOPY)

            ' Redraw moved items on the left
            BitBlt(hdc, 0, 416, cnt, 10, hdcMem, 640-cnt, 416, SRCCOPY)
        ENDIF

        SelectObject(hdc, hBitmapOld)
        DeleteObject(hBitmapOld)

' --------------------------------------------------------------------------

        ' If counter is greater than width, reset
        ' also bilt the orignal image to reset the percentage bar
        IF counter > 158 THEN
            ' Reset counter
            counter = 0

            BitBlt(hdc, 274, 437, 163, 8, hdcMem, 274, 437, SRCCOPY)
        ELSE
            INCR counter
        END IF

' --------------------------------------------------------------------------

        ' Create Windows 95 progress bar effect
        IF NOT mod(counter, 6) THEN
            hPen = CreatePen(0, 1, clrSecond)

            lb.lbStyle = BS_SOLID
                lb.lbColor = clrSecond
            hBrush = CreateBrushIndirect(&lb)

            hBrushOld = SelectObject(hdc, hBrush)
            hPenOld = SelectObject(hdc, hPen)

            Rectangle(hdc, 275 + counter, 438, 280 + counter, 444)

            SelectObject(hdc, hBrushOld)
            DeleteObject(hBrushOld)
            DeleteObject(hBrush)

            SelectObject(hdc, hPenOld)
            DeleteObject(hPenOld)
            DeleteObject(hPen)
        END IF

        DeleteDC(hdcMem)
        ReleaseDC(hWnd, hdc)

' **************************************************************************
    CASE WM_SIZE
' **************************************************************************
        cxClient = LOWORD(lParam)
        cyClient = HIWORD(lParam)

' **************************************************************************
    CASE WM_PAINT
' **************************************************************************
        IF NOT hBitmap THEN EXIT FUNCTION

        hdc = BeginPaint(hWnd, &ps)
        hdcMem = CreateCompatibleDC(hdc)

        hBitmapOld2 = SelectObject(hdcMem, hBitmap)
        BitBlt(hdc, 0, 0, cxClient, cyClient, hdcMem, 0, 0, SRCCOPY)

        DeleteDC(hdcMem)
        ReleaseDC(hWnd, hdc)

        SelectObject(hdc, hBitmapOld2)
        DeleteObject(hBitmapOld2)

        EndPaint(hWnd, &ps)

' **************************************************************************
    CASE WM_CLOSE
' **************************************************************************
        ' Free our dialog
        EndDialog(hWnd, TRUE)

' **************************************************************************
    CASE WM_DESTROY
' **************************************************************************
        KillTimer(hWnd, 1)

' **************************************************************************
    CASE ELSE
' **************************************************************************
        ' No messages processed, return false
        FUNCTION = FALSE
    END SELECT

    ' If we reach this point, that means a message was processed
    ' and we send a true value
    FUNCTION = TRUE
END FUNCTION


' ==========================================================================
' PURPOSE: Centers a given window or control
' INPUT  : hWnd AS HWND
' OUTPUT : none
' ==========================================================================
SUB CenterWindow(hWnd AS HWND)
    STATIC wRect AS RECT
    STATIC x     AS DWORD
    STATIC y     AS DWORD

    GetWindowRect(hWnd, &wRect)
    x = (GetSystemMetrics(SM_CXSCREEN) - (wRect.right - wRect.left)) / 2
    y = (GetSystemMetrics(SM_CYSCREEN) - (wRect.bottom - wRect.top + _
        GetSystemMetrics(SM_CYCAPTION))) / 2
    SetWindowPos(hWnd, NULL, x, y, 0, 0, SWP_NOSIZE OR SWP_NOZORDER)
END SUB


' ==========================================================================
' PURPOSE: Checks if a bitmap fits the Win2k logo requirements
' INPUT  : szFile$
' OUTPUT : returns TRUE if valid, otherwise FALSE
' ==========================================================================
FUNCTION ValidBitmap(szFile$)
    DIM pal AS PALETTE
    DIM bmp AS BMP_HEADER
    DIM inf AS BYTE
    DIM msg$

    msg$ = ""
    inf  = 0

    OPEN szFile$ FOR BINARY AS FP1
        ' obtain bitmap header
        GET$ FP1, sizeof(BMP_HEADER), &bmp

        ' The color for the percentage bar is stored as the second color
        ' in the palette. To grab the color, we shift right by 4 bytes.
        SEEK FP1, BMP_PALETTE + 4
        GET$ FP1, sizeof(pal), &pal
    CLOSE FP1

    IF LEFT$(LCASE$(bmp.fIdentity$), 2) <> "bm" THEN
        MessageBox(Form1, "Not a valid bitmap", "Bitmap Error", MB_OK)
        FUNCTION = FALSE
    END IF

    IF bmp.fWidth <> 640 THEN
        msg$ = "Width must be equal to 640 pixels" & CHR$(13) & CHR$(10)
        inf = 1
    END IF

    IF bmp.fHeight <> 480 THEN
        msg$ = msg$ & "Height must be equal to 480 pixels" & CHR$(13) & CHR$(10)
        inf = 1
    END IF
	
    IF bmp.fBPP <> 4 THEN
        msg$ = msg$ & "Color depth must be 16 colors" & CHR$(13) & CHR$(10)
        inf = 1
    END IF

    IF inf THEN
        MessageBox(Form1, msg$, "Bitmap Error", MB_OK)
        FUNCTION = FALSE
    END IF

    clrSecond = RGB(pal.fRed, pal.fGreen, pal.fBlue)

    FUNCTION = TRUE
END FUNCTION


' ==========================================================================
' PURPOSE: Gets the path & name of the running executable
' INPUT  : none
' OUTPUT : filename$ - name of exe
' ==========================================================================
FUNCTION EXEName$()
    DIM buffer$

    GetModuleFileName(NULL, buffer$, 1023)
    FUNCTION = buffer$
END FUNCTION


' ==========================================================================
' PURPOSE: Validates bitmap and loads bitmap to memory
' INPUT  : szFile$
' OUTPUT : none
' ==========================================================================
SUB OpenBitmap(szFile$)
    IF LCASE$(EXEName$()) <> LCASE$(szFile$) THEN
        IF ValidBitmap(szFile$) THEN
            IF hBitmap THEN DeleteObject(hBitmap)
            hBitmap = (HBITMAP)LoadImage(NULL, szFile$, IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_LOADFROMFILE)

            ' Force windows to display our bitmap
            InvalidateRect(Form1, NULL, TRUE)

            ' Remove previous timer and start new one
            counter = 163
            cnt     = 0 
            KillTimer(Form1, 1)
            SetTimer(Form1, 1, 0, NULL)
        END IF
    ELSE
        MessageBox(Form1, "Duh, that's this EXE!", "Error", MB_OK)
    END IF
END SUB
