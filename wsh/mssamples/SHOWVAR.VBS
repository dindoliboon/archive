' Windows Script Host Sample Script
'
' ------------------------------------------------------------------------
'               Copyright (C) 1996-1997 Microsoft Corporation
'
' You have a royalty-free right to use, modify, reproduce and distribute
' the Sample Application Files (and/or any modified version) in any way
' you find useful, provided that you agree that Microsoft has no warranty,
' obligations or liability for any Sample Application Files.
' ------------------------------------------------------------------------

' This sample will list all environment variables defined on this machine.

L_Welcome_MsgBox_Message_Text    = "This script will list all environment variables defined on this machine."
L_Welcome_MsgBox_Title_Text      = "Windows Scripting Host Sample"
Call Welcome()


' ********************************************************************************
' *
' * Environment Sample
' *
CRLF = Chr(13) & Chr(10)

Dim WSHShell
Set WSHShell = WScript.CreateObject("WScript.Shell")


Sub show_env(strText)
    MsgBox strText, vbInformation, L_Welcome_MsgBox_Title_Text
End Sub

intIndex = 0
strText = ""
intNumEnv = 0
MAX_ENV = 20
For Each strEnv In WshShell.Environment("PROCESS")
    intIndex = intIndex + 1
    strText = strText & CRLF & Right("    " & intIndex, 4) & " " & strEnv
    intNumEnv = intNumEnv + 1
    If intNumEnv >= MAX_ENV Then
        Call show_env(strText)
        strText = ""
        intNumEnv = 0
    End If
Next

If intNumEnv >= 1 Then Call show_env(strText)


' ********************************************************************************
' *
' * Welcome
' *
Sub Welcome()
    Dim intDoIt

    intDoIt =  MsgBox(L_Welcome_MsgBox_Message_Text, _
                      vbOKCancel + vbInformation,    _
                      L_Welcome_MsgBox_Title_Text )
    If intDoIt = vbCancel Then
        WScript.Quit
    End If
End Sub
