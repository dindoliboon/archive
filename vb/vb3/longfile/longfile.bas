' copyright 1996, Internet Software Engineering
Option Explicit

Global gShortFilename As String
Global gLongFilename As String
Global gIn16BitSystem As Integer    ' True or False

' structure for dialog box setup
Type LongFile
   Action As Integer                ' 1 = open, 2 = save
   Color As Long                    ' background color
   DialogTitle As String            ' title bar text
   Filename As String               ' filename for input to dialog box, output filename will be in gShortFilename and gLongFilename
   Filter As String                 ' file extension filter
   FilterIndex As Integer           ' index into file extension filter
End Type

Global LF As LongFile

' necessary structures for api calls
Type FILETIME
   dwLowDateTime As Long
   dwHighDateTime As Long
End Type

Const MAX_PATH = 260

Type WIN32_FIND_DATA
   dwFileAttributes As Long
   ftCreationTime As FILETIME
   ftLastAccessTime As FILETIME
   ftLastWriteTime As FILETIME
   nFileSizeHigh As Long
   nFileSizeLow As Long
   dwReserved0 As Long
   dwReserved1 As Long
   cFileName As String * MAX_PATH
   cAlternate As String * 14
End Type

' copyright 1996, Internet Software Engineering
Sub GetLongFilename ()

   ' check that action member of LongFile structure is set
   If LF.Action = 0 Then
      MsgBox "Illegal function call.", 16, App.Title
      Exit Sub
   End If

   Load frmLongFile
   frmLongFile.Show 1

End Sub

