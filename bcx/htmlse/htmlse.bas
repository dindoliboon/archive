' **************************************************************************
'            BCX Source Code Generated Using Dialog Starter 1.0
'                 For Use With BCX Translator Version 2.15+
' **************************************************************************

    ' Global Constants (Dialog/Control IDs)
    CONST IDD_FORM1 = 100
    CONST IDC_EDIT1 = 103
    CONST IDC_EDIT2 = 105
    CONST IDC_CHECKBOX1 = 106
    CONST IDC_CHECKBOX2 = 107
    CONST IDC_BUTTON1 = 108

    ' Global Variables (Dialog/Control Handles)
    GLOBAL hInstance AS HINSTANCE
    GLOBAL Form1 AS HWND
    GLOBAL Edit1 AS HWND
    GLOBAL Edit2 AS HWND
    GLOBAL CheckBox1 AS HWND
    GLOBAL CheckBox2 AS HWND
    GLOBAL Button1 AS HWND


FUNCTION WinMain()
    ' Gives global access to hInstance
    hInstance = hInst

    ' Intialize our dialog, pointing it to the dialog procedure
    DialogBox(hInst, MAKEINTRESOURCE(IDD_FORM1), NULL, (DLGPROC) Form1_Proc)

    FUNCTION = FALSE
END FUNCTION


CALLBACK FUNCTION Form1_Proc()
    DIM SHARED iURL, iEncode
    DIM fBuffer$, fChar$, fOutput$, fTemp$
    DIM cnt, iChar

    SELECT CASE Msg
' **************************************************************************
    CASE WM_INITDIALOG
' **************************************************************************
        ' Retrieves the dialog/control handles
        Form1 = hWnd
        Edit1 = GetDlgItem(hWnd, IDC_EDIT1)
        Edit2 = GetDlgItem(hWnd, IDC_EDIT2)
        CheckBox1 = GetDlgItem(hWnd, IDC_CHECKBOX1)
        CheckBox2 = GetDlgItem(hWnd, IDC_CHECKBOX2)
        Button1 = GetDlgItem(hWnd, IDC_BUTTON1)

        ' Set other window properties
        CenterWindow(hWnd)
        Button_SetCheck(CheckBox2, TRUE)
        SendMessage(hWnd, WM_COMMAND, MAKEWPARAM(IDC_CHECKBOX2, BN_CLICKED), (LPARAM) CheckBox2)
        iEncode = TRUE

' **************************************************************************
    CASE WM_COMMAND
' **************************************************************************
        IF LOWORD(wParam) = IDC_CHECKBOX1 THEN
            IF iURL THEN
                iURL = FALSE
            ELSE
                iURL = TRUE
            END IF
        END IF

        IF LOWORD(wParam) = IDC_CHECKBOX2 THEN
            IF iEncode THEN
                iEncode = FALSE
                Button_SetText(CheckBox1, "Decode as &URL?")
            ELSE
                iEncode = TRUE
                Button_SetText(CheckBox1, "Encode as &URL?")
            END IF
        END IF
        
        IF LOWORD(wParam) = IDC_BUTTON1 THEN
            GetWindowText(Edit1, fBuffer$, 2046)
            fOutput$ = ""
            FOR cnt = 1 TO LEN(fBuffer$)
                fChar$ = MID$(fBuffer$, cnt, 1)
                IF iEncode THEN
                    iChar = ASC(fChar$)
                    IF iURL THEN
                        IF iChar < 48 or iChar > 57 _
                            and iChar < 65 or iChar > 90 _
                            and iChar < 97 or iChar > 122 THEN
                            fChar$ = HEX$(iChar)
                            fOutput$ = fOutput$ & "%"
    
                            IF LEN(fChar$) <> 2 THEN
                                fOutput$ = fOutput$ & "0"
                            END IF
                        END IF
                        fOutput$ = fOutput$ & fChar$
                    ELSE
                        fOutput$ = fOutput$ & "&#"
                        fOutput$ = fOutput$ & TRIM$(STR$(iChar))
                        fOutput$ = fOutput$ & ";"
                    END IF
                ELSE
                    IF iURL THEN
                        SELECT CASE fChar$
                        CASE "+"
                            fOutput$ = fOutput$ & " "
                        CASE "%"
                            fOutput$ = fOutput$ & CHR$(hex2dec(MID$(fBuffer$, cnt + 1, 2)))
                            cnt += 2
                        CASE ELSE
                            fOutput$ = fOutput$ & fChar$
                        END SELECT
                    ELSE
                        SELECT CASE fChar$
                        CASE "#", "&"
                        CASE ";"
                            fOutput$ = fOutput$ & CHR$(VAL(fTemp$))
                            fTemp$ = ""
                        CASE ELSE
                            fTemp$ = fTemp$ & fChar$
                        END SELECT
                    END IF
                END IF
            NEXT

            SetWindowText(Edit2, fOutput$)
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


' Original FoxPro version by Richard Hendrick
FUNCTION hex2dec(inString$)
    DIM cHex$
    DIM iNumber, iHex, iPower, iLength, i

    iLength = LEN(inString$)
    FOR i = 1 TO iLength
        cHex$ = MID$(inString$, i, 1)
        SELECT CASE UCASE$(cHex$)
        CASE "A" : iHex = 10
        CASE "B" : iHex = 11
        CASE "C" : iHex = 12
        CASE "D" : iHex = 13
        CASE "E" : iHex = 14
        CASE "F" : iHex = 15
        CASE ELSE
            iHex = VAL(cHex$)
        END SELECT

        iPower = pow(16, iLength - i)
        iNumber += (iPower * iHex)
    NEXT

    FUNCTION = iNumber
END FUNCTION
