Option Explicit

Sub OpenFile ()

   ' always open a short filename as that's what VB3 can handle
   ' with it's file open functions

    Dim fn As Integer
    
    On Error Resume Next

    ' open the selected file
    fn = FreeFile
    Open gShortFilename For Input As fn
    If Err Then
	MsgBox "Can't open file: " & gShortFilename, 48, App.Title
	Exit Sub
    End If

    ' change mousepointer to an hourglass
    screen.MousePointer = 11
    
    ' change form's caption and display new text
    If gIn16BitSystem = True Then
      Form1.Caption = UCase$(gShortFilename)
    Else
      Form1.Caption = UCase$(gLongFilename)
    End If
    Form1.Text1.Text = Input$(LOF(fn), fn)
    Close fn

    ' reset mouse pointer
    screen.MousePointer = 0

End Sub

Sub SaveFileAs ()

   Dim Contents As String
   Dim fn As Integer
   
   ' open the file
   fn = FreeFile
   Open gShortFilename For Output As fn
   
   ' put contents of the text box into a variable
   Contents = Form1.Text1.Text
   
   ' display hourglass
   screen.MousePointer = 11
   
   ' write variable contents to saved file
   Print #fn, Contents
   Close #fn
   
   ' reset the mousepointer
   screen.MousePointer = 0


End Sub

