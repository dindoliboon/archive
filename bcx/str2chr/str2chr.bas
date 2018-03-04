GLOBAL hInput    AS HWND
GLOBAL hOutput   AS HWND
GLOBAL hCreate   AS HWND
GLOBAL Form1     AS HWND


FUNCTION WinMain(hInst AS HINSTANCE, hPrev AS HINSTANCE, CmdLine AS LPSTR, nCmdShow AS int)
    DialogBox(hInst, MAKEINTRESOURCE(100), 0, MainProc)
    FUNCTION = 0
END FUNCTION


FUNCTION MainProc(hDlg AS HWND, uMsg as UINT, wParam as WPARAM, lParam as LPARAM) AS INT_PTR CALLBACK
    SELECT CASE uMsg
    CASE WM_INITDIALOG
        Form1 = hDlg
        hInput = GetDlgItem(hDlg, 103)
        hOutput = GetDlgItem(hDlg, 105)
        hCreate = GetDlgItem(hDlg, 106)
    CASE WM_COMMAND
        IF wParam = 106 THEN CALL Create_Click
    CASE WM_CLOSE
        EndDialog(hDlg, 0)
    END SELECT

    FUNCTION = 0
END FUNCTION


SUB Create_Click()
    DIM fWordGet$
    DIM fCHRWord$
    DIM fBuffer$
    DIM iCount

    ' get program title
    GetWindowText(hInput, fWordGet$, 2048)
    IF LEN(fWordGet$) > 0 THEN
        fBuffer$ = "JOIN$("

        iCount = 0
        FOR iCount = 1 to LEN(fWordGet$)
            fCHRWord$ = MID$(fWordGet$, iCount, 1)
            fBuffer$ = fBuffer$ & "CHR$("
            fBuffer$ = fBuffer$ & TRIM$(STR$(ASC(fCHRWord$)))
            fBuffer$ = fBuffer$ & ")"
            IF iCount <> LEN(fWordGet$) THEN
                fBuffer$ = fBuffer$ & ", "
            END IF
        NEXT
        fBuffer$ = fBuffer$ & ")"

        ' update chr
        SetWindowText(hOutput, fBuffer$)
    END IF
END SUB
