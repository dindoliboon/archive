// Windows Script Host Sample Script
//
// ------------------------------------------------------------------------
//               Copyright (C) 1996 Microsoft Corporation
//
// You have a royalty-free right to use, modify, reproduce and distribute
// the Sample Application Files (and/or any modified version) in any way
// you find useful, provided that you agree that Microsoft has no warranty,
// obligations or liability for any Sample Application Files.
// ------------------------------------------------------------------------

// This sample will display Windows Scripting Host properties in Excel.


var vbOKCancel = 1;
var vbInformation = 64;
var vbCancel = 2;

var L_Welcome_MsgBox_Message_Text    = "This script will display Windows Scripting Host properties in Excel.";
var L_Welcome_MsgBox_Title_Text      = "Windows Scripting Host Sample";
Welcome();
    

//////////////////////////////////////////////////////////////////////////////////
//
// Excel Sample
//
var objXL = WScript.CreateObject("Excel.Application");

objXL.Visible = true;

objXL.WorkBooks.Add;

objXL.Columns(1).ColumnWidth = 20;
objXL.Columns(2).ColumnWidth = 30;
objXL.Columns(3).ColumnWidth = 40;

objXL.Cells(1, 1).Value = "Property Name";
objXL.Cells(1, 2).Value = "Value";
objXL.Cells(1, 3).Value = "Description";

objXL.Range("A1:C1").Select;
objXL.Selection.Font.Bold = true;
objXL.Selection.Interior.ColorIndex = 1;
objXL.Selection.Interior.Pattern = 1; //xlSolid
objXL.Selection.Font.ColorIndex = 2;

objXL.Columns("B:B").Select;
objXL.Selection.HorizontalAlignment = -4131; // xlLeft

var intIndex = 2;

function Show(strName, strValue, strDesc) {
    objXL.Cells(intIndex, 1).Value = strName;
    objXL.Cells(intIndex, 2).Value = strValue;
    objXL.Cells(intIndex, 3).Value = strDesc;
    intIndex++;
    objXL.Cells(intIndex, 1).Select;
}

//
// Show WScript properties
//
Show("Name",           WScript.Name,           "Application Friendly Name");
Show("Version",        WScript.Version,        "Application Version");
Show("FullName",       WScript.FullName,       "Application Context: Fully Qualified Name");
Show("Path",           WScript.Path,           "Application Context: Path Only");
Show("Interactive",    WScript.Interactive,    "State of Interactive Mode");


//
// Show command line arguments.
//
var colArgs = WScript.Arguments
Show("Arguments.Count", colArgs.length, "Number of command line arguments");

for (i = 0; i < colArgs.length; i++) {
    objXL.Cells(intIndex, 1).Value = "Arguments(" + i + ")";
    objXL.Cells(intIndex, 2).Value = colArgs(i);
    intIndex++;
    objXL.Cells(intIndex, 1).Select;
}


//////////////////////////////////////////////////////////////////////////////////
//
// Welcome
//
function Welcome() {
    var WSHShell = WScript.CreateObject("WScript.Shell");
    var intDoIt;

    intDoIt =  WSHShell.Popup(L_Welcome_MsgBox_Message_Text,
                              0,
                              L_Welcome_MsgBox_Title_Text,
                              vbOKCancel + vbInformation );
    if (intDoIt == vbCancel) {
        WScript.Quit();
    }
}

