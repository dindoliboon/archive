' //////////////////////////////////////////////////////////////////////////
'
' Get MP3v1 Tag 1.1
'
' Main application program.
'
' Functions:
'   ReadLine
'
' History (Legend: > Info, ! Fix, + New, - Removed):
'   1.0          8/13/2001   > Initial release.
'   1.1          9/30/2001   > Cleaned up code.
'                            ! ReadLine function.
'
' Author:
'   DL (dl@tks.cjb.net / http://tks.cjb.net)
'
' //////////////////////////////////////////////////////////////////////////

' Standard ID3_V1 tag
TYPE ID3_V1_TAG
       szID$[3]
     szSong$[30]
   szArtist$[30]
    szAlbum$[30]
     szYear$[4]
  szComment$[30]
    szGenre$[1]
END TYPE

DIM id3v1  AS ID3_V1_TAG
DIM dwSize
DIM szTmp$
DIM szFile$

' Check if file exists
szFile$ = COMMAND$
IF EXIST(szFile$) <> -1 THEN
  PRINT "Get MP3v1 Tag 1.0", CRLF$
  PRINT "MP3ID <file.mp3>"
  PRINT "  file.mp3  name of file to examine", CRLF$
  PRINT "EXAMPLES:"
  PRINT "  MP3ID cool.mp3"
  PRINT "  MP3ID ", CHR$(34), "my song.mp3", CHR$(34)
  FUNCTION = 0
END IF

' Get size of file
dwSize = LOF(szFile$)

' Open file and read ID3_V1 structure
OPEN szFile$ FOR BINARY AS FP1
SEEK FP1, dwSize - 128
GET$ FP1, sizeof(ID3_V1_TAG), &id3v1
CLOSE FP1

' Check for ID3 tag identifier
szTmp$ = LEFT$(id3v1.szID$, 3)
IF LCASE$(szTmp$) <> "tag" THEN
  PRINT "This file does not contain an ID3v1 tag."
  FUNCTION = 0
END IF

' Grab song title
szTmp$ = LEFT$(id3v1.szSong$, 30)
PRINT "     Song Name: ", szTmp$

' Grab artist name
szTmp$ = LEFT$(id3v1.szArtist$, 30)
PRINT "   Artist Name: ", szTmp$

' Grab album name
szTmp$ = LEFT$(id3v1.szAlbum$, 30)
PRINT "    Album Name: ", szTmp$

' Grab year
szTmp$ = LEFT$(id3v1.szYear$, 4)
PRINT "          Year: ", szTmp$

' Grab comments
szTmp$ = LEFT$(id3v1.szComment$, 30)
PRINT "      Comments: ", szTmp$

' Grab genere
szTmp$ = LEFT$(id3v1.szGenre$, 1)
dwSize = *szTmp ' stored as hex
PRINT "         Genre: ";

' Lookup genere in data file
IF (dwSize >= 0) AND (dwSize <= 116) THEN
  szTmp$ = ReadLine$("genre.dat", dwSize + 1)
ELSE
  szTmp$ = "undetermined"
END IF
PRINT szTmp$

' --------------------------------------------------------------------------
' 
' Grabs a line of data from a text file.
'
' Arguments:
'   szFile$  File to open.
'   iLine    Line number to read.
'
' Return Value:
'   Pointer to string with data if successful. Otherwise the return value
'   is an empty string.
'
' Comments:
'   iLine is 1 based.
'
' --------------------------------------------------------------------------
FUNCTION ReadLine$(szFile$, iLine)
  DIM fBuffer$
  DIM iCount AS WORD
  DIM iFound AS WORD

  ' Initialize variables
  iCount = 0
  iFound = FALSE

  OPEN szFile$ FOR INPUT AS FP_ReadLine
  WHILE NOT EOF(FP_ReadLine)
    ' Increment counter and read line
    INCR iCount
    LINE INPUT FP_ReadLine, fBuffer$

    ' Check if this is the line to grab
    IF iCount = iLine THEN
      iFound = TRUE
      GOTO Close_ReadLine
    END IF
  WEND

' Close file handle
Close_ReadLine:
  CLOSE FP_ReadLine

  ' Line was obtained, so exit function successfully
  IF iFound = TRUE THEN
    FUNCTION = fBuffer$
  END IF

  ' Function failed
  FUNCTION = ""
END FUNCTION
