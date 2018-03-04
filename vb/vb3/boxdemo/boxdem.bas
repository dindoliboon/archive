'
'
'  ****************************
'  *  Exploding Picture Demo  *
'  *                          *
'  *        Written by        *
'  *    Christopher A Evans   *
'  *     Saaiiee@AOL.COMM     *
'  *     (908) 874 - 3397     *
'  *                          *
'  * ©1995Christopher A Evans *
'  ****************************
'
'  This is just a test version some basic sub routines.
'  I have a P90 with a 1meg STB PCI video card and I would
'  like to know how well it works on other systems. If you
'  have a slower system could you E-mail me some performance
'  info, thanks.
'
'  The code is intentional simple, since this is just a
'  test. If you add some variables into the explode/implode
'  subs it could become must more powerful.
'
'  You are free to use this code as you see fit as long as
'  I am not held responsible for any damages. The sounds are
'  mine! Do not use them!
'
'  If you like some more code examples, sounds, buttons or
'  anything I have developed for multi media thing get in
'  touch with me. I don't usually sell the stuff but I like
'  to it trade for other original mm development files.


Declare Function sndPlaySound Lib "MMSYSTEM" (ByVal lpWavName$, ByVal Flags%) As Integer   '
Declare Function GetWindowsDirectory% Lib "Kernel" (ByVal lpBuffer$, ByVal nSize%)

Global xsound As String
Global info(1 To 5) As String
Global clicknum As Integer

Sub playsound (xsound As String)
Debug.Print "Xsound  " & xsound
Dim x%
x% = sndPlaySound(xsound, 1)
End Sub

