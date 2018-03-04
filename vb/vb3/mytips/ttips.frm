VERSION 2.00
Begin Form TTips 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   0  'None
   Caption         =   "ToolTips"
   ClientHeight    =   840
   ClientLeft      =   3360
   ClientTop       =   2070
   ClientWidth     =   2565
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   Height          =   1245
   Left            =   3300
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   840
   ScaleWidth      =   2565
   Top             =   1725
   Width           =   2685
   Begin Timer Timer 
      Interval        =   500
      Left            =   840
      Top             =   60
   End
   Begin Label Tip 
      AutoSize        =   -1  'True
      BackColor       =   &H0080FFFF&
      BorderStyle     =   1  'Fixed Single
      FontBold        =   0   'False
      FontItalic      =   0   'False
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   225
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   75
   End
End

Sub Timer_Timer ()
DisplayTips
End Sub

