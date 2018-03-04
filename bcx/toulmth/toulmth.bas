' #########################################################################

    CONST CaptionName1$ = "Toulmth v1.0 :: build 2988"
    CONST ClassName1$   = "trunks_toulmth_main"

    CONST ID_Exit     =  1001   'File Menu member

    CONST ID_LV1 = 2001
    CONST ID_LV2 = 2002
    CONST ID_LV3 = 2003
    CONST ID_LV4 = 2004
    CONST ID_LV5 = 2005
    CONST ID_LV6 = 2006

    CONST ID_H1 = 3001
    CONST ID_H2 = 3002
    CONST ID_H3 = 3003
    CONST ID_H4 = 3004
    CONST ID_H5 = 3005
    CONST ID_H6 = 3006

    GLOBAL ID_LSEL

    GLOBAL MainMenu  AS HANDLE  'The Main Menu
    GLOBAL FileMenu  AS HANDLE  'The File Menu
    GLOBAL GroupMenu AS HANDLE
    GLOBAL HelpMenu  AS HANDLE

    GLOBAL BCX_GetDiaUnit
    GLOBAL BCX_cxBaseUnit
    GLOBAL BCX_cyBaseUnit
    GLOBAL BCX_ScaleX
    GLOBAL BCX_ScaleY

    GLOBAL szItems$[8]
    GLOBAL szColumns$[8]

    GLOBAL szFNHead$
    GLOBAL szFNBody$
    GLOBAL szFNFoot$
    GLOBAL szFNBodyO$
    GLOBAL szFNBodyE$

    GLOBAL szCurrentL$             ' current left variable
    GLOBAL szCurrentR$             ' current right variable

    GLOBAL szColContentL$[8]       ' temporary list content variables
    GLOBAL szColContentR$[8]       ' temporary list content

' ##########################################################################

FUNCTION WinMain(hInst AS HINSTANCE, hPrev AS HINSTANCE, CmdLine AS LPSTR, CmdShow AS int)
    STATIC Wc  AS WNDCLASS
    STATIC Msg AS MSG

    Wc.style           = CS_HREDRAW OR CS_VREDRAW OR CS_DBLCLKS
    Wc.lpfnWndProc     = WndProc1
    Wc.cbClsExtra      = 0
    Wc.cbWndExtra      = 0
    Wc.hInstance       = hInst
    Wc.hIcon           = LoadIcon     ( NULL,IDI_WINLOGO )
    Wc.hCursor         = LoadCursor      ( NULL, IDC_ARROW )
    Wc.hbrBackground = GetSysColorBrush(COLOR_BTNFACE)
    Wc.lpszMenuName    = NULL
    Wc.lpszClassName   = ClassName1$

    RegisterClass(&Wc)

    InitCommonControls()

    FormLoad (hInst)

    WHILE GetMessage ( &Msg, NULL, 0 ,0 )
        IF NOT IsWindow(Form1) OR NOT IsDialogMessage(Form1,&Msg) THEN
            TranslateMessage ( &Msg )
            DispatchMessage  ( &Msg )
        END IF
    WEND

    FUNCTION = Msg.wParam
END FUNCTION

' ##########################################################################

FUNCTION WndProc1(hWnd AS HWND, uMsg as UINT, wParam AS WPARAM, lParam AS LPARAM) AS LRESULT CALLBACK
    SELECT CASE uMsg
' **************************************************************************
    CASE WM_COMMAND
' **************************************************************************
        IF LOWORD(wParam)=ID_Exit THEN SendMessage(hWnd, WM_CLOSE, 0, 0)
        IF LOWORD(wParam)=ID_LV1 THEN ListView_Load(1)
        IF LOWORD(wParam)=ID_LV2 THEN ListView_Load(2)
        IF LOWORD(wParam)=ID_LV3 THEN ListView_Load(3)
        IF LOWORD(wParam)=ID_LV4 THEN ListView_Load(4)
        IF LOWORD(wParam)=ID_LV5 THEN ListView_Load(5)
        IF LOWORD(wParam)=ID_LV6 THEN ListView_Load(0)
        IF LOWORD(wParam)=ID_Button1 THEN Create_Click()
        IF LOWORD(wParam)=ID_Button2 THEN SendMessage(hWnd, WM_COMMAND, ID_Exit, 0)
        IF LOWORD(wParam)=ID_H1 THEN
            MessageBox(Form1, "This program was designed for use with CDX. You'll need to have a template and your lists ready. Just select the list you want to generate, and press the Create button.", "Help Topics", MB_OK or MB_ICONQUESTION)
        END IF
        IF LOWORD(wParam)=ID_H2 THEN ShellExecute(0, 0, "http://tks.cjb.net", 0, 0, 0)
        IF LOWORD(wParam)=ID_H3 THEN ShellExecute(0, 0, "http://fly.to/exit.com", 0, 0, 0)
        IF LOWORD(wParam)=ID_H4 THEN ShellExecute(0, 0, "http://www.users.qwest.net/~sdiggins", 0, 0, 0)
        IF LOWORD(wParam)=ID_H5 THEN ShellExecute(0, 0, "http://www.cs.virginia.edu/~lcc-win32", 0, 0, 0)
        IF LOWORD(wParam)=ID_H6 THEN
            MessageBox(Form1, "coded by dl", "About", MB_OK or MB_ICONINFORMATION)
        END IF
' **************************************************************************
    CASE WM_CLOSE
        DestroyWindow (hWnd)
' **************************************************************************
    CASE WM_DESTROY
' **************************************************************************
        PostQuitMessage(0)
        EXIT FUNCTION
' **************************************************************************
    END SELECT

    FUNCTION = DefWindowProc(hWnd,uMsg,wParam,lParam)
END FUNCTION

' ##########################################################################

SUB CenterWindow (hWnd AS HWND)
    DIM wRect AS RECT
    DIM x AS DWORD
    DIM y AS DWORD

    GetWindowRect (hWnd, &wRect)
    x = (GetSystemMetrics ( SM_CXSCREEN)-(wRect.right-wRect.left))/2
    y = (GetSystemMetrics ( SM_CYSCREEN)- _
    (wRect.bottom-wRect.top+GetSystemMetrics(SM_CYCAPTION)))/2
    SetWindowPos (hWnd, NULL,x,y,0,0,SWP_NOSIZE OR SWP_NOZORDER)
END SUB

' ##########################################################################

SUB FormLoad ( hInst as HANDLE )
' **************************************************************************
'               Scale Dialog Units To Screen Units
' **************************************************************************

    BCX_GetDiaUnit = GetDialogBaseUnits()
    BCX_cxBaseUnit = LOWORD(BCX_GetDiaUnit)
    BCX_cyBaseUnit = HIWORD(BCX_GetDiaUnit)
    BCX_ScaleX     = BCX_cxBaseUnit/4
    BCX_ScaleY     = BCX_cyBaseUnit/8

' **************************************************************************

    GLOBAL Form1 AS HANDLE

    Form1 = CreateWindow(ClassName1$,CaptionName1$,DS_MODALFRAME|WS_POPUP|WS_CAPTION|WS_SYSMENU,106*BCX_ScaleX, 48*BCX_ScaleY,(4+ 170)*BCX_ScaleX,(12+ 136)*BCX_ScaleY,NULL,NULL,hInst,NULL)

' **************************************************************************

    GLOBAL  Edit1 AS HANDLE
    CONST   ID_Edit1 = 101
    Edit1 = CreateWindowEx(WS_EX_STATICEDGE,"edit",NULL,WS_CHILD|WS_VISIBLE| WS_DISABLED | NOT WS_TABSTOP, 0*BCX_ScaleX, 0*BCX_ScaleY, 172*BCX_ScaleX, 1*BCX_ScaleY,Form1,ID_Edit1,hInst,NULL)

    SendMessage(Edit1, WM_SETFONT, GetStockObject(DEFAULT_GUI_FONT),MAKELPARAM(FALSE,0))

' **************************************************************************

    GLOBAL  Static1 AS HANDLE
    CONST   ID_Static1 =  102
    Static1 = CreateWindowEx(0,"static","File Category:",WS_CHILD|SS_NOTIFY|SS_LEFT|WS_VISIBLE, 5*BCX_ScaleX, 5*BCX_ScaleY, 50*BCX_ScaleX, 8*BCX_ScaleY,Form1,ID_Static1,hInst,NULL)

    SendMessage(Static1, WM_SETFONT, GetStockObject(DEFAULT_GUI_FONT),MAKELPARAM(FALSE,0))

' **************************************************************************

    GLOBAL  Static2 AS HANDLE
    CONST   ID_Static2 =  103
    Static2 = CreateWindowEx(0,"static","None Selected",WS_CHILD|SS_NOTIFY|SS_RIGHT|WS_VISIBLE, 60*BCX_ScaleX, 5*BCX_ScaleY, 105*BCX_ScaleX, 8*BCX_ScaleY,Form1,ID_Static2,hInst,NULL)

    SendMessage(Static2, WM_SETFONT, GetStockObject(DEFAULT_GUI_FONT),MAKELPARAM(FALSE,0))

' **************************************************************************

    GLOBAL  Static3 AS HANDLE
    CONST   ID_Static3 =  104
    Static3 = CreateWindowEx(0,"static","Number of Files:",WS_CHILD|SS_NOTIFY|SS_LEFT|WS_VISIBLE, 5*BCX_ScaleX, 14*BCX_ScaleY, 50*BCX_ScaleX, 8*BCX_ScaleY,Form1,ID_Static3,hInst,NULL)

    SendMessage(Static3, WM_SETFONT, GetStockObject(DEFAULT_GUI_FONT),MAKELPARAM(FALSE,0))

' **************************************************************************

    GLOBAL  Static4 AS HANDLE
    CONST   ID_Static4 =  105
    Static4 = CreateWindowEx(0,"static","n/a",WS_CHILD|SS_NOTIFY|SS_RIGHT|WS_VISIBLE, 60*BCX_ScaleX, 14*BCX_ScaleY, 105*BCX_ScaleX, 8*BCX_ScaleY,Form1,ID_Static4,hInst,NULL)

    SendMessage(Static4, WM_SETFONT, GetStockObject(DEFAULT_GUI_FONT),MAKELPARAM(FALSE,0))

' **************************************************************************

    GLOBAL  Static5 AS HANDLE
    CONST   ID_Static5 =  106
    Static5 = CreateWindowEx(0,"static","Group Position:",WS_CHILD|SS_NOTIFY|SS_LEFT|WS_VISIBLE, 5*BCX_ScaleX, 23*BCX_ScaleY, 50*BCX_ScaleX, 8*BCX_ScaleY,Form1,ID_Static5,hInst,NULL)

    SendMessage(Static5, WM_SETFONT, GetStockObject(DEFAULT_GUI_FONT),MAKELPARAM(FALSE,0))

' **************************************************************************

    GLOBAL  Static6 AS HANDLE
    CONST   ID_Static6 =  107
    Static6 = CreateWindowEx(0,"static","n/a",WS_CHILD|SS_NOTIFY|SS_RIGHT|WS_VISIBLE, 60*BCX_ScaleX, 22*BCX_ScaleY, 105*BCX_ScaleX, 8*BCX_ScaleY,Form1,ID_Static6,hInst,NULL)

    SendMessage(Static6, WM_SETFONT, GetStockObject(DEFAULT_GUI_FONT),MAKELPARAM(FALSE,0))

' **************************************************************************

    GLOBAL  ListView1 AS HANDLE
    CONST   ID_ListView1 =  108
    ListView1 = CreateWindowEx(WS_EX_CLIENTEDGE, "SysListView32","",WS_CHILD|WS_VISIBLE| WS_TABSTOP|LVS_NOSORTHEADER or LVS_REPORT or LVS_SINGLESEL, 5*BCX_ScaleX, 34*BCX_ScaleY, 160*BCX_ScaleX, 69*BCX_ScaleY,Form1,ID_ListView1,hInst,NULL)
    SendMessage(ListView1, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, LVS_EX_FULLROWSELECT)
    SendMessage(ListView1, WM_SETFONT, GetStockObject(DEFAULT_GUI_FONT),MAKELPARAM(FALSE,0))

' **************************************************************************

    GLOBAL  Edit2 AS HANDLE
    CONST   ID_Edit2 = 109
    Edit2 = CreateWindowEx(WS_EX_STATICEDGE,"edit",NULL,WS_CHILD|WS_VISIBLE| WS_DISABLED | NOT WS_TABSTOP, 5*BCX_ScaleX, 106*BCX_ScaleY, 160*BCX_ScaleX, 1*BCX_ScaleY,Form1,ID_Edit2,hInst,NULL)

    SendMessage(Edit2, WM_SETFONT, GetStockObject(DEFAULT_GUI_FONT),MAKELPARAM(FALSE,0))

' **************************************************************************

    GLOBAL  ComboBox1 AS HANDLE
    CONST   ID_ComboBox1 = 110
    ComboBox1 = CreateWindowEx(WS_EX_CLIENTEDGE,"ComboBox","",WS_CHILD|WS_VISIBLE| CBS_DROPDOWNLIST | CBS_AUTOHSCROLL | CBS_SORT | WS_VSCROLL | WS_TABSTOP, 5*BCX_ScaleX, 110*BCX_ScaleY, 70*BCX_ScaleX, 50*BCX_ScaleY,Form1,ID_ComboBox1,hInst,NULL)

    SendMessage(ComboBox1, WM_SETFONT, GetStockObject(DEFAULT_GUI_FONT),MAKELPARAM(FALSE,0))

' **************************************************************************

    GLOBAL  Button1 AS HANDLE
    CONST   ID_Button1 =  111
    Button1 = CreateWindowEx(0,"button","&Create",WS_CHILD|WS_TABSTOP|BS_PUSHBUTTON|WS_VISIBLE, 80*BCX_ScaleX, 110*BCX_ScaleY, 40*BCX_ScaleX, 13*BCX_ScaleY,Form1,ID_Button1,hInst,NULL)

    SendMessage(Button1, WM_SETFONT, GetStockObject(DEFAULT_GUI_FONT),MAKELPARAM(FALSE,0))

' **************************************************************************

    GLOBAL  Button2 AS HANDLE
    CONST   ID_Button2 =  112
    Button2 = CreateWindowEx(0,"button","E&xit",WS_CHILD|WS_TABSTOP|BS_PUSHBUTTON|WS_VISIBLE, 125*BCX_ScaleX, 110*BCX_ScaleY, 40*BCX_ScaleX, 13*BCX_ScaleY,Form1,ID_Button2,hInst,NULL)

    SendMessage(Button2, WM_SETFONT, GetStockObject(DEFAULT_GUI_FONT),MAKELPARAM(FALSE,0))

' **************************************************************************
'                          Start Building Menus
' **************************************************************************
    MainMenu   =  CreateMenu()   ' CreateMenu returns a MENU HANDLE
    FileMenu   =  CreateMenu()   ' CreateMenu returns a MENU HANDLE
    GroupMenu  =  CreateMenu()   ' CreateMenu returns a MENU HANDLE
    HelpMenu   =  CreateMenu()   ' CreateMenu returns a MENU HANDLE
' **************************************************************************
'                     Build the File Menu First
' **************************************************************************
    AppendMenu(FileMenu,MF_STRING   ,ID_Exit  ,"E&xit")
' **************************************************************************
'                        Build the Main Menu Next
' **************************************************************************
    AppendMenu(GroupMenu,MF_STRING   ,ID_LV1 ,JOIN$(2, "&1 - ", ReadLine$("lview.dat", 41)))
    AppendMenu(GroupMenu,MF_STRING   ,ID_LV2 ,JOIN$(2, "&2 - ", ReadLine$("lview.dat", 42)))
    AppendMenu(GroupMenu,MF_STRING   ,ID_LV3 ,JOIN$(2, "&3 - ", ReadLine$("lview.dat", 43)))
    AppendMenu(GroupMenu,MF_STRING   ,ID_LV4 ,JOIN$(2, "&4 - ", ReadLine$("lview.dat", 44)))
    AppendMenu(GroupMenu,MF_STRING   ,ID_LV5 ,JOIN$(2, "&5 - ", ReadLine$("lview.dat", 45)))
    AppendMenu(GroupMenu, MF_SEPARATOR, 0, "")
    AppendMenu(GroupMenu,MF_STRING   ,ID_LV6, "&Refresh")
    '***********************************************************************
    AppendMenu(HelpMenu, MF_STRING, ID_H1, "&Help Topics")
    AppendMenu(HelpMenu, MF_SEPARATOR, 0, "")
    AppendMenu(HelpMenu, MF_STRING, ID_H2, "&Trunks Online")
    AppendMenu(HelpMenu, MF_STRING, ID_H3, "&www.exit.com")
    AppendMenu(HelpMenu, MF_STRING, ID_H4, "&Free BASIC Translators")
    AppendMenu(HelpMenu, MF_STRING, ID_H5, "&LCC-Win32 Compiler")
    AppendMenu(HelpMenu, MF_SEPARATOR, 0, "")
    AppendMenu(HelpMenu, MF_STRING, ID_H6, "&About")
' **************************************************************************
'                  Attach the File menu to the main menu
' **************************************************************************
    InsertMenu(MainMenu, 0, MF_POPUP, FileMenu, "&File")
    InsertMenu(MainMenu, 1, MF_POPUP, GroupMenu, "&Switch Category")
    InsertMenu(MainMenu, 2, MF_POPUP, HelpMenu, "&Help")
' **************************************************************************
    SetMenu(Form1,MainMenu)              ' Activate the menu
' **************************************************************************

    ' load the 1st list
    SendMessage(Form1, WM_COMMAND, ID_LV1, MainMenu)

    CenterWindow (Form1)   ' Center our Form on the screen
    UpdateWindow (Form1)   ' Force update of all controls
    ShowWindow   (Form1,1) ' Display our creation!

    Form_Load()
END SUB

' ##########################################################################

SUB Form_Load()
    STATIC fBuffer$

    ' list templates
    fBuffer$ = FINDFIRST$("*.tpl")
    WHILE LEN(fBuffer$) > 0
        IF fBuffer$ <> "." AND fBuffer$ <> ".." THEN
            SendMessage(ComboBox1, CB_ADDSTRING, 0, Extract$(fBuffer$, ".tpl"))
        END IF
        fBuffer$ = FINDNEXT$
    WEND
    SendMessage(ComboBox1, CB_SETCURSEL, 0, 0)
    SetFocus(ListView1)
END SUB

' ##########################################################################

FUNCTION MakeTemp$()
    STATIC szPath$
    STATIC szFile$

    GetTempPath(2048, szPath$)
    GetTempFileName(szPath$, "tmh", 0, szFile$)
    FUNCTION = szFile$
END FUNCTION

' ##########################################################################

SUB ReadTemplate(szHTMLTemplate$)
    STATIC fBuffer$
    STATIC iReadHTML
    STATIC iReadHead
    STATIC iReadEven
    STATIC iReadBody
    STATIC iReadOdd

    iReadHead = TRUE
    iReadHTML = FALSE
    iReadEven = FALSE
    iReadBody = FALSE
    iReadOdd = FALSE

    szFNHead$ = MakeTemp$()
    szFNBody$ = MakeTemp$()
    szFNFoot$ = MakeTemp$()
    szFNBodyO$ = MakeTemp$()
    szFNBodyE$ = MakeTemp$()

    OPEN szFNHead$ FOR OUTPUT AS FP_Head
    OPEN szFNBody$ FOR OUTPUT AS FP_Body
    OPEN szFNBodyO$ FOR OUTPUT AS FP_BodyO
    OPEN szFNBodyE$ FOR OUTPUT AS FP_BodyE
    OPEN szFNFoot$ FOR OUTPUT AS FP_Foot
    OPEN szHTMLTemplate$ FOR INPUT AS FP_Template
    WHILE NOT EOF(FP_Template)
        LINE INPUT FP_Template, fBuffer$

        fBuffer$ = TRIM$(fBuffer$)
        IF LEFT$(fBuffer$, 1) = "<" AND LEFT$(fBuffer$, 4) <> "<!--" AND RIGHT$(fBuffer$, 4) <> "--!>" THEN
            iReadHTML = TRUE
        END IF

        ' check for any looping bodies
        IF iReadHTML = TRUE AND LEN(fBuffer$) > 0 THEN
            IF LCASE$(fBuffer$) = "<!-- start of loop even --!>" THEN
                iReadEven = TRUE
                iReadHead = FALSE
            ELSEIF LCASE$(fBuffer$) = "<!-- end of loop even --!>" THEN
                iReadEven = FALSE
            ELSEIF LCASE$(fBuffer$) = "<!-- start of loop odd --!>" THEN
                iReadOdd = TRUE
                iReadHead = FALSE
            ELSEIF LCASE$(fBuffer$) = "<!-- end of loop odd --!>" THEN
                iReadOdd = FALSE
            ELSEIF LCASE$(fBuffer$) = "<!-- start of loop --!>" THEN
                iReadBody = TRUE
                iReadHead = FALSE
            ELSEIF LCASE$(fBuffer$) = "<!-- end of loop --!>" THEN
                iReadBody = FALSE
            END IF
        END IF

        ' remove comments
        IF RIGHT$(fBuffer$, 4) = "--!>" AND LEFT$(fBuffer$, 4) = "<!--" THEN
            fBuffer$ = ""
        END IF

        ' start creating head, body, and foot
        IF iReadHTML = TRUE AND LEN(fBuffer$) > 0 THEN
            IF iReadHead = TRUE THEN
                FPRINT FP_Head, fBuffer$
            ELSEIF iReadEven = TRUE THEN
                FPRINT FP_BodyE, fBuffer$
            ELSEIF iReadOdd = TRUE THEN
                FPRINT FP_BodyO, fBuffer$
            ELSEIF iReadBody = TRUE THEN
                FPRINT FP_Body, fBuffer$
            ELSEIF iReadHead = FALSE AND iReadEven = FALSE AND iReadOdd = FALSE AND iReadBody = FALSE THEN
                FPRINT FP_Foot, fBuffer$
            END IF
        END IF
    WEND
    CLOSE FP_Template
    CLOSE FP_Head
    CLOSE FP_Body
    CLOSE FP_BodyO
    CLOSE FP_BodyE
    CLOSE FP_Foot
END SUB

' ##########################################################################

FUNCTION TimeF$(szInFormat$)
    STATIC elapse_time AS LONG
    ! static struct tm *tp;

    time(&elapse_time)
    tp=localtime(&elapse_time)
    strftime(StrFunc[StrCnt],256,szInFormat,tp)
    FUNCTION = StrFunc[StrCnt]
END FUNCTION

' ##########################################################################

 ' FUNCTION CountLines(szFile$)
 '     STATIC fBuffer$
 '     STATIC iLines
 ' 
 '     iLines = 0
 '     OPEN szFile$ FOR INPUT AS FP_CountLines
 '     WHILE NOT EOF(FP_CountLines)
 '         LINE INPUT FP_CountLines, fBuffer$
 ' 
 '         ' check for null, if none, then add 1
 '         IF parse$(fBuffer$, "€", 7) <> CHR$(0) THEN
 '             INCR iLines
 '         END IF
 '     WEND
 '     CLOSE FP_CountLines
 ' 
 '     FUNCTION = iLines
 ' END FUNCT

' ##########################################################################

FUNCTION parse$(szLine$, szDel$, iWord)
    STATIC pLine$
    STATIC tLine$
    STATIC iPos
    STATIC iCur

    tLine$ = szLine$
    iPos = 1
    iCur = 0
    WHILE iPos > 0
        iPos = INSTR(tLine$, szDel$)
        pLine$ = MID$(tLine$, LEN(szDel$), iPos - 1)
        IF iCur = iWord THEN
            FUNCTION = pLine$
        ELSE
            tLine$ = MID$(tLine$, iPos + LEN(szDel$), LEN(tLine$))
            INCR iCur
        END IF
    WEND

    FUNCTION = CHR$(0)
END FUNCTION

' ##########################################################################

FUNCTION ReadLine$(szFile$, iLine)
    STATIC fBuffer$
    STATIC iCount
    STATIC iFound

    iCount = 0
    iFound = TRUE
    OPEN szFile$ FOR INPUT AS FP_ReadLine
    WHILE NOT EOF(FP_ReadLine)
        INCR iCount

        LINE INPUT FP_ReadLine, fBuffer$
        IF iCount = iLine THEN
            iFound = TRUE
            GOTO Close_ReadLine
        END IF
    WEND
    Close_ReadLine:
    CLOSE FP_ReadLine

    IF iFound = TRUE THEN
        FUNCTION = fBuffer$
    ELSE
        FUNCTION = ""
    END IF
END FUNCTION

' ##########################################################################

SUB ListView_AddColumn(iHowMany, hList AS HANDLE)
    STATIC lvc AS LV_COLUMN
    STATIC iCount

    FOR iCount = 1 TO iHowMany
        lvc.mask     = LVCF_TEXT or LVCF_WIDTH
        lvc.cx       = 50
        lvc.iSubItem = iCount
        lvc.pszText  = szColumns$[iHowMany - iCount]
        SendMessage(hList, LVM_INSERTCOLUMN, 0, &lvc)
    NEXT
END SUB

' ##########################################################################

SUB ListView_AddItems(iRow, hList AS HANDLE)
    STATIC lvi AS LV_ITEM
    STATIC iCount

    ' add 1st item
    lvi.mask     = LVIF_TEXT or LVIF_PARAM
    lvi.iItem    = iRow
    lvi.iSubItem = 0
    lvi.pszText  = szItems$[0]
    SendMessage(hList, LVM_INSERTITEM, 0, &lvi)

    ' add items remaining items
    FOR iCount = 1 TO 7
        lvi.mask     = LVIF_TEXT
        lvi.pszText  = szItems$[iCount]
        lvi.iSubItem = iCount
        SendMessage(hList, LVM_SETITEM, 0, &lvi)
    NEXT
END SUB

' ##########################################################################

SUB ListView_Load(iList)
    STATIC fBuffer$
    STATIC x
    STATIC y

    FOR x = 0 TO 4
        ' re-enable all menus
        EnableMenuItem(GroupMenu, 2000 + (x + 1), MF_ENABLED)

        ' disable menus for non-existing files
        IF LOF(JOIN$(3, "l", TRIM$(STR$(x)), ".txt")) <= 0 THEN
            EnableMenuItem(GroupMenu, 2000 + (x + 1), MF_GRAYED)
        END IF

        ' uncheck all items
        CheckMenuItem(GroupMenu, 2000 + (x + 1), MF_BYCOMMAND or MF_UNCHECKED)
    NEXT

    ' clear listview
    SendMessage(ListView1, LVM_DELETEALLITEMS, 0, 0)
    FOR x = 0 TO 7
        SendMessage(ListView1, LVM_DELETECOLUMN, 0, x)
    NEXT

    ' start processing listview
    IF iList = 0 THEN
        ' our refresh command
        IF ID_LSEL <> 0 THEN
            ListView_Load(ID_LSEL)
        ELSE
            SendMessage(Static2, WM_SETTEXT, 0, "None Selected")
            SendMessage(Static4, WM_SETTEXT, 0, "n/a")
            SendMessage(Static6, WM_SETTEXT, 0, "n/a")
        END IF
    ELSE
        ' check if our file is even valid
        IF LOF(JOIN$(3, "l", TRIM$(STR$(iList - 1)), ".txt")) > 1 THEN
            ' check selected listview
            CheckMenuItem(GroupMenu, 2000 + iList, MF_BYCOMMAND or MF_CHECKED)

            ' load all column names
            y = 0
            FOR x = (8 * iList) - 7 TO (8 * iList)
                szColumns$[y] = ReadLine$("lview.dat", x)
                INCR y
            NEXT
            ListView_AddColumn(8, ListView1)

            ' load all list items
            x = 0
            OPEN JOIN$(3, "l", TRIM$(STR$(iList - 1)), ".txt") FOR INPUT AS FP_LoadList
            WHILE NOT EOF(FP_LoadList)
                LINE INPUT FP_LoadList, fBuffer$
                FOR y = 0 TO 7
                    szItems$[y] = parse$(fBuffer$, "€", y)
                NEXT
                ListView_AddItems(x, ListView1)
                INCR x
            WEND
            CLOSE FP_LoadList

            ' update status statics
            SendMessage(Static2, WM_SETTEXT, 0, ReadLine$("lview.dat", 40 + iList))
            SendMessage(Static4, WM_SETTEXT, 0, STR$(SendMessage(ListView1, LVM_GETITEMCOUNT, 0, 0)))
            SendMessage(Static6, WM_SETTEXT, 0, STR$(iList))
        ELSE
            ' none selected, update statics
            SendMessage(Static2, WM_SETTEXT, 0, "None Selected")
            SendMessage(Static4, WM_SETTEXT, 0, "n/a")
            SendMessage(Static6, WM_SETTEXT, 0, "n/a")
        END IF
    END IF

    ' make sure not to save refresh
    IF iList <> 0 THEN ID_LSEL = iList
END SUB

' ##########################################################################

FUNCTION ReadContents$(szFile$)
    STATIC fReturn$ * 65535
    STATIC fBuffer$

    fReturn$ = ""
    OPEN szFile$ FOR INPUT AS FP_ReadContents
    WHILE NOT EOF(FP_ReadContents)
        LINE INPUT FP_ReadContents, fBuffer$
        fReturn$ = fReturn$ & fBuffer$
    WEND
    CLOSE FP_ReadContents

    FUNCTION = fReturn$
END FUNCTION

' ##########################################################################

FUNCTION TrimAll$(szInString$)
    STATIC tBuffer$
    STATIC cBuffer$

 '     tBuffer$ = ""
 '     cBuffer$ = ""
 ' 
    cBuffer$ = CHR$(9)
    tBuffer$ = REPLACE$(szInString$, cBuffer$, "")

    FUNCTION = TRIM$(tBuffer$)
END FUNCTION

' ##########################################################################

FUNCTION countVariables(szInFile$, szDelimiter$, intCount)
    STATIC fBuffer$
    STATIC tBuffer$
    STATIC lBuffer$
    STATIC rBuffer$
    STATIC sPosition
    STATIC nFound

    nFound = 0
 '     sPosition = 0
 '     fBuffer$ = ""
 '     tBuffer$ = ""
 '     lBuffer$ = ""
 '     rBuffer$ = ""
 ' 
    OPEN szInFile$ FOR INPUT AS Fp3
    WHILE NOT EOF(Fp3)
        LINE INPUT Fp3, fBuffer$
        tBuffer$ = TRIM$(fBuffer$)
        IF LEFT$(tBuffer$, 1) = szDelimiter$ THEN
            sPosition = INSTR(tBuffer$, "#")
            IF sPosition > 0 THEN
                lBuffer$ = LEFT$(tBuffer$, sPosition - 1)
                lBuffer$ = RIGHT$(lBuffer$, LEN(lBuffer$) - 1)
                lBuffer$ = TrimAll$(lBuffer$)
                rBuffer$ = RIGHT$(tBuffer$, LEN(tBuffer$) - sPosition)
                rBuffer$ = LEFT$(rBuffer$, LEN(rBuffer$))
                IF Len(lBuffer$) > 0 AND LEN(rBuffer$) > 0 THEN
                    szCurrentL$ = lBuffer$
                    szCurrentR$ = rBuffer$
                    INCR nFound
                END IF
                IF intCount > 0 AND intCount = nFound THEN
                    GOTO CloseFp3
                END IF
            END IF
        END IF
    WEND
    CloseFp3:
    CLOSE Fp3

    FUNCTION = nFound
END FUNCTION

' ##########################################################################

SUB Create_Click()
    STATIC fBuffer$
    STATIC iIndex 

    iIndex = SendMessage(ComboBox1, CB_GETCURSEL, 0, 0)
    IF iIndex <> CB_ERR AND ID_LSEL <> 0 THEN
        SendMessage(ComboBox1, CB_GETLBTEXT, iIndex, fBuffer$)
        fBuffer$ = fBuffer$ & ".tpl"
        IF LOF(fBuffer$) > 0 THEN
            ReadTemplate(fBuffer$)
            Generate_HTML(fBuffer$)
            KILL szFNHead$
            KILL szFNBody$
            KILL szFNFoot$
            KILL szFNBodyO$
            KILL szFNBodyE$
            MessageBox(Form1, "Your file has been created!", "Work Complete", MB_OK)
        END IF
    END IF
END SUB

' ##########################################################################

SUB Generate_HTML(szHTMLTemplate$)
    STATIC iVarCount
    STATIC iCount
    STATIC iNull
    STATIC iCurrent
    STATIC lvi AS LV_ITEM
    STATIC szHead$   * 65535
    STATIC szBody$   * 65535
    STATIC szBodyO$  * 65535
    STATIC szBodyE$  * 65535
    STATIC szTBody$  * 65535
    STATIC szTBodyO$ * 65535
    STATIC szTBodyE$ * 65535
    STATIC szFoot$   * 65535
    STATIC szNoItems$
    STATIC szTemp$

    szHead$ = ReadContents$(szFNHead$)
    szBody$ = ReadContents$(szFNBody$)
    szBodyO$ = ReadContents$(szFNBodyO$)
    szBodyE$ = ReadContents$(szFNBodyE$)
    szFoot$ = ReadContents$(szFNFoot$)

    ' read & replace custom variables
    iVarCount = countVariables(szHTMLTemplate$, "!", 0)
    FOR iCount = 1 to iVarCount
        iNull = countVariables(szHTMLTemplate$, "!", iCount)
        szHead$ = REPLACE$(szHead$, JOIN$(3, "!", szCurrentL$, "!"), szCurrentR$)
        IF LEN(szBody$) > 0 OR LEN(szBodyO$) > 0 OR LEN(szBodyO$) > 0 THEN
            IF LEN(szBody$) > 0 THEN
                szBody$ = REPLACE$(szBody$, JOIN$(3, "!", szCurrentL$, "!"), szCurrentR$)
            ELSE
                szBodyO$ = REPLACE$(szBodyO$, JOIN$(3, "!", szCurrentL$, "!"), szCurrentR$)
                szBodyE$ = REPLACE$(szBodyE$, JOIN$(3, "!", szCurrentL$, "!"), szCurrentR$)
            END IF
            szFoot$ = REPLACE$(szFoot$, JOIN$(3, "!", szCurrentL$, "!"), szCurrentR$)
        END IF
    NEXT

    ' grab all pre-defined variables
    iVarCount = countVariables(szHTMLTemplate$, "$", 0)
    FOR iCount = 1 TO iVarCount 
        iNull = countVariables(szHTMLTemplate$, "$", iCount)
        SELECT CASE LCASE$(szCurrentR$)
        CASE "gt"   : GetWindowText(Static2, szTemp$, 2048) : szCurrentR$ = szTemp$
        CASE "gp"   : GetWindowText(Static6, szTemp$, 2048) : szCurrentR$ = szTemp$
        CASE "gi"   : GetWindowText(Static4, szTemp$, 2048) : szCurrentR$ = szTemp$
        CASE "f1"
        FileReplace:
            szCurrentR$ = TRIM$(parse$(szCurrentL$, "^", 1))
            IF LOF(szCurrentR$) > 1 THEN
                szCurrentR$ = ReadContents$(szCurrentR$)
            END IF
            szCurrentL$ = parse$(szCurrentL$, "^", 0)
        CASE "f2"   : GOTO FileReplace
        CASE "f3"   : GOTO FileReplace
        CASE "f4"   : GOTO FileReplace
        CASE "f5"   : GOTO FileReplace
        CASE "ct24"
        DateReplace:
            szCurrentR$ = TRIM$(parse$(szCurrentL$, "^", 1))
            szCurrentR$ = TimeF$(szCurrentR$)
            szCurrentL$ = parse$(szCurrentL$, "^", 0)
        CASE "ct12" : GOTO DateReplace
        CASE "cdl"  : GOTO DateReplace
        CASE "cds"  : GOTO DateReplace
        CASE "pn"   : szCurrentR$ = "toulmth"
        CASE "pv"   : szCurrentR$ = "1.0 build 2988"
        CASE "lt1"  : szCurrentR$ = szColumns$[0]
        CASE "lt2"  : szCurrentR$ = szColumns$[1]
        CASE "lt3"  : szCurrentR$ = szColumns$[2]
        CASE "lt4"  : szCurrentR$ = szColumns$[3]
        CASE "lt5"  : szCurrentR$ = szColumns$[4]
        CASE "lt6"  : szCurrentR$ = szColumns$[5]
        CASE "lt7"  : szCurrentR$ = szColumns$[6]
        CASE "lt8"  : szCurrentR$ = szColumns$[7]
        END SELECT

        SELECT CASE LCASE$(szCurrentR$)
        CASE "ci"  : szNoItems$  = szCurrentL$
        CASE "lc1" : szColContentL$[0] = szCurrentL$
        CASE "lc2" : szColContentL$[1] = szCurrentL$
        CASE "lc3" : szColContentL$[2] = szCurrentL$
        CASE "lc4" : szColContentL$[3] = szCurrentL$
        CASE "lc5" : szColContentL$[4] = szCurrentL$
        CASE "lc6" : szColContentL$[5] = szCurrentL$
        CASE "lc7" : szColContentL$[6] = szCurrentL$
        CASE "lc8" : szColContentL$[7] = szCurrentL$
        CASE ELSE
            szHead$  = REPLACE$(szHead$, JOIN$(3, "$", szCurrentL$, "$"), szCurrentR$)
            IF LEN(szBody$) > 0 OR LEN(szBodyO$) > 0 OR LEN(szBodyO$) > 0 THEN
                IF LEN(szBody$) > 0 THEN
                    szBody$ = REPLACE$(szBody$, JOIN$(3, "$", szCurrentL$, "$"), szCurrentR$)
                ELSE
                    szBodyO$ = REPLACE$(szBodyO$, JOIN$(3, "$", szCurrentL$, "$"), szCurrentR$)
                    szBodyE$ = REPLACE$(szBodyE$, JOIN$(3, "$", szCurrentL$, "$"), szCurrentR$)
                END IF
                szFoot$ = REPLACE$(szFoot$, JOIN$(3, "$", szCurrentL$, "$"), szCurrentR$)
            END IF
        END SELECT
    NEXT

    ' replace all of the bodies with items
    OPEN JOIN$(3, "l", TRIM$(STR$(ID_LSEL - 1)), ".html") FOR OUTPUT AS FP_OutHTML
    FPRINT FP_OutHTML, szHead$;
    IF LEN(szBody$) > 0 OR LEN(szBodyO$) > 0 OR LEN(szBodyO$) > 0 THEN
        iCount = SendMessage(ListView1, LVM_GETITEMCOUNT, 0, 0)
        FOR iCurrent = 0 to iCount - 1
            szTBody$  = szBody$
            szTBodyO$ = szBodyO$
            szTBodyE$ = szBodyE$

            ' replace current items
            szCurrentL$ = Trim$(Str$(iCurrent + 1))
            IF LEN(szBody$) > 0 THEN
                szTBody$ = REPLACE$(szBody$, JOIN$(3, "$", szNoItems$, "$"), szCurrentL$)
            ELSE
                IF MOD(iCurrent + 1, 2) = 0 THEN
                    szTBodyE$ = REPLACE$(szBodyE$, JOIN$(3, "$", szNoItems$, "$"), szCurrentL$)
                ELSE
                    szTBodyO$ = REPLACE$(szBodyO$, JOIN$(3, "$", szNoItems$, "$"), szCurrentL$)
                END IF
            END IF

            FOR iNull = 0 TO 7
                lvi.mask     = LVIF_TEXT or LVIF_PARAM
                lvi.iItem    = iCurrent
                lvi.iSubItem = iNull 
                lvi.pszText  = szColContentR$[iNull]
                lvi.cchTextMax = 2048
                SendMessage(ListView1, LVM_GETITEM, 0, &lvi)
                IF LEN(szBody$) > 0 THEN
                    szTBody$ = REPLACE$(szTBody$, JOIN$(3, "$", szColContentL$[iNull], "$"), szColContentR$[iNull])
                ELSE
                    IF MOD(iCurrent + 1, 2) = 0 THEN
                        szTBodyE$ = REPLACE$(szTBodyE$, JOIN$(3, "$", szColContentL$[iNull], "$"), szColContentR$[iNull])
                    ELSE
                        szTBodyO$ = REPLACE$(szTBodyO$, JOIN$(3, "$", szColContentL$[iNull], "$"), szColContentR$[iNull])
                    END IF
                END IF
            NEXT

            ' print replacement bodies
            IF LEN(szBody$) > 0 THEN
                FPRINT FP_OutHTML, szTBody$;
            ELSE
                IF MOD(iCurrent + 1, 2) = 0 THEN
                    FPRINT FP_OutHTML, szTBodyE$;
                ELSE
                    FPRINT FP_OutHTML, szTBodyO$;
                END IF
            END IF
        NEXT
        FPRINT FP_OutHTML, szFoot$;
    END IF
    CLOSE FP_OutHTML

    FREE szHead$
    FREE szBody$
    FREE szBodyO$
    FREE szBodyE$
    FREE szFoot$
    FREE szTBody$
    FREE szTBodyO$
    FREE szTBodyE$
END SUB

' ##########################################################################
