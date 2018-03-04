VERSION 2.00
Begin Form Form1 
   BackColor       =   &H00C0C0C0&
   Caption         =   "Imitation Guage Control Demo"
   ClientHeight    =   3405
   ClientLeft      =   1020
   ClientTop       =   1470
   ClientWidth     =   4710
   DrawMode        =   10  'Not Xor Pen
   ForeColor       =   &H00800000&
   Height          =   3810
   Left            =   960
   LinkTopic       =   "Form1"
   ScaleHeight     =   3405
   ScaleWidth      =   4710
   Top             =   1125
   Width           =   4830
   Begin HScrollBar HScroll1 
      Height          =   255
      LargeChange     =   50
      Left            =   240
      Max             =   100
      TabIndex        =   2
      TabStop         =   0   'False
      Top             =   720
      Width           =   3135
   End
   Begin CommandButton cmdClose 
      Cancel          =   -1  'True
      Caption         =   "&Close"
      Default         =   -1  'True
      Height          =   375
      Left            =   3600
      TabIndex        =   1
      Top             =   600
      Width           =   855
   End
   Begin PictureBox picGuage 
      AutoRedraw      =   -1  'True
      DrawMode        =   7  'Xor Pen
      FillColor       =   &H000000FF&
      ForeColor       =   &H000000FF&
      Height          =   300
      Left            =   240
      ScaleHeight     =   270
      ScaleWidth      =   4185
      TabIndex        =   0
      Top             =   120
      Width           =   4215
   End
   Begin Label Label4 
      BackColor       =   &H00C0C0C0&
      Caption         =   "I know there are thousands of VBX's and OCXs out there for doing this but this way just uses native VB and puts very little overhead on your programs."
      Height          =   855
      Left            =   240
      TabIndex        =   6
      Top             =   2280
      Width           =   4215
   End
   Begin Label Label3 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Feel free to reuse this code as is or modified in your own programs.  If you have any comments then drop me a note."
      Height          =   615
      Left            =   240
      TabIndex        =   5
      Top             =   1680
      Width           =   4215
   End
   Begin Label Label2 
      BackColor       =   &H00C0C0C0&
      Caption         =   "EMail : 100042,2041@compuserve.com"
      Height          =   255
      Left            =   240
      TabIndex        =   4
      Top             =   1440
      Width           =   4215
   End
   Begin Label Label1 
      BackColor       =   &H00C0C0C0&
      Caption         =   "This code was written by Phil Ricketts"
      Height          =   255
      Left            =   240
      TabIndex        =   3
      Top             =   1200
      Width           =   4215
   End
End
Option Explicit

' Written by Phil Ricketts - EMail PRicketts@compuserve.com [100042,2041]
' =======================================================================

' Version
' -------
' 0.01  Jan '96


Sub cmdClose_Click ()

    Unload Me

End Sub

Sub Form_Load ()

    ' for starters for this demonstration I will set the value of the
    ' guage to 50, I'll do it by setting the Scroll bar value to 50 which will
    ' trigger the code to paint the percent bar because the Scroll bar is
    ' controlling the guage, in a real application this would be done programatically
    ' probably somewhere inside a loop, have a look at the HSCroll1_Change event to
    ' see how you would call the routine
    HScroll1.Value = 50

End Sub

Sub Guage (pic As Control, ByVal iPercent%, ByVal iVisible%)

    ' this routine will draw a 3D guage in the PictureBox control
    ' pic is the control
    ' iPercent% is the percentage to show in the guage
    ' iVisible% is a True/False and is used to show or hide the control
    ' this is useful if you want to only show the guage when something is
    ' happening but not show it at other times
    ' the percentage to show will be stored into the Tag property so that
    ' we can tell what it is currently set to if we need to repaint it at
    ' a random time

    Dim sPercent$
    Dim iLeft%
    Dim iTop%
    Dim iRight%
    Dim iBottom%
    Dim iLineWidth%

    ' these are used to create the 3D effect
    Const DGREYCOLOUR& = &H808080
    Const LGREYCOLOUR& = &HC0C0C0
    Const WHITECOLOUR& = &HFFFFFF

    Const COPYPEN = 13
    Const XORPEN = 7

    ' validate our percentage
    If iPercent% < 0 Then
	iPercent% = 0
    Else
	If iPercent% > 100 Then
	    iPercent% = 100
	End If
    End If

    ' set the number of twips per pixel into a variable
    ' NOTE: the picture control and the form it is on are expected to have
    ' their scale mode set to Twips
    iLineWidth% = Screen.TwipsPerPixelX

    ' I leave the BorderStyle set to 1 at design time so that the control is
    ' easy to find, but at run time we want the border to be invisible,
    ' however, just switching the border off will actually trigger a refresh
    ' of the control which is no use if AutoRedraw is set to False because
    ' that will trigger this code to run which will trigger another refresh
    ' which will ...
    If pic.BorderStyle <> 0 Then
	pic.BorderStyle = 0
    End If

    ' iVisible will either be set to True or False depending on whether we
    ' want to show or hide the control
    If iVisible% = False Then
	If pic.Visible <> False Then
	    pic.Visible = False
	End If
    Else
	If pic.Visible <> True Then
	    pic.Visible = True
	End If
    End If

    ' save the percentage into the Tag property - we can use this to repaint
    ' the guage if AutoRedraw is set to False
    pic.Tag = iPercent%

    ' set the text we will draw into a variable
    sPercent$ = CStr(iPercent%) & "%"

    ' work out the co-ords for the percentage bar
    iLeft% = iLineWidth%
    iTop% = iLineWidth%
    iRight% = pic.ScaleWidth - iLineWidth%
    iBottom% = pic.ScaleHeight - iLineWidth%

    ' erase everything by drawing a rectangle in the background colour
    pic.DrawMode = COPYPEN
    pic.Line (iLeft%, iTop%)-(iRight%, iBottom%), pic.BackColor, BF
    
    ' add the text - work out where to put it first - nicely centered
    ' the default in VB3 is for bold text, change the FontBold property in
    ' the Picture control if you want this to be non-bold
    pic.CurrentX = (pic.ScaleWidth - pic.TextWidth(sPercent$)) / 2
    pic.CurrentY = (pic.ScaleHeight - pic.TextHeight(sPercent$)) / 2
    pic.Print sPercent$
    
    ' do the two colour bar by setting the DrawMode to XOr then draw the bar
    ' in the fillcolour, if this overlaps the text then that portion of the
    ' text will get inverted, then XOr it again in the background colour,
    ' if you use the same colour for the FillColor and ForeColor then the
    ' text will invert nicely, but you can get some funny effects if you
    ' use two different colours
    ' NOTE: treat 0% as a special case because it will show up as a 1
    ' pixel wide line which looks bad
    ' ALSO NOTE: I am using BF in the call to the Line method, which means to
    ' draw a filled box, although I only want to draw lines which are a
    ' single pixel thick, because with trial and error I have found that this
    ' gives me the lines where I expect them for the co-ords that I am passing
    If iPercent% > 0 Then
	pic.DrawMode = XORPEN
	' XOr the pen
	pic.Line (iLeft%, iTop%)-((iRight% / 100) * iPercent, iBottom%), pic.FillColor, BF
	pic.Line (iLeft%, iTop%)-((iRight% / 100) * iPercent, iBottom%), pic.BackColor, BF
    End If
    
    ' add the 3D look - right, bottom, top, left
    pic.DrawMode = COPYPEN
    pic.Line (iRight%, iLineWidth%)-(iRight%, iBottom%), WHITECOLOUR&, BF
    pic.Line (iLineWidth%, iBottom%)-(iRight%, iBottom%), WHITECOLOUR&, BF
    pic.Line (0, 0)-(iRight%, 0), DGREYCOLOUR&, BF
    pic.Line (0, 0)-(0, iBottom%), DGREYCOLOUR&, BF
    
    ' this line adds an additional grey border around the inside of the control to
    ' accentuate the 3D border - personal preference thing
    pic.Line (iLeft%, iTop%)-(iRight% - iLineWidth%, iBottom% - iLineWidth%), LGREYCOLOUR, B

End Sub

Sub HSCroll1_Change ()

    ' call the routine which will paint the guage, the three parameters are
    ' the name of the PictureBox control which is being used for the Guage
    ' a number between 0 and 100, and True or False which is used to make
    ' sure that the picture control is either visible or not visible, the
    ' third parameter is there because I only want the guage to be visible
    ' when it is showing something meaningful, I usually put them at the
    ' right hand side of the status bar
    Call Guage(picGuage, HScroll1.Value, True)

End Sub

Sub HScroll1_Scroll ()

    Call HSCroll1_Change

End Sub

Sub picGuage_Paint ()

    ' this event will only get fired if AutoRedraw = False
    ' it gets fired when the control has to be redrawn, such as if part of it
    ' has been covered and has now been exposed again,
    ' if AutoRedraw is set to True then the control will retain the information
    ' required to repaint itself and will quite happily redraw itself but it
    ' will not pass on the message to us - this obviously uses more memory but
    ' does create a smoother refresh, I have stored the current value in the
    ' Tag property so if it is a number then we know what value to draw, it is
    ' up to you whether you feel you can afford to "waste" the memory required
    ' by setting AutoRedraw to True - for something as small as this the memory
    ' is negligible
    If IsNumeric(picGuage.Tag) = True Then
	Call Guage(picGuage, CInt(picGuage.Tag), picGuage.Visible)
    End If

End Sub

