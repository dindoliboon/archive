////////////////////////////////////////////////////////////////////////////

  Dos2Unix 1.1

  Converts files from Dos to Unix format and back.

  Usage:
    DOS2UNIX "<path\spec>" [-r] [-d]
      path\spec  directory to scan for file spec
      -r         recurse directory
      -d         convert to dos format

  Examples:
    DOS2UNIX "c:\bcx\con_demo\*.bas" -d
    DOS2UNIX "c:\bcx\gui_demo\*.bas" -r
    DOS2UNIX "c:\bcx\dll_demo\*.bas" -d -r

  Comments:
    1  WARNING: Backup the directory you are processing!

       During the development, this program had a strange bug that deleted
       the original file and did not replace it with the modified file.

    2  If you only need to convert one file at a time, rip out the file
       conversion procedures and create a new program with it.

    3  Removing the original file and then replacing it with the modified
       file seems to move the name back into the FindNextFile list.

       Example Order:
         File Name 1     << lets say we are processing File Name 1
         File Name 2
         File Name 3

       After being modified, the name will be spit back into the list,
       which will look similar to the following:

         File Name 2
         File Name 3
         File Name 1     << argh, here it is again

       This strange effect seems to only happen randomly for the first
       time, especially when using the *.* file spec. 

  History (Legend: > Info, ! Fix, + New, - Removed):
    1.0          5/17/2001   > Initial release.
    1.1          9/30/2001   ! Directory recursion.
                             + Unix to Dos conversion.

  Author:
    DL (dl@tks.cjb.net / http://tks.cjb.net)

////////////////////////////////////////////////////////////////////////////
                               DIRECTORY TREE
////////////////////////////////////////////////////////////////////////////

root
    walkdir.lib				Directory Walker library
    walkdir.h				Prototypes for walkdir.lib
    build.bat				Compiles project
    make.bat				Redirects to build.bat
    readme.txt				This file
    dos2unix.bas			BCX source for Dos2Unix
    dos2unix.exe.txt			Output when compiling
    dos2unix.exe			Compiled project
