; -------------------------------------------------------------------------

    title   : Dialog Converter
    version : 3.4

    abstract: Converts Microsoft Dialog Editor scripts into complete
              BCX source code, removing the need for the resource file
              completely. Or it can create BCX template, where your
              application depends on a resource file (*.RES).

              The code will be generated for BCX 3.0. Supports several
              of the standard controls such as edit, static, combobox,
              listbox, and more. It even handles the richedit, common
              controls, and multiple dialogs!

    compile : build.bat
    usage   : run dc.exe
    tools   : BCX-32 Version 6.8.3 (2011/10/24)
              Pelles ISO C Compiler, Version 6.00.6
              UPX 3.07w

    history : Updated Oct. 29, 2011 / 3.4
                  - Added return type for WinMain when using /l1 option
                  - Updated build.bat to use Pelles C instead of LCC-Win32
                  - Added blank afxres.h for vc example
              Updated Jan. 03, 2005 / 3.3
                  - Renamed hInstance to BCX_hInstance
                  - Changed the scaling method to reflect BCX 5.05-12
                  - Added support for BCX_Input
                  - Properly removes NOT statements
              Updated Jan. 01, 2005 / 3.2
                  - Fixed ElseIf when adding entry point in DC mode
                  - Removed WS_VISIBLE flag on a form in DC mode
                  - Allowed BCX controls to use Windows styles when
                    using simplified GUI commands
              Updated Dec. 31, 2002 / 3.01
                  - Fixed title bug when using the /l3 option
                  - Fixed duplicate handles on multiple dialogs
                  - Fixed displaying status on conversion
                  - Fixed unnecessary usage display
                  - Fixed form/control memory allocation
              Updated Sep. 03, 2002 / 3.0 Final
                  - Fixed mapping pointers for std. classes
                  - Compressed with UPX
                    upx --best --crp-ms=999999 dc.exe
                  - Expanded SubclassWindow and Dialog macros
                    when using the -l1 argument
                  - Added menu creation for dialog starter mode
                  - Disabled adding RichEdit code for DC gui code
              Updated Sep. 02, 2002 / 3.0 Beta
                  - Rewritten using new GUI keywords
                  - Merged /w Dialog Starter
                  - Dynamically adds form and control elements
                  - Several code options (gui/compact/expanded)
              Updated Feb. 23, 2001 / 1.3
              Created Jan. 13, 2001 / 1.0

    known
    issues  : 1) When using DS mode (-g2), a dialog may not appear. This is
                 caused by having the CLASS property for a specific dialog.

                 You will have to modify the dialog script and remove the
                 CLASS property manually.

              2) Comments are not skipped over in a dialog script.
                 Therefore, if you had something like:
                         /*
                             CLASS "my dialog class"
                         */
                 Class will be processed by DC.

              3) Identifiers declared as non-integers will remain undefined
                 if you do not include the header (*.h) with the
                 identifiers.

      mailto: dliboon@hotmail.com
         url: http://dliboon.freeshell.org

; -------------------------------------------------------------------------
