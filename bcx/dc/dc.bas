' -------------------------------------------------------------------------
'
' Dialog Converter 3.4
'
' Converts Microsoft Dialog Editor scripts into complete BCX source code,
' removing the need for the resource file completely. Or it can create BCX
' template, where your application depends on a resource file (*.RES).
'
' Copyright (C) Dindo Liboon 2001-2011. All rights reserved.
'
' mailto: dliboon@hotmail.com
'    url: http://dliboon.freeshell.org
'
' -------------------------------------------------------------------------

$NOMAIN ' disable default main(), and use our custom main()

$CCODE
    // standard control class tokens
    enum {CLS_BUTTON = 0, CLS_STATIC, CLS_SCROLL,
        CLS_COMBO, CLS_LIST, CLS_EDIT};

    // all control tokens
    enum {TYP_HSCROLL = 0, TYP_VSCROLL, TYP_CHECK, TYP_RADIO,
        TYP_LABEL, TYP_BUTTON, TYP_GROUP, TYP_COMBO,
        TYP_EDIT, TYP_LIST, TYP_RICHEDIT1, TYP_RICHEDIT2, TYP_ANIMATE,
        TYP_PAGER, TYP_LINK, TYP_TIPS, TYP_IP,
        TYP_FONTCTL, TYP_DATEPICK, TYP_MONTHCAL, TYP_REBAR,
        TYP_TOOLBAR, TYP_HEADER, TYP_LISTVIEW, TYP_STATUS,
        TYP_TREE, TYP_TAB, TYP_UPDOWN, TYP_PROGRESS,
        TYP_HOTKEY, TYP_TRACK, TYP_COMBOEX, TYP_CONTROL, TYP_ICON,
        TYP_BITMAP, TYP_BLACKFRAME, TYP_WHITEFRAME, TYP_GRAYFRAME,
        TYP_WHITERECT, TYP_GRAYRECT, TYP_BLACKRECT, TYP_INPUT,
        TYP_DIALOG, TYP_STYLE, TYP_CAPTION, TYP_BLOCKEND, TYP_BLOCKSTART,
        TYP_EXSTYLE, TYP_CLASS, TYP_DIALOGEX, TYP_ERROR};

    // standard control classes
    char *ctrlCls[] = {"\"BUTTON\"", "\"STATIC\"", "\"SCROLLBAR\"",
        "\"COMBOBOX\"", "\"LISTBOX\"", "\"EDIT\""};

    // control names, matches with TYP_XXXXXX
    char *ctlName[] = {"HScroll", "VScroll", "Checkbox", "Radio",
        "Label", "Button", "Group", "Combobox",
        "Edit", "Listbox", "RichEdit", "RichEdit", "Animate",
        "Pager", "Link", "ToolTips", "IPAddress",
        "FontCtl", "DatePick", "Calendar", "Rebar",
        "Toolbar", "Header", "ListView", "Status",
        "TreeView", "Tab", "UpDown", "Progress",
        "Hotkey", "Trackbar", "ComboEx", "Control", "Icon",
        "Bitmap", "BlackFrame", "WhiteFrame", "GrayFrame",
        "WhiteRect", "GrayRect", "BlackRect", "Input"};

    // control styles
    char *stylPak1[] = {"BS_AUTO3STATE", "BS_AUTOCHECKBOX", "BS_CHECKBOX",
        "BS_3STATE", "BS_AUTORADIOBUTTON", "BS_RADIOBUTTON", "SS_CENTER",
        "SS_LEFT", "SS_RIGHT", "BS_PUSHBOX", "BS_PUSHBUTTON",
        "BS_DEFPUSHBUTTON", "BS_GROUPBOX", "SBS_HORZ", "CBS_SIMPLE",
        "ES_LEFT", "LBS_NOTIFY"};

    // control tokens and classes
    char *ctrlPak1[] = {"AUTO3STATE", "AUTOCHECKBOX", "CHECKBOX", "STATE3",
        "AUTORADIOBUTTON", "RADIOBUTTON", "CTEXT", "LTEXT",
        "RTEXT", "PUSHBOX", "PUSHBUTTON", "DEFPUSHBUTTON",
        "GROUPBOX", "SCROLLBAR", // 14 controls
        "COMBOBOX", "EDITTEXT", "LISTBOX", // 3 controls
        "COMBOBOX", "WC_COMBOBOX", "EDIT", "WC_EDIT",
        "LISTBOX", "WC_LISTBOX", "SCROLLBAR", "WC_SCROLLBAR",
        "STATIC", "WC_STATIC", "BUTTON", "WC_BUTTON",
        "RICHEDIT", "RICHEDIT_CLASS10A", "RICHEDIT_CLASS", "RICHEDIT20A",
        "SYSANIMATE32", "ANIMATE_CLASS", "SYSPAGER", "WC_PAGESCROLLER",
        "WC_LINK", "SYSLINK", "TOOLTIPS_CLASS32", "TOOLTIPS_CLASS",
        "SYSIPADDRESS32", "WC_IPADDRESS", "NATIVEFONTCTL", "WC_NATIVEFONTCTL",
        "SYSDATETIMEPICK32", "DATETIMEPICK_CLASS", "SYSMONTHCAL32", "MONTHCAL_CLASS",
        "REBARWINDOW32", "REBARCLASSNAME", "REBARWINDOW", "TOOLBARWINDOW32",
        "TOOLBARWINDOW", "TOOLBARCLASSNAME", "SYSHEADER", "SYSHEADER32",
        "WC_HEADER", "SYSLISTVIEW", "SYSLISTVIEW32", "WC_LISTVIEW",
        "MSCTLS_STATUSBAR32", "MSCTLS_STATUSBAR", "STATUSCLASSNAME", "SYSTREEVIEW32",
        "WC_TREEVIEW", "SYSTREEVIEW", "SYSTABCONTROL32", "SYSTABCONTROL",
        "WC_TABCONTROL", "MSCTLS_UPDOWN", "MSCTLS_UPDOWN32", "UPDOWN_CLASS",
        "PROGRESS_CLASS", "MSCTLS_PROGRESS32", "MSCTLS_PROGRESS", "MSCTLS_HOTKEY32",
        "HOTKEY_CLASS", "MSCTLS_HOTKEY", "MSCTLS_TRACKBAR32", "MSCTLS_TRACKBAR",
        "TRACKBAR_CLASS", "ComboBoxEx"}; // 66 controls

    // remaps ctrlPak1 to actual tokens
    int mapTyp1[] = {TYP_CHECK, TYP_CHECK, TYP_CHECK, TYP_CHECK,
        TYP_RADIO, TYP_RADIO, TYP_LABEL, TYP_LABEL, TYP_LABEL, TYP_BUTTON,
        TYP_BUTTON, TYP_BUTTON, TYP_GROUP, TYP_HSCROLL,
        TYP_COMBO, TYP_EDIT, TYP_LIST,
        TYP_COMBO, TYP_COMBO, TYP_EDIT, TYP_EDIT,
        TYP_LIST, TYP_LIST, TYP_HSCROLL, TYP_HSCROLL,
        TYP_LABEL, TYP_LABEL, TYP_BUTTON, TYP_BUTTON,
        TYP_RICHEDIT1, TYP_RICHEDIT1, TYP_RICHEDIT2, TYP_RICHEDIT2,
        TYP_ANIMATE, TYP_ANIMATE, TYP_PAGER, TYP_PAGER,
        TYP_LINK, TYP_LINK, TYP_TIPS, TYP_TIPS,
        TYP_IP, TYP_IP, TYP_FONTCTL, TYP_FONTCTL,
        TYP_DATEPICK, TYP_DATEPICK, TYP_MONTHCAL, TYP_MONTHCAL,
        TYP_REBAR, TYP_REBAR, TYP_REBAR, TYP_TOOLBAR,
        TYP_TOOLBAR, TYP_TOOLBAR, TYP_HEADER, TYP_HEADER,
        TYP_HEADER, TYP_LISTVIEW, TYP_LISTVIEW, TYP_LISTVIEW,
        TYP_STATUS, TYP_STATUS, TYP_STATUS, TYP_TREE,
        TYP_TREE, TYP_TREE, TYP_TAB, TYP_TAB,
        TYP_TAB, TYP_UPDOWN, TYP_UPDOWN, TYP_UPDOWN,
        TYP_PROGRESS, TYP_PROGRESS, TYP_PROGRESS, TYP_HOTKEY,
        TYP_HOTKEY, TYP_HOTKEY, TYP_TRACK, TYP_TRACK,
        TYP_TRACK, TYP_COMBOEX};

    // remaps first 17 ctrlPak1 controls to ctrlCls classes
    int mapCls1[] = {CLS_BUTTON, CLS_BUTTON, CLS_BUTTON,
        CLS_BUTTON, CLS_BUTTON, CLS_BUTTON, CLS_STATIC, CLS_STATIC,
        CLS_STATIC, CLS_BUTTON, CLS_BUTTON, CLS_BUTTON, CLS_BUTTON,
        CLS_SCROLL, CLS_COMBO, CLS_EDIT, CLS_LIST};
$CCODE

'****************************************************
' Modified: 1/1/2005, 3.2
' Added debugging code
'****************************************************
'Const DEBUG_MODE

Const DLG_OPEN  = 1 ' found dialog or dialogex
Const DLG_BEGIN = 2 ' found begin block
Const DLG_END   = 3 ' found end block

Const MODE_DC = 1 ' converts to complete source code
Const MODE_DS = 2 ' creates a template for use with *.RES files

Const CL_EXPANDED   = 1 ' show all source code
Const CL_COMPACT    = 2 ' compacts source code
Const CL_SIMPLIFIED = 3 ' use simplified language keywords

Type Flags
    help     As Bool ' display help file
    status   As Bool ' display conversion status
    menu     As Bool ' add menu system
    include  As Bool ' add listed includes
    subclass As Bool ' add subclassing code
    comments As Bool ' add comments
    align%           ' spacing alignment
    codelevel%       ' specifies how much code should be hidden
    mode%            ' create full source code or templated code
End Type

Type Element
    exStyle$ ' extended style of element
    class$   ' class name of element
    text$    ' caption of element
    style$   ' style of element
    x$       ' x-coordinate
    y$       ' y-coordinate
    width$   ' width of element
    height$  ' height of element
    id$      ' control id
    owner$   ' parent dialog
    ownerN%  ' parent dialog number
    no%      ' current control number
    token%   ' token type
End Type

Global Chr34$           ' double quote
Global frm As LPELEMENT ' form properties
Global ctl As LPELEMENT ' control properties
Global dynFrm%          ' number of allocated forms
Global dynCtl%          ' number of allocated controls
Global numFrm%          ' used forms
Global numCtl%          ' used controls
Global curCtrl%[42]     ' used current control
Global incFile$[20]     ' allow for 20 includes
Global incNum%          ' number of include files
Global opt As Flags     ' holds application options
Global useRichEdit1%    ' enable richedit v1
Global useRichEdit2%    ' enable richedit v2
Global useCommCtrl%     ' enable common controls


' -------------------------------------------------------------------------
' Application entry point
'
' Returns 0 on success, 1 on failure.
' -------------------------------------------------------------------------
Function main%(argc%, argv As PCHAR PTR)
    Dim inFile$      ' input dialog file
    Dim outFile$     ' output file
    Dim Raw idx%     ' temporary index

    '------------------------
    ' set the default options
    '------------------------
    opt.help      = False         ' disable help
    opt.status    = False         ' hide conversion status
    opt.menu      = False         ' disable menu system
    opt.include   = True          ' insert include names
    opt.subclass  = False         ' disable control subclass code
    opt.comments  = True          ' enable code comments
    opt.codelevel = CL_SIMPLIFIED ' use simplified keywords
    opt.mode      = MODE_DC       ' create complete source code
    opt.align     = 4             ' spacing alignment

    Chr34$ = Chr$(34)

    ? "Dialog Converter 3.4"
    ? "Copyright (C) Dindo Liboon 2001-2011. All rights reserved."

    '---------------------------------------------
    ' check if there are any commandline arguments
    '---------------------------------------------
    If argc > 2 Then
        Dim Raw argLen% ' length of argument

        '-------------------------------
        ' grab each commandline argument
        '-------------------------------
        For idx = 2 To argc - 1
            argLen = Len(argv$[idx])

            '--------------------------------
            ' check if its an actual argument
            '--------------------------------
            If argLen > 1 Then
                Select Case Mid$(argv$[idx], 2, argLen - 1)
                Case "l1" : opt.codelevel = CL_EXPANDED
                Case "l2" : opt.codelevel = CL_COMPACT
                Case "l3" : opt.codelevel = CL_SIMPLIFIED
                Case "g1" : opt.mode      = MODE_DC
                Case "g2" : opt.mode      = MODE_DS
                Case "c"  : opt.subclass  = True
                Case "ni" : opt.include   = False
                Case "m"  : opt.menu      = True
                Case "k"  : opt.comments  = False
                Case "s"  : opt.status    = True
                Case "?"
                    Call DisplayHelp()
                    Function = 1
                Case Else
                    If Mid$(argv$[idx], 2, 1) = "a" Then
                        opt.align = (int)Val(Mid$(argv$[idx], 3, argLen - 1))
                    ElseIf idx <> argc - 1 Then
                        ? CRLF$, "unknown option: ", argv$[idx]
                    End If
                End Select
            End If
        Next
    Else
        '-----------------------------
        ' check if any arguments exist
        '-----------------------------
        If argc = 1 Then
            ? CRLF$, "usage: dc filename... [ option... ]"
            ? "   ie: dc dialog.dlg -l3 -s -a4 -c -m"
            ? " help: dc -?"

            Function = 1
        End If
    End If

    '---------------------------
    ' check if help is requested
    '---------------------------
    If argv$[1] = "-?" or argv$[1] = "/?" Then
        Call DisplayHelp()
        Function = 1
    End If

    '--------------------------
    ' determine input file name
    '--------------------------
    If Lof(Glue$(argv$[1], ".rc"))  > 0 Then
        inFile$ = Glue$(argv$[1], ".rc")
    ElseIf Lof(Glue$(argv$[1], ".dlg")) > 0 Then
        inFile$ = Glue$(argv$[1], ".dlg")
    ElseIf argc > 1 Then
        inFile$ = argv$[1]
    End If

    '---------------------------
    ' determine output file name
    '---------------------------
    idx = InstrRev(inFile$, ".")
    If idx > 0 Then
        outFile$ = Left$(inFile$, idx) & "bas"
    Else
        outFile$ = inFile$ & ".bas"
    End If

    '-------------------------------------
    ' open script for reading if it exists
    '-------------------------------------
    If Lof(inFile$) > 0 Then
        '-----------------------------------------------
        ' allocate and clear memory for dialogs/controls
        '-----------------------------------------------
        numFrm = 0
        numCtl = 0
        dynFrm = 5
        dynCtl = 30

        frm = (LPELEMENT)malloc(sizeof(Element) * dynFrm)
        ctl = (LPELEMENT)malloc(sizeof(Element) * dynCtl)

        ZeroMemory(frm, sizeof(Element) * dynFrm)
        ZeroMemory(ctl, sizeof(Element) * dynCtl)

        ? ""
        Call AnalyzeDlg(inFile$)
        ? " --> Converted the file ", inFile$, " to ", outFile$
    Else
        If inFile$ <> "" Then
            ? CRLF$, "The file ", Chr34$, inFile$, Chr34$, " does not exist."
        End If

        Function = 1
    End If

    '--------------------------------
    ' pass file name to generate code
    '--------------------------------
    Call GenerateCode(outFile$)

    '------------------
    ' exit successfully
    '------------------
    Function = 0
End Function


' -------------------------------------------------------------------------
' Breaks down the options to generate the source code
' -------------------------------------------------------------------------
Sub GenerateCode(file$)
    Dim Raw i% ' temporary variable

    Open file$ For Output As DlgOut

    If opt.comments = True Then
        Call EmitSep()
        FPrint DlgOut, "'"
        FPrint DlgOut, "' BCX Source Code Generated With Dialog Converter 3.4"
        FPrint DlgOut, "' For Use With BCX Translator Version 3.0"
        FPrint DlgOut, "'"
        Call EmitSep()
        FPrint DlgOut, ""
    End If

    If opt.include = True Then
        For i = 0 to incNum - 1
            FPrint DlgOut, "#include ", Chr34$, incFile$[i], Chr34$
        Next

        If incNum > 0 Then
            FPrint DlgOut, ""
        End If
    End If

    Select Case opt.mode
    Case MODE_DS
        MakeDS()
    Case Else
        MakeDC()
    End Select

    Close DlgOut
End Sub


' -------------------------------------------------------------------------
' Generate Dialog Converter code
' -------------------------------------------------------------------------
Sub MakeDC()
    Dim Raw i% ' temporary variable
    Dim tmp$   ' temporary buffer
    Dim typNm$ ' window type

    '-----------------------------------
    ' don't waste time if nothing exists
    '-----------------------------------
    If numFrm = 0 Then
        Exit Sub
    End If

    '-------------------------------------
    ' add Gui keyword and set window types
    '-------------------------------------
    If opt.codelevel = CL_SIMPLIFIED Then
        FPrint DlgOut, "Gui ", frm[0].class$
        FPrint DlgOut, ""

        typNm$ = " As Control"
    Else
        typNm$ = " As HWND"
    End If

    '-----------------------------------------------
    ' add menu constants and handles for menu system
    '-----------------------------------------------
    Call EmitMenuDef()

    '--------------------------------------------
    ' add windows EntryPoint, expand if requested
    '--------------------------------------------
    If opt.codelevel = CL_EXPANDED Then
        '****************************************************
        ' Modified: 10/29/2011, 3.4
        ' Added " As int WINAPI" to "WinMain" for expanded code
        '****************************************************
        FPrint DlgOut, "Function WinMain(hInst As HINSTANCE, hPrev As HINSTANCE, CmdLine As LPSTR, CmdShow%) As int WINAPI"
    ElseIf opt.codelevel = CL_COMPACT Then
        '****************************************************
        ' Modified: 1/1/2005, 3.2
        ' Corrected "Else If" to "ElseIf"
        '****************************************************
        FPrint DlgOut, "Function WinMain()"
    End If

    '--------------------------------------------------------
    ' for compact and expanded code levels, add form resizing
    ' code and form class registration
    '--------------------------------------------------------
    If opt.codelevel <> CL_SIMPLIFIED Then
        FPrint DlgOut, Align$(1), "Dim wc  As WNDCLASS"
        FPrint DlgOut, Align$(1), "Dim msg As MSG"

        '****************************************************
        ' Modified: 1/3/2005, 3.3
        ' Renamed hInstance to BCX_hInstance
        '****************************************************

        FPrint DlgOut, Align$(1), "Global BCX_hInstance As HINSTANCE"
        FPrint DlgOut, Align$(1), "Global BCX_ScaleX%"
        FPrint DlgOut, Align$(1), "Global BCX_ScaleY%"

        '****************************************************
        ' Modified: 1/3/2005, 3.3
        ' Changed the scaling method to reflect BCX 5.05-12
        '****************************************************

        FPrint DlgOut, ""
        FPrint DlgOut, Align$(1), "Set rc As RECT"
        FPrint DlgOut, Align$(2), "0, 0, 4, 8"
        FPrint DlgOut, Align$(1), "End Set"
        FPrint DlgOut, ""
        FPrint DlgOut, Align$(1), "BCX_hInstance = hInst"
        FPrint DlgOut, ""
        FPrint DlgOut, Align$(1), "MapDialogRect(NULL, &rc)"
        FPrint DlgOut, Align$(1), "BCX_ScaleX = rc.right / 2"
        FPrint DlgOut, Align$(1), "BCX_ScaleY = rc.bottom / 4"


        For i = 0 to numFrm - 1
            FPrint DlgOut, ""
            FPrint DlgOut, Align$(1), "wc.style           = CS_HREDRAW or CS_VREDRAW or CS_DBLCLKS"
            FPrint DlgOut, Align$(1), "wc.lpfnWndProc     = Form", NumToStr$(i + 1), "_Proc"
            FPrint DlgOut, Align$(1), "wc.cbClsExtra      = 0"
            FPrint DlgOut, Align$(1), "wc.cbWndExtra      = 0"
            FPrint DlgOut, Align$(1), "wc.hInstance       = hInst"
            FPrint DlgOut, Align$(1), "wc.hIcon           = LoadIcon  (NULL, IDI_WINLOGO)"
            FPrint DlgOut, Align$(1), "wc.hCursor         = LoadCursor(NULL, IDC_ARROW)"
            FPrint DlgOut, Align$(1), "wc.hbrBackground   = (HBRUSH)(COLOR_BTNFACE + 1)"
            FPrint DlgOut, Align$(1), "wc.lpszMenuName    = NULL"
            FPrint DlgOut, Align$(1), "wc.lpszClassName   = ", frm[i].class$
            FPrint DlgOut, Align$(1), "RegisterClass(&wc)"
        Next

        FPrint DlgOut, ""
        FPrint DlgOut, Align$(1), "FormLoad()"
        FPrint DlgOut, ""
        If opt.comments = True Then FPrint DlgOut, "' ", Repeat$(19, "*"), "[ This Message Pump Allows Tabbing ]", Repeat$(19, "*")
        FPrint DlgOut, ""
        FPrint DlgOut, Align$(1), "While GetMessage(&msg, NULL, 0, 0)"
        FPrint DlgOut, Align$(1), "    If Not IsWindow(GetActiveWindow()) or Not IsDialogMessage(GetActiveWindow(), &msg) Then"
        FPrint DlgOut, Align$(1), "        TranslateMessage(&msg)"
        FPrint DlgOut, Align$(1), "        DispatchMessage (&msg)"
        FPrint DlgOut, Align$(1), "    End If"
        FPrint DlgOut, Align$(1), "Wend"
        FPrint DlgOut, ""
        Call EmitSep()
        FPrint DlgOut, ""

        If opt.codelevel = CL_SIMPLIFIED And opt.mode = MODE_DC Then
        Else
            If useRichEdit1 = True or useRichEdit2 = True Then
                Call EmitComm("Remove RichEdit module from memory", 1)
                FPrint DlgOut, Align$(1), "Call FreeLibrary(dllRich)"
                FPrint DlgOut, ""
            End If
        End If

        FPrint DlgOut, Align$(1), "Function = msg.wParam"
        FPrint DlgOut, "End Function"    
        FPrint DlgOut, ""
        FPrint DlgOut, ""
    End If

    '-------------------------------------------------
    ' add userlevel entrypoint and necessary libraries
    '-------------------------------------------------
    FPrint DlgOut, "Sub FormLoad()"

    Call EmitDlls()

    '-------------------------
    ' generate form prototypes
    '-------------------------
    If opt.comments = True Then
        Call EmitSep()
        FPrint DlgOut, "' Create application forms and controls"
        Call EmitSep()
        FPrint DlgOut, ""
    End If

    For i = 0 to numFrm - 1
        FPrint DlgOut, Align$(1), "Global Form", NumToStr$(i + 1), typNm$
        FPrint DlgOut, ""

        '****************************************************
        ' Modified: 1/1/2005, 3.2
        ' Removed the WS_VISIBLE to prevent a window from
        ' displaying itself twice in DC mode
        '****************************************************
        frm[i].style$ = Replace$(frm[i].style$, "WS_VISIBLE or ", "")
        frm[i].style$ = Replace$(frm[i].style$, " or WS_VISIBLE", "")
        frm[i].style$ = Replace$(frm[i].style$, "WS_VISIBLE",     "")

        FPrint DlgOut, Align$(1), "Form", NumToStr$(i + 1), " = ";

        If opt.codelevel = CL_SIMPLIFIED Then
            FPrint DlgOut, "BCX_FORM(";
            If Len(Trim$(frm[i].text$)) > 0 Then
                FPrint DlgOut, frm[i].text$;

                FPrint DlgOut, ", ", frm[i].x$;
                FPrint DlgOut, ", ", frm[i].y$;
                FPrint DlgOut, ", ", frm[i].width$;
                FPrint DlgOut, ", ", frm[i].height$;

                If Len(frm[i].style$) Then
                    FPrint DlgOut, ", _"
                    FPrint DlgOut, Align$(2), frm[i].style$;
                End If
            End If
        Else
            FPrint DlgOut, "CreateWindowEx(";

            If Len(frm[i].exStyle$) Then
                FPrint DlgOut, Align$(2), frm[i].exStyle$;
            Else
                FPrint DlgOut, "0";
            End If

            FPrint DlgOut, ", ", frm[i].class$;
            FPrint DlgOut, ", ", frm[i].text$, ", _"

            If Len(frm[i].style$) Then
                FPrint DlgOut, Align$(2), frm[i].style$, ", _"
                FPrint DlgOut, Align$(2);
            Else
                FPrint DlgOut, Align$(2), "0, ";
            End If

            FPrint DlgOut, frm[i].x$, " * BCX_ScaleX";
            FPrint DlgOut, ", ", frm[i].y$, " * BCX_ScaleY";
            FPrint DlgOut, ", (4 + ", frm[i].width$, ") * BCX_ScaleX";
            FPrint DlgOut, ", (12 + ", frm[i].height$, ") * BCX_ScaleY, _"
            FPrint DlgOut, Align$(2), "NULL, NULL, BCX_hInstance, NULL";
        End If
        FPrint DlgOut, ")"

        If i > 0 Then
            FPrint DlgOut, ""
            FPrint DlgOut, Align$(1), "Global lpForm", NumToStr$(i + 1);
            FPrint DlgOut, "_Proc As WNDPROC"

            FPrint DlgOut, Align$(1), "lpForm", NumToStr$(i + 1), "_Proc = ";

            If opt.codelevel = CL_EXPANDED Then
                FPrint DlgOut, "((WNDPROC)SetWindowLong(Form", NumToStr$(i + 1), ", GWL_WNDPROC, _"
                FPrint DlgOut, Align$(2), "(LPARAM)(WNDPROC)Form", NumToStr$(i + 1), "_Proc))"
            Else
                FPrint DlgOut, "SubclassWindow(Form", NumToStr$(i + 1);
                FPrint DlgOut, ", Form", NumToStr$(i + 1), "_Proc)"
            End If
        End If

        FPrint DlgOut, ""
        Call EmitSep()
        FPrint DlgOut, ""
    Next

    '----------------------------
    ' generate control prototypes
    '----------------------------
    For i = 0 to numCtl - 1
        FPrint DlgOut, Align$(1), "Global ", ctl[i].owner$;
        FPrint DlgOut, ctlName$[ctl[i].token], NumToStr$(ctl[i].no), typNm$

        '-----------------------------
        ' generate control identifiers
        '-----------------------------
        tmp$ = "IDC_"
        tmp$ = tmp & UCase$(ctl[i].owner$) & UCase$(ctlName$[ctl[i].token]) & NumToStr$(ctl[i].no)

        '---------------------------------
        ' check if generated id and actual
        ' identifier are not the same
        '---------------------------------
        If LCase$(tmp$) <> LCase$(ctl[i].id$) Then
            FPrint DlgOut, Align$(1), "Const  ", tmp$, " = ", ctl[i].id$
            FPrint DlgOut, ""

            '------------------------------------
            ' set the new id name (for later use)
            '------------------------------------
            ctl[i].id$ = tmp$
        End If

        FPrint DlgOut, Align$(1), ctl[i].owner$;
        FPrint DlgOut, ctlName$[ctl[i].token], NumToStr$(ctl[i].no), " = ";

        If Trim$(ctl[i].text$) = "" Then ctl[i].text$ = Chr34$ & Chr34$

        If opt.codelevel = CL_SIMPLIFIED Then
            Select Case ctl[i].token
            Case TYP_BLACKRECT, TYP_BUTTON, TYP_CHECK, TYP_COMBO,     _
              TYP_CONTROL, TYP_DATEPICK, TYP_EDIT, TYP_GRAYRECT,      _
              TYP_GROUP, TYP_ICON, TYP_LABEL, TYP_LIST, TYP_LISTVIEW, _
              TYP_RADIO, TYP_RICHEDIT1, TYP_RICHEDIT2, TYP_TREE,      _
              TYP_WHITERECT, TYP_STATUS, TYP_INPUT

                FPrint DlgOut, "BCX_", UCase$(ctlName$[ctl[i].token]);
                FPrint DlgOut, "(", ctl[i].text$, ", _"
                FPrint DlgOut, Align$(2), "Form", NumToStr$(ctl[i].ownerN + 1), ", ", ctl[i].id$, ", ", ctl[i].x$, ", ", ctl[i].y$, ", ", ctl[i].width$, ", ", ctl[i].height$;

                '****************************************************
                ' Modified: 1/1/2005, 3.2
                ' BCX controls can now use Windows Styles if supplied
                '****************************************************
                If ctl[i].token <> TYP_STATUS Then
                    If Len(ctl[i].style$) Then
                        FPrint DlgOut, ", ", ctl[i].style$;
                        If Len(ctl[i].exStyle$) Then
                            FPrint DlgOut, ", ", ctl[i].exStyle$;
                        End If
                    End If
                End If

                FPrint DlgOut, ")"
            Case Else
                FPrint DlgOut, "BCX_CONTROL(";
                FPrint DlgOut, ctl[i].class$, ", Form", NumToStr$(ctl[i].ownerN + 1), ", ";
                FPrint DlgOut, ctl[i].text$, ", _"
                FPrint DlgOut, Align$(2), ctl[i].id$, ", ", ctl[i].x$, ", ", ctl[i].y$, ", ", ctl[i].width$, ", ", ctl[i].height$;
                If Len(ctl[i].style$) Then
                    FPrint DlgOut, ", _"
                    FPrint DlgOut, Align$(2), ctl[i].style$;
                    If Len(ctl[i].exStyle$) Then
                        FPrint DlgOut, ", ", ctl[i].exStyle$;
                    End If
                End If
                FPrint DlgOut, ")"
            End Select
        Else
            FPrint DlgOut, "CreateWindowEx(";

            If Len(ctl[i].exStyle$) Then
                FPrint DlgOut, Align$(2), ctl[i].exStyle$;
            Else
                FPrint DlgOut, "0";
            End If

            FPrint DlgOut, ", ", ctl[i].class$;
            FPrint DlgOut, ", ", ctl[i].text$, ", _"

            If Len(ctl[i].style$) Then
                FPrint DlgOut, Align$(2), ctl[i].style$, ", _"
                FPrint DlgOut, Align$(2);
            Else
                FPrint DlgOut, Align$(2), "0, ";
            End If

            FPrint DlgOut, ctl[i].x$, " * BCX_ScaleX";
            FPrint DlgOut, ", ", ctl[i].y$, " * BCX_ScaleY";
            FPrint DlgOut, ", ", ctl[i].width$, " * BCX_ScaleX";
            FPrint DlgOut, ", ", ctl[i].height$, " * BCX_ScaleY, _"
            FPrint DlgOut, Align$(2), "Form", NumToStr$(ctl[i].ownerN + 1), ", ", ctl[i].id$, ", BCX_hInstance, NULL)"
        End If

        If opt.codelevel <> CL_SIMPLIFIED Then
            FPrint DlgOut, ""
            FPrint DlgOut, Align$(1), "SendMessage(";
            FPrint DlgOut, ctl[i].owner$, ctlName$[ctl[i].token], NumToStr$(ctl[i].no);
            FPrint DlgOut, ", WM_SETFONT, _"
            FPrint DlgOut, Align$(2), "GetStockObject(DEFAULT_GUI_FONT), MAKELPARAM(False, 0))"
        End If

        If opt.subclass = True Then
            FPrint DlgOut, ""

            FPrint DlgOut, Align$(1), "Global lp", ctl[i].owner$;
            FPrint DlgOut, ctlName$[ctl[i].token], NumToStr$(ctl[i].no), "_Proc As WNDPROC"

            FPrint DlgOut, Align$(pos), "lp", ctl[i].owner$;
            FPrint DlgOut, ctlName$[ctl[i].token], NumToStr$(ctl[i].no), "_Proc = ";

            If opt.codelevel = CL_EXPANDED Then
                FPrint DlgOut, "((WNDPROC)SetWindowLong(", ctl[i].owner$, ctlName$[ctl[i].token], NumToStr$(ctl[i].no), ", GWL_WNDPROC, _"
                FPrint DlgOut, Align$(pos + 1), "(LPARAM)(WNDPROC)", ctl[i].owner$, ctlName$[ctl[i].token], NumToStr$(ctl[i].no), "_Proc))"
            Else
                FPrint DlgOut, "SubclassWindow(", ctl[i].owner$, ctlName$[ctl[i].token], NumToStr$(ctl[i].no);
                FPrint DlgOut, ", ", ctl[i].owner$, ctlName$[ctl[i].token], NumToStr$(ctl[i].no), "_Proc)"
            End If
        End If

        FPrint DlgOut, ""
        Call EmitSep()
        FPrint DlgOut, ""
    Next

    '-----------------------
    ' add menu creation code
    '-----------------------
    Call EmitMenu()

    '--------------------------
    ' generate show/center form
    '--------------------------
    For i = 0 to numFrm - 1
        FPrint DlgOut, Align$(1), "Call Center(Form", NumToStr$(i + 1), ")"

        '****************************************************
        ' Modified: 1/1/2005, 3.2
        ' Uses ShowWindow when in Expanded mode
        '****************************************************
        If opt.codelevel = CL_EXPANDED Then
            FPrint DlgOut, Align$(1), "Call ShowWindow(Form", NumToStr$(i + 1), ", SW_SHOW)"
        Else
            FPrint DlgOut, Align$(1), "Call Show(Form", NumToStr$(i + 1), ")"
        End If

        If i <> numFrm - 1 Then FPrint DlgOut, ""
    Next

    FPrint DlgOut, "End Sub"

    '--------------------------------------------------
    ' for simplified code level, add simplified WndProc
    '--------------------------------------------------
    If opt.codelevel = CL_SIMPLIFIED Then
        FPrint DlgOut, ""
        FPrint DlgOut, ""
        FPrint DlgOut, "Begin Events"
        FPrint DlgOut, Align$(1), "Select Case CBMSG"
        Call EmitSep()
        FPrint DlgOut, Align$(1), "Case WM_COMMAND"
        Call EmitSep()
        FPrint DlgOut, ""
        Call EmitSep()
        FPrint DlgOut, Align$(1), "Case WM_CLOSE"
        Call EmitSep()
        FPrint DlgOut, ""
        Call EmitSep()
        FPrint DlgOut, Align$(1), "Case WM_DESTROY"
        Call EmitSep()
        FPrint DlgOut, Align$(2), "PostQuitMessage(0)"
        FPrint DlgOut, Align$(2), "Exit Function"
        FPrint DlgOut, Align$(1), "End Select"
        FPrint DlgOut, "End Events"
    End If

    '-----------------------------------------------------------------------
    ' create form callback functions, exists even if subclassing is disabled
    '-----------------------------------------------------------------------
    For i = 0 to numFrm - 1
        If opt.codelevel = CL_SIMPLIFIED And i = 0 Then i = 1
        If i > numFrm - 1 Then Exit For

        FPrint DlgOut, ""
        FPrint DlgOut, ""

        If opt.codelevel <> CL_EXPANDED Then
            FPrint DlgOut, "Callback ";
        End If

        FPrint DlgOut, "Function Form", NumToStr$(i + 1), "_Proc(";

        If opt.codelevel = CL_EXPANDED Then
            FPrint DlgOut, "hWnd As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT CALLBACK"
        Else
            FPrint DlgOut, ")"
        End If

        FPrint DlgOut, Align$(1), "Select Case CBMSG"
        Call EmitSep()
        FPrint DlgOut, Align$(1), "Case WM_COMMAND"
        Call EmitSep()
        FPrint DlgOut, ""
        Call EmitSep()
        FPrint DlgOut, Align$(1), "Case WM_CLOSE"
        Call EmitSep()
        FPrint DlgOut, Align$(2), "Dim Raw id"
        FPrint DlgOut, ""
        FPrint DlgOut, Align$(2), "id = MessageBox(     _"
        FPrint DlgOut, Align$(3), "hWnd,            _"
        FPrint DlgOut, Align$(3), Chr34$, "Are you sure?", Chr34$, ", _"
        FPrint DlgOut, Align$(3), Chr34$, "Close Window!", Chr34$, ", _"
        FPrint DlgOut, Align$(3), "MB_YESNO or MB_ICONQUESTION)"
        FPrint DlgOut, ""

        If i = 0 Then
            FPrint DlgOut, Align$(2), "If id = IDYES Then DestroyWindow(hWnd)"
        Else
            FPrint DlgOut, Align$(2), "If id = IDYES Then ShowWindow(hWnd, SW_HIDE)"
        End If

        FPrint DlgOut, Align$(2), "Exit Function"
        FPrint DlgOut, ""
        Call EmitSep()
        FPrint DlgOut, Align$(1), "Case WM_DESTROY"
        Call EmitSep()
        FPrint DlgOut, Align$(2), "PostQuitMessage(0)"
        FPrint DlgOut, Align$(1), "End Select"
        FPrint DlgOut, ""
        FPrint DlgOut, Align$(1), "Function = DefWindowProc(hWnd, Msg, wParam, lParam)"
        FPrint DlgOut, "End Function"
    Next

    '----------------------------------
    ' create control callback functions
    '----------------------------------
    If opt.subclass = True Then
        For i = 0 to numCtl - 1
            FPrint DlgOut, ""
            FPrint DlgOut, ""

            If opt.codelevel <> CL_EXPANDED Then
                FPrint DlgOut, "Callback ";
            End If

            FPrint DlgOut, "Function ", ctl[i].owner$, ctlName$[ctl[i].token], NumToStr$(ctl[i].no), "_Proc(";

            If opt.codelevel = CL_EXPANDED Then
                FPrint DlgOut, "hWnd As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT CALLBACK"
            Else
                FPrint DlgOut, ")"
            End If

            FPrint DlgOut, Align$(1), "Select Case CBMSG"
            Call EmitSep()
            FPrint DlgOut, Align$(1), "Case WM_LBUTTONDBLCLK"
            Call EmitSep()
            FPrint DlgOut, Align$(2), "MsgBox ", Chr34$, ctlName$[ctl[i].token], " ", NumToStr$(ctl[i].no), " Double Clicked", Chr34$
            FPrint DlgOut, Align$(2), "Exit Function"
            FPrint DlgOut, Align$(1), "End Select"
            FPrint DlgOut, ""
            FPrint DlgOut, Align$(1), "Function = CallWindowProc(lp", ctl[i].owner$, ctlName$[ctl[i].token], NumToStr$(ctl[i].no), "_Proc, hWnd, Msg, wParam, lParam)"
            FPrint DlgOut, "End Function"
        Next
    End If
End Sub


' -------------------------------------------------------------------------
' Generate Dialog Starter code
' -------------------------------------------------------------------------
Sub MakeDS()
    Dim Raw i% ' temporary variable
    Dim Raw j% ' temporary variable
    Dim tmp$   ' temporary buffer

    '-----------------------------------
    ' don't waste time if nothing exists
    '-----------------------------------
    If numFrm = 0 Then Exit Sub

    '-------------------------------------
    ' add all form and control identifiers
    '-------------------------------------
    Call EmitComm("Form/Control Identifiers")
    For i = 0 to numFrm - 1
        tmp$ = "IDD_FORM" & NumToStr$(i + 1)

        If LCase$(tmp$) <> LCase$(frm[i].id$) Then
            FPrint DlgOut, "Const ", tmp$, " = ", frm[i].id$
        End If
    Next

    For i = 0 to numCtl - 1
        '-----------------------------
        ' generate control identifiers
        '-----------------------------
        tmp$ = "IDC_"
        tmp$ = tmp & UCase$(ctl[i].owner$) & UCase$(ctlName$[ctl[i].token]) & NumToStr$(ctl[i].no)

        '---------------------------------
        ' check if generated id and actual
        ' identifier are not the same
        '---------------------------------
        If LCase$(tmp$) <> LCase$(ctl[i].id$) Then
            FPrint DlgOut, "Const ", tmp$, " = ", ctl[i].id$

            '------------------------------------
            ' set the new id name (for later use)
            '------------------------------------
            ctl[i].id$ = tmp$
        End If
    Next
    FPrint DlgOut, ""

    '-----------------------
    ' add menu creation code
    '-----------------------
    Call EmitMenuDef()

    '-------------------------
    ' add form/control handles
    '-------------------------
    Call EmitComm("Form/control handles")

    For i = 0 to numFrm - 1
        FPrint DlgOut, "Global Form", NumToStr$(i + 1), " As HWND"
    Next

    For i = 0 to numCtl - 1
        FPrint DlgOut, "Global ", ctl[i].owner$;
        FPrint DlgOut, ctlName$[ctl[i].token], NumToStr$(ctl[i].no), " As HWND"
    Next

    FPrint DlgOut, ""

    '------------------------
    ' add subclassing handles
    '------------------------
    If opt.subclass = True Then
        Call EmitComm("Control subclass handles")

        For i = 0 to numCtl - 1
            FPrint DlgOut, "Global lp", ctl[i].owner$;
            FPrint DlgOut, ctlName$[ctl[i].token], NumToStr$(ctl[i].no), "_Proc As WNDPROC"
        Next

        FPrint DlgOut, ""
    End If

    '--------------------------------------------
    ' add windows EntryPoint, expand if requested
    '--------------------------------------------
    If opt.codelevel = CL_EXPANDED Then
        '****************************************************
        ' Modified: 10/29/2011, 3.4
        ' Added " As int WINAPI" to "WinMain" for expanded code
        '****************************************************
        FPrint DlgOut, "Function WinMain(hInst As HINSTANCE, hPrev As HINSTANCE, CmdLine As LPSTR, CmdShow%) As int WINAPI"
    Else Then
        FPrint DlgOut, "Function WinMain()"
    End If

    Call EmitDlls()

    '-------------------------
    ' generate form prototypes
    '-------------------------
    Call EmitComm("Initialize our dialog, pointing it to the dialog procedure", 1)

    For i = 0 to numFrm - 1
        If opt.codelevel = CL_EXPANDED Then
            FPrint DlgOut, Align$(1), "Call DialogBoxParam(hInst, MAKEINTRESOURCE(IDD_FORM", NumToStr$(i + 1), "), NULL, (DLGPROC)Form", NumToStr$(i + 1), "_Proc, 0L)"
        Else
            FPrint DlgOut, Align$(1), "Call DialogBox(hInst, MAKEINTRESOURCE(IDD_FORM", NumToStr$(i + 1), "), NULL, (DLGPROC)Form", NumToStr$(i + 1), "_Proc)"
        End If
    Next
    FPrint DlgOut, ""

    If useRichEdit1 = True or useRichEdit2 = True Then
        Call EmitComm("Remove RichEdit module from memory", 1)
        FPrint DlgOut, Align$(1), "Call FreeLibrary(dllRich)"
        FPrint DlgOut, ""
    End If

    FPrint DlgOut, Align$(1), "Function = False"
    FPrint DlgOut, "End Function"

    '-----------------------------------------------------------------------
    ' create form callback functions, exists even if subclassing is disabled
    '-----------------------------------------------------------------------
    For i = 0 to numFrm - 1
        FPrint DlgOut, ""
        FPrint DlgOut, ""

        If opt.codelevel <> CL_EXPANDED Then
            FPrint DlgOut, "Callback ";
        End If

        FPrint DlgOut, "Function Form", NumToStr$(i + 1), "_Proc(";

        If opt.codelevel = CL_EXPANDED Then
            FPrint DlgOut, "hWnd As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT CALLBACK"
        Else
            FPrint DlgOut, ")"
        End If

        FPrint DlgOut, Align$(1), "Select Case CBMSG"
        Call EmitSep()
        FPrint DlgOut, Align$(1), "Case WM_INITDIALOG"
        Call EmitSep()
        Call EmitComm("Retrieves the dialog/control handles", 2)
        FPrint DlgOut, Align$(2), "Form", NumToStr$(i + 1), " = hWnd"

        For j = 0 to numCtl - 1
            If ctl[j].ownerN = i Then
                FPrint DlgOut, Align$(2), ctl[j].owner$, ctlName$[ctl[j].token], NumToStr$(ctl[j].no), " = GetDlgItem(hWnd, ", ctl[j].id$, ")"
            End If
        Next
        FPrint DlgOut, ""

        If opt.subclass = True Then
            Call EmitComm("Give controls separate proc functions", 2)
            For j = 0 to numCtl - 1
                If ctl[j].ownerN = i Then
                    FPrint DlgOut, Align$(2), "lp", ctl[j].owner$;
                    FPrint DlgOut, ctlName$[ctl[j].token], NumToStr$(ctl[j].no), "_Proc = ";

                    If opt.codelevel = CL_EXPANDED Then
                        FPrint DlgOut, "((WNDPROC)SetWindowLong(", ctl[j].owner$, ctlName$[ctl[j].token], NumToStr$(ctl[j].no), ", GWL_WNDPROC, _"
                        FPrint DlgOut, Align$(3), "(LPARAM)(WNDPROC)", ctl[j].owner$, ctlName$[ctl[j].token], NumToStr$(ctl[j].no), "_Proc))"
                    Else
                        FPrint DlgOut, "SubclassWindow(", ctl[j].owner$, ctlName$[ctl[j].token], NumToStr$(ctl[j].no);
                        FPrint DlgOut, ", ", ctl[j].owner$, ctlName$[ctl[j].token], NumToStr$(ctl[j].no), "_Proc)"
                    End If
                End If
            Next
            FPrint DlgOut, ""
        End If

        If i = 0 Then Call EmitMenu()

        Call EmitComm("Set other window properties", 2)
        FPrint DlgOut, Align$(2), "Center(hWnd)"
        FPrint DlgOut, ""
        Call EmitSep()
        FPrint DlgOut, Align$(1), "Case WM_CLOSE"
        Call EmitSep()
        Call EmitComm("Free our dialog", 2)
        FPrint DlgOut, Align$(2), "EndDialog(hWnd, True)"
        FPrint DlgOut, ""
        Call EmitSep()
        FPrint DlgOut, Align$(1), "Case Else"
        Call EmitSep()
        Call EmitComm("No messages processed, return false", 2)
        FPrint DlgOut, Align$(2), "Function = False"
        FPrint DlgOut, Align$(1), "End Select"
        FPrint DlgOut, ""
        Call EmitComm("If we reach this point, that means a message was processed", 1)
        Call EmitComm("and we send a true value", 1)
        FPrint DlgOut, Align$(1), "Function = True"
        FPrint DlgOut, "End Function"
    Next

    '----------------------------------
    ' create control callback functions
    '----------------------------------
    If opt.subclass = True Then
        For i = 0 to numCtl - 1
            FPrint DlgOut, ""
            FPrint DlgOut, ""

            If opt.codelevel <> CL_EXPANDED Then
                FPrint DlgOut, "Callback ";
            End If

            FPrint DlgOut, "Function ", ctl[i].owner$, ctlName$[ctl[i].token], NumToStr$(ctl[i].no), "_Proc(";

            If opt.codelevel = CL_EXPANDED Then
                FPrint DlgOut, "hWnd As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT CALLBACK"
            Else
                FPrint DlgOut, ")"
            End If

            FPrint DlgOut, Align$(1), "Select Case CBMSG"
            Call EmitSep()
            FPrint DlgOut, Align$(1), "Case WM_LBUTTONDBLCLK"
            Call EmitSep()
            FPrint DlgOut, Align$(2), "MsgBox ", Chr34$, ctlName$[ctl[i].token], " ", NumToStr$(ctl[i].no), " Double Clicked", Chr34$
            FPrint DlgOut, Align$(2), "Exit Function"
            FPrint DlgOut, ""
            Call EmitSep()
            FPrint DlgOut, Align$(1), "Case Else"
            Call EmitSep()
            Call EmitComm("No messages have been processed", 2)
            FPrint DlgOut, Align$(2), "Function = CallWindowProc(lp", ctl[i].owner$, ctlName$[ctl[i].token], NumToStr$(ctl[i].no), "_Proc, hWnd, Msg, wParam, lParam)"
            FPrint DlgOut, Align$(1), "End Select"
            FPrint DlgOut, ""
            Call EmitComm("Default message has been processed", 1)
            FPrint DlgOut, Align$(1), "Function = True"
            FPrint DlgOut, "End Function"
        Next
    End If
End Sub


' -------------------------------------------------------------------------
' Prints the asterisk separator
' -------------------------------------------------------------------------
Sub EmitSep()
    If opt.comments = True Then
        FPrint DlgOut, "' ", Repeat$(73, "*")
    End If
End Sub


' -------------------------------------------------------------------------
' Prints the comment
' -------------------------------------------------------------------------
Sub EmitComm Optional (comment$, space% = 0)
    If opt.comments = True Then
        FPrint DlgOut, Align$(space), "' ", comment$
    End If
End Sub


' -------------------------------------------------------------------------
' Prints menu definition
' -------------------------------------------------------------------------
Sub EmitMenuDef()
    If opt.menu = True Then
        Call EmitComm("Menu identifiers and handles")

        FPrint DlgOut, "Const IDM_EDIT    = 1001"
        FPrint DlgOut, "Const IDM_OPTIONS = 1002"
        FPrint DlgOut, "Const IDM_OPEN    = 1003"
        FPrint DlgOut, "Const IDM_CLOSE   = 1004"
        FPrint DlgOut, "Const IDM_SAVE    = 1005"
        FPrint DlgOut, "Const IDM_SAVEAS  = 1006"
        FPrint DlgOut, "Const IDM_EXIT    = 1007"
        FPrint DlgOut, ""
        FPrint DlgOut, "Global MainMenu As HANDLE"
        FPrint DlgOut, "Global FileMenu As HANDLE"
        FPrint DlgOut, ""
    End If
End Sub


' -------------------------------------------------------------------------
' Prints menu
' -------------------------------------------------------------------------
Sub EmitMenu()
    If opt.menu = True Then
        FPrint DlgOut, Align$(1), "MainMenu = CreateMenu()"
        FPrint DlgOut, Align$(1), "FileMenu = CreateMenu()"
        FPrint DlgOut, ""
        FPrint DlgOut, Align$(1), "AppendMenu(FileMenu, MF_STRING, IDM_OPEN, ", Chr34$, "&Open", Chr34$, ")"
        FPrint DlgOut, Align$(1), "AppendMenu(FileMenu, MF_STRING, IDM_SAVE, ", Chr34$, "&Save", Chr34$, ")"
        FPrint DlgOut, Align$(1), "AppendMenu(FileMenu, MF_STRING, IDM_SAVEAS, ", Chr34$, "Save&As", Chr34$, ")"
        FPrint DlgOut, Align$(1), "AppendMenu(FileMenu, MF_SEPARATOR, 0, ", Chr34$, Chr34$, ")"
        FPrint DlgOut, Align$(1), "AppendMenu(FileMenu, MF_STRING, IDM_CLOSE, ", Chr34$, "&Close", Chr34$, ")"
        FPrint DlgOut, Align$(1), "AppendMenu(FileMenu, MF_SEPARATOR, 0, ", Chr34$, Chr34$, ")"
        FPrint DlgOut, Align$(1), "AppendMenu(FileMenu, MF_STRING, IDM_EXIT, ", Chr34$, "E&xit", Chr34$, ")"
        FPrint DlgOut, Align$(1), "AppendMenu(MainMenu, MF_STRING, IDM_EDIT, ", Chr34$, "Edit", Chr34$, ")"
        FPrint DlgOut, Align$(1), "AppendMenu(MainMenu, MF_STRING, IDM_OPTIONS, ", Chr34$, "Options", Chr34$, ")"
        FPrint DlgOut, ""
        FPrint DlgOut, Align$(1), "InsertMenu (MainMenu, IDM_EDIT, MF_POPUP, FileMenu, ", Chr34$, "File", Chr34$, ")"
        FPrint DlgOut, Align$(1), "SetMenu(Form1, MainMenu)"
        FPrint DlgOut, ""
        Call EmitSep()
        FPrint DlgOut, ""
    End If
End Sub


' -------------------------------------------------------------------------
' Add code for required libraries
' -------------------------------------------------------------------------
Sub EmitDlls()
    If opt.codelevel = CL_SIMPLIFIED And opt.mode = MODE_DC Then
    Else
        If useRichEdit1 = True or useRichEdit2 = True Then
            FPrint DlgOut, Align$(1), "Global dllRich As HMODULE"
        End If
    End If

    If useCommCtrl = True Then
        FPrint DlgOut, Align$(1), "Global icex As INITCOMMONCONTROLSEX"
    End If

    If opt.codelevel = CL_SIMPLIFIED And opt.mode = MODE_DC Then
    Else
        If useRichEdit1 = True or useRichEdit2 = True Then
        FPrint DlgOut, ""
        End If
    End If

    If opt.codelevel = CL_SIMPLIFIED And opt.mode = MODE_DC Then
    Else
        If useRichEdit1 = True Then
            FPrint DlgOut, Align$(1), "dllRich = LoadLibrary(", Chr34$, "riched32.dll", Chr34$, ")"
        End If

        If useRichEdit2 = True Then
            FPrint DlgOut, Align$(1), "dllRich = LoadLibrary(", Chr34$, "riched20.dll", Chr34$, ")"
        End If
    End If

    If useCommCtrl = True Then
        FPrint DlgOut, ""
        FPrint DlgOut, Align$(1), "icex.dwSize = sizeof(INITCOMMONCONTROLSEX)"
        FPrint DlgOut, Align$(1), "icex.dwICC  = ICC_COOL_CLASSES or ICC_DATE_CLASSES or _"
        FPrint DlgOut, Align$(1), "    ICC_INTERNET_CLASSES or ICC_PAGESCROLLER_CLASS or _"
        FPrint DlgOut, Align$(1), "    ICC_USEREX_CLASSES or ICC_WIN95_CLASSES"
        FPrint DlgOut, Align$(1), "InitCommonControlsEx(&icex)"
        FPrint DlgOut, ""
    End If
End Sub


' -------------------------------------------------------------------------
' Returns space alignment
' -------------------------------------------------------------------------
Function Align$(num)
    Function = Repeat$(num * opt.align, " ")
End Function


' -------------------------------------------------------------------------
' Opens the dialog script for reading
' -------------------------------------------------------------------------
Sub AnalyzeDlg(file$)
    Dim dlgData$     ' file content buffer
    Dim realData$    ' dialog script buffer
    Dim tokNum%      ' number of tokens
    Dim token$[1024] ' processes upto 1024 tokens per line
    Dim tokDel$      ' token delimiters

    tokDel$ = " ,|" & Chr$(9)

    Open file$ For Input As fDlgIn
    While Not Eof(fDlgIn)
        Line Input fDlgIn, dlgData$

        '----------------------------
        ' join separated script lines
        '----------------------------
        dlgData$  = Trim$(dlgData$)
        realData$ = realData$ & " " & dlgData$

        '----------------------------
        ' check if line is continuous
        '----------------------------
        If Right$(dlgData$, 1) <> "|" And Right$(LCase$(dlgData$), 3) <> "not" And _
          Right$(dlgData$, 1)  <> "," And Right$(LCase$(dlgData$), 2) <> "or"  And _
          Len(dlgData$) Then
            '---------------------------
            ' remove unnecessary padding
            '---------------------------
            realData$ = EatSpaces$(realData$)
            tokNum = Tokenize(token$, realData$, tokDel$)

            '------------------
            ' add include files
            '------------------
            If opt.include = True Then
                If LCase$(token$[0]) = "#include" And incNum <= 20 Then
                    If token[1][0] = 34 And Lof(UnQuote$(token$[1])) > 0 Then
                        incFile$[incNum] = UnQuote$(token$[1])

                        Incr incNum
                    End If
                End If
            End If

            Call AnalyzeTokens(token$, tokNum)

            realData$ = ""
        End If
    Wend
    Close fDlgIn
End Sub


' -------------------------------------------------------------------------
' Creates tokens and places them into their dialog or control array
' -------------------------------------------------------------------------
Sub AnalyzeTokens(token$[], tokNum%)
    Dim Static inDlg% ' part of dialog we are currently processing
    Dim Raw idx%      ' temporary index
    Dim typ%          ' token type
    Dim tmp%          ' temporary integer
    Dim comma%        ' comma location
    Dim style$        ' style buffer
    Dim class$        ' class buffer

    typ = TYP_ERROR
    '----------------
    ' check if dialog
    '----------------
    Select Case UCase$(token$[1])
    Case "DIALOG"
        typ   = TYP_DIALOG
        inDlg = DLG_OPEN
    Case "DIALOGEX"
        typ = TYP_DIALOGEX
        inDlg = DLG_OPEN
    End Select

    '------------------------
    ' grab values for dialogs
    '------------------------
    If typ <> TYP_ERROR Then
        If numFrm >= dynFrm Then Call AddMoreForms()

        frm[numFrm].class$  = Chr34$ & "Your Application Class" & Chr34$
        frm[numFrm].x$      = token$[tokNum - 7]
        frm[numFrm].y$      = token$[tokNum - 5]
        frm[numFrm].width$  = token$[tokNum - 3]
        frm[numFrm].height$ = token$[tokNum - 1]
        frm[numFrm].$id     = token$[0]
    End If

    typ = TYP_ERROR

    '--------------------------------
    ' look for most standard controls
    '--------------------------------
    For idx = 0 To 12
        If UCase$(UnQuote$(token$[0])) = UCase$(ctrlPak1$[idx]) Then
            typ    = mapTyp1[idx]
            class$ = ctrlCls$[mapCls1[idx]]

            comma = LocComma(token$, tokNum, 6)
            If comma <> -1 Then
                style$ = GrabTokens$(token$, tokNum, comma + 1)
            Else
                style$ = ""
            End If

            style$ = AddStyle$(stylPak1$[idx], style$)

            If mapCls1[idx] = CLS_BUTTON Then
                style$ = AddStyle$("WS_TABSTOP", style$)
            ElseIf typ = TYP_LABEL Then
                style$ = AddStyle$("WS_GROUP", style$)
            End If

            style$ = AddStyle$("WS_VISIBLE", style$)
            style$ = AddStyle$("WS_CHILD", style$)

            $IF DEBUG_MODE
                Print "     Token : ", token$
                Print "     Tok # : ", tokNum
                Print "     Styles: ", style$
                Print "     Class : ", class$
            $ENDIF

            Call SetCtrlInfo(token$, tokNum, typ, class$, style$, 1, 5, 7, 9, 11, 3, 7)
            Exit For
        End If
    Next

    '---------------------------------------
    ' look for edit/list/combo/scroll tokens
    '---------------------------------------
    For idx = 13 To 16
        If UCase$(UnQuote$(token$[0])) = UCase$(ctrlPak1$[idx]) Then
            typ    = mapTyp1[idx]
            class$ = ctrlCls$[mapCls1[idx]]

            comma = LocComma(token$, tokNum, 5)
            If comma <> -1 Then
                style$ = GrabTokens$(token$, tokNum, comma + 1)
            Else
                style$ = ""
            End If

            style$ = AddStyle$(stylPak1$[idx], style$)
            style$ = AddStyle$("WS_VISIBLE", style$)
            style$ = AddStyle$("WS_CHILD", style$)

            If Instr(UCase$(style$), "SBS_VERT") > 0 Then
                typ = TYP_VSCROLL
            End If

            If typ = TYP_EDIT Then  style$ = AddStyle$("ES_LEFT", style$)
            If typ = TYP_EDIT Then  style$ = AddStyle$("WS_BORDER", style$)
            If typ = TYP_LIST Then  style$ = AddStyle$("WS_BORDER", style$)
            If typ = TYP_COMBO Then style$ = AddStyle$("WS_TABSTOP", style$) 

            '****************************************************
            ' Modified: 1/3/2005, 3.3
            ' Added support for BCX_Input
            '****************************************************
            If typ = TYP_EDIT and opt.codelevel = CL_SIMPLIFIED and Len(style$) > 0 Then
                typ = TYP_INPUT
                class$ = "Input"

                For tmp = comma + 1 To tokNum - 1
                    '-------------------------------------
                    ' look for the text style ES_MULTILINE
                    '-------------------------------------
                    If UCase$(token$[tmp]) = "ES_MULTILINE" Then
                        typ = TYP_EDIT
                        class$ = "Edit"

                        Exit For
                    End If

                    '---------------------------------------------
                    ' look for the hex style ES_MULTILINE (0x0004)
                    '---------------------------------------------
                    If Len(token$[tmp]) > 2 and LCase$(Left$(token$[tmp], 2)) = "0x" Then
                        If Hex2Dec(token$[tmp]) BOR 0x0004 = Hex2Dec(token$[tmp]) Then
                            typ = TYP_EDIT
                            class$ = "Edit"

                            Exit For
                        End If
                    End If
                Next
            End If

            $IF DEBUG_MODE
                Print "     Token : ", token$
                Print "     Tok # : ", tokNum
                Print "     Styles: ", style$
                Print "     Class : ", class$
            $ENDIF

            Call SetCtrlInfo(token$, tokNum, typ, class$, style$, 0, 3, 5, 7, 9, 1, 6)
            Exit For
        End If
    Next

    '---------------
    ' check for icon
    '---------------
    If UCase$(token$[0]) = "ICON" Then
        typ = TYP_ICON
        class$ = ctrlCls$[CLS_STATIC]
        style$ = GrabTokens$(token$, tokNum, 6)
        style$ = AddStyle$("WS_VISIBLE", style$)
        style$ = AddStyle$("WS_CHILD", style$)

        $IF DEBUG_MODE
            Print "     Token : ", token$
            Print "     Tok # : ", tokNum
            Print "     Styles: ", style$
            Print "     Class : ", class$
        $ENDIF

        Call SetCtrlInfo(token$, tokNum, typ, class$, style$, 0, 5, 7, 9, 11, 3, 7)
    End If

    '------------------------------
    ' check for all custom controls
    '------------------------------
    If UCase$(token$[0]) = "CONTROL" Then
        typ    = TYP_CONTROL
        class$ = token$[5]
        style$ = GrabTokens$(token$, tokNum, 7)
        style$ = AddStyle$("WS_VISIBLE", style$)
        style$ = AddStyle$("WS_CHILD", style$)

        For idx = 17 to 82
            If UCase$(UnQuote$(token$[5])) = UCase$(ctrlPak1$[idx]) Then
                typ = mapTyp1[idx]
            End If
        Next

        If typ = TYP_LABEL Then
            If Instr(LCase$(style$), "ss_icon") > 0 Then typ = TYP_ICON
            If Instr(LCase$(style$), "ss_bitmap") > 0 Then typ = TYP_BITMAP
            If Instr(LCase$(style$), "ss_whiterect") > 0 Then typ = TYP_WHITERECT
            If Instr(LCase$(style$), "ss_blackrect") > 0 Then typ = TYP_BLACKRECT
            If Instr(LCase$(style$), "ss_grayrect") > 0 Then typ = TYP_GRAYRECT
            If Instr(LCase$(style$), "ss_whiteframe") > 0 Then typ = TYP_WHITEFRAME
            If Instr(LCase$(style$), "ss_blackframe") > 0 Then typ = TYP_BLACKFRAME
            If Instr(LCase$(style$), "ss_grayframe") > 0 Then typ = TYP_GRAYFRAME
        End If

        If typ = TYP_HSCROLL Then
            If Instr(LCase$(style$), "sbs_vert") > 0 Then typ = TYP_VSCROLL
        End If

        If typ = TYP_BUTTON Then
            If Instr(LCase$(style$), "bs_autocheckbox") > 0 Then typ = TYP_CHECK
            If Instr(LCase$(style$), "bs_auto3state") > 0 Then typ = TYP_CHECK
            If Instr(LCase$(style$), "bs_3state") > 0 Then typ = TYP_CHECK
            If Instr(LCase$(style$), "bs_autoradiobutton") > 0 Then typ = TYP_RADIO
        End If

        If typ = TYP_RICHEDIT1 Then useRichEdit1 = True
        If typ = TYP_RICHEDIT2 Then useRichEdit2 = True
        If typ >= TYP_PAGER And typ <= TYP_COMBOEX Then
            useCommCtrl = True
        End If

        $IF DEBUG_MODE
            Print "     Token : ", token$
            Print "     Tok # : ", tokNum
            Print "     Styles: ", style$
            Print "     Class : ", class$
        $ENDIF

        Call SetCtrlInfo(token$, tokNum, typ, class$, style$, 1, 0, 0, 0, 0, 3, 8)

        '---------------------------------------
        ' grab real data (due to style location)
        '---------------------------------------
        ctl[numCtl - 1].x$       = token$[LocComma(token$, tokNum, 4) + 1]
        ctl[numCtl - 1].y$       = token$[LocComma(token$, tokNum, 5) + 1]
        ctl[numCtl - 1].width$   = token$[LocComma(token$, tokNum, 6) + 1]
        ctl[numCtl - 1].height$  = token$[LocComma(token$, tokNum, 7) + 1]
    End If

    '--------------------------------
    ' check if dialog opens or closes
    '--------------------------------
    Select Case UCase$(token$[0])
    Case "BEGIN", "{"
        typ = TYP_BLOCKSTART

        If inDlg = DLG_OPEN Then
            If opt.status = True Then ? " --> Found Form", NumToStr$(numFrm + 1)

            inDlg = DLG_BEGIN
        End If
    Case "END", "}"
        typ = TYP_BLOCKEND

        If inDlg = DLG_BEGIN Then
            inDlg = DLG_END

            Incr numFrm

            '-------------------------------
            ' reset number of controls found
            '-------------------------------
            For idx = 0 To 41
                curCtrl[idx] = 0
            Next
        End If
    End Select

    '-------------------------
    ' check if dialog property
    '-------------------------
    If inDlg = DLG_OPEN Then
        Select Case UCase$(token$[0])
        Case "STYLE"
            typ = TYP_STYLE
            frm[numFrm].style$ = GrabTokens$(token$, tokNum, 1)
        Case "EXSTYLE"
            typ = TYP_EXSTYLE
            frm[numFrm].exStyle$ = GrabTokens$(token$, tokNum, 1)
        Case "CLASS"
            typ = TYP_CLASS
            frm[numFrm].class$ = token$[1]
        Case "CAPTION"
            typ = TYP_CAPTION
            frm[numFrm].text$ = token$[1]
        End Select
    End If
End Sub


' -------------------------------------------------------------------------
' Sets the properties for a control
' -------------------------------------------------------------------------
Sub SetCtrlInfo(token$[], tokNum%, typ%, class$, style$, text%, x%, y%, width%, height%, id%, exStyle%)
    Dim Raw iTmp% ' temporary variable
    Dim tmp$      ' temporary buffer

    '--------------------------------------
    ' check if a control has been processed
    '--------------------------------------
    If typ <> TYP_ERROR Then
        '---------------------------------------
        ' reset for properties that do not exist
        '---------------------------------------
        tmp$      = token$[0]
        token$[0] = ""

        If numCtl >= dynCtl Then Call AddMoreControls()
        curCtrl[typ]        += 1
        ctl[numCtl].class$   = class$
        ctl[numCtl].style$   = style$
        ctl[numCtl].no       = curCtrl[typ]
        ctl[numCtl].text$    = token$[text]
        ctl[numCtl].x$       = token$[x]
        ctl[numCtl].y$       = token$[y]
        ctl[numCtl].width$   = token$[width]
        ctl[numCtl].height$  = token$[height]
        ctl[numCtl].id$      = token$[id]
        ctl[numCtl].token    = typ
        ctl[numCtl].ownerN   = numFrm

        If numFrm = 0 Then
            ctl[numCtl].owner$ = ""
        Else
            ctl[numCtl].owner$   = "Form" & NumToStr$(numFrm + 1) & "_"
        End If

        iTmp = LocComma(token$, tokNum, exStyle)
        If iTmp <> -1 Then
            ctl[numCtl].exStyle$ = GrabTokens$(token$, tokNum, iTmp + 1)
        End If
        If opt.status = True Then ? " --> Found Form", NumToStr$(numFrm + 1), ".", ctlName$[typ], NumToStr$(ctl[numCtl].no)

        Incr numCtl

        '-------------------
        ' restore token zero
        '-------------------
        token$[0] = tmp$
    End If

    typ = TYP_ERROR
End Sub


' -------------------------------------------------------------------------
' Displays dialog converter options
' -------------------------------------------------------------------------
Sub DisplayHelp()
    ? CRLF$, "                           -DIALOG CONVERTER OPTIONS-", CRLF$
    ? "                               -CODE GENERATION-", CRLF$
    ? "    /l1 expand function names                /g1 generate DC code (default)"
    ? "    /l2 compact function names               /g2 generate DS code"
    ? "    /l3 simplified function names (default)  /c  add control subclass code", CRLF$
    ? "                                -MISCELLANEOUS-", CRLF$
    ? "    /ni disable inserting includes           /k  do not add comments"
    ? "    /a# spacing alignment (default=2)        /s  display conversion status"
    ? "    /m  add menu-system                      /?  display this help message", CRLF$
    ? "    The code generated by Dialog Converter is designed to be translated with"
    ? "    the freeware BCX-32: BASIC to C Translator 3.0 by Kevin Diggins."
End Sub


' -------------------------------------------------------------------------
' Adds a style to a string
'
' Returns style
' -------------------------------------------------------------------------
Function AddStyle$(addThis$, style$)
    Dim tmp$

    '------------------------------------------
    ' automatically add style if style is empty
    '------------------------------------------
    If Len(Trim$(style$)) < 1 Then Function = addThis$

    '-------------------------------
    ' add style if it does not exist
    '-------------------------------
    If Instr(UCase$(style$), UCase$(addThis$)) = 0 Then
        tmp$ = style$ & " or " & addThis$
    Else
        tmp$ = style$
    End If

    Function = tmp$
End Function
    

' -------------------------------------------------------------------------
' Combines two strings together
'
' Returns combined strings
' -------------------------------------------------------------------------
Function Glue$(s1$, s2$)
    Function = s1$ & s2$
End Function


' -------------------------------------------------------------------------
' Modified version of the split function that will take a string and
' convert it into an array of tokens
' -------------------------------------------------------------------------
Function Tokenize(Buf$[], T$, Delim As PCHAR)
    Dim Raw Begin%
    Dim Raw Count%
    Dim Raw Quote%
    Dim Raw Index%

    Begin = 0
    Count = 0
    Quote = 0
    Index = 0

    For Index = 1 To Len(T$)
        If Instr(Delim$, Chr$(T[Index - 1])) And Not Quote Then
            Buf$[Count] = Mid$(T$, Begin, Index - Begin)
            If Len(Buf$[Count]) > 0 Then Incr Count
            Begin = 0

            Buf[Count][0] = T[Index - 1] ' add delimiter
            Buf[Count][1] = 0            ' add null terminator

            '------------------------------
            ' check if "|" or "," delimiter
            '------------------------------
            If Buf[Count][0] = 124 or Buf[Count][0] = 44 Then Incr Count 
        Else
            '----------------
            ' check if quoted
            '----------------
            If T[Index - 1] = 34 Then Quote = Not Quote
            If Begin = 0 Then Begin = Index
        End If
    Next

    If Begin Then
        Buf$[Count] = Mid$(T, Begin, Index - Begin)
        Incr Count
    End If

    Function = Count
End Function


' -------------------------------------------------------------------------
' Removes unnecessary spaces and tabs from a string
' -------------------------------------------------------------------------
Function EatSpaces$(inData$)
    Dim buffer$
    Dim Raw idx%
    Dim Raw cdx%
    Dim Raw rLen%
    Dim Raw lstSpc%
    Dim Raw inQuot As Bool
    Dim Raw notSpc As Bool

    rLen   = Len(inData$)
    cdx    = 0
    lstSpc = 0
    inQuot = False
    notSpc = False

    For idx = 0 To rLen - 1
        '-----------------------------------------------
        ' check if we are not dealing with double-quotes
        '-----------------------------------------------
        If inData[idx] = 34 Then
            inQuot = inQuot Xor True
            notSpc = True
        End If

        '------------------------
        ' deal with space counter
        '------------------------
        If inData[idx] = 32 or inData[idx] = 9 And inQuot = False Then
            Incr lstSpc
        Else
            notSpc = True
            lstSpc = 0
        End If

        '------------------------------
        ' copy character if not a space
        '------------------------------
        If lstSpc < 2 And notSpc = True Then
            buffer[cdx] = inData[idx]
            Incr cdx
        End If
    Next

    buffer[cdx] = 0

    Function = buffer$
End Function


' -------------------------------------------------------------------------
' Removes wrapping quotes from a string
'
' Returns an unquoted string
' -------------------------------------------------------------------------
Function UnQuote$(inData$)
    Dim Raw dLen%
    Dim buffer$

    buffer$ = Trim$(inData$)
    dLen = Len(buffer$)

    If buffer[0] = 34 And buffer[(dLen - 1)] = 34 Then
        Function = Mid$(buffer$, 2, dLen - 2)
    End If

    Function = buffer$
End Function


' -------------------------------------------------------------------------
' Dynamically adds space for extra dialogs
' -------------------------------------------------------------------------
Sub AddMoreForms()
    dynFrm += 10
    frm = (LPELEMENT)realloc(frm, sizeof(Element) * dynFrm)
End Sub


' -------------------------------------------------------------------------
' Dynamically adds space for extra controls
' -------------------------------------------------------------------------
Sub AddMoreControls()
    dynCtl += 30
    ctl = (LPELEMENT)realloc(ctl, sizeof(Element) * dynCtl)
End Sub


' -------------------------------------------------------------------------
' Combines an array of style tokens into a string until a comma is found
'
' Returns string of tokens
' -------------------------------------------------------------------------
Function GrabTokens$(Buf$[], tokNum%, iStart%)
    Dim styl$
    Dim Raw i%

    '****************************************************
    ' Modified: 1/3/2005, 3.3
    ' Properly removes NOT statements
    '****************************************************
    For i = iStart To tokNum - 1
        '------------------------------
        ' break if a comma was detected
        '------------------------------
        If Buf[i][0] = 44 Then Exit For

        '------------------------------
        ' skip any NOT statements
        '------------------------------
        If UCase$(Buf$[i]) = "NOT" Then
            i += 2
        Else
            styl$ = styl$ & Buf$[i] & " "
        End If
    Next

    If Len(styl$) > 0 and Right$(styl$, 2) = "| " Then
        styl$ = Left$(styl$, Len(styl$) - 2)
    End If

    Function = Trim$(Replace$(styl$, "|", "or"))
End Function


' -------------------------------------------------------------------------
' Finds the location of a specific comma in a token array
'
' Returns the location of the comma, otherwise -1
' -------------------------------------------------------------------------
Function LocComma%(Buf$[], tokNum%, iNum%)
    Dim Raw found%
    Dim Raw i%

    found = 0

    For i = 0 To tokNum - 1
        If Buf[i][0] = 44 Then
            Incr found

            If iNum = found Then
                Function = i
            End If
        End If
    Next

    Function = -1
End Function


' -------------------------------------------------------------------------
' A wrapper for converting a number to a string
'
' Returns a string that contains a number
' -------------------------------------------------------------------------
Function NumToStr$(iNum%)
	Function = Trim$(Str$(iNum))
End Function
