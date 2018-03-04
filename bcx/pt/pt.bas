#include <mmsystem.h>

' **************************************************************************
'            BCX Source Code Generated Using Dialog Starter 1.0
'                 For Use With BCX Translator Version 2.15+
' **************************************************************************

    ' Global Constants (Dialog/Control IDs)
    CONST IDD_FORM1 = 100
    CONST IDC_GROUP1 = 101
    CONST IDC_STATIC1 = 102
    CONST IDC_STATIC2 = 103
    CONST IDC_STATIC3 = 104
    CONST IDC_EDIT1 = 105
    CONST IDC_BUTTON1 = 106

    ' Global Variables (Dialog/Control Handles)
    GLOBAL hInstance AS HINSTANCE
    GLOBAL Form1 AS HWND
    GLOBAL Group1 AS HWND
    GLOBAL Static1 AS HWND
    GLOBAL Static2 AS HWND
    GLOBAL Static3 AS HWND
    GLOBAL Edit1 AS HWND
    GLOBAL Button1 AS HWND
    GLOBAL xNumber
    GLOBAL yNumber

    ' Global Proc Variables
    GLOBAL lpButton1_Proc AS FARPROC
    GLOBAL lpEdit1_Proc AS FARPROC

FUNCTION WinMain()
    ' Gives global access to hInstance
    hInstance = hInst

    ' Intialize our dialog, pointing it to the dialog procedure
    DialogBox(hInst, MAKEINTRESOURCE(IDD_FORM1), NULL, (DLGPROC) Form1_Proc)

    FUNCTION = FALSE
END FUNCTION


CALLBACK FUNCTION Form1_Proc()
    SELECT CASE Msg
' **************************************************************************
    CASE WM_INITDIALOG
' **************************************************************************
        ' Retrieves the dialog/control handles
        Form1 = hWnd
        Group1 = GetDlgItem(hWnd, IDC_GROUP1)
        Static1 = GetDlgItem(hWnd, IDC_STATIC1)
        Static2 = GetDlgItem(hWnd, IDC_STATIC2)
        Static3 = GetDlgItem(hWnd, IDC_STATIC3)
        Edit1 = GetDlgItem(hWnd, IDC_EDIT1)
        Button1 = GetDlgItem(hWnd, IDC_BUTTON1)

        ' Give controls seperate proc functions
        lpButton1_Proc = SubclassWindow(Button1, Button1_Proc)
        lpEdit1_Proc = SubclassWindow(Edit1, Edit1_Proc)

        ' Set other window properties
        CenterWindow(hWnd)

        xNumber = 1
        yNumber = 2
        GenerateNumber()

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

CALLBACK FUNCTION Edit1_Proc()
    DIM Buffer$
    DIM check

    SELECT CASE Msg
' **************************************************************************
    CASE WM_KEYUP
' **************************************************************************
        IF wParam = VK_RETURN THEN
            SendMessage(Button1, WM_COMMAND, wParam, lParam)
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

CALLBACK FUNCTION Button1_Proc()
    DIM Buffer$
    DIM check

    SELECT CASE Msg
' **************************************************************************
    CASE WM_COMMAND
' **************************************************************************
        GetWindowText(Edit1, Buffer$, 1023)
        IF LEN(Buffer$) > 0 THEN
            IF VAL(Buffer$) = (xNumber * yNumber) THEN
                ' uncomment below if you have wave files 11.wav - 14.wav
                ' these waves are played when you have a correct answer

                'srand(time(NULL))
                'Buffer$ = TRIM$(STR$((int)mod(rand() * sqrt(rand()), 4) + 11)) & ".wav"
                'PlaySound(Buffer$, 0, SND_FILENAME)
            ELSE
                ' uncomment below if you have wave files 1.wav - 10.wav
                ' these waves are played when you have a wrong answer

                'Buffer$ = TRIM$(STR$((int)mod(rand() * sqrt(rand()), 10) + 1)) & ".wav"
                'PlaySound(Buffer$, 0, SND_FILENAME)
    
                Buffer$ = "The correct answer is" & STR$(xNumber * yNumber)
                MessageBox(Form1, Buffer$, "Wrong!", MB_OK)
            END IF
            GenerateNumber()
            SetWindowText(Edit1, "")
        END IF
        SetFocus(Edit1)
' **************************************************************************
    CASE ELSE
' **************************************************************************
        ' No messages have been processed
        FUNCTION = CallWindowProc(lpButton1_Proc, hWnd, Msg, wParam, lParam)
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

SUB GenerateNumber()
    DIM Buffer$

    srand(time(NULL))
    xNumber = mod(rand() * sqrt(rand()) + yNumber, 15) + 1
    yNumber = mod(rand() * pow(rand() + xNumber, xNumber ), 15) + 1
    Buffer$ = TRIM$(STR$(xNumber)) & " times " & TRIM$(STR$(yNumber)) & "?"

    SetWindowText(Static2, Buffer$)
END SUB
