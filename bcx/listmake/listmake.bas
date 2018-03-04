' //////////////////////////////////////////////////////////////////////////
'
' Listing Maker 1.0
'
' Main application program.
'
' Functions:
'   main
'   ProcessFiles
'   FileFromPath
'   AppPath
'   Combine
'   LastPosChar
'   CreateBackup
'
' History (Legend: > Info, ! Fix, + New, - Removed):
'   1.0          9/25/2001   > Initial release.
'
' Author:
'   DL (dl@tks.cjb.net / http://tks.cjb.net)
'
' //////////////////////////////////////////////////////////////////////////

$NOMAIN
#include "walkdir.h"

' Global variables
DIM g_Do_Recurse  ' Do recursion
DIM g_Do_AddHead  ' Add file header
DIM g_szOut$      ' File output name

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

  ' Add header and do recursion by default
  g_Do_Recurse = TRUE
  g_Do_AddHead = TRUE

  ' If there are not enough arguments, show usage screen
  IF argc < 3 THEN
    PRINT "Listing Maker 1.0", CRLF$
    PRINT "LISTMAKE ", CHR$(34), "<path\spec>", CHR$(34), " ", CHR$(34);
    PRINT "<file>", CHR$(34), " [-nr] [-nh]"
    PRINT "  path\spec  directory to scan for file spec"
    PRINT "  file       output file"
    PRINT "  -nr        do not recurse directory"
    PRINT "  -nh        do not print header", CRLF$
    PRINT "EXAMPLES:"
    PRINT "  LISTMAKE ", CHR$(34), "c:\bcx\con_demo\*.bas", CHR$(34);
    PRINT " ", CHR$(34), "all console.txt", CHR$(34), " -nr"
    PRINT "  LISTMAKE ", CHR$(34), "c:\bcx\gui_demo\*.bas", CHR$(34);
    PRINT " ", CHR$(34), "all gui.txt", CHR$(34)
    PRINT "  LISTMAKE ", CHR$(34), "c:\bcx\dll_demo\*.bas", CHR$(34);
    PRINT " ", CHR$(34), "all dll.txt", CHR$(34)

    FUNCTION = 0
  END IF

  ' Initialize data from command-line
  szPath$ = AppPath$(argv$[1])
  szSpec$ = FileFromPath$(argv$[1])
  g_szOut$  = argv$[2]

  ' Add current directory if path does not exist
  IF szPath$ = "" THEN szPath$ = CURDIR$

  ' Check command-line for any extra options
  IF argc > 3 THEN
    DIM x

    FOR x = 3 TO argc - 1
      SELECT CASE LCASE$(argv$[x])
      CASE "-nr", "/nr"
        g_Do_Recurse = FALSE

      CASE "-nh", "/nh"
        g_Do_AddHead = FALSE
      END SELECT
    NEXT
  END IF

  ' Create backup file if output file exists
  IF EXIST(g_szOut$) = -1 THEN
    CALL CreateBackup$(g_szOut$)
  END IF

  ' Create output file and start processing directories
  OPEN g_szOut$ FOR OUTPUT AS FP1
    WalkDir(szPath$, szSpec$, g_Do_Recurse, ProcessFiles)
  CLOSE FP1
END SUB

' --------------------------------------------------------------------------
' 
' Processes file names and creates file listing.
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
  DIM fd         AS WIN32_FIND_DATA
  DIM st         AS SYSTEMTIME
  DIM hFile      AS HFILE
  DIM dwSize     AS DWORD
  DIM szBuffer$
  DIM szDate$
  DIM szTime$

  ' Exit if no files were found
  IF bFile = FALSE THEN EXIT SUB
  IF LCASE$(szFile$) = LCASE$(FileFromPath$(g_szOut$)) THEN EXIT SUB

  ' Print current file being processed
  PRINT "Processing ", szFile$, " ..."

  ' Create header if enabled
  IF g_Do_AddHead THEN
    FPRINT FP1, "' ", REPEAT$(74, "-")
    FPRINT FP1, "' ", UCASE$(szFile$);

    ' Open file to obtain attributes
    hFile = _lopen(Combine$(szPath$, szFile$), OF_READ)
    IF hFile <> HFILE_ERROR THEN
      ' Get size of file
      dwSize = GetFileSize((HANDLE)hFile, NULL)

      ' Get the date and time of a file
      GetFileTime((HANDLE)hFile, NULL, NULL, &fd.ftLastWriteTime)
      FileTimeToLocalFileTime(&fd.ftLastWriteTime, &fd.ftLastWriteTime)
      FileTimeToSystemTime(&fd.ftLastWriteTime, &st)

      ' Format data and time
      GetDateFormat(LOCALE_USER_DEFAULT, 0, &st, _
        "MM/dd/yyyy", szDate$, 255)
      GetTimeFormat(LOCALE_USER_DEFAULT, 0, &st, _
        "hh:mm:ss tt", szTime$, 255)

      ' Close file
      _lclose(hFile)

      ' Print file attributes
      FPRINT FP1, "  ", szTime$, " ", szDate$, " ", dwSize, " bytes"
    ELSE
      FPRINT FP1, ""
    END IF

    FPRINT FP1, "' ", REPEAT$(74, "-")
  END IF

  ' Open input file and store contents into file listing
  OPEN Combine$(szPath$, szFile$) FOR INPUT AS FP2
    WHILE NOT EOF(FP2)
      LINE INPUT FP2, szBuffer$
      FPRINT FP1, szBuffer$
    WEND
  CLOSE FP2
  FPRINT FP1, ""
END SUB

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

' --------------------------------------------------------------------------
' 
' Creates a backup of a file.
'
' Arguments:
'   szFile$  Name of file to backup.
' 
' Return Value:
'   Name of the newly created backup file.
'   Empty if the operation failed.
'
' --------------------------------------------------------------------------
FUNCTION CreateBackup$(szFile$)
  DIM szBuffer$
  DIM iCounter

  ' Reset initial counter
  iCounter = 0

  ' Create infinite loop
  DO
    ' Exist if target file does not exist
    IF EXIST(szFile$) <> -1 THEN FUNCTION = ""

    ' Store name of backup file
    szBuffer$ = szFile$ & "." & TRIM$(STR$(iCounter))

    IF EXIST(szBuffer$) = -1 THEN
      ' If backup file exists, increment the counter again
      INCR iCounter
    ELSE
      ' If the target file exists, copy the target file with the name of the
      ' backup file, then exit the loop
      IF EXIST(szFile$) = -1 THEN COPYFILE szFile$, szBuffer$
      EXIT LOOP
    END IF
  LOOP

  FUNCTION = szBuffer$
END FUNCTION
