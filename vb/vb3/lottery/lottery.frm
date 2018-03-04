VERSION 2.00
Begin Form Main 
   BackColor       =   &H00C0C0C0&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Dunks Lotto Picker Ver 2"
   ClientHeight    =   4800
   ClientLeft      =   1335
   ClientTop       =   975
   ClientWidth     =   7095
   FontBold        =   -1  'True
   FontItalic      =   0   'False
   FontName        =   "Times New Roman"
   FontSize        =   10.5
   FontStrikethru  =   0   'False
   FontUnderline   =   0   'False
   Height          =   5205
   Icon            =   LOTTERY.FRX:0000
   Left            =   1275
   MaxButton       =   0   'False
   ScaleHeight     =   4800
   ScaleWidth      =   7095
   Top             =   630
   Width           =   7215
   Begin VScrollBar spin1 
      Height          =   315
      Left            =   2700
      Max             =   1
      Min             =   1000
      TabIndex        =   24
      Top             =   420
      Value           =   101
      Width           =   315
   End
   Begin CommandButton Command1 
      Caption         =   "Pick Numbers"
      Default         =   -1  'True
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "Times New Roman"
      FontSize        =   19.5
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   675
      Left            =   45
      TabIndex        =   3
      Top             =   4080
      Width           =   2565
   End
   Begin CommandButton Command5 
      Caption         =   "Clear List"
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "Times New Roman"
      FontSize        =   15
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   615
      Left            =   60
      TabIndex        =   2
      Top             =   3405
      Width           =   2535
   End
   Begin CommandButton Command2 
      Caption         =   "About"
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "Times New Roman"
      FontSize        =   18
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   570
      Left            =   5820
      TabIndex        =   5
      Top             =   3390
      Width           =   1200
   End
   Begin CheckBox Fast 
      BackColor       =   &H00FF8080&
      Caption         =   "Fast Ball Choosing?"
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   255
      Left            =   1065
      TabIndex        =   1
      Top             =   15
      Width           =   2310
   End
   Begin ListBox List1 
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "Times New Roman"
      FontSize        =   10.5
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   1050
      Left            =   2715
      TabIndex        =   4
      Top             =   3435
      Width           =   3015
   End
   Begin CommandButton Command4 
      Caption         =   "Quit"
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "Times New Roman"
      FontSize        =   24
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   705
      Left            =   5835
      MousePointer    =   1  'Arrow
      TabIndex        =   6
      Top             =   3990
      Width           =   1185
   End
   Begin Frame Frame1 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Your Numbers are....."
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "Times New Roman"
      FontSize        =   9.75
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   1410
      Left            =   30
      TabIndex        =   7
      Top             =   1905
      Width           =   7020
      Begin Label Label 
         BackStyle       =   0  'Transparent
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "Times New Roman"
         FontSize        =   37.5
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   720
         Index           =   1
         Left            =   225
         TabIndex        =   16
         Top             =   315
         Width           =   780
      End
      Begin Label Label 
         BackStyle       =   0  'Transparent
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "Times New Roman"
         FontSize        =   37.5
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   705
         Index           =   6
         Left            =   6045
         TabIndex        =   21
         Top             =   315
         Width           =   750
      End
      Begin Label Label 
         BackStyle       =   0  'Transparent
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "Times New Roman"
         FontSize        =   37.5
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   705
         Index           =   5
         Left            =   4845
         TabIndex        =   20
         Top             =   300
         Width           =   780
      End
      Begin Label Label 
         BackStyle       =   0  'Transparent
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "Times New Roman"
         FontSize        =   37.5
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   720
         Index           =   4
         Left            =   3705
         TabIndex        =   19
         Top             =   300
         Width           =   780
      End
      Begin Label Label 
         BackStyle       =   0  'Transparent
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "Times New Roman"
         FontSize        =   37.5
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   750
         Index           =   3
         Left            =   2550
         TabIndex        =   18
         Top             =   315
         Width           =   765
      End
      Begin Label Label 
         BackStyle       =   0  'Transparent
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "Times New Roman"
         FontSize        =   37.5
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         Height          =   735
         Index           =   2
         Left            =   1410
         TabIndex        =   17
         Top             =   315
         Width           =   735
      End
      Begin Shape Shape 
         BackStyle       =   1  'Opaque
         BorderWidth     =   2
         Height          =   1140
         Index           =   6
         Left            =   5865
         Shape           =   3  'Circle
         Top             =   180
         Width           =   1080
      End
      Begin Shape Shape 
         BackStyle       =   1  'Opaque
         BorderWidth     =   2
         Height          =   1140
         Index           =   5
         Left            =   4710
         Shape           =   3  'Circle
         Top             =   180
         Width           =   1080
      End
      Begin Shape Shape 
         BackStyle       =   1  'Opaque
         BorderWidth     =   2
         Height          =   1140
         Index           =   4
         Left            =   3555
         Shape           =   3  'Circle
         Top             =   180
         Width           =   1080
      End
      Begin Shape Shape 
         BackStyle       =   1  'Opaque
         BorderWidth     =   2
         Height          =   1140
         Index           =   3
         Left            =   2400
         Shape           =   3  'Circle
         Top             =   180
         Width           =   1080
      End
      Begin Shape Shape 
         BackStyle       =   1  'Opaque
         BorderWidth     =   2
         Height          =   1140
         Index           =   2
         Left            =   1245
         Shape           =   3  'Circle
         Top             =   180
         Width           =   1080
      End
      Begin Shape Shape 
         BackColor       =   &H00FFFFFF&
         BackStyle       =   1  'Opaque
         BorderWidth     =   2
         Height          =   1140
         Index           =   1
         Left            =   120
         Shape           =   3  'Circle
         Top             =   180
         Width           =   1080
      End
   End
   Begin CheckBox PrintIt 
      BackColor       =   &H00FF8080&
      Caption         =   "Print?"
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   255
      Left            =   15
      TabIndex        =   0
      Top             =   15
      Width           =   990
   End
   Begin CommandButton Command6 
      Caption         =   "Stop"
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "Times New Roman"
      FontSize        =   19.5
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   675
      Left            =   45
      MousePointer    =   1  'Arrow
      TabIndex        =   9
      Top             =   4080
      Width           =   2565
   End
   Begin ListBox List2 
      Height          =   1005
      Left            =   2910
      TabIndex        =   23
      Top             =   3570
      Width           =   2565
   End
   Begin Label Repeat 
      Alignment       =   2  'Center
      BackColor       =   &H0080FF80&
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "Times New Roman"
      FontSize        =   9.75
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   255
      Left            =   1980
      TabIndex        =   22
      Top             =   420
      Width           =   630
   End
   Begin Label Caption 
      AutoSize        =   -1  'True
      BackColor       =   &H0080FF80&
      Caption         =   "How Many Draws?"
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "Times New Roman"
      FontSize        =   10.5
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   255
      Index           =   0
      Left            =   120
      TabIndex        =   15
      Top             =   420
      Width           =   1695
   End
   Begin Label Caption 
      BackColor       =   &H00C0C0C0&
      BackStyle       =   0  'Transparent
      Caption         =   "Programs"
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "Times New Roman"
      FontSize        =   15.75
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      ForeColor       =   &H00FF0000&
      Height          =   405
      Index           =   6
      Left            =   1800
      TabIndex        =   14
      Top             =   1320
      Width           =   1515
   End
   Begin Label Caption 
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      BackStyle       =   0  'Transparent
      Caption         =   "S"
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "Times New Roman"
      FontSize        =   21.75
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      ForeColor       =   &H0000FFFF&
      Height          =   480
      Index           =   5
      Left            =   1155
      TabIndex        =   13
      Top             =   1260
      Width           =   240
   End
   Begin Label Caption 
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      BackStyle       =   0  'Transparent
      Caption         =   "A"
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "Times New Roman"
      FontSize        =   21.75
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      ForeColor       =   &H00FF0000&
      Height          =   480
      Index           =   4
      Left            =   840
      TabIndex        =   12
      Top             =   1245
      Width           =   300
   End
   Begin Label Caption 
      AutoSize        =   -1  'True
      BackColor       =   &H00C0C0C0&
      BackStyle       =   0  'Transparent
      Caption         =   "D"
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "Times New Roman"
      FontSize        =   21.75
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      ForeColor       =   &H0000FF00&
      Height          =   480
      Index           =   3
      Left            =   525
      TabIndex        =   11
      Top             =   1260
      Width           =   315
   End
   Begin Label Caption 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Brought to you by..."
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "Times New Roman"
      FontSize        =   15.75
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      ForeColor       =   &H00800000&
      Height          =   420
      Index           =   2
      Left            =   60
      TabIndex        =   10
      Top             =   780
      Width           =   2790
   End
   Begin Label Caption 
      BackColor       =   &H00C0FFC0&
      Caption         =   "Dunks Lotto Picker"
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "Times New Roman"
      FontSize        =   33.75
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      ForeColor       =   &H00800000&
      Height          =   1575
      Index           =   1
      Left            =   3480
      TabIndex        =   8
      Top             =   120
      Width           =   3585
   End
   Begin Shape Shape8 
      BackColor       =   &H000000FF&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00000000&
      Height          =   435
      Left            =   1425
      Top             =   1290
      Width           =   300
   End
   Begin Shape Shape7 
      BackColor       =   &H000000FF&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00000000&
      Height          =   435
      Left            =   195
      Top             =   1290
      Width           =   300
   End
End
Dim Numbers(1 To 6)
Dim num
Dim Green
Dim Pink
Dim Yellow
Dim White
Dim Blue
Dim endgen
Dim getvar(0 To 6)
Dim textlast$

Sub Check ()
For b = 1 To 6
Here1:
If Numbers(1) = Numbers(b) And b <> 1 Then
    Numbers(1) = Int(Rnd * 48) + 1
    GoTo Here1
End If
Next

For b = 1 To 6
Here2:
If Numbers(2) = Numbers(b) And b <> 2 Then
    Numbers(2) = Int(Rnd * 48) + 1
    GoTo Here2
End If
Next

For b = 1 To 6
Here3:
If Numbers(3) = Numbers(b) And b <> 3 Then
    Numbers(3) = Int(Rnd * 48) + 1
    GoTo Here3
End If
Next

For b = 1 To 6
Here4:
If Numbers(4) = Numbers(b) And b <> 4 Then
    Numbers(4) = Int(Rnd * 48) + 1
    GoTo Here4
End If
Next

For b = 1 To 6
Here5:
If Numbers(5) = Numbers(b) And b <> 5 Then
    Numbers(5) = Int(Rnd * 48) + 1
    GoTo Here5
End If
Next

For b = 1 To 6
Here6:
If Numbers(6) = Numbers(b) And b <> 6 Then
    Numbers(6) = Int(Rnd * 48) + 1
    GoTo Here6
End If
Next
EndAll:
End Sub

Sub Colours (b, a)

If a < 10 And Shape(b).BackColor <> White Then
  Shape(b).BackColor = White
End If
If a >= 10 And a <= 19 And Shape(b).BackColor <> Pink Then
  Shape(b).BackColor = Pink
End If
If a >= 20 And a <= 29 And Shape(b).BackColor <> Blue Then
  Shape(b).BackColor = Blue
End If
If a >= 30 And a <= 39 And Shape(b).BackColor <> Green Then
  Shape(b).BackColor = Green
End If
If a >= 40 And a <= 49 And Shape(b).BackColor <> Yellow Then
  Shape(b).BackColor = Yellow
End If
Shape(b).Refresh
End Sub

Private Sub Command1_Click ()
main.MousePointer = 11
endgen = 0
Command1.Enabled = False
command2.Enabled = False
Command5.Enabled = False
list1.Enabled = False
Command6.ZOrder
repeat.Enabled = False
Fast.Enabled = False
PrintIt.Enabled = False
Redo:
main.Caption = "DLP2" + " - " + repeat.Caption + " left"
Randomize Timer
For cnt = 1 To 6
  Numbers(cnt) = Int(Rnd * 48) + 1
  Check
Next

For cnt = 1 To 6
  If Fast.Value = 1 Then
    For zzz = 1 To 10
      DoEvents
      If endgen = 1 Then GoTo endthisnow
    Next
    If Numbers(cnt) >= 10 Then bstr = Numbers(cnt)
    If Numbers(cnt) < 10 Then bstr = "0" + CStr(Numbers(cnt))
    label(cnt).Caption = bstr
    Call Colours(cnt, Numbers(cnt))
    GoTo endoffast
  End If
  c = 1
  For b = c To Numbers(cnt)
    For zzz = 1 To 100
      DoEvents
      If endgen = 1 Then GoTo endthisnow
    Next
    If b >= 10 Then bstr = b
    If b < 10 Then bstr = "0" + CStr(b)
    label(cnt).Caption = bstr
    Numbers(cnt) = b
    Call Colours(cnt, b)
  Next
endoffast:
Next
num = num + 1
num = CStr(num)
If Val(num) <= 9 Then num = "0" + CStr(num)
ReArrange
For cnt = 1 To 6
  Call Colours(cnt, Numbers(cnt))
Next
list1.AddItem num + ": " + label(1) + ", " + label(2) + ", " + label(3) + ", " + label(4) + ", " + label(5) + ", " + label(6)
list2.AddItem label(1).Caption + label(2).Caption + label(3).Caption + label(4).Caption + label(5).Caption + label(6).Caption
list1.Refresh
list1.Selected(list1.ListCount - 1) = True
If Val(repeat.Caption) > 1 Then
    repeat.Caption = Str(Val(repeat.Caption - 1)): repeat.Refresh
    'If Fast.Value = 0 Then For zzz = 1 To 100: Next
    GoTo Redo
End If
If PrintIt.Value = 1 Then
    For lines = 0 To list1.ListCount
    LineToPrint = list1.List(lines)
    Printer.Print LineToPrint
    Next
    Printer.EndDoc
End If
GoTo afterend
endthisnow:
afterend:
main.MousePointer = 0
Command1.Enabled = True
command2.Enabled = True
Command5.Enabled = True
Command1.ZOrder
list1.Enabled = True
repeat.Enabled = True
Fast.Enabled = True
PrintIt.Enabled = True
textlast$ = ""
main.Caption = "Dunks Lotto Picker Ver 2"
End Sub

Sub Command2_Click ()
AboutWindow.Show
End Sub

Sub Command4_Click ()
End

End Sub

Sub Command5_Click ()
list1.Clear
list2.Clear
For cnt = 1 To 6
  label(cnt).Caption = ""
  Shape(cnt).BackColor = White
Next
num = 0

End Sub

Sub Command6_Click ()
endgen = 1
If list1.ListCount <= 0 Then
  For cnt = 1 To 6
    label(cnt).Caption = ""
    Shape(cnt).BackColor = White
  Next
  num = 0
  GoTo hereyetagain
End If
list1.Selected(list1.ListCount - 1) = True
txt$ = list2.List(list1.ListIndex)
For cnt = 1 To 6
  getvar(cnt) = Mid$(txt$, ((cnt - 1) * 2) + 1, 2)
Next
For cnt = 1 To 6
  Call Colours(cnt, getvar(cnt))
Next
For cnt = 1 To 6
  label(cnt).Caption = getvar(cnt)
Next
textlast$ = txt$
hereyetagain:

End Sub

Sub Form_Load ()
repeat.Caption = "1"
Green = &H80FF80
Pink = &HFFC0FF
Yellow = &H80FFFF
White = &HFFFFFF
Blue = &HFF8080

End Sub

Sub Form_Unload (Cancel As Integer)
End
End Sub

Sub List1_MouseDown (button As Integer, Shift As Integer, X As Single, Y As Single)
If list1.ListCount <= 0 Then GoTo here
txt$ = list2.List(list1.ListIndex)
If txt$ = textlast$ Then GoTo here
For cnt = 1 To 6
  getvar(cnt) = Mid$(txt$, ((cnt - 1) * 2) + 1, 2)
Next
For cnt = 1 To 6
  Call Colours(cnt, getvar(cnt))
Next
For cnt = 1 To 6
  label(cnt).Caption = getvar(cnt)
Next
textlast$ = txt$
here:
End Sub

Sub List1_MouseMove (button As Integer, Shift As Integer, X As Single, Y As Single)
If button = 1 Then
If list1.ListCount <= 0 Then GoTo hereaswell
txt$ = list2.List(list1.ListIndex)
If txt$ = textlast$ Then GoTo hereaswell
For cnt = 1 To 6
  getvar(cnt) = Mid$(txt$, ((cnt - 1) * 2) + 1, 2)
Next
For cnt = 1 To 6
  Call Colours(cnt, getvar(cnt))
Next
For cnt = 1 To 6
  label(cnt).Caption = getvar(cnt)
Next
textlast$ = txt$
hereaswell:
End If
End Sub

Sub ReArrange ()
For cnt = 1 To 5
  DoEvents
  For b = cnt To 6
    If Numbers(cnt) > Numbers(b) Then
      c = Numbers(cnt)
      Numbers(cnt) = Numbers(b)
      Numbers(b) = c
    End If
  Next
Next
For cnt = 1 To 6
  If Numbers(cnt) < 10 Then Numbers(cnt) = "0" + CStr(Numbers(cnt))
  label(cnt).Caption = Numbers(cnt)
  Shape(cnt).Refresh
Next
End Sub

Sub spin1_Change ()
If spin1.Value > 100 Then
  repeat.Caption = spin1.Value - 100
  repeat.Refresh
Else
  spin1.Value = 101
End If
End Sub

Sub spin1_Scroll ()
If spin1.Value > 100 Then
  repeat.Caption = spin1.Value - 100
  repeat.Refresh
Else
  spin1.Value = 101
End If
End Sub

Sub Spin1_SpinDown ()
End Sub

Sub Spin1_SpinUp ()
repeat.Caption = Str(Val(repeat.Caption) + 1)
repeat.Refresh
End Sub

