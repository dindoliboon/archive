Const TIPS_SW_SHOWNOACTIVATE = 4
Const TIPS_XGW_CHILD = 5         ' Needed for edit portion of combo box

Type TIPS_POINTAPI  '4 Bytes - Synonymous with LONG
        x As Integer
        y As Integer
End Type

Type tooltip_type
    hWnd As Long
    Tip As String
    Help As String
End Type

Declare Sub GetCursorPos Lib "User" (lpPoint As TIPS_POINTAPI)
Declare Function GetActiveWindow Lib "User" () As Integer
Declare Function WindowFromPoint Lib "user" (ByVal lpPointY As Integer, ByVal lpPointX As Integer) As Integer
Declare Function GetWindow Lib "User" (ByVal hWnd As Integer, ByVal wCmd As Integer) As Integer
Declare Function ShowWindow Lib "User" (ByVal hWnd As Integer, ByVal nCmdShow As Integer) As Integer




Global gtooltip() As tooltip_type

Sub AddTip (ByVal hWnd As Long, ByVal Tip As String, ByVal Help As String)
x = UBound(gtooltip) + 1

ReDim Preserve gtooltip(x) As tooltip_type
gtooltip(x).hWnd = hWnd
gtooltip(x).Tip = Tip
gtooltip(x).Help = Help
End Sub

Sub DisplayTips ()
Static LastHwnd As Long
Dim p As TIPS_POINTAPI

GetCursorPos p
CurHwnd = WindowFromPoint(p.y, p.x)

If LastHwnd = CurHwnd Then Exit Sub

LastHwnd = CurHwnd

For a = LBound(gtooltip) To UBound(gtooltip)
    If CurHwnd = gtooltip(a).hWnd And gtooltip(a).Tip <> "" Then
        TTips.Tip = gtooltip(a).Tip
        Theight = TTips.Tip.Height
        TWidth = TTips.Tip.Width
        TTips.Tip.AutoSize = False
        TTips.Tip.Width = TWidth + 15
        TTips.Tip.Height = Theight + 16
        TTips.Top = (p.y + 18) * Screen.TwipsPerPixelY
        TTips.Left = (p.x - 2) * Screen.TwipsPerPixelY
        TTips.Height = TTips.Tip.Height
        TTips.Width = TTips.Tip.Width
        'With .Help member you can fill a statusbar
        Form1.StatBar = gtooltip(a).Help
        '----------------------------------------
        TTips.ZOrder
        ' Show form without the focus:
        ret = ShowWindow(TTips.hWnd, TIPS_SW_SHOWNOACTIVATE)

        Exit Sub
    End If
    
    TTips.Hide
    ' Help on StatBar
    Form1.StatBar = ""
    TTips.Tip.AutoSize = True
Next a



End Sub

Sub InitializeTips ()
ReDim gtooltip(0) As tooltip_type
End Sub

Sub removeTip (ByVal hWnd As Long)
Dim a, b, u As Integer

up = UBound(gtooltip)

For a = LBound(gtooltip) To up
    If gtooltip(a).hWnd = hWnd Then
        For b = a + 1 To up
            gtooltip(b - 1).hWnd = gtooltip(b).hWnd
            gtooltip(b - 1).Tip = gtooltip(b).Tip
            gtooltip(b - 1).Help = gtooltip(b).Help
        Next b
        ReDim Preserve gtooltip(up - 1) As tooltip_type
        Exit For
     End If
Next a
End Sub

