readme.txt for longfile.zip

=====================================================================
The files in this zip are intended to be added to a Visual Basic 3.0
or 16-bit Visual Basic 4.0 project.  Using the enclosed modules will
allow 16-bit Visual Basic applications to use long file names in user
display while retaining short filenames for internal use.  

=====================================================================
All files are copyright 1996, Internet Software Engineering.  The author
is requesting a one-time user fee of $10.  Contact ise@arctic-ise.com 
for more info.  

=====================================================================
What's included:
longfile.frm
longfile.bas

Sample application also uses:
longfile.mak
fileopen.bas
Form1.frm

=====================================================================
What the files are about:
longfile.frm is a VB rendition of a common dialog box.  I considered
making this a .dll, but the resulting file was over 50K, where the VB
equivalent takes around 15K.  In the interest of compactness, I went
with the VB option.  Of course, this leaves the source code wide open
to plagarism -- the dishonest won't care, the guilty may send some
bucks to alleviate your sins... anyway, longfile.frm does the majority
of the processing necessary to get and convert long filenames from
the operating system.  More details are below.

longfile.bas contains declares and the main entry point into the 
longfile routines.

longfile.mak is a VB3 makefile for a sample application.

fileopen.bas is a module containing file open and save routines for
the sample application.

Form1.frm is a simple application form, allowing the user to open and
save a text file.

=====================================================================
FAQ:
1. (So far, the only asked question!) So if I understand correctly,
if I incorporate these modules into my 16-bit VB application, run 
that application on Windows 3.1, I have access to regular DOS 8.3 
style filenames, then run the same application on Window 95 or NT, 
and I also have access to both long and short filenames.  Is that 
right?

YES.

=====================================================================
Here's the main comments from the source code, which gives a pretty
good explanation of the modules and their use.  Also check out the
sample application for a more complete example.

This form and its accompanying longfile.bas module allow 16-bit VB
applications to use long file names when run in environments (Windows 95
and Windows NT) that support them.  Set up for a call to this form is
much like a call to a common dialog box, but with considerably less
properties.  The properties are stored in the following structure:

' structure for dialog box setup
Type LongFile
   Action as Integer         ' 1 = Open, 2 = Save
   Color As Long             ' background color
   DialogTitle As String     ' title bar text
   Filename As String        ' filename for input to dialog box, output filename will be in gShortFilename and gLongFilename
   Filter As String          ' file extension filter
   FilterIndex As Integer    ' index into file extension filter
End Type

This structure is declared as LF and the declaration is global.  Note
one major difference between this structure and that of the common dialog
box:  the Filename string is used only to send a name to this form.  The
string will be null upon exit from this form.  The user selected filename
will be in two global variables, gShortFilename and gLongFilename.  Both
will contain the full path to the filename.  Another global variable,
gIn16BitSystem will be set to True if the system only supports short
filenames, False if the system supports long filenames.  In 16-bit Windows 
systems, both gShortFilename and gLongFilename will contain the same value.

Sample setup and call:
     LF.Action = 1     ' nothing happens until call to GetLongFilename
     LF.DialogTitle = "Select File to Open"
     LF.Filter = "Text (*.txt)|*.txt|HTML (*.htm)|*.htm|All Files (*.*)|*.*"
     LF.FilterIndex = 2   ' set html as default file type
     GetLongFilename

Another example:
     LF.Action = 2     ' nothing happens until call to GetLongFilename
     LF.DialogTitle = "Save File"
     LF.Filename = "foo.txt"
     GetLongFilename
     if LF.Action = -1 ' then user chose Cancel

Since the LF structure is global, structure values remain intact between
calls except for LF.Filename, which is cleared after each call to
GetLongFilename, and LF.Action, which is set to zero on normal exit or
-1 if the user selected the Cancel button.

=======
Internet Software Engineering
ise@arctic-ise.com
http://www.arctic-ise.com/ise
1120 22nd Avenue
Clarkston, WA 99403 USA
(509) 758-3706
