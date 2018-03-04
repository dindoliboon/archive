' //////////////////////////////////////////////////////////////////////////
' > ripline.bas 1.0 3:37 PM 8/12/2001                         Main Program <
' \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'
' Rip Line
' Copyright (c) 2001 by DL
'
' Takes an input ASCII text file and performs basic left & right ripping
' of the data. Manipulated data can then be displayed to the screen with
' left and right appendages, shown in columns, or can be redirected to a
' file for further manual modification.
'
' //////////////////////////////////////////////////////////////////////////

DIM uiLeft  AS UINT ' number of places to move right
DIM uiRight AS UINT ' number of places to move left
DIM uiCnt   AS UINT ' temporary counter
DIM uiCols  AS UINT ' number of columns
DIM uiTmp   AS UINT ' temporary variable

DIM szBuffer$       ' file buffer
DIM szFile$         ' name of file
DIM szLeft$         ' left data to append
DIM szRight$        ' right data to append
DIM szSep$          ' data separator

' \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'
' EXAMPLE
' --------------------------------------------------------------------------
' data = blah blah blah blah I want to grab this name blah blah blahx
'        this is more junk haI want to get this too!!more junk blah x
'        this is more junk haI want to get this 1234!more junk blah x
'        this is more junk haI want to get this 5678!more junk blah x
'        this is more junk haI want to get this 3dfa!more junk blah x
'        this is more junk haI want to get this 3432!more junk blah x
' 
' By looking at the data above, we can see that it is wrapped around by
' almost repetitive junk. We need to remove the first 20 bytes on the left
' and we need to remove the last 16 bytes on the right.
' 
' This is where this program's use becomes noticeable. It can easily do the
' removing and you can perform the formatting once the data you need has
' been ripped. Saving the data into a file named 2.txt we use it based on
' our analysis of the data.
'
' USAGE
' --------------------------------------------------------------------------
' Run SLINE.EXE and setup the screens to look like the following:
' Name of file?                 2.txt
' Rip how many from the left?   20
' Rip how many from the right?  16
' Append anything to the left?  "
' Append anything to the right? "
' Print in columns of what?
'
' That will read the file "2.txt" and display the output as:
' "I want to grab this name"
' "I want to get this too!!"
' "I want to get this 1234!"
' "I want to get this 5678!"
' "I want to get this 3dfa!"
' "I want to get this 3432!"
' 
' EXPLINATION
' --------------------------------------------------------------------------
' uiLeft and uiRight can be seen as the following:
' Lets say szBuffer$ = "ab12cd", so the length = 6
' 
'                 0   1   2   3   4   5
'                -----------------------
'  szBuffer$  = | a | b | 1 | 2 | c | d |
'                -----------------------
'                 ^                   ^-- right pointer is at d
'                 |
'                 +-- left pointer is at a
' 
' If uiLeft = 2, that would move the left pointer RIGHT 2 places
' 
'                 0   1   2   3   4   5
'                -----------------------
'  szBuffer$  = | a | b | 1 | 2 | c | d |
'                -----------------------
'  left pointer is at 1 --^           ^-- right pointer is at d
' 
' If uiRight = 3, then we would move the right pointer LEFT 3 places
' 
'                 0   1   2   3   4   5
'                -----------------------
'  szBuffer$  = | a | b | 1 | 2 | c | d |
'                -----------------------
'  left pointer is at 1 --^
'                         ^-- right pointer is at 1
' 
' That means the only character we are getting is 1
'
' //////////////////////////////////////////////////////////////////////////

' obtain options from user
INPUT "Name of file?                 " szFile$
INPUT "Rip how many from the left?   " uiLeft
INPUT "Rip how many from the right?  " uiRight
INPUT "Append anything to the left?  " szLeft$
INPUT "Append anything to the right? " szRight$
INPUT "Print in columns of what?     " uiCols

IF uiCols > 0 THEN INPUT "What separator do you want?   " szSep$

' open file for normal text input
OPEN szFile$ FOR INPUT AS FP1
WHILE NOT EOF(FP1)
  ' grab 1 line of text from the file
  ' (max length is 2047 because that is BCX's default string size)
  LINE INPUT FP1, szBuffer$

  ' check if text length is at least greater than the
  ' amount we want to remove from both left & right sides
  uiTmp = uiLeft + uiRight
  IF LEN(szBuffer$) > uiTmp THEN
    ' seek to left position, grabbing the size - the rip lengths
    szBuffer$ = MID$(szBuffer$, uiLeft + 1, LEN(szBuffer$) - uiTmp)
    PRINT szLeft$, szBuffer$, szRight$, szSep$;

    IF uiCols <> 0 AND uiCnt = uiCols - 1 THEN
      ' if the user wants to print it in columns, add a new line
      PRINT ""
      uiCnt = -1
    ELSEIF uiCols = 0 THEN
      ' no columns, so just print it one line each
      PRINT ""
    END IF

    ' if the user is using columns, increment by one
    IF uiCols <> 0 THEN INCR uiCnt
  END IF
WEND

' close handle to file
CLOSE FP1

' //////////////////////////////////////////////////////////////////////////
' > 144 lines of for BCX 1.39                          End of Main Program <
' \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
