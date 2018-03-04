; #########################################################################
;
;   title   : Dialog Converter
;   version : 1.3
;   date    : February 23, 2001
;   abstract: Generates code based on Microsoft Dialog Editor text
;             resources. The code will be generated for BCX 2.0 or
;             higher. Supports several of the standard controls
;             such as edit, static, combobox, listbox, and more. It
;             even handles the richedit 1.0-3.0, win95 controls,
;             and multiple dialogs!
;   notes   : jan. 13, build 2024
;                 wrote preliminary version
;                 detects statics, edit, groups, and multiple forms
;             jan. 14, build 2025
;                 prints progress
;                 detects hscroll, vscroll, icon, combobox, listbox,
;                     buttons, radio, and checkbox
;                 made status messages an option
;                 command argument parsed
;                 added menu generation argument
;                 separate functions for various code generation
;                 added help argument
;                 attempt to handle multi-case dialog content
;                 generates code for multiple forms
;             jan. 15, build 2026
;                 parse function handles quotes to a certain degree
;                 added support for frames, other statics, rects
;                 smarter parser, that counts the quotes
;                 added options for subclass generation
;                 added support for richedit 1.0/2.0
;                 added support for win9x common controls
;             jan. 16, build 2027
;                 fixed reported winproc error under w98 (thanks kevin)
;                 added some comments to source for easier understanding
;                 switched to createwindowex to give controls 3d border
;             jan. 16, build 4120
;                 changed way build number is made
;                 reformats dialog (fixes modified dlg problem)
;             jan. 17, build 4121
;                 made GenerateProc print pound seperator (easier reading)
;                 removed obsolete code
;                 cleaned up example dialog
;             feb. 23, ver 1.3
;                 added WS_SHOWNORMAL
;                 modified parsing
;                 modified multiple dialog code
;   target  : Windows 95/NT or Higher
;   tools   : BCX Translator 2.26
;             LCC-Win32 Development System 1.3
;   compile : build.bat
;   usage   : run dc.exe
;
;   - dl (dl@tks.cjb.net)
;
; #########################################################################
