VERSION 2.00
Begin Form Form1 
   Caption         =   "My ToolTips Version"
   ClientHeight    =   5820
   ClientLeft      =   1095
   ClientTop       =   1485
   ClientWidth     =   7365
   Height          =   6225
   Left            =   1035
   LinkTopic       =   "Form1"
   ScaleHeight     =   5820
   ScaleWidth      =   7365
   Top             =   1140
   Width           =   7485
   Begin CommandButton Command1 
      Caption         =   "Click remove Delete Button from ToolTips List"
      Height          =   555
      Left            =   1230
      TabIndex        =   2
      Top             =   750
      Width           =   4755
   End
   Begin SSPanel StatBar 
      Align           =   2  'Align Bottom
      Alignment       =   1  'Left Justify - MIDDLE
      BevelInner      =   1  'Inset
      BorderWidth     =   1
      FontBold        =   0   'False
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   375
      Left            =   0
      Outline         =   -1  'True
      RoundedCorners  =   0   'False
      TabIndex        =   1
      Top             =   5445
      Width           =   7365
   End
   Begin SSPanel DataTBar 
      Align           =   1  'Align Top
      BorderWidth     =   1
      Height          =   465
      Left            =   0
      Outline         =   -1  'True
      RoundedCorners  =   0   'False
      TabIndex        =   0
      Top             =   0
      Width           =   7365
      Begin SSRibbon tbNewButton 
         AutoSize        =   0  'None
         GroupNumber     =   0
         Height          =   330
         Left            =   60
         PictureDisabled =   FORM1.FRX:0000
         PictureUp       =   FORM1.FRX:00FA
         Top             =   60
         Width           =   330
      End
      Begin SSRibbon tbFindButton 
         AutoSize        =   0  'None
         GroupNumber     =   0
         Height          =   330
         Left            =   810
         PictureDisabled =   FORM1.FRX:01F4
         PictureUp       =   FORM1.FRX:02EE
         Top             =   60
         Width           =   330
      End
      Begin SSRibbon tbRefreshButton 
         AutoSize        =   0  'None
         GroupNumber     =   0
         Height          =   330
         Left            =   1140
         PictureDisabled =   FORM1.FRX:03E8
         PictureUp       =   FORM1.FRX:04E2
         Top             =   60
         Width           =   330
      End
      Begin SSRibbon tbPreviousButton 
         AutoSize        =   0  'None
         GroupNumber     =   0
         Height          =   330
         Left            =   1920
         PictureDisabled =   FORM1.FRX:05DC
         PictureUp       =   FORM1.FRX:075E
         Top             =   60
         Width           =   330
      End
      Begin SSRibbon tbNextButton 
         AutoSize        =   0  'None
         GroupNumber     =   0
         Height          =   330
         Left            =   2250
         PictureDisabled =   FORM1.FRX:08E0
         PictureUp       =   FORM1.FRX:0A62
         Top             =   60
         Width           =   330
      End
      Begin SSRibbon tbUpdateButton 
         AutoSize        =   0  'None
         GroupNumber     =   0
         Height          =   330
         Left            =   390
         PictureDisabled =   FORM1.FRX:0BE4
         PictureUp       =   FORM1.FRX:0CDE
         Top             =   60
         Width           =   360
      End
      Begin SSRibbon tbDeleteButton 
         AutoSize        =   0  'None
         GroupNumber     =   0
         Height          =   330
         Left            =   2970
         PictureDisabled =   FORM1.FRX:0DD8
         PictureUp       =   FORM1.FRX:0F5A
         Top             =   60
         Width           =   330
      End
      Begin SSRibbon tbPrintButton 
         AutoSize        =   0  'None
         GroupNumber     =   0
         Height          =   330
         Left            =   1530
         PictureDisabled =   FORM1.FRX:10DC
         PictureUp       =   FORM1.FRX:11D6
         Top             =   60
         Width           =   330
      End
      Begin SSRibbon tbUndoButton 
         AutoSize        =   0  'None
         GroupNumber     =   0
         Height          =   330
         Left            =   2640
         PictureDisabled =   FORM1.FRX:12D0
         PictureUp       =   FORM1.FRX:13CA
         Top             =   60
         Width           =   330
      End
      Begin SSRibbon tbFkey 
         AutoSize        =   1  'Adjust Picture Size To Button
         GroupNumber     =   0
         Height          =   330
         Left            =   3780
         PictureUp       =   FORM1.FRX:14C4
         Top             =   60
         Value           =   -1  'True
         Width           =   360
      End
      Begin SSRibbon tbMasterDetailButton 
         AutoSize        =   1  'Adjust Picture Size To Button
         GroupNumber     =   0
         Height          =   330
         Left            =   3360
         PictureUp       =   FORM1.FRX:1646
         Top             =   60
         Visible         =   0   'False
         Width           =   360
      End
   End
   Begin Label Label1 
      Height          =   2835
      Left            =   1200
      TabIndex        =   3
      Top             =   1800
      Width           =   4815
   End
End

Sub Command1_Click ()
Static Status
If Status = False Then
    RemoveTip Me.tbDeleteButton.hWnd
    Me.Command1.Caption = "Click add Delete Button to Tooltips list"
    Status = True
Else
    AddTip Me.tbDeleteButton.hWnd, "Delete (F3)", ""
    Me.Command1.Caption = "Click remove Delete Button from Tooltips list"
    Status = False
End If
End Sub

Sub DataTBar_MouseMove (Button As Integer, Shift As Integer, X As Single, Y As Single)
DisplayTips
End Sub

Sub Form_Activate ()
InitializeTips

AddTip Me.tbNewButton.hWnd, "New (F2)", "Help for New Button......"
AddTip Me.tbDeleteButton.hWnd, "Delete (F3)", ""
AddTip Me.tbPreviousButton.hWnd, "Previous(F6)", ""
AddTip Me.tbNextButton.hWnd, "Next (F7)", ""
AddTip Me.tbFindButton.hWnd, "Find (F4)", ""
AddTip Me.tbRefreshButton.hWnd, "Refresh (F5)", ""
AddTip Me.tbPrintButton.hWnd, "Print (F8)", ""
AddTip Me.tbUndoButton.hWnd, "Undo (F9)", ""
AddTip Me.tbUpdateButton.hWnd, "Update (F10)", ""


End Sub

Sub Form_Load ()
msg$ = "MyToolTips Version" & Chr$(10)
msg$ = msg$ & "A FREEWARE VB source code only ToolTips System" & Chr$(10)
msg$ = msg$ & "(c) 1996 Gabriele Del Giovine" & Chr$(10)
msg$ = msg$ & "e-mail mc6491@mclink.it" & Chr$(10)
msg$ = msg$ & "COMPUSERVE 72660,1344" & Chr$(10)
label1 = msg$
End Sub

Sub Form_Unload (Cancel As Integer)
Unload TTips
End Sub

