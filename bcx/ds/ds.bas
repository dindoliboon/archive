' //////////////////////////////////////////////////////////////////////////
'
' Dialog Starter 1.1
'
' Main application program.
'
' History (Legend: > Info, ! Fix, + New, - Removed):
'   1.0          4/08/2001   > Initial release.
'   1.1B1       10/13/2001   ! Updated Parse() function.
'                            > PrintStatus() has optional NO CRLF.
'                            + Support for Extended Dialogs.
'                            + Support for non-numeric identifiers.
'                            > More flexable with other resource editors.
'                            > Default alignment is 2 spaces instead of 4.
'                            - Alignment restrictions.
'                            - C code.
'   1.1         10/16/2001   > Stk$[4] contains default control id.
'                            + Inserts #include <windows.h>.
'                            ! Comments from being always enabled.
'                            ! Open brace { Stk$[] bug.
'                            ! Multiple dialogs bug.
'                            ! Common controls support.
'   1.1a        10/17/2001   + Suport for VC++ static control IDs.
'                            > Repositioned icex variable.
'                            > Cleaned up and commented code.
'   1.1         11/02/2001   + Inserts #include "file.h" if it exists
'
' Author:
'   DL             dl@tks.cjb.net / http://tks.cjb.net
'
' Credits:
'   Kevin Diggins
'   http://www.users.qwest.net/~sdiggins
'
' //////////////////////////////////////////////////////////////////////////

TYPE new_form
  id$[30]
END TYPE

TYPE new_control
  type$[30]
  id$[30]
  dlg AS INTEGER
END TYPE

CONST NOCR    = TRUE  ' Do not print carriage return
CONST THE_MAX = 512   ' Size of the array for the forms/controls/parser

' --------------------------------------------------------------------------
'                      G L O B A L   V A R I A B L E S
' --------------------------------------------------------------------------

GLOBAL gComments         ' DEFAULT: Add comments
GLOBAL gSubclass         ' DEFAULT: Do not subclass
GLOBAL gAlign            ' DEFAULT: Align with 2 spaces
GLOBAL gStatus           ' DEFAULT: Do not display status
GLOBAL gHelp             ' DEFAULT: Do not display help screen
GLOBAL gDoInsert         ' DEFAULT: Insert #include <windows.h>
GLOBAL gRichEd1          '    FLAG: RichEdit v1 was found
GLOBAL gRichEd2          '    FLAG: RichEdit v2 was found
GLOBAL gCommon           '    FLAG: CommonControl was found

' Stk$[) AND Ndx must be declared GLOBAL
' and are re-initialized WITH each invocation
GLOBAL Stk$[THE_MAX]     ' Stack for preparse
GLOBAL Ndx               ' Current index for preparse

GLOBAL IncStk$[THE_MAX]  ' File include stack
GLOBAL IncNdx, cdx, ddx  ' Current indexes

DIM szInput$             ' Name of input resource file
DIM szOutput$            ' Name of output source code file
DIM szRealName$          ' Name of input res file w/o .ext
DIM Chr_34$              ' Contains "

DIM ctl[THE_MAX] AS new_control
DIM frm[THE_MAX] AS new_form

' These are not ment to be used globally, because it may
' affect other functions. Other procedures using variables
' with the same name, have their own defines in their own
' procedure.
DIM szTemp$              ' Temporary string buffer
DIM x                    ' Temporary integer buffer
DIM y                    ' Temporary integer buffer

' --------------------------------------------------------------------------
' 
' Application entry point.
'
' Return Value:
'   0 if successful.
' 
' --------------------------------------------------------------------------

' Initialize global variable defaults
Chr_34$   = CHR$(34)
gAlign    = 2
gDoInsert = gComments = TRUE
gSubclass = gStatus   = gHelp = FALSE
IncNdx    = cdx = ddx = -1

' Check for existance of any commandline arguments
IF argc > 1 THEN
  FOR x = 1 TO argc - 1
    y = LEN(argv$[x])

    IF y >= 2 THEN
      SELECT CASE LCASE$(RIGHT$(argv$[x], y - 1))
      CASE "s"  : gStatus   = TRUE
      CASE "c"  : gSubclass = TRUE
      CASE "k"  : gComments = FALSE
      CASE "?"  : gHelp     = TRUE
      CASE "ni" : gDoInsert = FALSE
      CASE ELSE
        ' Get the requested alignment size
        IF LCASE$(MID$(argv$[x], 2, 1)) = "a" THEN
          gAlign = VAL(RIGHT$(argv$[x], y - 2))
        END IF
      END SELECT
    END IF
  NEXT

  ' Get file name
  szTemp$ = argv$[1]
END IF

' If file name is empty, display help screen
IF szTemp$ = "" THEN gHelp = TRUE

' Check if file exists
IF LOF(szTemp$) = -1 THEN
  szInput$ = szTemp$ & ".dlg"

  ' Check if the .DLG file exists,
  ' if not, use .RC instead.
  IF LOF(szInput$) = -1 THEN
    szInput$ = argv$[1] & ".rc"
  END IF
ELSE
  ' Our file does exist
  szInput$ = szTemp$
END IF

' Create output .tmp file name
szOutput$ = LCASE$(szInput$)

' Remove file ext.
x = LEN(szOutput$)
IF RIGHT$(szOutput$, 4) = ".dlg" THEN
  szOutput$ = LEFT$(szOutput$, x - 4)
ELSEIF RIGHT$(szOutput$, 3) = ".rc" THEN
  szOutput$ = LEFT$(szOutput$, x - 3)
END IF
szRealName$ = szOutput$

' Create output file name
szOutput$ = szOutput$ & ".bas"

' Check if we need to display the help screen
IF gHelp = TRUE THEN
  PRINT "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
  PRINT "³ Dialog Starter 1.1                                                 ³"
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
  PRINT "³ /a#  # Represents spacing alignment. Default is 2.                 ³"
  PRINT "³ /ni  Disable inserting includes.                                   ³"
  PRINT "³ /?   Displays meanings of arguments.                               ³"
  PRINT "³                                                                    ³"
  PRINT "³ Also accepts unix-style switches such as:  ds filename -k -s -c -? ³"
  PRINT "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
  PRINT ""
ELSEIF LOF(szInput$) = -1 THEN
  PRINT "error : could not open source file."
ELSE
  IF gDoInsert THEN AddInc(szInput$, szRealName$, 0)
  IF gDoInsert THEN AddInc(szInput$, "windows.h", 1)

  ProcessDialog(szInput$)
  WriteSource(szOutput$)
END IF

SUB AddInc(szInFile$, szInc$, iType)
  DIM MyBuffer$ * LOF(szInFile$)
  DIM InBuffer$
  DIM ItsInside

  IF iType <> 1 THEN
    szInc$ = szInc$ & ".h"

    IF EXIST(szInc$) <> -1 THEN EXIT SUB
  END IF

  ' By default, it does not exist
  ItsInside = FALSE

  ' Open resource file for reading
  OPEN szInFile$ FOR INPUT AS InRc
  WHILE NOT EOF(InRc)
    LINE INPUT InRc, InBuffer$

    ' Store line along with carrige return
    MyBuffer$ = MyBuffer$ & InBuffer$ & CHR$(10)

    ' Parse line
    Parse(InBuffer$)

    ' Check if it is an include statement
    IF Ndx >= 2 AND LCASE$(Stk$[1]) = "#include" THEN
      ' Check if the string contains include
      IF INSTR(LCASE$(Stk$[2]), szInc$) THEN
        ItsInside = TRUE
        GOTO ExitCheck
      END IF
    END IF
  WEND

  ' Close the file reading handle
  ExitCheck:
  CLOSE InRc

  ' If it was not found, open file for writing and insert include
  IF ItsInside = FALSE THEN
    PrintStatus(" - inserting #include ", NOCR)

    IF iType = 1 THEN
      PrintStatus("<", NOCR)
    ELSE
      PrintStatus(Chr_34$, NOCR)
    END IF

    PrintStatus(szInc$, NOCR)

    IF iType = 1 THEN
      PrintStatus(">")
    ELSE
      PrintStatus(Chr_34$)
    END IF

    OPEN szInFile$ FOR OUTPUT AS RcOut
      IF iType = 1 THEN
        FPRINT RcOut, "#include <", szInc$, ">"
      ELSE
        FPRINT RcOut, "#include ", Chr_34$, szInc$, Chr_34$
      END IF

      FPRINT RcOut, MyBuffer$
    CLOSE RcOut
  END IF

  ' Free string buffer
  FREE MyBuffer$
END SUB

' --------------------------------------------------------------------------
' 
' Generates the source code based on obtained information.
'
' Arguments:
'   szOutFile$  Name of file to create.
' 
' --------------------------------------------------------------------------
SUB WriteSource(szOutFile$)
  DIM x

  ' Write header and any C includes
  OPEN szOutFile$ FOR OUTPUT AS OutFile
  EmitHeader(OutFile)
  IF IncNdx <> -1 THEN
    EmitComment(OutFile, 0, "User defined C headers")
    FOR x = 0 TO IncNdx
      FPRINT OutFile, IncStk$[IncNdx]
    NEXT
    FPRINT OutFile, ""
  END IF

  ' Write all control and dialog identifiers
  EmitComment(OutFile, 0, "Global Constants (Dialog/Control IDs)")
  FOR x = 0 to ddx
    szTemp$ = "IDD_FORM" & TrimNum$(x + 1)
    IF LCASE$(szTemp$) <> LCASE$(TRIM$(frm[x].id$)) THEN
      FPRINT OutFile, "CONST ", szTemp$, " = ", frm[x].id$
    END IF
  NEXT

  FOR x = 0 to cdx
    IF LCASE$(ctl[x].id$) = "idc_static" THEN ctl[x].id$ = "-1"

    IF ctl[x].dlg = 1 THEN
      szTemp$ = "IDC_" & UCASE$(ctl[x].type$)
      IF LCASE$(szTemp$) <> LCASE$(TRIM$(ctl[x].id$)) THEN
        FPRINT OutFile, "CONST ", szTemp$, " = ", ctl[x].id$
      END IF
    ELSE
      szTemp$ = "IDC_FORM" & TrimNum$(ctl[x].dlg) & "_" & UCASE$(ctl[x].type$)
      IF LCASE$(szTemp$) <> LCASE$(TRIM$(ctl[x].id$)) THEN
         FPRINT OutFile, "CONST ", szTemp$, " = ", ctl[x].id$
      END IF
    END IF
  NEXT
  FPRINT OutFile, ""

  ' Write out all global handles
  EmitComment(OutFile, 0, "Global Variables (Dialog/Control Handles)")
  FPRINT OutFile, "GLOBAL hInstance AS HINSTANCE"

  IF gRichEd1 or gRichEd2 THEN
    FPRINT OutFile, "GLOBAL dllRich AS HMODULE"
  END IF

  IF gCommon THEN
    FPRINT OutFile, "GLOBAL icex AS INITCOMMONCONTROLSEX"
  END IF

  FOR x = 0 to ddx
    FPRINT OutFile, "GLOBAL Form", TrimNum$(x + 1), " AS HWND"
  NEXT

  FOR x = 0 to cdx
    IF ctl[x].dlg = 1 THEN
      FPRINT OutFile, "GLOBAL ", ctl[x].type$, " AS HWND"
    ELSE
      FPRINT OutFile, "GLOBAL Form", TrimNum$(ctl[x].dlg), "_", ctl[x].type$, " AS HWND"
    END IF
  NEXT
  FPRINT OutFile, ""

  ' Write wndproc handles if subclassing is enabled
  IF gSubclass THEN
    EmitComment(OutFile, 0, "Global Proc Variables")
    FOR x = 0 to cdx
      IF ctl[x].dlg = 1 THEN
        FPRINT OutFile, "GLOBAL lp", ctl[x].type$, "_Proc AS WNDPROC"
      ELSE
        FPRINT OutFile, "GLOBAL lpForm", TrimNum$(ctl[x].dlg), "_", ctl[x].type$, "_Proc AS WNDPROC"
      END IF
    NEXT
    FPRINT OutFile, ""
  END IF
  FPRINT OutFile, ""

  ' Write main function code
  EmitMain(OutFile)

  ' Write individual subclass code for each dialog
  FOR x = 0 to ddx
    EmitDlgProc(OutFile, x + 1)
  NEXT

  ' Write individual subclass code for each control
  FOR x = 0 to cdx
    EmitControlProc(OutFile, ctl[x].type$, ctl[x].dlg)
  NEXT

  ' Write any helper functions and close the handle
  EmitUtilities(OutFile)
  CLOSE OutFile
END SUB

' --------------------------------------------------------------------------
' 
' Obtains all control and dialog identifiers.
'
' Arguments:
'   szInFile$  Name of file to process.
' 
' --------------------------------------------------------------------------
SUB ProcessDialog(szInFile$)
  DIM fContents$
  DIM fBuffer$
  DIM inDialog
  DIM bDialog
  DIM InsideComments

  OPEN szInFile$ FOR INPUT AS InDlg
  PrintStatus(" - loading dialog file")
  WHILE NOT EOF(InDlg)
    LINE INPUT InDlg, fContents$

    ' Create and cleanup buffer
    fContents$ = TRIM$(fContents$)
    fBuffer$ = fBuffer$ & fContents$

    ' Check if the line is broken
    IF RIGHT$(fContents$, 1) <> "|" AND RIGHT$(fContents$, 1) <> "," AND _
      RIGHT$(LCASE$(fContents$), 3) <> "not" AND _
      RIGHT$(LCASE$(fContents$), 2) <> "or"  AND _
      LEN(fContents$) THEN

      ' Cleanup buffer
      fBuffer$ = TRIM$(fBuffer$)

      ' Check if we are inside of comments
      IF LEFT$(fBuffer$, 2) = "//" THEN GOTO SkipProcess
      IF LEFT$(fBuffer$, 2) = "/*" THEN
        InsideComments = TRUE
      END IF

      ' Check for end of comments
      IF RIGHT$(fBuffer$, 2) = "*/" THEN
        InsideComments = FALSE
        GOTO SkipProcess
      END IF

      ' If we are not inside comments, parse the line
      IF InsideComments = TRUE THEN GOTO SkipProcess
      Parse(fBuffer$)

      ' Check if the include file exists, if it does,
      ' add it to our include array
      IF Ndx >= 2 AND LCASE$(Stk$[1]) = "#include" THEN
        IF LOF(RQlow$(Stk$[2])) <> -1 THEN
          INCR IncNdx

          IncStk$[IncNdx] = "#include " & Stk$[2]
        END IF
      END IF

      ' Check if we are at the beginning of a dialog
      IF Ndx >= 9 AND LCASE$(Stk$[2]) = "dialog" OR LCASE$(Stk$[2]) = "dialogex" THEN
        INCR ddx
        bDialog = TRUE
        PrintStatus(" - found form", NOCR)
        PrintStatus(TrimNum$(ddx + 1))

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

      ' Check if it is the end of a dialog
      IF LCASE$(Stk$[1]) = "end" OR Stk$[1] = "}" THEN
        inDialog = FALSE
      END IF

      ' If we are inside the dialog, process all controls
      IF inDialog THEN
        INCR cdx
        ProcessControl(ddx + 1, fBuffer$)
      END IF

      ' Check if we are inside the start of a dialog
      IF LCASE$(Stk$[1]) = "begin" OR Stk$[1] = "{" THEN
        IF bDialog THEN
          inDialog = TRUE
          bDialog = FALSE
        END IF
      END IF

  ' Clean buffer for next read
  SkipProcess:
      fBuffer$ = ""
    END IF
  WEND

  CLOSE InDlg
END SUB


SUB ProcessControl(iDialog, fBuffer$)
  DIM SHARED iCheck,    iRadio,    iCombo,      iControl
  DIM SHARED iStatic,   iButton,   iEdit,       iGroup
  DIM SHARED iIcon,     iList,     iVScroll,    iHScroll
  DIM SHARED iFrame,    iRect,     iRich,       iRebar
  DIM SHARED iHotkey,   iHeader,   iProgress,   iCalendar
  DIM SHARED iAnimate,  iStatus,   iToolbar,    iPager
  DIM SHARED iTrackbar, iUpDown,   iComboBoxEx, iDatePicker
  DIM SHARED iIP, iTab, iListview, iTooltips,   iTreeview

  ctl[cdx].dlg = iDialog
  IF Ndx >=4 THEN ctl[cdx].id$ = Stk$[4]

  SELECT CASE LCASE$(Stk$[1])
  CASE "auto3state", "autocheckbox", "checkbox", "state3"
    INCR iCheck
    ctl[cdx].type$ = "CheckBox" & TrimNum$(iCheck)
  CASE "autoradiobutton", "radiobutton"
    INCR iRadio
    ctl[cdx].type$ = "Radio" & TrimNum$(iRadio)
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
    CASE "richedit20w", "richedit20a", "richedit_class"
      gRichEd2 = TRUE
      INCR iRich
      ctl[cdx].type$ = "RichEdit" & TrimNum$(iRich)
    CASE "rebarwindow32", "rebarclassname"
      gCommon = TRUE
      INCR iRebar
      ctl[cdx].type$ = "Rebar" & TrimNum$(iRebar)
    CASE "msctls_hotkey32", "hotkey_class"
      gCommon = TRUE
      INCR iHotkey
      ctl[cdx].type$ = "Hotkey" & TrimNum$(iHotkey)
    CASE "sysheader32", "wc_header"
      gCommon = TRUE
      INCR iHeader
      ctl[cdx].type$ = "Header" & TrimNum$(iHeader)
    CASE "msctls_progress32", "progress_class"
      gCommon = TRUE
      INCR iProgress
      ctl[cdx].type$ = "Progress" & TrimNum$(iProgress)
    CASE "sysmonthcal32", "monthcal_class"
      gCommon = TRUE
      INCR iCalendar
      ctl[cdx].type$ = "Calendar" & TrimNum$(iCalendar)
    CASE "sysanimate32", "animate_class"
      gCommon = TRUE
      INCR iAnimate
      ctl[cdx].type$ = "Animate" & TrimNum$(iAnimate)
    CASE "msctls_statusbar32", "statusclassname"
      gCommon = TRUE
      INCR iStatus
      ctl[cdx].type$ = "Status" & TrimNum$(iStatus)
    CASE "toolbarwindow32", "toolbarclassname"
      gCommon = TRUE
      INCR iToolbar
      ctl[cdx].type$ = "Toolbar" & TrimNum$(iToolbar)
    CASE "syspager", "wc_pagescroller"
      gCommon = TRUE
      INCR iPager
      ctl[cdx].type$ = "Pager" & TrimNum$(iPager)
    CASE "msctls_trackbar32", "trackbar_class"
      gCommon = TRUE
      INCR iTrackbar
      ctl[cdx].type$ = "Trackbar" & TrimNum$(iTrackbar)
    CASE "msctls_updown32", "updown_class"
      gCommon = TRUE
      INCR iUpDown
      ctl[cdx].type$ = "UpDown" & TrimNum$(iUpDown)
    CASE "comboboxex32", "wc_comboboxex"
      gCommon = TRUE
      INCR iComboBoxEx
      ctl[cdx].type$ = "ComboBoxEx" & TrimNum$(iComboBoxEx)
    CASE "sysdatetimepick32", "datetimepick_class"
      gCommon = TRUE
      INCR iDatePicker
      ctl[cdx].type$ = "DatePicker" & TrimNum$(iDatePicker)
    CASE "sysipaddress32", "wc_ipaddress"
      gCommon = TRUE
      INCR iIP
      ctl[cdx].type$ = "IPAddress" & TrimNum$(iIP)
    CASE "syslistview32", "wc_listview"
      gCommon = TRUE
      INCR iListview
      ctl[cdx].type$ = "ListView" & TrimNum$(iListview)
    CASE "tooltips_class32", "tooltips_class"
      gCommon = TRUE
      INCR iTooltips
      ctl[cdx].type$ = "Tooltips" & TrimNum$(iTooltips)
    CASE "systabcontrol32", "wc_tabcontrol"
      gCommon = TRUE
      INCR iTab
      ctl[cdx].type$ = "Tab" & TrimNum$(iTab)
    CASE "systreeview32", "wc_treeview"
      gCommon = TRUE
      INCR iTreeview
      ctl[cdx].type$ = "TreeView" & TrimNum$(iTreeview)
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
    CASE "combobox"
      INCR iCombo
      ctl[cdx].type$ = "ComboBox" & TrimNum$(iCombo)
    CASE "edit"
      INCR iEdit
      ctl[cdx].type$ = "Edit" & TrimNum$(iEdit)
    CASE "listbox"
      INCR iList
      ctl[cdx].type$ = "ListBox" & TrimNum$(iList)
    CASE "scrollbar"
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
    CASE ELSE
      INCR iControl
      ctl[cdx].type$ = "Control" & TrimNum$(iControl)
    END SELECT
  CASE "ctext", "ltext", "rtext"
    INCR iStatic
    ctl[cdx].type$ = "Static" & TrimNum$(iStatic)
  CASE "defpushbutton", "pushbox", "pushbutton"
    INCR iButton
    ctl[cdx].type$ = "Button" & TrimNum$(iButton)
  CASE "edittext"
    INCR iEdit
    ctl[cdx].type$ = "Edit" & TrimNum$(iEdit)
    ctl[cdx].id$ = Stk$[2]
  CASE "groupbox"
    INCR iGroup
    ctl[cdx].type$ = "Group" & TrimNum$(iGroup)
  CASE "icon"
    INCR iIcon
    ctl[cdx].type$ = "Icon" & TrimNum$(iIcon)
  CASE "listbox"
    INCR iList
    ctl[cdx].type$ = "ListBox" & TrimNum$(iList)
    ctl[cdx].id$ = Stk$[2]
  CASE "scrollbar"
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


SUB PrintStatus OPTIONAL(szString$, NoCrLf = 0)
  IF NOT gStatus THEN EXIT SUB

  IF NoCrLf = 0 THEN
    PRINT szString$
  ELSE
    PRINT szString$;
  END IF
END SUB


SUB EmitMain(FP@)
  DIM x

  FPRINT FP, "FUNCTION WinMain()"
  EmitComment(FP, 1, "Gives global access to hInstance")
  FPRINT FP, SAlign$(1), "hInstance = hInst"
  FPRINT FP, ""

  IF gCommon OR gRichEd1 OR gRichEd2 THEN
    EmitComment(FP, 1, "Initialize extra controls")
  END IF

  IF gCommon THEN
    FPRINT FP, SAlign$(1), "icex.dwSize = sizeof(INITCOMMONCONTROLSEX)"
    FPRINT FP, SAlign$(1), "icex.dwICC  = ICC_COOL_CLASSES     OR ICC_DATE_CLASSES OR       _"
    FPRINT FP, SAlign$(1), "              ICC_INTERNET_CLASSES OR ICC_PAGESCROLLER_CLASS OR _"
    FPRINT FP, SAlign$(1), "              ICC_USEREX_CLASSES   OR ICC_WIN95_CLASSES"
    FPRINT FP, SAlign$(1), "InitCommonControlsEx(&icex)"
    FPRINT FP, ""
  END IF

  IF gRichEd1 THEN
    FPRINT FP, SAlign$(1), "dllRich = LoadLibrary(", Chr_34$, "riched32.dll", Chr_34$, ")"
  END IF

  IF gRichEd2 THEN
    FPRINT FP, SAlign$(1), "dllRich = LoadLibrary(", Chr_34$, "riched20.dll", Chr_34$, ")"
  END IF

  IF gRichEd1 OR gRichEd2 THEN
    FPRINT FP, ""
  END IF

  EmitComment(FP, 1, "Initialize our dialog, pointing it to the dialog procedure")
  FOR x = 0 to ddx
    FPRINT FP, SAlign$(1), "DialogBox(hInst, MAKEINTRESOURCE(IDD_FORM", TrimNum$(x + 1), "), NULL, (DLGPROC) Form", TrimNum$(x + 1), "_Proc)"
  NEXT
  FPRINT FP, ""

  IF gRichEd1 or gRichEd2 THEN
    EmitComment(FP, 1, "Remove RichEdit module from memory")
    FPRINT FP, SAlign$(1), "FreeLibrary(dllRich)"
    FPRINT FP, ""
  END IF

  FPRINT FP, SAlign$(1), "FUNCTION = FALSE"
  FPRINT FP, "END FUNCTION"
  FPRINT FP, ""
  FPRINT FP, ""
END SUB


SUB EmitDlgProc(FP@, iDialog)
  DIM x

  FPRINT FP, "CALLBACK FUNCTION Form", TrimNum$(iDialog), "_Proc()"
  FPRINT FP, SAlign$(1), "SELECT CASE Msg"
  EmitSeperator(FP)
  FPRINT FP, SAlign$(1), "CASE WM_INITDIALOG"
  EmitSeperator(FP)
  EmitComment(FP, 2, "Retrieves the dialog/control handles")
  FPRINT FP, SAlign$(2), "Form", TrimNum$(iDialog), " = hWnd"
  FOR x = 0 to cdx
    IF ctl[x].dlg = iDialog THEN
      IF ctl[x].dlg = 1 THEN
        FPRINT FP, SAlign$(2), ctl[x].type$, " = GetDlgItem(hWnd, IDC_", UCASE$(ctl[x].type$), ")"
      ELSE
        FPRINT FP, SAlign$(2), "Form", TrimNum$(ctl[x].dlg), "_", ctl[x].type$, " = GetDlgItem(hWnd, IDC_FORM", TrimNum$(ctl[x].dlg), "_", UCASE$(ctl[x].type$), ")"
      END IF
    END IF
  NEXT
  FPRINT FP, ""

  IF gSubclass THEN
    EmitComment(FP, 2, "Give controls seperate proc functions")
    FOR x = 0 to cdx
      IF ctl[x].dlg = iDialog THEN
        IF ctl[x].dlg = 1 THEN
          FPRINT FP, SAlign$(2), "lp", ctl[x].type$, "_Proc = SubclassWindow(", ctl[x].type$, ", ", ctl[x].type$, "_Proc)"
        ELSE
          FPRINT FP, SAlign$(2), "lpForm", TrimNum$(ctl[x].dlg), "_", ctl[x].type$, "_Proc = SubclassWindow(Form", TrimNum$(ctl[x].dlg), "_", ctl[x].type$, ", Form", TrimNum$(ctl[x].dlg), "_", ctl[x].type$, "_Proc)"
        END IF
      END IF
    NEXT
    FPRINT FP, ""
  END IF

  EmitComment(FP, 2, "Set other window properties")
  FPRINT FP, SAlign$(2), "CenterWindow(hWnd)"
  FPRINT FP, ""
  EmitSeperator(FP)
  FPRINT FP, SAlign$(1), "CASE WM_CLOSE"
  EmitSeperator(FP)
  EmitComment(FP, 2, "Free our dialog")
  FPRINT FP, SAlign$(2), "EndDialog(hWnd, TRUE)"
  FPRINT FP, ""
  EmitSeperator(FP)
  FPRINT FP, SAlign$(1), "CASE ELSE"
  EmitSeperator(FP)
  EmitComment(FP, 2, "No messages processed, return false")
  FPRINT FP, SAlign$(2), "FUNCTION = FALSE"
  FPRINT FP, SAlign$(1), "END SELECT"
  FPRINT FP, ""
  EmitComment(FP, 1, "If we reach this point, that means a message was processed")
  EmitComment(FP, 1, "and we send a true value")
  FPRINT FP, SAlign$(1), "FUNCTION = TRUE"
  FPRINT FP, "END FUNCTION"
  FPRINT FP, ""
  FPRINT FP, ""
END SUB


SUB EmitControlProc(FP@, szControl$, iDialog)
  IF NOT gSubclass THEN EXIT SUB

  IF iDialog = 1 THEN
    FPRINT FP, "CALLBACK FUNCTION ", szControl$, "_Proc()"
  ELSE
    FPRINT FP, "CALLBACK FUNCTION Form", TrimNum$(iDialog), "_", szControl$, "_Proc()"
  END IF

  FPRINT FP, SAlign$(1), "SELECT CASE Msg"
  EmitSeperator(FP)
  FPRINT FP, SAlign$(1), "CASE WM_COMMAND"
  EmitSeperator(FP)
  EmitComment(FP, 2, "Your WM_COMMAND code")
  FPRINT FP, ""
  EmitSeperator(FP)
  FPRINT FP, SAlign$(1), "CASE WM_LBUTTONDBLCLK"
  EmitSeperator(FP)

  IF iDialog = 1 THEN
    FPRINT FP, SAlign$(2), "MSGBOX ", Chr_34$, szControl$, " Double Clicked!", Chr_34$
  ELSE
    FPRINT FP, SAlign$(2), "MSGBOX ", Chr_34$, "Form", TrimNum$(iDialog), "_", szControl$, " Double Clicked!", Chr_34$
  END IF

  FPRINT FP, ""
  EmitSeperator(FP)
  FPRINT FP, SAlign$(1), "CASE ELSE"
  EmitSeperator(FP)
  EmitComment(FP, 2, "No messages have been processed")

  IF iDialog = 1 THEN
    FPRINT FP, SAlign$(2), "FUNCTION = CallWindowProc(lp", szControl$, "_Proc, hWnd, Msg, wParam, lParam)"
  ELSE
    FPRINT FP, SAlign$(2), "FUNCTION = CallWindowProc(lpForm", TrimNum$(iDialog), "_", szControl$, "_Proc, hWnd, Msg, wParam, lParam)"
  END IF

  FPRINT FP, SAlign$(1), "END SELECT"
  FPRINT FP, ""
  EmitComment(FP, 1, "Default message has been processed")
  FPRINT FP, SAlign$(1), "FUNCTION = TRUE"
  FPRINT FP, "END FUNCTION"
  FPRINT FP, ""
  FPRINT FP, ""
END SUB


SUB EmitUtilities(FP@)
  FPRINT FP, "SUB CenterWindow(hWnd AS HWND)"
  FPRINT FP, SAlign$(1), "DIM wRect AS RECT"
  FPRINT FP, SAlign$(1), "DIM x     AS DWORD"
  FPRINT FP, SAlign$(1), "DIM y     AS DWORD"
  FPRINT FP, ""
  FPRINT FP, SAlign$(1), "GetWindowRect(hWnd, &wRect)"
  FPRINT FP, SAlign$(1), "x = (GetSystemMetrics(SM_CXSCREEN) - (wRect.right - wRect.left)) / 2"
  FPRINT FP, SAlign$(1), "y = (GetSystemMetrics(SM_CYSCREEN) - (wRect.bottom - wRect.top + _"
  FPRINT FP, SAlign$(1), "    GetSystemMetrics(SM_CYCAPTION))) / 2"
  FPRINT FP, SAlign$(1), "SetWindowPos(hWnd, NULL, x, y, 0, 0, SWP_NOSIZE OR SWP_NOZORDER)"
  FPRINT FP, "END SUB"
END SUB


SUB EmitSeperator(FP@)
  DIM szBuffer$

  IF NOT gComments THEN EXIT SUB
  szBuffer$ = REPEAT$(74, "*")
  FPRINT FP, "' ", szBuffer$
END SUB


SUB EmitHeader(FP@)
  IF NOT gComments THEN EXIT SUB

  EmitSeperator(FP)
  FPRINT FP, "'", SPACE$(12), "BCX Source Code Generated Using Dialog Starter 1.1"
  FPRINT FP, "'", SPACE$(17), "For Use With BCX Translator Version 2.68+"
  EmitSeperator(FP)
  FPRINT FP, ""
END SUB


SUB EmitComment(FP@, nCol, szComment$)
  IF NOT gComments THEN EXIT SUB

  FPRINT FP, SAlign$(nCol), "' ", szComment$
END SUB


SUB EmitLine(FP@, nCol, szLine$)
  FPRINT FP, SAlign$(nCol), szLine$
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


FUNCTION SAlign$(iNumber)
  FUNCTION = SPACE$(gAlign * iNumber)
END FUNCTION


SUB Parse(Arg$)
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
