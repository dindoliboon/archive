' //////////////////////////////////////////////////////////////////////////
' > main.bas 1.01 10:20 PM 8/15/2001                           Main Dialog <
' \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'
' This is the main program which contains the initial window
' information, as well as links to the required includes.
'
' Globals and constants are also included in this file.
'
' History
'    1.0  -> 11:54 AM  8/15/2001
'    1.01 -> 10:20 PM  8/15/2001
'
' Copyright (c) 2001 DL
' All Rights Reserved.
'
' \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'                           CONSTANTS AND GLOBALS
' //////////////////////////////////////////////////////////////////////////

CONST MAX_COLUMNS              = 7
CONST LITESFV_TB_SETBUTTONINFO = WM_USER + 66

' this tells BCX to turn off processing of the \ slash
$IPRINT_OFF
CONST szFilter$     = "All Files (*.*)\0*.*\0SFV Files (*.sfv)\0*.sfv\0\0"
' turn on processing of \ slahes
' remember, C/C++ use \\ instead of a single \ slash
$IPRINT_ON
' NEW ## 1.01 // registry location
CONST szSubKey$     = "Software\DL Software\LiteSFV\"
' NEW ## 1.01 // registry location
CONST szWait$       = " Waiting for command..."
CONST szObtn$       = " Obtaining file names..."
CONST szCalc$       = " Calculating CRC-32..."
CONST CaptionName1$ = "LiteSFV"
CONST ClassName1$   = "Class Name"
CONST szINI$        = "litesfv.ini"

TYPE MY_INI
  rc                 AS RECT
  dwChunk            AS DWORD
  dwCol[MAX_COLUMNS] AS DWORD
  iPt[3]             AS INTEGER

  ' a bit-field for save boolean values
  ! unsigned bOnTop    : 1;
  ! unsigned bNotify   : 1;
  ! unsigned bDisplay  : 1;
  ! unsigned bVerify   : 1;
  ! unsigned bCtlFlag  : 1;
  ! unsigned bCancel   : 1;
  ! unsigned bTruePath : 1;
  ! unsigned bRoundNo  : 1;

  ' gotta be careful with this bit-field
  ' these values are automatically saved
  ! unsigned bInScan   : 1;
  ! unsigned bStartUp  : 1;
  ! unsigned bScanSFV  : 1;
  ! unsigned bTmpTest  : 1;
  ! unsigned bOneTime  : 1;
  ! unsigned bReserved : 3;
END TYPE

GLOBAL szColumns$[MAX_COLUMNS]
GLOBAL szItems$  [MAX_COLUMNS]
GLOBAL hInstance AS HINSTANCE
GLOBAL MainMenu  AS HANDLE
GLOBAL tbb       AS TBBUTTON
GLOBAL uiGood    AS UINT
GLOBAL uiBad     AS UINT
GLOBAL uiMiss    AS UINT
GLOBAL myi       AS MY_INI
GLOBAL szStop$

' this gives us global access to the command-line
GLOBAL _ARGC AS INTEGER
GLOBAL _ARGV AS PCHAR*

' \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'                        START OF CONSOLE APPLICATION
' //////////////////////////////////////////////////////////////////////////

' Yes, this is really a CONSOLE application!
' Made good use of the Split Personality example ...
'
' Before I started this app, I wanted to make a program
' that received data from the right-click menus in explorer.
'
' But there had to be another way instead of using COM. That
' way is to process the arguments presented in the command-line.
'
' However, there is no generic command-line parser for GUI
' applications, unless your on NT, which is why this has been
' made as a console application.
'
' If the command-line is detected to have data, we will copy the
' string data to a temporary buffer. Then we can just setup a
' boolean flag to notify the listview that we have data ready
' to be added to the listview.

IF LEN(COMMAND$) THEN
  _ARGC = argc ' console integer that contains number of arguments
  _ARGV = argv ' console character array that contains arguments
END IF

' now lets start the real application!
FUNCTION = StartMain(GetModuleHandle(NULL))

' \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'                         END OF CONSOLE APPLICATION
' //////////////////////////////////////////////////////////////////////////

' --------------------------------------------------------------------------
' DESCRIPTION: Registers our application
'       INPUT: hInst AS HINSTANCE
'      OUTPUT: Integer with exit value
'       USAGE: StartMain(GetModuleHandle(NULL))
'     RETURNS: 0
' --------------------------------------------------------------------------
FUNCTION StartMain(hInst AS HINSTANCE)
  LOCAL Wc AS WNDCLASS
  LOCAL Msg AS MSG

  ' global message that you will see attached to every message box
  szStop$ = CRLF$ & CRLF$ & "Goto the menu Tools -> Options" & CRLF$ & _
            "to disable this message."

  ' register our main window
  Wc.style         = CS_HREDRAW OR CS_VREDRAW OR CS_DBLCLKS
  Wc.lpfnWndProc   = WndProc1
  Wc.cbClsExtra    = 0
  Wc.cbWndExtra    = 0
  Wc.hInstance     = hInstance = hInst
  Wc.hIcon         = LoadIcon(hInst, MAKEINTRESOURCE(IDI_MAIN))
  Wc.hCursor       = LoadCursor(NULL, IDC_ARROW)
  Wc.hbrBackground = GetSysColorBrush(COLOR_BTNFACE)
  Wc.lpszMenuName  = NULL
  Wc.lpszClassName = ClassName1$
  RegisterClass(&Wc)

  ' init common controls and get INI name
  InitCommonControls()

  ' setup columns to have an 80 pixel width
  DIM wCnt AS WORD
  FOR wCnt = 0 TO MAX_COLUMNS - 1
    myi.dwCol[wCnt] = 80
  NEXT

  ' setup default listview values
  myi.rc.left   = myi.rc.top = 0
  myi.rc.right  = 395
  myi.rc.bottom = 322
  myi.bNotify   = myi.bCancel  = myi.bDisplay  = myi.bVerify  = TRUE
  myi.bOnTop    = myi.bScanSFV = myi.bTruePath = myi.bRoundNo = FALSE
  myi.dwChunk   = 262144
  myi.iPt[0]    = 80
  myi.iPt[1]    = 175
  myi.iPt[2]    = -1

' NEW ## 1.01 // loads registry data
  IF LoadRegData() THEN
    myi.bOneTime = FALSE
  ELSE
    ' if it does not exist, it must be the first time,
    ' so the about dialog will be shown
    RichMain(hInstance)
    myi.bOneTime = TRUE
  END IF
' NEW ## 1.01 // loads registry data

  ' setup default values
  myi.bCtlFlag = myi.bInScan = FALSE
  myi.bStartUp = TRUE

  ' load main application
  FormLoad(hInst)

  WHILE GetMessage(&Msg, NULL, 0, 0)
    IF Msg.message = WM_KEYDOWN THEN
      IF Msg.wParam = VK_CONTROL THEN myi.bCtlFlag = TRUE
    END IF

    ' watch for key commands by watching the messages directly
    IF Msg.message = WM_KEYUP THEN
      SELECT CASE Msg.wParam
      CASE VK_CONTROL
        myi.bCtlFlag = FALSE
      CASE 0x4E ' N
        IF myi.bCtlFlag = TRUE THEN SNDMSG(Form1, WM_COMMAND, IDM_NEW, 0)
      CASE 0x4F ' O
        IF myi.bCtlFlag = TRUE THEN SNDMSG(Form1, WM_COMMAND, IDM_OPEN, 0)
      CASE 0x53 ' S
        IF myi.bCtlFlag = TRUE THEN SNDMSG(Form1, WM_COMMAND, IDM_SAVE, 0)
      END SELECT
    END IF

    IF NOT IsWindow(GetActiveWindow()) OR NOT _
      IsDialogMessage(GetActiveWindow(), &Msg) THEN
      TranslateMessage(&Msg)
      DispatchMessage(&Msg)
    END IF
  WEND

  FUNCTION = Msg.wParam
END FUNCTION

' --------------------------------------------------------------------------
' DESCRIPTION: Processes messages sent to the main window
'       INPUT: hWnd as HWND, Msg as UINT, wParam as WPARAM, lParam as LPARAM
'      OUTPUT: Depends on the message sent
'       USAGE: WndProc1(hWnd, WM_COMMAND, 0, 0)
'     RETURNS: 0
' --------------------------------------------------------------------------
CALLBACK FUNCTION WndProc1()
  ' used for open/save dialogs
  ! OPENFILENAME ofn;
  ! char szFileName[260];

  SELECT CASE Msg
' **************************************************************************
  CASE WM_COMMAND
' **************************************************************************
  SELECT CASE LOWORD(wParam)
  CASE IDM_NEW
    ' check if scan is not in the process
    IF myi.bInScan THEN FUNCTION = 0

    ' delete all listview items by default
    IF ListView_GetItemCount(ListView) THEN
      IF VerifyThis("Are you sure you want to clear the list?") = _
        IDYES THEN ListView_DeleteAllItems(ListView)
    ELSE
      DisplayError("What are you talking about? The list is empty!")
    END IF
  CASE IDM_OPEN
    ' check if scan is not in the process
    IF myi.bInScan THEN FUNCTION = 0

    ' initialize OPENFILENAME
    ZeroMemory(&ofn, sizeof(OPENFILENAME))
    ZeroMemory(szFileName, 260)

    ofn.lStructSize     = sizeof(OPENFILENAME)
    ofn.hwndOwner       = hWnd
    ofn.lpstrFile       = szFileName
    ofn.nMaxFile        = sizeof(szFileName)
    ofn.lpstrFilter     = szFilter$
    ofn.nFilterIndex    = 1
    ofn.lpstrFileTitle  = NULL
    ofn.nMaxFileTitle   = 0
    ofn.lpstrInitialDir = NULL
    ofn.lpstrTitle      = "Open which SFV file?"
    ofn.Flags           = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST

    IF GetOpenFileName(&ofn) = TRUE THEN
      IF EXIST(szFileName$) = -1 THEN
        ' if the file exists, clear all scanning settings
        ListView_DeleteAllItems(ListView)
        ClearScanValues()
        AddFileToList(szFileName$)

        ' check if theirs anything to scan
        IF ListView_GetItemCount(ListView) THEN
          StartScan()
        ELSE
          DisplayError("What are you trying to open? The file is empty!")
          myi.bInScan = FALSE
        END IF
      END IF
    END IF
  CASE IDM_SAVE
    ' check if scan is not in the process or listview is not empty
' NEW ## 1.01 // checks for missing total
    IF (uiGood + uiBad = 0) OR (myi.bInScan) OR _
       (ListView_GetItemCount(ListView) = 0) THEN FUNCTION = 0
' NEW ## 1.01 // checks for missing total

    ' initialize OPENFILENAME
    ZeroMemory(&ofn, sizeof(OPENFILENAME))
    ZeroMemory(szFileName, 260)

    ofn.lStructSize     = sizeof(OPENFILENAME)
    ofn.hwndOwner       = hWnd
    ofn.lpstrFile       = szFileName
    ofn.nMaxFile        = sizeof(szFileName)
    ofn.lpstrFilter     = szFilter$
    ofn.nFilterIndex    = 1
    ofn.lpstrFileTitle  = NULL
    ofn.nMaxFileTitle   = 0
    ofn.lpstrInitialDir = NULL
    ofn.lpstrTitle      = "Save the SFV as?"
    ofn.Flags           = OFN_PATHMUSTEXIST

    IF GetSaveFileName(&ofn) = TRUE THEN
      ' write SFV to disk
      MakeSfv(szFileName$)
    END IF
  CASE IDM_EXIT
    ' close main window
    SendMessage(hWnd, WM_CLOSE, 0, 0)
  CASE IDM_CHUNK
    ' check if scan is not in the process
    IF myi.bInScan THEN FUNCTION = 0

    ' show settings dialog
    DialogBox(hInstance, MAKEINTRESOURCE(IDD_FORM2), hWnd, _
      (DLGPROC)Form2_Proc)
     SetActiveWindow(hWnd)
  CASE IDM_ONTOP
    IF myi.bOnTop = TRUE THEN
      CheckMenuItem(MainMenu, IDM_ONTOP, MF_BYCOMMAND OR MF_UNCHECKED)
      SetWindowPos(hWnd, HWND_NOTOPMOST, 0, 0, 0, 0, _
        SWP_NOSIZE OR SWP_NOMOVE OR SWP_NOACTIVATE)
      myi.bOnTop = FALSE
    ELSE
      CheckMenuItem(MainMenu, IDM_ONTOP, MF_BYCOMMAND OR MF_CHECKED)
      SetWindowPos(hWnd, HWND_TOPMOST, 0, 0, 0, 0, _
        SWP_NOSIZE OR SWP_NOMOVE OR SWP_NOACTIVATE)
      myi.bOnTop = TRUE
    END IF
  CASE IDM_ROUND
    IF myi.bRoundNo = TRUE THEN
      CheckMenuItem(MainMenu, IDM_ROUND, MF_BYCOMMAND OR MF_UNCHECKED)
      myi.bRoundNo = FALSE
    ELSE
      CheckMenuItem(MainMenu, IDM_ROUND, MF_BYCOMMAND OR MF_CHECKED)
      myi.bRoundNo = TRUE
    END IF
  CASE IDM_TRUEPATH
    IF myi.bTruePath = TRUE THEN
      CheckMenuItem(MainMenu, IDM_TRUEPATH, MF_BYCOMMAND OR MF_UNCHECKED)
      myi.bTruePath = FALSE
    ELSE
      IF NOT myi.bStartUp THEN
        IF VerifyThis("This might break other SFV programs, OK?") = _
          IDYES THEN
          CheckMenuItem(MainMenu, IDM_TRUEPATH, MF_BYCOMMAND OR MF_CHECKED)
          myi.bTruePath = TRUE
        END IF
      ELSE
        CheckMenuItem(MainMenu, IDM_TRUEPATH, MF_BYCOMMAND OR MF_CHECKED)
        myi.bTruePath = TRUE
      END IF
    END IF
  CASE IDM_SCANSFV
    IF myi.bScanSFV = TRUE THEN
      CheckMenuItem(MainMenu, IDM_SCANSFV, MF_BYCOMMAND OR MF_UNCHECKED)
      myi.bScanSFV = FALSE
    ELSE
      CheckMenuItem(MainMenu, IDM_SCANSFV, MF_BYCOMMAND OR MF_CHECKED)
      myi.bScanSFV = TRUE
    END IF
  CASE IDM_VERIFY
    ' check if scan is not in the process
    IF myi.bInScan THEN FUNCTION = 0

    IF ListView_GetItemCount(ListView) = 0 THEN
      DisplayError("There is nothing to verify!")
    ELSE
      ClearScanValues()

      DIM dwTmp

      ' make sure file info is cleared out
      FOR dwTmp = 0 to ListView_GetItemCount(ListView) - 1
        ListView_SetItemText(ListView, dwTmp, 1, "")
        ListView_SetItemText(ListView, dwTmp, 2, "")
        ListView_SetItemText(ListView, dwTmp, 3, "")
        ListView_SetItemText(ListView, dwTmp, 4, "")
      NEXT

      StartScan()
    END IF
  CASE IDC_CANCEL
    IF myi.bCancel = TRUE THEN
      ResumeButton("Pause")
      myi.bCancel = FALSE
      StartScanThread()
    ELSE
      ResumeButton("Resume")
      myi.bCancel = TRUE
    END IF
  CASE IDM_ABOUT
    ShowWindow(Form1, SW_HIDE)
    RichMain(hInstance)
    ShowWindow(Form1, SW_SHOW)
  END SELECT

' **************************************************************************
  CASE WM_DROPFILES
' **************************************************************************
  DIM uNumFiles AS UINT
  DIM uFile AS UINT
  DIM szFile$

  ' reset all scanning values
  ' 
  ' drag n' drop starts all values from scratch
  SendMessage(StatusBar, SB_SETTEXT, 2, szObtn$)
  ClearScanValues()
  ListView_DeleteAllItems(ListView)

  uNumFiles = DragQueryFile ((HDROP)wParam, 0xFFFFFFFF, NULL, 0)
  IF uNumFiles THEN
    FOR uFile = 0 TO uNumFiles - 1
      ' check for any drag n' drop errors
      IF DragQueryFile((HDROP)wParam, uFile, szFile$, 2047) = 0 THEN
        EXIT FOR
      END IF

      AddFileToList(szFile$)
    NEXT
  END IF

  ' bring main window back to the top
  SetForegroundWindow(hWnd)

  ' initialize scanner after drag n' drop
  StartScan()

' **************************************************************************
  CASE WM_NOTIFY
' **************************************************************************
  DIM lpNotify AS LPNMHDR
  DIM szTT$
  DIM szTmp$

  ' this will watch the WM_NOTIFY for any tooltip requests

  lpNotify = (LPNMHDR)lParam
  IF lpNotify->hwndFrom = hToolTips THEN
    SELECT CASE wParam
    CASE IDM_NEW    : szTT$ = " New SFV"
    CASE IDM_OPEN   : szTT$ = " Open SFV"
    CASE IDM_SAVE   : szTT$ = " Save SFV"
    CASE IDM_EXIT   : szTT$ = " Exit Program"
    CASE IDM_VERIFY : szTT$ = " Verify List"
    CASE IDC_CANCEL : szTT$ = " Pause / Resume"
    END SELECT

    SendMessage(StatusBar, SB_GETTEXT, 1, szTmp$)
    IF szTmp$ <> szTT$ THEN SendMessage(StatusBar, SB_SETTEXT, 1, szTT$)
  END IF

' **************************************************************************
  CASE WM_SIZE
' **************************************************************************
  MoveWindow(Toolbar, 0, 0, LOWORD(lParam), 24, TRUE)
  MoveWindow(StatusBar, 0, 0, 0, 0, TRUE)
  MoveWindow(ListView, 0, 24, LOWORD(lParam), HIWORD(lParam) - 44, TRUE)
  SendMessage(StatusBar, SB_SETPARTS, 3, &myi.iPt)

  FUNCTION = 0

' **************************************************************************
  CASE WM_CLOSE
' **************************************************************************
  ' restore window so we can save the proper RECT values
  IF IsIconic(hWnd) OR IsZoomed(hWnd) THEN
    ShowWindow(hWnd, SW_RESTORE)
  END IF

' NEW ## 1.01 // saves to registry
  ' a huge majority values in the MY_INI structure already
  ' contain the custom values, so we just need to worry
  ' about the other ones, not modified by the settings dialog

  GetWindowRect(hWnd, &myi.rc)

  DIM wCnt AS WORD
  FOR wCnt = 0 TO MAX_COLUMNS - 1
    myi.dwCol[wCnt] = ListView_GetColumnWidth(ListView, wCnt)
  NEXT

  StoreRegData()
' NEW ## 1.01 // saves to registry

  DestroyWindow(hWnd)
  FUNCTION = 0

' **************************************************************************
  CASE WM_DESTROY
' **************************************************************************
  PostQuitMessage(0)
  FUNCTION = 0

' **************************************************************************
  END SELECT
' **************************************************************************

  FUNCTION = DefWindowProc(hWnd, Msg, wParam, lParam)
END FUNCTION

' --------------------------------------------------------------------------
' DESCRIPTION: Contains code to create main window and children controls
'       INPUT: hInst AS HINSTANCE
'      OUTPUT: n/a
'       USAGE: FormLoad(hInstance)
'     RETURNS: n/a
' --------------------------------------------------------------------------
SUB FormLoad(hInst AS HINSTANCE)
  GLOBAL Form1 AS HWND

  Form1 = CreateWindow(ClassName1$, CaptionName1$, WS_MINIMIZEBOX OR _
    WS_MAXIMIZEBOX OR WS_POPUP OR WS_CLIPSIBLINGS OR WS_CLIPCHILDREN OR _
    WS_CAPTION OR WS_SYSMENU OR WS_THICKFRAME, myi.rc.left, myi.rc.top, _
    myi.rc.right - myi.rc.left, myi.rc.bottom - myi.rc.top, NULL, NULL, _
    hInst, NULL)

' **************************************************************************

  GLOBAL  Toolbar AS HWND

  Toolbar = CreateToolbarEx(Form1, TBSTYLE_TOOLTIPS OR TBSTYLE_LIST OR _
    CCS_NORESIZE OR TBSTYLE_FLAT OR WS_CHILD OR WS_TABSTOP OR WS_VISIBLE, _
    ID_Toolbar, 17, HINST_COMMCTRL, IDB_STD_SMALL_COLOR, _
    (LPCTBBUTTON)NULL, 0, 16, 16, 0, 0, sizeof(TBBUTTON))

  ' add toolbar buttons and disable pause

  Toolbar_AddButton(IDM_NEW, STD_FILENEW, "")
  Toolbar_AddButton(IDM_OPEN, STD_FILEOPEN, "")
  Toolbar_AddButton(IDM_SAVE, STD_FILESAVE, "")
  Toolbar_AddSeparator()

  Toolbar_AddButton(IDM_VERIFY, STD_PRINTPRE, "Verify")
  Toolbar_AddButton(IDM_EXIT, STD_REDOW, "Exit")
  Toolbar_AddSeparator()

  Toolbar_AddButton(IDC_CANCEL, STD_UNDO, "Pause")
  SNDMSG(Toolbar, TB_ENABLEBUTTON, IDC_CANCEL, MAKELPARAM(FALSE, 0))

' **************************************************************************

  GLOBAL hToolTips AS HWND

  hToolTips = (HWND)SendMessage(Toolbar, TB_GETTOOLTIPS, 0, 0)
  SendMessage(hToolTips, TTM_SETDELAYTIME, TTDT_INITIAL, 0)
  SendMessage(hToolTips, TTM_SETDELAYTIME, TTDT_RESHOW, 0)

' **************************************************************************

  GLOBAL  ListView AS HWND

  ListView = CreateWindowEx(WS_EX_CLIENTEDGE, WC_LISTVIEW, "", _
    WS_CHILD OR WS_TABSTOP OR WS_VISIBLE OR LVS_REPORT OR _
    LVS_NOSORTHEADER, 0, 0, 0, 0, Form1, ID_ListView, hInst, NULL)

  SendMessage(ListView, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, _
    LVS_EX_FULLROWSELECT or LVS_EX_GRIDLINES)

' **************************************************************************

  GLOBAL  StatusBar AS HWND

  StatusBar = CreateStatusWindow(WS_CHILD OR WS_VISIBLE, "", Form1, _
     ID_StatusBar)

  SendMessage(StatusBar, SB_SETTEXT, 0 | SBT_NOBORDERS, NULL)
  SendMessage(StatusBar, SB_SETTEXT, 1 | 0, NULL)
  SendMessage(StatusBar, SB_SETTEXT, 2 | 0, NULL)

' **************************************************************************

  GLOBAL  ProgressBar1 AS HANDLE

  ProgressBar1 = CreateWindowEx(0, PROGRESS_CLASS, "", WS_CHILD OR _
    WS_TABSTOP OR WS_VISIBLE OR PBS_SMOOTH, 0, 2, myi.iPt[0], 8, _
    StatusBar, ID_ProgressBar1, hInst, NULL)

' **************************************************************************

  GLOBAL  ProgressBar2 AS HANDLE

  ProgressBar2 = CreateWindowEx(0, PROGRESS_CLASS, "", WS_CHILD OR _
    WS_TABSTOP OR WS_VISIBLE OR PBS_SMOOTH, 0, 12, myi.iPt[0], 8, _
    StatusBar, ID_ProgressBar2, hInst, NULL)

' **************************************************************************

  MainMenu = LoadMenu(hInst, MAKEINTRESOURCE(IDM_MAIN))
  SetMenu(Form1, MainMenu)

' **************************************************************************

  ' initialize listview columns
  szColumns$[0] = "Name"
  szColumns$[1] = "Size"
  szColumns$[2] = "Modified"
  szColumns$[3] = "True CRC-32"
  szColumns$[4] = "Status"
  szColumns$[5] = "SFV"
  szColumns$[6] = "CRC-32 in SFV"
  ListView_AddColumn(MAX_COLUMNS)

' **************************************************************************

  DIM wCnt AS WORD

  ' resize all columns based on sizing within the MY_INI structure
  FOR wCnt = 0 TO MAX_COLUMNS - 1
    ListView_SetColumnWidth(ListView, wCnt, myi.dwCol[wCnt])
  NEXT

  ' reverse values using XOR
  ' alternative to
  '   IF myi.bTruePath = TRUE THEN
  '     myi.bTruePath = FALSE
  '   ELSE
  '     myi.bTruePath = TRUE
  '   END IF
  myi.bTruePath ^= TRUE
  myi.bOnTop    ^= TRUE
  myi.bRoundNo  ^= TRUE
  myi.bScanSFV  ^= TRUE

  ' apply settings
  SNDMSG(Form1, WM_COMMAND, MAKEWPARAM(IDM_SCANSFV, 0)   , 0)
  SNDMSG(Form1, WM_COMMAND, MAKEWPARAM(IDM_ONTOP, 0)   , 0)
  SNDMSG(Form1, WM_COMMAND, MAKEWPARAM(IDM_TRUEPATH, 0), 0)
  SNDMSG(Form1, WM_COMMAND, MAKEWPARAM(IDM_ROUND, 0)   , 0)

  ' setup statusbar
  SendMessage(StatusBar, SB_SETPARTS, 3, &myi.iPt)
  SendMessage(StatusBar, SB_SETTEXT, 2, szWait$)

' **************************************************************************

  InitTable()                  ' initialize CRC-32 table
  DragAcceptFiles(Form1, TRUE) ' enable drag n' drop

  IF myi.bOneTime = TRUE THEN  ' center window on first run only
    CenterWindow(Form1)
  END IF

' **************************************************************************

  DIM dwCnt AS DWORD
  DIM lvfi  AS LVFINDINFO

  IF _ARGC >= 2 THEN

    ' if we have command-line arguments,
    ' check if they actually exist, then
    ' add them to the list

    FOR dwCnt = 1 TO _ARGC - 1
      IF (EXIST(_ARGV[dwCnt]) = -1) THEN AddFileToList(_ARGV[dwCnt])
    NEXT

    IF ListView_GetItemCount(ListView) THEN
      StartScan()
    ELSE
      myi.bInScan = FALSE
    END IF
  ELSE
  END IF

' **************************************************************************

  ' redraw and show window
  UpdateWindow(Form1)
  ShowWindow(Form1, SW_SHOWNORMAL)

  ' end of startup
  myi.bStartUp = FALSE
END SUB

' //////////////////////////////////////////////////////////////////////////
' > 675 lines for BCX-32 2.41d                          End of Main Dialog <
' \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
