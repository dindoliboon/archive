Option Explicit

Global sAppPath As String

Global Const sININame$ = "SETTIME.INI"

' **************** DECLARATION OF API FUNCTIONS *******************
Declare Function GetPrivateProfileString Lib "Kernel" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Integer, ByVal lpFileName As String) As Integer
Declare Function WritePrivateProfileString Lib "Kernel" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lplFileName As String) As Integer
Declare Function GetSystemMenu Lib "User" (ByVal hWnd As Integer, ByVal bRevert As Integer) As Integer
Declare Function DeleteMenu Lib "User" (ByVal hMenu As Integer, ByVal nPosition As Integer, ByVal wFlags As Integer) As Integer
Declare Function GetFreeSystemResources Lib "User" (ByVal fuSysResource As Integer) As Integer
Declare Function GetWinFlags Lib "Kernel" () As Long
Declare Function GetFreeSpace Lib "Kernel" (ByVal wFlags As Integer) As Long
Declare Function WinHelp Lib "User" (ByVal hWnd As Integer, ByVal lpHelpFile As String, ByVal wCommand As Integer, ByVal dwData As Long) As Integer
Declare Function SendMessage Lib "User" (ByVal hWnd As Integer, ByVal wMsg As Integer, ByVal wParam As Integer, lParam As Any) As Long

' Send Message API
Global Const WM_USER = &H400
Global Const LB_SETTABSTOPS = (WM_USER + 19)

' WinHelp API's
Global Const HELP_CONTEXT = &H1         ' Display topic in ulTopic
Global Const HELP_QUIT = &H2            ' Terminate help
Global Const HELP_CONTENTS = &H3        ' Display Help for a particular topic
Global Const HELP_HELPONHELP = &H4      ' Display help on using help
Global Const HELP_PARTIALKEY = &H105    ' Display topic found in keyword list

' DeleteMenu API's
Global Const MF_BYPOSITION = &H400      ' Used in DeleteMenu functions

' Win Info API's
Global Const WF_80x87 = &H400
Global Const WF_CPU086 = &H40
Global Const WF_CPU186 = &H80
Global Const WF_CPU286 = &H2
Global Const WF_CPU386 = &H4
Global Const WF_CPU486 = &H8
Global Const WF_ENHANCED = &H20

Sub CenterForm (aForm As Form)
    aForm.Move (Screen.Width - aForm.Width) / 2, (Screen.Height - aForm.Height) / 2
End Sub

Function FileExist (sName) As Integer
    Dim iFreeFile As Integer

    On Error Resume Next
    FileExist = True
    iFreeFile = FreeFile
    Open sName For Input Access Read Shared As iFreeFile
    Close iFreeFile
    If Err Then
        FileExist = False
    End If
End Function

Sub Highlight (aControl As Control)
    aControl.SelStart = 0
    aControl.SelLength = 2000
End Sub

Function ReadFromINI (sSection As String, sParam As String) As String
    Dim iResult As Integer
    Dim sDummy As String * 500

    iResult = GetPrivateProfileString(sSection, sParam, "*ERROR*", sDummy, 500, sAppPath + sININame)
    ReadFromINI = Left(sDummy, iResult)
End Function

Sub RemoveSystemMenus (aForm As Form)
    Dim iFormHandle As Integer, iSysMenu As Integer, iRes As Integer

    iFormHandle = aForm.hWnd
    iSysMenu = GetSystemMenu(iFormHandle, False)
    iRes = DeleteMenu(iSysMenu, 8, MF_BYPOSITION)   ' Switch To...
    iRes = DeleteMenu(iSysMenu, 7, MF_BYPOSITION)   ' Seperator
    iRes = DeleteMenu(iSysMenu, 5, MF_BYPOSITION)   ' Seperator
    iRes = DeleteMenu(iSysMenu, 4, MF_BYPOSITION)   ' Max
    iRes = DeleteMenu(iSysMenu, 3, MF_BYPOSITION)   ' Min
    iRes = DeleteMenu(iSysMenu, 2, MF_BYPOSITION)   ' Size
    iRes = DeleteMenu(iSysMenu, 0, MF_BYPOSITION)   ' Restore
End Sub

Sub ShowHelpTopic (sHelpFile As String, iCommand As Integer, lTopicNum As Long)
    Dim iResult As Integer
    Screen.MousePointer = 11
    iResult = WinHelp(frmSetTime.hWnd, sHelpFile, iCommand, lTopicNum)
    Screen.MousePointer = 0
End Sub

Function WriteToINI (sSection As String, sParam As String, sValue As String) As Integer
    Dim iResult As Integer

    iResult = WritePrivateProfileString(sSection, sParam, sValue, sAppPath + sININame)

    WriteToINI = iResult
End Function

