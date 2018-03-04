GLOBAL hProgram  AS HWND
GLOBAL hMonth    AS HWND
GLOBAL hDay      AS HWND
GLOBAL hYear     AS HWND
GLOBAL hRevision AS HWND
GLOBAL hBuild    AS HWND
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
        hProgram = GetDlgItem(hDlg, 103)
        hMonth = GetDlgItem(hDlg, 105)
        hDay = GetDlgItem(hDlg, 107)
        hYear = GetDlgItem(hDlg, 109)
        hRevision = GetDlgItem(hDlg, 111)
        hBuild = GetDlgItem(hDlg, 113)
        hCreate = GetDlgItem(hDlg, 114)

        SetWindowText(hProgram, "my application version 1.0")
        SetWindowText(hRevision, "0")
        SetWindowText(hMonth, TimeF$("%m"))
        SetWindowText(hDay, TimeF$("%d"))
        SetWindowText(hYear, TimeF$("%Y"))
        SetWindowText(hBuild, "0")
        Create_Click()
    CASE WM_COMMAND
        IF wParam = 114 THEN CALL Create_Click
    CASE WM_CLOSE
        EndDialog(hDlg, 0)
    END SELECT

    FUNCTION = 0
END FUNCTION


SUB Create_Click()
    STATIC fWordGet$
    STATIC fCHRWord$
    STATIC iCount
    STATIC iWordCount
    STATIC iTempA

    iCount = 0
    iWordCount = 0
    iTempA = 0

    ' get program title
    iWordCount = GetWindowTextLength(hProgram) + 1
    GetWindowText(hProgram, fWordGet$, iWordCount)

    FOR iCount = 1 to LEN(fWordGet$)
        fCHRWord$ = MID$(fWordGet$, iCount, 1)
        iTempA = iTempA + ASC(fCHRWord$)
    NEXT

    ' get revision
    iWordCount = GetWindowTextLength(hRevision) + 1
    GetWindowText(hRevision, fWordGet$, iWordCount)
    iTempA = iTempA + VAL(fWordGet$)

    ' get month
    iWordCount = GetWindowTextLength(hMonth) + 1
    GetWindowText(hMonth, fWordGet$, iWordCount)
    fWordGet$ = fWordGet$ & "0"
    iTempA = iTempA + VAL(fWordGet$)

    ' get day
    iWordCount = GetWindowTextLength(hDay) + 1
    GetWindowText(hDay, fWordGet$, iWordCount)
    iTempA = iTempA + VAL(fWordGet$)

    ' get year
    iWordCount = GetWindowTextLength(hYear) + 1
    GetWindowText(hYear, fWordGet$, iWordCount)
    iTempA = iTempA + VAL(fWordGet$)

    ' update build
    fWordGet$ = TRIM$(STR$(iTempA))
    SetWindowText(hBuild, fWordGet$)
END SUB


FUNCTION TimeF$(szInFormat$)
    STATIC elapse_time AS LONG
    ! static struct tm *tp;

    time(&elapse_time)
    tp=localtime(&elapse_time)
    strftime(StrFunc[StrCnt], 256, szInFormat, tp)

    FUNCTION = StrFunc[StrCnt]
END FUNCTION
