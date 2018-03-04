VERSION 2.00
Begin Form Form1 
   Caption         =   "TaskLister"
   ClipControls    =   0   'False
   Height          =   4395
   Icon            =   TASKLIST.FRX:0000
   Left            =   930
   LinkTopic       =   "Form1"
   ScaleHeight     =   3975
   ScaleWidth      =   7155
   Top             =   1365
   Width           =   7275
   Begin Frame Frame1 
      Caption         =   "Modules to Exclude/Include"
      Height          =   855
      Left            =   3660
      TabIndex        =   6
      Top             =   0
      Width           =   3435
      Begin ComboBox Combo_LookFor 
         FontBold        =   0   'False
         FontItalic      =   0   'False
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   315
         Left            =   60
         TabIndex        =   9
         Top             =   480
         Width           =   2355
      End
      Begin CommandButton Command_Delete 
         Caption         =   "Delete"
         FontBold        =   0   'False
         FontItalic      =   0   'False
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   255
         Left            =   2520
         TabIndex        =   8
         Top             =   480
         Width           =   855
      End
      Begin CommandButton Command_ClearList 
         Caption         =   "Clear List"
         FontBold        =   0   'False
         FontItalic      =   0   'False
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   255
         Left            =   2520
         TabIndex        =   7
         Top             =   180
         Width           =   855
      End
      Begin OptionButton Option_Exclude 
         Caption         =   "Exclude"
         FontBold        =   0   'False
         FontItalic      =   0   'False
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   255
         Left            =   1320
         TabIndex        =   11
         Top             =   240
         Value           =   -1  'True
         Width           =   915
      End
      Begin OptionButton Option_Include 
         Caption         =   "Include"
         FontBold        =   0   'False
         FontItalic      =   0   'False
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   255
         Left            =   240
         TabIndex        =   10
         Top             =   240
         Width           =   855
      End
   End
   Begin CheckBox Check_Parent 
      Caption         =   "Show Parent Windows Only"
      FontBold        =   0   'False
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   255
      Left            =   4680
      TabIndex        =   5
      Top             =   900
      Width           =   2415
   End
   Begin CommandButton Command_ReloadTasklist 
      Caption         =   "(c) 1996 - nix Box Industries"
      FontBold        =   0   'False
      FontItalic      =   -1  'True
      FontName        =   "MS Sans Serif"
      FontSize        =   13.5
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   495
      Left            =   60
      TabIndex        =   4
      Top             =   60
      Width           =   3555
   End
   Begin PictureBox pic 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00FFFFFF&
      ClipControls    =   0   'False
      FontBold        =   0   'False
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   2655
      Left            =   60
      ScaleHeight     =   2625
      ScaleWidth      =   7005
      TabIndex        =   3
      Top             =   1260
      Width           =   7035
   End
   Begin CommandButton Command_OK 
      Caption         =   "Activate"
      FontBold        =   0   'False
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   255
      Left            =   2400
      TabIndex        =   2
      Top             =   600
      Width           =   1035
   End
   Begin ComboBox Combo_TaskList 
      FontBold        =   0   'False
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   315
      Left            =   240
      TabIndex        =   1
      Top             =   900
      Width           =   4395
   End
   Begin Label Label1 
      Caption         =   "Application to AppActivate:"
      FontBold        =   0   'False
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   255
      Left            =   60
      TabIndex        =   0
      Top             =   660
      Width           =   2055
   End
End
DefInt A-Z
Dim thehwnd(255) As Integer

'Windows API function declarations:
'Enter each entire Declare statement on one, single line:
Declare Function GetWindow Lib "user" (ByVal hWnd As Integer, ByVal wCmd As Integer) As Integer
Declare Function GetWindowText Lib "user" (ByVal hWnd As Integer, ByVal lpSting$, ByVal nMaxCount As Integer) As Integer
Declare Function GetWindowTextLength Lib "user" (ByVal hWnd As Integer) As Integer
' Enter each of the following Declare statements on one, single line:
'Declare Sub GetCursorPos Lib "User" (lpPoint As Long)
'Declare Function WindowFromPoint Lib "User" (ByVal ptScreen As Any) As Integer
Declare Function GetModuleFileName Lib "Kernel" (ByVal hModule As Integer, ByVal lpFilename As String, ByVal nSize As Integer) As Integer
Declare Function GetWindowWord Lib "User" (ByVal hWnd As Integer, ByVal nIndex As Integer) As Integer
Declare Function GetWindowLong Lib "User" (ByVal hWnd As Integer, ByVal nIndex As Integer) As Long
Declare Function GetParent Lib "User" (ByVal hWnd As Integer) As Integer
Declare Function GetClassName Lib "User" (ByVal hWnd As Integer, ByVal lpClassName As String, ByVal nMaxCount As Integer) As Integer

Const GWW_HINSTANCE = (-6)
Const GWW_ID = (-12)
Const GWL_STYLE = (-16)


'Declare constants used by GetWindow.
Const GW_CHILD = 5
Const GW_HWNDFIRST = 0
Const GW_HWNDLAST = 1
Const GW_HWNDNEXT = 2
Const GW_HWNDPREV = 3
Const GW_OWNER = 4

Sub Check_Parent_Click ()

LoadTasklist
combo_tasklist.SetFocus

End Sub

Sub combo_lookfor_gotfocus ()
combo_lookfor.SelStart = 0
combo_lookfor.SelLength = Len(combo_lookfor.Text)
End Sub

Sub Combo_LookFor_KeyPress (keyascii As Integer)
If keyascii = 13 Then
    If combo_lookfor.Text <> "" Then
        combo_lookfor.AddItem UCase$(combo_lookfor.Text)
        combo_lookfor.Text = UCase$(combo_lookfor.Text)
        LoadTasklist
    End If
    keyascii = 0
    combo_lookfor_gotfocus
End If
End Sub

Sub Combo_TaskList_Click ()
      Dim sWindowText As String * 100
      Dim sClassName As String * 100
      Dim hWndOver As Integer
      Dim hWndParent As Integer
      Dim sParentClassName As String * 100
      Dim wID As Integer
      Dim lWindowStyle As Long
      Dim hInstance As Integer

      Dim sParentWindowText As String * 100
      Dim sModuleFileName As String * 100
      Static hWndLast As Integer

      hWndOver = thehwnd(combo_tasklist.ListIndex)

        pic.Cls                                      ' Clear the form
        pic.Print "Window Handle: &H"; Hex(hWndOver) ' Display window handle

        r = GetWindowText(hWndOver, sWindowText, 100)      ' Window text

        pic.Print "Window Text: " & Left(sWindowText, r)

        r = GetClassName(hWndOver, sClassName, 100)         ' Window Class
        pic.Print "Window Class Name: "; Left(sClassName, r)

        lWindowStyle = GetWindowLong(hWndOver, GWL_STYLE)   ' Window Style
        pic.Print "Window Style: &H"; Hex(lWindowStyle)
        ' Get handle of parent window:
        hWndParent = GetParent(hWndOver)
        ' If there is a parent get more info:
        If hWndParent <> 0 Then
        ' Get ID of window:
        wID = GetWindowWord(hWndOver, GWW_ID)

        pic.Print "Window ID Number: &H"; Hex(wID)
        pic.Print "Parent Window Handle: &H"; Hex(hWndParent)
        ' Get the text of the Parent window:
        r = GetWindowText(hWndParent, sParentWindowText, 100)
        pic.Print "Parent Window Text: " & Left(sParentWindowText, r)
        ' Get the class name of the parent window:
        r = GetClassName(hWndParent, sParentClassName, 100)
        pic.Print "Parent Window Class Name: "; Left(sParentClassName, r)
        Else
        ' Update fields when no parent:

        pic.Print "Window ID Number: N/A"
        pic.Print "Parent Window Handle: N/A"
        pic.Print "Parent Window Text : N/A"
        pic.Print "Parent Window Class Name: N/A"
        End If
        ' Get window instance:
        hInstance = GetWindowWord(hWndOver, GWW_HINSTANCE)
        ' Get module file name:
        r = GetModuleFileName(hInstance, sModuleFileName, 100)
        pic.Print "Module: "; Left(sModuleFileName, r)
End Sub

Sub Command_ClearList_Click ()
combo_lookfor.Clear
End Sub

Sub Command_Delete_Click ()
For i = combo_lookfor.ListCount - 1 To 0 Step -1
    If combo_lookfor.Text = combo_lookfor.List(i) Then
        combo_lookfor.RemoveItem i
    End If
Next
LoadTasklist
End Sub

Sub Command_Ok_Click ()
      'Get the item selected from the text portion of the combo box.
      f$ = combo_tasklist.Text

      'Resume if "Illegal function call" occurs on AppActivate statement.
      On Local Error Resume Next

      AppActivate f$
      If Err Then
        MsgBox "Couldn't activate...", , "Hi There"
      End If
End Sub

Sub Command_ReloadTasklist_Click ()

LoadTasklist

End Sub

Sub Form_Load ()

Call LoadTasklist

'If no items are in the task list, end the program.
If combo_tasklist.ListCount > 0 Then
    combo_tasklist.Text = combo_tasklist.List(0)
Else
    MsgBox "Nothing found in task list", 16, "AppActivate"
    Unload Form1
End If
End Sub

Sub LoadTasklist ()

Dim sModuleFileName As String * 100
Dim hInstance As Integer

combo_tasklist.Clear
Erase thehwnd

i = 0
'Get the hWnd of the first item in the master list
'so we can process the task list entries (top-level only).
If check_parent.Value Then
    lastwnd = GetWindow(Form1.hWnd, GW_HWNDFIRST)
Else
    currwnd = GetWindow(Form1.hWnd, GW_HWNDFIRST)
End If

another:
    
If check_parent.Value Then
    currwnd = GetWindow(lastwnd, GW_OWNER)
    If currwnd <> 0 And currwnd <> lastwnd Then
        lastwnd = currwnd
        GoTo another
    End If
    currwnd = lastwnd
End If

If currwnd = 0 Then
    pic.Cls
    If combo_tasklist.ListCount > 0 Then combo_tasklist.ListIndex = 0
    Exit Sub
End If
'Get the length of task name identified by CurrWnd in the list.
Length = GetWindowTextLength(currwnd)

'Get task name of the task in the master list.
listitem$ = Space$(Length + 1)

Length = GetWindowText(currwnd, listitem$, Length + 1)

'If there is a task name in the list, add the item to the list.
If Length > 0 Then
    ' Get module file name:
    hInstance = GetWindowWord(currwnd, GWW_HINSTANCE)
    r = GetModuleFileName(hInstance, sModuleFileName$, 100)
    check$ = UCase$(Left$(sModuleFileName$, r))
    ' check module name against LookFor combo:
    If option_exclude Then addit = True Else addit = False
    
    For q = 0 To combo_lookfor.ListCount - 1
        If option_exclude Then
            addit = addit And InStr(check$, combo_lookfor.List(q)) = False
        Else
            addit = addit Or InStr(check$, combo_lookfor.List(q))
        End If
    Next
    
    If addit Then
        combo_tasklist.AddItem listitem$
        thehwnd(i) = currwnd
        i = i + 1
    End If
End If

'Get the next task list item in the master list.
If check_parent.Value Then
    lastwnd = GetWindow(currwnd, GW_HWNDNEXT)
Else
    currwnd = GetWindow(currwnd, GW_HWNDNEXT)
End If

'Process Windows events.
DoEvents
GoTo another
   
End Sub

Sub Option_Exclude_Click ()
LoadTasklist
End Sub

Sub Option_Include_Click ()
LoadTasklist
End Sub

