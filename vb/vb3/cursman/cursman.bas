
Sub Main ()

Dim A As Long
Form1.Show
C_State = -1

      'Never ending loop for the purpose of this demo

While A = A

      'Call the API function defined in CURSPOSG.BAS to retreive
      '                                cursor position on screen.
      Call GetCursorPos(Pos)
      
      'Write current cursor position
      Form1.Label1.Caption = " Screen X: " + Str$(Pos.x) + " -  Y: " + Str$(Pos.Y)
      
      'Write position selected with mouse
      Form1.Label2.Caption = " Pos = X: " + Str$(tPos.x) + " - Y: " + Str$(tPos.Y)
      
      'Execute other events (mouse click, buttons...)
      A = DoEvents()
Wend
End Sub

