' Dialog Starter 1.0
' Converts Microsoft Dialog Editor Scripts to BCX code.
' Unlike DC, which converts everything to BCX, DS simply
' creates a template so you can use the actual DLG file.
'
' Created by DL, April 08, 2001
' Parser by Kevin Diggins
'
' ********************** NOTES **********************
' A few things that are important to mention:
'   1) only for Microsoft Dialog Editor scripts
'   2) do not use a custom class name for dialogs
'   3) don't forget to compile your dialog as a
'      32-bit binary resource when your done
'   4) does not handle non-numerical IDs
'   5) enjoy
' ********************** NOTES **********************

    CONST CRLF = TRUE
    CONST NOCR = FALSE

    GLOBAL gComments
    GLOBAL gSubclass
    GLOBAL gAlign
    GLOBAL gStatus
    GLOBAL gHelp
    GLOBAL gRichEd1
    GLOBAL gRichEd2
    GLOBAL gCommon

    TYPE form
        id$[6]
    END TYPE

    TYPE control
        type$[30]
        id$[6]
        dlg AS INTEGER
    END TYPE

    DIM szFile$
    DIM szTemp$
    DIM szOutput$
    DIM x

    gAlign = 4
    gComments = TRUE
    gSubclass = FALSE
    gStatus   = FALSE

    ' scan arguments
    ! for (x = 1; x < argc; x++)
    ! if (argv[x][0] == '/' || argv[x][0] == '-')
    ! {
    !    switch (argv[x][1])
    !    {
    !    case 'S':
    !    case 's':
    !        gStatus   = TRUE;
    !        break;
    !    case 'C':
    !    case 'c':
    !        gSubclass = TRUE;
    !        break;
    !    case 'K':
    !    case 'k':
    !        gComments = FALSE;
    !        break;
    !    case 'A':
    !    case 'a':
            IF argv[x][2] >= 48 AND argv[x][2] <= 57 THEN
                gAlign = argv[x][2] - 48
            END IF           
    !        break;
    !    case '?':
    !        gHelp     = TRUE;
    !        break;
    !    }
    ! }

    ' get file name
    szTemp$ = COMMAND$                ' required to call command function
    IF argc > 1 THEN
        ! sprintf(szTemp, "%s", command(2, argv));
    END IF

    IF szTemp$ = "" THEN gHelp = TRUE
    IF LOF(szTemp$) = -1 THEN         ' check if file exists
        szFile$ = szTemp$ & ".dlg"    ' file doesn't exist, add ext
    ELSE
        szFile$ = szTemp$             ' file exists, leave it alone
    END IF

    ' create output .tmp file name
    szOutput$ = LCASE$(szFile$)
    szOutput$ = REMOVE$(szOutput$, ".dlg")
    szOutput$ = szOutput$ & ".bas"

    ' check final orders (help or if file exists)
    IF gHelp = TRUE THEN
        PRINT "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
        PRINT "³ Dialog Starter 1.0                                                 ³"
        PRINT "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
        PRINT "³ Converts Microsoft Dialog Editor scripts to BCX BASIC source code. ³"
        PRINT "³ ds [drive:][path]filename[.dlg] [/k] [/s] [/c] [/?] [a#]           ³"
        PRINT "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
        PRINT "³ [drive:][path]filename[.dlg]                                       ³"
        PRINT "³ Specifies the file that you would like to convert.                 ³"
        PRINT "³ The drive, path, and dlg extention are optional.                   ³"
        PRINT "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
        PRINT "³ /k   Remove comments from source code.                             ³"
        PRINT "³ /s   Displays status while converting scripts.                     ³"
        PRINT "³ /c   Adds control subclass to source code.                         ³"
        PRINT "³ /?   Displays meanings of arguments.                               ³"
        PRINT "³ /a#  # Represents spacing alignment. Accepts 0 to 9. Default is 4. ³"
        PRINT "³                                                                    ³"
        PRINT "³ Also accepts unix-style switches such as:  ds filename -k -s -c -? ³"
        PRINT "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
        PRINT ""
    ELSEIF LOF(szFile$) = -1 THEN
        PRINT "error : could not open source file."
    ELSE
        StartApplication(szFile$, szOutput$)
    END IF


SUB StartApplication(szInFile$, szOutFile$)
    DIM SHARED cdx AS INTEGER
    DIM SHARED ddx AS INTEGER
    DIM SHARED ctl[256] AS control
    DIM SHARED frm[256] AS form
    DIM x

    ProcessDialog(szInFile$)
    OPEN szOutFile$ FOR OUTPUT AS FP_WRITE
        EmitHeader(FP_WRITE)

        EmitComment(FP_WRITE, 1, "Global Constants (Dialog/Control IDs)")
        FOR x = 0 to ddx
            FPRINT FP_WRITE, SPACE$(gAlign * 1), "CONST IDD_FORM", TRIM$(STR$(x + 1)), " = ", frm[x].id$
        NEXT
        FOR x = 0 to cdx
            IF ctl[x].dlg = 1 THEN
                FPRINT FP_WRITE, SPACE$(gAlign * 1), "CONST IDC_", UCASE$(ctl[x].type$), " = ", ctl[x].id$
            ELSE
                FPRINT FP_WRITE, SPACE$(gAlign * 1), "CONST IDC_FORM", TRIM$(STR$(ctl[x].dlg)), "_", UCASE$(ctl[x].type$), " = ", ctl[x].id$
            END IF
        NEXT
        FPRINT FP_WRITE, ""

        EmitComment(FP_WRITE, 1, "Global Variables (Dialog/Control Handles)")
        FPRINT FP_WRITE, SPACE$(gAlign * 1), "GLOBAL hInstance AS HINSTANCE"
        IF gRichEd1 or gRichEd2 THEN
            FPRINT FP_WRITE, SPACE$(gAlign * 1), "GLOBAL dllRich AS HMODULE"
        END IF
        FOR x = 0 to ddx
            FPRINT FP_WRITE, SPACE$(gAlign * 1), "GLOBAL Form", TRIM$(STR$(x + 1)), " AS HWND"
        NEXT
        FOR x = 0 to cdx
            IF ctl[x].dlg = 1 THEN
                FPRINT FP_WRITE, SPACE$(gAlign * 1), "GLOBAL ", ctl[x].type$, " AS HWND"
            ELSE
                FPRINT FP_WRITE, SPACE$(gAlign * 1), "GLOBAL Form", TRIM$(STR$(ctl[x].dlg)), "_", ctl[x].type$, " AS HWND"
            END IF
        NEXT
        FPRINT FP_WRITE, ""

        IF gSubclass THEN
            EmitComment(FP_WRITE, 1, "Global Proc Variables")
            FOR x = 0 to cdx
                IF ctl[x].dlg = 1 THEN
                    FPRINT FP_WRITE, SPACE$(gAlign * 1), "GLOBAL lp", ctl[x].type$, "_Proc AS FARPROC"
                ELSE
                    FPRINT FP_WRITE, SPACE$(gAlign * 1), "GLOBAL lpForm", TRIM$(STR$(ctl[x].dlg)), "_", ctl[x].type$, "_Proc AS FARPROC"
                END IF
            NEXT
            FPRINT FP_WRITE, ""
        END IF
        FPRINT FP_WRITE, ""

        EmitMain(FP_WRITE)

        FOR x = 0 to ddx
            EmitDlgProc(FP_WRITE, x + 1)
        NEXT

        FOR x = 0 to cdx
            EmitControlProc(FP_WRITE, ctl[x].type$, ctl[x].dlg)
        NEXT

        EmitUtilities(FP_WRITE)
    CLOSE FP_WRITE
END SUB


SUB ProcessDialog(szFile$)
    DIM iDialog
    DIM fContents$
    DIM fBuffer$
    DIM inDialog
    DIM bDialog

    cdx = -1
    ddx = -1
    OPEN szFile$ FOR INPUT AS FP_DLG
    PrintStatus(" - loading dialog file", CRLF)
    WHILE NOT EOF(FP_DLG)
        LINE INPUT FP_DLG, fContents$
        fContents$ = TRIM$(fContents$)

        fBuffer$ = fBuffer$ & " "
        fBuffer$ = fBuffer$ & fContents$

        IF RIGHT$(fContents$, 1) <> "|" and RIGHT$(fContents$, 1) <> "," and RIGHT$(LCASE$(fContents$), 3) <> "not" and RIGHT$(LCASE$(fContents$), 2) <> "or" THEN
            fBuffer$ = TRIM$(fBuffer$)
            Parse(fBuffer$)

            IF LCASE$(Stk$[2]) = "dialog" THEN
                INCR iDialog
                INCR ddx
                bDialog = TRUE

                PrintStatus(" - found form", NOCR)
                PrintStatus(TRIM$(STR$(iDialog)), CRLF)

                frm[ddx].id$ = Stk$[1]

                ' reset control counter
                iCheck      = 0
                iRadio      = 0
                iCombo      = 0
                iControl    = 0
                iStatic     = 0
                iButton     = 0
                iEdit       = 0
                iGroup      = 0
                iIcon       = 0
                iList       = 0
                iVScroll    = 0
                iHScroll    = 0
                iFrame      = 0
                iRect       = 0
                iRich       = 0
                iRebar      = 0
                iHotkey     = 0
                iHeader     = 0
                iProgress   = 0
                iCalendar   = 0
                iAnimate    = 0
                iStatus     = 0
                iToolbar    = 0
                iPager      = 0
                iTrackbar   = 0
                iUpDown     = 0
                iComboBoxEx = 0
                iDatePicker = 0
                iIP         = 0
                iListview   = 0
                iTooltips   = 0
                iTab        = 0
                iTreeview   = 0
            END IF

            IF LCASE$(Stk$[1]) = "begin" THEN
                IF bDialog = TRUE THEN
                    inDialog = TRUE
                    bDialog = FALSE
                END IF
            END IF

            IF LCASE$(Stk$[1]) = "end" THEN
                inDialog = FALSE
            END IF

            IF inDialog = TRUE THEN
                INCR cdx
                ProcessControl(iDialog, fBuffer$)
            END IF

            fBuffer$ = ""
        END IF
    WEND
    CLOSE FP_DLG
END SUB


SUB ProcessControl(iDialog, fBuffer$)
    DIM SHARED iCheck
    DIM SHARED iRadio
    DIM SHARED iCombo
    DIM SHARED iControl
    DIM SHARED iStatic
    DIM SHARED iButton
    DIM SHARED iEdit
    DIM SHARED iGroup
    DIM SHARED iIcon
    DIM SHARED iList
    DIM SHARED iVScroll
    DIM SHARED iHScroll
    DIM SHARED iFrame
    DIM SHARED iRect
    DIM SHARED iRich
    DIM SHARED iRebar
    DIM SHARED iHotkey
    DIM SHARED iHeader
    DIM SHARED iProgress
    DIM SHARED iCalendar
    DIM SHARED iAnimate
    DIM SHARED iStatus
    DIM SHARED iToolbar
    DIM SHARED iPager
    DIM SHARED iTrackbar
    DIM SHARED iUpDown
    DIM SHARED iComboBoxEx
    DIM SHARED iDatePicker
    DIM SHARED iIP
    DIM SHARED iListview
    DIM SHARED iTooltips
    DIM SHARED iTab
    DIM SHARED iTreeview
    DIM SHARED iControl

    ctl[cdx].dlg = iDialog
    SELECT CASE LCASE$(Stk$[1])
    CASE "auto3state", "autocheckbox", "checkbox", "state3"
        INCR iCheck
        ctl[cdx].type$ = "CheckBox" & TRIM$(STR$(iCheck))
        ctl[cdx].id$ = Stk$[4]
    CASE "autoradiobutton", "radiobutton"
        INCR iRadio
        ctl[cdx].type$ = "Radio" & TRIM$(STR$(iRadio))
        ctl[cdx].id$ = Stk$[4]
    CASE "combobox"
        INCR iCombo
        ctl[cdx].type$ = "ComboBox" & TRIM$(STR$(iCombo))
        ctl[cdx].id$ = Stk$[2]
    CASE "control"
        SELECT CASE RQlow$(Stk$[6])
        CASE "richedit"
            gRichEd1 = TRUE
            INCR iRich
            ctl[cdx].type$ = "RichEdit" & TRIM$(STR$(iRich))
            ctl[cdx].id$ = Stk$[4]
        CASE "richedit20w", "richedit20a", "richedit_class"
            gRichEd2 = TRUE
            INCR iRich
            ctl[cdx].type$ = "RichEdit" & TRIM$(STR$(iRich))
            ctl[cdx].id$ = Stk$[4]
        CASE "rebarwindow32", "rebarclassname"
            gCommon = TRUE
            INCR iRebar
            ctl[cdx].type$ = "Rebar" & TRIM$(STR$(iRebar))
            ctl[cdx].id$ = Stk$[4]
        CASE "msctls_hotkey32", "hotkey_class"
            gCommon = TRUE
            INCR iHotkey
            ctl[cdx].type$ = "Hotkey" & TRIM$(STR$(iHotkey))
            ctl[cdx].id$ = Stk$[4]
        CASE "sysheader32", "wc_header"
            gCommon = TRUE
            INCR iHeader
            ctl[cdx].type$ = "Header" & TRIM$(STR$(iHeader))
            ctl[cdx].id$ = Stk$[4]
        CASE "msctls_progress32", "progress_class"
            gCommon = TRUE
            INCR iProgress
            ctl[cdx].type$ = "Progress" & TRIM$(STR$(iProgress))
            ctl[cdx].id$ = Stk$[4]
        CASE "sysmonthcal32", "monthcal_class"
            gCommon = TRUE
            INCR iCalendar
            ctl[cdx].type$ = "Calendar" & TRIM$(STR$(iCalendar))
            ctl[cdx].id$ = Stk$[4]
        CASE "sysanimate32", "animate_class"
            gCommon = TRUE
            INCR iAnimate
            ctl[cdx].type$ = "Animate" & TRIM$(STR$(iAnimate))
            ctl[cdx].id$ = Stk$[4]
        CASE "msctls_statusbar32", "statusclassname"
            gCommon = TRUE
            INCR iStatus
            ctl[cdx].type$ = "Status" & TRIM$(STR$(iStatus))
            ctl[cdx].id$ = Stk$[4]
        CASE "toolbarwindow32", "toolbarclassname"
            gCommon = TRUE
            INCR iToolbar
            ctl[cdx].type$ = "Toolbar" & TRIM$(STR$(iToolbar))
            ctl[cdx].id$ = Stk$[4]
        CASE "syspager", "wc_pagescroller"
            gCommon = TRUE
            INCR iPager
            ctl[cdx].type$ = "Pager" & TRIM$(STR$(iPager))
            ctl[cdx].id$ = Stk$[4]
        CASE "msctls_trackbar32", "trackbar_class"
            gCommon = TRUE
            INCR iTrackbar
            ctl[cdx].type$ = "Trackbar" & TRIM$(STR$(iTrackbar))
            ctl[cdx].id$ = Stk$[4]
        CASE "msctls_updown32", "updown_class"
            gCommon = TRUE
            INCR iUpDown
            ctl[cdx].type$ = "UpDown" & TRIM$(STR$(iUpDown))
            ctl[cdx].id$ = Stk$[4]
        CASE "comboboxex32", "wc_comboboxex"
            gCommon = TRUE
            INCR iComboBoxEx
            ctl[cdx].type$ = "ComboBoxEx" & TRIM$(STR$(iComboBoxEx))
            ctl[cdx].id$ = Stk$[4]
        CASE "sysdatetimepick32", "datetimepick_class"
            gCommon = TRUE
            INCR iDatePicker
            ctl[cdx].type$ = "DatePicker" & TRIM$(STR$(iDatePicker))
            ctl[cdx].id$ = Stk$[4]
        CASE "sysipaddress32", "wc_ipaddress"
            gCommon = TRUE
            INCR iIP
            ctl[cdx].type$ = "IPAddress" & TRIM$(STR$(iIP))
            ctl[cdx].id$ = Stk$[4]
        CASE "syslistview32", "wc_listview"
            gCommon = TRUE
            INCR iListview
            ctl[cdx].type$ = "ListView" & TRIM$(STR$(iListview))
            ctl[cdx].id$ = Stk$[4]
        CASE "tooltips_class32", "tooltips_class"
            gCommon = TRUE
            INCR iTooltips
            ctl[cdx].type$ = "Tooltips" & TRIM$(STR$(iTooltips))
            ctl[cdx].id$ = Stk$[4]
        CASE "systabcontrol32", "wc_tabcontrol"
            gCommon = TRUE
            INCR iTab
            ctl[cdx].type$ = "Tab" & TRIM$(STR$(iTab))
            ctl[cdx].id$ = Stk$[4]
        CASE "systreeview32", "wc_treeview"
            gCommon = TRUE
            INCR iTreeview
            ctl[cdx].type$ = "TreeView" & TRIM$(STR$(iTreeview))
            ctl[cdx].id$ = Stk$[4]
        CASE "button"
            IF INSTR(LCASE$(fBuffer$), "bs_autocheckbox") or INSTR(LCASE$(fBuffer$), "bs_auto3state") or INSTR(LCASE$(fBuffer$), "bs_3state") THEN
                INCR iCheck
                ctl[cdx].type$ = "CheckBox" & TRIM$(STR$(iCheck))
            ELSEIF INSTR(LCASE$(fBuffer$), "bs_autoradiobutton") THEN
                INCR iRadio
                ctl[cdx].type$ = "Radio" & TRIM$(STR$(iRadio))
            ELSE
                INCR iButton
                ctl[cdx].type$ = "Button" & TRIM$(STR$(iButton))
            END IF
            ctl[cdx].id$ = Stk$[4]
        CASE "combobox"
            INCR iCombo
            ctl[cdx].type$ = "ComboBox" & TRIM$(STR$(iCombo))
            ctl[cdx].id$ = Stk$[4]
        CASE "edit"
            INCR iEdit
            ctl[cdx].type$ = "Edit" & TRIM$(STR$(iEdit))
            ctl[cdx].id$ = Stk$[4]
        CASE "listbox"
            INCR iList
            ctl[cdx].type$ = "ListBox" & TRIM$(STR$(iList))
            ctl[cdx].id$ = Stk$[4]
        CASE "scrollbar"
            ctl[cdx].id$ = Stk$[4]
            IF INSTR(LCASE$(fBuffer$), "sbs_vert") THEN
                INCR iVScroll
                ctl[cdx].type$ = "VScroll" & TRIM$(STR$(iVScroll))
            ELSE
                INCR iHScroll
                ctl[cdx].type$ = "HScroll" & TRIM$(STR$(iHScroll))
            END IF
        CASE "static"
            IF INSTR(LCASE$(fBuffer$), "ss_blackframe") or INSTR(LCASE$(fBuffer$), "ss_grayframe") THEN
                INCR iFrame
                ctl[cdx].type$ = "Frame" & TRIM$(STR$(iFrame))
            ELSEIF INSTR(LCASE$(fBuffer$), "ss_whiterect") or INSTR(LCASE$(fBuffer$), "ss_grayrect") or INSTR(LCASE$(fBuffer$), "ss_blackrect") THEN
                INCR iRect
                ctl[cdx].type$ = "Rect" & TRIM$(STR$(iRect))
            ELSE
                INCR iStatic
                ctl[cdx].type$ = "Static" & TRIM$(STR$(iStatic))
            END IF
            ctl[cdx].id$ = Stk$[4]
        CASE ELSE
            INCR iControl
            ctl[cdx].type$ = "Control" & TRIM$(STR$(iControl))
            ctl[cdx].id$ = Stk$[4]
        END SELECT
    CASE "ctext", "ltext", "rtext"
        INCR iStatic
        ctl[cdx].type$ = "Static" & TRIM$(STR$(iStatic))
        ctl[cdx].id$ = Stk$[4]
    CASE "defpushbutton", "pushbox", "pushbutton"
        INCR iButton
        ctl[cdx].type$ = "Button" & TRIM$(STR$(iButton))
        ctl[cdx].id$ = Stk$[4]
    CASE "edittext"
        INCR iEdit
        ctl[cdx].type$ = "Edit" & TRIM$(STR$(iEdit))
        ctl[cdx].id$ = Stk$[2]
    CASE "groupbox"
        INCR iGroup
        ctl[cdx].type$ = "Group" & TRIM$(STR$(iGroup))
        ctl[cdx].id$ = Stk$[4]
    CASE "icon"
        INCR iIcon
        ctl[cdx].type$ = "Icon" & TRIM$(STR$(iIcon))
        ctl[cdx].id$ = Stk$[4]
    CASE "listbox"
        INCR iList
        ctl[cdx].type$ = "ListBox" & TRIM$(STR$(iList))
        ctl[cdx].id$ = Stk$[2]
    CASE "scrollbar"
        ctl[cdx].id$ = Stk$[4]
        IF INSTR(LCASE$(fBuffer$), "sbs_vert") THEN
            INCR iVScroll
            ctl[cdx].type$ = "VScroll" & TRIM$(STR$(iVScroll))
        ELSE
            INCR iHScroll
            ctl[cdx].type$ = "HScroll" & TRIM$(STR$(iHScroll))
        END IF
    CASE ELSE
        DECR cdx
    END SELECT

    IF TRIM$(ctl[cdx].type$) <> "" THEN
        PrintStatus(" - found form", NOCR)
        PrintStatus(TRIM$(STR$(iDialog)), NOCR)
        PrintStatus(".", NOCR)
        PrintStatus(LCASE$(ctl[cdx].type$), CRLF)
    END IF
END SUB


SUB PrintStatus(szString$, iCRLF)
    IF gStatus = TRUE THEN
        IF iCRLF = TRUE THEN
            PRINT szString$
        ELSE
            PRINT szString$;
        END IF
    END IF
END SUB


SUB EmitMain(FP@)
    DIM x

    FPRINT FP, SPACE$(gAlign * 0), "FUNCTION WinMain()"
    EmitComment(FP, 1, "Gives global access to hInstance")
    FPRINT FP, SPACE$(gAlign * 1), "hInstance = hInst"
    FPRINT FP, ""

    IF gCommon OR gRichEd1 OR gRichEd2 THEN
        EmitComment(FP, 1, "Intialize extra controls")
    END IF

    IF gCommon THEN
        FPRINT FP, SPACE$(gAlign * 1), "InitCommonControls()"
    END IF

    IF gRichEd1 THEN
        FPRINT FP, SPACE$(gAlign * 1), "dllRich = LoadLibrary(", CHR$(34), "riched32.dll", CHR$(34), ")"
    END IF

    IF gRichEd2 THEN
        FPRINT FP, SPACE$(gAlign * 1), "dllRich = LoadLibrary(", CHR$(34), "riched20.dll", CHR$(34), ")"
    END IF

    IF gCommon OR gRichEd1 OR gRichEd2 THEN
        FPRINT FP, ""
    END IF

    EmitComment(FP, 1, "Intialize our dialog, pointing it to the dialog procedure")
    FOR x = 0 to ddx
        FPRINT FP, SPACE$(gAlign * 1), "DialogBox(hInst, MAKEINTRESOURCE(IDD_FORM", TRIM$(STR$(x + 1)), "), NULL, (DLGPROC) Form", TRIM$(STR$(x + 1)), "_Proc)"
    NEXT
    FPRINT FP, ""

    IF gRichEd1 or gRichEd2 THEN
        EmitComment(FP, 1, "Remove RichEdit module from memory")
        FPRINT FP, SPACE$(gAlign * 1), "FreeLibrary(dllRich)"
        FPRINT FP, ""
    END IF

    FPRINT FP, SPACE$(gAlign * 1), "FUNCTION = FALSE"
    FPRINT FP, SPACE$(gAlign * 0), "END FUNCTION"
    FPRINT FP, ""
    FPRINT FP, ""
END SUB


SUB EmitDlgProc(FP@, iDialog)
    DIM x

    FPRINT FP, SPACE$(gAlign * 0), "CALLBACK FUNCTION Form", TRIM$(STR$(iDialog)), "_Proc()"
    FPRINT FP, SPACE$(gAlign * 1), "SELECT CASE Msg"
    EmitSeperator(FP)
    FPRINT FP, SPACE$(gAlign * 1), "CASE WM_INITDIALOG"
    EmitSeperator(FP)
    EmitComment(FP, 2, "Retrieves the dialog/control handles")
    FPRINT FP, SPACE$(gAlign * 2), "Form", TRIM$(STR$(iDialog)), " = hWnd"
    FOR x = 0 to cdx
        IF ctl[x].dlg = iDialog THEN
            IF ctl[x].dlg = 1 THEN
                FPRINT FP, SPACE$(gAlign * 2), ctl[x].type$, " = GetDlgItem(hWnd, IDC_", UCASE$(ctl[x].type$), ")"
            ELSE
                FPRINT FP, SPACE$(gAlign * 2), "Form", TRIM$(STR$(ctl[x].dlg)), "_", ctl[x].type$, " = GetDlgItem(hWnd, IDC_FORM", TRIM$(STR$(ctl[x].dlg)), "_", UCASE$(ctl[x].type$), ")"
            END IF
        END IF
    NEXT
    FPRINT FP, ""

    IF gSubclass THEN
        EmitComment(FP, 2, "Give controls seperate proc functions")
        FOR x = 0 to cdx
            IF ctl[x].dlg = iDialog THEN
                IF ctl[x].dlg = 1 THEN
                    FPRINT FP, SPACE$(gAlign * 2), "lp", ctl[x].type$, "_Proc = SubclassWindow(", ctl[x].type$, ", ", ctl[x].type$, "_Proc)"
                ELSE
                    FPRINT FP, SPACE$(gAlign * 2), "lpForm", TRIM$(STR$(ctl[x].dlg)), "_", ctl[x].type$, "_Proc = SubclassWindow(Form", TRIM$(STR$(ctl[x].dlg)), "_", ctl[x].type$, ", Form", TRIM$(STR$(ctl[x].dlg)), "_", ctl[x].type$, "_Proc)"
                END IF
            END IF
        NEXT
        FPRINT FP, ""
    END IF

    EmitComment(FP, 2, "Set other window properties")
    FPRINT FP, SPACE$(gAlign * 2), "CenterWindow(hWnd)"
    FPRINT FP, ""
    EmitSeperator(FP)
    FPRINT FP, SPACE$(gAlign * 1), "CASE WM_CLOSE"
    EmitSeperator(FP)
    EmitComment(FP, 2, "Free our dialog")
    FPRINT FP, SPACE$(gAlign * 2), "EndDialog(hWnd, TRUE)"
    FPRINT FP, ""
    EmitSeperator(FP)
    FPRINT FP, SPACE$(gAlign * 1), "CASE ELSE"
    EmitSeperator(FP)
    EmitComment(FP, 2, "No messages processed, return false")
    FPRINT FP, SPACE$(gAlign * 2), "FUNCTION = FALSE"
    FPRINT FP, SPACE$(gAlign * 1), "END SELECT"
    FPRINT FP, ""
    EmitComment(FP, 1, "If we reach this point, that means a message was processed")
    EmitComment(FP, 1, "and we send a true value")
    FPRINT FP, SPACE$(gAlign * 1), "FUNCTION = TRUE"
    FPRINT FP, SPACE$(gAlign * 0), "END FUNCTION"
    FPRINT FP, ""
    FPRINT FP, ""
END SUB


SUB EmitControlProc(FP@, szControl$, iDialog)
    IF gSubclass THEN
        IF iDialog =1 THEN
            FPRINT FP, SPACE$(gAlign * 0), "CALLBACK FUNCTION ", szControl$, "_Proc()"
        ELSE
            FPRINT FP, SPACE$(gAlign * 0), "CALLBACK FUNCTION Form", TRIM$(STR$(iDialog)), "_", szControl$, "_Proc()"
        END IF
        FPRINT FP, SPACE$(gAlign * 1), "SELECT CASE Msg"
        EmitSeperator(FP)
        FPRINT FP, SPACE$(gAlign * 1), "CASE WM_COMMAND"
        EmitSeperator(FP)
        EmitComment(FP, 2, "Your WM_COMMAND code")
        FPRINT FP, ""
        EmitSeperator(FP)
        FPRINT FP, SPACE$(gAlign * 1), "CASE WM_LBUTTONDBLCLK"
        EmitSeperator(FP)
        IF iDialog = 1 THEN
            FPRINT FP, SPACE$(gAlign * 2), "MSGBOX ", CHR$(34), szControl$, " Double Clicked!", CHR$(34)
        ELSE
            FPRINT FP, SPACE$(gAlign * 2), "MSGBOX ", CHR$(34), "Form", TRIM$(STR$(iDialog)), "_", szControl$, " Double Clicked!", CHR$(34)
        END IF
        FPRINT FP, ""
        EmitSeperator(FP)
        FPRINT FP, SPACE$(gAlign * 1), "CASE ELSE"
        EmitSeperator(FP)
        EmitComment(FP, 2, "No messages have been processed")
        IF iDialog = 1 THEN
            FPRINT FP, SPACE$(gAlign * 2), "FUNCTION = CallWindowProc(lp", szControl$, "_Proc, hWnd, Msg, wParam, lParam)"
        ELSE
            FPRINT FP, SPACE$(gAlign * 2), "FUNCTION = CallWindowProc(lpForm", TRIM$(STR$(iDialog)), "_", szControl$, "_Proc, hWnd, Msg, wParam, lParam)"
        END IF
        FPRINT FP, SPACE$(gAlign * 1), "END SELECT"
        FPRINT FP, ""
        EmitComment(FP, 1, "Default message has been processed")
        FPRINT FP, SPACE$(gAlign * 1), "FUNCTION = TRUE"
        FPRINT FP, SPACE$(gAlign * 0), "END FUNCTION"
        FPRINT FP, ""
        FPRINT FP, ""
    END IF
END SUB


SUB EmitUtilities(FP@)
    FPRINT FP, SPACE$(gAlign * 0), "SUB CenterWindow(hWnd AS HWND)"
    FPRINT FP, SPACE$(gAlign * 1), "STATIC wRect AS RECT"
    FPRINT FP, SPACE$(gAlign * 1), "STATIC x     AS DWORD"
    FPRINT FP, SPACE$(gAlign * 1), "STATIC y     AS DWORD"
    FPRINT FP, ""
    FPRINT FP, SPACE$(gAlign * 1), "GetWindowRect(hWnd, &wRect)"
    FPRINT FP, SPACE$(gAlign * 1), "x = (GetSystemMetrics(SM_CXSCREEN) - (wRect.right - wRect.left)) / 2"
    FPRINT FP, SPACE$(gAlign * 1), "y = (GetSystemMetrics(SM_CYSCREEN) - (wRect.bottom - wRect.top + _"
    FPRINT FP, SPACE$(gAlign * 1), "    GetSystemMetrics(SM_CYCAPTION))) / 2"
    FPRINT FP, SPACE$(gAlign * 1), "SetWindowPos(hWnd, NULL, x, y, 0, 0, SWP_NOSIZE OR SWP_NOZORDER)"
    FPRINT FP, SPACE$(gAlign * 0), "END SUB"
END SUB


SUB EmitSeperator(FP@)
    DIM szBuffer$

    IF gComments THEN
        szBuffer$ = REPEAT$(74, "*")
        FPRINT FP, "' ", szBuffer$
    END IF
END SUB


SUB EmitHeader(FP@)
    IF gComments THEN
        EmitSeperator(FP)
        FPRINT FP, "'", SPACE$(12), "BCX Source Code Generated Using Dialog Starter 1.0"
        FPRINT FP, "'", SPACE$(17), "For Use With BCX Translator Version 2.15+"
        EmitSeperator(FP)
        FPRINT FP, ""
    END IF
END SUB


SUB EmitComment(FP@, nCol, szComment$)
    IF gComments THEN
        FPRINT FP, SPACE$(gAlign * nCol), "' ", szComment$
    END IF
END SUB


SUB EmitLine(FP@, nCol, szLine$)
    FPRINT FP, SPACE$(gAlign * nCol), szLine$
END SUB


FUNCTION RQlow$(szString$)
    DIM szBuffer$

    szBuffer$ = LCASE$(TRIM$(szString$))
    IF LEFT$(szBuffer$, 1) = CHR$(34) THEN
        szBuffer$ = RIGHT$(szBuffer$, LEN(szBuffer$) - 1)
    END IF

    IF RIGHT$(szBuffer$, 1) = CHR$(34) THEN
        szBuffer$ = LEFT$(szBuffer$, LEN(szBuffer$) - 1)
    END IF

    FUNCTION = szBuffer$
END FUNCTION


SUB Parse (Arg$)
' ********************************************************************
    DIM SHARED Stk$[256]
    DIM SHARED Ndx
    LOCAL Char$, Counter, StrLit$, Anyword$
' ********************************************************************
    Ndx  = 0
    Arg$ = Trim$(Arg$)

    IF Arg$ = ""  THEN
        Ndx = 0
        EXIT SUB
    END IF
' ********************************************************************
    WHILE Counter < Len(Arg$)
        INCR Counter
        Char$ = MID$(Arg$, Counter, 1)
        SELECT CASE Char$
        CASE CHR$(34)     ' Identify string literals
' ********************************************************************
            StrLit$ = Char$
            Char$ = ""
            DO
                IF Char$ = CHR$(34) THEN EXIT LOOP
                INCR Counter
                IF Counter = LEN(Arg$) THEN
                    Char$ = MID$(Arg$, Counter, 1)
                    StrLit$ = StrLit$ & Char$
                    IF Char$ <> CHR$(34) THEN
                        StrLit$ = StrLit$ & CHR$(34) ' Allow unquoted end of string
                    END IF
                    EXIT LOOP
                END IF
                Char$ = MID$(Arg$, Counter, 1)
                StrLit$ = StrLit$ & Char$
            LOOP
            INCR Ndx
            Stk$[Ndx] = StrLit$
' ********************************************************************
        CASE " "
' ********************************************************************
            IF Anyword$ > "" THEN
                INCR Ndx
                Stk$[Ndx] = Anyword$
                Anyword$ = ""
            END IF
' ********************************************************************
        CASE "^", "[", "]" , "'", "(", ")", ",", "+", "-", _
             "*", "/", "=" , "?", "<", ">", ";", "|", "&", "#"
' ********************************************************************
            IF Anyword$ > "" THEN
                INCR Ndx
                Stk$[Ndx] = Anyword$
                Anyword$ = ""
            END IF
            INCR Ndx
            Stk$[Ndx] = Char$
        CASE ELSE
            Anyword$ = Anyword$ & MID$(Arg$, Counter, 1)
' ********************************************************************
        END SELECT
' ********************************************************************
    WEND

    IF Anyword$ > "" THEN
        INCR Ndx
        Stk$[Ndx] = Anyword$
    END IF
END SUB


FUNCTION IsQuoted(A$)
    IF LEFT$(A$, 1) = CHR$(34) THEN
        IF RIGHT$(A$, 1) = CHR$(34) THEN FUNCTION = TRUE
    END IF

    FUNCTION = FALSE
END FUNCTION
