' //////////////////////////////////////////////////////////////////////////
' > readme.txt 1.0 1:36 PM 8/15/2001                          Read Me File <
' \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'
' LiteSFV 1.0
'
' Verifies and creates SFV files using the CRC-32 algorithm.
' It is free to use and of course, it's open-source!
'
' Copyright (c) 2001 DL
' All Rights Reserved.
'
' \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

root
¦   litesfv.sfv				verification file
¦   readme.txt				this file
¦
+---bin
¦       litesfv.out.txt			output when compiling litesfv
¦       readme.out.txt			output when compiling readme.lib
¦       crc32.out.txt			output when compiling crc32.lib
¦       litesfv.exe			litesfv program file
|
+---source
¦   ¦   crc32.h				crc32.lib prototypes
¦   ¦   litesfv.h			litesfv control identifiers
¦   ¦   readme.h			readme.lib prototypes
¦   ¦   main.bas			BCX source for main dialog
¦   ¦   tools.bas			BCX source for tool functions
¦   ¦   settings.bas			BCX source for settings dialog
¦   ¦   misc.bas			BCX source for misc. functions
¦   ¦   litesfv.bas			BCX source for litesfv program
¦   ¦   litesfv.rc			litesfv resource file
¦   ¦   litesfv.ico			litesfv icon
¦   ¦   crc32.lib			crc32 static library
¦   ¦   readme.lib			readme static library
¦   ¦   build.bat			compiles litesfv program
¦   ¦   make.bat			redirects to build.bat
¦   ¦   tools.bat			post-compiling batch file
¦   ¦
¦   +---readme
¦   ¦       readme.asm			MASM source for readme dialog
¦   ¦       rtfdata.asm			MASM source for RTF data
¦   ¦       make.bat			redirects to build.bat
¦   ¦       tools.bat			post-compiling batch file
¦   ¦
¦   \---crc32
¦           crc32.asm			blank MASM source for crc32.lib
¦           make.bat			redirects to build.bat
¦           tools.bat			post-compiling batch file
¦
\---resource
        icon.psp                        PSP 6.02 icon
        logo.psp                        PSP 6.02 logo
        readme.rtf                      RTF for readme.asm

' //////////////////////////////////////////////////////////////////////////
' > 56 lines for Notepad                               End of Read Me File <
' \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
