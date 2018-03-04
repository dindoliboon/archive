VERSION 2.00
Begin Form frmCool 
   BackColor       =   &H8000000F&
   Caption         =   "Immitation CoolBar Test Stub"
   ClientHeight    =   3315
   ClientLeft      =   7230
   ClientTop       =   4200
   ClientWidth     =   7290
   Height          =   4005
   Left            =   7170
   LinkTopic       =   "Form1"
   ScaleHeight     =   221
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   486
   Top             =   3570
   Width           =   7410
   Begin Frame Frame1 
      BackColor       =   &H8000000F&
      Caption         =   "Enable Buttons"
      Height          =   1815
      Left            =   120
      TabIndex        =   1
      Top             =   1200
      Width           =   1575
      Begin CheckBox Check1 
         BackColor       =   &H8000000F&
         Caption         =   "Last"
         Height          =   255
         Index           =   5
         Left            =   120
         TabIndex        =   7
         Top             =   1440
         Value           =   1  'Checked
         Width           =   900
      End
      Begin CheckBox Check1 
         BackColor       =   &H8000000F&
         Caption         =   "Next"
         Height          =   255
         Index           =   4
         Left            =   120
         TabIndex        =   6
         Top             =   1200
         Value           =   1  'Checked
         Width           =   900
      End
      Begin CheckBox Check1 
         BackColor       =   &H8000000F&
         Caption         =   "Prev"
         Height          =   255
         Index           =   3
         Left            =   120
         TabIndex        =   5
         Top             =   960
         Value           =   1  'Checked
         Width           =   900
      End
      Begin CheckBox Check1 
         BackColor       =   &H8000000F&
         Caption         =   "First"
         Height          =   255
         Index           =   2
         Left            =   120
         TabIndex        =   4
         Top             =   720
         Value           =   1  'Checked
         Width           =   900
      End
      Begin CheckBox Check1 
         BackColor       =   &H8000000F&
         Caption         =   "Print"
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   3
         Top             =   480
         Value           =   1  'Checked
         Width           =   900
      End
      Begin CheckBox Check1 
         BackColor       =   &H8000000F&
         Caption         =   "Page"
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   2
         Top             =   240
         Value           =   1  'Checked
         Width           =   900
      End
   End
   Begin PictureBox picCoolBar 
      Align           =   1  'Align Top
      BackColor       =   &H8000000F&
      Height          =   1095
      Left            =   0
      ScaleHeight     =   71
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   484
      TabIndex        =   0
      Top             =   0
      Width           =   7290
      Begin PictureBox picSourceBitmaps 
         AutoSize        =   -1  'True
         Height          =   930
         Left            =   3960
         Picture         =   FCOOLBAR.FRX:0000
         ScaleHeight     =   60
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   200
         TabIndex        =   8
         Top             =   120
         Visible         =   0   'False
         Width           =   3030
      End
      Begin PictureBox picScratchPad 
         Height          =   975
         Left            =   5280
         ScaleHeight     =   945
         ScaleWidth      =   1785
         TabIndex        =   9
         Top             =   0
         Visible         =   0   'False
         Width           =   1815
      End
      Begin Timer timerCool 
         Enabled         =   0   'False
         Interval        =   55
         Left            =   0
         Top             =   0
      End
   End
   Begin Menu mnuFile 
      Caption         =   "File"
      Begin Menu mnuFilePrintPage 
         Caption         =   "Print Page"
      End
      Begin Menu mnuFilePrintAll 
         Caption         =   "Print All"
      End
      Begin Menu mnuFileSep1 
         Caption         =   "-"
      End
      Begin Menu mnuFileExit 
         Caption         =   "Exit"
      End
   End
   Begin Menu mnuNav 
      Caption         =   "Navigate"
      Begin Menu mnuNavFirst 
         Caption         =   "First"
      End
      Begin Menu mnuNavPrev 
         Caption         =   "Prev"
      End
      Begin Menu mnuNavNext 
         Caption         =   "Next"
      End
      Begin Menu mnuNavLast 
         Caption         =   "Last"
      End
   End
End
Option Explicit

Sub Check1_Click (Index As Integer)

    ' this is a kludgy way of setting the enabled/disabled state of the
    ' buttons, I am trying to avoid using globals, but globals would
    ' probably be neater, the call to DrawCoolBar at the end is to force
    ' it to redraw the buttons, when it does that it will check the
    ' enabled/disabled state of the menu options to decide if the button
    ' is enabled or not

    Dim iRet As Integer
    
    Select Case Index
    Case 0:
        mnuFilePrintPage.Enabled = Check1(Index).Value
    Case 1:
        mnuFilePrintAll.Enabled = Check1(Index).Value
    Case 2:
        mnuNavFirst.Enabled = Check1(Index).Value
    Case 3:
        mnuNavPrev.Enabled = Check1(Index).Value
    Case 4:
        mnuNavNext.Enabled = Check1(Index).Value
    Case 5:
        mnuNavLast.Enabled = Check1(Index).Value
    End Select

    iRet = DrawCoolBar(0, 0, 0)

End Sub

Sub Form_Load ()

    ' this should be called before anything gets shown - most people have their
    ' button colours set to shades of grey, but sometimes people set them to
    ' other colours, I have drawn the bitmaps using the standard 16 colours and
    ' I have used shades of grey for the background and 3D look, this routine
    ' will change the 4 colours (white, light grey, dark grey and black to the
    ' system colours for button highlight, button face, button shadow and
    ' button text)

    Call ChangeBitmapColours(picSourceBitmaps, picScratchPad)

End Sub

Sub mnuFileExit_Click ()

    Unload Me

End Sub

Sub picCoolBar_MouseDown (Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim iRet As Integer

    iRet = DrawCoolBar(Button, X, Y)

End Sub

Sub picCoolBar_MouseMove (Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim iRet As Integer

    timerCool.Enabled = True
    iRet = DrawCoolBar(Button, X, Y)

End Sub

Sub picCoolBar_MouseUp (Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim iRet As Integer

    iRet = DrawCoolBar(0, X, Y)
    Select Case iRet
    Case 1:
        Debug.Print "Print Page Button clicked"
    Case 2:
        Debug.Print "Print All Button clicked"
    Case 3:
        Debug.Print "Rewind Button clicked"
    Case 4:
        Debug.Print "Prev Button clicked"
    Case 5:
        Debug.Print "Next Button clicked"
    Case 6:
        Debug.Print "Fast Forward Button clicked"
    End Select

End Sub

Sub picCoolBar_Resize ()

    Dim iRet As Integer
    
    iRet = DrawCoolBar(0, 0, 0)

End Sub

Sub timerCool_Timer ()

    ' I have decided to use a timer control to trigger code which will look for the
    ' mouse being moved off of the PictureBox which we are using for the ToolBar,
    ' the moment the mouse moves off of the control, the timer is stopped and the
    ' picture box is redrawn

    ' The Static variable is used to keep track of the mouse position the last time
    ' through this routine, if it is the same as this time through then there is no
    ' need to do any more checking

    Dim pt As POINTAPI
    Dim iMinX As Integer
    Dim iMinY As Integer
    Dim iMaxX As Integer
    Dim iMaxY As Integer
    Dim iRet As Integer

    Static LastPt As POINTAPI

    ' get the current mouse position, and if it is the same as last time then stop
    ' otherwise work out if it is over the CoolBar, if it is over the CoolBar then
    ' do nothing, otherwise redraw the CoolBar and stop the timer

    Call GetCursorPos(pt)
    If LastPt.X = pt.X And LastPt.Y = pt.Y Then
        ' the mouse hasn't moved from last time - do nothing more
    Else
        LastPt.X = pt.X
        LastPt.Y = pt.Y

        If ScaleMode <> 3 Then
            ScaleMode = 3
        End If
        
        iMinX = Left / Screen.TwipsPerPixelX
        iMinX = iMinX + (((Width / Screen.TwipsPerPixelX) - ScaleWidth) / 2)
        iMinX = iMinX + picCoolBar.Left
        iMinY = Top / Screen.TwipsPerPixelY
        iMinY = iMinY + ((Height / Screen.TwipsPerPixelY) - ScaleHeight)
        iMinY = iMinY - (((Width / Screen.TwipsPerPixelX) - ScaleWidth) / 2)
        iMinY = iMinY + picCoolBar.Top
        iMaxX = iMinX + picCoolBar.Width
        iMaxY = iMinY + picCoolBar.Height
    
        If pt.X >= iMinX And pt.X <= iMaxX And pt.Y >= iMinY And pt.Y <= iMaxY Then
            ' inside the rect
        Else
            ' outside
            iRet = DrawCoolBar(0, 0, 0)
            timerCool.Enabled = False
            LastPt.X = 0
            LastPt.Y = 0
        End If
    End If

End Sub

