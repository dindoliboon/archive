; -------------------------------------------------------------------------

    title   : Dialog Converter
    version : 3.01

    abstract: Converts Microsoft Dialog Editor scripts into complete
              BCX source code, removing the need for the resource file
              completely, or a BCX template, where your application
              depends on a resource file (*.RES).

              The code will be generated for BCX 3.0. Supports several
              of the standard controls such as edit, static, combobox,
              listbox, and more. It even handles the richedit, common
              controls, and multiple dialogs!

    compile : build.bat
    usage   : run dc.exe
    tools   : BCX Translator 3.32
              LCC-Win32 Development System 1.3
              UPX 1.22

    history : Updated Dec. 31, 2002 / 3.01
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

       notes: To my knowledge, there are no known bugs in this version.

              However, there are a few issues, but this is not due to
              Dialog Converter (DC from hereon).

              1) When using DC mode (-g1), a GUI window will appear and the
                 move itself to the center to the screen. This is caused by
                 having the WS_VISIBLE flag in your dialog.

                 You will have to either modify the dialog script and
                 remove the WS_VISIBLE flag manually OR modify the
                 generated source code.

              2) When using DS mode (-g2), a dialog may not appear. This is
                 caused by having the CLASS property for a specific dialog.

                 You will have to modify the dialog script and remove the
                 CLASS property manually.

              3) Comments are not skipped over in a dialog script.
                 Therefore, if you had something like:
                         /*
                             CLASS "my dialog class"
                         */
                 Class will be processed by DC.

              4) Identifiers declared as non-integers will remain undefined
                 if you do not include the header (*.h) with the
                 identifiers.

      mailto: dl @ tks.cjb.net
         url: http://tks.cjb.net

; -------------------------------------------------------------------------
