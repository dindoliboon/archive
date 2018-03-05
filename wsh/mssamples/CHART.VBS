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

' This sample demonstrates how to access Microsoft Excel using the Windows Scripting Host.

L_Welcome_MsgBox_Message_Text    = "This script demonstrates how to access Excel using the Windows Scripting Host."
L_Welcome_MsgBox_Title_Text      = "Windows Scripting Host Sample"
Call Welcome()
    
' ********************************************************************************
' *
' * Excel Sample
' *

Dim objXL
Dim objXLchart
Dim intRotate

Set objXL = WScript.CreateObject("Excel.Application")
objXL.Workbooks.Add
objXL.Cells(1,1).Value = 5
objXL.Cells(1,2).Value = 10
objXL.Cells(1,3).Value = 15
objXL.Range("A1:C1").Select

Set objXLchart = objXL.Charts.Add()
objXL.Visible = True
objXLchart.Type = -4100     

For intRotate = 5 To 180 Step 5
    objXLchart.Rotation = intRotate
Next

For intRotate = 175 To 0 Step -5
    objXLchart.Rotation = intRotate
Next

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

