' Dialog Starter 1.1 Beta 1
' Converts dialog resource scripts to BCX code.
' Unlike DC, which converts everything to BCX, DS simply
' creates a template so you can use the actual DLG file.
'
' Created by DL
' Parser by Kevin Diggins
'
' ********************** NOTES **********************
' A few things that are important to mention:
'   1) do not use a custom class name for dialogs
'   2) don't forget to compile your dialog as a
'      32-bit binary resource when your done
'   3) enjoy
'
' 04/08/2001
' - First Release
'
' 10/13/2001
' - Replaced Parse with new parser in BCX 2.68
' - Made PrintStatus have an optional no CRLF
' - Added support for DialogEx
' - Kinda added support for non-numeric IDs
' - Kinda supports other resource editors
' - Tried to speed up/clean up code
' - Default spacing is now 2 (smaller output file)
' - Removed alignment restrictions
' - Removed C code
'
' TODO
' - cleanup & comment
' ********************** NOTES **********************

  CONST NOCR = TRUE

  GLOBAL gComments
  GLOBAL gSubclass
  GLOBAL gAlign
  GLOBAL gStatus
  GLOBAL gHelp
  GLOBAL gRichEd1
  GLOBAL gRichEd2
  GLOBAL gCommon
  GLOBAL IncStk$[50]
  GLOBAL IncNdx

  TYPE form
      id$[30]
  END TYPE

  TYPE control
    type$[30]
    id$[30]
    dlg AS INTEGER
  END TYPE

  DIM szFile$
  DIM szTemp$
  DIM szOutput$
  DIM x
  DIM Chr_34$
  DIM argLen

  Chr_34$ = CHR$(34)

  IncNdx = -1
  gAlign = 2
  gComments = TRUE
  gSubclass = FALSE
  gStatus   = FALSE

  IF argc > 1 THEN
    ' Check for any user options
    FOR x = 1 TO argc - 1
      argLen = LEN(argv$[x])
      IF argLen >= 2 THEN
        SELECT CASE LCASE$(RIGHT$(argv$[x], argLen - 1))
        CASE "s" : gStatus   = TRUE
        CASE "c" : gSubclass = TRUE
        CASE "k" : gComments = TRUE
        CASE "?" : gHelp     = TRUE
        CASE ELSE
          ' Get the requested alignment size
          IF LCASE$(MID$(argv$[x], 2, 1)) = "a" THEN
            gAlign = VAL(RIGHT$(argv$[x], argLen - 2))
          END IF
        END SELECT
      END IF
    NEXT

    ' Get file name
    szTemp$ = argv$[1]
  END IF

  IF szTemp$ = "" THEN gHelp = TRUE
  IF LOF(szTemp$) = -1 THEN       ' check if file exists
    szFile$ = szTemp$ & ".dlg"    ' file doesn't exist, add ext

    IF LOF(szFile$) = -1 THEN
      szFile$ = argv$[1] & ".rc"
    END IF
  ELSE
    szFile$ = szTemp$             ' file exists, leave it alone
  END IF

  ' create output .tmp file name
  szOutput$ = LCASE$(szFile$)

  ' remove file ext
  IF RIGHT$(szOutput$, 4) = ".dlg" THEN
    szOutput$ = LEFT$(szOutput$, LEN(szOutput) - 4)
  ELSEIF RIGHT$(szOutput$, 3) = ".rc" THEN
    szOutput$ = LEFT$(szOutput$, LEN(szOutput) - 3)
  END IF

  szOutput$ = szOutput$ & ".bas"

  ' check final orders (help or if file exists)
  IF gHelp = TRUE THEN
    PRINT "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
    PRINT "³ Dialog Starter 1.1 beta 1                                          ³"
    PRINT "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
    PRINT "³ Converts dialog resource scripts to BCX BASIC source code.         ³"
    PRINT "³ ds [drive:][path]filename[.dlg] [/k] [/s] [/c] [/?] [a#]           ³"
    PRINT "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
    PRINT "³ [drive:][path]filename[.dlg]                                       ³"
    PRINT "³ Specifies the file that you would like to convert.                 ³"
    PRINT "³ The drive, path, and dlg extension are optional.                   ³"
    PRINT "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
    PRINT "³ /k   Remove comments from source code.                             ³"
    PRINT "³ /s   Displays status while converting scripts.                     ³"
    PRINT "³ /c   Adds control subclass to source code.                         ³"
    PRINT "³ /?   Displays meanings of arguments.                               ³"
    PRINT "³ /a#  # Represents spacing alignment. Default is 2.                 ³"
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

    IF IncNdx <> -1 THEN
      EmitComment(FP_WRITE, 0, "User defined C headers")
      FOR x = 0 TO IncNdx
        FPRINT FP_WRITE, IncStk$[IncNdx]
      NEXT
      FPRINT FP_WRITE, ""
    END IF

    EmitComment(FP_WRITE, 0, "Global Constants (Dialog/Control IDs)")
    FOR x = 0 to ddx
      szTemp$ = "IDD_FORM" & TrimNum$(x + 1)
      IF LCASE$(szTemp$) <> LCASE$(TRIM$(frm[x].id$)) THEN
        FPRINT FP_WRITE, "CONST ", szTemp$, " = ", frm[x].id$
      END IF
    NEXT

    FOR x = 0 to cdx
      IF ctl[x].dlg = 1 THEN
        szTemp$ = "IDC_" & UCASE$(ctl[x].type$)

        IF LCASE$(szTemp$) <> LCASE$(TRIM$(ctl[x].id$)) THEN
          FPRINT FP_WRITE, "CONST ", szTemp$, " = ", ctl[x].id$
        END IF
      ELSE
        szTemp$ = "IDC_FORM" & TrimNum$(ctl[x].dlg) & "_" & UCASE$(ctl[x].type$)

        IF LCASE$(szTemp$) <> LCASE$(TRIM$(ctl[x].id$)) THEN
          FPRINT FP_WRITE, "CONST ", szTemp$, " = ", ctl[x].id$
        END IF
      END IF
    NEXT
    FPRINT FP_WRITE, ""

    EmitComment(FP_WRITE, 0, "Global Variables (Dialog/Control Handles)")
    FPRINT FP_WRITE, "GLOBAL hInstance AS HINSTANCE"
    IF gRichEd1 or gRichEd2 THEN
      FPRINT FP_WRITE, "GLOBAL dllRich AS HMODULE"
    END IF
    FOR x = 0 to ddx
      FPRINT FP_WRITE, "GLOBAL Form", TrimNum$(x + 1), " AS HWND"
    NEXT
    FOR x = 0 to cdx
      IF ctl[x].dlg = 1 THEN
        FPRINT FP_WRITE, "GLOBAL ", ctl[x].type$, " AS HWND"
      ELSE
        FPRINT FP_WRITE, "GLOBAL Form", TrimNum$(ctl[x].dlg), "_", ctl[x].type$, " AS HWND"
      END IF
    NEXT
    FPRINT FP_WRITE, ""

    IF gSubclass THEN
      EmitComment(FP_WRITE, 0, "Global Proc Variables")
      FOR x = 0 to cdx
        IF ctl[x].dlg = 1 THEN
          FPRINT FP_WRITE, "GLOBAL lp", ctl[x].type$, "_Proc AS WNDPROC"
        ELSE
          FPRINT FP_WRITE, "GLOBAL lpForm", TrimNum$(ctl[x].dlg), "_", ctl[x].type$, "_Proc AS WNDPROC"
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
  DIM InsideComments

  cdx = -1
  ddx = -1
  OPEN szFile$ FOR INPUT AS FP_DLG
  PrintStatus(" - loading dialog file")
  WHILE NOT EOF(FP_DLG)
    LINE INPUT FP_DLG, fContents$
    fContents$ = TRIM$(fContents$)

    fBuffer$ = fBuffer$ & fContents$

    IF RIGHT$(fContents$, 1) <> "|" AND RIGHT$(fContents$, 1) <> "," AND _
      RIGHT$(LCASE$(fContents$), 3) <> "not" AND _
      RIGHT$(LCASE$(fContents$), 2) <> "or"  AND _
      LEN(fContents$) THEN

      IF LEFT$(fBuffer$, 2) = "//" THEN GOTO SkipProcess
      IF LEFT$(fBuffer$, 2) = "/*" THEN
        InsideComments = TRUE
      END IF

      IF RIGHT$(fBuffer$, 2) = "*/" THEN
        InsideComments = FALSE
        GOTO SkipProcess
      END IF

      IF InsideComments = TRUE THEN GOTO SkipProcess

      fBuffer$ = TRIM$(fBuffer$)
      Parse(fBuffer$)

      IF Ndx >= 2 AND LCASE$(Stk$[1]) = "#include" THEN
        IF LOF(RQlow$(Stk$[2])) <> -1 THEN
          INCR IncNdx

          IncStk$[IncNdx] = "#include " & Stk$[2]
        END IF
      END IF

      IF Ndx >= 9 AND LCASE$(Stk$[2]) = "dialog" OR LCASE$(Stk$[2]) = "dialogex" THEN
        INCR iDialog
        INCR ddx
        bDialog = TRUE
        PrintStatus(" - found form", NOCR)
        PrintStatus(TrimNum$(iDialog))

        frm[ddx].id$ = Stk$[1]

        ' reset control counter
        iCheck      = iRadio      = iCombo      = iControl    = 0
        iStatic     = iButton     = iEdit       = iGroup      = 0
        iIcon       = iList       = iVScroll    = iHScroll    = 0
        iFrame      = iRect       = iRich       = iRebar      = 0
        iHotkey     = iHeader     = iProgress   = iCalendar   = 0
        iAnimate    = iStatus     = iToolbar    = iPager      = 0
        iTrackbar   = iUpDown     = iComboBoxEx = iDatePicker = 0
        iIP         = iListview   = iTooltips   = 0
        iTab        = iTreeview   = 0
      END IF

      IF LCASE$(Stk$[1]) = "begin" OR Stk$[2] = "{" THEN
        IF bDialog = TRUE THEN
          inDialog = TRUE
          bDialog = FALSE
        END IF
      END IF

      IF LCASE$(Stk$[1]) = "end" OR Stk$[1] = "}" THEN
        inDialog = FALSE
      END IF

      IF inDialog = TRUE THEN
        INCR cdx
        ProcessControl(iDialog, fBuffer$)
      END IF

SkipProcess:
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
    ctl[cdx].type$ = "CheckBox" & TrimNum$(iCheck)
    ctl[cdx].id$ = Stk$[4]
  CASE "autoradiobutton", "radiobutton"
    INCR iRadio
    ctl[cdx].type$ = "Radio" & TrimNum$(iRadio)
    ctl[cdx].id$ = Stk$[4]
  CASE "combobox"
    INCR iCombo
    ctl[cdx].type$ = "ComboBox" & TrimNum$(iCombo)
    ctl[cdx].id$ = Stk$[2]
  CASE "control"
    SELECT CASE RQlow$(Stk$[6])
    CASE "richedit"
      gRichEd1 = TRUE
      INCR iRich
      ctl[cdx].type$ = "RichEdit" & TrimNum$(iRich)
      ctl[cdx].id$ = Stk$[4]
    CASE "richedit20w", "richedit20a", "richedit_class"
      gRichEd2 = TRUE
      INCR iRich
      ctl[cdx].type$ = "RichEdit" & TrimNum$(iRich)
      ctl[cdx].id$ = Stk$[4]
    CASE "rebarwindow32", "rebarclassname"
      gCommon = TRUE
      INCR iRebar
      ctl[cdx].type$ = "Rebar" & TrimNum$(iRebar)
      ctl[cdx].id$ = Stk$[4]
    CASE "msctls_hotkey32", "hotkey_class"
      gCommon = TRUE
      INCR iHotkey
      ctl[cdx].type$ = "Hotkey" & TrimNum$(iHotkey)
      ctl[cdx].id$ = Stk$[4]
    CASE "sysheader32", "wc_header"
      gCommon = TRUE
      INCR iHeader
      ctl[cdx].type$ = "Header" & TrimNum$(iHeader)
      ctl[cdx].id$ = Stk$[4]
    CASE "msctls_progress32", "progress_class"
      gCommon = TRUE
      INCR iProgress
      ctl[cdx].type$ = "Progress" & TrimNum$(iProgress)
      ctl[cdx].id$ = Stk$[4]
    CASE "sysmonthcal32", "monthcal_class"
      gCommon = TRUE
      INCR iCalendar
      ctl[cdx].type$ = "Calendar" & TrimNum$(iCalendar)
      ctl[cdx].id$ = Stk$[4]
    CASE "sysanimate32", "animate_class"
      gCommon = TRUE
      INCR iAnimate
      ctl[cdx].type$ = "Animate" & TrimNum$(iAnimate)
      ctl[cdx].id$ = Stk$[4]
    CASE "msctls_statusbar32", "statusclassname"
      gCommon = TRUE
      INCR iStatus
      ctl[cdx].type$ = "Status" & TrimNum$(iStatus)
      ctl[cdx].id$ = Stk$[4]
    CASE "toolbarwindow32", "toolbarclassname"
      gCommon = TRUE
      INCR iToolbar
      ctl[cdx].type$ = "Toolbar" & TrimNum$(iToolbar)
      ctl[cdx].id$ = Stk$[4]
    CASE "syspager", "wc_pagescroller"
      gCommon = TRUE
      INCR iPager
      ctl[cdx].type$ = "Pager" & TrimNum$(iPager)
      ctl[cdx].id$ = Stk$[4]
    CASE "msctls_trackbar32", "trackbar_class"
      gCommon = TRUE
      INCR iTrackbar
      ctl[cdx].type$ = "Trackbar" & TrimNum$(iTrackbar)
      ctl[cdx].id$ = Stk$[4]
    CASE "msctls_updown32", "updown_class"
      gCommon = TRUE
      INCR iUpDown
      ctl[cdx].type$ = "UpDown" & TrimNum$(iUpDown)
      ctl[cdx].id$ = Stk$[4]
    CASE "comboboxex32", "wc_comboboxex"
      gCommon = TRUE
      INCR iComboBoxEx
      ctl[cdx].type$ = "ComboBoxEx" & TrimNum$(iComboBoxEx)
      ctl[cdx].id$ = Stk$[4]
    CASE "sysdatetimepick32", "datetimepick_class"
      gCommon = TRUE
      INCR iDatePicker
      ctl[cdx].type$ = "DatePicker" & TrimNum$(iDatePicker)
      ctl[cdx].id$ = Stk$[4]
    CASE "sysipaddress32", "wc_ipaddress"
      gCommon = TRUE
      INCR iIP
      ctl[cdx].type$ = "IPAddress" & TrimNum$(iIP)
      ctl[cdx].id$ = Stk$[4]
    CASE "syslistview32", "wc_listview"
      gCommon = TRUE
      INCR iListview
      ctl[cdx].type$ = "ListView" & TrimNum$(iListview)
      ctl[cdx].id$ = Stk$[4]
    CASE "tooltips_class32", "tooltips_class"
      gCommon = TRUE
      INCR iTooltips
      ctl[cdx].type$ = "Tooltips" & TrimNum$(iTooltips)
      ctl[cdx].id$ = Stk$[4]
    CASE "systabcontrol32", "wc_tabcontrol"
      gCommon = TRUE
      INCR iTab
      ctl[cdx].type$ = "Tab" & TrimNum$(iTab)
      ctl[cdx].id$ = Stk$[4]
    CASE "systreeview32", "wc_treeview"
      gCommon = TRUE
      INCR iTreeview
      ctl[cdx].type$ = "TreeView" & TrimNum$(iTreeview)
      ctl[cdx].id$ = Stk$[4]
    CASE "button"
      IF INSTR(LCASE$(fBuffer$), "bs_autocheckbox") or INSTR(LCASE$(fBuffer$), "bs_auto3state") or INSTR(LCASE$(fBuffer$), "bs_3state") THEN
        INCR iCheck
        ctl[cdx].type$ = "CheckBox" & TrimNum$(iCheck)
      ELSEIF INSTR(LCASE$(fBuffer$), "bs_autoradiobutton") THEN
        INCR iRadio
        ctl[cdx].type$ = "Radio" & TrimNum$(iRadio)
      ELSE
        INCR iButton
        ctl[cdx].type$ = "Button" & TrimNum$(iButton)
      END IF
      ctl[cdx].id$ = Stk$[4]
    CASE "combobox"
      INCR iCombo
      ctl[cdx].type$ = "ComboBox" & TrimNum$(iCombo)
      ctl[cdx].id$ = Stk$[4]
    CASE "edit"
      INCR iEdit
      ctl[cdx].type$ = "Edit" & TrimNum$(iEdit)
      ctl[cdx].id$ = Stk$[4]
    CASE "listbox"
      INCR iList
      ctl[cdx].type$ = "ListBox" & TrimNum$(iList)
      ctl[cdx].id$ = Stk$[4]
    CASE "scrollbar"
      ctl[cdx].id$ = Stk$[4]
      IF INSTR(LCASE$(fBuffer$), "sbs_vert") THEN
        INCR iVScroll
        ctl[cdx].type$ = "VScroll" & TrimNum$(iVScroll)
      ELSE
        INCR iHScroll
        ctl[cdx].type$ = "HScroll" & TrimNum$(iHScroll)
      END IF
    CASE "static"
      IF INSTR(LCASE$(fBuffer$), "ss_blackframe") or INSTR(LCASE$(fBuffer$), "ss_grayframe") THEN
        INCR iFrame
        ctl[cdx].type$ = "Frame" & TrimNum$(iFrame)
      ELSEIF INSTR(LCASE$(fBuffer$), "ss_whiterect") or INSTR(LCASE$(fBuffer$), "ss_grayrect") or INSTR(LCASE$(fBuffer$), "ss_blackrect") THEN
        INCR iRect
        ctl[cdx].type$ = "Rect" & TrimNum$(iRect)
      ELSE
        INCR iStatic
        ctl[cdx].type$ = "Static" & TrimNum$(iStatic)
      END IF
      ctl[cdx].id$ = Stk$[4]
    CASE ELSE
      INCR iControl
      ctl[cdx].type$ = "Control" & TrimNum$(iControl)
      ctl[cdx].id$ = Stk$[4]
    END SELECT
  CASE "ctext", "ltext", "rtext"
    INCR iStatic
    ctl[cdx].type$ = "Static" & TrimNum$(iStatic)
    ctl[cdx].id$ = Stk$[4]
  CASE "defpushbutton", "pushbox", "pushbutton"
    INCR iButton
    ctl[cdx].type$ = "Button" & TrimNum$(iButton)
    ctl[cdx].id$ = Stk$[4]
  CASE "edittext"
    INCR iEdit
    ctl[cdx].type$ = "Edit" & TrimNum$(iEdit)
    ctl[cdx].id$ = Stk$[2]
  CASE "groupbox"
    INCR iGroup
    ctl[cdx].type$ = "Group" & TrimNum$(iGroup)
    ctl[cdx].id$ = Stk$[4]
  CASE "icon"
    INCR iIcon
    ctl[cdx].type$ = "Icon" & TrimNum$(iIcon)
    ctl[cdx].id$ = Stk$[4]
  CASE "listbox"
    INCR iList
    ctl[cdx].type$ = "ListBox" & TrimNum$(iList)
    ctl[cdx].id$ = Stk$[2]
  CASE "scrollbar"
    ctl[cdx].id$ = Stk$[4]
    IF INSTR(LCASE$(fBuffer$), "sbs_vert") THEN
      INCR iVScroll
      ctl[cdx].type$ = "VScroll" & TrimNum$(iVScroll)
    ELSE
      INCR iHScroll
      ctl[cdx].type$ = "HScroll" & TrimNum$(iHScroll)
    END IF
  CASE ELSE
    DECR cdx
  END SELECT

  IF TRIM$(ctl[cdx].type$) <> "" THEN
    PrintStatus(" - found form", NOCR)
    PrintStatus(TrimNum$(iDialog), NOCR)
    PrintStatus(".", NOCR)
    PrintStatus(LCASE$(ctl[cdx].type$))
  END IF
END SUB


SUB PrintStatus OPTIONAL(szString$, NoCrLf)
  IF gStatus = TRUE THEN
    IF NoCrLf = 0 THEN
      PRINT szString$
    ELSE
      PRINT szString$;
    END IF
  END IF
END SUB


SUB EmitMain(FP@)
  DIM x

  FPRINT FP, "FUNCTION WinMain()"
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
    FPRINT FP, SPACE$(gAlign * 1), "dllRich = LoadLibrary(", Chr_34$, "riched32.dll", Chr_34$, ")"
  END IF

  IF gRichEd2 THEN
    FPRINT FP, SPACE$(gAlign * 1), "dllRich = LoadLibrary(", Chr_34$, "riched20.dll", Chr_34$, ")"
  END IF

  IF gCommon OR gRichEd1 OR gRichEd2 THEN
    FPRINT FP, ""
  END IF

  EmitComment(FP, 1, "Initialize our dialog, pointing it to the dialog procedure")
  FOR x = 0 to ddx
    FPRINT FP, SPACE$(gAlign * 1), "DialogBox(hInst, MAKEINTRESOURCE(IDD_FORM", TrimNum$(x + 1), "), NULL, (DLGPROC) Form", TrimNum$(x + 1), "_Proc)"
  NEXT
  FPRINT FP, ""

  IF gRichEd1 or gRichEd2 THEN
    EmitComment(FP, 1, "Remove RichEdit module from memory")
    FPRINT FP, SPACE$(gAlign * 1), "FreeLibrary(dllRich)"
    FPRINT FP, ""
  END IF

  FPRINT FP, SPACE$(gAlign * 1), "FUNCTION = FALSE"
  FPRINT FP, "END FUNCTION"
  FPRINT FP, ""
  FPRINT FP, ""
END SUB


SUB EmitDlgProc(FP@, iDialog)
  DIM x

  FPRINT FP, "CALLBACK FUNCTION Form", TrimNum$(iDialog), "_Proc()"
  FPRINT FP, SPACE$(gAlign * 1), "SELECT CASE Msg"
  EmitSeperator(FP)
  FPRINT FP, SPACE$(gAlign * 1), "CASE WM_INITDIALOG"
  EmitSeperator(FP)
  EmitComment(FP, 2, "Retrieves the dialog/control handles")
  FPRINT FP, SPACE$(gAlign * 2), "Form", TrimNum$(iDialog), " = hWnd"
  FOR x = 0 to cdx
    IF ctl[x].dlg = iDialog THEN
      IF ctl[x].dlg = 1 THEN
        FPRINT FP, SPACE$(gAlign * 2), ctl[x].type$, " = GetDlgItem(hWnd, IDC_", UCASE$(ctl[x].type$), ")"
      ELSE
        FPRINT FP, SPACE$(gAlign * 2), "Form", TrimNum$(ctl[x].dlg), "_", ctl[x].type$, " = GetDlgItem(hWnd, IDC_FORM", TrimNum$(ctl[x].dlg), "_", UCASE$(ctl[x].type$), ")"
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
          FPRINT FP, SPACE$(gAlign * 2), "lpForm", TrimNum$(ctl[x].dlg), "_", ctl[x].type$, "_Proc = SubclassWindow(Form", TrimNum$(ctl[x].dlg), "_", ctl[x].type$, ", Form", TrimNum$(ctl[x].dlg), "_", ctl[x].type$, "_Proc)"
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
  FPRINT FP, "END FUNCTION"
  FPRINT FP, ""
  FPRINT FP, ""
END SUB


SUB EmitControlProc(FP@, szControl$, iDialog)
  IF gSubclass THEN
    IF iDialog =1 THEN
      FPRINT FP, "CALLBACK FUNCTION ", szControl$, "_Proc()"
    ELSE
      FPRINT FP, "CALLBACK FUNCTION Form", TrimNum$(iDialog), "_", szControl$, "_Proc()"
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
      FPRINT FP, SPACE$(gAlign * 2), "MSGBOX ", Chr_34$, szControl$, " Double Clicked!", Chr_34$
    ELSE
      FPRINT FP, SPACE$(gAlign * 2), "MSGBOX ", Chr_34$, "Form", TrimNum$(iDialog), "_", szControl$, " Double Clicked!", Chr_34$
    END IF
    FPRINT FP, ""
    EmitSeperator(FP)
    FPRINT FP, SPACE$(gAlign * 1), "CASE ELSE"
    EmitSeperator(FP)
    EmitComment(FP, 2, "No messages have been processed")
    IF iDialog = 1 THEN
      FPRINT FP, SPACE$(gAlign * 2), "FUNCTION = CallWindowProc(lp", szControl$, "_Proc, hWnd, Msg, wParam, lParam)"
    ELSE
      FPRINT FP, SPACE$(gAlign * 2), "FUNCTION = CallWindowProc(lpForm", TrimNum$(iDialog), "_", szControl$, "_Proc, hWnd, Msg, wParam, lParam)"
    END IF
    FPRINT FP, SPACE$(gAlign * 1), "END SELECT"
    FPRINT FP, ""
    EmitComment(FP, 1, "Default message has been processed")
    FPRINT FP, SPACE$(gAlign * 1), "FUNCTION = TRUE"
    FPRINT FP, "END FUNCTION"
    FPRINT FP, ""
    FPRINT FP, ""
  END IF
END SUB


SUB EmitUtilities(FP@)
  FPRINT FP, "SUB CenterWindow(hWnd AS HWND)"
  FPRINT FP, SPACE$(gAlign * 1), "DIM wRect AS RECT"
  FPRINT FP, SPACE$(gAlign * 1), "DIM x     AS DWORD"
  FPRINT FP, SPACE$(gAlign * 1), "DIM y     AS DWORD"
  FPRINT FP, ""
  FPRINT FP, SPACE$(gAlign * 1), "GetWindowRect(hWnd, &wRect)"
  FPRINT FP, SPACE$(gAlign * 1), "x = (GetSystemMetrics(SM_CXSCREEN) - (wRect.right - wRect.left)) / 2"
  FPRINT FP, SPACE$(gAlign * 1), "y = (GetSystemMetrics(SM_CYSCREEN) - (wRect.bottom - wRect.top + _"
  FPRINT FP, SPACE$(gAlign * 1), "    GetSystemMetrics(SM_CYCAPTION))) / 2"
  FPRINT FP, SPACE$(gAlign * 1), "SetWindowPos(hWnd, NULL, x, y, 0, 0, SWP_NOSIZE OR SWP_NOZORDER)"
  FPRINT FP, "END SUB"
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
    FPRINT FP, "'", SPACE$(12), "BCX Source Code Generated Using Dialog Starter 1.1 beta 1"
    FPRINT FP, "'", SPACE$(17), "For Use With BCX Translator Version 2.68+"
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


FUNCTION TrimNum$(iNumber)
  FUNCTION = TRIM$(STR$(iNumber))
END FUNCTION


FUNCTION RQlow$(szString$)
  DIM szBuffer$

  szBuffer$ = LCASE$(TRIM$(szString$))

  IF PTR szBuffer$ = 34 THEN
    szBuffer$ = RIGHT$(szBuffer$, LEN(szBuffer$) - 1)
  END IF

  IF RIGHT$(szBuffer$, 1) = Chr_34$ THEN
    szBuffer$ = LEFT$(szBuffer$, LEN(szBuffer$) - 1)
  END IF

  FUNCTION = szBuffer$
END FUNCTION


SUB Parse(Arg$)
  '********************************************
  ' Stk$[) AND Ndx must be declared GLOBAL
  ' and are re-initialized WITH each invocation
  '*********************************************
  GLOBAL Stk$[1024]                   ' Stack for preparse
  GLOBAL Ndx                          ' Current index for preparse

  DIM RAW szChar$
  DIM RAW Strlit$
  DIM RAW Anyword$
  DIM RAW Counter
  DIM RAW T
  DIM RAW Tmp
  DIM RAW Arglen
  DIM RAW A
  DIM RAW j
  
' **************************************************************************
  Anyword$ = "" ' This is the only local that needs to be initialized
' **************************************************************************
  Ndx = 0
  Arg$ = RTRIM$(Arg$)
  IF Arg$ = "" THEN
    Ndx = 0
    EXIT SUB
  END IF
  '********************
  FOR Tmp = 0 TO 15
    Stk$[Tmp] = ""
  NEXT
  '********************
  Arglen = LEN(Arg$)
  Counter = 0
  WHILE Counter <= Arglen
    INCR Counter
    szChar[0] =Arg[Counter-1]              'This eliminates using MID$
    szChar[1] = 0                          'Remember to null terminate
    T = ASC(szChar$)
  '***************************************
    SELECT CASE T
  '***************************************
      CASE 34   'Identify string literals
  '****************************************
      Strlit$ = szChar$
      szChar$ = ""
      DO
        IF szChar$ = Chr_34$  THEN EXIT LOOP
        INCR Counter
        IF Counter = Arglen THEN
          szChar[0] =Arg[Counter-1]        'This eliminates using MID$
          szChar[1] = 0                    'Remember to null terminate
          Strlit$ = Strlit$ & szChar$
          IF szChar$ <> Chr_34$ THEN
            Strlit$ = Strlit$ & Chr_34$    'Allow unquoted END of string
          END IF
          EXIT LOOP
        END IF
        szChar[0]=Arg[Counter-1]           'This eliminates using MID$
        szChar[1]=0                        'Remember to null terminate
        Strlit$ = Strlit$ & szChar$
      LOOP
      INCR Ndx
      Stk$[Ndx]= Strlit$
' **************************************************************************
      CASE 32
' **************************************************************************
      IF Anyword[0] THEN
        INCR Ndx
        Stk$[Ndx] = Anyword$
        Anyword$ = ""
      END IF
' **************************************************************************
      CASE 44, 124
' **************************************************************************
      IF Anyword$ > "" THEN
        INCR Ndx
        Stk$[Ndx]= Anyword$
        Anyword$ = ""
      END IF
      INCR Ndx
      Stk$[Ndx]= szChar$
' **************************************************************************
      CASE ELSE
' **************************************************************************
      A=LEN(Anyword$)
      Anyword[A]   = Arg[Counter-1]        'This eliminates using MID$
      Anyword[A+1] = 0                     'Remember to null terminate
' **************************************************************************
    END SELECT
' **************************************************************************
  LOOP
  
  IF Anyword$ > "" THEN
    INCR Ndx
    Stk$[Ndx]= Anyword$
  END IF
END SUB
