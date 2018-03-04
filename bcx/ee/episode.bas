' **************************************************************************
'        BCX Source Code Generated Using Dialog Starter 1.0
'         For Use With BCX Translator Version 2.15+
' **************************************************************************

    ' Global Constants (Dialog/Control IDs)
    CONST IDD_FORM1 = 100
    CONST IDC_EDIT1 = 112
    CONST IDC_EDIT2 = 114
    CONST IDC_EDIT3 = 116
    CONST IDC_LISTBOX1 = 118
    CONST IDC_EDIT4 = 102

    ' Global Variables (Dialog/Control Handles)
    GLOBAL hInstance AS HINSTANCE
    GLOBAL Form1 AS HWND
    GLOBAL Edit1 AS HWND
    GLOBAL Edit2 AS HWND
    GLOBAL Edit3 AS HWND
    GLOBAL ListBox1 AS HWND
    GLOBAL Edit4 AS HWND

    ' Global Proc Variables
    GLOBAL lpEdit1_Proc AS FARPROC

    GLOBAL hBitmap1 AS HBITMAP
    GLOBAL bitmap1  AS BITMAP

FUNCTION WinMain()
    ' Gives global access to hInstance
    hInstance = hInst

    ' Intialize our dialog, pointing it to the dialog procedure
    DialogBox(hInst, MAKEINTRESOURCE(IDD_FORM1), NULL, (DLGPROC) Form1_Proc)

    FUNCTION = FALSE
END FUNCTION


CALLBACK FUNCTION Form1_Proc()
    DIM  ps     AS PAINTSTRUCT
    DIM  hdc    AS HDC
    DIM  hdcMem AS HDC

    SELECT CASE Msg
' **************************************************************************
    CASE WM_INITDIALOG
' **************************************************************************
    ' Retrieves the dialog/control handles
    Form1 = hWnd
    Edit1 = GetDlgItem(hWnd, IDC_EDIT1)
    Edit2 = GetDlgItem(hWnd, IDC_EDIT2)
    Edit3 = GetDlgItem(hWnd, IDC_EDIT3)
    ListBox1 = GetDlgItem(hWnd, IDC_LISTBOX1)
    Edit4 = GetDlgItem(hWnd, IDC_EDIT4)

    ' Give controls seperate proc functions
    lpEdit1_Proc = SubclassWindow(Edit1, Edit1_Proc)
    SubclassWindow(Edit2, Edit1_Proc)
    SubclassWindow(Edit3, Edit1_Proc)

    ' Set other window properties
    CenterWindow(hWnd)
    SetWindowText(Edit1, "25")
    SetWindowText(Edit2, "25.0")
    SetWindowText(Edit3, "4.32")

    ListBox_AddString(ListBox1, "Microsoft MPEG-4 VCR Quality at 320x240")
    ListBox_AddString(ListBox1, "RealVideo G2 150 Kbps VCR Quality at 320x240")
    ListBox_AddString(ListBox1, "RealVideo G2 300 Kbps VCR Quality at 320x240")
    ListBox_AddString(ListBox1, "DivX MPEG-4 VCR Quality at 320x240")
    ListBox_AddString(ListBox1, "DivX MPEG-4 VCD Quality at 512x384")
    ListBox_AddString(ListBox1, "Radius Cinepak VCD Quality at 320x240")
    ListBox_AddString(ListBox1, "DivX MPEG-4 SVCD Quality at 352x240")
    ListBox_AddString(ListBox1, "VCD MPEG-1 VCD Quality at 352x240")

    ' if you want to save space, you can just load it from a file
    'hBitmap1 = LoadImage(0, "episode.bmp", IMAGE_BITMAP, 509, 64, LR_LOADFROMFILE)

    hBitmap1 = LoadBitmap(hInstance, MAKEINTRESOURCE(100))
    GetObject(hBitmap1, sizeof(BITMAP), &bitmap1)

    SendMessage(hWnd, WM_SETICON, TRUE, LoadIcon(hInstance, MAKEINTRESOURCE(100)))
    ListBox_SetCurSel(ListBox1, 4)
    UpdateNumbers()

' **************************************************************************
    CASE WM_COMMAND
' **************************************************************************
    IF HIWORD(wParam) = LBN_SELCHANGE THEN
        SELECT CASE ListBox_GetCurSel(ListBox1)
        CASE 0
            SetWindowText(Edit3, "1.2")
        CASE 1
            SetWindowText(Edit3, "1.04")
        CASE 2
            SetWindowText(Edit3, "2.44")
        CASE 3
            SetWindowText(Edit3, "2")
        CASE 4
            SetWindowText(Edit3, "4.32")
        CASE 5
            SetWindowText(Edit3, "4.84")
        CASE 6
            SetWindowText(Edit3, "5")
        CASE ELSE
            SetWindowText(Edit3, "8.12")
        END SELECT

        UpdateNumbers()
    END IF

' **************************************************************************
    CASE WM_PAINT
' **************************************************************************
        hdc = BeginPaint(hWnd, &ps)
        hdcMem = CreateCompatibleDC(hdc)

        SelectObject(hdcMem, hBitmap1)
        BitBlt(hdc, 6, 6, 509, 64, hdcMem, 0, 0, SRCCOPY)

        DeleteDC(hdcMem)
        EndPaint(hWnd, &ps)

' **************************************************************************
    CASE WM_CLOSE
' **************************************************************************
    ' Free our dialog
    EndDialog(hWnd, TRUE)

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


CALLBACK FUNCTION Edit1_Proc()
    SELECT CASE Msg
' **************************************************************************
    CASE WM_CHAR
' **************************************************************************
    ' Only allow numbers
    IF (wParam >= 48 and wParam <= 57) OR wParam = VK_BACK OR wParam = ASC(".") THEN
        FUNCTION = CallWindowProc(lpEdit1_Proc, hWnd, Msg, wParam, lParam)
    END IF

' **************************************************************************
    CASE WM_KEYUP
' **************************************************************************
    UpdateNumbers()

' **************************************************************************
    CASE ELSE
' **************************************************************************
    ' No messages have been processed
    FUNCTION = CallWindowProc(lpEdit1_Proc, hWnd, Msg, wParam, lParam)
    END SELECT

    ' Default message has been processed
    FUNCTION = TRUE
END FUNCTION


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


SUB UpdateNumbers()
    DIM szBuffer$
    DIM dwAmount AS DOUBLE
    DIM dwSize   AS DOUBLE
    DIM dwLength AS DOUBLE
    DIM dwTmp1   AS DOUBLE
    DIM dwTmp2   AS DOUBLE

    GetWindowText(Edit1, szBuffer$, sizeof(szBuffer$))
    dwAmount = VAL(szBuffer$)

    GetWindowText(Edit2, szBuffer$, sizeof(szBuffer$))
    dwLength = VAL(szBuffer$)

    GetWindowText(Edit3, szBuffer$, sizeof(szBuffer$))
    dwSize   = VAL(szBuffer$)

    dwTmp1 = dwAmount * dwLength
    dwTmp2 = dwLength * dwSize * dwAmount

    szBuffer$ = "~ VCR Tapes" & CRLF$
    szBuffer$ = szBuffer$ & "Uses " & str$(ceil((dwTmp1) / 120.0)) & " 2 hr SP tapes" & CRLF$
    szBuffer$ = szBuffer$ & "Uses " & str$(ceil((dwTmp1) / 180.0)) & " 3 hr SP tapes" & CRLF$
    szBuffer$ = szBuffer$ & "Uses " & str$(ceil((dwTmp1) / 240.0)) & " 4 hr LP tapes" & CRLF$
    szBuffer$ = szBuffer$ & "Uses " & str$(ceil((dwTmp1) / 360.0)) & " 6 hr LP tapes <<" & CRLF$
    szBuffer$ = szBuffer$ & "Uses " & str$(ceil((dwTmp1) / 480.0)) & " 8 hr EP tapes" & CRLF$
    szBuffer$ = szBuffer$ & "Uses " & str$(ceil((dwTmp1) / 540.0)) & " 9 hr EP tapes" & CRLF$ & CRLF$
    szBuffer$ = szBuffer$ & "~ CD-R/CD-RW" & CRLF$
    szBuffer$ = szBuffer$ & "Uses " & str$(ceil((dwTmp2) / 650.0))  & " 650 MB CDs <<" & CRLF$
    szBuffer$ = szBuffer$ & "Uses " & str$(ceil((dwTmp2) / 700.0))  & " 700 MB CDs" & CRLF$ & CRLF$
    szBuffer$ = szBuffer$ & "~ DVD/DVD-RAM/DVD-RW" & CRLF$
    szBuffer$ = szBuffer$ & "Uses " & str$(ceil((dwTmp2) / 2500.0)) & " 2.5 GB CDs <<" & CRLF$
    szBuffer$ = szBuffer$ & "Uses " & str$(ceil((dwTmp2) / 4700.0)) & " 4.7 GB CDs" & CRLF$
    szBuffer$ = szBuffer$ & "Uses " & str$(ceil((dwTmp2) / 5200.0)) & " 5.2 GB CDs" & CRLF$
    szBuffer$ = szBuffer$ & "Uses " & str$(ceil((dwTmp2) / 9400.0)) & " 9.4 GB CDs" & CRLF$ & CRLF$
    szBuffer$ = szBuffer$ & "<< means standard" & CRLF$
    SetWindowText(Edit4, szBuffer$)
END SUB
