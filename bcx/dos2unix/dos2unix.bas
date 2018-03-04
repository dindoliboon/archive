' //////////////////////////////////////////////////////////////////////////
'
' Dos2Unix 1.1
'
' Main application program.
'
' Functions:
'   main
'   ProcessFiles
'   TempFile
'   FileFromPath
'   AppPath
'   Combine
'   LastPosChar
'
' History (Legend: > Info, ! Fix, + New, - Removed):
'   1.0          5/17/2001   > Initial release.
'   1.1          9/30/2001   ! Directory recursion.
'                            + Unix to Dos conversion.
'
' Author:
'   DL (dl@tks.cjb.net / http://tks.cjb.net)
'
' //////////////////////////////////////////////////////////////////////////

$NOMAIN
#include "walkdir.h"

' Global variables
DIM g_Do_Recurse  ' Do recursion
DIM g_Do_Dos      ' Convert to Dos
DIM g_szLast$     ' Last file being processed

' --------------------------------------------------------------------------
' 
' Application entry point.
'
' Return Value:
'   0 if successful.
' 
' --------------------------------------------------------------------------
SUB main()
  DIM szSpec$
  DIM szPath$

  ' Check if there are enough arguments
  IF argc < 2 THEN
    PRINT "Dos2Unix 1.0", CRLF$
    PRINT "DOS2UNIX ", CHR$(34), "<path\spec>", CHR$(34), " [-r] [-d]"
    PRINT "  path\spec  directory to scan for file spec"
    PRINT "  -r         recurse directory"
    PRINT "  -d         convert to dos format", CRLF$
    PRINT "EXAMPLES:"
    PRINT "  DOS2UNIX ", CHR$(34), "c:\bcx\con_demo\*.bas", CHR$(34);
    PRINT " -d"
    PRINT "  DOS2UNIX ", CHR$(34), "c:\bcx\gui_demo\*.bas", CHR$(34);
    PRINT " -r"
    PRINT "  DOS2UNIX ", CHR$(34), "c:\bcx\dll_demo\*.bas", CHR$(34);
    PRINT " -d -r"

    FUNCTION = 0
  END IF

  ' Setup default values
  g_Do_Recurse = FALSE
  g_Do_Dos     = FALSE

  ' Initialize data from command-line
  szPath$ = AppPath$(argv$[1])
  szSpec$ = FileFromPath$(argv$[1])

  ' Add current directory if path does not exist
  IF szPath$ = "" THEN szPath$ = CURDIR$

  ' Check command-line for any extra options
  IF argc > 2 THEN
    DIM x

    FOR x = 2 TO argc - 1
      SELECT CASE LCASE$(argv$[x])
      CASE "-d", "/d"
        g_Do_Dos = TRUE

      CASE "-r", "/r"
        g_Do_Recurse = TRUE
      END SELECT
    NEXT
  END IF

  WalkDir(szPath$, szSpec$, g_Do_Recurse, ProcessFiles)
END SUB

' --------------------------------------------------------------------------
' 
' Processes file names and does conversion.
'
' Arguments:
'   szPath$  Directory of current file.
'   szFile$  Current file being processed.
'   bFile    If TRUE, szPath$ will contain the directory of the file and
'            szFile$ will contain the name of the file. Otherwise, szPath$
'            will contain the sub-directory and szFile$ will be empty.
'
' Comments:
'   Callback function for WalkDir.
' 
' --------------------------------------------------------------------------
SUB ProcessFiles(szPath$, szFile$, bFile)
  DIM szBuffer$
  DIM szTmp$
  DIM szInput$

  ' Exit if no files were found
  IF bFile = FALSE THEN EXIT SUB
  IF szFile$ = "" THEN EXIT SUB

  ' Create new file name and check if it was processed before
  szInput$ = Combine$(szPath$, szFile$)
  IF LCASE$(g_szLast$) = LCASE$(szInput$) THEN EXIT SUB

  ' Create temporary file name
  szTmp$ = TempFile$()
  IF szTmp$ = "" THEN szTmp$ = "temp.$$$"

  ' Print current file being processed
  PRINT "Processing ", szFile$, " ..."

  OPEN szInput$ FOR INPUT AS FP1
  OPEN szTmp$   FOR BINARY NEW AS FP2

  ' Read in file data
  WHILE NOT EOF(FP1)
    LINE INPUT FP1, szBuffer$

    PUT$ FP2, szBuffer$, LEN(szBuffer$)

    ' Check which format to save the file as
    IF g_Do_Dos = TRUE THEN
      PUT$ FP2, CRLF$, 2
    ELSE
      PUT$ FP2, CHR$(10), 1
    END IF
  WEND

  CLOSE FP2
  CLOSE FP1

  ' Replace the original file with the modified file
  KILL szInput$
  COPYFILE szTmp$, szInput$
  KILL szTmp$

  ' Save name of file that was processed
  g_szLast$ = szInput$
END SUB

' --------------------------------------------------------------------------
' 
' Creates a temporary file in the current directory.
'
' Return Value:
'   Pointer to the temporary file name.
'
' --------------------------------------------------------------------------
FUNCTION TempFile$()
  DIM szFile$

  IF GetTempFileName(CURDIR$, "fcv", 0, szFile$) = 0 THEN
    FUNCTION = ""
  END IF

  FUNCTION = szFile$
END FUNCTION

' --------------------------------------------------------------------------
' 
' Gets file name from full path name.
'
' Arguments:
'   path$  Complete path with file name.
' 
' Return Value:
'   Pointer to the file name.
'
' --------------------------------------------------------------------------
FUNCTION FileFromPath$(path$)
  FUNCTION = RIGHT$(path$, LEN(path$) - (LastPosChar(path$, "\") + 1))
END FUNCTION

' --------------------------------------------------------------------------
' 
' Get the path name from a string with the full path name of a file.
'
' Arguments:
'   path$  Complete path with file name.
' 
' Return Value:
'   Pointer to the path name.
'
' --------------------------------------------------------------------------
FUNCTION AppPath$(path$)
  FUNCTION = LEFT$(path$, LastPosChar(path$, "\") + 1)
END FUNCTION

' --------------------------------------------------------------------------
' 
' Appends one string to another.
'
' Arguments:
'   sz1$  First part of the string.
'   sz2$  String to be appended to sz1$.
' 
' Return Value:
'   Returns the appended string.
'
' Comments:
'   Handles ONLY 2 strings.
'
' --------------------------------------------------------------------------
FUNCTION Combine$(sz1$, sz2$)
  FUNCTION = sz1$ & sz2$
END SUB

' --------------------------------------------------------------------------
' 
' Returns the position of the last occurrence of a character in a string.
'
' Arguments:
'   szLine  Search target
'   szChar  Character to find in string
' 
' Return Value:
'   If successful, the position of the character will be returned.
'   -1 if the operation failed.
'
' Comments:
'   0 based position.
'
' --------------------------------------------------------------------------
FUNCTION LastPosChar(szLine AS PCHAR, szChar AS PCHAR)
  ! int iCount = 0;
  ! int iPos   = -1;

  ' Don't forget that we are dealing with the LCC-Win32 layer
  '
  ' That mean's instead of using char *, we can use PCHAR
  ' which is already defined in the <win.h> header

  ! while (*szLine != 0)
  ! {
  !   if (*szLine == *szChar) iPos = iCount;
  !   iCount ++;
  !   ++ szLine;
  ! }

  FUNCTION = iPos
END FUNCTION
