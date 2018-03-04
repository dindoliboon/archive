VERSION 2.00
Begin Form Form1 
   BackColor       =   &H8000000F&
   Caption         =   "Immitation Status Bar Test Stub"
   ClientHeight    =   3390
   ClientLeft      =   1095
   ClientTop       =   1485
   ClientWidth     =   4470
   Height          =   3795
   Left            =   1035
   LinkTopic       =   "Form1"
   ScaleHeight     =   3390
   ScaleWidth      =   4470
   Top             =   1140
   Width           =   4590
   Begin CommandButton Command3 
      Caption         =   "Close"
      Height          =   375
      Left            =   2880
      TabIndex        =   5
      Top             =   120
      Width           =   1335
   End
   Begin TextBox Text1 
      Height          =   285
      Left            =   240
      TabIndex        =   4
      Text            =   "New Status Bar Message"
      Top             =   1560
      Width           =   3975
   End
   Begin CommandButton Command2 
      Caption         =   "Get Status Bar Text"
      Height          =   375
      Left            =   240
      TabIndex        =   3
      Top             =   600
      Width           =   1935
   End
   Begin CommandButton Command1 
      Caption         =   "Clear Status Bar"
      Height          =   375
      Left            =   240
      TabIndex        =   2
      Top             =   120
      Width           =   1935
   End
   Begin CommandButton Command4 
      Caption         =   "Change Status Bar"
      Height          =   375
      Left            =   240
      TabIndex        =   1
      Top             =   1080
      Width           =   1935
   End
   Begin PictureBox picStatus 
      Height          =   300
      Left            =   120
      ScaleHeight     =   270
      ScaleWidth      =   1065
      TabIndex        =   0
      Top             =   3000
      Width           =   1095
   End
   Begin Label Label1 
      BackColor       =   &H8000000F&
      Caption         =   "This code was written by Phil Ricketts, EMail PRicketts@compuserve.com.  Feel Free to use this code in your own programs."
      Height          =   735
      Left            =   240
      TabIndex        =   6
      Top             =   2040
      Width           =   3975
   End
End
Option Explicit


Declare Function GetSysColor Lib "user" (ByVal nIndex As Integer) As Long

Const COLOR_BTNHIGHLIGHT = 20
Const COLOR_BTNFACE = 15
Const COLOR_BTNSHADOW = 16
Const COLOR_BTNTEXT = 18

Sub Command1_Click ()

    Call Status("")

End Sub

Sub Command2_Click ()

    MsgBox GetStatus()

End Sub

Sub Command3_Click ()

    Unload Me

End Sub

Sub Command4_Click ()

    Call Status(Text1.Text)

End Sub

Sub Form_Load ()

    Call Status("Your Status Bar Message goes here")

End Sub

Function GetStatus () As String

    ' FIL 20/3/96 - returns the current status bar caption
    ' use the Status() subroutine to put text onto the Status Bar
    
    Dim pic As control

    Set pic = Form1.picStatus
    ' see comment in Status() routine to explain why I do it this way

    GetStatus = pic.Tag

End Function

Sub picStatus_Paint ()

    Call Status(GetStatus())

End Sub

Sub picStatus_Resize ()

    Call Status(GetStatus())

End Sub

Sub Status (ByVal sNewCaption As String)

    ' FIL 20/3/96 - sets the text displayed in the status bar
    ' this works by drawing a rectangle in the PictureBox's BackColour
    ' over the entire PictureBox except - this rectangle erases any text
    ' that was already there
    ' NOTE: if the text is too long to fit then it will NOT wrap
    
    ' Declare Function GetSysColor Lib "user" (ByVal nIndex As Integer) As Long
    ' Const COLOR_BTNHIGHLIGHT = 20
    ' Const COLOR_BTNSHADOW = 16
    ' Const COLOR_BTNFACE = 15
    ' Const COLOR_BTNTEXT = 18

    Dim pic As control
    Dim lHilightColour As Long
    Dim lShadowColour As Long
    Dim lButtonColour As Long
    Dim lTextColour As Long

    Const ALIGN_BOTTOM = 2
    Const BORDER_NONE = 0

    ' the colours to use for drawing
    lHilightColour = GetSysColor(COLOR_BTNHIGHLIGHT)
    lShadowColour = GetSysColor(COLOR_BTNSHADOW)
    lButtonColour = GetSysColor(COLOR_BTNFACE)
    lTextColour = GetSysColor(COLOR_BTNTEXT)

    ' assign the PictureBox to a variable to keep the code neater
    ' most programs will only have one anyway
    Set pic = Form1.picStatus
    ' You may feel that it is a bit untidy to have a control assigned in the
    ' function but most applications generally have a single main window with
    ' the status bar on it, I put the Status and GetStatus() routines in a
    ' global BAS module where they can be accessed by the entire program, if
    ' you are unhappy with this method then you could very easily change the
    ' routines to take the name of the control as a parameter

    If pic.BorderStyle <> BORDER_NONE Then
        pic.BorderStyle = BORDER_NONE
    End If
    If pic.AutoRedraw <> True Then
        pic.AutoRedraw = True
    End If
    If pic.FontBold <> False Then
        pic.FontBold = False
    End If
    If pic.Align <> ALIGN_BOTTOM Then

        pic.Align = ALIGN_BOTTOM
    End If
    If pic.BackColor <> lButtonColour Then
        pic.BackColor = lButtonColour
    End If
    If pic.ForeColor <> lTextColour Then
        pic.ForeColor = lTextColour
    End If

    ' clear the picture box and draw the 3D lines
    'pic.Line (0, 2 * Screen.TwipsPerPixelY)-(pic.Width, pic.Height), lButtonColour, BF
    pic.Line (0, 0)-(pic.Width, pic.Height), lButtonColour, BF
    pic.Line (0, 0)-(pic.Width, 0), lShadowColour

    pic.Line (0, Screen.TwipsPerPixelY)-(pic.Width, Screen.TwipsPerPixelY), lHilightColour

    ' 4 to allow for a reasonable margin - this offsets the text slightly
    ' from the top left corner
    pic.CurrentX = 4 * Screen.TwipsPerPixelX
    pic.CurrentY = 4 * Screen.TwipsPerPixelY

    ' set the text into the Tag property - for posterity
    ' use GetStatus() to retrieve it
    pic.Tag = sNewCaption

    ' print it
    pic.Print sNewCaption

    ' Refresh will force the PictureBox to paint itself now, otherwise we
    ' might have to wait for idle time, or a DoEvents
    pic.Refresh

End Sub

