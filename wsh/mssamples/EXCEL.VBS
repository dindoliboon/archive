' Windows Script Host Sample Script
'
' ------------------------------------------------------------------------
'               Copyright (C) 1996 Microsoft Corporation
'
' You have a royalty-free right to use, modify, reproduce and distribute
' the Sample Application Files (and/or any modified version) in any way
' you find useful, provided that you agree that Microsoft has no warranty,
' obligations or liability for any Sample Application Files.
' ------------------------------------------------------------------------

' This sample will display Windows Scripting Host properties in Excel.

L_Welcome_MsgBox_Message_Text    = "This script will display Windows Scripting Host properties in Excel."
L_Welcome_MsgBox_Title_Text      = "Windows Scripting Host Sample"
Call Welcome()
    

' ********************************************************************************
' *
' * Excel Sample
' *
Dim objXL
Set objXL = WScript.CreateObject("Excel.Application")

objXL.Visible = TRUE

objXL.WorkBooks.Add

objXL.Columns(1).ColumnWidth = 20
objXL.Columns(2).ColumnWidth = 30
objXL.Columns(3).ColumnWidth = 40

objXL.Cells(1, 1).Value = "Property Name"
objXL.Cells(1, 2).Value = "Value"
objXL.Cells(1, 3).Value = "Description"

objXL.Range("A1:C1").Select
objXL.Selection.Font.Bold = True
objXL.Selection.Interior.ColorIndex = 1
objXL.Selection.Interior.Pattern = 1 'xlSolid
objXL.Selection.Font.ColorIndex = 2

objXL.Columns("B:B").Select
objXL.Selection.HorizontalAlignment = &hFFFFEFDD ' xlLeft

Dim intIndex
intIndex = 2

Sub Show(strName, strValue, strDesc)
    objXL.Cells(intIndex, 1).Value = strName
    objXL.Cells(intIndex, 2).Value = strValue
    objXL.Cells(intIndex, 3).Value = strDesc
    intIndex = intIndex + 1
    objXL.Cells(intIndex, 1).Select
End Sub

'
' Show WScript properties
'
Call Show("Name",           WScript.Name,           "Application Friendly Name")
Call Show("Version",        WScript.Version,        "Application Version")
Call Show("FullName",       WScript.FullName,       "Application Context: Fully Qualified Name")
Call Show("Path",           WScript.Path,           "Application Context: Path Only")
Call Show("Interactive",    WScript.Interactive,    "State of Interactive Mode")


'
' Show command line arguments.
'
Dim colArgs
Set colArgs = WScript.Arguments
Call Show("Arguments.Count", colArgs.Count, "Number of command line arguments")

For i = 0 to colArgs.Count - 1
    objXL.Cells(intIndex, 1).Value = "Arguments(" & i & ")"
    objXL.Cells(intIndex, 2).Value = colArgs(i)
    intIndex = intIndex + 1
    objXL.Cells(intIndex, 1).Select
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

