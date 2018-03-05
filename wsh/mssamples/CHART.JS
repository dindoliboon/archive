// Windows Script Host Sample Script
//
// ------------------------------------------------------------------------
//               Copyright (C) 1996-1997 Microsoft Corporation
//
// You have a royalty-free right to use, modify, reproduce and distribute
// the Sample Application Files (and/or any modified version) in any way
// you find useful, provided that you agree that Microsoft has no warranty,
// obligations or liability for any Sample Application Files.
// ------------------------------------------------------------------------

// This sample demonstrates how to access Microsoft Excel using the Windows Scripting Host.

var vbOKCancel = 1;
var vbInformation = 64;
var vbCancel = 2;

var L_Welcome_MsgBox_Message_Text    = "This script demonstrates how to access Excel using the Windows Scripting Host.";
var L_Welcome_MsgBox_Title_Text      = "Windows Scripting Host Sample";
Welcome();
    
//////////////////////////////////////////////////////////////////////////////////
//
// Excel Sample
//

var objXL;

objXL = WScript.CreateObject("Excel.Application");
objXL.Workbooks.Add;
objXL.Cells(1,1).Value = 5;
objXL.Cells(1,2).Value = 10;
objXL.Cells(1,3).Value = 15
objXL.Range("A1:C1").Select;

var objXLchart = objXL.Charts.Add();
objXL.Visible = true;
objXLchart.Type = -4100;

var intRotate;
for(intRotate = 5; intRotate <= 180; intRotate += 5) {
    objXLchart.Rotation = intRotate;
}

for (intRotate = 175; intRotate >= 0; intRotate -= 5) {
    objXLchart.Rotation = intRotate;
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
