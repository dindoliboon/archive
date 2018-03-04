VERSION 2.00
Begin Form frmSetTime 
   BackColor       =   &H8000000F&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Time & Date Stamp"
   ClientHeight    =   4860
   ClientLeft      =   465
   ClientTop       =   1335
   ClientWidth     =   7710
   Height          =   5265
   Icon            =   FRMSETTI.FRX:0000
   Left            =   405
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   4860
   ScaleWidth      =   7710
   Top             =   990
   Width           =   7830
   Begin CommandButton cmdAbout 
      Caption         =   "&About..."
      Height          =   375
      Left            =   5800
      TabIndex        =   15
      Top             =   2160
      Width           =   1635
   End
   Begin Timer timNow 
      Interval        =   500
      Left            =   5820
      Top             =   3420
   End
   Begin ListBox lstFiles 
      FontBold        =   0   'False
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   3930
      Left            =   2460
      MultiSelect     =   2  'Extended
      TabIndex        =   11
      Top             =   120
      Width           =   3195
   End
   Begin CommandButton cmdStart 
      Caption         =   "Start"
      Default         =   -1  'True
      Enabled         =   0   'False
      Height          =   435
      Left            =   5800
      TabIndex        =   10
      Top             =   720
      Width           =   1395
   End
   Begin ComboBox cboTypes 
      Height          =   300
      Left            =   2460
      Style           =   2  'Dropdown List
      TabIndex        =   7
      Top             =   4440
      Width           =   2715
   End
   Begin DriveListBox Drive1 
      Height          =   315
      Left            =   60
      TabIndex        =   6
      Top             =   900
      Width           =   2175
   End
   Begin DirListBox Dir1 
      Height          =   3405
      Left            =   60
      TabIndex        =   5
      Top             =   1320
      Width           =   2175
   End
   Begin FileListBox File1 
      Height          =   420
      Left            =   6240
      TabIndex        =   4
      Top             =   3240
      Visible         =   0   'False
      Width           =   1395
   End
   Begin TextBox txtTime 
      Height          =   285
      Left            =   480
      TabIndex        =   2
      Top             =   480
      Width           =   1455
   End
   Begin TextBox txtDate 
      Height          =   285
      Left            =   480
      TabIndex        =   1
      Top             =   60
      Width           =   1455
   End
   Begin Label lblGeneral 
      AutoSize        =   -1  'True
      BackColor       =   &H8000000F&
      BackStyle       =   0  'Transparent
      Caption         =   "Date/Time Now:"
      FontBold        =   0   'False
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   195
      Index           =   4
      Left            =   5800
      TabIndex        =   14
      Top             =   1320
      Width           =   1185
   End
   Begin Label lblTime 
      AutoSize        =   -1  'True
      BackColor       =   &H8000000F&
      BackStyle       =   0  'Transparent
      Caption         =   "04/10/95 12:00:00"
      Height          =   195
      Left            =   5800
      TabIndex        =   13
      Top             =   1560
      Width           =   1635
   End
   Begin Label lblSelectCount 
      AutoSize        =   -1  'True
      BackColor       =   &H8000000F&
      BackStyle       =   0  'Transparent
      Caption         =   "0"
      Height          =   195
      Left            =   5800
      TabIndex        =   12
      Top             =   360
      Width           =   120
   End
   Begin Label lblGeneral 
      AutoSize        =   -1  'True
      BackColor       =   &H8000000F&
      BackStyle       =   0  'Transparent
      Caption         =   "Number Of Files Selected:"
      FontBold        =   0   'False
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   195
      Index           =   3
      Left            =   5800
      TabIndex        =   9
      Top             =   120
      Width           =   1845
   End
   Begin Label lblGeneral 
      AutoSize        =   -1  'True
      BackColor       =   &H8000000F&
      BackStyle       =   0  'Transparent
      Caption         =   "View File T&ypes:"
      FontBold        =   0   'False
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   195
      Index           =   2
      Left            =   2460
      TabIndex        =   8
      Top             =   4200
      Width           =   1155
   End
   Begin Label lblGeneral 
      AutoSize        =   -1  'True
      BackColor       =   &H8000000F&
      BackStyle       =   0  'Transparent
      Caption         =   "&Time:"
      FontBold        =   0   'False
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   195
      Index           =   1
      Left            =   60
      TabIndex        =   3
      Top             =   480
      Width           =   390
   End
   Begin Label lblGeneral 
      AutoSize        =   -1  'True
      BackColor       =   &H8000000F&
      BackStyle       =   0  'Transparent
      Caption         =   "&Date:"
      FontBold        =   0   'False
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   195
      Index           =   0
      Left            =   60
      TabIndex        =   0
      Top             =   60
      Width           =   390
   End
End
Option Explicit

Sub cboTypes_Click ()
    Screen.MousePointer = 11
    File1.Pattern = cboTypes
    Screen.MousePointer = 0
End Sub

Sub cmdAbout_Click ()
    Screen.MousePointer = 11
    frmAbout.Show 1
    Screen.MousePointer = 0
End Sub

Sub cmdStart_Click ()
    Dim iFreeFile As Integer, i As Integer
    Dim sPath As String, sFile As String, sDateToDo As String, sTimeToDo As String
    Dim sByte As String * 1
    Dim vRemember As Variant

    sDateToDo = Format(DateValue(txtDate), "mm/dd/yy")
    sTimeToDo = Format(TimeValue(txtTime) + 1 / 86400, "hh:mm:ss")
    sPath = File1.Path
    If Right(sPath, 1) <> "\" Then
        sPath = sPath + "\"
    End If
    For i = 0 To lstFiles.ListCount - 1
        If lstFiles.Selected(i) Then
            iFreeFile = FreeFile
            Open sPath + File1.List(i) For Binary As iFreeFile
                Get iFreeFile, 1, sByte
                Put iFreeFile, 1, sByte
                vRemember = Now
                Date$ = sDateToDo
                Time$ = sTimeToDo
            Close iFreeFile
            Date$ = Format(vRemember, "mm/dd/yy")
            Time$ = Format(vRemember, "hh:mm:ss")
        End If
    Next i
    Call UpdateList
End Sub

Sub Dir1_Change ()
    Screen.MousePointer = 11
    File1.Path = Dir1.Path
    Screen.MousePointer = 0
End Sub

Sub Drive1_Change ()
    Screen.MousePointer = 11
    Dir1.Path = Drive1.Drive
    Screen.MousePointer = 0
End Sub

Sub File1_PathChange ()
    Call UpdateList
End Sub

Sub File1_PatternChange ()
    Call UpdateList
End Sub

Sub Form_Load ()
    Dim iRes As Integer
    Dim sTemp As String

    sAppPath = App.Path
    If Right(sAppPath, 1) <> "\" Then
        sAppPath = sAppPath + "\"
    End If
    
    txtDate = Format(Now, "Short Date")
    txtTime = "00:00:00"
    cboTypes.AddItem "*.*"
    cboTypes.AddItem "*.EXE"
    cboTypes.AddItem "*.DLL"
    cboTypes.AddItem "*.BMP;*.WMF"
    cboTypes.AddItem "*.FRM"
    cboTypes.ListIndex = 0
    iRes = SendMessage(lstFiles.hWnd, LB_SETTABSTOPS, 1, 60)
    
    ' See if INI file contains path and file list
    sTemp = ReadFromINI("Prefs", "LastPath")
    If sTemp <> "*ERROR*" Then
        Err = 0
        On Error Resume Next
        Drive1.Drive = Left(sTemp, 2)
        Dir1.Path = sTemp
    End If
    sTemp = ReadFromINI("Prefs", "LastDate")
    If sTemp <> "*ERROR*" Then
        txtDate = sTemp
    End If
    sTemp = ReadFromINI("Prefs", "LastTime")
    If sTemp <> "*ERROR*" Then
        txtTime = sTemp
    End If
    sTemp = ReadFromINI("Prefs", "LastPattern")
    If sTemp <> "*ERROR*" Then
        cboTypes.ListIndex = Val(sTemp)
    End If
    
    Call UpdateList
    Call timNow_Timer
End Sub

Sub Form_QueryUnload (Cancel As Integer, UnloadMode As Integer)
    Dim iRes As Integer
    
    iRes = WriteToINI("Prefs", "LastPath", (File1.Path))
    iRes = WriteToINI("Prefs", "LastDate", (txtDate))
    iRes = WriteToINI("Prefs", "LastTime", (txtTime))
    iRes = WriteToINI("Prefs", "LastPattern", (cboTypes.ListIndex))
End Sub

Sub lblSelectCount_Change ()
    If Val(lblSelectCount) > 0 Then
        cmdStart.Enabled = True
    Else
        cmdStart.Enabled = False
    End If
End Sub

Sub lstFiles_Click ()
    lblSelectCount = CStr(lstFiles.SelCount) + "/" + CStr(lstFiles.ListCount)
End Sub

Sub timNow_Timer ()
    lblTime = Format(Now, "Short Date") + " " + Format(Now, "hh:mm:ss")
End Sub

Sub UpdateList ()
    Dim i As Integer
    Dim sPath As String, sFile As String, sTemp As String
    Dim sInfo As String

    sPath = File1.Path
    If Right(sPath, 1) <> "\" Then
        sPath = sPath + "\"
    End If
    lstFiles.Clear
    lblSelectCount = "0"
    For i = 0 To File1.ListCount - 1
        sFile = File1.List(i)
        sTemp = sFile + Chr(9)
        sInfo = FileDateTime(sPath + sFile)
        sTemp = sTemp + Format(sInfo, "Short Date") + " " + Format(sInfo, "hh:mm:ss")
        lstFiles.AddItem sTemp
    Next i
    lblSelectCount = "0/" + CStr(lstFiles.ListCount)
End Sub

