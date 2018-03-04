VERSION 2.00
Begin Form Form1 
   Caption         =   "FreeSpy by WorldMaker@aol.com"
   ClientHeight    =   2430
   ClientLeft      =   1530
   ClientTop       =   2955
   ClientWidth     =   5835
   Height          =   2835
   Icon            =   FRMMAIN.FRX:0000
   Left            =   1470
   LinkTopic       =   "Form1"
   ScaleHeight     =   2430
   ScaleWidth      =   5835
   Top             =   2610
   Width           =   5955
   Begin Timer Timer1 
      Interval        =   100
      Left            =   180
      Top             =   135
   End
End
   'FreeSpy by WorldMaker@aol.com
   '
   'IvanSkii and I discussed some Visual Basic stuff one day and
   'talk got around to the IVY Spy program he uploaded to AOL a couple
   'of years ago. He said the code was from the Microsoft Visual Basic
   'Knowledge Base. So, I checked. I played. And I added a little to it.
   'I like my VB apps to start up in the center of the screen. In the
   'Form_Load event, you'll find the code which handles this. Also,
   'since I use this little thing to double-check handle values, I find
   'it useful that it stay on top *always*, and when maximized from a
   'minimized state, that it *stay* on top. You'll find the code for that
   'here in the general declarations section.
   '
   'Feel free to do whatever you'd like with this. The code is from the
   'VBKB with minor additions and changes by me. Just have fun. :)

   
   Declare Sub GetCursorPos Lib "User" (lpPoint As Long)
   Declare Function WindowFromPoint Lib "User" (ByVal ptScreen As Any) As Integer
   Declare Function GetModuleFileName Lib "Kernel" (ByVal hModule As Integer, ByVal lpFilename As String, ByVal nSize As Integer) As Integer
   Declare Function GetWindowWord Lib "User" (ByVal hWnd As Integer, ByVal nIndex As Integer) As Integer
   Declare Function GetWindowLong Lib "User" (ByVal hWnd As Integer, ByVal nIndex As Integer) As Long
   Declare Function GetParent Lib "User" (ByVal hWnd As Integer) As Integer
   Declare Function GetClassName Lib "User" (ByVal hWnd As Integer, ByVal lpClassName As String, ByVal nMaxCount As Integer) As Integer
   Declare Function GetWindowText Lib "User" (ByVal hWnd As Integer, ByVal lpString As String, ByVal aint As Integer) As Integer
   Declare Function SetWindowPos Lib "user" (ByVal h%, ByVal hb%, ByVal X%, ByVal Y%, ByVal cx%, ByVal cy%, ByVal f%) As Integer
   Declare Function GetActiveWindow% Lib "User" ()

   Const GWW_HINSTANCE = (-6)
   Const GWW_ID = (-12)
   Const GWL_STYLE = (-16)
   Const HWND_TOPMOST = -1
   Const HWND_NOTOPMOST = -2
   Const SWP_NOMOVE = 2
   Const SWP_NOSIZE = 1
   Const FLAGS = SWP_NOMOVE Or SWP_NOSIZE
   Const SW_MINIMIZE = 6

Sub Form_Load ()

    'This centers the form. I usually add a function to center
    'a form but since this is just a one-form kinda program,
    'I just put it here.
    Me.Left = (screen.Width - Me.Width) / 2
    Me.Top = (screen.Height - Me.Height) / 2

    'This calls the StayOnTop function. You can find this
    'particular function under every rock and in just about
    'every book on Visual Basic. :)
    StayOnTop Me

End Sub

Sub Label1_Click ()
End
End Sub

Sub StayOnTop (frm As Form)

    Dim success%
    success% = SetWindowPos(frm.hWnd, HWND_TOPMOST, 0, 0, 0, 0, FLAGS)

End Sub

Sub Timer1_Timer ()

'Among the things I played with was removing the Hex function from
'this code. Personally, I don't care much about Hex values. If that
'kind of thing floats *your* boat, pull out the KB article and
'change it back. :)

Dim ptCursor As Long
      Dim sWindowText As String * 100
      Dim sClassName As String * 100
      Dim hWndOver As Integer
      Dim hWndParent As Integer
      Dim sParentClassName As String * 100
      Dim wID As Integer
      Dim lWindowStyle As Long
      Dim hInstance As Integer
      Dim sParentWindowText As String * 100

      Dim sModuleFileName As String * 100
      Static hWndLast As Integer

      Call GetCursorPos(ptCursor)               ' Get cursor position
      hWndOver = WindowFromPoint(ptCursor)      ' Get window cursor is over
      If hWndOver <> hWndLast Then              ' If changed update display
         hWndLast = hWndOver                    ' Save change
         Cls                                      ' Clear the form
         Print "Window Handle: "; (hWndOver) ' Display window handle
         Print "Focus: "; GetActiveWindow()  'I added this
         r = GetWindowText(hWndOver, sWindowText, 100)      ' Window text
         Print "Window Text: " & Left(sWindowText, r)

         r = GetClassName(hWndOver, sClassName, 100)         ' Window Class
         Print "Window Class Name: "; Left(sClassName, r)

         lWindowStyle = GetWindowLong(hWndOver, GWL_STYLE)   ' Window Style
         Print "Window Style: "; (lWindowStyle)

         ' Get handle of parent window:
         hWndParent = GetParent(hWndOver)

         ' If there is a parent get more info:

         If hWndParent <> 0 Then
            ' Get ID of window:
            wID = GetWindowWord(hWndOver, GWW_ID)
            Print "Window ID Number: "; (wID)
            Print "Parent Window Handle: "; (hWndParent)

            ' Get the text of the Parent window:
            r = GetWindowText(hWndParent, sParentWindowText, 100)
            Print "Parent Window Text: " & Left(sParentWindowText, r)

            ' Get the class name of the parent window:
            r = GetClassName(hWndParent, sParentClassName, 100)
            Print "Parent Window Class Name: "; Left(sParentClassName, r)
         Else
            ' Update fields when no parent:
            Print "Window ID Number: N/A"
            Print "Parent Window Handle: N/A"
            Print "Parent Window Text : N/A"

            Print "Parent Window Class Name: N/A"
         End If

         ' Get window instance:
         hInstance = GetWindowWord(hWndOver, GWW_HINSTANCE)

         ' Get module file name:
         r = GetModuleFileName(hInstance, sModuleFileName, 100)
         Print "Module: "; Left(sModuleFileName, r)
      End If
    


End Sub

