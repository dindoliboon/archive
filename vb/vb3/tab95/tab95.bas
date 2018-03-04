Option Explicit

Const MAXTABS = 20
Type tTAB
    iNumTabs As Integer
    sTabCaption(MAXTABS) As String
    iTabEnabled(MAXTABS) As Integer
End Type

' need routines to ...
' create a tab
' delete a tab
' enable a tab
' disable a tab
' select a tab

Sub AddTab (inTab As tTAB, ByVal sTabCaption As String)

    inTab.
    
End Sub

Sub PaintTab (pic As Control, ByVal iForcedTab%, ByVal X!, ByVal Y!)

    ' this routine can be called in two different ways, it can either be
    ' called with the iForcedTab% parameter set to the number of the tab
    ' which is to be selected - in which case the X! and Y! parameters will
    ' be ignored, or it can be called with the iForcedTab% parameter set to
    ' 0 - in which case the X! and Y! parameters will be used to calculate
    ' which tab, if any, has been selected, the former case is so that we can
    ' programatically select a tab, and so that we can handle the redrawing
    ' if necessary, the latter case is so that this can be called when a
    ' MouseDown event occurs on the PictureBox control

    ' the colours used for text and line drawing
    Const BLACKCOLOUR = &H0
    Const LGREYCOLOUR = &H8000000F
    Const DGREYCOLOUR = &H80000010
    Const WHITECOLOUR = &HFFFFFF
    ' - this could be changed to the correct buttonhighlight colour by calling GetSystemColor

    ' sizes and offsets
    Dim iLineWidth%
    Dim iTabHeight%
    Dim iTextBorder%
    Dim iTabExtra%
    Dim iTabLeftOffset%
    Dim iTabGap%

    Dim iCount%
    Dim iTab%
    Dim iTabLeft%
    Dim iTabWidth%
    Dim iTabRight%
    Dim iTabTop%
    Dim iTabBottom%
    Dim iSelectedTab%

' MODIFY THIS BLOCK TO SUIT YOUR REQUIREMENTS
' the text is held in an array of string variables - sTabText

    ' set up the tabs
    Const NUMTABS = 5
    ReDim sTabText$(NUMTABS)
    sTabText$(1) = "Top Tab"
    sTabText$(2) = "How does it work ?"
    sTabText$(3) = "Limitations"
    sTabText$(4) = "Who did this ?"
    sTabText$(5) = "Why ?"
' ...

    ' set up the size variables
    ' NOTE: By default I leave the ScaleMode set to Twips
    ' this routine will have to be modified to cope with other scale modes
    iLineWidth% = Screen.TwipsPerPixelX
    iTabHeight% = 21 * iLineWidth%
    iTextBorder% = 8 * iLineWidth%
    iTabExtra% = 3 * iLineWidth%
    iTabLeftOffset% = 3 * iLineWidth%
    iTabGap% = 1 * iLineWidth%
    ' changing any of these will change the appearance of the Tab

    ' work out which tab has been selected
    If iForcedTab% = 0 Or iForcedTab% > NUMTABS Then
        ' is this a click in one of the tabs
        ' if not then bomb out
        If Y! > iTabHeight% Or Y! < iTabExtra% Then
            ' a click in the body of the tab - ignore it
            Exit Sub
        End If
    
        iTabRight% = iTabLeftOffset%
        iSelectedTab% = 0
        For iCount% = 1 To NUMTABS
            iTabRight% = iTabRight% + pic.TextWidth(sTabText$(iCount%)) + (iTextBorder% * 2) + iTabGap%
            If X! < iTabRight% Then
                iSelectedTab% = iCount%
                Exit For
            End If
        Next
        If iSelectedTab% = 0 Then
            ' a click in the tab area but after the last tab
            Exit Sub
        End If
    Else
        iSelectedTab% = iForcedTab%
    End If
    pic.Tag = CStr(iSelectedTab%)
    
    ' set Border Style to 0,
    ' I leave it at 1 so that I can see it at design time
    If pic.BorderStyle <> 0 Then
        ' this triggers a refresh - so only do it if necessary
        pic.BorderStyle = 0
    End If
    If pic.FontBold <> False Then
        ' the default for a PictureBox control in VB3 is for FontBold to
        ' be True, Windows95 uses non-bold
        pic.FontBold = False
    End If
    If pic.BackColor <> LGREYCOLOUR Then
        ' the default is for this to be the default window colour
        pic.BackColor = LGREYCOLOUR
    End If

    ' erase the old Tab - by drawing a grey rectangle over the entire area of it
    pic.Line (0, 0)-(pic.Width, pic.Height), LGREYCOLOUR, BF

    ' draw the tabs - left, right, top, text
    ' draw them in reverse order - incase they overlap
    iTabTop% = iTabExtra%
    For iCount% = NUMTABS To 1 Step -1
        ' find the left co-ord by working out the width of all previous tabs
        If iCount% <> iSelectedTab% Then
            iTabLeft% = iTabLeftOffset%
            If iCount% > 1 Then
                For iTab% = 1 To iCount% - 1
                    iTabWidth% = pic.TextWidth(sTabText$(iTab%)) + (iTextBorder% * 2) + iTabGap%
                    iTabLeft% = iTabLeft% + iTabWidth%
                Next
            End If
            iTabWidth% = pic.TextWidth(sTabText$(iCount%)) + (iTextBorder% * 2)
            iTabRight% = iTabLeft% + iTabWidth%
            pic.Line (iTabLeft% + iLineWidth%, iTabHeight%)-(iTabLeft% + iLineWidth%, iTabExtra%), WHITECOLOUR
            pic.Line (iTabLeft% + (iLineWidth% * 2), iTabExtra%)-(iTabRight% - iLineWidth%, iTabExtra%), WHITECOLOUR
            pic.Line (iTabRight% - iLineWidth%, iTabHeight%)-(iTabRight% - iLineWidth%, iTabExtra%), DGREYCOLOUR
            pic.Line (iTabRight%, iTabHeight%)-(iTabRight%, iTabExtra% + iLineWidth%), BLACKCOLOUR
            ' draw the text
            pic.CurrentX = iTabLeft% + ((iTabWidth% - pic.TextWidth(sTabText$(iCount%))) / 2)
            pic.CurrentY = ((iTabExtra% - iLineWidth% + (iTabHeight% - pic.TextHeight(sTabText$(iCount%))) / 2))
            pic.ForeColor = BLACKCOLOUR
            pic.Print sTabText$(iCount%)
        Else
            ' this is the selected tab - dont bother drawing it - we'll do that last
        End If
    Next
    
    ' draw the border - top, left, bottom, right
    pic.Line (iLineWidth%, iTabHeight%)-(pic.Width, iTabHeight%), WHITECOLOUR
    pic.Line (0, iTabHeight%)-(0, pic.Height), WHITECOLOUR
    pic.Line (0, pic.Height - iLineWidth%)-(pic.Width, pic.Height - iLineWidth%), BLACKCOLOUR
    pic.Line (pic.Width - iLineWidth%, iTabHeight%)-(pic.Width - iLineWidth%, pic.Height - iLineWidth%), BLACKCOLOUR
    pic.Line (iLineWidth%, pic.Height - (iLineWidth% * 2))-(pic.Width - iLineWidth%, pic.Height - (iLineWidth% * 2)), DGREYCOLOUR
    pic.Line (pic.Width - (iLineWidth% * 2), iTabHeight% + iLineWidth%)-(pic.Width - (iLineWidth% * 2), pic.Height - (iLineWidth% * 2)), DGREYCOLOUR
                              
    ' find the left co-ord by working out the width of all previous tabs
    iTabLeft% = iTabLeftOffset%
    If iSelectedTab% > 1 Then
        For iTab% = 1 To iSelectedTab% - 1
            iTabWidth% = pic.TextWidth(sTabText$(iTab%)) + (iTextBorder% * 2) + iTabGap%
            iTabLeft% = iTabLeft% + iTabWidth%
        Next
    End If
    iTabWidth% = pic.TextWidth(sTabText$(iSelectedTab%)) + (iTextBorder% * 2)
    iTabRight% = iTabLeft% + iTabWidth%
    
    ' adjust the left and right positions by the extra width of the selected tab
    iTabLeft% = iTabLeft% - iTabExtra%
    iTabRight% = iTabRight% + iTabExtra%
    
    ' draw the selected tab - bottom, left, right, top, text
    ' erase the area first
    pic.Line (iTabLeft% + iLineWidth%, iTabTop%)-(iTabRight% - iLineWidth, iTabHeight% + iLineWidth%), LGREYCOLOUR, BF
    pic.Line (iTabLeft%, iTabHeight%)-(iTabLeft%, iLineWidth%), WHITECOLOUR
    pic.Line (iTabLeft% + iLineWidth%, iLineWidth%)-(iTabRight% - iLineWidth%, iLineWidth%), WHITECOLOUR
    pic.Line (iTabRight%, iTabHeight% - iLineWidth%)-(iTabRight%, (iLineWidth% * 2)), BLACKCOLOUR
    pic.Line (iTabRight% - iLineWidth%, iTabHeight%)-(iTabRight% - iLineWidth%, iLineWidth%), DGREYCOLOUR
    ' draw the text
    pic.CurrentX = iTabLeft% + ((iTabWidth% + (iTabExtra% * 2) - pic.TextWidth(sTabText$(iSelectedTab%))) / 2)
    pic.CurrentY = ((iTabHeight% - pic.TextHeight(sTabText$(iSelectedTab%))) / 2)
    pic.ForeColor = BLACKCOLOUR
    pic.Print sTabText$(iSelectedTab%)

' MODIFY THIS CASE STATEMENT TO SUIT YOUR APPLICATION
' in this case I have five tabs, and each tab has a container
' control holding the controls that are to be shown when that
' tab has been selected, I have used five PictureBox controls as
' the containers, I am making the container control for the
' selected tab visible and hiding all of the others - this could
' be done with less code if I had used an array of controls

    ' selected tab specific code
    ' trigger code here to hide and show controls
    ' to imitate a new tab being shown
    Select Case iSelectedTab%
    Case 1:
        picContainer1.Visible = True
        picContainer2.Visible = False
        picContainer3.Visible = False
        picContainer4.Visible = False
        picContainer5.Visible = False
    Case 2:
        picContainer2.Visible = True
        picContainer1.Visible = False
        picContainer3.Visible = False
        picContainer4.Visible = False
        picContainer5.Visible = False
    Case 3:
        picContainer3.Visible = True
        picContainer1.Visible = False
        picContainer2.Visible = False
        picContainer4.Visible = False
        picContainer5.Visible = False
    Case 4:
        picContainer4.Visible = True
        picContainer1.Visible = False
        picContainer2.Visible = False
        picContainer3.Visible = False
        picContainer5.Visible = False
    Case 5:
        picContainer5.Visible = True
        picContainer1.Visible = False
        picContainer2.Visible = False
        picContainer3.Visible = False
        picContainer4.Visible = False
    Case Else
        ' case not supported
        MsgBox "TAB95.FRM:PaintTab - case not supported"
    End Select

End Sub

