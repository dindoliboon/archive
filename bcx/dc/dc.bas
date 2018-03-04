    GLOBAL pMenu
    GLOBAL pStatus
    GLOBAL pSubclass
    GLOBAL pCommon
    GLOBAL pRich
    GLOBAL pRich2

    STATIC szFile$
    STATIC szFMFile$
    STATIC szOutput$
    STATIC szTempA$
    STATIC iX
    STATIC pHelp

    ' set globals to false
    pMenu     = FALSE
    pStatus   = FALSE
    pHelp     = FALSE
    pSubclass = FALSE
    pCommon   = FALSE
    pRich     = FALSE
    pRich2    = FALSE

    ' scan arguments
    ! for (iX = 1; iX < argc; iX++)
    ! if (argv[iX][0] == '/' || argv[iX][0] == '-')
    ! {
    !    switch (argv[iX][1])
    !    {
    !    case 'M':
    !    case 'm':
    !        pMenu     = TRUE;
    !        break;
    !    case 'S':
    !    case 's':
    !        pStatus   = TRUE;
    !        break;
    !    case 'C':
    !    case 'c':
    !        pSubclass = TRUE;
    !        break;
    !    case '?':
    !        pHelp     = TRUE;
    !        break;
    !    }
    ! }

    ' get file name
    szTempA$ = COMMAND$                ' required to call command function
    IF argc > 1 THEN
        ! sprintf(szTempA,"%s", command(2,argv));
    END IF

    IF szTempA$ = "" THEN pHelp = TRUE
    IF LOF(szTempA$) = -1 THEN         ' check if file exists
        szFile$ = szTempA$ & ".dlg"    ' file doesn't exist, add ext
    ELSE
        szFile$ = szTempA$             ' file exists, leave it alone
    END IF


    ' create output .tmp file name

    szOutput$ = LCASE$(szTempA$)
    szOutput$ = REMOVE$(szOutput$, ".dlg")
    szFMFile$ = szOutput$ & ".bas"
    szOutput$ = szOutput$ & ".tmp"

    ' check final orders (help or if file exists)

    IF pHelp = TRUE THEN
        PRINT "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커"
        PRINT "� Dialog Converter v1.3 ( Original by DL )  Updated by Kevin Diggins �"
        PRINT "쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑"
        PRINT "� Converts Microsoft Dialog Editor scripts to BCX BASIC source code. �"
        PRINT "� dc [drive:][path]filename[.dlg] [/m] [/s] [/c] [/?]                �"
        PRINT "쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑"
        PRINT "� [drive:][path]filename[.dlg]                                       �"
        PRINT "� Specifies the file that you would like to convert.                 �"
        PRINT "� The drive, path, and dlg extention are optional.                   �"
        PRINT "쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑"
        PRINT "� /m Adds menu-system to source code.                                �"
        PRINT "� /s Displays status while converting scripts.                       �"
        PRINT "� /c Adds control subclass to source code.                           �"
        PRINT "� /? Displays meanings of arguments.                                 �"
        PRINT "�                                                                    �"
        PRINT "� Also accepts unix-style switches such as:  dc filename -m -s -c -? �"
        PRINT "읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸"
        PRINT ""
    ELSEIF LOF(szFile$) = -1 THEN
        PRINT "error : could not open source file."
    ELSE
        prn(" - loading dialog file", TRUE)
        CALL Program_Load(szFile$, szOutput$)
        prn(" - formatting source code", TRUE)
        CALL Format_Source(szOutput$, szFMFile$)
        KILL szOutput$
    END IF



SUB Program_Load(szInput$, szOutput$)
'                szInput$   ' input dialog file
'                szOutput$  ' output bas file
    STATIC szBuffer$
    STATIC szTempA$
    STATIC szTempB$
    STATIC szTempC$
    STATIC szTempD$
    STATIC szTempE$
    STATIC szID$
    STATIC szHeight$
    STATIC szWidth$
    STATIC szLeft$
    STATIC szTop$
    STATIC iStatic
    STATIC iListBox
    STATIC iComboBox
    STATIC iGroup
    STATIC iIcon
    STATIC iControl
    STATIC iButton
    STATIC iEdit
    STATIC iCheckBox
    STATIC iRadio
    STATIC iVScroll
    STATIC iHScroll
    STATIC iFrame
    STATIC iRect
    STATIC iRichEdit
    STATIC iDialog
    STATIC iDialogF
    STATIC iClass
    STATIC iCaption
    STATIC iTemp
    STATIC iAnimate
    STATIC iDate
    STATIC iHotkey
    STATIC iProgress
    STATIC iMonth
    STATIC iRebar
    STATIC iStatus
    STATIC iToolbar
    STATIC iTooltip
    STATIC iTrack
    STATIC iUpDown
    STATIC iComboEx
    STATIC iHeader
    STATIC iAddress
    STATIC iListView
    STATIC iPager
    STATIC iTab
    STATIC iTree

' *************************************************************************
'                             open output file
' *************************************************************************

    OPEN szOutput$ FOR OUTPUT AS FPout
    EmitSeparator (FPout)
    FPRINT FPout, "'           BCX Source Code Generated using Dialog Converter 1.3"
    FPRINT FPout, "'                 For Use With BCX Translator Version 2.06"
    EmitSeparator (FPout)
    FPRINT FPout, ""

' *************************************************************************
    OPEN szInput$ FOR INPUT AS FPin
    WHILE NOT EOF(FPin)
        LINE INPUT FPin, szBuffer$

        ' check for a new dialog to work with

        szBuffer$ = TRIM$(szBuffer$)

        IF LCASE$(parse$(szBuffer$, " ", 1)) = "dialog" THEN
            iCaption = FALSE
            iClass = FALSE
            iDialogF = TRUE
            INCR iDialog
            szTempA$ = TRIM$(STR$(iDialog))
            prn(" - found form", FALSE)
            prn(szTempA$, TRUE)
        END IF

        IF LCASE$(szBuffer$) = "begin" THEN
            IF iCaption = FALSE THEN     ' generic title
                iCaption = FALSE
                FPRINT FPout, "CONST CaptionName";
                szTempA$ = TRIM$(STR$(iDialog))
                FPRINT FPout, szTempA$;
                FPRINT FPout, "$ = ";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, "Caption Name";
                FPRINT FPout, CHR$(34)
            END IF

            IF iClass = FALSE THEN   ' generic class
                iClass = FALSE
                FPRINT FPout, "CONST ClassName";
                szTempA$ = TRIM$(STR$(iDialog))
                FPRINT FPout, szTempA$;
                FPRINT FPout, "$ = ";
                FPRINT FPout, CHR$(34);
                IF iDialog > 1 THEN
                    FPRINT FPout, "Child ";
                ELSE
                    FPRINT FPout, "Main ";
                END IF
                FPRINT FPout, "Class Name";
                FPRINT FPout, CHR$(34)
                FPRINT FPout, ""
            END IF
            iDialogF = FALSE
        END IF

        IF iDialogF = TRUE THEN
            IF LCASE$(parse$(szBuffer$, " ", 0)) = "caption" THEN
                iCaption = TRUE
                FPRINT FPout, "CONST CaptionName";
                szTempA$ = TRIM$(STR$(iDialog))
                FPRINT FPout, szTempA$;
                FPRINT FPout, "$ = ";
                szTempA$ = RIGHT$(szBuffer$, LEN(szBuffer$) - 8)
                FPRINT FPout, szTempA$

            ELSEIF LCASE$(parse$(szBuffer$, " ", 0)) = "class" THEN

                iClass = TRUE
                FPRINT FPout, "CONST ClassName";
                szTempA$ = TRIM$(STR$(iDialog))
                FPRINT FPout, szTempA$;
                FPRINT FPout, "$ = ";
                szTempA$ = RIGHT$(szBuffer$, LEN(szBuffer$) - 6)
                FPRINT FPout, szTempA$
                FPRINT FPout, ""
            END IF
        END IF

        ' check if we have a dialog to work with

        IF iDialog > 0 THEN     ' join lines
            szTempA$ = szTempA$ & " "
            szTempA$ = szTempA$ & TRIM$(szBuffer$)


            IF RIGHT$(TRIM$(szBuffer$), 1) <> "|" and RIGHT$(TRIM$(szBuffer$), 1) _
            <> "," and RIGHT$(TRIM$(LCASE$(szBuffer$)), 3) <> "not" THEN

            szTempA$ = TRIM$(szTempA$)
            IF LCASE$(LEFT$(szTempA$, 7)) = "control" THEN
                szTempB$ = TRIM$(LCASE$(parse$(szTempA$, ",", 2)))
                szTempB$ = LEFT$(szTempB$, LEN(szTempB$) - 1)
                szTempB$ = RIGHT$(szTempB$, LEN(szTempB$) - 1)
                SELECT CASE szTempB$
                    CASE "richedit"           : pRich   = TRUE
                    CASE "richedit20w"        : pRich2  = TRUE
                    CASE "richedit20a"        : pRich2  = TRUE
                    CASE "sysanimate32"       : pCommon = TRUE
                    CASE "sysdatetimepick32"  : pCommon = TRUE
                    CASE "msctls_hotkey32"    : pCommon = TRUE
                    CASE "msctls_progress32"  : pCommon = TRUE
                    CASE "sysmonthcal32"      : pCommon = TRUE
                    CASE "rebarwindow32"      : pCommon = TRUE
                    CASE "msctls_statusbar32" : pCommon = TRUE
                    CASE "toolbarwindow32"    : pCommon = TRUE
                    CASE "tooltips_class32"   : pCommon = TRUE
                    CASE "msctls_trackbar32"  : pCommon = TRUE
                    CASE "msctls_updown32"    : pCommon = TRUE
                    CASE "comboboxex32"       : pCommon = TRUE
                    CASE "sysheader32"        : pCommon = TRUE
                    CASE "sysipaddress32"     : pCommon = TRUE
                    CASE "syslistview32"      : pCommon = TRUE
                    CASE "syspager"           : pCommon = TRUE
                    CASE "systabcontrol32"    : pCommon = TRUE
                    CASE "systreeview32"      : pCommon = TRUE
                END SELECT
            END IF
            szTempA$ = ""
        END IF
    END IF
    WEND
    CLOSE FPin


' *************************************************************************

    IF pMenu = TRUE THEN
        FPRINT FPout, "CONST ID_Edit     =  1001   'Main Menu member"
        FPRINT FPout, "CONST ID_Options  =  1002   'Main Menu member"
        FPRINT FPout, "CONST ID_Open     =  1003   'File Menu member"
        FPRINT FPout, "CONST ID_Close    =  1004   'File Menu member"
        FPRINT FPout, "CONST ID_Save     =  1005   'File Menu member"
        FPRINT FPout, "CONST ID_SaveAs   =  1006   'File Menu member"
        FPRINT FPout, "CONST ID_Exit     =  1007   'File Menu member"
        FPRINT FPout, ""
        FPRINT FPout, "GLOBAL MainMenu  AS  HMENU  'The Main Menu"
        FPRINT FPout, "GLOBAL FileMenu  AS  HMENU  'The File Menu"
        FPRINT FPout, ""
    END IF

    FPRINT FPout, "GLOBAL BCX_GetDiaUnit"
    FPRINT FPout, "GLOBAL BCX_cxBaseUnit"
    FPRINT FPout, "GLOBAL BCX_cyBaseUnit"
    FPRINT FPout, "GLOBAL BCX_ScaleX"
    FPRINT FPout, "GLOBAL BCX_ScaleY"
    FPRINT FPout, ""
    FPRINT FPout, ""
    FPRINT FPout, ""
    FPRINT FPout, "FUNCTION WinMain()"
    FPRINT FPout, "STATIC Wc  AS WNDCLASS"
    FPRINT FPout, "STATIC Msg AS MSG"
    FPRINT FPout, ""
    FPRINT FPout, "IF FindFirstInstance(ClassName1$) THEN EXIT FUNCTION"
    FPRINT FPout, ""

    FOR iTemp = 1 to iDialog
        FPRINT FPout, "Wc.style           = CS_HREDRAW OR CS_VREDRAW OR CS_DBLCLKS"
        FPRINT FPout, "Wc.lpfnWndProc     = WndProc";
        szBuffer$ = TRIM$(STR$(iTemp))
        FPRINT FPout, szBuffer$
        FPRINT FPout, "Wc.cbClsExtra      = 0"
        FPRINT FPout, "Wc.cbWndExtra      = 0"
        FPRINT FPout, "Wc.hInstance       = hInst"
        FPRINT FPout, "Wc.hIcon           = LoadIcon     ( NULL,IDI_";
        IF iTemp = 1 THEN
            FPRINT FPout, "APPLICATION)"
        ELSE
            FPRINT FPout, "WINLOGO)"
        END IF
        FPRINT FPout, "Wc.hCursor         = LoadCursor      ( NULL, IDC_ARROW )"
        FPRINT FPout, "Wc.hbrBackground   = GetSysColorBrush(COLOR_BTNFACE)"
        FPRINT FPout, "Wc.lpszMenuName    = NULL"
        FPRINT FPout, "Wc.lpszClassName   = ClassName";
        szBuffer$ = TRIM$(STR$(iTemp))
        FPRINT FPout, szBuffer$;
        FPRINT FPout, "$"
        FPRINT FPout, "RegisterClass(&Wc)"
        FPRINT FPout, ""
    NEXT

    IF pRich = TRUE THEN
        FPRINT FPout, ""
        FPRINT FPout, "GLOBAL dllRich As HMODULE"
        FPRINT FPout, "dllRich = LoadLibrary(";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, "RICHED32.DLL";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, ")"
    ELSEIF pRich2 = TRUE THEN
        FPRINT FPout, ""
        FPRINT FPout, "GLOBAL dllRich As HMODULE"
        FPRINT FPout, "dllRich = LoadLibrary(";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, "RICHED20.DLL";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, ")"
    END IF

    IF pCommon = TRUE THEN
        FPRINT FPout, ""
        FPRINT FPout, "InitCommonControls()"
    END IF

    FPRINT FPout, ""
    FPRINT FPout, "FormLoad (hInst)"
    FPRINT FPout, ""

    szBuffer$ = "' "  & REPEAT$(18,"*")
    szBuffer$ = szBuffer$ & "[ This Message Pump Allows Tabbing ]"
    szBuffer$ = szBuffer$ & REPEAT$(18,"*")

    FPRINT FPout, szBuffer$

    FPRINT FPout, ""
    FPRINT FPout, "WHILE GetMessage ( &Msg, NULL, 0 ,0 )"
    FPRINT FPout, "IF NOT IsWindow(Form1) OR NOT IsDialogMessage(Form1,&Msg) THEN"
    FPRINT FPout, "TranslateMessage ( &Msg )"
    FPRINT FPout, "DispatchMessage  ( &Msg )"
    FPRINT FPout, "END IF"
    FPRINT FPout, "WEND"
    FPRINT FPout, ""
    EmitSeparator (FPout)
    FPRINT FPout, "FUNCTION = Msg.wParam"
    FPRINT FPout, "END FUNCTION"
    FPRINT FPout, ""
    FPRINT FPout, ""
    FPRINT FPout, ""

    FOR iTemp = 1 to iDialog
        FPRINT FPout, "CALLBACK FUNCTION WndProc";
        szBuffer$ = TRIM$(STR$(iTemp)) & "()"
        FPRINT FPout, szBuffer$
        FPRINT FPout, "SELECT CASE Msg"
        EmitSeparator (FPout)

        IF iTemp > 1 THEN
            FPRINT FPout, "CASE WM_CLOSE"
            EmitSeparator (FPout)
            FPRINT FPout, "ShowWindow(hWnd, SW_HIDE)"
            FPRINT FPout, "FUNCTION = 0"
        ELSE
            ' first form only
            IF pMenu = TRUE THEN
                FPRINT FPout, "CASE WM_COMMAND"
                EmitSeparator (FPout)
                FPRINT FPout, "IF LOWORD(wParam)=ID_Edit THEN"
                FPRINT FPout, "MessageBox(Form1,";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, "Edit";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",0)"
                FPRINT FPout, "END IF"
                FPRINT FPout, ""
                FPRINT FPout, "IF LOWORD(wParam)=ID_Options THEN"
                FPRINT FPout, "MessageBox(Form1,";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, "Options";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",0)"
                FPRINT FPout, "END IF"
                FPRINT FPout, ""
                FPRINT FPout, "IF LOWORD(wParam)=ID_Open THEN"
                FPRINT FPout, "OpenFileDialog (Form1,";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, "Open File";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, "*.*";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, "*.*";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, "*.*";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",0)"
                FPRINT FPout, "END IF"
                FPRINT FPout, ""
                FPRINT FPout, "IF LOWORD(wParam)=ID_Close THEN"
                FPRINT FPout, "MessageBox(Form1,";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, "Close";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",0)"
                FPRINT FPout, "END IF"
                FPRINT FPout, ""
                FPRINT FPout, "IF LOWORD(wParam)=ID_Save THEN"
                FPRINT FPout, "OpenFileDialog (Form1,";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, "Save File";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, "*.*";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, "*.*";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, "*.*";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",0)"
                FPRINT FPout, "END IF"
                FPRINT FPout, ""
                FPRINT FPout, "IF LOWORD(wParam)=ID_SaveAs THEN"
                FPRINT FPout, "OpenFileDialog (Form1,";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, "Save As...";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, "*.*";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, "*.*";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, "*.*";
                FPRINT FPout, CHR$(34);
                FPRINT FPout, ",0)"
                FPRINT FPout, "END IF"
                FPRINT FPout, "IF LOWORD(wParam)=ID_Exit THEN SendMessage(Form1, WM_CLOSE, 0, 0)"
                EmitSeparator (FPout)
            END IF


            FPRINT FPout, "CASE WM_CLOSE"
            EmitSeparator (FPout)
            FPRINT FPout, "STATIC id"
            FPRINT FPout, "id = MessageBox(        _"
            FPRINT FPout, "     hWnd,              _"
            FPRINT FPout, "     ";
            FPRINT FPout, CHR$(34);
            FPRINT FPout, "Are you sure?";
            FPRINT FPout, CHR$(34);
            FPRINT FPout, ",   _"
            FPRINT FPout, "     ";
            FPRINT FPout, CHR$(34);
            FPRINT FPout, "Quit Program!";
            FPRINT FPout, CHR$(34);
            FPRINT FPout, ",   _"
            FPRINT FPout, "     MB_YESNO OR MB_ICONQUESTION )"
            FPRINT FPout, "IF id = IDYES THEN DestroyWindow (hWnd)"
            FPRINT FPout, "FUNCTION = 0"
            EmitSeparator (FPout)
            FPRINT FPout, "CASE WM_DESTROY "
            EmitSeparator (FPout)
            FPRINT FPout, "PostQuitMessage(0)"
            FPRINT FPout, "FUNCTION = 0"

        END IF

        FPRINT FPout, "END SELECT"
        FPRINT FPout, "FUNCTION = DefWindowProc(hWnd,Msg,wParam,lParam)"
        FPRINT FPout, "END FUNCTION"
        FPRINT FPout, ""
        FPRINT FPout, ""
        FPRINT FPout, ""
    NEXT

    FPRINT FPout, "SUB CenterWindow (hWnd AS HWND)"
    FPRINT FPout, "DIM wRect AS RECT"
    FPRINT FPout, "DIM x AS DWORD"
    FPRINT FPout, "DIM y AS DWORD"
    FPRINT FPout, "GetWindowRect (hWnd, &wRect)"
    FPRINT FPout, "x = (GetSystemMetrics ( SM_CXSCREEN)-(wRect.right-wRect.left))/2"
    FPRINT FPout, "y = (GetSystemMetrics ( SM_CYSCREEN)- _"
    FPRINT FPout, "    (wRect.bottom-wRect.top+GetSystemMetrics(SM_CYCAPTION)))/2"
    FPRINT FPout, "SetWindowPos (hWnd, NULL,x,y,0,0,SWP_NOSIZE OR SWP_NOZORDER)"
    FPRINT FPout, "END SUB"
    FPRINT FPout, ""
    FPRINT FPout, ""
    FPRINT FPout, ""
    FPRINT FPout, "FUNCTION FindFirstInstance(ApplName$)"
    FPRINT FPout, "STATIC hWnd AS HWND"
    FPRINT FPout, "hWnd = FindWindow (ApplName$,NULL)"
    FPRINT FPout, "IF hWnd THEN"
    FPRINT FPout, "FUNCTION = TRUE"
    FPRINT FPout, "END IF"
    FPRINT FPout, "FUNCTION = FALSE"
    FPRINT FPout, "END FUNCTION"
    FPRINT FPout, ""
    FPRINT FPout, ""
    FPRINT FPout, ""



    IF pMenu = TRUE THEN
        FPRINT FPout, "FUNCTION OpenFileDialog _"
        FPRINT FPout, "(                       _"
        FPRINT FPout, "hWnd AS HWND      , _"
        FPRINT FPout, "zCaption$         , _"
        FPRINT FPout, "zFilespec$        , _"
        FPRINT FPout, "zInitialDir$      , _"
        FPRINT FPout, "zFilter$          , _"
        FPRINT FPout, "zDefExtension$    , _"
        FPRINT FPout, "Flags               _"
        FPRINT FPout, ")"
        FPRINT FPout, ""
        FPRINT FPout, "STATIC ofn AS OPENFILENAME"
        FPRINT FPout, "STATIC File$"
        FPRINT FPout, "STATIC FileTitle$"
        FPRINT FPout, "STATIC Filter$"
        FPRINT FPout, "STATIC InitialDir$"
        FPRINT FPout, "STATIC Title$"
        FPRINT FPout, "STATIC DefExt$"
        FPRINT FPout, "STATIC RetFlg"
        FPRINT FPout, ""
        FPRINT FPout, "IF Len(zInitialDir$) = 0 Then"
        FPRINT FPout, "InitialDir$ = CURDIR$"
        FPRINT FPout, "End If"
        FPRINT FPout, ""
        FPRINT FPout, "Filter$               = zFilter$"
        FPRINT FPout, "InitialDir$           = zInitialDir$"
        FPRINT FPout, "File$                 = zFilespec$"
        FPRINT FPout, "DefExt$               = zDefExtension$"
        FPRINT FPout, "Title$                = zCaption$"
        FPRINT FPout, ""
        FPRINT FPout, "ofn.lStructSize       = SIZEOF(ofn)"
        FPRINT FPout, "ofn.hwndOwner         = hWnd"
        FPRINT FPout, "ofn.lpstrFilter       = Filter$"
        FPRINT FPout, "ofn.nFilterIndex      = 1"
        FPRINT FPout, "ofn.lpstrFile         = File$"
        FPRINT FPout, "ofn.nMaxFile          = SIZEOF(File$)"
        FPRINT FPout, "ofn.lpstrFileTitle    = FileTitle$"
        FPRINT FPout, "ofn.nMaxFileTitle     = SIZEOF(FileTitle$)"
        FPRINT FPout, "ofn.lpstrInitialDir   = InitialDir$"
        FPRINT FPout, "ofn.Flags             = Flags"
        FPRINT FPout, "ofn.lpstrDefExt       = DefExt$"
        FPRINT FPout, ""
        FPRINT FPout, "If Len(Title$) > 0 Then"
        FPRINT FPout, "ofn.lpstrTitle       = Title$"
        FPRINT FPout, "End If"
        FPRINT FPout, ""
        FPRINT FPout, "RetFlg = GetOpenFileName(&ofn)"
        FPRINT FPout, ""
        FPRINT FPout, "zFilespec$ = File$"
        FPRINT FPout, "Flags    = ofn.Flags"
        FPRINT FPout, "Function = RetFlg"
        FPRINT FPout, "End Function"
        FPRINT FPout, ""
        FPRINT FPout, ""
        FPRINT FPout, ""
    END IF


    FPRINT FPout, "SUB FormLoad ( hInst as HANDLE )"
    EmitSeparator (FPout)
    FPRINT FPout, "'               Scale Dialog Units To Screen Units"
    EmitSeparator (FPout)
    FPRINT FPout, ""
    FPRINT FPout, "BCX_GetDiaUnit = GetDialogBaseUnits()"
    FPRINT FPout, "BCX_cxBaseUnit = LOWORD(BCX_GetDiaUnit)"
    FPRINT FPout, "BCX_cyBaseUnit = HIWORD(BCX_GetDiaUnit)"
    FPRINT FPout, "BCX_ScaleX     = BCX_cxBaseUnit/4"
    FPRINT FPout, "BCX_ScaleY     = BCX_cyBaseUnit/8"

' *************************************************************************

    szBuffer$ = ""
    szTempA$ = ""
    iDialog = 0

' *************************************************************************

    ' read file again, this time, create controls
    OPEN szInput$ FOR INPUT AS FPin

    WHILE NOT EOF(FPin)
        LINE INPUT FPin, szBuffer$

        ' check for new dialog
        szBuffer$ = TRIM$(szBuffer$)
        IF LCASE$(parse$(szBuffer$, " ", 1)) = "dialog" THEN
            INCR iDialog

            'reset standard controls
            iStatic   = 0
            iListBox  = 0
            iComboBox = 0
            iGroup    = 0
            iIcon     = 0
            iControl  = 0
            iButton   = 0
            iEdit     = 0
            iCheckBox = 0
            iRadio    = 0
            iVScroll  = 0
            iHScroll  = 0
            iFrame    = 0
            iRect     = 0
            iRichEdit = 0
            iAnimate  = 0
            iDate     = 0
            iHotkey   = 0
            iProgress = 0
            iMonth    = 0
            iRebar    = 0
            iStatus   = 0
            iToolbar  = 0
            iTooltip  = 0
            iTrack    = 0
            iUpDown   = 0
            iComboEx  = 0
            iHeader   = 0
            iAddress  = 0
            iListView = 0
            iPager    = 0
            iTab      = 0
            iTree     = 0

            szLeft$   =  parse$(szBuffer$, " ", 2)
            szLeft$   =  LEFT$(szLeft$, LEN(szLeft$) - 1)
            szTop$    =  parse$(szBuffer$, ",", 1)
            szWidth$  =  parse$(szBuffer$, ",", 2)
            szHeight$ =  parse$(szBuffer$, ",", 3)
        END IF

        ' check if we have a dialog to work with
        IF iDialog > 0 THEN     ' join lines
            szTempA$ = szTempA$ & " "
            szTempA$ = szTempA$ & TRIM$(szBuffer$)


            IF RIGHT$(TRIM$(szBuffer$), 1) <> "|" and RIGHT$(TRIM$(szBuffer$), 1)   _
            <> "," and RIGHT$(TRIM$(LCASE$(szBuffer$)), 3) <> "not" THEN

            ' attempt to reformat line
            szTempA$ = TRIM$(szTempA$)              ' trim spaces
            szTempC$ = parse$(szTempA$, " ", 0)     ' search for control name
            szTempB$ = szTempC$                     ' add control to string
            szTempD$ = SPACE$(16 - LEN(szTempC$))   ' create padding
            szTempB$ = szTempB$ & szTempD$          ' add padding to string

            ' get control properties
            szTempD$ = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - LEN(szTempC$)))

            ' add properties to string
            szTempA$ = szTempB$ & szTempD$

            IF LCASE$(LEFT$(szTempA$, 5)) = "style" THEN
                FPRINT FPout, ""
                EmitSeparator (FPout)
                FPRINT FPout, ""
                szTempB$ = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 6))
                REPLACE "|" WITH "OR" IN szTempB$
                FPRINT FPout, "GLOBAL Form";
                szTempA$ = TRIM$(STR$(iDialog))
                FPRINT FPout, szTempA$;
                FPRINT FPout, " AS HWND"
                FPRINT FPout, ""
                FPRINT FPout, "Form";
                FPRINT FPout, szTempA$;
                FPRINT FPout, " = CreateWindow(ClassName";
                FPRINT FPout, szTempA$;
                FPRINT FPout, "$,CaptionName";
                FPRINT FPout, szTempA$;
                FPRINT FPout, "$, _"
                FPRINT FPout, szTempB$;
                FPRINT FPout, ", _"
                FPRINT FPout, szLeft$;
                FPRINT FPout, "*BCX_ScaleX,";
                FPRINT FPout, szTop$;
                FPRINT FPout, "*BCX_ScaleY,(4+";
                FPRINT FPout, szWidth$;
                FPRINT FPout, ")*BCX_ScaleX,(12+";
                FPRINT FPout, szHeight$;
                FPRINT FPout, ")*BCX_ScaleY, _"
                FPRINT FPout, "NULL,NULL,hInst,NULL)"
            ELSEIF LCASE$(LEFT$(szTempA$, 5)) = "ltext" THEN
                INCR iStatic
                szTempB$ = TRIM$(STR$(iDialog))
                prn(" - found form", FALSE)
                prn(szTempB$, FALSE)
                prn(".static", FALSE)
                szTempB$ = TRIM$(STR$(iStatic))
                prn(szTempB$, TRUE)
                ' ==========
                szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                szTempB$  = parse$(szTempA$, ",", 0) ' text
                szID$     = parse$(szTempA$, ",", 1) ' id
                szLeft$   = parse$(szTempA$, ",", 2) ' left
                szTop$    = parse$(szTempA$, ",", 3) ' top
                szHeight$ = parse$(szTempA$, ",", 4) ' height
                szWidth$  = parse$(szTempA$, ",", 5) ' width
                szTempC$  = parse$(szTempA$, ",", 6) ' style
                szTempD$  = CHR$(34) & "static"
                szTempD$  = szTempD$ & CHR$(34)
                szTempC$  = AddStyle("WS_VISIBLE", szTempC$)
                szTempC$  = AddStyle("SS_LEFT", szTempC$)
                szTempC$  = AddStyle("SS_NOTIFY", szTempC$)
                szTempC$  = AddStyle("WS_CHILD", szTempC$)
                GenerateControl("","Static", szID$, szTempD$, szTempB$, szTempC$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iStatic, pSubclass, FPout)
            ELSEIF LCASE$(LEFT$(szTempA$, 5)) = "ctext" THEN
                INCR iStatic
                szTempB$ = TRIM$(STR$(iDialog))
                prn(" - found form", FALSE)
                prn(szTempB$, FALSE)
                prn(".static", FALSE)
                szTempB$ = TRIM$(STR$(iStatic))
                prn(szTempB$, TRUE)
                ' ==========
                szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                szTempB$  = parse$(szTempA$, ",", 0) ' text
                szID$     = parse$(szTempA$, ",", 1) ' id
                szLeft$   = parse$(szTempA$, ",", 2) ' left
                szTop$    = parse$(szTempA$, ",", 3) ' top
                szHeight$ = parse$(szTempA$, ",", 4) ' height
                szWidth$  = parse$(szTempA$, ",", 5) ' width
                szTempC$  = parse$(szTempA$, ",", 6) ' style
                szTempD$  = CHR$(34) & "static"
                szTempD$  = szTempD$ & CHR$(34)
                szTempC$  = AddStyle("WS_VISIBLE", szTempC$)
                szTempC$  = AddStyle("SS_CENTER", szTempC$)
                szTempC$  = AddStyle("SS_NOTIFY", szTempC$)
                szTempC$  = AddStyle("WS_CHILD", szTempC$)
                GenerateControl("","Static", szID$, szTempD$, szTempB$, szTempC$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iStatic, pSubclass, FPout)
            ELSEIF LCASE$(LEFT$(szTempA$, 5)) = "rtext" THEN
                INCR iStatic
                szTempB$ = TRIM$(STR$(iDialog))
                prn(" - found form", FALSE)
                prn(szTempB$, FALSE)
                prn(".static", FALSE)
                szTempB$ = TRIM$(STR$(iStatic))
                prn(szTempB$, TRUE)
                ' ==========
                szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                szTempB$  = parse$(szTempA$, ",", 0) ' text
                szID$     = parse$(szTempA$, ",", 1) ' id
                szLeft$   = parse$(szTempA$, ",", 2) ' left
                szTop$    = parse$(szTempA$, ",", 3) ' top
                szHeight$ = parse$(szTempA$, ",", 4) ' height
                szWidth$  = parse$(szTempA$, ",", 5) ' width
                szTempC$  = parse$(szTempA$, ",", 6) ' style
                szTempD$  = CHR$(34) & "static"
                szTempD$  = szTempD$ & CHR$(34)
                szTempC$  = AddStyle("WS_VISIBLE", szTempC$)
                szTempC$  = AddStyle("SS_RIGHT", szTempC$)
                szTempC$  = AddStyle("SS_NOTIFY", szTempC$)
                szTempC$  = AddStyle("WS_CHILD", szTempC$)
                GenerateControl("","Static", szID$, szTempD$, szTempB$, szTempC$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iStatic, pSubclass, FPout)
            ELSEIF LCASE$(LEFT$(szTempA$, 8)) = "edittext" THEN
                INCR iEdit
                szTempB$ = TRIM$(STR$(iDialog))
                prn(" - found form", FALSE)
                prn(szTempB$, FALSE)
                prn(".edit", FALSE)
                szTempB$ = TRIM$(STR$(iEdit))
                prn(szTempB$, TRUE)
                ' ==========
                szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                szID$     = parse$(szTempA$, ",", 0) ' id
                szLeft$   = parse$(szTempA$, ",", 1) ' left
                szTop$    = parse$(szTempA$, ",", 2) ' top
                szHeight$ = parse$(szTempA$, ",", 3) ' height
                szWidth$  = parse$(szTempA$, ",", 4) ' width
                szTempC$  = parse$(szTempA$, ",", 5) ' style
                szTempD$  = CHR$(34) & "edit"
                szTempD$  = szTempD$ & CHR$(34)
                szTempC$  = AddStyle("WS_VISIBLE", szTempC$)
                szTempC$  = AddStyle("WS_TABSTOP", szTempC$)
                szTempC$  = AddStyle("WS_CHILD", szTempC$)
                GenerateControl("WS_EX_CLIENTEDGE","Edit", szID$, szTempD$, "NULL", szTempC$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iEdit, pSubclass, FPout)
            ELSEIF LCASE$(LEFT$(szTempA$, 8)) = "groupbox" THEN
                INCR iGroup
                szTempB$ = TRIM$(STR$(iDialog))
                prn(" - found form", FALSE)
                prn(szTempB$, FALSE)
                prn(".group", FALSE)
                szTempB$ = TRIM$(STR$(iGroup))
                prn(szTempB$, TRUE)
                ' ==========
                szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                szTempB$  = parse$(szTempA$, ",", 0) ' text
                szID$     = parse$(szTempA$, ",", 1) ' id
                szLeft$   = parse$(szTempA$, ",", 2) ' left
                szTop$    = parse$(szTempA$, ",", 3) ' top
                szHeight$ = parse$(szTempA$, ",", 4) ' height
                szWidth$  = parse$(szTempA$, ",", 5) ' width
                szTempC$  = parse$(szTempA$, ",", 6) ' style
                szTempD$  = CHR$(34) & "button"
                szTempD$  = szTempD$ & CHR$(34)
                szTempC$  = AddStyle("WS_VISIBLE", szTempC$)
                szTempC$  = AddStyle("BS_GROUPBOX", szTempC$)
                szTempC$  = AddStyle("WS_CHILD", szTempC$)
                GenerateControl("","Group", szID$, szTempD$, szTempB$, szTempC$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iGroup, FALSE, FPout)
            ELSEIF LCASE$(LEFT$(szTempA$, 10)) = "pushbutton" THEN
                INCR iButton
                szTempB$ = TRIM$(STR$(iDialog))
                prn(" - found form", FALSE)
                prn(szTempB$, FALSE)
                prn(".button", FALSE)
                szTempB$ = TRIM$(STR$(iButton))
                prn(szTempB$, TRUE)
                ' ==========
                szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                szTempB$  = parse$(szTempA$, ",", 0) ' text
                szID$     = parse$(szTempA$, ",", 1) ' id
                szLeft$   = parse$(szTempA$, ",", 2) ' left
                szTop$    = parse$(szTempA$, ",", 3) ' top
                szHeight$ = parse$(szTempA$, ",", 4) ' height
                szWidth$  = parse$(szTempA$, ",", 5) ' width
                szTempC$  = parse$(szTempA$, ",", 6) ' style
                szTempD$  = CHR$(34) & "button"
                szTempD$  = szTempD$ & CHR$(34)
                szTempC$  = AddStyle("WS_VISIBLE", szTempC$)
                szTempC$  = AddStyle("BS_PUSHBUTTON", szTempC$)
                szTempC$  = AddStyle("WS_TABSTOP", szTempC$)
                szTempC$  = AddStyle("WS_CHILD", szTempC$)
                GenerateControl("","Button", szID$, szTempD$, szTempB$, szTempC$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iButton, pSubclass, FPout)
            ELSEIF LCASE$(LEFT$(szTempA$, 13)) = "defpushbutton" THEN
                INCR iButton
                szTempB$ = TRIM$(STR$(iDialog))
                prn(" - found form", FALSE)
                prn(szTempB$, FALSE)
                prn(".button", FALSE)
                szTempB$ = TRIM$(STR$(iButton))
                prn(szTempB$, TRUE)
                ' ==========
                szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                szTempB$  = parse$(szTempA$, ",", 0) ' text
                szID$     = parse$(szTempA$, ",", 1) ' id
                szLeft$   = parse$(szTempA$, ",", 2) ' left
                szTop$    = parse$(szTempA$, ",", 3) ' top
                szHeight$ = parse$(szTempA$, ",", 4) ' height
                szWidth$  = parse$(szTempA$, ",", 5) ' width
                szTempC$  = parse$(szTempA$, ",", 6) ' style
                szTempD$  = CHR$(34) & "button"
                szTempD$  = szTempD$ & CHR$(34)
                szTempC$  = AddStyle("WS_VISIBLE", szTempC$)
                szTempC$  = AddStyle("BS_PUSHBUTTON", szTempC$)
                szTempC$  = AddStyle("WS_TABSTOP", szTempC$)
                szTempC$  = AddStyle("WS_CHILD", szTempC$)
                szTempC$  = AddStyle("BS_DEFPUSHBUTTON", szTempC$)
                GenerateControl("","Button", szID$, szTempD$, szTempB$, szTempC$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iButton, pSubclass, FPout)
            ELSEIF LCASE$(LEFT$(szTempA$, 8)) = "checkbox" THEN
                INCR iCheckBox
                szTempB$ = TRIM$(STR$(iDialog))
                prn(" - found form", FALSE)
                prn(szTempB$, FALSE)
                prn(".checkbox", FALSE)
                szTempB$ = TRIM$(STR$(iCheckBox))
                prn(szTempB$, TRUE)
                ' ==========
                szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                szTempB$  = parse$(szTempA$, ",", 0) ' text
                szID$     = parse$(szTempA$, ",", 1) ' id
                szLeft$   = parse$(szTempA$, ",", 2) ' left
                szTop$    = parse$(szTempA$, ",", 3) ' top
                szHeight$ = parse$(szTempA$, ",", 4) ' height
                szWidth$  = parse$(szTempA$, ",", 5) ' width
                szTempC$  = parse$(szTempA$, ",", 6) ' style
                szTempD$  = CHR$(34) & "button"
                szTempD$  = szTempD$ & CHR$(34)
                szTempC$  = AddStyle("WS_VISIBLE", szTempC$)
                szTempC$  = AddStyle("BS_CHECKBOX", szTempC$)
                szTempC$  = AddStyle("WS_TABSTOP", szTempC$)
                szTempC$  = AddStyle("WS_CHILD", szTempC$)
                GenerateControl("","CheckBox", szID$, szTempD$, szTempB$, szTempC$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iCheckBox, pSubclass, FPout)
            ELSEIF LCASE$(LEFT$(szTempA$, 11)) = "radiobutton" THEN
                INCR iRadio
                szTempB$ = TRIM$(STR$(iDialog))
                prn(" - found form", FALSE)
                prn(szTempB$, FALSE)
                prn(".radio", FALSE)
                szTempB$ = TRIM$(STR$(iRadio))
                prn(szTempB$, TRUE)
                ' ==========
                szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                szTempB$  = parse$(szTempA$, ",", 0) ' text
                szID$     = parse$(szTempA$, ",", 1) ' id
                szLeft$   = parse$(szTempA$, ",", 2) ' left
                szTop$    = parse$(szTempA$, ",", 3) ' top
                szHeight$ = parse$(szTempA$, ",", 4) ' height
                szWidth$  = parse$(szTempA$, ",", 5) ' width
                szTempC$  = parse$(szTempA$, ",", 6) ' style
                szTempD$  = CHR$(34) & "button"
                szTempD$  = szTempD$ & CHR$(34)
                szTempC$  = AddStyle("WS_VISIBLE", szTempC$)
                szTempC$  = AddStyle("BS_AUTORADIOBUTTON", szTempC$)
                szTempC$  = AddStyle("WS_TABSTOP", szTempC$)
                szTempC$  = AddStyle("WS_CHILD", szTempC$)
                GenerateControl("","Radio", szID$, szTempD$, szTempB$, szTempC$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iRadio, pSubclass, FPout)
            ELSEIF LCASE$(LEFT$(szTempA$, 8)) = "combobox" THEN
                INCR iComboBox
                szTempB$ = TRIM$(STR$(iDialog))
                prn(" - found form", FALSE)
                prn(szTempB$, FALSE)
                prn(".combobox", FALSE)
                szTempB$ = TRIM$(STR$(iComboBox))
                prn(szTempB$, TRUE)
                ' ==========
                szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                szTempB$  = CHR$(34) & CHR$(34)
                szID$     = parse$(szTempA$, ",", 0) ' id
                szLeft$   = parse$(szTempA$, ",", 1) ' left
                szTop$    = parse$(szTempA$, ",", 2) ' top
                szHeight$ = parse$(szTempA$, ",", 3) ' height
                szWidth$  = parse$(szTempA$, ",", 4) ' width
                szTempC$  = parse$(szTempA$, ",", 5) ' style
                szTempD$  = CHR$(34) & "ComboBox"
                szTempD$  = szTempD$ & CHR$(34)
                szTempC$  = AddStyle("WS_VISIBLE", szTempC$)
                szTempC$  = AddStyle("WS_CHILD", szTempC$)
                GenerateControl("WS_EX_CLIENTEDGE","ComboBox", szID$, szTempD$, szTempB$, szTempC$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iComboBox, pSubclass, FPout)
            ELSEIF LCASE$(LEFT$(szTempA$, 7)) = "listbox" THEN
                INCR iListBox
                szTempB$ = TRIM$(STR$(iDialog))
                prn(" - found form", FALSE)
                prn(szTempB$, FALSE)
                prn(".listbox", FALSE)
                szTempB$ = TRIM$(STR$(iListBox))
                prn(szTempB$, TRUE)
                ' ==========
                szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                szTempB$  = CHR$(34) & CHR$(34)
                szID$     = parse$(szTempA$, ",", 0) ' id
                szLeft$   = parse$(szTempA$, ",", 1) ' left
                szTop$    = parse$(szTempA$, ",", 2) ' top
                szHeight$ = parse$(szTempA$, ",", 3) ' height
                szWidth$  = parse$(szTempA$, ",", 4) ' width
                szTempC$  = parse$(szTempA$, ",", 5) ' style
                szTempD$  = CHR$(34) & "ListBox"
                szTempD$  = szTempD$ & CHR$(34)
                szTempC$  = AddStyle("WS_VISIBLE", szTempC$)
                szTempC$  = AddStyle("WS_CHILD", szTempC$)
                szTempC$  = AddStyle("LBS_STANDARD", szTempC$)
                GenerateControl("WS_EX_CLIENTEDGE","ListBox", szID$, szTempD$, szTempB$, szTempC$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iListBox, pSubclass, FPout)
            ELSEIF LCASE$(LEFT$(szTempA$, 4)) = "icon" THEN
                INCR iIcon
                szTempB$ = TRIM$(STR$(iDialog))
                prn(" - found form", FALSE)
                prn(szTempB$, FALSE)
                prn(".icon", FALSE)
                szTempB$ = TRIM$(STR$(iIcon))
                prn(szTempB$, TRUE)
                ' ==========
                szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                szTempB$  = CHR$(34) & CHR$(34)
                szID$     = parse$(szTempA$, ",", 1) ' id
                szLeft$   = parse$(szTempA$, ",", 2) ' left
                szTop$    = parse$(szTempA$, ",", 3) ' top
                szHeight$ = parse$(szTempA$, ",", 4) ' height
                szWidth$  = parse$(szTempA$, ",", 5) ' width
                szTempC$  = parse$(szTempA$, ",", 6) ' style
                szTempD$  = CHR$(34) & "static"
                szTempD$  = szTempD$ & CHR$(34)
                szTempC$  = AddStyle("WS_VISIBLE", szTempC$)
                szTempC$  = AddStyle("SS_ICON", szTempC$)
                szTempC$  = AddStyle("SS_NOTIFY", szTempC$)
                szTempC$  = AddStyle("WS_CHILD", szTempC$)
                GenerateControl("","Icon", szID$, szTempD$, szTempB$, szTempC$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iIcon, pSubclass, FPout)
            ELSEIF LCASE$(LEFT$(szTempA$, 9)) = "scrollbar" THEN
                IF INSTR(LCASE$(szTempA$), "sbs_vert") > 0 THEN
                    INCR iVScroll
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".vscroll", FALSE)
                    szTempB$ = TRIM$(STR$(iVScroll))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempB$  = CHR$(34) & CHR$(34)
                    szID$     = parse$(szTempA$, ",", 0) ' id
                    szLeft$   = parse$(szTempA$, ",", 1) ' left
                    szTop$    = parse$(szTempA$, ",", 2) ' top
                    szHeight$ = parse$(szTempA$, ",", 3) ' height
                    szWidth$  = parse$(szTempA$, ",", 4) ' width
                    szTempC$  = parse$(szTempA$, ",", 5) ' style
                    szTempD$  = CHR$(34) & "scrollbar"
                    szTempD$  = szTempD$ & CHR$(34)
                    szTempC$  = AddStyle("WS_VISIBLE", szTempC$)
                    szTempC$  = AddStyle("WS_TABSTOP", szTempC$)
                    szTempC$  = AddStyle("WS_CHILD", szTempC$)
                    GenerateControl("","VScroll", szID$, szTempD$, szTempB$, szTempC$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iVScroll, pSubclass, FPout)
                ELSE
                    INCR iHScroll
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".hscroll", FALSE)
                    szTempB$ = TRIM$(STR$(iHScroll))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempB$  = CHR$(34) & CHR$(34)
                    szID$     = parse$(szTempA$, ",", 0) ' id
                    szLeft$   = parse$(szTempA$, ",", 1) ' left
                    szTop$    = parse$(szTempA$, ",", 2) ' top
                    szHeight$ = parse$(szTempA$, ",", 3) ' height
                    szWidth$  = parse$(szTempA$, ",", 4) ' width
                    szTempC$  = parse$(szTempA$, ",", 5) ' style
                    szTempD$  = CHR$(34) & "scrollbar"
                    szTempD$  = szTempD$ & CHR$(34)
                    szTempC$  = AddStyle("SB_HORZ", szTempC$)
                    szTempC$  = AddStyle("WS_VISIBLE", szTempC$)
                    szTempC$  = AddStyle("WS_TABSTOP", szTempC$)
                    szTempC$  = AddStyle("WS_CHILD", szTempC$)
                    GenerateControl("","HScroll", szID$, szTempD$, szTempB$, szTempC$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iHScroll, pSubclass, FPout)
                END IF
            ELSEIF LCASE$(LEFT$(szTempA$, 7)) = "control" THEN
                szTempB$ = TRIM$(LCASE$(parse$(szTempA$, ",", 2)))
                szTempB$ = LEFT$(szTempB$, LEN(szTempB$) - 1)
                szTempB$ = RIGHT$(szTempB$, LEN(szTempB$) - 1)
                SELECT CASE szTempB$
                    CASE "static"
                    IF INSTR(LCASE$(szTempA$), "ss_blackframe") or INSTR(LCASE$(szTempA$), "ss_grayframe") THEN
                        INCR iFrame
                        szTempC$ = TRIM$(STR$(iDialog))
                        prn(" - found form", FALSE)
                        prn(szTempC$, FALSE)
                        prn(".frame", FALSE)
                        szTempC$ = TRIM$(STR$(iFrame))
                        prn(szTempC$, TRUE)
                        ' ==========
                        szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                        szTempC$  = parse$(szTempA$, ",", 0) ' text
                        szID$     = parse$(szTempA$, ",", 1) ' id
                        szTempD$  = parse$(szTempA$, ",", 3) ' style
                        szLeft$   = parse$(szTempA$, ",", 4) ' left
                        szTop$    = parse$(szTempA$, ",", 5) ' top
                        szHeight$ = parse$(szTempA$, ",", 6) ' height
                        szWidth$  = parse$(szTempA$, ",", 7) ' width
                        szTempE$  = CHR$(34) & "static"
                        szTempE$  = szTempE$ & CHR$(34)
                        szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                        szTempD$  = AddStyle("SS_NOTIFY", szTempD$)
                        szTempD$  = AddStyle("WS_CHILD", szTempD$)
                        GenerateControl("","Frame", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iFrame, pSubclass, FPout)
                    ELSEIF INSTR(LCASE$(szTempA$), "ss_whiterect") or INSTR(LCASE$(szTempA$), "ss_grayrect") or INSTR(LCASE$(szTempA$), "ss_blackrect") THEN
                        INCR iRect
                        szTempC$ = TRIM$(STR$(iDialog))
                        prn(" - found form", FALSE)
                        prn(szTempC$, FALSE)
                        prn(".rect", FALSE)
                        szTempC$ = TRIM$(STR$(iRect))
                        prn(szTempC$, TRUE)
                        ' ==========
                        szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                        szTempC$  = parse$(szTempA$, ",", 0) ' text
                        szID$     = parse$(szTempA$, ",", 1) ' id
                        szTempD$  = parse$(szTempA$, ",", 3) ' style
                        szLeft$   = parse$(szTempA$, ",", 4) ' left
                        szTop$    = parse$(szTempA$, ",", 5) ' top
                        szHeight$ = parse$(szTempA$, ",", 6) ' height
                        szWidth$  = parse$(szTempA$, ",", 7) ' width
                        szTempE$  = CHR$(34) & "static"
                        szTempE$  = szTempE$ & CHR$(34)
                        szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                        szTempD$  = AddStyle("SS_NOTIFY", szTempD$)
                        szTempD$  = AddStyle("WS_CHILD", szTempD$)
                        GenerateControl("","Rect", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iRect, pSubclass, FPout)
                    ELSE
                        INCR iStatic
                        szTempC$ = TRIM$(STR$(iDialog))
                        prn(" - found form", FALSE)
                        prn(szTempC$, FALSE)
                        prn(".static", FALSE)
                        szTempC$ = TRIM$(STR$(iStatic))
                        prn(szTempC$, TRUE)
                        ' ==========
                        szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                        szTempC$  = parse$(szTempA$, ",", 0) ' text
                        szID$     = parse$(szTempA$, ",", 1) ' id
                        szTempD$  = parse$(szTempA$, ",", 3) ' style
                        szLeft$   = parse$(szTempA$, ",", 4) ' left
                        szTop$    = parse$(szTempA$, ",", 5) ' top
                        szHeight$ = parse$(szTempA$, ",", 6) ' height
                        szWidth$  = parse$(szTempA$, ",", 7) ' width
                        szTempE$  = CHR$(34) & "static"
                        szTempE$  = szTempE$ & CHR$(34)
                        szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                        szTempD$  = AddStyle("SS_NOTIFY", szTempD$)
                        szTempD$  = AddStyle("WS_CHILD", szTempD$)
                        GenerateControl("","Static", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iStatic, pSubclass, FPout)
                    END IF
                    CASE "button"
                    IF INSTR(LCASE$(szTempA$), "bs_autocheckbox") or INSTR(LCASE$(szTempA$), "bs_auto3state") or INSTR(LCASE$(szTempA$), "bs_3state") THEN
                        INCR iCheckBox
                        szTempC$ = TRIM$(STR$(iDialog))
                        prn(" - found form", FALSE)
                        prn(szTempC$, FALSE)
                        prn(".checkbox", FALSE)
                        szTempC$ = TRIM$(STR$(iCheckBox))
                        prn(szTempC$, TRUE)
                        ' ==========
                        szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                        szTempC$  = parse$(szTempA$, ",", 0) ' text
                        szID$     = parse$(szTempA$, ",", 1) ' id
                        szTempD$  = parse$(szTempA$, ",", 3) ' style
                        szLeft$   = parse$(szTempA$, ",", 4) ' left
                        szTop$    = parse$(szTempA$, ",", 5) ' top
                        szHeight$ = parse$(szTempA$, ",", 6) ' height
                        szWidth$  = parse$(szTempA$, ",", 7) ' width
                        szTempE$  = CHR$(34) & "button"
                        szTempE$  = szTempE$ & CHR$(34)
                        szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                        szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                        szTempD$  = AddStyle("WS_CHILD", szTempD$)
                        GenerateControl("","CheckBox", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iCheckBox, pSubclass, FPout)
                    ELSEIF INSTR(LCASE$(szTempA$),"bs_autoradiobutton") THEN
                        INCR iRadio
                        szTempC$ = TRIM$(STR$(iDialog))
                        prn(" - found form", FALSE)
                        prn(szTempC$, FALSE)
                        prn(".radio", FALSE)
                        szTempC$ = TRIM$(STR$(iRadio))
                        prn(szTempC$, TRUE)
                        ' ==========
                        szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                        szTempC$  = parse$(szTempA$, ",", 0) ' text
                        szID$     = parse$(szTempA$, ",", 1) ' id
                        szTempD$  = parse$(szTempA$, ",", 3) ' style
                        szLeft$   = parse$(szTempA$, ",", 4) ' left
                        szTop$    = parse$(szTempA$, ",", 5) ' top
                        szHeight$ = parse$(szTempA$, ",", 6) ' height
                        szWidth$  = parse$(szTempA$, ",", 7) ' width
                        szTempE$  = CHR$(34) & "button"
                        szTempE$  = szTempE$ & CHR$(34)
                        szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                        szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                        szTempD$  = AddStyle("WS_CHILD", szTempD$)
                        GenerateControl("","Radio", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iRadio, pSubclass, FPout)
                    ELSE
                        INCR iButton
                        szTempC$ = TRIM$(STR$(iDialog))
                        prn(" - found form", FALSE)
                        prn(szTempC$, FALSE)
                        prn(".button", FALSE)
                        szTempC$ = TRIM$(STR$(iButton))
                        prn(szTempC$, TRUE)
                        ' ==========
                        szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                        szTempC$  = parse$(szTempA$, ",", 0) ' text
                        szID$     = parse$(szTempA$, ",", 1) ' id
                        szTempD$  = parse$(szTempA$, ",", 3) ' style
                        szLeft$   = parse$(szTempA$, ",", 4) ' left
                        szTop$    = parse$(szTempA$, ",", 5) ' top
                        szHeight$ = parse$(szTempA$, ",", 6) ' height
                        szWidth$  = parse$(szTempA$, ",", 7) ' width
                        szTempE$  = CHR$(34) & "button"
                        szTempE$  = szTempE$ & CHR$(34)
                        szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                        szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                        szTempD$  = AddStyle("WS_CHILD", szTempD$)
                        GenerateControl("","Button", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iButton, pSubclass, FPout)
                    END IF
                    CASE "richedit20a"
                    INCR iRichEdit
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".richedit", FALSE)
                    szTempB$ = TRIM$(STR$(iRichEdit))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("WS_EX_CLIENTEDGE","RichEdit", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iRichEdit, pSubclass, FPout)
                    CASE "richedit20w"
                    INCR iRichEdit
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".richedit", FALSE)
                    szTempB$ = TRIM$(STR$(iRichEdit))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("WS_EX_CLIENTEDGE","RichEdit", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iRichEdit, pSubclass, FPout)
                    CASE "richedit"
                    INCR iRichEdit
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".richedit", FALSE)
                    szTempB$ = TRIM$(STR$(iRichEdit))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("WS_EX_CLIENTEDGE","RichEdit", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iRichEdit, pSubclass, FPout)
                    CASE "sysanimate32"
                    INCR iAnimate
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".animate", FALSE)
                    szTempB$ = TRIM$(STR$(iAnimate))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("","Animate", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iAnimate, pSubclass, FPout)
                    CASE "sysdatetimepick32"
                    INCR iDate
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".datepicker", FALSE)
                    szTempB$ = TRIM$(STR$(iDate))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("","DatePicker", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iDate, pSubclass, FPout)
                    CASE "msctls_hotkey32"
                    INCR iHotkey
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".hotkey", FALSE)
                    szTempB$ = TRIM$(STR$(iHotkey))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("","HotKey", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iHotkey, pSubclass, FPout)
                    CASE "msctls_progress32"
                    INCR iProgress
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".progressbar", FALSE)
                    szTempB$ = TRIM$(STR$(iProgress))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("","ProgressBar", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iProgress, pSubclass, FPout)
                    CASE "sysmonthcal32"
                    INCR iMonth
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".monthcal", FALSE)
                    szTempB$ = TRIM$(STR$(iMonth))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("","MonthCal", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iMonth, pSubclass, FPout)
                    CASE "rebarwindow32"
                    INCR iRebar
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".rebar", FALSE)
                    szTempB$ = TRIM$(STR$(iRebar))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("","ReBar", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iRebar, pSubclass, FPout)
                    CASE "msctls_statusbar32"
                    INCR iStatus
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".statusbar", FALSE)
                    szTempB$ = TRIM$(STR$(iStatus))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("","StatusBar", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iStatus, pSubclass, FPout)
                    CASE "toolbarwindow32"
                    INCR iToolbar
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".toolbar", FALSE)
                    szTempB$ = TRIM$(STR$(iToolbar))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("","ToolBar", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iToolbar, pSubclass, FPout)
                    CASE "tooltips_class32"
                    INCR iTooltip
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".tooltips", FALSE)
                    szTempB$ = TRIM$(STR$(iTooltip))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("","ToolTips", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iTooltip, pSubclass, FPout)
                    CASE "msctls_trackbar32"
                    INCR iTrack
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".trackbar", FALSE)
                    szTempB$ = TRIM$(STR$(iTrack))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("","TrackBar", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iTrack, pSubclass, FPout)
                    CASE "msctls_updown32"
                    INCR iUpDown
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".updown", FALSE)
                    szTempB$ = TRIM$(STR$(iUpDown))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("","UpDown", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iUpDown, pSubclass, FPout)
                    CASE "comboboxex32"
                    INCR iComboEx
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".comboboxex", FALSE)
                    szTempB$ = TRIM$(STR$(iComboEx))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("WS_EX_CLIENTEDGE","ComboBoxEx", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iComboEx, pSubclass, FPout)
                    CASE "sysheader32"
                    INCR iHeader
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".header", FALSE)
                    szTempB$ = TRIM$(STR$(iHeader))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("","Header", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iHeader, pSubclass, FPout)
                    CASE "sysipaddress32"
                    INCR iAddress
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".ipaddress", FALSE)
                    szTempB$ = TRIM$(STR$(iAddress))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("WS_EX_CLIENTEDGE","IPAddress", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iAddress, pSubclass, FPout)
                    CASE "syslistview32"
                    INCR iListView
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".listview", FALSE)
                    szTempB$ = TRIM$(STR$(iListView))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("WS_EX_CLIENTEDGE","ListView", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iListView, pSubclass, FPout)
                    CASE "syspager"
                    INCR iPager
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".pager", FALSE)
                    szTempB$ = TRIM$(STR$(iPager))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("","Pager", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iPager, pSubclass, FPout)
                    CASE "systabcontrol32"
                    INCR iTab
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".tab", FALSE)
                    szTempB$ = TRIM$(STR$(iTab))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("","TabControl", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iTab, pSubclass, FPout)
                    CASE "systreeview32"
                    INCR iTree
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".treeview", FALSE)
                    szTempB$ = TRIM$(STR$(iTree))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("WS_EX_CLIENTEDGE","TreeView", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iTree, pSubclass, FPout)
                ELSE
                    INCR iControl
                    szTempB$ = TRIM$(STR$(iDialog))
                    prn(" - found form", FALSE)
                    prn(szTempB$, FALSE)
                    prn(".control", FALSE)
                    szTempB$ = TRIM$(STR$(iControl))
                    prn(szTempB$, TRUE)
                    ' ==========
                    szTempA$  = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - 16))
                    szTempC$  = parse$(szTempA$, ",", 0) ' text
                    szID$     = parse$(szTempA$, ",", 1) ' id
                    szTempE$  = parse$(szTempA$, ",", 2) ' class
                    szTempD$  = parse$(szTempA$, ",", 3) ' style
                    szLeft$   = parse$(szTempA$, ",", 4) ' left
                    szTop$    = parse$(szTempA$, ",", 5) ' top
                    szHeight$ = parse$(szTempA$, ",", 6) ' height
                    szWidth$  = parse$(szTempA$, ",", 7) ' width
                    szTempD$  = AddStyle("WS_VISIBLE", szTempD$)
                    szTempD$  = AddStyle("WS_TABSTOP", szTempD$)
                    szTempD$  = AddStyle("WS_CHILD", szTempD$)
                    GenerateControl("","Control", szID$, szTempE$, szTempC$, szTempD$, szLeft$, szTop$, szHeight$, szWidth$, iDialog, iControl, pSubclass, FPout)
                END SELECT
            END IF
            szTempA$ = ""
        END IF
    END IF
    WEND
    CLOSE FPin

' *************************************************************************

    IF pMenu = TRUE THEN
        FPRINT FPout, ""

        EmitSeparator (FPout)
        FPRINT FPout, "'                          Start Building Menus"
        EmitSeparator (FPout)

        FPRINT FPout, "MainMenu   =  CreateMenu()   ' CreateMenu returns a MENU HANDLE"
        FPRINT FPout, "FileMenu   =  CreateMenu()   ' CreateMenu returns a MENU HANDLE"

        EmitSeparator (FPout)

        FPRINT FPout, "'                     Build the File Menu First"

        EmitSeparator (FPout)

        FPRINT FPout, "AppendMenu(FileMenu,MF_STRING   ,ID_Open  ,";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, "&Open";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, ")"
        FPRINT FPout, "AppendMenu(FileMenu,MF_STRING   ,ID_Save  ,";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, "&Save";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, ")"
        FPRINT FPout, "AppendMenu(FileMenu,MF_STRING   ,ID_SaveAs,";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, "Save&As";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, ")"
        FPRINT FPout, "AppendMenu(FileMenu,MF_SEPARATOR,    0    ,";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, CHR$(34);
        FPRINT FPout, ")"
        FPRINT FPout, "AppendMenu(FileMenu,MF_STRING   ,ID_Close ,";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, "&Close";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, ")"
        FPRINT FPout, "AppendMenu(FileMenu,MF_SEPARATOR,    0    ,";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, CHR$(34);
        FPRINT FPout, ")"
        FPRINT FPout, "AppendMenu(FileMenu,MF_STRING   ,ID_Exit  ,";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, "E&xit";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, ")"

        EmitSeparator (FPout)

        FPRINT FPout, "'                        Build the Main Menu Next"

        EmitSeparator (FPout)

        FPRINT FPout, "AppendMenu ( MainMenu , MF_STRING , ID_Edit    , ";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, "Edit";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, ")"
        FPRINT FPout, "AppendMenu ( MainMenu , MF_STRING , ID_Options , ";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, "Options";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, ")"

        EmitSeparator (FPout)

        FPRINT FPout, "'                  Attach the File menu to the main menu"

        EmitSeparator (FPout)

        FPRINT FPout, "InsertMenu ( MainMenu, ID_Edit , MF_POPUP , FileMenu ,";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, "File";
        FPRINT FPout, CHR$(34);
        FPRINT FPout, ")"

        EmitSeparator (FPout)

        FPRINT FPout, "SetMenu(Form1,MainMenu)              ' Activate the menu"
    END IF

' *************************************************************************

    FPRINT FPout, ""

    EmitSeparator (FPout)

    FPRINT FPout, ""
    FOR iTemp = 1 to iDialog
        FPRINT FPout, "CenterWindow (Form";
        szBuffer$ = TRIM$(STR$(iTemp))
        FPRINT FPout, szBuffer$;
        FPRINT FPout, ")   ' Center our Form on the screen"
        FPRINT FPout, "UpdateWindow (Form";
        szBuffer$ = TRIM$(STR$(iTemp))
        FPRINT FPout, szBuffer$;
        FPRINT FPout, ")   ' Force update of all controls"
        FPRINT FPout, "ShowWindow   (Form";
        szBuffer$ = TRIM$(STR$(iTemp))
        FPRINT FPout, szBuffer$;
        FPRINT FPout, ", SW_SHOWNORMAL) ' Display our creation!"
    NEXT
    FPRINT FPout, "END SUB"

' *************************************************************************

    ' do subclass generation
    iDialog = 0
    IF pSubclass = TRUE THEN
        OPEN szInput$ FOR INPUT AS FPin
        WHILE NOT EOF(FPin)
            LINE INPUT FPin, szBuffer$

            ' check for new dialog
            szBuffer$ = TRIM$(szBuffer$)
            IF LCASE$(parse$(szBuffer$, " ", 1)) = "dialog" THEN
                INCR iDialog

                'reset standard controls
                iStatic = 0
                iListBox = 0
                iComboBox = 0
                iGroup = 0
                iIcon = 0
                iControl = 0
                iButton = 0
                iEdit = 0
                iCheckBox = 0
                iRadio = 0
                iVScroll = 0
                iHScroll = 0
                iFrame = 0
                iRect = 0
                iRichEdit = 0
                iAnimate = 0
                iDate = 0
                iHotkey = 0
                iProgress = 0
                iMonth = 0
                iRebar = 0
                iStatus = 0
                iToolbar = 0
                iTooltip = 0
                iTrack = 0
                iUpDown = 0
                iComboEx = 0
                iHeader = 0
                iAddress = 0
                iListView = 0
                iPager = 0
                iTab = 0
                iTree = 0
            END IF

            ' check if we have a dialog to work with
            IF iDialog > 0 THEN   ' join lines
                szTempA$ = szTempA$ & " "
                szTempA$ = szTempA$ & TRIM$(szBuffer$)

                IF RIGHT$(TRIM$(szBuffer$), 1) <> "|" and RIGHT$(TRIM$(szBuffer$), 1) _
                <> "," and RIGHT$(TRIM$(LCASE$(szBuffer$)), 3) <> "not" THEN

                ' attempt to reformat line
                szTempA$ = TRIM$(szTempA$)              ' trim spaces
                szTempC$ = parse$(szTempA$, " ", 0)     ' search for control name
                szTempB$ = szTempC$                     ' add control to string
                szTempD$ = SPACE$(16 - LEN(szTempC$))   ' create padding
                szTempB$ = szTempB$ & szTempD$          ' add padding to string

                ' get control properties
                szTempD$ = TRIM$(RIGHT$(szTempA$, LEN(szTempA$) - LEN(szTempC$)))
                szTempA$ = szTempB$ & szTempD$          ' add properties to string

                IF LCASE$(LEFT$(szTempA$, 5)) = "ltext" THEN
                    INCR iStatic
                    GenerateProc("Static", iDialog, iStatic, FPout)
                ELSEIF LCASE$(LEFT$(szTempA$, 5)) = "ctext" THEN
                    INCR iStatic
                    GenerateProc("Static", iDialog, iStatic, FPout)
                ELSEIF LCASE$(LEFT$(szTempA$, 5)) = "rtext" THEN
                    INCR iStatic
                    GenerateProc("Static", iDialog, iStatic, FPout)
                ELSEIF LCASE$(LEFT$(szTempA$, 8)) = "edittext" THEN
                    INCR iEdit
                    GenerateProc("Edit", iDialog, iEdit, FPout)
                ELSEIF LCASE$(LEFT$(szTempA$, 10)) = "pushbutton" THEN
                    INCR iButton
                    GenerateProc("Button", iDialog, iButton, FPout)
                ELSEIF LCASE$(LEFT$(szTempA$, 13)) = "defpushbutton" THEN
                    INCR iButton
                    GenerateProc("Button", iDialog, iButton, FPout)
                ELSEIF LCASE$(LEFT$(szTempA$, 8)) = "checkbox" THEN
                    INCR iCheckBox
                    GenerateProc("CheckBox", iDialog, iCheckBox, FPout)
                ELSEIF LCASE$(LEFT$(szTempA$, 11)) = "radiobutton" THEN
                    INCR iRadio
                    GenerateProc("Radio", iDialog, iRadio, FPout)
                ELSEIF LCASE$(LEFT$(szTempA$, 8)) = "combobox" THEN
                    INCR iComboBox
                    GenerateProc("ComboBox", iDialog, iComboBox, FPout)
                ELSEIF LCASE$(LEFT$(szTempA$, 7)) = "listbox" THEN
                    INCR iListBox
                    GenerateProc("ListBox", iDialog, iListBox, FPout)
                ELSEIF LCASE$(LEFT$(szTempA$, 4)) = "icon" THEN
                    INCR iIcon
                    GenerateProc("Icon", iDialog, iIcon, FPout)
                ELSEIF LCASE$(LEFT$(szTempA$, 9)) = "scrollbar" THEN
                    IF INSTR(LCASE$(szTempA$), "sbs_vert") > 0 THEN
                        INCR iVScroll
                        GenerateProc("VScroll", iDialog, iVScroll, FPout)
                    ELSE
                        INCR iHScroll
                        GenerateProc("HScroll", iDialog, iHScroll, FPout)
                    END IF
                ELSEIF LCASE$(LEFT$(szTempA$, 7)) = "control" THEN
                    szTempB$ = TRIM$(LCASE$(parse$(szTempA$, ",", 2)))
                    szTempB$ = LEFT$(szTempB$, LEN(szTempB$) - 1)
                    szTempB$ = RIGHT$(szTempB$, LEN(szTempB$) - 1)
                    SELECT CASE szTempB$
                        CASE "static"
                        IF INSTR(LCASE$(szTempA$), "ss_blackframe") or INSTR(LCASE$(szTempA$), "ss_grayframe") THEN
                            INCR iFrame
                            GenerateProc("Frame", iDialog, iFrame, FPout)
                        ELSEIF INSTR(LCASE$(szTempA$), "ss_whiterect") or INSTR(LCASE$(szTempA$), "ss_grayrect") or INSTR(LCASE$(szTempA$), "ss_blackrect") THEN
                            INCR iRect
                            GenerateProc("Rect", iDialog, iRect, FPout)
                        ELSE
                            INCR iStatic
                            GenerateProc("Static", iDialog, iStatic, FPout)
                        END IF
                        CASE "button"
                        IF INSTR(LCASE$(szTempA$), "bs_autocheckbox") or INSTR(LCASE$(szTempA$), "bs_auto3state") or INSTR(LCASE$(szTempA$), "bs_3state") THEN
                            INCR iCheckBox
                            GenerateProc("CheckBox", iDialog, iCheckBox, FPout)
                        ELSEIF INSTR(LCASE$(szTempA$), "bs_autoradiobutton") THEN
                            INCR iRadio
                            GenerateProc("Radio", iDialog, iRadio, FPout)
                        ELSE
                            INCR iButton
                            GenerateProc("Button", iDialog, iButton, FPout)
                        END IF
                        CASE "richedit"
                        INCR iRichEdit
                        GenerateProc("RichEdit", iDialog, iRichEdit, FPout)
                        CASE "richedit20w"
                        INCR iRichEdit
                        GenerateProc("RichEdit", iDialog, iRichEdit, FPout)
                        CASE "richedit20a"
                        INCR iRichEdit
                        GenerateProc("RichEdit", iDialog, iRichEdit, FPout)
                        CASE "richedit20a"
                        INCR iRichEdit
                        GenerateProc("RichEdit", iDialog, iRichEdit, FPout)
                        CASE "sysanimate32"
                        INCR iAnimate
                        GenerateProc("Animate", iDialog, iAnimate, FPout)
                        CASE "sysdatetimepick32"
                        INCR iDate
                        GenerateProc("DatePicker", iDialog, iDate, FPout)
                        CASE "msctls_hotkey32"
                        INCR iHotkey
                        GenerateProc("HotKey", iDialog, iHotkey, FPout)
                        CASE "msctls_progress32"
                        INCR iProgress
                        GenerateProc("ProgressBar", iDialog, iProgress, FPout)
                        CASE "sysmonthcal32"
                        INCR iMonth
                        GenerateProc("MonthCal", iDialog, iMonth, FPout)
                        CASE "rebarwindow32"
                        INCR iRebar
                        GenerateProc("ReBar", iDialog, iRebar, FPout)
                        CASE "msctls_statusbar32"
                        INCR iStatus
                        GenerateProc("StatusBar", iDialog, iStatus, FPout)
                        CASE "toolbarwindow32"
                        INCR iToolbar
                        GenerateProc("ToolBar", iDialog, iToolbar, FPout)
                        CASE "tooltips_class32"
                        INCR iTooltip
                        GenerateProc("ToolTips", iDialog, iTooltip, FPout)
                        CASE "msctls_trackbar32"
                        INCR iTrack
                        GenerateProc("TrackBar", iDialog, iTrack, FPout)
                        CASE "msctls_updown32"
                        INCR iUpDown
                        GenerateProc("UpDown", iDialog, iUpDown, FPout)
                        CASE "comboboxex32"
                        INCR iComboEx
                        GenerateProc("ComboBoxEx", iDialog, iComboEx, FPout)
                        CASE "sysheader32"
                        INCR iHeader
                        GenerateProc("Header", iDialog, iHeader, FPout)
                        CASE "sysipaddress32"
                        INCR iAddress
                        GenerateProc("IPAddress", iDialog, iAddress, FPout)
                        CASE "syslistview32"
                        INCR iListView
                        GenerateProc("ListView", iDialog, iListView, FPout)
                        CASE "syspager"
                        INCR iPager
                        GenerateProc("Pager", iDialog, iPager, FPout)
                        CASE "systabcontrol32"
                        INCR iTab
                        GenerateProc("TabControl", iDialog, iTab, FPout)
                        CASE "systreeview32"
                        INCR iTree
                        GenerateProc("TreeView", iDialog, iTree, FPout)
                    ELSE
                        INCR iControl
                        GenerateProc("Control", iDialog, iControl, FPout)
                    END SELECT
                END IF
                szTempA$ = ""
            END IF
        END IF
    WEND
    CLOSE FPin
    END IF

' *************************************************************************

    FPRINT FPout, ""

    FPRINT FPout, ""
    FPRINT FPout, ""

    'close output file
    CLOSE FPout
END SUB


FUNCTION AddStyle$(szArgument$, szStyle$)
'                  szArgument$  ' style to add
'                  szStyle$     ' string to add style to

    STATIC szTemp$
    STATIC szTempA$

    IF INSTR(LCASE$(szStyle$), LCASE$(szArgument$)) = 0 THEN
        IF LEN(TRIM$(szStyle$)) > 0 THEN
            szTemp$ = szStyle$
            szTempA$ = szArgument$ & "|"
            szTempA$ = REPLACE$(szTempA$, "|", " OR ")
            FUNCTION = szTempA$ & szTemp$
        ELSE
            FUNCTION = szArgument$
        END IF
    ELSE
        FUNCTION = szStyle$
    END IF
END FUNCTION


FUNCTION parse$( _
    szLine$,     _
    szDel$,      _
    iMatch       _
)

    ! char *szTmp;
    ! int qCount = 0;
    STATIC szTemp$
    STATIC szBuffer$
    ! int lstQuote = FALSE;
    ! int iCount = 0;
    STATIC dQuote$ * 2
    STATIC sQuote$ * 1

    dQuote$ = CHR$(34) & CHR$(34)
    sQuote$ = CHR$(34)
    szTemp$ = szLine$
    szTmp = strtok(szTemp$, szDel$)
    WHILE szTmp <> NULL
        qCount += TALLY(szTmp, CHR$(34))
        IF mod(qCount, 2) = 0  THEN
            IF lstQuote = TRUE THEN
                lstrcat(szBuffer$, szTmp)
                lstQuote = FALSE
            ELSE
                lstrcpy(szBuffer$, szTmp)
            END IF

            IF iCount = iMatch THEN
                'make sure its not a blank string
                IF LEN(szBuffer$) > 2 THEN
                    szBuffer$ = REPLACE$(szBuffer$, dQuote$, sQuote$)
                END IF
                FUNCTION = szBuffer$
            END IF

            qCount = 0
            INCR iCount
        ELSE
            lstrcat(szBuffer$, szTmp)
            lstrcat(szBuffer$, szDel$)
            lstQuote = TRUE
        END IF

        szTmp = strtok(NULL, szDel$)
    WEND

    FUNCTION = Chr$(0)
END FUNCTION


SUB GenerateControl(szCStyle$,szControlName$,szControlID$,szControlClass$,szControlTitle$,szControlStyle$,szControlLeft$,szControlTop$,szControlHeight$,szControlWidth$,iFormNo,iControlNo,iMakeProc,fpName AS FILE *)
'   szCStyle$           ' extended style
'   szControlName$      ' name of control
'   szControlID$        ' control id
'   szControlClass$     ' class of control
'   szControlTitle$     ' caption of control
'   szControlStyle$     ' control styles
'   szControlLeft$      ' control left position
'   szControlTop$       ' control top position
'   szControlHeight$    ' control height
'   szControlWidth$     ' control width
'   iFormNo             ' current form number
'   iControlNo          ' current control number
'   iMakeProc           ' generate subclass code?
'   fpName AS FILE *    ' pointer to file handle

    STATIC szCtrlName$   ' control name
    STATIC szCtrlNo$     ' number of controls
    STATIC szFormNo$     ' number of forms

    FPRINT fpName, ""

    EmitSeparator (fpName)

    FPRINT fpName, ""

    ' setup control name

    szCtrlNo$ = TRIM$(STR$(iControlNo))
    szFormNo$ = TRIM$(STR$(iFormNo))

    IF iFormNo > 1 THEN
        szCtrlName$ = "Form" & szFormNo$
        szCtrlName$ = szCtrlName$ & "_"
        szCtrlName$ = szCtrlName$ & szControlName$
        szCtrlName$ = szCtrlName$ & szCtrlNo$
    ELSE
        szCtrlName$ = szControlName$ & szCtrlNo$
    END IF

    FPRINT fpName, "GLOBAL  ";
    FPRINT fpName, szCtrlName$;
    FPRINT fpName, " AS HWND"
    FPRINT fpName, "CONST   ID_";
    FPRINT fpName, szCtrlName$;
    FPRINT fpName, " = ";
    FPRINT fpName, szControlID$
    FPRINT fpName, ""

    FPRINT fpName, szCtrlName$;
    FPRINT fpName, " = CreateWindowEx(";

    IF szCStyle$ = "" THEN
        FPRINT fpName, "0";
    ELSE
        FPRINT fpName, szCStyle$;
    END IF

    FPRINT fpName, ",";
    FPRINT fpName, szControlClass$;
    FPRINT fpName, ",";
    FPRINT fpName, szControlTitle$;
    FPRINT fpName, ", _"

    REPLACE "|" WITH " OR " IN szControlStyle$

    FPRINT fpName, szControlStyle$;
    FPRINT fpName, ", _"
    FPRINT fpName, szControlLeft$;
    FPRINT fpName, "*BCX_ScaleX,";
    FPRINT fpName, szControlTop$;
    FPRINT fpName, "*BCX_ScaleY,";
    FPRINT fpName, szControlHeight$;
    FPRINT fpName, "*BCX_ScaleX,";
    FPRINT fpName, szControlWidth$;
    FPRINT fpName, "*BCX_ScaleY, _ " 'zap
    FPRINT fpName, "Form", szFormNo$;
    FPRINT fpName, ",ID_";
    FPRINT fpName, szCtrlName$;
    FPRINT fpName, ",hInst,NULL)"
    FPRINT fpName, ""

    FPRINT fpName, "SendMessage(";
    FPRINT fpName, szCtrlName$;
    FPRINT fpName, ", WM_SETFONT, _"
    FPRINT fpName, "GetStockObject(DEFAULT_GUI_FONT),MAKELPARAM(FALSE,0))"

    IF iMakeProc = TRUE THEN
        FPRINT fpName, ""
        FPRINT fpName, "GLOBAL lp";
        FPRINT fpName, szCtrlName$;
        FPRINT fpName, "_WndProc AS FARPROC"
        FPRINT fpName, "lp";
        FPRINT fpName, szCtrlName$;
        FPRINT fpName, "_WndProc = SetWindowLong(";
        FPRINT fpName, szCtrlName$;
        FPRINT fpName, ",GWL_WNDPROC,";
        FPRINT fpName, szCtrlName$;
        FPRINT fpName, "_WndProc)"
    END IF
END SUB


SUB GenerateProc(szControlName$, iFormNo, iControlNo, fpName AS FILE *)
'    szControlName$     ' name of control
'    iFormNo            ' form number
'    iControlNo         ' control number
'    fpName AS FILE *   ' pointer to output file

    STATIC szCtrlName$   ' control name
    STATIC szCtrlNo$     ' number of controls
    STATIC szFormNo$     ' number of forms

    FPRINT fpName, ""
    EmitSeparator (fpName)
    FPRINT fpName, ""

    ' setup control name
    szCtrlNo$ = TRIM$(STR$(iControlNo))
    szFormNo$ = TRIM$(STR$(iFormNo))

    IF iFormNo > 1 THEN
        szCtrlName$ = "Form" & szFormNo$
        szCtrlName$ = szCtrlName$ & "_"
        szCtrlName$ = szCtrlName$ & szControlName$
        szCtrlName$ = szCtrlName$ & szCtrlNo$
    ELSE
        szCtrlName$ = szControlName$ & szCtrlNo$
    END IF

    FPRINT fpName, "CALLBACK FUNCTION " , szCtrlName$,"_WndProc()"
    FPRINT fpName, "SELECT CASE Msg"
    FPRINT fpName, "CASE WM_LBUTTONDBLCLK"
    FPRINT fpName, "MsgBox ";
    FPRINT fpName, CHR$(34);
    FPRINT fpName, szControlName$;
    FPRINT fpName, " ";
    FPRINT fpName, szCtrlNo$;
    FPRINT fpName, " Double Clicked";
    FPRINT fpName, CHR$(34)
    FPRINT fpName, "FUNCTION = 0"
    FPRINT fpName, "END SELECT"
    FPRINT fpName, "FUNCTION = CallWindowProc(lp";
    FPRINT fpName, szCtrlName$;
    FPRINT fpName, "_WndProc,hWnd,Msg,wParam,lParam)"
    FPRINT fpName, "END FUNCTION"
END SUB


SUB prn(szStr$, iEnter)
'   szStr$  ' string to print
'   iEnter  ' add return string?
    IF pStatus = TRUE THEN
        IF iEnter = TRUE THEN
            PRINT szStr$
        ELSE
            PRINT szStr$;
        END IF
    END IF
END SUB


Sub EmitSeparator(FP@)
    STATIC szBuffer$
    FPRINT FP, "' ";
    szBuffer$ = REPEAT$(74, "*")
    FPRINT FP, szBuffer$
End Sub


SUB Format_Source(file$, fout$)
    Dim Source$           '  Source Filename
    Dim Destin$           '  Destination Filename
    Dim NumTabs           '  Indentation level
    Dim Count             '  counter variable
    Dim A$,B$,C$,D$,Op$   '  Working Strings

    NumTabs = 4      ' DEFAULT to 4 space indentation level

    OPEN file$ FOR INPUT  AS FP1
    OPEN fout$ FOR OUTPUT AS FP2

    WHILE NOT EOF(FP1)
        LINE INPUT FP1,A$
        Op$ = ""
        A$ = TRIM$ (A$) & " "

        '----------------------------------------------------------------------------

        IF UCASE$(LEFT$(A$,5))   =  "TYPE "        THEN  Op$  =  "TYPE"
        IF UCASE$(LEFT$(A$,3))   =  "DO "          THEN  Op$  =  "DO"
        IF UCASE$(LEFT$(A$,6))   =  "WHILE "       THEN  Op$  =  "WHILE"
        IF UCASE$(LEFT$(A$,5))   =  "LOOP "        THEN  Op$  =  "LOOP"
        IF UCASE$(LEFT$(A$,5))   =  "WEND "        THEN  Op$  =  "WEND"
        IF UCASE$(MID$(A$,1,6))  =  "END IF"       THEN  Op$  =  "END"
        IF UCASE$(MID$(A$,1,7))  =  "END  IF"      THEN  Op$  =  "END"
        IF UCASE$(MID$(A$,1,5))  =  "ENDIF"        THEN  Op$  =  "END"
        IF UCASE$(LEFT$(A$,5))   =  "ELSE "        THEN  Op$  =  "ELSE"
        IF UCASE$(LEFT$(A$,6))   =  "ELSEIF"       THEN  Op$  =  "ELSEIF"
        IF UCASE$(LEFT$(A$,4))   =  "FOR "         THEN  Op$  =  "FOR"
        IF UCASE$(LEFT$(A$,5))   =  "NEXT "        THEN  Op$  =  "NEXT"
        IF UCASE$(LEFT$(A$,7))   =  "SELECT "      THEN  Op$  =  "SELECT"
        IF UCASE$(LEFT$(A$,10))  =  "END SELECT"   THEN  Op$  =  "END SELECT"
        IF UCASE$(LEFT$(A$,11))  =  "END  SELECT"  THEN  Op$  =  "END SELECT"
        IF UCASE$(LEFT$(A$,8))   =  "END TYPE"     THEN  Op$  =  "END TYPE"
        IF UCASE$(LEFT$(A$,9))   =  "END  TYPE"    THEN  Op$  =  "END TYPE"

        '----------------------------------------------------------------------------

        IF UCASE$(LEFT$(A$,3))  = "IF " THEN
            D$ = UCASE$(RIGHT$(A$,5))
            IF D$ = "THEN " AND UCASE$(LEFT$(A$,2))="IF" THEN Op$ = "IF"
            C$ = TRIM$(MID$(A$,INSTR(UCASE$(A$),"THEN ") + 4, LEN(A$)))
            IF LEFT$(C$,1)="'"  AND UCASE$(LEFT$(A$,2))="IF" THEN Op$ = "IF"
        END IF

        '----------------------------------------------------------------------------

        SELECT CASE Op$
            CASE  "TYPE"     : GOSUB  StartCtrl
            CASE  "IF"       : GOSUB  StartCtrl
            CASE  "WHILE"    : GOSUB  StartCtrl
            CASE  "DO"       : GOSUB  StartCtrl
            CASE  "FOR"      : GOSUB  StartCtrl
            CASE  "SELECT"   : GOSUB  StartCtrl
            EXIT SELECT

            StartCtrl:

            B$  =  SPACE$(Count) & A$
            INCR Count,NumTabs
            RETURN
        END SELECT

        '----------------------------------------------------------------------------

        IF Op$ = "ELSE" OR Op$ = "ELSEIF" THEN
            IF Count-NumTabs <  0  THEN B$ = SPACE$(Count) & A$
            IF Count-NumTabs >= 0  THEN B$ = SPACE$(Count-NumTabs) & A$
        END IF

        '----------------------------------------------------------------------------

        SELECT CASE Op$
            CASE  "LOOP"        :  GOSUB  EndCtrl
            CASE  "WEND"        :  GOSUB  EndCtrl
            CASE  "END"         :  GOSUB  EndCtrl
            CASE  "NEXT"        :  GOSUB  EndCtrl
            CASE  "END SELECT"  :  GOSUB  EndCtrl
            CASE  "END TYPE"    :  GOSUB  EndCtrl
            EXIT SELECT

            EndCtrl:

            DECR Count,NumTabs
            IF Count < 0 THEN Count = 0
            B$ = SPACE$(Count) & A$
            RETURN
        END SELECT

        '----------------------------------------------------------------------------

        IF Op$ = "" THEN
            B$ = SPACE$(Count) & A$
        END IF

        '----------------------------------------------------------------------------

        STATIC x$

        x$ = ""
        lstrcat(x$, SPACE$(NumTabs))
        lstrcat(x$, B$)
        B$ = x$

        IF LEFT$(UCASE$(TRIM$(B$)), 1)  = "("            THEN B$ = LTRIM$(B$)
        IF LEFT$(UCASE$(TRIM$(B$)), 1)  = ")"            THEN B$ = LTRIM$(B$)
        IF LEFT$(UCASE$(TRIM$(B$)), 3)  = "' #"          THEN B$ = LTRIM$(B$)
        IF LEFT$(UCASE$(TRIM$(B$)), 3)  = "' -"          THEN B$ = LTRIM$(B$)
        IF LEFT$(UCASE$(TRIM$(B$)), 3)  = "' *"          THEN B$ = LTRIM$(B$)
        IF LEFT$(UCASE$(TRIM$(B$)), 4)  = "'   "         THEN B$ = LTRIM$(B$)
        IF LEFT$(UCASE$(TRIM$(B$)), 3)  = "SUB"          THEN B$ = LTRIM$(B$)
        IF LEFT$(UCASE$(TRIM$(B$)), 7)  = "END SUB"      THEN B$ = LTRIM$(B$)
        IF LEFT$(UCASE$(TRIM$(B$)), 12) = "END FUNCTION" THEN B$ = LTRIM$(B$)
        IF LEFT$(UCASE$(TRIM$(B$)), 9)  = "CALLBACK "    THEN B$ = LTRIM$(B$)

        IF NOT INSTR(B$, "=") THEN
            IF LEFT$(UCASE$(TRIM$(B$)), 9)  = "FUNCTION "    THEN B$ = LTRIM$(B$)
        END IF

        FPRINT FP2, RTRIM$(B$)
    LOOP

    CLOSE FP1
    CLOSE FP2
END SUB
