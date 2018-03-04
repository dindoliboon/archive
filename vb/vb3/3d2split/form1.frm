VERSION 2.00
Begin Form Form1 
   BackColor       =   &H00C0C0C0&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Example of 3D routines and splitter bars"
   ClientHeight    =   4704
   ClientLeft      =   888
   ClientTop       =   1512
   ClientWidth     =   7572
   Height          =   5124
   Left            =   840
   LinkTopic       =   "Form1"
   ScaleHeight     =   4704
   ScaleWidth      =   7572
   Top             =   1140
   Width           =   7668
   Begin PictureBox Picture2 
      Height          =   432
      Left            =   4860
      Picture         =   FORM1.FRX:0000
      ScaleHeight     =   408
      ScaleWidth      =   408
      TabIndex        =   15
      Top             =   4500
      Visible         =   0   'False
      Width           =   432
   End
   Begin PictureBox PBottom 
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   0  'None
      Height          =   720
      Left            =   0
      ScaleHeight     =   720
      ScaleWidth      =   7572
      TabIndex        =   10
      Top             =   3988
      Width           =   7576
      Begin PictureBox PMenu 
         BackColor       =   &H00C0C0C0&
         BorderStyle     =   0  'None
         Height          =   480
         Left            =   120
         ScaleHeight     =   480
         ScaleWidth      =   7320
         TabIndex        =   11
         Top             =   120
         Width           =   7320
         Begin CommandButton B_Colors 
            Caption         =   "Colors"
            Height          =   360
            Left            =   60
            TabIndex        =   9
            Top             =   60
            Width           =   1200
         End
         Begin CommandButton B_Exit 
            Caption         =   "Exit"
            Height          =   360
            Left            =   6060
            TabIndex        =   14
            Top             =   60
            Width           =   1200
         End
         Begin PictureBox PStatus 
            BackColor       =   &H00C0C0C0&
            BorderStyle     =   0  'None
            Height          =   360
            Left            =   1380
            ScaleHeight     =   360
            ScaleWidth      =   4560
            TabIndex        =   12
            Top             =   60
            Width           =   4560
            Begin Label Status 
               Alignment       =   2  'Center
               BackColor       =   &H00C0C0C0&
               Caption         =   "Help/Status bar"
               FontBold        =   0   'False
               FontItalic      =   0   'False
               FontName        =   "MS Sans Serif"
               FontSize        =   7.8
               FontStrikethru  =   0   'False
               FontUnderline   =   0   'False
               Height          =   240
               Left            =   0
               TabIndex        =   13
               Top             =   60
               Width           =   4440
            End
         End
      End
   End
   Begin TextBox RText 
      BackColor       =   &H00FFFFFF&
      Height          =   1800
      Left            =   3840
      MultiLine       =   -1  'True
      TabIndex        =   8
      Text            =   "As the mouse pointer enters a control, the status/help bar shows the corresponding help line."
      Top             =   2040
      Width           =   3600
   End
   Begin TextBox LText 
      BackColor       =   &H00FFFFFF&
      Height          =   1800
      Left            =   120
      MultiLine       =   -1  'True
      TabIndex        =   7
      Text            =   "The two picture boxes and the two text boxes are resized when you drag one of the five splitters.  Please read the comments in 3D2.BAS (declarations section)."
      Top             =   2040
      Width           =   3600
   End
   Begin PictureBox C 
      BackColor       =   &H000000FF&
      BorderStyle     =   0  'None
      Height          =   96
      Left            =   3732
      MousePointer    =   8  'Size NW SE
      ScaleHeight     =   96
      ScaleWidth      =   96
      TabIndex        =   6
      Top             =   1932
      Width           =   96
   End
   Begin PictureBox HR 
      BackColor       =   &H0000FF00&
      BorderStyle     =   0  'None
      Height          =   96
      Left            =   3840
      MousePointer    =   7  'Size N S
      ScaleHeight     =   96
      ScaleWidth      =   3612
      TabIndex        =   5
      Top             =   1932
      Width           =   3612
   End
   Begin PictureBox HL 
      BackColor       =   &H0000FF00&
      BorderStyle     =   0  'None
      Height          =   96
      Left            =   108
      MousePointer    =   7  'Size N S
      ScaleHeight     =   96
      ScaleWidth      =   3612
      TabIndex        =   3
      Top             =   1932
      Width           =   3612
   End
   Begin PictureBox VT 
      BackColor       =   &H0000FFFF&
      BorderStyle     =   0  'None
      Height          =   1824
      Left            =   3732
      MousePointer    =   9  'Size W E
      ScaleHeight     =   1824
      ScaleWidth      =   96
      TabIndex        =   2
      Top             =   108
      Width           =   96
   End
   Begin PictureBox LPict 
      BackColor       =   &H00C0C0C0&
      Height          =   1800
      Left            =   120
      ScaleHeight     =   1776
      ScaleWidth      =   3576
      TabIndex        =   1
      Tag             =   "List of target language sentences"
      Top             =   120
      Width           =   3600
   End
   Begin PictureBox RPict 
      BackColor       =   &H00C0C0C0&
      Height          =   1800
      Left            =   3840
      ScaleHeight     =   1776
      ScaleWidth      =   3576
      TabIndex        =   0
      Tag             =   "List of target language sentences"
      Top             =   120
      Width           =   3600
   End
   Begin PictureBox VB 
      BackColor       =   &H0000FFFF&
      BorderStyle     =   0  'None
      Height          =   1824
      Left            =   3732
      MousePointer    =   9  'Size W E
      ScaleHeight     =   1824
      ScaleWidth      =   96
      TabIndex        =   4
      Top             =   2028
      Width           =   96
   End
End
Option Explicit

Dim tx As Integer     ' TwipsPerPixelX
Dim ty As Integer     ' TwipsPerPixelY
Dim MinL As Integer   ' Limits to splitters' positions
Dim MaxR As Integer
Dim MinT As Integer
Dim MaxB As Integer
Dim OKtoDraw As Integer      ' Flag to indicate the rectangle should be drawn
Dim Vrct As RECT             ' Vertical outline structure
Dim Hrct As RECT             ' Horizontal outline structure
Dim SplitInitLeft As Integer ' Initial values for MouseMove
Dim InitX As Integer
Dim SplitInitTop As Integer
Dim InitY As Integer

Sub B_Colors_Click ()
    If C.BackColor = RED Then
        C.BackColor = LIGHTGRAY
        HL.BackColor = LIGHTGRAY
        HR.BackColor = LIGHTGRAY
        VT.BackColor = LIGHTGRAY
        VB.BackColor = LIGHTGRAY
    Else
        C.BackColor = RED
        HL.BackColor = GREEN
        HR.BackColor = GREEN
        VT.BackColor = YELLOW
        VB.BackColor = YELLOW
    End If
End Sub

Sub B_Colors_MouseMove (Button As Integer, Shift As Integer, X As Single, Y As Single)
    Status = "B_Colors help"
End Sub

Sub B_Exit_Click ()
    Unload Me
End Sub

Sub B_Exit_MouseMove (Button As Integer, Shift As Integer, X As Single, Y As Single)
    Status = "B_Exit help"
End Sub

Sub C_DblClick ()
    ' This is to compensate for the extra MouseUp event that
    ' is triggered when the user doubleclicks on the splitter.
    ' (The rectangle must be drawn an even number of times.)
    DrawOutline Vrct, Me
    DrawOutline Hrct, Me
End Sub

Sub C_MouseDown (Button As Integer, Shift As Integer, X As Single, Y As Single)
    OKtoDraw = True ' Paintbrush on.
    
    Hrct.Left = HL.Left
    Hrct.Top = HL.Top
    Hrct.right = Hrct.Left + HL.Width + C.Width + HR.Width
    Hrct.bottom = Hrct.Top + HL.Height
    DrawOutline Hrct, Me
    SplitInitTop = HL.Top
    InitY = Y
    
    Vrct.Left = VT.Left
    Vrct.Top = VT.Top
    Vrct.right = Vrct.Left + VT.Width
    Vrct.bottom = Vrct.Top + VT.Height + C.Height + VB.Height
    DrawOutline Vrct, Me
    SplitInitLeft = VT.Left
    InitX = X

End Sub

Sub C_MouseMove (Button As Integer, Shift As Integer, X As Single, Y As Single)
    Status = "C help"
    If OKtoDraw Then
        DrawOutline Hrct, Me
        Hrct.Top = SplitInitTop + Y - InitY
        If Hrct.Top < MinT Then Hrct.Top = MinT
        If Hrct.Top > MaxB Then Hrct.Top = MaxB
        Hrct.bottom = Hrct.Top + HL.Height
        DrawOutline Hrct, Me
        DrawOutline Vrct, Me
        Vrct.Left = SplitInitLeft + X - InitX
        If Vrct.Left < MinL Then Vrct.Left = MinL
        If Vrct.Left > MaxR Then Vrct.Left = MaxR
        Vrct.right = Vrct.Left + VT.Width
        DrawOutline Vrct, Me
    End If
End Sub

Sub C_MouseUp (Button As Integer, Shift As Integer, X As Single, Y As Single)
    DrawOutline Hrct, Me
    DrawOutline Vrct, Me
    OKtoDraw = False
    HL.Top = Hrct.Top
    HR.Top = HL.Top
    C.Top = HL.Top
    VT.Height = HL.Top - VT.Top
    VB.Top = HL.Top + HL.Height
    VB.Height = VB.Height + SplitInitTop - HL.Top
    VT.Left = Vrct.Left
    VB.Left = VT.Left
    C.Left = VT.Left
    HL.Width = VT.Left - HL.Left
    HR.Width = HR.Width + SplitInitLeft - VT.Left
    HR.Left = VT.Left + VT.Width
    ReSizeMe
    OutlineControl Me, LText, 1, -1
    OutlineControl Me, RText, 1, -1
    OutlineControl Me, LPict, 1, -1
    OutlineControl Me, RPict, 1, -1
End Sub

Sub Form_Load ()
    
    tx = screen.TwipsPerPixelX
    ty = screen.TwipsPerPixelY
    MinL = 1200
    MaxR = Me.Width - 1200
    MinT = 1200
    MaxB = Me.Height - 2200
    Me.Width = 7600
    Me.Height = 5040
    PBottom.Width = Me.Width - 2 * tx
    PBottom.Top = Me.Height - PBottom.Height - 348
    PStatus.Width = Me.Width - 3040
    Status.Width = Me.Width - 3160
    
    ' Fine-tune the splitters' initial position
    ' This is necessary to accomodate different screen resolutions
    VT.Top = 120 - ty
    VT.Height = 1800 + 2 * ty
    VT.Width = 120 - 2 * tx
    VT.Left = 120 + 3600 + tx
    C.Top = VT.Top + VT.Height
    C.Height = 120 - 2 * ty
    C.Width = VT.Width
    C.Left = VT.Left
    VB.Top = C.Top + C.Height
    VB.Height = VT.Height
    VB.Width = VT.Width
    VB.Left = VT.Left
    HL.Top = 120 + 1800 + ty
    HL.Height = 120 - 2 * ty
    HL.Width = 3600 + 2 * tx
    HL.Left = 120 - tx
    HR.Top = HL.Top
    HR.Height = HL.Height
    HR.Width = HL.Width
    HR.Left = C.Left + C.Width
    LPict.Picture = Picture2.Picture
    RPict.Picture = Picture2.Picture
    
    CenterForm Me

End Sub

Sub Form_MouseMove (Button As Integer, Shift As Integer, X As Single, Y As Single)
    Status = "Form help"
End Sub

Sub Form_Paint ()
    OutlineForm Me, 1, raised
    InLinePic PBottom, 2, raised
    OutlineControl Me, LText, 1, -1
    OutlineControl Me, RText, 1, -1
    OutlineControl Me, LPict, 1, -1
    OutlineControl Me, RPict, 1, -1
    OutlineControlPic PBottom, PMenu, 1, -1
    OutlineControlPic PMenu, B_Colors, 1, -1
    OutlineControlPic PMenu, B_Exit, 1, -1
    OutlineControlPic PMenu, PStatus, 1, -1
    'OutlinePicOnPic PMenu, PStatus, INSET
End Sub

Sub Form_Resize ()
    MinL = 1200
    MaxR = Me.Width - 1200
    MinT = 1200
    MaxB = Me.Height - 2200
    Dim Disp As Integer
    If WindowState = MAXI Then
        OutlineControl Me, PMenu, 1, 2
    End If
    If WindowState = NORMAL Then     ' Check for splitters out of bounds
        If VT.Left > MaxR Then
            Disp = VT.Left - MaxR
            VT.Left = MaxR
            C.Left = MaxR
            VB.Left = MaxR
            HR.Left = HR.Left - Disp
            HR.Width = HR.Width + Disp
            HL.Width = HL.Width - Disp
        End If
        If HL.Top > MaxB Then
            Disp = HL.Top - MaxB
            HL.Top = MaxB
            C.Top = MaxB
            HR.Top = MaxB
            VB.Top = VB.Top - Disp
            VB.Height = VB.Height + Disp
            VT.Height = VT.Height - Disp
        End If
    End If
    InLinePic PBottom, 2, remove
    SizeMe
    Me.Refresh
End Sub

Sub HL_DblClick ()
    ' This is to compensate for the extra MouseUp event that
    ' is triggered when the user doubleclicks on the splitter.
    ' (The rectangle must be drawn an even number of times.)
    DrawOutline Hrct, Me
End Sub

Sub HL_MouseDown (Button As Integer, Shift As Integer, X As Single, Y As Single)
    OKtoDraw = True
    Hrct.Left = HL.Left
    Hrct.Top = HL.Top
    Hrct.right = Hrct.Left + HL.Width + C.Width + HR.Width
    Hrct.bottom = Hrct.Top + HL.Height
    DrawOutline Hrct, Me
    SplitInitTop = HL.Top
    InitY = Y
End Sub

Sub HL_MouseMove (Button As Integer, Shift As Integer, X As Single, Y As Single)
    Status = "HL help"
    If OKtoDraw Then
        DrawOutline Hrct, Me
        Hrct.Top = SplitInitTop + Y - InitY
        If Hrct.Top < MinT Then Hrct.Top = MinT
        If Hrct.Top > MaxB Then Hrct.Top = MaxB
        Hrct.bottom = Hrct.Top + HL.Height
        DrawOutline Hrct, Me
    End If
End Sub

Sub HL_MouseUp (Button As Integer, Shift As Integer, X As Single, Y As Single)
    DrawOutline Hrct, Me
    OKtoDraw = False
    HL.Top = Hrct.Top
    HR.Top = HL.Top
    C.Top = HL.Top
    VT.Height = HL.Top - VT.Top
    VB.Top = HL.Top + HL.Height
    VB.Height = VB.Height + SplitInitTop - HL.Top
    ReSizeMe
    OutlineControl Me, LText, 1, -1
    OutlineControl Me, RText, 1, -1
    OutlineControl Me, LPict, 1, -1
    OutlineControl Me, RPict, 1, -1
End Sub

Sub HR_DblClick ()
    ' This is to compensate for the extra MouseUp event that
    ' is triggered when the user doubleclicks on the splitter.
    ' (The rectangle must be drawn an even number of times.)
    DrawOutline Hrct, Me
End Sub

Sub HR_MouseDown (Button As Integer, Shift As Integer, X As Single, Y As Single)
    OKtoDraw = True
    Hrct.Left = HL.Left
    Hrct.Top = HL.Top
    Hrct.right = Hrct.Left + HL.Width + C.Width + HR.Width
    Hrct.bottom = Hrct.Top + HL.Height
    DrawOutline Hrct, Me
    SplitInitTop = HL.Top
    InitY = Y
End Sub

Sub HR_MouseMove (Button As Integer, Shift As Integer, X As Single, Y As Single)
    Status = "HR help"
    If OKtoDraw Then
        DrawOutline Hrct, Me
        Hrct.Top = SplitInitTop + Y - InitY
        If Hrct.Top < MinT Then Hrct.Top = MinT
        If Hrct.Top > MaxB Then Hrct.Top = MaxB
        Hrct.bottom = Hrct.Top + HL.Height
        DrawOutline Hrct, Me
    End If
End Sub

Sub HR_MouseUp (Button As Integer, Shift As Integer, X As Single, Y As Single)
    DrawOutline Hrct, Me
    OKtoDraw = False
    HL.Top = Hrct.Top
    HR.Top = HL.Top
    C.Top = HL.Top
    VT.Height = HL.Top - VT.Top
    VB.Top = HL.Top + HL.Height
    VB.Height = VB.Height + SplitInitTop - HL.Top
    ReSizeMe
    OutlineControl Me, LText, 1, -1
    OutlineControl Me, RText, 1, -1
    OutlineControl Me, LPict, 1, -1
    OutlineControl Me, RPict, 1, -1
End Sub

Sub LPict_MouseMove (Button As Integer, Shift As Integer, X As Single, Y As Single)
    Status = "LPict help"
End Sub

Sub LText_MouseMove (Button As Integer, Shift As Integer, X As Single, Y As Single)
    Status = "LText help"
End Sub

Sub PMenu_MouseMove (Button As Integer, Shift As Integer, X As Single, Y As Single)
    Status = "PMenu help"
End Sub

Sub ReSizeMe ()
    ' Resize control when splitters have moved (in MouseUp)
    ' H size and position
    LPict.Width = VT.Left - tx - 120
    RPict.Left = VT.Left + 120 - tx
    RPict.Width = Me.Width - RPict.Left - 160
    LText.Width = LPict.Width
    RText.Width = RPict.Width
    RText.Left = RPict.Left
    ' V size and position
    LPict.Height = VT.Height - 2 * ty
    RPict.Height = LPict.Height
    LText.Top = VB.Top + ty
    LText.Height = Me.Height - LText.Top - 1200
    RText.Top = LText.Top
    RText.Height = LText.Height
End Sub

Sub RPict_MouseMove (Button As Integer, Shift As Integer, X As Single, Y As Single)
    Status = "RPict help"
End Sub

Sub RText_MouseMove (Button As Integer, Shift As Integer, X As Single, Y As Single)
    Status = "RText help"
End Sub

Sub SizeMe ()
    ' Size controls when Max/Minimize button is pressed
    If WindowState = MINI Then Exit Sub   ' Minimized
    VB.Height = Me.Height - VB.Top - 1188
    HR.Width = Me.Width - HR.Left - 148
    PBottom.Top = Me.Height - 1068
    PBottom.Width = Me.Width - 20
    PMenu.Width = Me.Width - 276
    PStatus.Width = Me.Width - 3036
    B_Exit.Left = Me.Width - 1536

    ' H size and position
    LPict.Width = VT.Left - tx - 120
    RPict.Left = VT.Left + 120 - tx
    RPict.Width = Me.Width - RPict.Left - 160
    LText.Width = LPict.Width
    RText.Width = RPict.Width
    RText.Left = RPict.Left

    ' V size and position
    LPict.Height = VT.Height - 2 * ty
    RPict.Height = LPict.Height
    LText.Top = VB.Top + ty
    LText.Height = Me.Height - LText.Top - 1200
    RText.Top = LText.Top
    RText.Height = LText.Height

End Sub

Sub VB_DblClick ()
    ' This is to compensate for the extra MouseUp event that
    ' is triggered when the user doubleclicks on the splitter.
    ' (The rectangle must be drawn an even number of times.)
    DrawOutline Vrct, Me
End Sub

Sub VB_MouseDown (Button As Integer, Shift As Integer, X As Single, Y As Single)
    OKtoDraw = True
    Vrct.Left = VB.Left
    Vrct.Top = VT.Top
    Vrct.right = Vrct.Left + VB.Width
    Vrct.bottom = Vrct.Top + VB.Height + C.Height + VT.Height
    DrawOutline Vrct, Me
    SplitInitLeft = VB.Left
    InitX = X
End Sub

Sub VB_MouseMove (Button As Integer, Shift As Integer, X As Single, Y As Single)
    Status = "VB help"
    If OKtoDraw Then
        DrawOutline Vrct, Me
        Vrct.Left = SplitInitLeft + X - InitX
        If Vrct.Left < MinL Then Vrct.Left = MinL
        If Vrct.Left > MaxR Then Vrct.Left = MaxR
        Vrct.right = Vrct.Left + VB.Width
        DrawOutline Vrct, Me
    End If
End Sub

Sub VB_MouseUp (Button As Integer, Shift As Integer, X As Single, Y As Single)
    DrawOutline Vrct, Me
    OKtoDraw = False
    VT.Left = Vrct.Left
    VB.Left = VT.Left
    C.Left = VT.Left
    HL.Width = VT.Left - HL.Left
    HR.Width = HR.Width + SplitInitLeft - VT.Left
    HR.Left = VT.Left + VT.Width
    ReSizeMe
    OutlineControl Me, LText, 1, -1
    OutlineControl Me, RText, 1, -1
    OutlineControl Me, LPict, 1, -1
    OutlineControl Me, RPict, 1, -1
End Sub

Sub VT_DblClick ()
    ' This is to compensate for the extra MouseUp event that
    ' is triggered when the user doubleclicks on the splitter.
    ' (The rectangle must be drawn an even number of times.)
    DrawOutline Vrct, Me
End Sub

Sub VT_MouseDown (Button As Integer, Shift As Integer, X As Single, Y As Single)
    OKtoDraw = True
    Vrct.Left = VT.Left
    Vrct.Top = VT.Top
    Vrct.right = Vrct.Left + VT.Width
    Vrct.bottom = Vrct.Top + VT.Height + C.Height + VB.Height
    DrawOutline Vrct, Me
    SplitInitLeft = VT.Left
    InitX = X
End Sub

Sub VT_MouseMove (Button As Integer, Shift As Integer, X As Single, Y As Single)
    Status = "VT help"
    If OKtoDraw Then
        DrawOutline Vrct, Me
        Vrct.Left = SplitInitLeft + X - InitX
        If Vrct.Left < MinL Then Vrct.Left = MinL
        If Vrct.Left > MaxR Then Vrct.Left = MaxR
        Vrct.right = Vrct.Left + VT.Width
        DrawOutline Vrct, Me
    End If
End Sub

Sub VT_MouseUp (Button As Integer, Shift As Integer, X As Single, Y As Single)
    DrawOutline Vrct, Me
    OKtoDraw = False
    VT.Left = Vrct.Left
    VB.Left = VT.Left
    C.Left = VT.Left
    HL.Width = VT.Left - HL.Left
    HR.Width = HR.Width + SplitInitLeft - VT.Left
    HR.Left = VT.Left + VT.Width
    ReSizeMe
    OutlineControl Me, LText, 1, -1
    OutlineControl Me, RText, 1, -1
    OutlineControl Me, LPict, 1, -1
    OutlineControl Me, RPict, 1, -1
End Sub

