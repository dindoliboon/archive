' //////////////////////////////////////////////////////////////////////////
'
' Count Example 1.0
'
' Main application program.
'
' Functions:
'   ProcessWalkResult
'
' History (Legend: > Info, ! Fix, + New, - Removed):
'   1.0          8/26/2001   > Initial release.
'
' Author:
'   DL (dl@tks.cjb.net / http://tks.cjb.net)
'
' //////////////////////////////////////////////////////////////////////////

#include "walkdir.h"

' Define variables
DIM szDir$, szSpec$
DIM dwFileCnt AS DWORD
DIM dFileSz#
DIM iError

' Ask for directory and file spec
INPUT "Enter directory: " szDir$
INPUT "Enter file spec: " szSpec$

' Call WalkDir function
WalkDir(szDir$, szSpec$, TRUE, ProcessWalkResult)

' Print results
PRINT ">", dwFileCnt, " file(s) were found!"
PRINT ">", dFileSz#,  " byte(s) were found!"
PRINT ">", iError,    " error(s) occured!"

' --------------------------------------------------------------------------
' 
' Counts the number of files in a given directory.
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
SUB ProcessWalkResult(szPath$, szFile$, bFile)
  DIM szTmp$
  DIM dwSize AS DWORD
  DIM hFile  AS HFILE

  ' If bFile is TRUE, a file was found
  IF bFile = TRUE THEN
    ' Increment file found counter
    INCR dwFileCnt

    ' Create full path name
    szTmp$ = szPath$ & szFile$

    ' Open file to obtain file size
    hFile  = _lopen(szTmp$, OF_READ)
    dwSize = GetFileSize((HANDLE)hFile, NULL)

    ' If -1 is the file size, an error occured
    IF dwSize = -1 THEN
      PRINT "Error getting size of ", szTmp$
      INCR iError
    ELSE
      dFileSz# += dwSize
    END IF

    ' close file
    _lclose(hFile)
  ELSE
    ' Path was found, do path manipulating functions below !
    ' PRINT szPath$
  END IF
END SUB
