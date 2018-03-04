VERSION 2.00
Begin Form Form1 
   Caption         =   "Long Filename Sample"
   ClientHeight    =   5820
   ClientLeft      =   1095
   ClientTop       =   1770
   ClientWidth     =   7365
   Height          =   6510
   Left            =   1035
   LinkTopic       =   "Form1"
   ScaleHeight     =   5820
   ScaleWidth      =   7365
   Top             =   1140
   Width           =   7485
   Begin TextBox Text1 
      FontBold        =   -1  'True
      FontItalic      =   0   'False
      FontName        =   "Arial"
      FontSize        =   8.25
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   5835
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   0
      Width           =   7395
   End
   Begin Menu mnuFile 
      Caption         =   "&File"
      Begin Menu mnuFOpen 
         Caption         =   "&Open"
      End
      Begin Menu mnuFSave 
         Caption         =   "&Save"
      End
      Begin Menu mnuFExit 
         Caption         =   "E&xit"
      End
   End
End
Option Explicit

Sub mnuFExit_Click ()

   Unload Me

End Sub

Sub mnuFOpen_Click ()

   LF.Action = 1
   GetLongFilename
   If LF.Action = -1 Then Exit Sub

   OpenFile
      

End Sub

Sub mnuFSave_Click ()
   
   LF.Action = 2
   LF.Filename = gLongFilename
   GetLongFilename
   If LF.Action = -1 Then Exit Sub

   SaveFileAs
   
End Sub

