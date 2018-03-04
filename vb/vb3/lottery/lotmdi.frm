VERSION 2.00
Begin Form AboutWindow 
   BackColor       =   &H00000000&
   BorderStyle     =   3  'Fixed Double
   Caption         =   "About fing"
   ClientHeight    =   2880
   ClientLeft      =   1290
   ClientTop       =   1830
   ClientWidth     =   6810
   ControlBox      =   0   'False
   FontBold        =   -1  'True
   FontItalic      =   0   'False
   FontName        =   "Times New Roman"
   FontSize        =   10.5
   FontStrikethru  =   0   'False
   FontUnderline   =   0   'False
   Height          =   3285
   Icon            =   LOTMDI.FRX:0000
   Left            =   1230
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   ScaleHeight     =   2880
   ScaleWidth      =   6810
   Top             =   1485
   Width           =   6930
   Begin PictureBox Picture1 
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      Height          =   2910
      Left            =   3345
      ScaleHeight     =   2910
      ScaleWidth      =   3525
      TabIndex        =   4
      Top             =   -15
      Width           =   3525
      Begin Label Label4 
         BackColor       =   &H00000000&
         Caption         =   "If anybody wins more than a tenner by using this program, then I hope you'll send me a percentage of the winnings!"
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "Times New Roman"
         FontSize        =   8.25
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         ForeColor       =   &H0000FFFF&
         Height          =   660
         Left            =   195
         TabIndex        =   5
         Top             =   2025
         Width           =   3075
      End
      Begin Label Label1 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Dunks Lotto Picker is copyrighted"
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "Times New Roman"
         FontSize        =   12
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         ForeColor       =   &H000000FF&
         Height          =   285
         Left            =   30
         TabIndex        =   1
         Top             =   150
         Width           =   3420
      End
      Begin Label Label2 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "And DAS is a trademarked name"
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "Times New Roman"
         FontSize        =   10.5
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         ForeColor       =   &H00FF0000&
         Height          =   255
         Left            =   225
         TabIndex        =   2
         Top             =   540
         Width           =   3060
      End
      Begin Label Label3 
         BackStyle       =   0  'Transparent
         Caption         =   "Any attempt of breaking established copyrights will result in SEVERE PAIN!"
         FontBold        =   -1  'True
         FontItalic      =   0   'False
         FontName        =   "Times New Roman"
         FontSize        =   15
         FontStrikethru  =   0   'False
         FontUnderline   =   0   'False
         ForeColor       =   &H0000FF00&
         Height          =   1065
         Left            =   90
         TabIndex        =   3
         Top             =   870
         Width           =   3375
      End
   End
   Begin CommandButton Command1 
      Caption         =   "Quit"
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "Times New Roman"
      FontSize        =   15
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   495
      Left            =   1470
      TabIndex        =   0
      Top             =   2130
      Width           =   915
   End
   Begin Image Image1 
      Height          =   5505
      Left            =   -2280
      Picture         =   LOTMDI.FRX:0302
      Stretch         =   -1  'True
      Top             =   -600
      Visible         =   0   'False
      Width           =   7980
   End
End
Sub Command1_Click ()
AboutWindow.Hide
End Sub

Sub Form_Activate ()
image1.Visible = False
image1.Top = -885
image1.Left = -2280
normy = image1.Top
normx = image1.Left
firstgo = 1
Do
 DoEvents
 ang = ang + 1: If ang > 360 Then ang = 0
 x = Cos(ang * (3.14159265359 / 180)) * 1000
 y = Sin(ang * (3.14159265359 / 180)) * 1000
 image1.Top = normy + y
 image1.Left = normx + x
 If image1.Visible = False Then image1.Visible = True
Loop
End Sub

Sub Form_Deactivate ()
AboutWindow.Hide
End Sub

