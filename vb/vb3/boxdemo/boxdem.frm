VERSION 2.00
Begin Form Form1 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Double
   ClientHeight    =   2085
   ClientLeft      =   2805
   ClientTop       =   2355
   ClientWidth     =   4245
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   Height          =   2490
   Left            =   2745
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2085
   ScaleWidth      =   4245
   Top             =   2010
   Width           =   4365
   Begin PictureBox Picture1 
      BackColor       =   &H00FFFFFF&
      ForeColor       =   &H00000000&
      Height          =   1815
      Left            =   120
      ScaleHeight     =   119
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   263
      TabIndex        =   0
      Top             =   120
      Visible         =   0   'False
      Width           =   3975
      Begin Shape Shape2 
         BorderColor     =   &H00C00000&
         BorderWidth     =   4
         Height          =   1800
         Left            =   0
         Top             =   0
         Width           =   3960
      End
      Begin Label Label1 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Height          =   1575
         Left            =   120
         TabIndex        =   1
         Top             =   120
         Width           =   3735
      End
   End
   Begin CommandButton Command1 
      Caption         =   "&Start"
      Height          =   375
      Left            =   1560
      TabIndex        =   2
      Top             =   840
      Width           =   1095
   End
   Begin Shape Shape1 
      BackColor       =   &H00C0C0C0&
      BorderColor     =   &H00C0C0C0&
      BorderStyle     =   3  'Dot
      DrawMode        =   6  'Invert
      Height          =   135
      Left            =   4440
      Top             =   120
      Visible         =   0   'False
      Width           =   135
   End
End
'
'
'  ****************************
'  *  Exploding Picture Demo  *
'  *                          *
'  *        Written by        *
'  *    Christopher A Evans   *
'  *     Saaiiee@AOL.COMM     *
'  *     (908) 874 - 3397     *
'  *                          *
'  * ©1995Christopher A Evans *
'  ****************************
'
'  This is just a test version some basic sub routines.
'  I have a P90 with a 1meg STB PCI video card and I would
'  like to know how well it works on other systems. If you
'  have a slower system could you E-mail me some performance
'  info, thanks.
'
'  The code is intentional simple, since this is just a
'  test. If you add some variables into the explode/implode
'  subs it could become must more powerful.
'
'  You are free to use this code as you see fit as long as
'  I am not held responsible for any damages. The sounds are
'  mine! Do not use them!
'
'  If you like some more code examples, sounds, buttons or
'  anything I have developed for multi media thing get in
'  touch with me. I don't usually sell the stuff but I like
'  to it trade for other original mm development files.
'
'
'
'

Sub Command1_Click ()
command1.Visible = False
playsound ("mousehit.wav")
exploder

End Sub

'
'
' Does any one know how to tell if a wav is playing?
' Wend\loop whould help alot!
'
Sub exploder ()
 '
 ' You may neeed to add a path befor the sound
 ' eg. Playsound "c:\boxdem\in.wav"
 '
 playsound "in.wav"
 pl = picture1.Left
 pt = picture1.Top
 pw = picture1.Width / 2
 ph = picture1.Height / 2
 rcx = pw
 rcy = ph
 rcmx = (rcx / 20)
 rcmy = (rcy / 20)
 rmx = (pw / 10)
 rmy = (ph / 10)
 shape1.Move pl + rcx, pr + rcy
 shape1.Visible = True
For X = 1 To 20
    Debug.Print X
    shape1.Move pl + rcx - (rcmx * X), pt + rcy - (rcmy * X), rmx * X, rmy * X
Next X

picture1.Visible = True
    
    shape1.BorderStyle = 1
    shape1.FillStyle = 1
    shape1.BackStyle = 1
    shape1.DrawMode = 13
    shape1.Move pl + 80, pt + 80, pw * 2, ph * 2

End Sub

Sub Form_Click ()
playsound ("C:\mousehit.wav")
End Sub

Sub Form_Load ()
        
    clicknum = 1

    info(1) = "Exploding Picture Demo" & Chr$(13) & Chr$(13) & "Written by" & Chr$(13) & "Christopher A Evans" & Chr$(13) & "Saaiiee@AOL.COMM" & Chr$(13) & "(908) 874 - 3397" & Chr$(13) & Chr$(13) & " ©1995Christopher A Evans"

    info(2) = "    This is just a test version some basic sub routines. I have a P90 with a 1meg STB PCI video card and I would like to know how well it works on other systems. If you have a slower system could you E-mail me some performance info."

    info(3) = "    The code is intentional simple, since this is just a test. If you add some variables into the explode/implode sub it could become much more powerful."

    info(4) = "    You are free to use this code as you see fit as long as I am not held responsible for any damages." & Chr$(13) & Chr$(13) & "    The sounds are mine! Do not use them!" & Chr$(13) & Chr$(13) & "The left mouse button will  end  this demo."

    info(5) = "    If you would like some more code examples, sounds, buttons or anything else I have developed for multi media apps, get in touch with me. I don't usually sell the stuff but I like to it trade for other original MM development files."
   
    label1.Caption = info(1)
End Sub

'
' Does any one know how to tell if a wav is playing?
' Wend\loop whould help alot!
'
'
'
Sub impolder ()
 label1.Alignment = 0
 clicknum = clicknum + 1
 If clicknum > 5 Then
    clicknum = 1
    label1.Alignment = 2
    End If


 pl = picture1.Left
 pt = picture1.Top
 pw = picture1.Width / 2
 ph = picture1.Height / 2
 rcx = pw
 rcy = ph
 rcmx = (rcx / 20)
 rcmy = (rcy / 20)
 rmx = (pw / 10)
 rmy = (ph / 10)
 
 shape1.Move pl, pr '+ rcx, pr + rcy
 shape1.Visible = True

 picture1.Visible = False
    
 shape1.BorderStyle = 3
 shape1.FillStyle = 1
 shape1.BackStyle = 0
 shape1.DrawMode = 6
 


For X = 20 To 1 Step -1
    Debug.Print X
    shape1.Move pl + rcx - (rcmx * X), pt + rcy - (rcmy * X), rmx * X, rmy * X
Next X
    shape1.Visible = False
    label1.Caption = info(clicknum)
    For a = 1 To 20: Next a
    exploder
End Sub

'
' Does any one know how to tell if a wav is playing?
' Wend\loop whould help alot!
'
Sub Label1_Click ()
 '
 ' You may neeed to add a path befor the sound
 ' eg. Playsound "c:\boxdem\in.wav"
 '

playsound ("mousehit.wav")
impolder
End Sub

Sub Label1_MouseDown (button As Integer, Shift As Integer, X As Single, Y As Single)
If button = 2 Then End
End Sub

