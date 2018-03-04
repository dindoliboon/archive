VERSION 2.00
Begin Form frmLongFile 
   BackColor       =   &H00C0C0C0&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Open File "
   ClientHeight    =   3270
   ClientLeft      =   1110
   ClientTop       =   1500
   ClientWidth     =   7005
   ControlBox      =   0   'False
   Height          =   3675
   Left            =   1050
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3270
   ScaleWidth      =   7005
   Top             =   1155
   Width           =   7125
   Begin TextBox txtFilename 
      Height          =   315
      Left            =   120
      TabIndex        =   11
      Top             =   360
      Width           =   2895
   End
   Begin ComboBox comboFileTypes 
      Height          =   315
      Left            =   120
      TabIndex        =   6
      Text            =   "Combo1"
      Top             =   2820
      Width           =   2895
   End
   Begin DirListBox Dir1 
      Height          =   1605
      Left            =   3120
      TabIndex        =   5
      Top             =   840
      Width           =   2535
   End
   Begin DriveListBox Drive1 
      Height          =   315
      Left            =   3120
      TabIndex        =   4
      Top             =   2820
      Width           =   2535
   End
   Begin CommandButton btnCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   5760
      TabIndex        =   2
      Top             =   1320
      Width           =   1095
   End
   Begin CommandButton btnOpen 
      Caption         =   "OK"
      Height          =   375
      Left            =   5760
      TabIndex        =   1
      Top             =   840
      Width           =   1095
   End
   Begin ListBox List1 
      Height          =   1590
      Left            =   120
      Sorted          =   -1  'True
      TabIndex        =   0
      Top             =   840
      Width           =   2895
   End
   Begin Label Label5 
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      Caption         =   "Folders:"
      Height          =   195
      Left            =   3120
      TabIndex        =   10
      Top             =   120
      Width           =   690
   End
   Begin Label Label4 
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      Caption         =   "Filename:"
      Height          =   195
      Left            =   120
      TabIndex        =   9
      Top             =   120
      Width           =   825
   End
   Begin Label Label3 
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      Caption         =   "Drives:"
      Height          =   195
      Left            =   3120
      TabIndex        =   8
      Top             =   2580
      Width           =   615
   End
   Begin Label Label2 
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      Caption         =   "List files of type:"
      Height          =   195
      Left            =   120
      TabIndex        =   7
      Top             =   2580
      Width           =   1425
   End
   Begin Label lblFolders 
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   1  'Fixed Single
      Height          =   375
      Left            =   3120
      TabIndex        =   3
      Top             =   360
      Width           =   3735
      WordWrap        =   -1  'True
   End
End
Option Explicit

' This form and its accompanying longfile.bas module allow 16-bit VB
' applications to use long file names when run in environments (Windows 95
' and Windows NT) that support them.  Set up for a call to this form is
' much like a call to a common dialog box, but with considerably less
' properties.  The properties are stored in the following structure:

'' structure for dialog box setup
'Type LongFile
'   Action as Integer         ' 1 = Open, 2 = Save
'   Color As Long             ' background color
'   DialogTitle As String     ' title bar text
'   Filename As String        ' filename for input to dialog box, output filename will be in gShortFilename and gLongFilename
'   Filter As String          ' file extension filter
'   FilterIndex As Integer    ' index into file extension filter
'End Type

' This structure is declared as LF and the declaration is global.  Note
' one major difference between this structure and that of the common dialog
' box:  the Filename string is used only to send a name to this form.  The
' string will be null upon exit from this form.  The user selected filename
' will be in two global variables, gShortFilename and gLongFilename.  Both
' will contain the full path to the filename.  Another global variable,
' gIn16BitSystem will be set to True if the system only supports short
' filenames, False if the system supports long filenames.  Use this value
' to determine which of gShortFilename or gLongFilename to use to interact
' with the system for file saves and opens.  In 16-bit Windows systems, both
' gShortFilename and gLongFilename will contain the same value.
'
' Sample setup and call:
'     LF.Action = 1     ' nothing happens until call to GetLongFilename
'     LF.DialogTitle = "Select File to Open"
'     LF.Filter = "Text (*.txt)|*.txt|HTML (*.htm)|*.htm|All Files (*.*)|*.*"
'     LF.FilterIndex = 2   ' set html as default file type
'     GetLongFilename
'
' Another example:
'     LF.Action = 2     ' nothing happens until call to GetLongFilename
'     LF.DialogTitle = "Save File"
'     LF.Filename = "foo.txt"
'     GetLongFilename
'     if LF.Action = -1 ' then user chose Cancel
'
' Since the LF structure is global, structure values remain intact between
' calls except for LF.Filename, which is cleared after each call to
' GetLongFilename, and LF.Action, which is set to zero on normal exit or
' -1 if the user selected the Cancel button.






































'============================================================================


' form level declarations for long filename support

Dim hInstKernel As Long
Dim lpGetShortPathNameA As Long
Dim lpFindFirstFileA As Long



' api calls for long filename support
Declare Function LoadLibraryEx32W Lib "KERNEL" (ByVal lpszFile As String, ByVal hFile As Long, ByVal dwFlags As Long) As Long
Declare Function FreeLibrary32W Lib "KERNEL" (ByVal hDllModule As Long) As Long
Declare Function GetProcAddress32W Lib "KERNEL" (ByVal hInstance As Long, ByVal FunctionName As String) As Long
Declare Function FindFirstFileA Lib "KERNEL" Alias "CallProc32W" (ByVal lpszFile As String, aFindFirst As WIN32_FIND_DATA, ByVal lpfnFunction As Long, ByVal fAddressConvert As Long, ByVal dwParams As Long) As Long
Declare Function GetShortPathNameA Lib "KERNEL" Alias "CallProc32W" (ByVal lpszLongFile As String, ByVal lpszShortFile As String, ByVal lBuffer As Long, ByVal lpfnFunction As Long, ByVal fAddressConvert As Long, ByVal dwParams As Long) As Long
Declare Function lcreat Lib "Kernel" Alias "_lcreat" (ByVal lpPathName As String, ByVal iAttribute As Integer) As Integer

Sub btnCancel_Click ()

   gShortFilename = ""
   gLongFilename = ""
   LF.Action = -1
   Unload Me

End Sub

' copyright 1996, Internet Software Engineering
Sub btnOpen_Click ()

   Dim szShortFilename As String * 256
   Dim p As Integer
   Dim a As Long
   Dim tmpstr As String
   Dim hFile As Integer
   Dim rtn As Integer

   tmpstr = lblFolders.Caption
   If Right$(tmpstr, 1) <> "\" Then tmpstr = tmpstr & "\"
   gLongFilename = tmpstr & txtFilename.Text

   'Convert the Long Filename to a Short Filename
   If LF.Action = 2 And Not gIn16BitSystem Then ' create the file
      hFile = lcreat(gLongFilename, 0)
      If hFile = -1 Then
	 MsgBox "File error.", 16, App.Title
      End If
   End If

   If Not gIn16BitSystem Then
      a = GetShortPathNameA(gLongFilename, szShortFilename, 256&, lpGetShortPathNameA, 6&, 3&)
      p = InStr(szShortFilename, Chr$(0))
      gShortFilename = Left$(szShortFilename, p - 1)
   Else
      gShortFilename = gLongFilename
   End If

   Unload Me

End Sub

' copyright 1996, Internet Software Engineering
Function ChangeLongFilenameToShort (Filename As String) As Integer
   
   ' the return value from this function seems backwards, but is correct
   ' returning false means we're not in a 16-bit system
   ' returning true means we are
   On Error GoTo ChangeLongFilenameToShort_Error

   Dim sFF As WIN32_FIND_DATA
   Dim a As Long
   Dim szShortFilename As String * 256
   Dim p As Integer

   ' load Kernel32
   hInstKernel = LoadLibraryEx32W("Kernel32.dll", 0&, 0&)

   ' get the address of the functions to deal with long filenames
   lpGetShortPathNameA = GetProcAddress32W(hInstKernel, "GetShortPathNameA")

   ' change the filename
   ' get the short name for the directory currently selected and clean it up
   a = GetShortPathNameA(Filename, szShortFilename, 256&, lpGetShortPathNameA, 6&, 3&)
   p = InStr(szShortFilename, Chr$(0))
   ChangeLongFilenameToShort = False
   gLongFilename = Filename
   gShortFilename = LCase$(Left$(szShortFilename, p - 1))

   ' release the Kernel if necessary
   a = FreeLibrary32W(hInstKernel)

   Exit Function
   
ChangeLongFilenameToShort_Error:
   ' must be no Win32 support, so just return the passed in filename
   ChangeLongFilenameToShort = True
   gLongFilename = Filename
   gShortFilename = Filename
   Exit Function


End Function

' copyright 1996, Internet Software Engineering
Function ChangeShortFilenameToLong (Filename As String) As Integer

   ' the return value from this function seems backwards, but is correct
   ' returning false means we're not in a 16-bit system
   ' returning true means we are
   On Error GoTo ChangeShortFilenameToLong_Error

   Dim sFF As WIN32_FIND_DATA
   Dim a As Long
   Dim szShortFilename As String * 256

   ' load Kernel32
   hInstKernel = LoadLibraryEx32W("Kernel32.dll", 0&, 0&)

   ' get the address of the functions to deal with long filenames
   lpFindFirstFileA = GetProcAddress32W(hInstKernel, "FindFirstFileA")

   'Use the Win32 call to convert any short filenames to long filenames
   a = FindFirstFileA(Filename, sFF, lpFindFirstFileA, 3&, 2&)
   gLongFilename = sFF.cFileName
   gShortFilename = Filename
   ChangeShortFilenameToLong = False

   ' release the Kernel if necessary
   a = FreeLibrary32W(hInstKernel)

   Exit Function

ChangeShortFilenameToLong_Error:
   ' must be no Win32 support, so just return the short filename
   ChangeShortFilenameToLong = True
   gLongFilename = Filename
   gShortFilename = Filename
   Exit Function

End Function

' copyright 1996, Internet Software Engineering
Function ChopPath (fn As String)

' returns the filename part of a combined pathfilename
' e.g. if passed c:\temp\text.txt returns text.txt

Dim x As Integer
Dim y As String

    For x = Len(fn) To 1 Step -1
   If Mid$(fn, x, 1) = "\" Then
       ChopPath = Mid$(fn, x + 1, Len(fn) - x)
       Exit Function
   End If
    Next
    
End Function

Sub comboFileTypes_Click ()

   Dim tmpstr As String

   tmpstr = comboFileTypes.Text
   txtFilename.Text = GetFileMask(tmpstr)

   FillFileListBox (lblFolders.Caption)


End Sub

' copyright 1996, Internet Software Engineering
Sub Dir1_Change ()

   Dim a As Long
   Dim sFF As WIN32_FIND_DATA
   Dim p As Integer, q As Integer
   Dim szDirectoryName As String
   Dim label1caption As String

   On Error GoTo Dir1_Change_Error

   If Not gIn16BitSystem Then
      ' get the long filename of the directory
      a = FindFirstFileA(Dir1.Path, sFF, lpFindFirstFileA, 3&, 2&)
   
      ' clean it up
      p = InStr(sFF.cFileName, Chr$(0))
      szDirectoryName = LCase$(Left$(sFF.cFileName, p - 1))
   Else
      szDirectoryName = Dir1.Path
   End If

   ' going to use lblFolders.Caption several times,
   ' so assign it to a variable for optimization
   label1caption = lblFolders.Caption

   ' check if it's already part of the path in the label
   p = InStr(LCase$(label1caption), szDirectoryName)

   ' if it is, then chop off anything following this name,
   ' but retaining the trailing \
   If Not gIn16BitSystem Then
      If p > 0 Then
	 q = InStr(p, label1caption, "\")
	 lblFolders.Caption = Left$(label1caption, q)
   
      ' otherwise add this new name to the end,
      ' always appending a \
      Else
	 If Right$(label1caption, 1) <> "\" Then label1caption = label1caption & "\"
	 lblFolders.Caption = label1caption & szDirectoryName & "\"
      End If

   ' don't need to chop if in 16 bit system as szDirectoryName will be correct
   Else
      lblFolders.Caption = szDirectoryName
   End If

   ' update the list box with the file names from this new directory
   FillFileListBox (lblFolders.Caption)

   Exit Sub


Dir1_Change_Error:
   
   Exit Sub

End Sub

Sub Drive1_Change ()

   Dir1.Path = Drive1.Drive
   lblFolders.Caption = Dir1.Path

End Sub

' copyright 1996, Internet Software Engineering
Sub FillFileListBox (directory As String)

   Dim sFF As WIN32_FIND_DATA
   Dim a As Long
   Dim szShortFilename As String * 256
   Dim tmpstr As String
   Dim p As Integer
   Dim q As Integer
   Dim szFilename As String
   Dim szFileMask As String

   On Error GoTo FillFileListBox_Error


   List1.Clear

   If Not gIn16BitSystem Then
      ' get the short name for the directory currently selected and clean it up
      a = GetShortPathNameA(directory, szShortFilename, 256&, lpGetShortPathNameA, 6&, 3&)
      p = InStr(szShortFilename, Chr$(0))
      szFilename = LCase$(Left$(szShortFilename, p - 1))
   Else
      ' no Win32 support, so go with unaltered directory name
      szFilename = directory
   End If
   If Right$(szFilename, 1) <> "\" Then szFilename = szFilename & "\"

   ' set the mask for the selected file type
   tmpstr = comboFileTypes.Text
   szFileMask = GetFileMask(tmpstr)

   ' fill the list box with the proper file names
   tmpstr = Dir$(szFilename & szFileMask)
   Do
      If tmpstr = "" Then Exit Do
      If Not gIn16BitSystem Then
	 'Use the Win32 call to convert any short filenames to long filenames
	 a = FindFirstFileA(szFilename & tmpstr, sFF, lpFindFirstFileA, 3&, 2&)
	 List1.AddItem sFF.cFileName
      Else
	 ' no Win32 support, so go with unaltered filename
	 List1.AddItem tmpstr
      End If
      tmpstr = Dir$
   Loop

   List1.Refresh

   Exit Sub

FillFileListBox_Error:
   
   Exit Sub

End Sub

' copyright 1996, Internet Software Engineering
Sub FillFileTypesBox (Filter As String, FilterIndex As Integer)

   On Error Resume Next

   Dim p As Integer
   Dim q As Integer
   Dim x As Integer

   p = 1
   q = InStr(Filter, "|")
   If q = 0 Then  ' invalid filter specified, so use default
      comboFileTypes.AddItem "Text (*.txt)"
      comboFileTypes.AddItem "All Files (*.*)"
      comboFileTypes.Text = "Text (*.txt)"
      txtFilename.Text = "*.txt"
      Exit Sub
   End If

   ' append a | for easier processing
   If Right$(Filter, 1) <> "|" Then Filter = Filter & "|"
   x = 1
   Do While q
      comboFileTypes.AddItem Mid$(Filter, p, q - p)
      If x = FilterIndex Then comboFileTypes.Text = Mid$(Filter, p, q - p)
      p = q + 1
      q = InStr(p, Filter, "|")
      If x = FilterIndex Then txtFilename.Text = Mid$(Filter, p, q - p)
      p = q + 1
      q = InStr(p, Filter, "|")
      x = x + 1
   Loop


End Sub

Sub Form_Activate ()

   ' initialize the directory list and file list box
'   Dir1.Path = Drive1.Drive
   lblFolders.Caption = Dir1.Path
   If Right$(lblFolders.Caption, 1) <> "\" Then lblFolders.Caption = lblFolders.Caption & "\"
   FillFileListBox (Dir1.Path)

End Sub

' copyright 1996, Internet Software Engineering
Sub Form_Load ()

   On Error GoTo DontGotWin32


   ' setup appearance from LongFile structure
   ' use defaults if not otherwise set
   If LF.Color > 0 Then
      BackColor = LF.Color
      lblFolders.BackColor = LF.Color
      Label2.BackColor = LF.Color
      Label3.BackColor = LF.Color
      Label4.BackColor = LF.Color
      Label5.BackColor = LF.Color
   Else
      BackColor = &HC0C0C0
   End If
   If LF.DialogTitle <> "Select File" And LF.DialogTitle <> "" Then
      Caption = LF.DialogTitle
   Else
      Caption = "Select File"
   End If
   If LF.Filter <> "Text (*.txt)|*.txt|All Files (*.*)|*.*" And LF.Filter <> "" Then
      Call FillFileTypesBox(LF.Filter, LF.FilterIndex)
   Else
      Call FillFileTypesBox("Text (*.txt)|*.txt|All Files (*.*)|*.*", 1)
   End If
   If LF.Filename <> "" Then
      Drive1.Drive = GetDrive(LF.Filename)
      txtFilename.Text = ChopPath(LF.Filename)
      lblFolders.Caption = GetPath(LF.Filename)
   End If

   ' load Kernel32
   hInstKernel = LoadLibraryEx32W("Kernel32.dll", 0&, 0&)

   ' get the address of the functions to deal with long filenames
   lpGetShortPathNameA = GetProcAddress32W(hInstKernel, "GetShortPathNameA")
   lpFindFirstFileA = GetProcAddress32W(hInstKernel, "FindFirstFileA")

   gIn16BitSystem = False


   Exit Sub

DontGotWin32:

   ' if here, then long filenames aren't supported,
   ' so set the gIn16BitSystem flag to true and set up
   ' for short filenames

   gIn16BitSystem = True


   Exit Sub

End Sub

Sub Form_Unload (Cancel As Integer)

   On Error Resume Next

   ' reset the LongFile structure
   If LF.Action <> -1 Then LF.Action = 0
   LF.Filename = ""

   If gIn16BitSystem = True Then Exit Sub

   Dim a As Long

   ' release the Kernel if necessary
   a = FreeLibrary32W(hInstKernel)


End Sub

' copyright 1996, Internet Software Engineering
Function GetDrive (fn As String)

' returns the drive part of a path filename
' the trailing \ is not returned
' e.g. if passed c:\temp\text.txt returns c:

Dim x As Integer
    
    x = InStr(fn, ":")
    If x > 0 Then
      GetDrive = Left$(fn, x)
    Else
      GetDrive = ""
    End If


End Function

' copyright 1996, Internet Software Engineering
Function GetFileMask (mask As String) As String

   Dim tmpstr As String
   Dim p As Integer
   Dim q As Integer
   Dim x As Integer

   tmpstr = mask
   p = InStr(tmpstr, "(")
   If p = 0 Then
      MsgBox "Invalid file type in List of File Types", 48, App.Title
      Exit Function
   End If
   p = p + 1
   q = InStr(p, tmpstr, ")")
   If q = 0 Then
      MsgBox "Invalid file type in List of File Types", 48, App.Title
      Exit Function
   End If
   GetFileMask = Mid$(tmpstr, p, q - p)

End Function

' copyright 1996, Internet Software Engineering
Function GetPath (fn As String)

' returns the path from a combined pathfilename
' the trailing \ is not returned
' e.g. if passed c:\temp\text.txt returns c:\temp

Dim x As Integer
Dim y As String

   For x = Len(fn) To 1 Step -1
      If Mid$(fn, x, 1) = "\" Then
	  GetPath = Mid$(fn, 1, x - 1)
	  Exit Function
      End If
   Next
    
End Function

Sub List1_Click ()

   txtFilename.Text = List1.List(List1.ListIndex)

End Sub

Sub List1_DblClick ()

   txtFilename.Text = List1.List(List1.ListIndex)
   btnOpen_Click

End Sub

