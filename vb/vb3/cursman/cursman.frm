VERSION 2.00
Begin Form Form1 
   BackColor       =   &H00C0C0C0&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Cursor Manipulations - (c)1992 Pierre Fillion"
   ClientHeight    =   4680
   ClientLeft      =   1290
   ClientTop       =   1425
   ClientWidth     =   6195
   ControlBox      =   0   'False
   Height          =   5085
   Left            =   1230
   LinkMode        =   1  'Source
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4680
   ScaleMode       =   0  'User
   ScaleWidth      =   6195
   Top             =   1080
   Width           =   6315
   Begin CommandButton Command6 
      Caption         =   "&UnClip Cursor"
      Height          =   315
      Left            =   3450
      TabIndex        =   8
      Top             =   4200
      Width           =   1965
   End
   Begin CommandButton Command5 
      Caption         =   "&Clip Cursor"
      Height          =   315
      Left            =   750
      TabIndex        =   7
      Top             =   4200
      Width           =   1965
   End
   Begin CommandButton Command4 
      Caption         =   "&Show cursor"
      Height          =   315
      Left            =   3450
      TabIndex        =   6
      Top             =   3750
      Width           =   1965
   End
   Begin CommandButton Command3 
      Caption         =   "&Hide cursor"
      Height          =   315
      Left            =   750
      TabIndex        =   5
      Top             =   3750
      Width           =   1965
   End
   Begin CommandButton Command1 
      Caption         =   "E&xit"
      Height          =   315
      Left            =   3450
      TabIndex        =   1
      Top             =   3300
      Width           =   1965
   End
   Begin CommandButton Command2 
      Caption         =   "&Go to position "
      Height          =   315
      Left            =   750
      TabIndex        =   2
      Top             =   3300
      Width           =   1965
   End
   Begin Label Label3 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Click in box to set a position"
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   12
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   2565
      Left            =   150
      TabIndex        =   4
      Top             =   600
      Width           =   5865
   End
   Begin Label Label2 
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   1  'Fixed Single
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   315
      Left            =   3300
      TabIndex        =   3
      Top             =   150
      Width           =   2715
   End
   Begin Label Label1 
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   1  'Fixed Single
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      ForeColor       =   &H00000000&
      Height          =   315
      Left            =   150
      TabIndex        =   0
      Top             =   150
      Width           =   3015
   End
End
Sub Command1_Click ()

'Exit the program
End

End Sub

Sub Command2_Click ()

'Call API function to set cursor position on the screen
'defined in tPos.X and tPos.Y in Sub Label3_Click ()

A% = SetCursorPos(tPos.x, tPos.Y)

End Sub

Sub Command3_Click ()

'Verify if the cursor is already hidden (to prevent stacking)
'If not hide it!

If C_State <> C_Hide Then
   Ret% = ShowCursor(C_Hide)
   C_State = C_Hide
   Form1.Label3.Caption = "Press Alt+S to show cursor"
End If
  
End Sub

Sub Command4_Click ()

'Verify if the cursor is already showed (to prevent stacking)
'If not show it!

If C_State <> C_Show Then
   Ret% = ShowCursor(C_Show)
   C_State = C_Show
   Form1.Label3.Caption = "Click in box to set a position"
End If

End Sub

Sub Command5_Click ()

'Clip Positions defined on Form1 positions
'Divided by 15 to convert twips in pixels for the API call
ClipWin.Left = Form1.Left / 15
ClipWin.Top = Form1.Top / 15
ClipWin.Right = (Form1.Left + Form1.Width) / 15
ClipWin.Bottom = (Form1.Top + Form1.Height) / 15

Form1.Label3.Caption = "Click in box to set a position" + Chr$(13) + "Clip= T:" + Str$(ClipWin.Top) + " L:" + Str$(ClipWin.Left) + " R:" + Str$(ClipWin.Right) + " B:" + Str$(ClipWin.Bottom)

'Call API to clip cursor in positions
Call ClipCursor(ClipWin)

End Sub

Sub Command6_Click ()

'Clip Positions defined on screen resolution
'Divided by 15 to convert twips in pixels for the API call
ClipWin.Left = 0
ClipWin.Top = 0
ClipWin.Right = Screen.Width / 15
ClipWin.Bottom = Screen.Height / 15

Form1.Label3.Caption = "Click in box to set a position" + Chr$(13) + "Clip= T:" + Str$(ClipWin.Top) + " L:" + Str$(ClipWin.Left) + " R:" + Str$(ClipWin.Right) + " B:" + Str$(ClipWin.Bottom)

'Call API to clip cursor in positions
Call ClipCursor(ClipWin)

End Sub

Sub Label3_Click ()

'Store the current position of the cursor on mouse click in Label3
Call GetCursorPos(tPos)

End Sub

Sub Picture1_Click ()
Call GetCursorPos(tPos)
End Sub

Sub Picture2_Click ()
Call GetCursorPos(tPos)
Call Main
End Sub

Sub Picture3_Click ()
Call GetCursorPos(tPos)
Call Main

End Sub

Sub Picture4_Click ()
Call GetCursorPos(tPos)
Call Main

End Sub

