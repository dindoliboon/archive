'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'
'This Demo is copyrighed by Pierre Fillion 1992

'CURSMAN (Cursor Manipulations) will show you:

'How to get real cursor positions (positions of the entire screen)
'How to clip a cursor into a part of the screen
'How to hide and restore cursor (this won't disable it just hide it)
'How to move the cursor to specific location on the screen

'I released the source of this demo to show the use of api calls for cursor
'manipulations. Many hours have been spend to create this demo to make it
'public. Feel free to use part of the code as long as you send a donation.

'Thanks a lot.

'Pierre Fillion
'8460 Perras Apt1
'Montreal, Quebec
'Canada, H1E 5C7

'Questions, suggestions ?? Go Ahead. CIS ID:71162,51

'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

'NOTES:
'
'  1- The routine to hide the cursor don't disable it, the cursor still
'     active but hidden.
'
'     To enables or disables mouse and keyboard input to the specified window
'     or control use this API call on one line.

'     Declare Function EnableWindow Lib "User"
'     (ByVal hWnd As Integer, ByVal aBOOL As Integer) As Integer

'     When input is disable, input such as mouse clicks and key presses
'     are ignored by the window. When input is enabled, all input is processed.

'  2- If you clip the cursor, you won't be able to move it out of the form, but
'     if you drag the form you will see that the clipped area disapeared. It's
'     because, by moving the frame windows reseted the clipped area. To prevent
'     this, just set the top of the clipping area for the form to disallow cursor
'     from reaching it.

'  3- If you exit the program without unclipping, the cursor will be restricted
'     to the clipped area. Just call the unclip routines in you program when you
'     you exit them.

'     I didn't fixed the two previous notes because I found it nice to let you
'     take a look at them.

'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



'Cursor Types for Records
Type POINTAPI
x As Integer
Y As Integer
End Type

Type RECT
Left As Integer
Top As Integer
Right As Integer
Bottom As Integer
End Type

'Cursor Record for API calls
Global Pos As POINTAPI
Global TPos As POINTAPI
Global ClipWin As RECT

'Cursor constants
Global Const C_HIDE = 0
Global Const C_SHOW = -1
Global C_State As Integer 'State of the cursor - hidden of not

'API declaration for cursor manipulations
Declare Sub GetCursorPos Lib "User" (lpPoint As POINTAPI)
Declare Function SetCursorPos Lib "User" (ByVal x%, ByVal Y%) As Integer
Declare Function ShowCursor Lib "User" (ByVal State%) As Integer
Declare Sub ClipCursor Lib "User" (lpRect As Any)



