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
//
// This sample demonstrates how to write/delete entries in the registry. 

var vbOKCancel = 1;
var vbInformation = 64;
var vbCancel = 2;

var L_Welcome_MsgBox_Message_Text   = "This script demonstrates how to create and delete registry keys.";
var L_Welcome_MsgBox_Title_Text     = "Windows Scripting Host Sample";
Welcome();


// ********************************************************************************
// *
// * Registry related methods.
// *

var WSHShell = WScript.CreateObject("WScript.Shell");

WSHShell.Popup("Create key HKCU\\MyRegKey with value 'Top level key'");
WSHShell.RegWrite("HKCU\\MyRegKey\\", "Top level key");

WSHShell.Popup("Create key HKCU\\MyRegKey\\Entry with value 'Second level key'");
WSHShell.RegWrite("HKCU\\MyRegKey\\Entry\\", "Second level key");

WSHShell.Popup("Set value HKCU\\MyRegKey\\Value to REG_SZ 1");
WSHShell.RegWrite("HKCU\\MyRegKey\\Value", 1);

WSHShell.Popup("Set value HKCU\\MyRegKey\\Entry to REG_DWORD 2");
WSHShell.RegWrite("HKCU\\MyRegKey\\Entry", 2, "REG_DWORD");

WSHShell.Popup("Set value HKCU\\MyRegKey\\Entry\\Value1 to REG_BINARY 3");
WSHShell.RegWrite("HKCU\\MyRegKey\\Entry\\Value1", 3, "REG_BINARY");

WSHShell.Popup("Delete value HKCU\\MyRegKey\\Entry\\Value1");
WSHShell.RegDelete("HKCU\\MyRegKey\\Entry\\Value1");

WSHShell.Popup("Delete key HKCU\\MyRegKey\\Entry");
WSHShell.RegDelete("HKCU\\MyRegKey\\Entry\\");

WSHShell.Popup("Delete key HKCU\\MyRegKey");
WSHShell.RegDelete("HKCU\\MyRegKey\\");

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
