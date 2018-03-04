
'This Works:

Declare Function sndPlaySound Lib "MMSYSTEM.DLL" (ByVal lpszSoundName As Any, ByVal wFlags%) As Integer


' =====  TRY REMMING OUT THE ABOVE LINE & USING THE DECLARE BELOW...
'The next line is the Function Declaration as shown in Microsoft article
' number Q86281 "How to Play a Waveform Sound File in Visual Basic:

'Declare Function sndPlaySound Lib "MMSYSTEM.DLL" (ByVal lpszSoundName$, ByVal wFlags%) As Integer

'======  DOESN'T WORK HUh! ==========================================


Global Const SND_SYNC = &H0
Global Const SND_ASYNC = &H1
Global Const SND_NODEFAULT = &H2
Global Const SND_LOOP = &H8
Global Const SND_NOSTOP = &H10

'You might want to now add a NULL Definition line:

Global Const NewNULL = 0&            '(Wonder what other No's would work?)

