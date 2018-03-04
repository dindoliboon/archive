'----------------------------------------------------------
'| 3D Routines with Splitter Bars v2.0 - By Daniel Benito |
'----------------------------------------------------------
'
' This file contains a new version of a minute collection of simple
' routines that enable you to paint several kinds of frames around or
' inside controls and forms, adding a 3D effect to your application,
' without the need of .VBX controls or .DLLs.
'
' They were written to cover a basic need, while keeping code
' simple and fast.
'
' The idea of these subroutines is loosely based on a routine called
' Outlines, which is included in the VB 3.0 sample application
' VISDATA.
'
' Also included is DrawOutline, a routine used with my splitter bars.
'
' The author spent a while coding these routines. If you find them useful,
' he would gratefully accept ten bucks (sic), five quid, mil quinientas pelas,
' or whatever you consider adequate in your currency.
'
' My postal address is:
'
'     Daniel Benito
'     Soto Hidalgo, 8
'     28042 Madrid (Spain)
'
' If you have any questions, send me a message to the CIS address
' 100022,141, or post it in the MSBASIC forum.

' 3D constants
Global Const INSET = -1
Global Const RAISED = 0
Global Const REMOVE = 2

' WindowState
Global Const NORMAL = 0
Global Const MINI = 1
Global Const MAXI = 2

' Colors
Global Const BLACK = &H0&
Global Const RED = &HFF&
Global Const GREEN = &HFF00&
Global Const YELLOW = &HFFFF&
Global Const BLUE = &HFF0000
Global Const MAGENTA = &HFF00FF
Global Const CYAN = &HFFFF00
Global Const WHITE = &HFFFFFF
Global Const LIGHTGRAY = &HC0C0C0
Global Const DARKGRAY = &H808080

Declare Sub DrawFocusRect Lib "User" (ByVal hDC%, lpRect As Any)
Declare Sub GetWindowRect Lib "User" (ByVal hWnd%, lpRect As Any)
Declare Function GetDC Lib "User" (ByVal hWnd As Integer) As Integer
Declare Function ReleaseDC Lib "User" (ByVal hWnd As Integer, ByVal hDC As Integer) As Integer

Type RECT
    Left As Integer
    Top As Integer
    Right As Integer
    Bottom As Integer
End Type

Sub DrawOutline (rt As RECT, frm As Form)

' This subroutine paints a focus frame at the specified co-ordinates. In this example it is
' used to draw the marquee that is dragged when you drag an splitter bar.
' Note: It paints the box on screen DC, not just on the form, to make it appear above other
' controls.
' Parameters:
' rt            - The name of the rect type structure containing the coords of the box to
'                 be drawn.
' frm           - The form on which to draw the frame.
    
    Dim wndcoord As RECT, r As RECT ' structs used for coords
    Dim Dummy As Integer
    DC = GetDC(0) ' Get the Device Context of the whole screen
    GetWindowRect frm.hWnd, wndcoord ' Get coords of form
    
    ' Add pixels for border and titlebar (the coords of a form in VB do not include them)
    ' The number of pixels to be added depends on the type of border

    r.Left = (rt.Left / Screen.TwipsPerPixelX) + wndcoord.Left + 1 '+ 4 sizable border
    r.Top = (rt.Top / Screen.TwipsPerPixelX) + wndcoord.Top + 28 '+ 31 sizable border
    r.right = (rt.right / Screen.TwipsPerPixelX) + wndcoord.Left + 1 '+ 4 sizable border
    r.bottom = (rt.bottom / Screen.TwipsPerPixelX) + wndcoord.Top + 28 '+ 31 sizable border
    
    DrawFocusRect DC, r ' Draw the frame itself
    
    Dummy = ReleaseDC(0, DC) ' Release the allocated DC

End Sub

Sub CenterForm (form_name As Form)
    ' Centers form_name on the screen
    Screen.MousePointer = 11
    form_name.Top = Screen.Height / 2 - form_name.Height / 2
    form_name.Left = Screen.Width / 2 - form_name.Width / 2
    Screen.MousePointer = 0
End Sub

Sub InLinePic (pic_name As Control, bevel_size As Integer, dn As Integer)

' This subroutine paints a frame inside a picture box (or any control with
' the Line method), giving it a 3D effect.
'
' Parameters:
' pic_name      - The name of the picture box on which the frame is to be drawn.
' bevel_size    - Width of the bevel, in pixels.
' dn            - Indicates the style of the frame:
'                   INSET   - The frame is drawn sunken.
'                   RAISED  - The frame is drawn raised.
'                   REMOVE  - The frame is removed (drawn in light gray).

    Dim col1 As Long, col2 As Long ' variables for highlight and shadow colors
    Dim x1 As Integer, y1 As Integer, x As Integer, y As Integer, i As Integer
    Dim pleft As Integer, pright As Integer, ptop As Integer, pbottom As Integer ' coords
    
    Select Case dn ' assign colors depending on frame style
        Case True ' Inset
            col1 = DARKGRAY
            col2 = WHITE
            'col1 = RGB(128, 128, 128) ' Dark gray
            'col2 = RGB(255, 255, 255) ' Bright white
        Case False ' Raised
            col1 = WHITE
            col2 = DARKGRAY
            'col1 = RGB(255, 255, 255) ' Bright white
            'col2 = RGB(128, 128, 128) ' Dark gray
        Case 2 ' Remove
            col1 = LIGHTGRAY
            col2 = LIGHTGRAY
            'col1 = RGB(192, 192, 192) ' Light gray
            'col2 = RGB(192, 192, 192) ' Light gray
        Case Else ' Otherwise, it's an error
            Exit Sub ' Exit subroutine
    End Select
    
    x1 = Screen.TwipsPerPixelX ' Number of twips per pixel horizontally
    y1 = Screen.TwipsPerPixelY ' Number of twips per pixel vertically
    
    bevel_size = bevel_size - 1
    
    pleft = pic_name.ScaleLeft ' Assign coords
    ptop = pic_name.ScaleTop
    pright = pic_name.ScaleLeft + pic_name.ScaleWidth - x1 ' Take away one pixel
    pbottom = pic_name.ScaleTop + pic_name.ScaleHeight - y1 ' Take away one pixel
    
    For i = 0 To bevel_size ' Loop depends of bevel size - draws one rectangle per bevel pixel
        x = x1 * i ' Distance from picture edge
        y = y1 * i ' Distance form picture edge
        pic_name.Line (pleft + x, ptop + y)-(pright - x, ptop + y), col1 ' Draw the individual lines
        pic_name.Line (pleft + x, ptop + y)-(pleft + x, pbottom - y), col1
        pic_name.Line (pleft + x1 + x, pbottom - y)-(pright - x, pbottom - y), col2
        pic_name.Line (pright - x, pbottom - y)-(pright - x, ptop + y), col2
    Next i

End Sub

Sub OutlineControl (form_name As Form, ctrl_name As Control, bevel_size As Integer, dn As Integer)
    
' This subroutine paints a frame on a form around a control, giving it a 3D effect.
'
' Parameters:
' form_name     - The name of the form on which the control is.
' ctrl_name     - The name of the control around which the bevel is to be drawn.
' bevel_size    - Width of the bevel, in pixels.
' dn            - Indicates the style of the frame:
'                   INSET   - The frame is drawn sunken.
'                   RAISED  - The frame is drawn raised.
'                   REMOVE  - The frame is removed (drawn in light gray).
    
    Dim col1 As Long, col2 As Long ' variables for highlight and shadow colors
    Dim x1 As Integer, y1 As Integer, x As Integer, y As Integer, i As Integer
    Dim cleft As Integer, cright As Integer, ctop As Integer, cbottom As Integer ' coords
    
    Select Case dn ' assign colors depending on frame style
        Case True ' Inset
            col1 = DARKGRAY
            col2 = WHITE
            'col1 = RGB(128, 128, 128) ' Dark gray
            'col2 = RGB(255, 255, 255) ' Bright white
        Case False ' Raised
            col1 = WHITE
            col2 = DARKGRAY
            'col1 = RGB(255, 255, 255) ' Bright white
            'col2 = RGB(128, 128, 128) ' Dark gray
        Case 2 ' Remove
            col1 = LIGHTGRAY
            col2 = LIGHTGRAY
            'col1 = RGB(192, 192, 192) ' Light gray
            'col2 = RGB(192, 192, 192) ' Light gray
        Case Else ' Otherwise, it's an error
            Exit Sub ' Exit subroutine
    End Select
    
    x1 = Screen.TwipsPerPixelX ' Number of twips per pixel horizontally
    y1 = Screen.TwipsPerPixelY ' Number of twips per pixel vertically
    
    bevel_size = bevel_size - 1
    
    cleft = ctrl_name.Left ' Assign coords
    ctop = ctrl_name.Top
    cright = ctrl_name.Left + ctrl_name.Width
    cbottom = ctrl_name.Top + ctrl_name.Height
    
    For i = 0 To bevel_size ' Loop depends of bevel size - draws one rectangle per bevel pixel
        x = x1 * i ' Distance from picture edge
        y = y1 * i ' Distance from picture edge
        form_name.Line ((cleft - x1) - x, (ctop - y1) - y)-((cright) + x, (ctop - y1) - y), col1 ' Draw the individual lines
        form_name.Line ((cleft - x1) - x, (ctop - y1) - y)-((cleft - x1) - x, (cbottom) + y), col1
        form_name.Line ((cright) + x, (ctop) - y)-((cright) + x, (cbottom + y1) + y), col2
        form_name.Line ((cleft) - x, (cbottom) + y)-((cright) + x, (cbottom) + y), col2
    Next i

End Sub

Sub OutlineControlPic (pic_name As Control, ctrl_name As Control, bevel_size As Integer, dn As Integer)
    
' This subroutine paints a frame around a control inside a picture box,
' giving it a 3D effect. This separate routine is necessary because, with controls
' insice a container, VB uses the edge of the container as the origin of the coordinates.
'
' Parameters:
' pic_name      - The name of the picture box in which the control is.
' ctrl_name     - The name of the control around which the bevel is to be drawn.
' bevel_size    - Width of the bevel, in pixels.
' dn            - Indicates the style of the frame:
'                   INSET   - The frame is drawn sunken.
'                   RAISED  - The frame is drawn raised.
'                   REMOVE  - The frame is removed (drawn in light gray).
    
    Dim col1 As Long, col2 As Long ' variables for highlight and shadow colors
    Dim x1 As Integer, y1 As Integer, x As Integer, y As Integer, i As Integer
    Dim cleft As Integer, cright As Integer, ctop As Integer, cbottom As Integer ' coords
    
    Select Case dn ' assign colors depending on frame style
        Case True ' Inset
            col1 = DARKGRAY
            col2 = WHITE
            'col1 = RGB(128, 128, 128) ' Dark gray
            'col2 = RGB(255, 255, 255) ' Bright white
        Case False ' Raised
            col1 = WHITE
            col2 = DARKGRAY
            'col1 = RGB(255, 255, 255) ' Bright white
            'col2 = RGB(128, 128, 128) ' Dark gray
        Case 2 ' Remove
            col1 = LIGHTGRAY
            col2 = LIGHTGRAY
            'col1 = RGB(192, 192, 192) ' Light gray
            'col2 = RGB(192, 192, 192) ' Light gray
        Case Else ' Otherwise, it's an error
            Exit Sub ' Exit subroutine
    End Select
    
    x1 = Screen.TwipsPerPixelX ' Number of twips per pixel horizontally
    y1 = Screen.TwipsPerPixelY ' Number of twips per pixel vertically
    
    bevel_size = bevel_size - 1
    
    cleft = ctrl_name.Left ' Assign coords
    ctop = ctrl_name.Top
    cright = ctrl_name.Left + ctrl_name.Width
    cbottom = ctrl_name.Top + ctrl_name.Height
    
    For i = 0 To bevel_size ' Loop depends of bevel size - draws one rectangle per bevel pixel
        x = x1 * i ' Distance from picture edge
        y = y1 * i ' Distance from picture edge
        pic_name.Line ((cleft - x1) - x, (ctop - y1) - y)-((cright) + x, (ctop - y1) - y), col1 ' Draw the individual lines
        pic_name.Line ((cleft - x1) - x, (ctop - y1) - y)-((cleft - x1) - x, (cbottom) + y), col1
        pic_name.Line ((cright) + x, (ctop) - y)-((cright) + x, (cbottom + y1) + y), col2
        pic_name.Line ((cleft) - x, (cbottom) + y)-((cright) + x, (cbottom) + y), col2
    Next i

End Sub

Sub OutlineForm (form_name As Form, bevel_size As Integer, dn As Integer)

' This subroutine paints a frame inside a form, giving it a 3D effect.
'
' Parameters:
' form_name     - The name of the form on which the frame is to be drawn.
' bevel_size    - Width of the bevel, in pixels.
' dn            - Indicates the style of the frame:
'                   INSET   - The frame is drawn sunken.
'                   RAISED  - The frame is drawn raised.
'                   REMOVE  - The frame is removed (drawn in light gray).
    
    Dim col1 As Long, col2 As Long ' variables for highlight and shadow colors
    Dim x1 As Integer, y1 As Integer, x As Integer, y As Integer, i As Integer
    Dim fleft As Integer, fright As Integer, ftop As Integer, fbottom As Integer ' coords
    
    Select Case dn ' assign colors depending on frame style
        Case True ' Inset
            col1 = DARKGRAY
            col2 = WHITE
            'col1 = RGB(128, 128, 128) ' Dark gray
            'col2 = RGB(255, 255, 255) ' Bright white
        Case False ' Raised
            col1 = WHITE
            col2 = DARKGRAY
            'col1 = RGB(255, 255, 255) ' Bright white
            'col2 = RGB(128, 128, 128) ' Dark gray
        Case 2 ' Remove
            col1 = LIGHTGRAY
            col2 = LIGHTGRAY
            'col1 = RGB(192, 192, 192) ' Light gray
            'col2 = RGB(192, 192, 192) ' Light gray
        Case Else ' Otherwise, it's an error
            Exit Sub ' Exit subroutine
    End Select
    
    x1 = Screen.TwipsPerPixelX ' Number of twips per pixel horizontally
    y1 = Screen.TwipsPerPixelY ' Number of twips per pixel vertically
    
    bevel_size = bevel_size - 1
    
    
    fleft = form_name.ScaleLeft ' Assign coords
    ftop = form_name.ScaleTop
    fright = form_name.ScaleLeft + form_name.ScaleWidth - x1 ' Take away one pixel
    fbottom = form_name.ScaleTop + form_name.ScaleHeight - y1 ' Take away one pixel
    
    For i = 0 To bevel_size ' Loop depends of bevel size - draws one rectangle per bevel pixel
        x = x1 * i ' Distance from picture edge
        y = y1 * i ' Distance from picture edge
        form_name.Line (fleft + x, ftop + y)-(fright - x, ftop + y), col1 ' Draw the individual lines
        form_name.Line (fleft + x, ftop + y)-(fleft + x, fbottom - y), col1
        form_name.Line (fleft + x1 + x, fbottom - y)-(fright - x, fbottom - y), col2
        form_name.Line (fright - x, fbottom - y)-(fright - x, ftop + y), col2
    Next i
    
End Sub

Sub OutlinePic (form_name As Form, ctrl_name As Control, dn As Integer)
    
' This subroutine paints a 3D rectangle, with a 1 pixel bevel, around a picture box.
' Although this routine is meant to draw around a container, it can be used with any control.
'
' Parameters:
' form_name     - The name of the form on which the picture box is.
' ctrl_name     - The name of the picture box around which the frame is to be drawn.
' dn            - Indicates the style of the frame:
'                   INSET   - The frame is drawn sunken.
'                   RAISED  - The frame is drawn raised.
'                   REMOVE  - The frame is removed (drawn in light gray).
    
    Dim col1 As Long, col2 As Long ' variables for highlight and shadow colors
    Dim x2 As Integer, y2 As Integer, x As Integer, y As Integer, i As Integer
    Dim fleft As Integer, fright As Integer, ftop As Integer, fbottom As Integer ' coords
    
    Select Case dn ' assign colors depending on frame style
        Case True ' Inset
            col1 = DARKGRAY
            col2 = WHITE
            'col1 = RGB(128, 128, 128) ' Dark gray
            'col2 = RGB(255, 255, 255) ' Bright white
        Case False ' Raised
            col1 = WHITE
            col2 = DARKGRAY
            'col1 = RGB(255, 255, 255) ' Bright white
            'col2 = RGB(128, 128, 128) ' Dark gray
        Case 2 ' Remove
            col1 = LIGHTGRAY
            col2 = LIGHTGRAY
            'col1 = RGB(192, 192, 192) ' Light gray
            'col2 = RGB(192, 192, 192) ' Light gray
        Case Else ' Otherwise, it's an error
            Exit Sub ' Exit subroutine
    End Select
    
    x = Screen.TwipsPerPixelX ' Number of twips per pixel horizontally
    y = Screen.TwipsPerPixelY ' Number of twips per pixel vertically
    
    x2 = x * 2 ' Distance from edge
    y2 = y * 2 ' Distance from edge
        
    ' First box
    ctop = ctrl_name.Top - Screen.TwipsPerPixelY
    cleft = ctrl_name.Left - Screen.TwipsPerPixelX
    cright = ctrl_name.Left + ctrl_name.Width
    cbottom = ctrl_name.Top + ctrl_name.Height
    
    form_name.Line (cleft - x, cbottom + y2)-(cright + x2 + x, cbottom + y2), col1 ' Draw individual lines
    form_name.Line (cright + x2, ctop - y)-(cright + x2, cbottom + y2), col1
    form_name.Line (cleft - x, ctop - y)-(cright + x2, ctop - y), col1
    form_name.Line (cleft - x, ctop - y)-(cleft - x, cbottom + y2), col1
        
    'Second box
    ctop = ctrl_name.Top - Screen.TwipsPerPixelY
    cleft = ctrl_name.Left - Screen.TwipsPerPixelX
    cright = ctrl_name.Left + ctrl_name.Width
    cbottom = ctrl_name.Top + ctrl_name.Height
    
    form_name.Line (cleft - x2, cbottom + y)-(cright + x2, cbottom + y), col2 ' Draw individual lines
    form_name.Line (cright + x, ctop - y2)-(cright + x, cbottom + y), col2
    form_name.Line (cleft - x2, ctop - y2)-(cright + x, ctop - y2), col2
    form_name.Line (cleft - x2, ctop - y2)-(cleft - x2, cbottom + y), col2

End Sub

Sub OutlinePicOnPic (pic_name As Control, ctrl_name As Control, dn As Integer)
    
' This subroutine paints a 3D rectangle, with a 1 pixel bevel, around a picture box inside
' a container. Although it is meant to drawn around a container, it can be used with any
' control.
'
' Parameters:
' pic_name      - The name of the container on which the picture box is.
' ctrl_name     - The name of the picture box around which the frame is to be drawn.
' dn            - Indicates the style of the frame:
'                   INSET   - The frame is drawn sunken.
'                   RAISED  - The frame is drawn raised.
'                   REMOVE  - The frame is removed (drawn in light gray).
    
    Dim col1 As Long, col2 As Long ' variables for highlight and shadow colors
    Dim x2 As Integer, y2 As Integer, x As Integer, y As Integer, i As Integer
    Dim fleft As Integer, fright As Integer, ftop As Integer, fbottom As Integer ' coords
    
    Select Case dn ' assign colors depending on frame style
        Case True ' Inset
            col1 = DARKGRAY
            col2 = WHITE
            'col1 = RGB(128, 128, 128) ' Dark gray
            'col2 = RGB(255, 255, 255) ' Bright white
        Case False ' Raised
            col1 = WHITE
            col2 = DARKGRAY
            'col1 = RGB(255, 255, 255) ' Bright white
            'col2 = RGB(128, 128, 128) ' Dark gray
        Case 2 ' Remove
            col1 = LIGHTGRAY
            col2 = LIGHTGRAY
            'col1 = RGB(192, 192, 192) ' Light gray
            'col2 = RGB(192, 192, 192) ' Light gray
        Case Else ' Otherwise, it's an error
            Exit Sub ' Exit subroutine
    End Select
    
    x = Screen.TwipsPerPixelX ' Number of twips per pixel horizontally
    y = Screen.TwipsPerPixelY ' Number of twips per pixel vertically
    
    x2 = x * 2 ' Distance from edge
    y2 = y * 2 ' Distance from edge
        
    ' First box
    ctop = ctrl_name.Top - Screen.TwipsPerPixelY
    cleft = ctrl_name.Left - Screen.TwipsPerPixelX
    cright = ctrl_name.Left + ctrl_name.Width
    cbottom = ctrl_name.Top + ctrl_name.Height
    
    pic_name.Line (cleft - x, cbottom + y2)-(cright + x2 + x, cbottom + y2), col1 ' Draw individual lines
    pic_name.Line (cright + x2, ctop - y)-(cright + x2, cbottom + y2), col1
    pic_name.Line (cleft - x, ctop - y)-(cright + x2, ctop - y), col1
    pic_name.Line (cleft - x, ctop - y)-(cleft - x, cbottom + y2), col1
        
    'Second box
    ctop = ctrl_name.Top - Screen.TwipsPerPixelY
    cleft = ctrl_name.Left - Screen.TwipsPerPixelX
    cright = ctrl_name.Left + ctrl_name.Width
    cbottom = ctrl_name.Top + ctrl_name.Height
    
    pic_name.Line (cleft - x2, cbottom + y)-(cright + x2, cbottom + y), col2 ' Draw individual lines
    pic_name.Line (cright + x, ctop - y2)-(cright + x, cbottom + y), col2
    pic_name.Line (cleft - x2, ctop - y2)-(cright + x, ctop - y2), col2
    pic_name.Line (cleft - x2, ctop - y2)-(cleft - x2, cbottom + y), col2

End Sub

