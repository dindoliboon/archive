VERSION 2.00
Begin Form frmBigFoot 
   BackColor       =   &H00C0C0C0&
   Caption         =   "BIGFOOT File Viewer"
   ClientHeight    =   6510
   ClientLeft      =   1110
   ClientTop       =   1755
   ClientWidth     =   8415
   FontBold        =   0   'False
   FontItalic      =   0   'False
   FontName        =   "Fixedsys"
   FontSize        =   9
   FontStrikethru  =   0   'False
   FontUnderline   =   0   'False
   Height          =   7200
   Icon            =   BIGFOOT.FRX:0000
   Left            =   1050
   LinkTopic       =   "Form1"
   ScaleHeight     =   6510
   ScaleWidth      =   8415
   Top             =   1125
   Width           =   8535
   Begin CommonDialog CMDialog1 
      Left            =   7800
      Top             =   120
   End
   Begin VScrollBar vsbFile 
      Height          =   4575
      LargeChange     =   30
      Left            =   7800
      Max             =   100
      Min             =   1
      TabIndex        =   0
      Top             =   960
      Value           =   1
      Width           =   255
   End
   Begin TextBox txtFile 
      FontBold        =   0   'False
      FontItalic      =   0   'False
      FontName        =   "Fixedsys"
      FontSize        =   9
      FontStrikethru  =   0   'False
      FontUnderline   =   0   'False
      Height          =   5655
      Left            =   480
      MultiLine       =   -1  'True
      ScrollBars      =   1  'Horizontal
      TabIndex        =   1
      TabStop         =   0   'False
      Top             =   360
      Width           =   7215
   End
   Begin Menu mnuFile 
      Caption         =   "&File"
      Begin Menu mnuFileOpen 
         Caption         =   "&Open"
      End
   End
   Begin Menu mnuHelp 
      Caption         =   "&Help"
      Begin Menu mnuHelpItem 
         Caption         =   "&Help"
         Index           =   0
      End
      Begin Menu mnuHelpItem 
         Caption         =   "-"
         Index           =   1
      End
      Begin Menu mnuHelpItem 
         Caption         =   "&About BIGFOOT"
         Index           =   2
      End
   End
End
Option Explicit

Dim fileBuff()  As Variant       'array of buffers to store file
Dim numBuffTotal%, numBuffNow%
Dim numLinesTotal%, saveLineNum%
Dim buffLines%, buffBytes%, extraBytes%

Sub Form_Resize ()
    Dim i%, numvisible%

    txtFile.Top = 0
    txtFile.Left = 0
    txtFile.Height = ScaleHeight
    txtFile.Width = ScaleWidth - vsbFile.Width

    vsbFile.Top = 0
    vsbFile.Left = txtFile.Width
    vsbFile.Height = txtFile.Height - vsbFile.Width  'for txtFile's hsb

    numvisible = GetVisibleLines()

    vsbFile.LargeChange = numvisible - 1

    If vsbFile.LargeChange >= numLinesTotal Then   'if all lines visible
        vsbFile.Max = 1
    Else
        vsbFile.Max = numLinesTotal - vsbFile.LargeChange
    End If
End Sub

Function GetVisibleLines% ()
    Dim rc As RECT
    Dim lc%, hDC%
    Dim lfont%, oldfont
    Dim tm As TEXTMETRIC
    Dim di%

    ' Get the formatting rectangle - this describes the
    ' rectangle in the Text Box in which text is placed.
    lc = SendMessage(txtFile.hWnd, EM_GETRECT, 0, rc)

    ' Get a handle to the logical font used by the control.
    ' The VB font properties are accurately reflected by
    ' this logical font.
    lfont = SendMessageByNum(txtFile.hWnd, WM_GETFONT, 0, 0&)
    
    ' Get a device context to the text control.
    hDC = GetDC(txtFile.hWnd)

    ' Select in the logical font to obtain the exact font
    ' metrics.
    If lfont <> 0 Then oldfont = SelectObject(hDC, lfont)

    di = GetTextMetrics(hDC, tm)
    ' Select out the logical font
    If lfont <> 0 Then lfont = SelectObject(hDC, oldfont)

    ' The lines depends on the formatting rectangle and font height
    GetVisibleLines = (rc.bottom - rc.top) / tm.tmHeight

    ' Release the device context when done.
    di = ReleaseDC(txtFile.hWnd, hDC)
End Function

Sub mnuFileOpen_Click ()
    Dim nextline$, ndx&, linenum%, buff$, msg$, numErr%, avelength%

    CMDialog1.Filter = "All Files (*.*)|*.*|Text Files (*.txt)|*.txt"
    CMDialog1.FilterIndex = 2
    CMDialog1.Action = 1     'Open

    If CMDialog1.Filename = "" Then Exit Sub  'Open-Dialog Canceled

    avelength = AVELINELENGTH
    Screen.MousePointer = HOURGLASS

startNewFile:

'extraBytes is number of bytes which will be added to each buffer
'from the next buffer in line, to be displayed in the textbox, below
'the "last" line of current buffer.
    extraBytes = MAXLINESVISIBLE * (avelength + 2)
    buffBytes = 30000 - extraBytes
    buffLines = buffBytes \ (avelength + 2)

    'reset before possible re-Open
    Close #1
    numBuffTotal = 0
    numLinesTotal = 0
    Erase fileBuff

    Open CMDialog1.Filename For Input As #1

    Do Until EOF(1)
        buff = Space$(buffBytes)

        linenum = 0
        ndx = 1
        On Error GoTo errorRead
        Do Until linenum = buffLines Or EOF(1)
            linenum = linenum + 1
            Line Input #1, nextline
            nextline = nextline & Chr(13) & Chr(10)
            Mid$(buff, ndx, Len(nextline)) = nextline
            ndx = ndx + Len(nextline)
        Loop
        On Error GoTo 0

        numLinesTotal = numLinesTotal + linenum

        If linenum > 0 Then        'at least one line
            numBuffTotal = numBuffTotal + 1       'starts at one
            ReDim Preserve fileBuff(numBuffTotal)
            fileBuff(numBuffTotal - 1) = RTrim$(buff)
            buff = ""
        End If
    Loop

    Screen.MousePointer = DEFAULT
    numBuffNow = 1

    If vsbFile.LargeChange >= numLinesTotal Then  'all lines visible
        vsbFile.Max = 1           'disable the vert scroll bar
    Else
        vsbFile.Max = numLinesTotal - vsbFile.LargeChange
    End If

    If numBuffNow = numBuffTotal Then  ' if only one buffer
        txtFile.Text = fileBuff(numBuffNow - 1)
    Else
        txtFile.Text = fileBuff(numBuffNow - 1) & Left$(fileBuff(numBuffNow), extraBytes)
    End If

    caption = CMDialog1.Filename
    vsbFile.Value = 1
    vsbFile.SetFocus
    saveLineNum = 1  'start at first line

    Exit Sub

errorRead:
    numErr = numErr + 1
    Beep
    If Err = 5 And numErr <= 5 Then    'could not fit into file buffer
        avelength = 1.25 * avelength    'so try less lines per buffer
        Resume startNewFile
    End If
    msg = "ERROR During File Read !" & Chr(13) & Chr(10)
    msg = msg & "Attempts to adjust average line length failed" & Chr(13) & Chr(10)
    msg = msg & "HUGE line length? (Try adjusting Const AVELINELENGTH)"
    MsgBox msg, 16
    End
End Sub

Sub mnuHelpItem_Click (Index As Integer)
    Dim msg$
    Select Case Index
        Case 0   'Help
            msg = "BIGFOOT is a read-only viewer for large files." & Chr$(13) & Chr$(10)
            msg = msg & "Program uses Visual Basic Text-Box control for view-port." & Chr$(13) & Chr$(10)
            msg = msg & "See About BIGFOOT for contact information."
            MsgBox msg, 64
        Case 2   'About
            msg = "Dan Metzger  dmetzger@ngdc.noaa.gov" & Chr$(13) & Chr$(10)
            msg = msg & "U.S. National Geophysical Data Center"
            Call ShellAbout(Me.hWnd, "BIGFOOT FREEWARE", msg, Me.Icon)
    End Select
End Sub

Sub txtFile_KeyDown (KeyCode As Integer, Shift As Integer)
    KeyCode = 0
    vsbFile.SetFocus
End Sub

Sub vsbFile_Change ()
    vsbFile_Scroll
End Sub

Sub vsbFile_KeyDown (KeyCode As Integer, Shift As Integer)
    If KeyCode = 37 Or KeyCode = 39 Then  'disable left, right arrows
        KeyCode = 0
    End If
End Sub

Sub vsbFile_Scroll ()
    Dim numtoscroll&, l&, numbuffcorrect%

    numtoscroll = vsbFile.Value - saveLineNum   'started at 1
    saveLineNum = vsbFile.Value

    numbuffcorrect = (vsbFile.Value - 1) \ buffLines + 1

    If numBuffNow <> numbuffcorrect Then
        numBuffNow = numbuffcorrect
        If numBuffNow = numBuffTotal Then  ' if no more buffers
            txtFile.Text = fileBuff(numBuffNow - 1)
        Else
          txtFile.Text = fileBuff(numBuffNow - 1) & Left$(fileBuff(numBuffNow), extraBytes)
        End If
        numtoscroll = vsbFile.Value - ((numBuffNow - 1) * buffLines) - 1
    End If

    l = SendMessageByNum(txtFile.hWnd, EM_LINESCROLL, 0, numtoscroll)
End Sub

