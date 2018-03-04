A M I G R E E N   T E S T W I N D O W   1 . 0 0
-----------------------------------------------

I N T R O D U C T I O N
-----------------------
Amigreen TestWindow was made as an experiment and
example of how to create a "small-size" application.
First I made a simpel program in Delphi on the "standard"
way. Then I started to build the program _from scratch_.
I maneged to "shrink" the app. from 212kb to only 16,6kb.
I "saved" 196kb!!!!!


C O M M E N T S   O N   T H E   C O D E
---------------------------------------
First thing to do is to create the main window:
	1. Registrering a custom class for the Window.
	   (The registrered class is automatically unregistered
	    when the application terminates.)
	2. Creating the window by using CreateWindowEx.

Next is to create all the controls in the window:
	1. Using CreateWindow(Ex) to create the button,
	   edit and label.
	- It is important that you create the controls
	  as childs.

Now I want to change the font - the default is too big:
	1. Create a font handle using CreateFont.
	2. Send a WM_SETFONT to every control.

The UpdateWindow draws the components at the same time, so you
don't get a build-up look, when the app. starts.

The messageloop ensures that the application does not terminate
by it self. 

WindowProc function:
All messages sent to the application is sent to the function specified
in the TWndClass structure.


D I S C L A I M E R 
-------------------
This code/program can be distributed freely as long as the author's name
(Janus N. Tøndering, Amigreen Software) is present in both code and readme.


C O N T A C T   I N F O
-----------------------
You can contact with questions about TestWindow or corrections or just
if you want to give me your opinion.

My email address is: j@nus.person.dk
My homepage is at: http://www.crosswinds.net/denmark/~amigreen/ (finished in Feb. 1999)

Copyright © Amigreen Software 1998
