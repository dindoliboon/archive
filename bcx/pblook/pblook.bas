' **************************************************************************
'            BCX Source Code Generated Using Dialog Starter 1.0
'                 For Use With BCX Translator Version 2.15+
' **************************************************************************

    #include <assert.h>

    GLOBAL szGDesc$

    ' Global Constants (Dialog/Control IDs)
    CONST IDD_FORM1 = 100
    CONST IDC_EDIT1 = 102
    CONST IDC_BUTTON1 = 103
    CONST IDC_STATIC3 = 106

    ' Global Variables (Dialog/Control Handles)
    GLOBAL hInstance AS HINSTANCE
    GLOBAL Form1 AS HWND
    GLOBAL Edit1 AS HWND
    GLOBAL Button1 AS HWND
    GLOBAL Static3 AS HWND

    ' Global Proc Variables
    GLOBAL lpEdit1_Proc AS FARPROC
    GLOBAL lpButton1_Proc AS FARPROC

' -------------------------------------------------------------------------
'   INPUT: hInst AS HINSTANCE, hPrev AS HINSTANCE, CmdLine AS LPSTR,
'          CmdShow AS INTEGER
'  OUTPUT: FALSE
' PURPOSE: Main application code.
' -------------------------------------------------------------------------
FUNCTION WinMain()
    ' Gives global access to hInstance
    hInstance = hInst

    ' Intialize our dialog, pointing it to the dialog procedure
    DialogBox(hInst, MAKEINTRESOURCE(IDD_FORM1), NULL, (DLGPROC) Form1_Proc)

    FUNCTION = FALSE
END FUNCTION

' -------------------------------------------------------------------------
'   INPUT: hWnd AS HWND, Msg AS UINT, wParam AS WPARAM, lParam AS LPARAM
'  OUTPUT: TRUE
' PURPOSE: Handles messages sent by Windows.
' -------------------------------------------------------------------------
CALLBACK FUNCTION Form1_Proc()
    SELECT CASE Msg
' **************************************************************************
    CASE WM_INITDIALOG
' **************************************************************************
        ' Retrieves the dialog/control handles
        Form1 = hWnd
        Edit1 = GetDlgItem(hWnd, IDC_EDIT1)
        Button1 = GetDlgItem(hWnd, IDC_BUTTON1)
        Static3 = GetDlgItem(hWnd, IDC_STATIC3)

        ' Give controls seperate proc functions
        lpEdit1_Proc = SubclassWindow(Edit1, Edit1_Proc)
        lpButton1_Proc = SubclassWindow(Button1, Button1_Proc)

        ' Set other window properties
        CenterWindow(hWnd)

' **************************************************************************
    CASE WM_COMMAND
' **************************************************************************
        IF wParam = IDC_BUTTON1 THEN
            SendMessage(Button1, WM_COMMAND, wParam, lParam)
        END IF

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

' -------------------------------------------------------------------------
'   INPUT: hWnd AS HWND, Msg AS UINT, wParam AS WPARAM, lParam AS LPARAM
'  OUTPUT: TRUE
' PURPOSE: Handles messages for the edit control sent by Windows.
' -------------------------------------------------------------------------
CALLBACK FUNCTION Edit1_Proc()
    SELECT CASE Msg
' **************************************************************************
    CASE WM_KEYUP
' **************************************************************************
        IF wParam = VK_RETURN THEN
            SendMessage(Button1, WM_COMMAND, wParam, lParam)
        END IF

' **************************************************************************
    CASE WM_CHAR
' **************************************************************************
       ' Only allow numbers
       IF (wParam >= 48 and wParam <= 57) OR wParam = VK_BACK THEN
           FUNCTION = CallWindowProc(lpEdit1_Proc, hWnd, Msg, wParam, lParam)
       END IF

' **************************************************************************
    CASE ELSE
' **************************************************************************
        ' No messages have been processed
        FUNCTION = CallWindowProc(lpEdit1_Proc, hWnd, Msg, wParam, lParam)
    END SELECT

    ' Default message has been processed
    FUNCTION = TRUE
END FUNCTION

' -------------------------------------------------------------------------
'   INPUT: hWnd AS HWND, Msg AS UINT, wParam AS WPARAM, lParam AS LPARAM
'  OUTPUT: TRUE
' PURPOSE: Handles messages for the push button control sent by Windows.
' -------------------------------------------------------------------------
CALLBACK FUNCTION Button1_Proc()
    DIM Buffer$

    SELECT CASE Msg
' **************************************************************************
    CASE WM_COMMAND
' **************************************************************************
        GetWindowText(Edit1, Buffer$, 10)
        IF LEN(Buffer$) > 0 THEN
            IF ViewError(VAL(Buffer$)) = TRUE THEN
                SetWindowText(Static3, szGDesc$)
            ELSE
                SetWindowText(Static3, "Error code does not exist.")
            END IF
        END IF

' **************************************************************************
    CASE ELSE
' **************************************************************************
        ' No messages have been processed
        FUNCTION = CallWindowProc(lpButton1_Proc, hWnd, Msg, wParam, lParam)
    END SELECT

    ' Default message has been processed
    FUNCTION = TRUE
END FUNCTION

' -------------------------------------------------------------------------
'   INPUT: hWnd AS HWND
'  OUTPUT: none
' PURPOSE: Moves a window to the center of the screen.
' -------------------------------------------------------------------------
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

' -------------------------------------------------------------------------
'   INPUT: iError
'  OUTPUT: TRUE if error exists, otherwise FALSE
' PURPOSE: Seeks error code in file and places it in the global buffer
' -------------------------------------------------------------------------
FUNCTION ViewError(iError)
    DIM szBuffer$

    ' data file MUST exist
    assert(EXIST("error.dat") == -1)
    szGDesc$ = ""

    OPEN "error.dat" FOR INPUT AS FP1
        WHILE NOT EOF(FP1)
            LINE INPUT FP1, szBuffer$

            IF iError = VAL(LEFT$(szBuffer$, 4)) THEN
                szGDesc$ = RIGHT$(szBuffer$, LEN(szBuffer$) - 8)

                CLOSE FP1
                FUNCTION = TRUE
            END IF
        WEND
    CLOSE FP1

    FUNCTION = FALSE
END FUNCTION
