' //////////////////////////////////////////////////////////////////////////
' > misc.bas 1.01 8:22 PM 8/15/2001                Miscellaneous Functions <
' \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'
' Most of these functions are wrappers for common commands that
' this program uses. Basically, they were designed specifically
' for this program only.
'
' History
'    1.0  -> 11:54 AM  8/15/2001
'    1.01 ->  8:22 PM  8/15/2001
'
' Copyright (c) 2001 DL
' All Rights Reserved.
'
' //////////////////////////////////////////////////////////////////////////

' --------------------------------------------------------------------------
' DESCRIPTION: Loads registry data for LiteSFV
'       INPUT: n/a
'      OUTPUT: TRUE if exists, otherwise FALSE
'       USAGE: iStart = LoadRegData()
'     RETURNS: Depends on existance of key
'         NEW: 1.01
' --------------------------------------------------------------------------
FUNCTION LoadRegData()
  DIM hKey   AS PHKEY
  DIM hValue AS DWORD
  DIM dwSize AS DWORD

  dwSize = sizeof(MY_INI)

  IF RegOpenKeyEx(HKEY_CURRENT_USER, szSubKey$, 0, KEY_QUERY_VALUE, _
    &hKey) = ERROR_SUCCESS THEN
    IF RegQueryValueEx(hKey, szINI$, (LPDWORD)NULL, (LPDWORD)NULL, _
      (LPBYTE)&myi, &dwSize) = ERROR_SUCCESS THEN
      RegCloseKey(hKey)
      FUNCTION = TRUE
    END IF
  END IF
  RegCloseKey(hKey)

  FUNCTION = FALSE
END FUNCTION

' --------------------------------------------------------------------------
' DESCRIPTION: Stores registry data for LiteSFV
'       INPUT: n/a
'      OUTPUT: n/a
'       USAGE: StoreRegData()
'     RETURNS: n/a
'         NEW: 1.01
' --------------------------------------------------------------------------
SUB StoreRegData()
  DIM hKey   AS PHKEY
  DIM hValue AS DWORD
  DIM dwSize AS DWORD

  dwSize = sizeof(MY_INI)

  IF RegCreateKey(HKEY_CURRENT_USER, szSubKey$, &hKey) = ERROR_SUCCESS THEN
    IF RegSetValueEx(hKey, szINI$, 0, REG_BINARY, &myi, dwSize) <> _
      ERROR_SUCCESS THEN
      DisplayLastError()
    END IF
  END IF
  RegCloseKey(hKey)
END SUB

' --------------------------------------------------------------------------
' DESCRIPTION: Calls resume scanning
'       INPUT: n/a
'      OUTPUT: n/a
'       USAGE: StartScan()
'     RETURNS: n/a
' --------------------------------------------------------------------------
SUB StartScan()
  myi.bCancel = TRUE
  SendMessage(Form1, WM_COMMAND, MAKEWORD(IDC_CANCEL, 0), 0)
END SUB

' --------------------------------------------------------------------------
' DESCRIPTION: Resets all scanning values
'       INPUT: n/a
'      OUTPUT: n/a
'       USAGE: ClearScanValues()
'     RETURNS: n/a
' --------------------------------------------------------------------------
SUB ClearScanValues()
  SendMessage(ProgressBar1, PBM_SETPOS, 0, 0)
  SendMessage(ProgressBar2, PBM_SETPOS, 0, 0)
  uiMiss = uiGood = uiBad = 0
  myi.bInScan = TRUE
END SUB

' --------------------------------------------------------------------------
' DESCRIPTION: Adds one file to the listview for scanning
'       INPUT: szFile$
'      OUTPUT: n/a
'       USAGE: AddFileToList(szFileName$)
'     RETURNS: n/a
' --------------------------------------------------------------------------
SUB AddFileToList(szFile$)
  DIM lvfi AS LVFINDINFO

  ' check if file is really a directory
  IF (GetFileAttributes(szFile$) & FILE_ATTRIBUTE_DIRECTORY) <> 16 THEN
    myi.bInScan = TRUE

    ' check if the file has an SFV extension
    IF LCASE$(RIGHT$(szFile$, 3)) = "sfv" THEN
      myi.bTmpTest = TRUE
    ELSE
      myi.bTmpTest = FALSE
    END IF

    IF (myi.bScanSFV = TRUE AND myi.bTmpTest = TRUE) OR _
      (myi.bTmpTest = FALSE) THEN
      ' if the file is not an SFV, scan it as a normal file
      szItems$[0] = szFile$
      lvfi.flags  = LVFI_STRING
      lvfi.psz    = szItems$[0]
      IF ListView_FindItem(ListView, -1, &lvfi) = -1 THEN
        ListView_AddItem()
      END IF
    ELSE
      ' otherwise it is an SFV, so load its contents
      LoadSfv(szFile$)
    END IF
  END IF
END SUB

' --------------------------------------------------------------------------
' DESCRIPTION: Loads the contents of an SFV file to the listview
'       INPUT: szFile$
'      OUTPUT: n/a
'       USAGE: LoadSfv(szFileName$)
'     RETURNS: n/a
' --------------------------------------------------------------------------
SUB LoadSfv(szFile$)
  DIM szBuffer$

  OPEN szFile$ FOR INPUT AS FP1
  WHILE NOT EOF(FP1)
    ' grab a line and trim spaces
    LINE INPUT FP1, szBuffer$
    szBuffer$ = TRIM$(szBuffer$)

    ' check if the line is worth processing
    IF (LEN(szBuffer$) >= 3) AND INSTR(szBuffer$, " ") THEN
      ' skip past any comments
      IF LEFT$(szBuffer$, 1) <> ";" THEN
' FIX ## 1.01 // checks for true file path
        ' check for true path
        IF LastPosChar(szBuffer$, ":") = -1 THEN
          ' if the true path wasn't used, add the SFV's path
          szItems$[0] = AppPath$(szFile$) & _
            LEFT$(szBuffer$, LastPosChar(szBuffer$, " "))
        ELSE
          szItems$[0] = LEFT$(szBuffer$, LastPosChar(szBuffer$, " "))
        END IF
' FIX ## 1.01 // checks for true file path

        ' setup items
        szItems$[0] = TRIM$(szItems$[0])
        szItems$[6] = TRIM$(RIGHT$(szBuffer$, _
                      LEN(szBuffer$) - LastPosChar(szBuffer$, " ")))
        szItems$[5] = szFile$

        DIM lvfi      AS LVFINDINFO
        DIM dwReceive AS DWORD

        ' check if that item is already on the list
        lvfi.flags = LVFI_STRING
        lvfi.psz   = szItems$[0]
        dwReceive  = ListView_FindItem(ListView, -1, &lvfi)
        IF dwReceive = -1 THEN
          ListView_AddItem()
          dwReceive = ListView_GetItemCount(ListView) - 1
        END IF

        ' update listview items
        ListView_SetItemText(ListView, dwReceive, 3, _
          Prepend$(szItems$[3], 8, 48))
        ListView_SetItemText(ListView, dwReceive, 6, szItems$[6])
        ListView_SetItemText(ListView, dwReceive, 5, szItems$[5])
      END IF
    END IF
  WEND
  CLOSE FP1
END SUB

' --------------------------------------------------------------------------
' DESCRIPTION: Saves the contents of the listview to an SFV file
'       INPUT: szFile$
'      OUTPUT: n/a
'       USAGE: MakeSfv(szFileName$)
'     RETURNS: n/a
' --------------------------------------------------------------------------
SUB MakeSfv(szFile$)
  CONST szDateTime$ = "%Y-%m-%d at %H:%M.%S"

  DIM dwCnt  AS DWORD
  DIM dwSize AS DWORD
  DIM szTmp$

  OPEN szFile$ FOR OUTPUT AS FP1
  FPRINT FP1, "; Generated by WIN-SFV32 v1.1a on ", TimeFormat$(szDateTime$)
  FPRINT FP1, "; -------------------+----------------------------------"

' FIX ## 1.01 // adds existing good and bad total
  wsprintf(szTmp$, "%18d", uiGood + uiBad)
' FIX ## 1.01 // adds existing good and bad total

  FPRINT FP1, "; compatibility line | TOTAL: ", szTmp$, " file(s)"

  ' add the size of all the files
  dwSize = 0
  FOR dwCnt = 0 to ListView_GetItemCount(ListView) - 1
    ListView_GetItemText(ListView, dwCnt, 1, szTmp$, 2047)
    dwSize += VAL(szTmp$)
  NEXT

  wsprintf(szTmp$, "%18d", dwSize)
  FPRINT FP1, ";      for WIN-SFV32 |  SIZE: ", szTmp$, " byte(s)"
  FPRINT FP1, ";                    |"
' FIX ## 1.01 // file version
  FPRINT FP1, "; by LiteSFV 1.01 <--+--> Coded in 32-bit BASIC & WinASM"
' FIX ## 1.01 // file version
  FPRINT FP1, ";"

  ' print the file's size, time & date, and file name
  FOR dwCnt = 0 to ListView_GetItemCount(ListView) - 1
' NEW ## 1.01 // check for missing status
    ListView_GetItemText(ListView, dwCnt, 4, szTmp$, 2047)
    IF szTmp$ <> "Missing" THEN
' NEW ## 1.01 // check for missing status
      ListView_GetItemText(ListView, dwCnt, 1, szTmp$, 2047)
      szTmp$ = Prepend$(szTmp$, 12, 32)
      FPRINT FP1, "; ", szTmp$, "  ";

      ListView_GetItemText(ListView, dwCnt, 2, szTmp$, 2047)
      FPRINT FP1, szTmp$, " ";

      ListView_GetItemText(ListView, dwCnt, 0, szTmp$, 2047)
      IF myi.bTruePath = TRUE THEN
        FPRINT FP1, szTmp$
      ELSE
        FPRINT FP1, GetFileName$(szTmp$)
      END IF
    END IF
  NEXT

  ' print the file name and CRC-32
  FOR dwCnt = 0 to ListView_GetItemCount(ListView) - 1
' NEW ## 1.01 // check for missing status
    ListView_GetItemText(ListView, dwCnt, 4, szTmp$, 2047)
    IF szTmp$ <> "Missing" THEN
' NEW ## 1.01 // check for missing status
      ListView_GetItemText(ListView, dwCnt, 0, szTmp$, 2047)
      IF myi.bTruePath = TRUE THEN
        FPRINT FP1, szTmp$;
      ELSE
        FPRINT FP1, GetFileName$(szTmp$);
      END IF

      ' print CRC-32
      ListView_GetItemText(ListView, dwCnt, 3, szTmp$, 2047)
      FPRINT FP1, " ", szTmp$
    END IF
  NEXT

  CLOSE FP1
  DisplayNotification(Combine$("Your SFV file has been saved as ", szFile$))
END SUB

' --------------------------------------------------------------------------
' DESCRIPTION: Changes the text of the pause/resume button
'       INPUT: szText$
'      OUTPUT: n/a
'       USAGE: ResumeButton("new name of button")
'     RETURNS: n/a
' --------------------------------------------------------------------------
SUB ResumeButton(szText$)
  DIM tbi AS TBBUTTONINFOA

  tbi.cbSize    = sizeof(TBBUTTONINFOA)
  tbi.dwMask    = TBIF_COMMAND OR TBIF_TEXT
  tbi.idCommand = IDC_CANCEL
  tbi.cchText   = 2048
  tbi.pszText   = szText$
  SendMessage(Toolbar, LITESFV_TB_SETBUTTONINFO, IDC_CANCEL, &tbi)
END SUB

' --------------------------------------------------------------------------
' DESCRIPTION: Creates a thread for the scanning routine
'       INPUT: szFile$
'      OUTPUT: n/a
'       USAGE: StartScanThread()
'     RETURNS: n/a
' --------------------------------------------------------------------------
SUB StartScanThread()
  DIM threadID as DWORD

  CloseHandle(CreateThread(0, 0, _
    (LPTHREAD_START_ROUTINE)ScanListView, 0, 0, &threadID))
END SUB

' --------------------------------------------------------------------------
' DESCRIPTION: Begins scanning the files, based on data in the listview
'       INPUT: n/a
'      OUTPUT: n/a
'       USAGE: ScanListView()
'     RETURNS: n/a
' --------------------------------------------------------------------------
SUB ScanListView()
  DIM hFile      AS HFILE
  DIM dwFileSize AS DWORD
  DIM rAlloc     AS HGLOBAL
  DIM dwCRC      AS DWORD
  DIM dwFCnt     AS DWORD
  DIM dwFByt     AS LONGLONG
  DIM fd         AS WIN32_FIND_DATA
  DIM st         AS SYSTEMTIME
  DIM fh         AS HANDLE
  DIM dwBufr     AS DWORD
  DIM crc        AS UINT
  DIM dwSize     AS DWORD
  DIM dwStart    AS DWORD
  DIM dwFin      AS DWORD
  DIM szTest$
  DIM dwPercent#
  DIM szDate$
  DIM szTime$
  DIM szStatus$
  DIM i

  ' setup percentage bars and statusbar
  DragAcceptFiles(Form1, FALSE)
  SNDMSG(Toolbar, TB_ENABLEBUTTON, IDC_CANCEL, MAKELPARAM(TRUE, 0))
  SendMessage(ProgressBar1, PBM_SETBARCOLOR, 0, RGB(0, 255, 0))
  SendMessage(ProgressBar1, PBM_SETRANGE, 0, MAKELPARAM(0, 100))
  SendMessage(ProgressBar2, PBM_SETRANGE, 0, _
    MAKELPARAM(0, ListView_GetItemCount(ListView)))
  SendMessage(StatusBar, SB_SETTEXT, 2, szCalc$)
  myi.bInScan = TRUE

  ' start counting!
  dwStart = GetTickCount()
  FOR i = 0 to ListView_GetItemCount(ListView) - 1
    ListView_GetItemText(ListView, i, 4, szStatus$, 2047)

    IF szStatus$ = "Bad" OR szStatus$ = "" THEN
      ListView_GetItemText(ListView, i, 0, szTest$, 2047)

      IF EXIST(szTest$) = -1 THEN
        ' open file
        hFile = _lopen(szTest$, OF_READ)
        IF hFile = HFILE_ERROR THEN DisplayLastError()

        ' get size of file
        dwFileSize = GetFileSize((HANDLE)hFile, NULL)

        dwSize = dwFileSize
        dwBufr = myi.dwChunk
        crc = -1

        SendMessage(ProgressBar1, PBM_SETPOS, 0, 0)
        WHILE dwSize
          ' yes sir, our file chunking checker
          '
          ' this determines if we need to use the
          ' custom file chunk size for large files
          IF dwSize < dwBufr THEN
            dwBufr = dwSize
          ELSE
            dwBufr = myi.dwChunk
          END IF

          IF myi.bCancel = TRUE THEN
            EXIT WHILE
          END IF

          ' allocate memory to read data
          rAlloc = GlobalAlloc(GMEM_FIXED, dwBufr)

          ' read file into buffer
          _lread(hFile, rAlloc, dwBufr)

          ' calculate CRC-32
          crc = PartialCrc32(crc, rAlloc, dwBufr)

          ' release buffer
          GlobalFree(rAlloc)

          sprintf(szTest$, "%f", GetPercent#(dwFileSize#-dwSize#, _
            dwFileSize#))
          SendMessage(ProgressBar1, PBM_SETPOS, VAL(szTest$), 0)

          dwSize -= dwBufr
        WEND

        IF myi.bCancel = TRUE THEN
          IF hFile THEN _lclose(hFile)
          EXIT FOR
        ELSE
          SendMessage(ProgressBar1, PBM_SETPOS, 100, 0)
          wsprintf(szItems$[1], "%ld", dwFileSize)

          ' get the date and time of a file
          GetFileTime((HANDLE)hFile, NULL, NULL, &fd.ftLastWriteTime)
          FileTimeToLocalFileTime(&fd.ftLastWriteTime, &fd.ftLastWriteTime)
          FileTimeToSystemTime(&fd.ftLastWriteTime, &st)
          GetDateFormat(LOCALE_USER_DEFAULT, 0, &st, "yyyy-MM-dd", _
            szDate$, 255)
          GetTimeFormat(LOCALE_USER_DEFAULT, 0, &st, "HH:mm.ss", _
            szTime$, 255)
          szItems$[2] = szTime$ & " " & szDate$ 

          ' calculate CRC-32
          crc = FinishCrc32(crc)
          wsprintf(szItems$[3], "%08X", crc)

          ' it defaults to FFFFFFF or -1, so set it to 0
          IF szItems$[1] = "0" THEN
             szItems$[3] = "00000000"
          END IF

          ListView_GetItemText(ListView, i, 6, szTest$, 2047)
          IF LCASE$(szTest$) = LCASE$(szItems$[3]) THEN
            szItems$[4] = "Good"
            INCR uiGood
          ELSEIF LCASE$(szTest$) = "" THEN
            szItems$[4] = "New"
            INCR uiGood
          ELSE
            szItems$[4] = "Bad"
            INCR uiBad
          END IF
        END IF

        ' increment file size and file counter
        dwFCnt# += 1
        dwFByt# += dwFileSize

        ' update listview with new data
        ListView_SetItemText(ListView, i, 1, szItems$[1])
        ListView_SetItemText(ListView, i, 2, szItems$[2])
        ListView_SetItemText(ListView, i, 3, szItems$[3])
        ListView_SetItemText(ListView, i, 4, szItems$[4])

        IF hFile THEN _lclose(hFile)

        ' update statusbar with current percentage done
        szTest$ = szCalc$ & STR$(RoundIt#(GetPercent#(i + 1, _
          ListView_GetItemCount(ListView)))) & "% Done"
        SendMessage(StatusBar, SB_SETTEXT, 2, szTest$)

        SendMessage(ProgressBar2, PBM_SETPOS, i, 0)
      ELSE
' NEW ## 1.01 // clear file properties
        ListView_SetItemText(ListView, i, 1, "")
        ListView_SetItemText(ListView, i, 2, "")
        ListView_SetItemText(ListView, i, 3, "")
' NEW ## 1.01 // clear file properties
        ListView_SetItemText(ListView, i, 4, "Missing")
        INCR uiMiss
      END IF
    END IF
  NEXT

' FIX ## 1.01 // moved timer up for more precision
  ' update statusbar with statistics
  szTest$ = STR$(uiMiss) & " Missing," & STR$(uiGood) & " Good," & _
    STR$(uiBad) & " Bad - Took" & STR$(RoundIt#( _
    (GetTickCount() - dwStart#) / 1000.0)) & " Seconds"
  SendMessage(StatusBar, SB_SETTEXT, 2, szTest$)
' FIX ## 1.01 // moved timer up for more precision

  ' notify completion
  IF myi.bCancel = FALSE THEN
    SendMessage(ProgressBar2, PBM_SETPOS, _
      ListView_GetItemCount(ListView), 0)
    SNDMSG(Toolbar, TB_ENABLEBUTTON, IDC_CANCEL, MAKELPARAM(FALSE, 0))
    DisplayNotification("CRC-32 Check Complete!")
  END IF

  ' restore settings
  myi.bInScan = FALSE
  DragAcceptFiles(Form1, TRUE)
  SetFocus(ListView)
END SUB

' --------------------------------------------------------------------------
' DESCRIPTION: Adds a new button to the toolbar
'       INPUT: idCommand, iBitmap, szDesc$
'      OUTPUT: n/a
'       USAGE: Toolbar_AddButton(command_id, bitmap_id, "description")
'     RETURNS: n/a
' --------------------------------------------------------------------------
SUB Toolbar_AddButton(idCommand, iBitmap, szDesc$)
  tbb.iBitmap   = iBitmap
  tbb.fsState   = TBSTATE_ENABLED
  tbb.idCommand = idCommand
  tbb.fsStyle   = TBSTYLE_BUTTON OR TBSTYLE_AUTOSIZE
  tbb.iString   = SendMessage(Toolbar, TB_ADDSTRING, 0, (LPARAM)szDesc$)
  SendMessage(Toolbar, TB_ADDBUTTONS, 1, &tbb)
END SUB

' --------------------------------------------------------------------------
' DESCRIPTION: Adds a separator to the toolbar
'       INPUT: n/a
'      OUTPUT: n/a
'       USAGE: Toolbar_AddSeparator()
'     RETURNS: n/a
' --------------------------------------------------------------------------
SUB Toolbar_AddSeparator()
  tbb.iBitmap   = 0
  tbb.idCommand = 0
  tbb.fsStyle   = TBSTYLE_SEP
  SendMessage(Toolbar, TB_ADDBUTTONS, 1, &tbb)
END SUB

' --------------------------------------------------------------------------
' DESCRIPTION: Adds a range of columns to the listview
'       INPUT: iHowMany
'      OUTPUT: n/a
'       USAGE: ListView_AddColumn(5)
'     RETURNS: n/a
' --------------------------------------------------------------------------
SUB ListView_AddColumn(iHowMany)
  DIM lvc AS LV_COLUMN
  DIM iCount

  lvc.mask = LVCF_TEXT or LVCF_WIDTH
  lvc.cx   = 100

  FOR iCount = 1 TO iHowMany
    lvc.pszText = szColumns$[iCount - 1]
    ListView_InsertColumn(ListView, iCount - 1, &lvc)
  NEXT
END SUB

' --------------------------------------------------------------------------
' DESCRIPTION: Adds a new item to the listview, data is in szItems$[0]
'       INPUT: n/a
'      OUTPUT: n/a
'       USAGE: ListView_AddItem()
'     RETURNS: n/a
' --------------------------------------------------------------------------
SUB ListView_AddItem()
  DIM lvi AS LV_ITEM

  ' setup default lvi structure
  lvi.mask     = LVIF_TEXT or LVIF_PARAM
  lvi.iItem    = ListView_GetItemCount(ListView)
  lvi.lParam   = lvi.iItem
  lvi.iSubItem = 0
  lvi.pszText  = szItems$[0]

  ListView_InsertItem(ListView, &lvi)
END SUB

' --------------------------------------------------------------------------
' DESCRIPTION: Displays last API call error if display error is enabled
'       INPUT: n/a
'      OUTPUT: n/a
'       USAGE: DisplayLastError()
'     RETURNS: n/a
' --------------------------------------------------------------------------
SUB DisplayLastError()
  DIM szErrorMsg AS PVOID
  DIM szErrorNo$

  IF myi.bDisplay AND GetLastError() <> 0 THEN
    ' allow windows to allocate the buffer
    FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | _
      FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS, NULL, _
      GetLastError(), 0, (LPTSTR)&szErrorMsg, 0, NULL)

    ' convert number into displable text, then send it to the screen
    wsprintf(szErrorNo$, "Error: %d", GetLastError())
    MessageBox(Form1, Combine$(szErrorMsg$, szStop$), szErrorNo$, _
      MB_OK OR MB_ICONSTOP)
  END IF
END SUB

' --------------------------------------------------------------------------
' DESCRIPTION: Displays a custom error if display error is enabled
'       INPUT: szMsg$
'      OUTPUT: n/a
'       USAGE: DisplayError("custom message")
'     RETURNS: n/a
' --------------------------------------------------------------------------
SUB DisplayError(szMsg$)
  IF myi.bDisplay THEN
    MessageBox(Form1, Combine$(szMsg$, szStop$), "Error", _
      MB_OK OR MB_ICONSTOP)
  END IF
END SUB

' --------------------------------------------------------------------------
' DESCRIPTION: Displays a notification message if notifications are enabled
'       INPUT: szMsg$
'      OUTPUT: n/a
'       USAGE: DisplayNotification("custom message")
'     RETURNS: n/a
' --------------------------------------------------------------------------
SUB DisplayNotification(szMsg$)
  IF myi.bNotify THEN
    MessageBox(Form1, Combine$(szMsg$, szStop$), "Notification", _
      MB_OK OR MB_ICONINFORMATION)
  END IF
END SUB

' --------------------------------------------------------------------------
' DESCRIPTION: Asks user a question, if verifications are enabled
'       INPUT: szMsg$
'      OUTPUT: IDYES by default, otherwise IDNO
'       USAGE: dwYes = VerifyThis("your question")
'     RETURNS: Depends on selection, IDYES by default
' --------------------------------------------------------------------------
FUNCTION VerifyThis(szMsg$)
  IF myi.bVerify THEN
    FUNCTION = MessageBox(Form1, Combine$(szMsg$, szStop$), _
               "Verification", MB_YESNO OR MB_ICONQUESTION OR MB_DEFBUTTON2)
  END IF

  ' can be dangerous saying yes to everything
  FUNCTION = IDYES
END FUNCTION

' --------------------------------------------------------------------------
' DESCRIPTION: Rounds a double number to an integer value if enabled
'       INPUT: dVal#
'      OUTPUT: Integer with value
'       USAGE: dwStore = RoundIt#(value_to_round#)
'     RETURNS: Number after being rounded if enabled
' --------------------------------------------------------------------------
FUNCTION RoundIt#(dVal#)
  IF myi.bRoundNo = TRUE THEN
' FIX ## 1.01 // rounds up
    FUNCTION = ceil(dVal#)
' FIX ## 1.01 // rounds up
  END IF

  FUNCTION = dVal#
END FUNCTION

' //////////////////////////////////////////////////////////////////////////
' > 651 lines for BCX-32 2.41d              End of Miscellaneous Functions <
' \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
