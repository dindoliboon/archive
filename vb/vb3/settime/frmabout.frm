VERSION 2.00
Begin Form frmAbout 
   BackColor       =   &H8000000F&
   BorderStyle     =   3  'Fixed Double
   Caption         =   "About..."
   ClientHeight    =   1575
   ClientLeft      =   1950
   ClientTop       =   3000
   ClientWidth     =   5070
   Height          =   1980
   Icon            =   0
   Left            =   1890
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1575
   ScaleWidth      =   5070
   Top             =   2655
   Width           =   5190
   Begin CommandButton cmdOK 
      Cancel          =   -1  'True
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   1980
      TabIndex        =   2
      Top             =   1140
      Width           =   1215
   End
   Begin Label Label1 
      AutoSize        =   -1  'True
      BackColor       =   &H8000000F&
      Caption         =   "Compuserver ID : 100541,604"
      Height          =   195
      Index           =   2
      Left            =   660
      TabIndex        =   3
      Top             =   780
      Width           =   2550
   End
   Begin Label Label1 
      AutoSize        =   -1  'True
      BackColor       =   &H8000000F&
      Caption         =   "Copyright ©1995 Matthew Simpson"
      Height          =   195
      Index           =   1
      Left            =   660
      TabIndex        =   1
      Top             =   480
      Width           =   2985
   End
   Begin Label Label1 
      AutoSize        =   -1  'True
      BackColor       =   &H8000000F&
      Caption         =   "Date && Time stamp program written in Visual Basic."
      Height          =   195
      Index           =   0
      Left            =   660
      TabIndex        =   0
      Top             =   180
      Width           =   4335
   End
   Begin Image Image1 
      Height          =   480
      Left            =   60
      Picture         =   FRMABOUT.FRX:0000
      Top             =   120
      Width           =   480
   End
End
Option Explicit

Sub cmdOK_Click ()
    Unload Me
End Sub

Sub Form_Activate ()
    Screen.MousePointer = 0
End Sub

Sub Form_Load ()
    Call CenterForm(Me)
    Call RemoveSystemMenus(Me)
End Sub

