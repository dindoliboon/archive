Option Explicit

Type POINTAPI
    X As Integer
    Y As Integer
End Type

Declare Function GetSysColor Lib "user" (ByVal nIndex As Integer) As Long
Declare Function GetVersion Lib "kernel" () As Long
Declare Sub GetCursorPos Lib "user" (lpPoint As POINTAPI)
Declare Function BitBlt Lib "gdi" (ByVal srchDC As Integer, ByVal srcX As Integer, ByVal srcY As Integer, ByVal srcW As Integer, ByVal srcH As Integer, ByVal desthDC As Integer, ByVal destX As Integer, ByVal destY As Integer, ByVal op As Long) As Integer

' used by the TransBlit function
Type BITMAP
    bmType As Integer
    bmWidth As Integer
    bmHeight As Integer
    bmWidthBytes As Integer
    bmPlanes As String * 1
    bmBitsPixel As String * 1
    bmBits As Long
End Type

'Declare Function BitBlt Lib "gdi" (ByVal srchDC As Integer, ByVal srcX As Integer, ByVal srcY As Integer, ByVal srcW As Integer, ByVal srcH As Integer, ByVal desthDC As Integer, ByVal destX As Integer, ByVal destY As Integer, ByVal op As Long) As Integer
Declare Function SetBkColor Lib "gdi" (ByVal hDC As Integer, ByVal cColor As Long) As Long
Declare Function CreateCompatibleDC Lib "gdi" (ByVal hDC As Integer) As Integer
Declare Function DeleteDC Lib "gdi" (ByVal hDC As Integer) As Integer
Declare Function CreateBitmap Lib "gdi" (ByVal nWidth As Integer, ByVal nHeight As Integer, ByVal cbPlanes As Integer, ByVal cbBits As Integer, lpvBits As Any) As Integer
Declare Function CreateCompatibleBitmap Lib "gdi" (ByVal hDC As Integer, ByVal nWidth As Integer, ByVal nHeight As Integer) As Integer
Declare Function SelectObject Lib "gdi" (ByVal hDC As Integer, ByVal hObject As Integer) As Integer
Declare Function DeleteObject Lib "gdi" (ByVal hObject As Integer) As Integer
Declare Function GetObj Lib "gdi" Alias "GetObject" (ByVal hObject As Integer, ByVal nCount As Integer, bmp As Any) As Integer

Sub ChangeBitmapColours (picKeep As PictureBox, picScratch As PictureBox)

    ' using two Picture Boxes, copy the first picture (which was created using shades of grey)
    ' converting first one colour to the actual system 3D colours on this machine
    
    Const COLOR_BTNHIGHLIGHT = 20
    Const COLOR_BTNSHADOW = 16
    Const COLOR_BTNTEXT = 18
    Const COLOR_BTNFACE = 15
    
    Dim iScratchWidth As Integer
    Dim iScratchHeight As Integer
    Dim iScratchRedraw As Integer
    Dim lScratchBackColour As Long
    Dim iKeepWidth As Integer
    Dim iKeepHeight As Integer

    On Error Resume Next

    iScratchWidth = picScratch.Width
    iScratchHeight = picScratch.Height
    iScratchRedraw = picScratch.AutoRedraw
    lScratchBackColour = picScratch.BackColor
    iKeepWidth = picKeep.Width
    iKeepHeight = picKeep.Height

    picScratch.Width = picKeep.Width
    picScratch.Height = picKeep.Height
    
    picScratch.AutoRedraw = True

    ' change bright white to the button highlight colour
    picScratch.BackColor = GetSysColor(COLOR_BTNHIGHLIGHT)
    Call TransBlit(picScratch, picKeep, 0, 0, QBColor(15))
    picKeep.Picture = picScratch.Image
    ' change light grey to the button face colour
    picScratch.BackColor = GetSysColor(COLOR_BTNFACE)
    Call TransBlit(picScratch, picKeep, 0, 0, QBColor(7))
    picKeep.Picture = picScratch.Image
    ' change dark grey to the button shadow colour
    picScratch.BackColor = GetSysColor(COLOR_BTNSHADOW)
    Call TransBlit(picScratch, picKeep, 0, 0, QBColor(8))
    picKeep.Picture = picScratch.Image
    ' change black to the button text colour
    picScratch.BackColor = GetSysColor(COLOR_BTNTEXT)
    Call TransBlit(picScratch, picKeep, 0, 0, QBColor(0))
    picKeep.Picture = picScratch.Image
    
    picScratch.BackColor = lScratchBackColour
    
    picScratch.Width = iScratchWidth
    picScratch.Height = iScratchHeight
    picScratch.AutoRedraw = iScratchRedraw
    picKeep.Width = iKeepWidth
    picKeep.Height = iKeepHeight

End Sub

Function DrawCoolBar (ByVal MouseButton As Integer, ByVal MouseX As Single, ByVal MouseY As Single) As Integer

    ' this is the main routine, for drawing the CoolBar, this routine will work out
    ' from the co-ords passed in which button the mouse is over, and will redraw the
    ' bar as necessary in order to raise or lower the buttons, this should be called
    ' from the MouseMove, MouseDown and MouseUp events, it should also be called from
    ' the Resize event of the CoolBar PictureBox, since we will have to redraw the bar
    ' if the form gets resized

    ' variables to hold the Form and the PictureBoxes
    Dim frm As form
    Dim pic As PictureBox
    Dim picGlyphs As PictureBox

    ' set the Form and PictureBox controls to use
    Set frm = frmCool
    Set pic = frmCool.picCoolBar
    Set picGlyphs = frmCool.picSourceBitmaps

    ' variables to hold the drawing colours - which we get from GetSysColor()
    Dim lHilightColour As Long
    Dim lShadowColour As Long
    Dim lTextColour As Long
    
    ' the offset from the top left corner of the PictureBox to the top left corner of the
    ' first button
    Dim iButtonXOffset As Integer
    Dim iButtonYOffset As Integer
    ' the size of the buttons - they are all the same size
    Dim iButtonWidth As Integer
    Dim iButtonHeight As Integer
    
    Dim iBarHeight As Integer
    Dim iBarStyle As Integer

    ' the number of buttons, and the text to draw on each - keep the text short, and make
    ' sure the buttons are wide enough to show the text
    Dim iMaxButtons As Integer
    Dim fShowText As Integer
    Dim sButtonText() As String
    Dim fButtonEnabled() As Integer

    Dim iGlyphWidth As Integer
    Dim iGlyphHeight As Integer
    Dim iGlyphUpXOffset As Integer
    Dim iGlyphUpYOffset As Integer
    Dim iGlyphDownXOffset As Integer
    Dim iGlyphDownYOffset As Integer
    Dim iGlyphVertOffset As Integer
    Dim iTextVertOffset As Integer

    ' working variables to hold the x and y co-ords of the graphic and the text when redrawing each button
    Dim iGlyphLeft As Integer
    Dim iGlyphTop As Integer
    Dim iTextLeft As Integer
    Dim iTextTop As Integer

    ' a working variable to hold the button the mouse is over - or 0 if it isn't over any
    ' this is also returned as the result of the function, and that value can be tested for
    ' in the mouse up event which is where the mouse click code should go or in the mouse
    ' over code if you want to update the status bar
    Dim iSelectedButton As Integer
    ' used as a counter
    Dim iButtonCount As Integer
    ' working variables to hold the co-ords that each button will be drawn at
    Dim iLeft As Integer
    Dim iTop As Integer
    Dim iRight As Integer
    Dim iBottom As Integer
    
    Dim iRet As Integer

    Static iLastSelectedButton As Integer
    Static iLastButtonState As Integer

    ' API constants - stored as locals to keep all the code together
    Const COLOR_BTNHIGHLIGHT = 20
    Const COLOR_BTNSHADOW = 16
    Const COLOR_BTNTEXT = 18
    Const COLOR_BTNFACE = 15
    Const SRCCOPY = &HCC0020

    Const BAR3DNONE = 0
    Const BAR3DCUSTOM = 1
    Const BAR3DRAISED = 2
    Const BAR3DLOWERED = 3

    ' the colours to use for drawing
    lHilightColour = GetSysColor(COLOR_BTNHIGHLIGHT)
    lShadowColour = GetSysColor(COLOR_BTNSHADOW)
    lTextColour = GetSysColor(COLOR_BTNTEXT)
    
    ' set up all of the local variables
    iButtonXOffset = 6
    iButtonYOffset = 4
    iMaxButtons = 6
    iBarStyle = BAR3DCUSTOM
    fShowText = False
    ReDim Preserve sButtonText(iMaxButtons)
    ReDim Preserve fButtonEnabled(iMaxButtons)
    sButtonText(1) = "Print Page"
    sButtonText(2) = "Print"
    sButtonText(3) = "First"
    sButtonText(4) = "Prev"
    sButtonText(5) = "Next"
    sButtonText(6) = "Last"
    fButtonEnabled(1) = frm.mnuFilePrintPage.Enabled
    fButtonEnabled(2) = frm.mnuFilePrintAll.Enabled
    fButtonEnabled(3) = frm.mnuNavFirst.Enabled
    fButtonEnabled(4) = frm.mnuNavPrev.Enabled
    fButtonEnabled(5) = frm.mnuNavNext.Enabled
    fButtonEnabled(6) = frm.mnuNavLast.Enabled
    
    ' this dimensions of each bitmap in the block of bitmaps
    iGlyphWidth = 20
    iGlyphHeight = 20
    ' the offset from the normal position to draw the bitmap when the button is raised or lowered
    iGlyphUpXOffset = 0
    iGlyphUpYOffset = 0
    iGlyphDownXOffset = 1
    iGlyphDownYOffset = 1
    ' the offset from the top of the button to the top of the bitmap
    iGlyphVertOffset = 4
    ' the offset from the bottom of the bitmap to the top of the text
    iTextVertOffset = 2

    ' draw the buttons with text underneath
    fShowText = True
    iButtonWidth = 60
    iButtonHeight = 40
    ' draw the buttons without text
    'fShowText = False
    'iButtonWidth = 28
    'iButtonHeight = 28

    ' ensure that the controls are set up the way we want them to be
    If pic.BorderStyle <> 0 Then
        pic.BorderStyle = 0
    End If
    If pic.AutoRedraw <> True Then
        pic.AutoRedraw = True
    End If
    If pic.FontBold <> False Then
        pic.FontBold = False
    End If
    If pic.ScaleMode <> 3 Then
        pic.ScaleMode = 3
    End If
    If pic.Parent.ScaleMode <> 3 Then
        pic.Parent.ScaleMode = 3
    End If
    If picGlyphs.AutoRedraw <> True Then
        picGlyphs.AutoRedraw = True
    End If
    If picGlyphs.Visible <> False Then
        picGlyphs.Visible = False
    End If
    If pic.ForeColor <> lTextColour Then
        pic.ForeColor = lTextColour
    End If
    
    ' make sure the Picture Box is big enough
    iBarHeight = iButtonHeight + (iButtonYOffset * 2)
    If pic.Height <> iBarHeight + 1 Then
        pic.Height = iBarHeight + 1
    End If

    ' determine if the mouse is over one of the buttons
    iSelectedButton = 0
    For iButtonCount = 1 To iMaxButtons
        iLeft = iButtonXOffset + ((iButtonCount - 1) * iButtonWidth)
        iTop = iButtonYOffset
        iRight = iLeft + iButtonWidth
        iBottom = iTop + iButtonHeight
        If MouseX >= iLeft And MouseY >= iTop And MouseX <= iRight And MouseY <= iBottom Then
            ' we are over one of the buttons
            iSelectedButton = iButtonCount
        End If
    Next

    ' start drawing - erase the control and redraw the 3D lines
    If MouseButton = 0 And MouseX = 0 And MouseY = 0 Then
        ' sentinel values - erase and redraw the control
        ' when calling this from the Resize event and the timer it should be called with
        ' these sentinel values to force a complete redraw
        Select Case iBarStyle
        Case BAR3DCUSTOM:
            pic.Line (0, 0)-(pic.ScaleWidth, pic.ScaleHeight), pic.BackColor, BF
            pic.Line (0, 0)-(pic.ScaleWidth, 0), lShadowColour, B
            pic.Line (0, 1)-(pic.ScaleWidth, 1), lHilightColour, B
            pic.Line (0, iBarHeight - 2)-(pic.ScaleWidth, iBarHeight - 2), lShadowColour, B
            pic.Line (0, iBarHeight - 1)-(pic.ScaleWidth, iBarHeight - 1), lHilightColour, B
        Case BAR3DRAISED:
            pic.Line (0, 0)-(pic.ScaleWidth, pic.ScaleHeight), pic.BackColor, BF
            pic.Line (0, 0)-(pic.ScaleWidth, 0), lHilightColour, B
            pic.Line (0, iBarHeight - 1)-(pic.ScaleWidth, iBarHeight - 1), lShadowColour, B
        Case BAR3DLOWERED:
            pic.Line (0, 0)-(pic.ScaleWidth, pic.ScaleHeight), pic.BackColor, BF
            pic.Line (0, 0)-(pic.ScaleWidth, 0), lShadowColour, B
            pic.Line (0, iBarHeight - 1)-(pic.ScaleWidth, iBarHeight - 1), lHilightColour, B
        Case Else:
            ' no 3D effects
            pic.Line (0, 0)-(pic.ScaleWidth, pic.ScaleHeight), pic.BackColor, BF
        End Select
    Else
        ' NOTE: we dont want to even test for this if the sentinel values are passed in
        ' ALSO: there is no point is redrawing anything if nothing has changed since last time
        If iSelectedButton = iLastSelectedButton And MouseButton = iLastButtonState Then
            ' no change from last time
            Exit Function
        Else
            iLastSelectedButton = iSelectedButton
            iLastButtonState = MouseButton
        End If
    End If

    ' draw the glyphs and the text
    For iButtonCount = 1 To iMaxButtons
            
        iLeft = iButtonXOffset + ((iButtonCount - 1) * iButtonWidth)
        iTop = iButtonYOffset
        iRight = iLeft + iButtonWidth
        iBottom = iTop + iButtonHeight
        pic.Line (iLeft, iTop)-(iRight, iBottom), pic.BackColor, B
            
        iGlyphLeft = iLeft + ((iButtonWidth - iGlyphWidth) / 2)
        iGlyphTop = iTop + iGlyphVertOffset
            
        ' if the mouse is over one of the buttons then draw it in the up or down position
        ' depending on the MouseButton state otherwise draw it in the flat position
        If iButtonCount = iSelectedButton And fButtonEnabled(iButtonCount) = True Then
            ' adjust the Glyph offset
            ' this button will be drawn in either the up or down position
            If MouseButton <> 1 Then
                iGlyphLeft = iGlyphLeft + iGlyphUpXOffset
                iGlyphTop = iGlyphTop + iGlyphUpYOffset
            Else
                iGlyphLeft = iGlyphLeft + iGlyphDownXOffset
                iGlyphTop = iGlyphTop + iGlyphDownYOffset
            End If
        End If

        ' erase the client area of the button then blit the new glyph
        pic.Line (iLeft + 1, iTop + 1)-(iRight - 1, iBottom - 1), pic.BackColor, BF
        If fButtonEnabled(iButtonCount) = True Then
            If iButtonCount <> iSelectedButton Then
                ' blit the glyph from the first row - enabled but not selected button
                iRet = BitBlt(pic.hDC, iGlyphLeft, iGlyphTop, iGlyphWidth, iGlyphHeight, picGlyphs.hDC, iGlyphWidth * (iButtonCount - 1), 0, SRCCOPY)
            Else
                ' blit the glyph from the second row - selected button
                iRet = BitBlt(pic.hDC, iGlyphLeft, iGlyphTop, iGlyphWidth, iGlyphHeight, picGlyphs.hDC, iGlyphWidth * (iButtonCount - 1), iGlyphHeight, SRCCOPY)
            End If
        Else
            ' blit the glyph from the third row - disabled button
            iRet = BitBlt(pic.hDC, iGlyphLeft, iGlyphTop, iGlyphWidth, iGlyphHeight, picGlyphs.hDC, iGlyphWidth * (iButtonCount - 1), iGlyphHeight * 2, SRCCOPY)
        End If

        If fShowText = True Then
            ' draw the text
            iTextLeft = iLeft + ((iButtonWidth - pic.TextWidth(sButtonText(iButtonCount))) / 2)
            iTextTop = iGlyphTop + iGlyphHeight + iTextVertOffset
            If iButtonCount = iSelectedButton And fButtonEnabled(iButtonCount) = True Then
                ' adjust the TextOffset
                ' this button will be drawn in either the up or down position
                If MouseButton <> 1 Then
                    iTextLeft = iTextLeft + iGlyphUpXOffset
                Else
                    iTextLeft = iTextLeft + iGlyphDownXOffset
                End If
            End If
        
            If fButtonEnabled(iButtonCount) = True Then
                ' draw the text enabled
                pic.CurrentX = iTextLeft
                pic.CurrentY = iTextTop
                pic.Print sButtonText(iButtonCount)
            Else
                ' draw the text disabled
                pic.CurrentX = iTextLeft
                pic.CurrentY = iTextTop
                pic.ForeColor = lHilightColour
                pic.Print sButtonText(iButtonCount)
    
                pic.CurrentX = iTextLeft - 1
                pic.CurrentY = iTextTop - 1
                pic.ForeColor = lShadowColour
                pic.Print sButtonText(iButtonCount)
                
                pic.ForeColor = lTextColour
            End If
        End If
    Next

    ' finally draw the selected button border - unless it is disabled
    If iSelectedButton > 0 And fButtonEnabled(iSelectedButton) = True Then
        iLeft = iButtonXOffset + ((iSelectedButton - 1) * iButtonWidth)
        iTop = iButtonYOffset
        iRight = iLeft + iButtonWidth
        iBottom = iTop + iButtonHeight
        If MouseButton <> 1 Then
            ' draw the button up
            pic.Line (iLeft, iTop)-(iRight, iBottom), lHilightColour, B
            pic.Line (iLeft, iBottom)-(iRight, iBottom), lShadowColour, B
            pic.Line (iRight, iTop)-(iRight, iBottom), lShadowColour, B
        Else
            ' draw the button down
            pic.Line (iLeft, iTop)-(iRight, iBottom), lShadowColour, B
            pic.Line (iLeft, iBottom)-(iRight, iBottom), lHilightColour, B
            pic.Line (iRight, iTop)-(iRight, iBottom), lHilightColour, B
        End If
    End If
    
    ' set the return value - this should be looked for in the MouseUp event to
    ' trigger code, or the MouseMove event if you want to update a Status Bar
    If iSelectedButton > 0 And fButtonEnabled(iSelectedButton) = True Then
        DrawCoolBar = iSelectedButton
    End If

End Function

Sub TransBlit (picDest As PictureBox, picSrc As PictureBox, ByVal destX As Integer, ByVal destY As Integer, ByVal TransColor As Long)

    ' this was cribbed from MSDN - it will allow you to draw transparent bitmaps
    ' I'm using it to change the standard 3D colours (shades of grey) to the actual
    ' system colours being used

    ' used by the TransBlit function
    'Type BITMAP
    '    bmType As Integer
    '    bmWidth As Integer
    '    bmHeight As Integer
    '    bmWidthBytes As Integer
    '    bmPlanes As String * 1
    '    bmBitsPixel As String * 1
    '    bmBits As Long
    'End Type
    
    'Declare Function BitBlt Lib "gdi" (ByVal srchDC As Integer, ByVal srcX As Integer, ByVal srcY As Integer, ByVal srcW As Integer, ByVal srcH As Integer, ByVal desthDC As Integer, ByVal destX As Integer, ByVal destY As Integer, ByVal op As Long) As Integer
    'Declare Function SetBkColor Lib "gdi" (ByVal hDC As Integer, ByVal cColor As Long) As Long
    'Declare Function CreateCompatibleDC Lib "gdi" (ByVal hDC As Integer) As Integer
    'Declare Function DeleteDC Lib "gdi" (ByVal hDC As Integer) As Integer
    'Declare Function CreateBitmap Lib "gdi" (ByVal nWidth As Integer, ByVal nHeight As Integer, ByVal cbPlanes As Integer, ByVal cbBits As Integer, lpvBits As Any) As Integer
    'Declare Function CreateCompatibleBitmap Lib "gdi" (ByVal hDC As Integer, ByVal nWidth As Integer, ByVal nHeight As Integer) As Integer
    'Declare Function SelectObject Lib "gdi" (ByVal hDC As Integer, ByVal hObject As Integer) As Integer
    'Declare Function DeleteObject Lib "gdi" (ByVal hObject As Integer) As Integer
    'Declare Function GetObj Lib "gdi" Alias "GetObject" (ByVal hObject As Integer, ByVal nCount As Integer, bmp As Any) As Integer

    Const SRCCOPY = &HCC0020
    Const SRCAND = &H8800C6
    Const SRCPAINT = &HEE0086
    Const NOTSRCCOPY = &H330008
    
    Const PIXEL = 3

    Dim destScale As Integer
    Dim srcDC As Integer  'source bitmap (color)
    Dim saveDC As Integer 'backup copy of source bitmap
    Dim maskDC As Integer 'mask bitmap (monochrome)
    Dim invDC As Integer  'inverse of mask bitmap (monochrome)
    Dim resultDC As Integer 'combination of source bitmap & background
    Dim bmp As BITMAP 'description of the source bitmap
    Dim hResultBmp As Integer 'Bitmap combination of source & background
    Dim hSaveBmp As Integer 'Bitmap stores backup copy of source bitmap
    Dim hMaskBmp As Integer 'Bitmap stores mask (monochrome)
    Dim hInvBmp As Integer  'Bitmap holds inverse of mask (monochrome)
    Dim hPrevBmp As Integer 'Bitmap holds previous bitmap selected in DC
    Dim hSrcPrevBmp As Integer  'Holds previous bitmap in source DC
    Dim hSavePrevBmp As Integer 'Holds previous bitmap in saved DC
    Dim hDestPrevBmp As Integer 'Holds previous bitmap in destination DC
    Dim hMaskPrevBmp As Integer 'Holds previous bitmap in the mask DC
    Dim hInvPrevBmp As Integer 'Holds previous bitmap in inverted mask DC
    Dim OrigColor As Long 'Holds original background color from source DC
    Dim Success As Integer 'Stores result of call to Windows API
    
    destScale = picDest.ScaleMode
    picDest.ScaleMode = PIXEL

    'Retrieve bitmap to get width (bmp.bmWidth) & height (bmp.bmHeight)
    Success = GetObj(picSrc.Picture, Len(bmp), bmp)
    srcDC = CreateCompatibleDC(picDest.hDC)
    saveDC = CreateCompatibleDC(picDest.hDC)
    maskDC = CreateCompatibleDC(picDest.hDC)
    invDC = CreateCompatibleDC(picDest.hDC)
    resultDC = CreateCompatibleDC(picDest.hDC)

    'Create monochrome bitmaps for the mask-related bitmaps:
    hMaskBmp = CreateBitmap(bmp.bmWidth, bmp.bmHeight, 1, 1, ByVal 0&)
    hInvBmp = CreateBitmap(bmp.bmWidth, bmp.bmHeight, 1, 1, ByVal 0&)
    
    'Create color bitmaps for final result & stored copy of source
    hResultBmp = CreateCompatibleBitmap(picDest.hDC, bmp.bmWidth, bmp.bmHeight)
    hSaveBmp = CreateCompatibleBitmap(picDest.hDC, bmp.bmWidth, bmp.bmHeight)
    hSrcPrevBmp = SelectObject(srcDC, picSrc.Picture)
    hSavePrevBmp = SelectObject(saveDC, hSaveBmp)
    hMaskPrevBmp = SelectObject(maskDC, hMaskBmp)
    hInvPrevBmp = SelectObject(invDC, hInvBmp)
    hDestPrevBmp = SelectObject(resultDC, hResultBmp)
    Success = BitBlt(saveDC, 0, 0, bmp.bmWidth, bmp.bmHeight, srcDC, 0, 0, SRCCOPY)
    
    'Create mask: set background color of source to transparent color.
    OrigColor = SetBkColor(srcDC, TransColor)
    Success = BitBlt(maskDC, 0, 0, bmp.bmWidth, bmp.bmHeight, srcDC, 0, 0, SRCCOPY)
    TransColor = SetBkColor(srcDC, OrigColor)
        
    'Create inverse of mask to AND w/ source & combine w/ background.
    Success = BitBlt(invDC, 0, 0, bmp.bmWidth, bmp.bmHeight, maskDC, 0, 0, NOTSRCCOPY)
    'Copy background bitmap to result & create final transparent bitmap
    Success = BitBlt(resultDC, 0, 0, bmp.bmWidth, bmp.bmHeight, picDest.hDC, destX, destY, SRCCOPY)
    'AND mask bitmap w/ result DC to punch hole in the background by
    'painting black area for non-transparent portion of source bitmap.
    Success = BitBlt(resultDC, 0, 0, bmp.bmWidth, bmp.bmHeight, maskDC, 0, 0, SRCAND)
    'AND inverse mask w/ source bitmap to turn off bits associated
    'with transparent area of source bitmap by making it black.
    Success = BitBlt(srcDC, 0, 0, bmp.bmWidth, bmp.bmHeight, invDC, 0, 0, SRCAND)
    'XOR result w/ source bitmap to make background show through.
    Success = BitBlt(resultDC, 0, 0, bmp.bmWidth, bmp.bmHeight, srcDC, 0, 0, SRCPAINT)
    Success = BitBlt(picDest.hDC, destX, destY, bmp.bmWidth, bmp.bmHeight, resultDC, 0, 0, SRCCOPY)
    Success = BitBlt(srcDC, 0, 0, bmp.bmWidth, bmp.bmHeight, saveDC, 0, 0, SRCCOPY)
    
    hPrevBmp = SelectObject(srcDC, hSrcPrevBmp)
    hPrevBmp = SelectObject(saveDC, hSavePrevBmp)
    hPrevBmp = SelectObject(resultDC, hDestPrevBmp)
    hPrevBmp = SelectObject(maskDC, hMaskPrevBmp)
    hPrevBmp = SelectObject(invDC, hInvPrevBmp)
    
    Success = DeleteObject(hSaveBmp)
    Success = DeleteObject(hMaskBmp)
    Success = DeleteObject(hInvBmp)
    Success = DeleteObject(hResultBmp)
    Success = DeleteDC(srcDC)
    Success = DeleteDC(saveDC)
    Success = DeleteDC(invDC)
    Success = DeleteDC(maskDC)
    Success = DeleteDC(resultDC)
    picDest.ScaleMode = destScale
    
End Sub

