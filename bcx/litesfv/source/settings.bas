' //////////////////////////////////////////////////////////////////////////
' > settings.bas 1.0 11:54 AM 8/15/2001                    Settings Dialog <
' \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'
' Contains procedures for the settings dialog.
'
' Copyright (c) 2001 DL
' All Rights Reserved.
'
' //////////////////////////////////////////////////////////////////////////

' --------------------------------------------------------------------------
' DESCRIPTION: Processes messages sent to the settings dialog
'       INPUT: hWnd as HWND, Msg as UINT, wParam as WPARAM, lParam as LPARAM
'      OUTPUT: Depends on the message sent
'       USAGE: Form2_Proc(hWnd, WM_COMMAND, 0, 0)
'     RETURNS: 0
' --------------------------------------------------------------------------
CALLBACK FUNCTION Form2_Proc()
  GLOBAL Form2         AS HWND
  GLOBAL Edit1         AS HWND
  GLOBAL Edit2         AS HWND
  GLOBAL Edit3         AS HWND
  GLOBAL Edit4         AS HWND
  GLOBAL Check1        AS HWND
  GLOBAL Check2        AS HWND
  GLOBAL Check3        AS HWND
  GLOBAL lpEdit1_Proc  AS FARPROC
  GLOBAL lpCheck1_Proc AS FARPROC
 
  SELECT CASE Msg
' **************************************************************************
  CASE WM_INITDIALOG
' **************************************************************************
  ' Retrieves the dialog/control handles
  Form2 = hWnd
  Edit1 = GetDlgItem(hWnd, IDC_EDIT1)
  Edit2 = GetDlgItem(hWnd, IDC_EDIT2)
  Edit3 = GetDlgItem(hWnd, IDC_EDIT3)
  Edit4 = GetDlgItem(hWnd, IDC_EDIT4)

  Check1 = GetDlgItem(hWnd, IDC_CHECK1)
  Check2 = GetDlgItem(hWnd, IDC_CHECK2)
  Check3 = GetDlgItem(hWnd, IDC_CHECK3)

  ' Give controls seperate proc functions
  lpEdit1_Proc = SubclassWindow(Edit1, Edit1_Proc)
                 SubclassWindow(Edit2, Edit1_Proc)
                 SubclassWindow(Edit3, Edit1_Proc)
                 SubclassWindow(Edit4, Edit1_Proc)

  lpCheck1_Proc = SubclassWindow(Check1, Check1_Proc)
                  SubclassWindow(Check2, Check1_Proc)
                  SubclassWindow(Check3, Check1_Proc)

  ' Set other window properties
  CenterWindow(hWnd)

  ' setup the edit text controls
  SetWindowText(Edit1, TRIM$(STR$(myi.dwChunk)))
  SetWindowText(Edit2, TRIM$(STR$(myi.iPt[0])))
  SetWindowText(Edit3, TRIM$(STR$(myi.iPt[1])))
  SetWindowText(Edit4, TRIM$(STR$(myi.iPt[2])))

  ' setup the checkboxes
  Button_SetCheck(Check1, myi.bNotify)
  Button_SetCheck(Check2, myi.bDisplay)
  Button_SetCheck(Check3, myi.bVerify)

' **************************************************************************
  CASE WM_CLOSE
' **************************************************************************
  DIM szBuffer$
  DIM dwValue AS DWORD

  ' get values from the checkboxes
  myi.bNotify  = Button_GetCheck(Check1)
  myi.bDisplay = Button_GetCheck(Check2)
  myi.bVerify  = Button_GetCheck(Check3)

  ' get values from the edit controls
  GetWindowText(Edit2, szBuffer$, 2047)
  myi.iPt[0] = VAL(szBuffer$)

  GetWindowText(Edit3, szBuffer$, 2047)
  myi.iPt[1] = VAL(szBuffer$)

  GetWindowText(Edit4, szBuffer$, 2047)
  myi.iPt[2] = VAL(szBuffer$)

  GetWindowText(Edit1, szBuffer$, 2047)
  dwValue = VAL(szBuffer$)

  ' make sure that the chunk size is valid  
  IF dwValue > 0 THEN
    myi.dwChunk = dwValue
    SendMessage(StatusBar, SB_SETPARTS, 3, &myi.iPt)
    SetWindowPos(ProgressBar1, 0, 0, 0, myi.iPt[0], 8, SWP_NOMOVE OR _
      SWP_NOZORDER)
    SetWindowPos(ProgressBar2, 0, 0, 0, myi.iPt[0], 8, SWP_NOMOVE OR _
      SWP_NOZORDER)

    EndDialog(hWnd, TRUE)
  ELSE
    SetWindowText(Edit1, "262144")
    EXIT FUNCTION
  END IF

' **************************************************************************
    CASE ELSE
' **************************************************************************
  ' No messages processed, return false
  FUNCTION = FALSE

' **************************************************************************
  END SELECT
' **************************************************************************

  ' If we reach this point, that means a message was processed
  ' and we send a true value
  FUNCTION = TRUE
END FUNCTION

' --------------------------------------------------------------------------
' DESCRIPTION: Processes messages sent to the edit control
'       INPUT: hWnd as HWND, Msg as UINT, wParam as WPARAM, lParam as LPARAM
'      OUTPUT: Depends on the message sent
'       USAGE: Edit1_Proc(hWnd, WM_COMMAND, 0, 0)
'     RETURNS: 0
' --------------------------------------------------------------------------
CALLBACK FUNCTION Edit1_Proc()
  SELECT CASE Msg
' **************************************************************************
  CASE WM_KEYUP
' **************************************************************************
  IF wParam = VK_ESCAPE THEN SendMessage(Form2, WM_CLOSE, 0, 0)

' **************************************************************************
  CASE WM_CHAR
' **************************************************************************
  ' Only allow numbers
  IF (hWnd <> Edit1 AND wParam = 0x2D) OR (wParam >= 48 and wParam <= 57) _
    OR wParam = VK_BACK THEN
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

' --------------------------------------------------------------------------
' DESCRIPTION: Processes messages sent to the check control
'       INPUT: hWnd as HWND, Msg as UINT, wParam as WPARAM, lParam as LPARAM
'      OUTPUT: Depends on the message sent
'       USAGE: Check1_Proc(hWnd, WM_COMMAND, 0, 0)
'     RETURNS: 0
' --------------------------------------------------------------------------
CALLBACK FUNCTION Check1_Proc()
  SELECT CASE Msg
' **************************************************************************
  CASE WM_KEYUP
' **************************************************************************
  IF wParam = VK_ESCAPE THEN SendMessage(Form2, WM_CLOSE, 0, 0)

' **************************************************************************
    CASE ELSE
' **************************************************************************
        ' No messages have been processed
        FUNCTION = CallWindowProc(lpCheck1_Proc, hWnd, Msg, wParam, lParam)
    END SELECT

    ' Default message has been processed
    FUNCTION = TRUE
END FUNCTION

' //////////////////////////////////////////////////////////////////////////
' > 186 lines for BCX-32 2.41d                      End of Settings Dialog <
' \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
