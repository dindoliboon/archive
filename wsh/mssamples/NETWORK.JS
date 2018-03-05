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
//
// This sample demonstrates how to use the WSHNetwork object.
// It reads network properties (username and computername), 
// connects, disconnects, and enumerates network drives.

var vbOKOnly = 0;
var vbOKCancel = 1;
var vbYesNo = 4;
var vbQuestion = 32;
var vbInformation = 64;
var vbCancel = 2;
var vbYes = 6;

var L_Welcome_MsgBox_Message_Text   = "This script demonstrates how to use the WSHNetwork object.";
var L_Welcome_MsgBox_Title_Text     = "Windows Scripting Host Sample";
Welcome();

//////////////////////////////////////////////////////////////////////////////////
// 
//  WSH Network Object.
// 

var WSHShell = WScript.CreateObject("WScript.Shell");
var WSHNetwork = WScript.CreateObject("WScript.Network")
var colDrives, SharePoint



function Ask(strAction){
   // This function asks the user whether to perform a specific "Action"
   // and sets a return code or quits script execution depending on the 
   // button that the user presses.  This function is called at various
   // points in the script below.

    var intButton
    intButton = WSHShell.Popup(strAction,
                               0,
                               L_Welcome_MsgBox_Title_Text,
                               vbQuestion + vbYesNo );
    return intButton == vbYes;
}

//////////////////////////////////////////////////////////////////////////////////
// 
//  Show WSHNetwork object properties
// 
// 
WSHShell.Popup("UserDomain\t= " + WSHNetwork.UserDomain  +
               "\r\nUserName\t= " + WSHNetwork.UserName  +
               "\r\nComputerName\t= " + WSHNetwork.ComputerName,
               0,
               "WSHNetwork Properties",
               vbInformation + vbOKOnly );

//////////////////////////////////////////////////////////////////////////////////
// 
//  WSHNetwork.EnumNetworkDrive
// 
// 
//Ask user whether to enumerate network drives
if (Ask("Do you want to enumerate connected network drives?")) {
    //Enumerate network drives into a collection object of type WshCollection
    var colDrives = WSHNetwork.EnumNetworkDrives();

    //If no network drives were enumerated, then inform user, else display 
    //enumerated drives
    if (colDrives.length == 0) {
        WSHShell.Popup("There are no drives to enumerate.",
                       0,
                       L_Welcome_MsgBox_Title_Text,
                       vbInformation + vbOKOnly );
    } else {
        strMsg = "Current network drive connections: \r\n";
        for (i = 0; i < colDrives.length; i += 2) {
            strMsg = strMsg + "\r\n" + colDrives(i) + "\t" + colDrives(i + 1);
        }
        
        WSHShell.Popup(strMsg,
                       0,
                       L_Welcome_MsgBox_Title_Text,
                       vbInformation + vbOKOnly );
    }
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
