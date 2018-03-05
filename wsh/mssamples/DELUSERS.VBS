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
'
'This script deletes users from the Windows NT DS
'via ADSI. The script reads an EXCEL spreadsheet (DelUsers.xls) that contains a page 
'of users to delete.
'
'The sample uses the directory root "LDAP://DC=ArcadiaBay,DC=Com,O=Internet
'Change the directory path in the EXCEL spreadsheet to match your DS
'before running this sample.
'
''To add users, run ADDUSERS.VBS with %windir%\"Your Samples Directory here"\AddUsers.XLS.
''To Delete users, run DELUSERS.VBS with %windir%\"Your Samples Directory here"\DelUsers.XLS.


    Dim oXL
    Dim u
    Dim c
    Dim root
    Dim ou
    Dim TextXL
    Dim CRLF
    dim oArgs

    
    'Get the command line args
    set oArgs=wscript.arguments

    CRLF = Chr(13) & Chr(10)
  
    'If no command line arguments provided, prompt for file containing users to add/delete
    If oArgs.Count = 0 Then
       TextXL = InputBox("This scripts reads an Excel spread sheet and deletes " & _
       "users from the Windows NT DS via ADSI." & CRLF & CRLF & _
       "Before starting, change the DS root in the EXCEL spreadsheet to match " & _
       "your DS."& CRLF & CRLF & _
       "Type in the path of a file containing users to add or delete" & CRLF & CRLF & _
       "Sample Add User file: ADDUSERS.XLS" & CRLF & _
       "Sample Delete User file: DELUSERS.XLS" & CRLF)
    'Else file containing users is the first argument
    Else
      TextXL = oArgs.item(0)
    End If

    If TextXL = "" Then
       WScript.Echo "No input file provided.  stopping script now."
       WScript.Quit(1)
    End If

    'We will use ou to control loop, so set initial value to null
    ou = ""
   
    'Start EXCEL and display it to the user
    Set oXL = WScript.CreateObject("EXCEL.application")
    oXL.Visible = True

    'Open the workbook passed in the command line
    oXL.workbooks.open TextXL


    'Now do deletes
    '
    'Activate the Delete page
    oXL.sheets("Delete").Activate

    'Set the cell cursor to the DS root
    oXL.ActiveSheet.range("A2").Activate ' this cell has the DS root in it

    'Show it to the user
    'WScript.Echo oXL.activecell.Value

    root = oXL.activecell.Value
    oXL.activecell.offset(1, 0).Activate

    'Until we run out of rows...
    Do While oXL.activecell.Value <> ""

	'If the requested OU is different
        If oXL.activecell.Value <> ou Then
            ou = oXL.activecell.Value

	    'Compose the new ou path...
            s = "LDAP://" + OU + "," + root

            'Show it to the user
	    WScript.Echo s

            'Get the new container
            Set c = GetObject(s)
        End If

        'Compose the user name
        uname = "CN=" + oXL.activecell.offset(0, 1).Value + " " + oXL.activecell.offset(0, 2).Value
	' wscript.echo uname
	'Delete the user
        Call c.Delete("user", uname)
        oXL.activecell.offset(1, 0).Activate ' next row
    Loop

    'Done.  close excel spreadsheet
    oXL.application.quit
