' //////////////////////////////////////////////////////////////////////////
' > tools.bas 1.01 8:20 PM 8/15/2001                        Tool Functions <
' \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'
' Collection of reusable function not tied down by any global variables.
' Basically it means that you can use it in your other programs by simply
' including $include "tools.bas" in your main program.
'
' History
'    1.0  -> 11:54 AM  8/15/2001
'    1.01 ->  8:20 PM  8/15/2001
'
' Copyright (c) 2001 DL
' All Rights Reserved.
'
' //////////////////////////////////////////////////////////////////////////

' --------------------------------------------------------------------------
' DESCRIPTION: Adds a backslash to a file path
'       INPUT: szPath$
'      OUTPUT: String with backslash
'       USAGE: szBuffer$ = Backslash$("c:\test")
'     RETURNS: c:\test\
'        NEW : 1.01
' --------------------------------------------------------------------------
FUNCTION Backslash$(szPath$)
  IF RIGHT$(szPath$, 1) <> CHR$(92) THEN
    FUNCTION = szPath$ & CHR$(92)
  END IF

  FUNCTION = szPath$
END FUNCTION

' --------------------------------------------------------------------------
' DESCRIPTION: Formats the time and date
'       INPUT: szFormat$
'      OUTPUT: String with formatted time & date
'       USAGE: szBuffer$ = TimeFormat$(szFormattedTime$)
'     RETURNS: szBuffer$ = "14:46.02 2001-08-13"
' --------------------------------------------------------------------------
FUNCTION TimeFormat$(szFormat$)
  DIM tElapsed AS time_t
  DIM szTmp$

  ' Note that szFormat$ must be an address to a string!
  '
  ' For example, the following currently does not work:
  ' PRINT TimeFormat$("%M")
  '
  ' You must create a string variable first!
  ' DIM szM$
  ' szM$ = "%M"
  ' PRINT TimeFormat$(szM$)

  time(&tElapsed)
  strftime(szTmp$, 256, szFormat$, localtime(&tElapsed))
  FUNCTION = szTmp$
END FUNCTION

' --------------------------------------------------------------------------
' DESCRIPTION: Adds data to the left side of a string
'       INPUT: szIn$, iSize, iVal
'      OUTPUT: String with prepended data
'       USAGE: szBuffer$ = Prepend("my string", 12, ASC(">"))
'     RETURNS: szBuffer$ = ">>>my string"
' --------------------------------------------------------------------------
FUNCTION Prepend$(szIn$, dwSize AS DWORD, iVal)
  DIM dwLen AS DWORD
  DIM szTmp$

  dwLen     = LEN(szIn$)
  IF dwLen >= dwSize THEN FUNCTION = szIn$
  FUNCTION  = STRING$(dwSize - dwLen, iVal) & szIn$
END FUNCTION

' --------------------------------------------------------------------------
' DESCRIPTION: Adds data to the right side of a string
'       INPUT: szIn$, iSize, iVal
'      OUTPUT: String with appended data
'       USAGE: szBuffer$ = Append("my string", 12, ASC("<"))
'     RETURNS: szBuffer$ = "my string<<<"
' --------------------------------------------------------------------------
FUNCTION Append$(szIn$, iSize, iVal)
  DIM dwLen AS DWORD
  DIM szTmp$

  dwLen     = LEN(szIn$)
  IF dwLen >= iSize THEN FUNCTION = szIn$
  szTmp$    = szIn$ & STRING$(iSize - dwLen, iVal)
  FUNCTION  = szTmp$
END FUNCTION

' --------------------------------------------------------------------------
' DESCRIPTION: Moves a window to the center of the screen
'       INPUT: hWnd
'      OUTPUT: n/a
'       USAGE: CenterWindow(hMainWindow)
'     RETURNS: n/a
' --------------------------------------------------------------------------
SUB CenterWindow(hWnd AS HWND)
  DIM wRect AS RECT
  DIM x AS DWORD
  DIM y AS DWORD

  GetWindowRect(hWnd, &wRect)
  x = (GetSystemMetrics(SM_CXSCREEN) - (wRect.right - wRect.left)) / 2
  y = (GetSystemMetrics(SM_CYSCREEN) - _
      (wRect.bottom - wRect.top + GetSystemMetrics(SM_CYCAPTION))) / 2
  SetWindowPos(hWnd, NULL, x, y, 0, 0, SWP_NOSIZE OR SWP_NOZORDER)
END SUB

' --------------------------------------------------------------------------
' DESCRIPTION: Returns the percentage value of a number
'       INPUT: x#, y#
'      OUTPUT: Double percentage value
'       USAGE: z# = GetPercent(5.0, 7.0)
'     RETURNS: 71.428571428571428571428571428571
' --------------------------------------------------------------------------
FUNCTION GetPercent#(x#, y#)
  FUNCTION = (x# / y#) * 100.0
END FUNCTION

' --------------------------------------------------------------------------
' DESCRIPTION: Wrapper for GetModuleFileName()
'       INPUT: n/a
'      OUTPUT: String to full path name
'       USAGE: buffer$ = EXEModule$()
'     RETURNS: c:\your application path\your file.exe
' --------------------------------------------------------------------------
FUNCTION EXEModule$()
  DIM buffer$

  GetModuleFileName(NULL, buffer$, 2047)
  FUNCTION = buffer$
END FUNCTION

' --------------------------------------------------------------------------
' DESCRIPTION: Gets a path from full path name
'       INPUT: path$
'      OUTPUT: String to path name
'       USAGE: buffer$ = AppPath$("c:\your directory\your file.exe")
'     RETURNS: c:\your directory\
' --------------------------------------------------------------------------
FUNCTION AppPath$(path$)
  FUNCTION = LEFT$(path$, LastPosChar(path$, "\") + 1)
END FUNCTION

' --------------------------------------------------------------------------
' DESCRIPTION: Gets file name from full path name
'       INPUT: path$
'      OUTPUT: String to file name
'       USAGE: buffer$ = GetFileName$("c:\your directory\your file.exe")
'     RETURNS: your file.exe
' --------------------------------------------------------------------------
FUNCTION GetFileName$(path$)
  FUNCTION = RIGHT$(path$, LEN(path$) - (LastPosChar(path$, "\") + 1))
END FUNCTION

' --------------------------------------------------------------------------
' DESCRIPTION: Returns last occurrence of a string
'       INPUT: szLine$, szChar$
'      OUTPUT: Integer to position
'       USAGE: buffer = LastPosChar("c:\your directory\your file.exe", "\")
'     RETURNS: 17
' --------------------------------------------------------------------------
FUNCTION LastPosChar(szLine AS PCHAR, szChar AS PCHAR)
  ! int iCount = 0;
  ! int iPos   = -1;

  ' Don't forget that we are dealing with the LCC-Win32 layer
  '
  ' That mean's instead of using char *, we can use PCHAR
  ' which is already defined in the <win.h> header

  ! while (*szLine != '\0')
  ! {
  !   if (*szLine == *szChar) iPos = iCount;
  !   iCount ++;
  !   ++ szLine;
  ! }

  FUNCTION = iPos
END FUNCTION

' --------------------------------------------------------------------------
' DESCRIPTION: Combines TWO strings together, an alternative to JOIN$()
'       INPUT: sz1$, sz2$
'      OUTPUT: Combined string
'       USAGE: szBuffer$ = Combine$("one ", "two")
'     RETURNS: szBuffer$ = "one two"
' --------------------------------------------------------------------------
FUNCTION Combine$(sz1$, sz2$)

  ' As you can see, this is not a TRUE alternative to JOIN$()
  '
  ' It only adds TWO strings together.
  ' However, it can be used in a FUNCTION,
  ' which is why it was created.

  FUNCTION = sz1$ & sz2$
END SUB

' --------------------------------------------------------------------------
' DESCRIPTION: Checks if a character is an alphabet
'       INPUT: ch$
'      OUTPUT: TRUE if an alphabet, otherwise FALSE
'       USAGE: IsChAlpha("4")
'     RETURNS: FALSE
' --------------------------------------------------------------------------
FUNCTION IsChAlpha(ch$)

  ' This uses semi-C'ish code. Without incrementing the position
  ' *ch will point to the first character, which is position 0.

  IF (*ch >= 0x41 AND *ch <= 0x5A) THEN FUNCTION = TRUE
  IF (*ch >= 0x61 AND *ch <= 0x7A) THEN FUNCTION = TRUE

  FUNCTION = FALSE
END FUNCTION

' //////////////////////////////////////////////////////////////////////////
' > 224 lines for BCX-32 2.41d                       End of Tool Functions <
' \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
