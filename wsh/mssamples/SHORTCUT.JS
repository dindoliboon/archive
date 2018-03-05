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


// This sample demonstrates how to use the WSHShell object to create a shortcut
// on the desktop.
var vbOKCancel = 1;
var vbInformation = 64;
var vbCancel = 2;

var L_Welcome_MsgBox_Message_Text   = "This script will create a shortcut to Notepad on your desktop.";
var L_Welcome_MsgBox_Title_Text     = "Windows Scripting Host Sample";
Welcome();

// ********************************************************************************
// *
// * Shortcut related methods.
// *

var WSHShell = WScript.CreateObject("WScript.Shell");


// Read desktop path using WshSpecialFolders object
var DesktopPath = WSHShell.SpecialFolders("Desktop");

// Create a shortcut object on the desktop
var MyShortcut = WSHShell.CreateShortcut(DesktopPath + "\\Shortcut to notepad.lnk");

// Set shortcut object properties and save it
MyShortcut.TargetPath = WSHShell.ExpandEnvironmentStrings("%windir%\\notepad.exe");
MyShortcut.WorkingDirectory = WSHShell.ExpandEnvironmentStrings("%windir%");
MyShortcut.WindowStyle = 4;
MyShortcut.IconLocation = WSHShell.ExpandEnvironmentStrings("%windir%\\notepad.exe, 0");
MyShortcut.Save();

WScript.Echo("A shortcut to Notepad now exists on your Desktop.");

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
