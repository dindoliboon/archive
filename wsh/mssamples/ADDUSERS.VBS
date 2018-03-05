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
'This script is adds users from the Windows NT DS
'via ADSI. The script reads an EXCEL spreadsheet that contains a page 
'of users to add.  
'
'The sample uses the directory root "LDAP://DC=ArcadiaBay,DC=Com,O=Internet"
'Change the directory path in the EXCEL spreadsheet to match your DS
'before running this sample.
'
'
'
'To add users, run ADDUSERS.VBS with %windir%\"Your Samples Directory Here"\AddUsers.XLS.
'To Delete users, run DELUSERS.VBS with %windir%\"Your Samples Directory Here"\DelUsers.XLS.


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
       TextXL = InputBox("This scripts reads an Excel spreadsheet and adds" & _
       "users from the Windows NT DS via ADSI." & CRLF & CRLF & _
       "Before starting, change the DS root in the EXCEL spreadsheet to match " & _
       "your DS." & CRLF & CRLF & _
       "Type in the path of a file containing users to add or delete" & CRLF & CRLF & _
       "Sample Add User file: ADDUSERS.XLS" & CRLF & _
       "Sample Delete User file: DELUSERS.XLS" & CRLF)
    'Else file containing users is the first argument
    Else
      TextXL = oArgs.item(0)
    End If

    If TextXL = "" Then
       WScript.Echo "No input file provided. Stopping the script now."
       WScript.Quit(1)
    End If

    'We will use ou to control loop, so set initial value to null
    ou = ""
   
    'Start EXCEL and display it to the user
    Set oXL = WScript.CreateObject("EXCEL.application")
    oXL.Visible = True

    'Open the workbook passed in the command line
    oXL.workbooks.open TextXL

    'Activate the Add page 
    oXL.sheets("Add").Activate

    'Put the cursor in the starting cell and read the DS root
    oXL.ActiveSheet.range("A2").Activate ' this cell has the DS root in it

    'Show it to the user
    'WScript.Echo  oXL.activecell.Value
  
    'This is the starting point in the ds
    root = oXL.activecell.Value

    'Step to the next row
    oXL.activecell.offset(1, 0).Activate

    'Until we run out of rows
    Do While oXL.activecell.Value <> ""
      
        'if the requested OU is a new one...
        If oXL.activecell.Value <> ou Then
            'Pick up the OU name...
            ou = oXL.activecell.Value

            'Compose the ADSI path...
            s = "LDAP://" + ou+"," + root

            'Show it to the user...
	    WScript.Echo s

            'And get the object
            Set c = GetObject(s)
        End If

        'Compose the user common name name from first and last names...
        uname = "CN=" + oXL.activecell.offset(0, 1).Value + " " + oXL.activecell.offset(0, 2).Value

        'Create the new user object...
        Set u = c.Create("user", uname)

        'Set the properties of the new user
        u.Put "givenName", oXL.activecell.offset(0, 1).Value 'givenName
        u.Put "sn", oXL.activecell.offset(0, 2).Value 'sn
        u.Put "mail", oXL.activecell.offset(0, 3).Value 'Email
        u.Put "sAMAccountName", oXL.activecell.offset(0, 4).Value  'Sam Acct
        u.Put "telephoneNumber", oXL.activecell.offset(0, 5).Value  'Phone

        'Enable the account, must change pw @ logon
        u.Put "userAccountControl",16 

        '...and update the DS
        u.SetInfo

        'Done with this object, discard it
        Set u = Nothing

        'Step to the next user...
        oXL.activecell.offset(1, 0).Activate   'Next row
    Loop


    'Done.  close excel spreadsheet
    oXL.application.quit
