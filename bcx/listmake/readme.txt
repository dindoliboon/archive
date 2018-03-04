////////////////////////////////////////////////////////////////////////////

  Listing Maker 1.0
 
  Creates a file with the contents of several files. By default, it will
  recurse sub-directories and print header information for each file found.
  Idea from Cino Hilliard's condemo.bas and guidemo.bas application.

  Usage:
    LISTMAKE "<path\spec>" "<file>" [-nr] [-nh]
      path\spec  directory to scan for file spec
      file       output file
      -nr        do not recurse directory
      -nh        do not print header

  Examples:
    LISTMAKE "c:\bcx\con_demo\*.bas" "all console.txt" -nr
    LISTMAKE "c:\bcx\gui_demo\*.bas" "all gui.txt"
    LISTMAKE "c:\bcx\dll_demo\*.bas" "all dll.txt" -nh -nr
    LISTMAKE "c:\bcx\*.bas" "all.txt" -nh

  History (Legend: > Info, ! Fix, + New, - Removed):
    1.0          9/25/2001   > Initial release.

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
    listmake.bas			BCX source for Listing Maker
    listmake.exe.txt			Output when compiling
    listmake.exe			Compiled project
