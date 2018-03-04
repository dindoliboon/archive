ReadMe File for

Splitit.C (C) Copyright Bill Buckels 1992-1999
All Rights Reserved.
The ORIGINAL Splitit(C) File Splitter now for Windows 95/98/NT
Version 3.0

Program Description
-------------------

Splitit(C) is a utility program for Windows 95/98/NT that Splits, Joins,
(and Kills) Files in the Current Directory. It also Splits from the
current directory to floppy, and Joins from floppy to the current
directory.

Splitting and Joining
---------------------

Splitit(C) Splits larger files into smaller ones so they can be stored
or transported and later Joined together using Splitit(C)'s Join command or
the DOS copy command.

This is useful for splitting large ZIP files from the Internet and other
huge files across several floppies, for transporting to another
computer, or for storage.

Beheading and Trimming
----------------------

Besides Splitting Files Into Two or more Parts, Headers or Footers may
be removed from files (split apart) using Splitit(C). Whether you are
beheading the header from a database file, and then chunking the data
into records, or trimming the palette data from the end of a 256 color
PCX file, Splitit(C) does it all.

Splitting Text Files
--------------------

Splitit(C) offers a Special Mode for Splitting Large TEXT files (like log
files) without breaking them in the middle of a line. You may wish to
store large text files in smaller more manageable uncompressed pieces.

Batch Mode and Command Line Mode
--------------------------------

And Splitit(C) offers both interactive and command line usage modes. The
non-interactive "Batch" Command Line Mode allows Splitit(C) to be called
from a batch file. Even though Splitit(C) is a 32 bit Windows
Application, it behaves pretty much like a DOS application in a batch
file, but it handles long file names.

Splitit(C) can be called from a DOS batch file with the Windows Start
command and /W (Wait command option) to do after-hours processing and
other non-interactive work.

Or you can use Splitit(C) with our Task Launcher, WinRobot, available from
our WebSite to do pretty much the same thing in a WinRobot script.

New Features - Long Filename Support and Hot Keys
-------------------------------------------------

New Features include support for Long FileNames, and "Hot Keys" for
standard commands. Standard features like Automatic File Naming are
still in place from the earlier versions.

New Features - Move and Copy
----------------------------

You can also use Splitit(C) to Move and Copy Files. If you prefer not to
split directly to floppy, you can make floppy size chunks in the current
directory and later use Splitit(C) (or Explorer) to move or copy to floppy
disk. (If you have the room, perhaps it is better to Split to your Hard
Drive first, in case you have a bad floppy or two.)

New Features - Split to Floppy and Join from Floppy
---------------------------------------------------

Splitit(C) has always been rather restricted in where it creates its
files... until this version all file chunks were put into the current
directory. This is because I don't like to get too fancy. Split first
and move later has been my motto.

But to offer an alternative this version we also map to a floppy in
either drives A: or B: for Splitting to and Joining from... this is
probably sufficient for most folks even if they like to split to a
different destination.

Even if we are splitting to floppy, we still prompt the user to enter a
filesize for target chunks. Some may argue that the floppy save should
be smart enough to know the floppy size and to not bother the user...

That may be true, and perhaps next version we'll do this differently, but
in the interests of getting on with life, and getting this version out
the door, I have made the floppy save the same as the others... although
I provide some guidance regarding floppy sizes.

Is Splitit(C) Destructive ?
---------------------------

Splitit(C) can be destructive, but gives you a "fighting chance" for
reasonably intelligent errors.

When Splitit(C) splits a file it leaves the original file intact, but
you can use Splitit(C) to delete the original file later if you wish.
When you Join files, Splitit(C) will overwrite files of the same name,
but will prompt you first.

Automatic Naming
----------------

Splitit(C) uses an Automatic File naming convention of appending a 3
digit number to the original root name of the file.

When Splitit(C) splits a file it creates chunks of the file starting
with the file's "rootname" and having numbered extensions starting with
.001, .002, etc. Splitit(C) does not worry about overwriting these .001
type of files when splitting.

Splitit(C) also does not know ahead of time how many chunks you need to
join and just keeps counting, so when joining from floppy don't worry if
Splitit(C) asks you for another DISK after you have fed it the last one in
the set. (This just the way Splitit(C) is designed in order to keep it
simple... maybe next version this will be a little more sophisticated.)

Because Splitit(C) uses automatic naming to make the Chunks from the
original file, the only files that you can't split or join to are files
with a 3 digit numeric file extensions (since they conflict with our
output and input naming conventions). I can't think of any other files
with numeric extensions of this nature anyway, so the chances of you
needing to split one are probably pretty slim.

Heavy On the positive side, automatic naming is really nice, both for
you to stay organized with your file chunks, and for Splitit(C)'s Join
Feature to work without problems.

Negative side is that you may lose the last chunk in a series and create
an incomplete file when joining, so as usual, be careful not to lose
your archives, and label your disks disk x of xx.

Cleaning-Up
-----------

Splitit(C) does not clean up after itself. This is by design, for diagnostic
reasons, rather than to make your life miserable. In future versions
maybe this will be an option, but for now you need to use Splitit(C)'s
delete command to individually remove old chunks.

Make Sure that you remove all the leftover numbered chunks from any
failed split operation, so you don't confuse either Splitit(C) or yourself
as to which chunks are old and which ones are new.

Since failures should be the exception rather than the rule, only a
pessimist would worry too much about such things. So don't worry.

Working Without A Net
---------------------

Like any file utility of this power, you have the potential for making
errors if you really try hard enough. Splitit(C) is distributed without
Warranty or liability... as they say in the circus, "you are working
without a net", so be careful. But this is the case with most if not all
file utilities, whether purchased or free.

Reporting Bugs
--------------

Even though Splitit(C) is FreeWare, we do not want bugs to make your life
miserable. I did not find problems in Splitit(C), and I have been testing
most of the  low level code in Splitit(C) off and on for the last 10 years
(I reused the original DOS routines with additional fenestration for the
Windows environment, so they should be OK by now.)

(Note: The term fenestrate is used above to describe porting this
program from DOS. Next version will possibly be a Cross-Platform
refenestration in Java... still thinking about it.)

Nevertheless... to report Bugs, I have an online form on my WebSite at:

http://www.escape.ca/~bbuckels

Please note: Splitit(C) was written for fun and as a public service. Some
evidence that it was written for fun should be apparent by little
messages that congratulate you when you have completed Splitit(C)'s pretty
boring tasks. No complaints about Splitit(C)'s "look and feel" please...
Splitit(C) doesn't have a "look and feel"... Splitit(C) has a "look and
laugh".

Don't be fooled
---------------

Don't be fooled by more expensive imitations or Splitit(C) "soundalikes"!
There is only one Splitit(C) and This Is It! Splitit(C) Version 3.0 is the
long overdue WIN32 rewrite of the ORIGINAL Splitit(C) Utility for DOS by
the Original Author, and it is still absolutely free.

The original features have all survived. For example, you can still join
the files that Splitit(C) creates using the DOS copy command with the /B
option if you don't want to use Splitit(C)'s built in Join command.

Open Source
-----------

Splitit(C) is distributed as FreeWare with Open C Language Source Code.
It is written in hard-wired 100% Pure Industrial Strength Microsoft 32
Bit C (WIN32 not C++), and compiled under MSC Version 12 (Visual Studio
6). The code in this program is pretty well commented and you shouldn't
have much trouble reading it.

If you didn't get a copy of the source code with Splitit(C), visit the
Teacher's Choice Website at http://www.escape.ca/~bbuckels and get the
latest version complete with source.

As far as we know, Splitit(C) does not require any special libraries
other than the usual ones that are shipped with Windows. It is not a
bloated VB or MFC application, and runs quickly and quietly. And since
Splitit(C) is so tiny, anyone can easily find room on their computer for
it.

Installing and Running Splitit(C)
-----------------------------

Install Splitit(C) by "UNZIPPING" Splitit.ZIP complete with pathnames
to the drive of your choice. If you decide to install Splitit(C) to
Drive C:, Splitit(C) will be installed into the directory C:\Splitit.

Start Splitit(C) by clicking on Splitit.EXE.

Use With Care! Damage can be Caused if Your Disk Is Full!

Licence Agreement
-----------------
Splitit(C) Copyright Bill Buckels 1992-1999.
All Rights Reserved.

Splitit(C) is distributed as FreeWare with Open Source.

You have a royalty-free right to use, modify, reproduce and distribute
this program and its source code and associated files in any
non-competitive way you find useful, provided that you agree that Bill
Buckels has no warranty obligations or liability resulting from said
distribution in any way whatsoever. If you don't agree, remove
Splitit.Exe and all associated files from your computer now.

Bill Buckels
589 Oxford Street
Winnipeg, Manitoba, Canada R3M 3J2

Email: bbuckels@escape.ca
WebSite: http://www.escape.ca/~bbuckels

Splitit(C) is not a derivative work of any other author and is the
exclusive property of Bill Buckels (the author). All methods are the
product of work and study by the author.

Splitit(C) was not produced in anticipation of profit, except where The
Author's WebSite is mentioned. Since The Author's WebSite and ShareWare
have never generated revenue, and are primarily offered as a public
service, this is more like a sponsorship reference than advertising, and
is not meant to offend anyone.

Command Line Mode
-----------------

Splitit(C) Offers Both interactive and command line usage modes. The
commandline mode which is covered below allows Splitit(C) to be called
from a batch file, or from the DOS command line and perform its
handiwork non-interactively.

See Appendix A - Using the Windows Start Command in a batch file for a
summary of information about the Start command. Splitit(C) can also be run
non-interactively in batch mode from the WinRobot Task Launcher
available from our Website.

Commandline: Splitit(C) [command] ROOTNAME.EXT [checksum-bytes]

B - Behead - remove [checksum] bytes from the beginning of the file.
2-files are created... [ROOTNAME].001 and [ROOTNAME].002.

T - Trim - remove [checksum] bytes from the end of the file. 2-files are
created... [ROOTNAME].001 and [ROOTNAME].002.

C - Chunk BINARY - break file into pieces (multiple files) of [checksum]
bytes starting with  file [ROOTNAME].001, [ROOTNAME].002, etc.

A - Chunk ASCII - break a file into pieces of [checksum] bytes same as
binary but do not split lines of text. Use for BBS Logfiles, etc.

J - Join - Join a file that was previously split into pieces (multiple
files) starting with  file [ROOTNAME].001. The [checksum] is not
required for this option.

Additional Files
----------------

As previously stated, Splitit(C) comes with Complete 32 Bit Source Code. If
you want to mess with it, just run it through your compiler and you
should be fine. I think just about any 32 Bit MSC Compiler will handle
the code.

I also couldn't resist including DOS Version 2.0 of Splitit(C) complete with
source code, just for old time's sake. There is no point in using it
really, since this version does all of that and more, but in case you
ever get into a nostalgia jag or you just want to make fun of the old
days, it is there for you.

This basically ends the official documentation. The rest of this is
appendices about related stuff.

Hope you enjoy using Splitit(C) as much as I enjoyed making it. It really
was fun and pretty easy to take the old DOS version and put a Win 32
skin on it... but then my idea of fun is pretty weird.

Bill Buckels
Teacher's Choice Productions
October 24, 1999

Email: bbuckels@escape.ca
Website: http://www.escape.ca/~bbuckels


Appendix A - Using the Windows Start Command in a Batch File
----------

Start.Exe (Windows 95/98)

Runs a Windows program or an MS-DOS program.

START [options] program [arg...]
START [options] document.ext

/m[inimized] Run the new program minimized (in the background).
/max[imized] Run the new program maximized (in the foreground).
/r[estored]  Run the new program restored (in the foreground). [default]
/w[ait]      Does not return until the other program exits.

End of Appendix A

Appendix B - Joining Files Using The DOS Copy Command
----------

This is a really long appendix, and is the last thing in this ReadMe
file. I have included it for reference, because lots of folks don't know
where their DOS is anymore, but they might be curious with all this talk
about using the DOS copy command to Join files. Many of us who used DOS
longer than we care to remember already know more than we care to about
the copy command and can probably safely skip most of this.

Believe it or not, I have shortened most of this to include only the
parts that might relate to the Joining of files in DOS. If there is no
reason for you to use DOS, you may wish to skip this entirely and simply
use the Join command in Splitit(C).

COPY - Syntax
-------------

Copies one or more files to the location you specify.

This command can also be used to combine files. When more than one file
is copied, MS-DOS dipoles each filename as the file is copied.

Syntax
------

    COPY [/Y|/-Y] [/A|/B] source [/A|/B] [+ source [/A|/B] [+
    ...]][destination [/A|/B]] [/V]

Parameters
----------

source
    Specifies the location and name of a file or set of files from which
    you want to copy. Source can consist of a drive letter and colon, a
    directory name, a filename, or a combination.

destination
    Specifies the location and name of a file or set of files to which
    you want to copy. Destination can consist of a drive letter and
    colon, a directory name, a filename, or a combination.

Switches
--------

/Y
    Indicates that you want COPY to replace existing file(s) without
    prompting you for confirmation. By default, if you specify an
    existing file as the destination file, COPY will ask you if you want
    to overwrite the existing file. (Previous versions of MS-DOS would
    simply replace the existing file.) If the COPY command is part of a
    batch file, COPY will behave as in previous versions. Specifying
    this switch overrides all defaults and the current setting of the
    COPYCMD environment variable.

/-Y
    Indicates that you want COPY to prompt you for confirmation when
    replacing an existing file. Specifying this switch overrides all
    defaults and the current setting of the COPYCMD environment
    variable.

/A
    Indicates an ASCII text file. When the /A switch precedes the list
    of filenames on the command line, it applies to all files whose
    names follow the /A switch, until COPY encounters a /B switch, in
    which case the /B switch applies to the file whose name precedes the
    /B switch.

    When the /A switch follows a filename, it applies to the file whose
    name precedes the /A switch and to all files whose names follow the
    /A switch, until COPY encounters a /B switch, in which case the /B
    switch applies to the file whose name precedes the /B switch.

    An ASCII text file can use an end-of-file character (CTRL+Z) to
    indicate the end of the file. When combining files, COPY treats
    files as ASCII text files by default.

/B
    Indicates a binary file. When the /B switch precedes the list of
    filenames on the command line, it applies to all files whose names
    follow the /B switch, until COPY encounters an /A switch, in which
    case the /A switch applies to the file whose name precedes the /A
    switch.

    When the /B switch follows a filename, it applies to the file whose
    name precedes the /B switch and to all files whose names follow the
    /B switch, until COPY encounters an /A switch, in which case the /A
    switch applies to the file whose name precedes the /A switch.

    The /B switch specifies that the command interpreter is to read the
    number of bytes specified by the file size in the directory. The /B
    switch is the default value for COPY unless COPY is combining files.

/V
    Verifies that new files are written correctly.

COPY - Examples
---------------

To copy several files into one file, list any number of files as source
parameters on the COPY command line. Separate filenames with a plus sign
(+) and specify a filename for the resulting combined file, as the
following example shows:

    copy mar89.rpt + apr89.rpt + may89.rpt report

This command combines the files named MAR89.RPT, APR89.RPT, and
MAY89.RPT from the current drive and directory and places them in a file
named REPORT in the current directory on the current drive. When files
are combined, the destination file is created with the current date and
time. If you omit destination, MS-DOS combines the files and stores them
under the name of the first specified file. For example, if a file named
REPORT already exists, you can use the following command to combine all
four files in REPORT:

    copy report + mar89.rpt + apr89.rpt + may89.rpt

You can also combine several files into one by using wildcards, as the
following example shows:

    copy *.txt combin.doc

This command combines all files in the current directory on the current
drive that have the extension .TXT into one file named COMBIN.DOC, also
in the current directory on the current drive.

If you want to combine several binary files into one by using wildcards,
include the /B switch, as the following example shows:

    copy /b *.exe combin.exe

This prevents MS-DOS from treating CTRL+Z as an end-of-file character.

CAUTION:  If you combine binary files, the resulting file might not be
          usable due to internal formatting.

In the following example, COPY combines each file that has a .TXT
extension with its corresponding .REF file. The result is a file with
the same filename but with a .DOC extension. Thus, COPY combines
FILE1.TXT with FILE1.REF to form FILE1.DOC. Then COPY combines FILE2.TXT
with FILE2.REF to form FILE2.DOC, and so on.

    copy *.txt + *.ref *.doc

The following COPY command combines first all files with the .TXT
extension, then all files with the .REF extension into one file named
COMBIN.DOC:

    copy *.txt + *.ref combin.doc


COPY - Notes
------------

Setting the COPYCMD environment variable
----------------------------------------

You can set the COPYCMD environment variable to specify whether you want
the COPY, MOVE, and XCOPY commands to prompt you for confirmation before
overwriting a file, whether issued from the command prompt or a batch
file.

To force the COPY, MOVE, and XCOPY commands to prompt you before
overwriting in all cases, set the COPYCMD environment variable /-Y. To
force these commands to overwrite in all cases without prompting you,
set the COPYCMD environment variable to /Y.

Typing any of these commands with the /Y or /-Y switch overrides all
defaults and the current setting of the COPYCMD environment variable.

Using the /V switch
-------------------

If MS-DOS cannot verify a write operation, it displays an error message.
Although recording errors rarely occur with the COPY command, the /V
switch lets you verify that critical data has been correctly recorded.
The /V switch also slows down the COPY command, because MS-DOS must
check each sector recorded on the disk.

Using the /A and /B switches
----------------------------

The effect of an /A or /B switch depends upon its position on the
command line. When the /A or /B switch follows the source filename, COPY
performs as shown in the following list:

/A
    Treats the file as an ASCII (text) file and copies data that
    precedes the first end-of-file character. COPY does not copy the
    first end-of-file character or the remainder of the file.

/B
    Copies the entire file, including any end-of-file character.

When the /A or /B switch follows the destination filename, COPY performs
as shown in the following list:

/A
    Adds an end-of-file character as the last character of the file.

/B
    Does not add an end-of-file character.

Combining files with the COPY command
-------------------------------------

If you specify more than one source, separating entries with a plus sign
(+), COPY combines the files, creating a single file. If you use
wildcards in source but specify a single filename in destination, COPY
combines all files matching the filename in source and creates a single
file with the filename specified in destination.

In either case, COPY assumes the combined files are ASCII files unless
you specify the /B switch. (Do not combine non-ASCII files without
specifying the /B switch; doing so can result in truncated files, since
most binary files contain CTRL+Z characters which cause COPY to behave
as if it has reached the end of the file.)

If the name of the destination file is the same as the name of one of
the files being copied (except the first file), the original contents of
the destination file are lost. When this happens, COPY displays the
following message:

    Content of destination lost before copy

End of Appendix B
End of ReadMe
