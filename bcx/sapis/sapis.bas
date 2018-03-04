GLOBAL hHandle  AS HWND
GLOBAL hClass   AS HWND
GLOBAL hText    AS HWND
GLOBAL hID      AS HWND
GLOBAL hStyle   AS HWND
GLOBAL hExStyle AS HWND
GLOBAL hRect    AS HWND
GLOBAL hCRect   AS HWND
GLOBAL hRGB     AS HWND
GLOBAL hXY      AS HWND
GLOBAL hPicker  AS HWND

GLOBAL cSelected
GLOBAL Form1            AS HWND
GLOBAL lasthwnd         AS HWND
GLOBAL lpPicker_WndProc AS FARPROC
GLOBAL hInstance        AS HINSTANCE


FUNCTION WinMain(hInst AS HINSTANCE, hPrev AS HINSTANCE, CmdLine AS LPSTR, nCmdShow AS int)
    hInstance = hInst
    DialogBox(hInst, MAKEINTRESOURCE(100), 0, SapisProc)
    FUNCTION = 0
END FUNCTION


FUNCTION SapisProc(hDlg AS HWND, uMsg as UINT, wParam as WPARAM, lParam as LPARAM) AS INT_PTR CALLBACK
    SELECT CASE uMsg
    CASE WM_INITDIALOG
        Form1 = hDlg
        hHandle  = GetDlgItem(hDlg, 103)
        hClass   = GetDlgItem(hDlg, 105)
        hText    = GetDlgItem(hDlg, 107)
        hID      = GetDlgItem(hDlg, 109)
        hStyle   = GetDlgItem(hDlg, 111)
        hExStyle = GetDlgItem(hDlg, 113)
        hRect    = GetDlgItem(hDlg, 115)
        hCRect   = GetDlgItem(hDlg, 117)
        hRGB     = GetDlgItem(hDlg, 120)
        hXY      = GetDlgItem(hDlg, 122)
        hPicker  = GetDlgItem(hDlg, 124)

        lpPicker_WndProc = SetWindowLong(hPicker, GWL_WNDPROC, Picker_WndProc)
        SendMessage(hDlg, WM_SETICON, TRUE, LoadIcon(hInstance, MAKEINTRESOURCE(100)))
        SetWindowPos(hDlg, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE)
    CASE WM_CLOSE
        EndDialog(hDlg, 0)
    END SELECT

    FUNCTION = 0
END FUNCTION


FUNCTION Picker_WndProc(hWnd AS HWND, Msg as UINT, wParam as WPARAM, lParam as LPARAM) AS INT_PTR CALLBACK
    STATIC lpBuffer$
    STATIC pt AS POINT
    STATIC lpt AS POINT
    STATIC rc AS RECT
    STATIC crc AS RECT
    STATIC wrc AS RECT
    STATIC hwnd AS HWND
    STATIC cRef AS COLORREF
    STATIC lRef AS COLORREF

    SELECT CASE Msg
    CASE WM_LBUTTONDOWN
        SetCursor(LoadCursor(hInstance, MAKEINTRESOURCE(100)))
        ShowWindow(hPicker, SW_HIDE)
        SetCapture(hPicker)
        cSelected = TRUE
    CASE WM_LBUTTONUP
        cSelected = FALSE

        lasthwnd = 0
        SetCursor(NULL)
        ShowWindow(hPicker, SW_SHOW)
        ReleaseCapture()
    CASE WM_MOUSEMOVE
        IF cSelected THEN
            GetCursorPos(&pt)
            hwnd = WindowFromPoint(pt)
            IF hwnd <> lasthwnd AND Form1 <> GetParent(hwnd) AND _
                hwnd <> Form1 THEN
                lasthwnd = hwnd

                ' handle
                lpBuffer$ = TRIM$(STR$((LONG)hwnd))
                SendMessage(hHandle, WM_SETTEXT, 0, (LPARAM)lpBuffer$)

                ' class
                GetClassName(hwnd, lpBuffer$, 1024)
                SendMessage(hClass, WM_SETTEXT, 0, (LPARAM)lpBuffer$)

                ' text
                SendMessage(hwnd, WM_GETTEXT, 1024, (LPARAM)lpBuffer$)
                SendMessage(hText, WM_SETTEXT, 0, (LPARAM)lpBuffer$)

                ' id
                lpBuffer$ = TRIM$(STR$(GetWindowLong(hwnd, GWL_ID)))
                SendMessage(hID, WM_SETTEXT, 0, (LPARAM)lpBuffer$)

                ' style
                lpBuffer$ = TRIM$(STR$(GetWindowLong(hwnd, GWL_STYLE)))
                SendMessage(hStyle, WM_SETTEXT, 0, (LPARAM)lpBuffer$)

                ' extended style
                lpBuffer$ = TRIM$(STR$(GetWindowLong(hwnd, GWL_EXSTYLE)))
                SendMessage(hExStyle, WM_SETTEXT, 0, (LPARAM)lpBuffer$)
            END IF

            ' rect
            GetWindowRect(hwnd, &rc)
            IF wrc.left <> rc.left or wrc.top <> rc.top or wrc.right <> rc.right or wrc.bottom <> rc.bottom THEN
                lpBuffer$ = "(" & TRIM$(STR$(rc.left))
                lpBuffer$ = lpBuffer$ & ","
                lpBuffer$ = lpBuffer$ & TRIM$(STR$(rc.top))
                lpBuffer$ = lpBuffer$ & ") - ("
                lpBuffer$ = lpBuffer$ & TRIM$(STR$(rc.right))
                lpBuffer$ = lpBuffer$ & ","
                lpBuffer$ = lpBuffer$ & TRIM$(STR$(rc.bottom))
                lpBuffer$ = lpBuffer$ & ")"
                SendMessage(hRect, WM_SETTEXT, 0, (LPARAM)lpBuffer$)
        
                wrc.left = rc.left
                wrc.top = rc.top
                wrc.right = rc.right
                wrc.bottom = rc.bottom
            END IF

            ' client rect
            GetClientRect(hwnd, &rc)
            IF crc.left <> rc.left or crc.top <> rc.top or crc.right <> rc.right or crc.bottom <> rc.bottom THEN
                lpBuffer$ = "(" & TRIM$(STR$(rc.left))
                lpBuffer$ = lpBuffer$ & ","
                lpBuffer$ = lpBuffer$ & TRIM$(STR$(rc.top))
                lpBuffer$ = lpBuffer$ & ") - ("
                lpBuffer$ = lpBuffer$ & TRIM$(STR$(rc.right))
                lpBuffer$ = lpBuffer$ & ","
                lpBuffer$ = lpBuffer$ & TRIM$(STR$(rc.bottom))
                lpBuffer$ = lpBuffer$ & ")"
                SendMessage(hCRect, WM_SETTEXT, 0, (LPARAM)lpBuffer$)
        
                crc.left = rc.left
                crc.top = rc.top
                crc.right = rc.right
                crc.bottom = rc.bottom
            END IF

            ' rgb color
            cRef = GetPixel(GetDC(0), pt.x, pt.y)
            IF lRef <> cRef THEN
                lpBuffer$ = "(" & TRIM$(STR$(GetRValue(cRef )))
                lpBuffer$ = lpBuffer$ & ","
                lpBuffer$ = lpBuffer$ & TRIM$(STR$(GetGValue(cRef )))
                lpBuffer$ = lpBuffer$ & ","
                lpBuffer$ = lpBuffer$ & TRIM$(STR$(GetBValue(cRef )))
                lpBuffer$ = lpBuffer$ & ")"
                SendMessage(hRGB, WM_SETTEXT, 0, (LPARAM)lpBuffer$)
                lRef = cRef
            END IF
            ReleaseDC(0, GetDC(0))

            ' x/y position
            IF pt.x <> lpt.x or pt.y <> lpt.y THEN
                lpBuffer$ = "(" & TRIM$(STR$(pt.x))
                lpBuffer$ = lpBuffer$ & ","
                lpBuffer$ = lpBuffer$ & TRIM$(STR$(pt.y))
                lpBuffer$ = lpBuffer$ & ")"
                SendMessage(hXY, WM_SETTEXT, 0, (LPARAM)lpBuffer$)
                lpt.x = pt.x
                lpt.y = pt.y
            END IF
        END IF
    END SELECT

    FUNCTION = CallWindowProc(lpPicker_WndProc, hWnd, Msg, wParam, lParam)
END FUNCTION
