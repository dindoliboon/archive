********************************************************************

Example Name: AppendMe (Appending data to an executable) 
Version: 1.0
Delphi Version: 4.x (untested on 3.x, 2.x)
Date: 28th November, 1998
Author: Marko Peric (lonewolf@tig.com.au)

********************************************************************

Description: This example program shows you how to append data to
an executable. I should explain why one would want to append data to 
an executable. A couple of examples spring to mind. First off, 
installation programs like Wise and InstallShield require it. As do 
self-extracting archival programs like WinZip. Any program which allows 
the user to distribute a collection of files (in a professional
manner) would need it, too. In this example, I'm appending another 
executable to the main extractor executable which once extracted will 
run. None of this requires the VCL (in the strict sense of the term), 
by the way.

********************************************************************

Installation and Running: (follow these instructions carefully!)

1. Extract the files to a directory of your choice.
2. Compile Extractor.dpr but DON'T RUN IT! Check that the size of
   the resulting executable (in bytes) is the same as the constant,
   ExeSize. If it isn't, then change the constant to the actual size
   and recompile (but again, don't run it!) (*)
3. Compile and Run the AppendExe.dpr. This will append (**) the file 
   Helloworld.exe to the Extractor executable. Notice that the
   Extractor executable got bigger!
4. Move the Extractor executable to a different directory (or a
   sub-directory) and Run it.
5. It should now extract the HelloWorld program and ask if you want
   to run it. Congrats!

(*) If you don't know how to find the size of an executable, then
shame on you. Right-click on Extractor.exe in Explorer, and then
choose Properties from the pop-up menu. The correct value is NOT
the number of "bytes used" (clusters and all that) but the value 
that you see in brackets, next to the value in KB.

(**) "Append" means add to the end, at least in this context!

********************************************************************

Issues, Bugs, Problems...

  Only tested in Delphi 4.x, but I've done it before in Delphi 3.x
(and then lost the source!) and I see no reason why it shouldn't
work in Delphi 2.x. Not tested on NT.

********************************************************************

About and Contacting the Author

Personal URL: http://homepages.tig.com.au/~lonewolf
Business URL: http://www.kagi.com/sightscreen

Personal E-mail: lonewolf@tig.com.au
Business E-mail: sightscreen@kagi.com

I'm 29 years old, with a Master's degree in Astrophysics, based 
in Sydney, Australia, and currently seeking an exciting Delphi 
programming job. I would prefer to work in Sydney or Hobart, but can 
be enticed elsewhere. If you are interested, you can browse through 
my CV at:

http://homepages.tig.com.au/~lonewolf/CV.html

********************************************************************

Disclaimer:

Since this example program is free, and I give you the source code, 
I bear absolutely no responsibility for what it does to your 
application, computer, or love life. Use it at your own risk.

To end on a positive note, I welcome all comments, bug reports, and
marriage offers.

********************************************************************