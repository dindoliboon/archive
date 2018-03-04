Option Explicit

Type RECT   '8 Bytes
        left As Integer
        top As Integer
        right As Integer
        bottom As Integer
End Type

Type TEXTMETRIC   '31 Bytes
        tmHeight As Integer
        tmAscent As Integer
        tmDescent As Integer
        tmInternalLeading As Integer
        tmExternalLeading As Integer
        tmAveCharWidth As Integer
        tmMaxCharWidth As Integer
        tmWeight As Integer
        tmItalic As String * 1
        tmUnderlined As String * 1
        tmStruckOut As String * 1
        tmFirstChar As String * 1
        tmLastChar As String * 1
        tmDefaultChar As String * 1
        tmBreakChar As String * 1
        tmPitchAndFamily As String * 1
        tmCharSet As String * 1
        tmOverhang As Integer
        tmDigitizedAspectX As Integer
        tmDigitizedAspectY As Integer
End Type

Declare Sub ShellAbout Lib "shell.dll" (ByVal hWndOwner%, ByVal lpszAppName$, ByVal lpszMoreInfo$, ByVal hIcon%)
Declare Function SendMessage& Lib "User" (ByVal hwnd%, ByVal wMsg%, ByVal wParam%, lParam As Any)
Declare Function SendMessageByNum& Lib "User" Alias "SendMessage" (ByVal hwnd%, ByVal wMsg%, ByVal wParam%, ByVal lParam&)
Declare Function GetDC% Lib "User" (ByVal hwnd%)
Declare Function ReleaseDC% Lib "User" (ByVal hwnd%, ByVal hDC%)
Declare Function SelectObject% Lib "GDI" (ByVal hDC%, ByVal hObject%)
Declare Function GetTextMetrics% Lib "GDI" (ByVal hDC%, lpMetrics As TEXTMETRIC)

'AVELINELENGTH is used a to calculate how many lines of the file to
'put in each file buffer to avoid busting the 32K limit of the Text Box.
'AVELINELENGTH can be adjusted for files with long lines.
'However, the program will automatically attempt to adjust itself by
'multiplying ave-line-length times 1.25 five times running before giving up.
'i.e. an AVELINELENGTH of 80 will handle a file with ave-line-length of 243.

Global Const AVELINELENGTH = 80

Global Const MAXLINESVISIBLE = 48  'max lines needed to fit in textbox view
                                   'e.g. 48 for maximized window using 1024x768 small font
Global Const DEFAULT = 0        ' MOUSE POINTER
Global Const HOURGLASS = 11     ' MOUSE CURSOR
Global Const WM_GETFONT = &H31
'  Private Window Messages Start Here:
Global Const WM_USER = &H400
Global Const EM_LINESCROLL = WM_USER + 6  ' = &H406
Global Const EM_GETRECT = WM_USER + 2

