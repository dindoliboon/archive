; #########################################################################
;
;   title   : toulmth
;   version : 1.0.2988
;   date    : January 21, 2001
;   abstract: Generates HTML files based on file lists created using
;             CDX 3.4+. It will read these files and then read a user
;             created HTML template. The final result will be saved
;             to a file. It can handle custom variables, orientation
;             of the date & time, and much more if you have a good
;             knowledge of HTML. Includes several examples with
;             comments.
;   notes   : dec. 28, build 2104
;                 no actual history record
;                 very cude looking template
;                 decided to add pre-defined variables
;             jan. 01, build 2968
;                 re-wrote template adding:
;                 custom variables
;                 customizable date/time output
;                 renamable pre-definined variables
;                 check lists for all 8 delmiters
;                 generates the first list
;             jan. 02, build 2969
;                 re-compiled with lcc-win32 v1.32
;                 applied -O linking switch to save 1K
;                 formatted source code
;             jan. 03, build 2970
;                 added support for odd/even printing
;                 * generates all files (1, 2, 3, and 5) for now
;                 * checks if all files exist
;                 * multipule templates
;                 real history notes
;             jan. 04, build 2971
;                 renamed app
;                 designing gui
;             jan. 05, build 2972
;                 creating gui
;                 adding file reading code
;             jan. 20, build 2987
;                 re-wrote application
;                 decreased exe by 8k
;                 removed unnecessary code
;             jan. 21, build 2988
;                 added file inserting, (5 files max)
;   target  : Windows 95/NT or Higher
;   tools   : BCX Translator 2.10
;             LCC-Win32 Development System 1.3
;   compile : build.bat
;   usage   : run toulmth.exe
;
;   - dl (dl@tks.cjb.net)
;
; #########################################################################
