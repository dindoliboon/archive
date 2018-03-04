' **************************************************************************
'            BCX Source Code Generated Using Dialog Starter 1.0
'                 For Use With BCX Translator Version 2.15+
' **************************************************************************

    ' Global Constants (Dialog/Control IDs)
    CONST IDD_FORM1 = 100
    CONST IDC_LISTVIEW1 = 101
    CONST IDC_STATIC1 = 102
    CONST IDC_STATIC2 = 103
    CONST IDC_EDIT1 = 104
    CONST IDC_STATIC3 = 105
    CONST IDC_EDIT2 = 106
    CONST IDC_STATIC4 = 107
    CONST IDC_EDIT3 = 108
    CONST IDC_STATIC5 = 109
    CONST IDC_EDIT4 = 110
    CONST IDC_STATIC6 = 111
    CONST IDC_EDIT5 = 112
    CONST MAXTEXT_SIZE  = 32768
    CONST CB_INT        = INTEGER CALLBACK

    ' Global Variables (Dialog/Control Handles)
    GLOBAL hInstance AS HINSTANCE
    GLOBAL Form1 AS HWND
    GLOBAL ListView1 AS HWND
    GLOBAL Static1 AS HWND
    GLOBAL Static2 AS HWND
    GLOBAL Edit1 AS HWND
    GLOBAL Static3 AS HWND
    GLOBAL Edit2 AS HWND
    GLOBAL Static4 AS HWND
    GLOBAL Edit3 AS HWND
    GLOBAL Static5 AS HWND
    GLOBAL Edit4 AS HWND
    GLOBAL Static6 AS HWND
    GLOBAL Edit5 AS HWND
    GLOBAL szColumns$[5]
    GLOBAL szItems$[5]
    GLOBAL SortOrder

    ' Global Proc Variables
    GLOBAL lpListView1_Proc AS FARPROC
    GLOBAL lpStatic1_Proc AS FARPROC
    GLOBAL lpStatic2_Proc AS FARPROC
    GLOBAL lpEdit1_Proc AS FARPROC
    GLOBAL lpStatic3_Proc AS FARPROC
    GLOBAL lpEdit2_Proc AS FARPROC
    GLOBAL lpStatic4_Proc AS FARPROC
    GLOBAL lpEdit3_Proc AS FARPROC
    GLOBAL lpStatic5_Proc AS FARPROC
    GLOBAL lpEdit4_Proc AS FARPROC
    GLOBAL lpStatic6_Proc AS FARPROC
    GLOBAL lpEdit5_Proc AS FARPROC

TYPE ONEBYTE
    ! unsigned int b0:1;
    ! unsigned int b1:1;
    ! unsigned int b2:1;
    ! unsigned int b3:1;
    ! unsigned int b4:1;
    ! unsigned int b5:1;
    ! unsigned int b6:1;
    ! unsigned int b7:1;
END TYPE


FUNCTION WinMain()
    ' Gives global access to hInstance
    hInstance = hInst

    ' Intialize extra controls
    InitCommonControls()

    ' Intialize our dialog, pointing it to the dialog procedure
    DialogBox(hInst, MAKEINTRESOURCE(IDD_FORM1), NULL, (DLGPROC) Form1_Proc)

    FUNCTION = FALSE
END FUNCTION


CALLBACK FUNCTION Form1_Proc()
    SELECT CASE Msg
' **************************************************************************
    CASE WM_INITDIALOG
' **************************************************************************
        ' Retrieves the dialog/control handles
        Form1 = hWnd
        ListView1 = GetDlgItem(hWnd, IDC_LISTVIEW1)
        Static1 = GetDlgItem(hWnd, IDC_STATIC1)
        Static2 = GetDlgItem(hWnd, IDC_STATIC2)
        Edit1 = GetDlgItem(hWnd, IDC_EDIT1)
        Static3 = GetDlgItem(hWnd, IDC_STATIC3)
        Edit2 = GetDlgItem(hWnd, IDC_EDIT2)
        Static4 = GetDlgItem(hWnd, IDC_STATIC4)
        Edit3 = GetDlgItem(hWnd, IDC_EDIT3)
        Static5 = GetDlgItem(hWnd, IDC_STATIC5)
        Edit4 = GetDlgItem(hWnd, IDC_EDIT4)
        Static6 = GetDlgItem(hWnd, IDC_STATIC6)
        Edit5 = GetDlgItem(hWnd, IDC_EDIT5)

        ' Give controls seperate proc functions
        lpListView1_Proc = SubclassWindow(ListView1, ListView1_Proc)
        lpStatic1_Proc = SubclassWindow(Static1, Static1_Proc)

        lpStatic2_Proc = SubclassWindow(Static2, Static2_Proc)
                         SubclassWindow(Static3, Static2_Proc)
                         SubclassWindow(Static4, Static2_Proc)
                         SubclassWindow(Static5, Static2_Proc)
                         SubclassWindow(Static6, Static2_Proc)

        lpEdit1_Proc = SubclassWindow(Edit1, Edit1_Proc)
                       SubclassWindow(Edit2, Edit1_Proc)
                       SubclassWindow(Edit3, Edit1_Proc)
                       SubclassWindow(Edit4, Edit1_Proc)
                       SubclassWindow(Edit5, Edit1_Proc)

        ' Set other window properties
        CenterWindow(hWnd)

        SendMessage(ListView1, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, LVS_EX_FULLROWSELECT or LVS_EX_GRIDLINES)
        SetWindowLong(ListView1, GWL_EXSTYLE, WS_EX_CLIENTEDGE)

        szColumns$[0] = "Service"
        szColumns$[1] = "Website"
        szColumns$[2] = "User Name"
        szColumns$[3] = "Password"
        szColumns$[4] = "Comments"

        ListView_AddColumn(5)
        ListView_SetColumnWidth(ListView1, 1, 70)
        ListView_SetColumnWidth(ListView1, 2, 70)
        ListView_SetColumnWidth(ListView1, 3, 0)
        ListView_SetColumnWidth(ListView1, 4, 70)

        ListView_LoadData()
        ListView_SetSelectionMark(ListView1, 0)
        ListView_GetCurrentSel()

' **************************************************************************
    CASE WM_NOTIFY
' **************************************************************************
        DIM plParam AS LPNMHDR
        DIM lvParam AS LPNM_LISTVIEW
        DIM iTmp

        plParam = (LPNMHDR)lParam
        IF plParam->idFrom = IDC_LISTVIEW1 THEN
            IF plParam->code = NM_CLICK OR plParam->code = NM_RCLICK THEN
                ListView_GetCurrentSel()
            ELSEIF plParam->code = NM_DBLCLK THEN
                iTmp = ListView_GetSelectionMark(ListView1)

                IF iTmp <> -1 THEN
                    ListView_DeleteItem(ListView1, iTmp)
                    ListView_GetCurrentSel()
                END IF
            ELSEIF plParam->code = NM_RDBLCLK THEN
                szItems$[0] = "new item"
                szItems$[1] = ""
                szItems$[2] = ""
                szItems$[3] = ""
                szItems$[4] = ""
                ListView_AddItems()
            ELSEIF plParam->code = LVN_COLUMNCLICK THEN
                lvParam = (LPNM_LISTVIEW)lParam
                IF lvParam->iSubItem = 4 THEN
                    IF SortOrder = 0 OR SortOrder = 10 THEN
                        SortOrder = 9
                    ELSE
                        SortOrder = 10
                    END IF
                ELSEIF lvParam->iSubItem = 3 THEN
                    IF SortOrder = 0 OR SortOrder = 8 THEN
                        SortOrder = 7
                    ELSE
                        SortOrder = 8
                    END IF
                ELSEIF lvParam->iSubItem = 2 THEN
                    IF SortOrder = 0 OR SortOrder = 6 THEN
                        SortOrder = 5
                    ELSE
                        SortOrder = 6
                    END IF
                ELSEIF lvParam->iSubItem = 1 THEN
                    IF SortOrder = 0 OR SortOrder = 4 THEN
                        SortOrder = 3
                    ELSE
                        SortOrder = 4
                    END IF
                ELSE
                    IF SortOrder = 0 OR SortOrder = 2 THEN
                        SortOrder = 1
                    ELSE
                        SortOrder = 2
                    END IF
                END IF

                SendMessage(ListView1, LVM_SORTITEMS, SortOrder, CompareFunc)
                UpdatelParam()
                ListView_GetCurrentSel()
           END IF
        END IF

' **************************************************************************
    CASE WM_CLOSE
' **************************************************************************
        ListView_WriteData()

        ' Free our dialog
        EndDialog(hWnd, TRUE)

' **************************************************************************
    CASE ELSE
' **************************************************************************
        ' No messages processed, return false
        FUNCTION = FALSE
    END SELECT

    ' If we reach this point, that means a message was processed
    ' and we send a true value
    FUNCTION = TRUE
END FUNCTION


CALLBACK FUNCTION ListView1_Proc()
DIM iTmp

    SELECT CASE Msg
' **************************************************************************
    CASE WM_KEYUP
' **************************************************************************
        SELECT CASE wParam
        CASE VK_INSERT
            szItems$[0] = "new item"
            szItems$[1] = ""
            szItems$[2] = ""
            szItems$[3] = ""
            szItems$[4] = ""
            ListView_AddItems()
        CASE VK_DELETE
            iTmp = ListView_GetSelectionMark(ListView1)

            IF iTmp <> -1 THEN
                ListView_DeleteItem(ListView1, iTmp)
                ListView_GetCurrentSel()
            END IF
        END SELECT

        ListView_GetCurrentSel()

' **************************************************************************
    CASE ELSE
' **************************************************************************
        ' No messages have been processed
        FUNCTION = CallWindowProc(lpListView1_Proc, hWnd, Msg, wParam, lParam)
    END SELECT

    ' Default message has been processed
    FUNCTION = TRUE
END FUNCTION


CALLBACK FUNCTION Static1_Proc()
    SELECT CASE Msg
' **************************************************************************
    CASE WM_LBUTTONDBLCLK
' **************************************************************************
        FlashWindow(hWnd, TRUE)

' **************************************************************************
    CASE ELSE
' **************************************************************************
        ' No messages have been processed
        FUNCTION = CallWindowProc(lpStatic1_Proc, hWnd, Msg, wParam, lParam)
    END SELECT

    ' Default message has been processed
    FUNCTION = TRUE
END FUNCTION


CALLBACK FUNCTION Static2_Proc()
    DIM hMemory AS HGLOBAL
    DIM pMemory AS LPVOID

    SELECT CASE Msg
' **************************************************************************
    CASE WM_LBUTTONDBLCLK
' **************************************************************************
        OpenClipboard(NULL)
        EmptyClipboard()

        hMemory = GlobalAlloc(GMEM_MOVEABLE, MAXTEXT_SIZE + 1)
        pMemory = GlobalLock(hMemory)
        GetWindowText(GetDlgItem(Form1, GetDlgCtrlID(hWnd) + 1), pMemory$, MAXTEXT_SIZE)

        SetClipboardData(CF_TEXT, hMemory)
        CloseClipboard()

        GlobalUnlock(hMemory)
        GlobalFree(hMemory)

' **************************************************************************
    CASE ELSE
' **************************************************************************
        ' No messages have been processed
        FUNCTION = CallWindowProc(lpStatic2_Proc, hWnd, Msg, wParam, lParam)
    END SELECT

    ' Default message has been processed
    FUNCTION = TRUE
END FUNCTION


CALLBACK FUNCTION Edit1_Proc()
    SELECT CASE Msg
' **************************************************************************
    CASE WM_KEYUP
' **************************************************************************
        ListView_UpdateItem()
        FUNCTION = CallWindowProc(lpEdit1_Proc, hWnd, Msg, wParam, lParam)

' **************************************************************************
    CASE ELSE
' **************************************************************************
        ' No messages have been processed
        FUNCTION = CallWindowProc(lpEdit1_Proc, hWnd, Msg, wParam, lParam)
    END SELECT

    ' Default message has been processed
    FUNCTION = TRUE
END FUNCTION


SUB CenterWindow(hWnd AS HWND)
    STATIC wRect AS RECT
    STATIC x     AS DWORD
    STATIC y     AS DWORD

    GetWindowRect(hWnd, &wRect)
    x = (GetSystemMetrics(SM_CXSCREEN) - (wRect.right - wRect.left)) / 2
    y = (GetSystemMetrics(SM_CYSCREEN) - (wRect.bottom - wRect.top + _
        GetSystemMetrics(SM_CYCAPTION))) / 2
    SetWindowPos(hWnd, NULL, x, y, 0, 0, SWP_NOSIZE OR SWP_NOZORDER)
END SUB


SUB ListView_AddColumn(iHowMany)
    DIM lvc AS LV_COLUMN
    DIM iCount

    lvc.mask = LVCF_TEXT or LVCF_WIDTH
    lvc.cx   = 219

    FOR iCount = 1 TO iHowMany
        lvc.pszText = szColumns$[iCount - 1]
        SendMessage(ListView1, LVM_INSERTCOLUMN, iCount - 1, &lvc)
    NEXT
END SUB


SUB ListView_UpdateItem()
    DIM lvi AS LV_ITEM
    DIM iCount

    lvi.mask   = LVIF_TEXT or LVIF_PARAM
    lvi.iItem  = ListView_GetSelectionMark(ListView1)
    lvi.lParam = lvi.iItem

    IF lvi.iItem = -1 THEN EXIT SUB

    FOR iCount = 0 TO 4
        IF iCount > 0 THEN
            lvi.mask   = LVIF_TEXT
        END IF

        lvi.iSubItem = iCount
        GetWindowText(GetDlgItem(Form1, IDC_EDIT1 + (iCount * 2)), szItems$[iCount], MAXTEXT_SIZE)
        lvi.pszText = szItems$[iCount]
        SendMessage(ListView1, LVM_SETITEM, 0, &lvi)
    NEXT
END SUB


SUB ListView_AddItems()
    DIM lvi AS LV_ITEM
    DIM iCount

    lvi.mask   = LVIF_TEXT or LVIF_PARAM
    IF ListView_GetSelectionMark(ListView1) > -1 THEN
        lvi.iItem = ListView_GetSelectionMark(ListView1)
    ELSE
        lvi.iItem = ListView_GetItemCount(ListView1)
    END IF
    lvi.lParam = lvi.iItem

    FOR iCount = 0 TO 4
        IF iCount > 0 THEN
            lvi.mask   = LVIF_TEXT
        END IF

        lvi.iSubItem = iCount
        lvi.pszText  = szItems$[iCount]

        IF iCount = 0 THEN
            SendMessage(ListView1, LVM_INSERTITEM, 0, &lvi)
        ELSE
            SendMessage(ListView1, LVM_SETITEM, 0, &lvi)
        END IF
    NEXT
END SUB


SUB ListView_GetCurrentSel()
    DIM lvi AS LV_ITEM
    DIM iCount

    lvi.mask       = LVIF_TEXT
    lvi.iItem      = ListView_GetSelectionMark(ListView1)
    lvi.cchTextMax = MAXTEXT_SIZE

    FOR iCount = 0 TO 4
        lvi.iSubItem = iCount

        lvi.pszText = szItems$[iCount]
        ListView_GetItem(ListView1, &lvi)
        SetWindowText(GetDlgItem(Form1, IDC_EDIT1 + (iCount * 2)), szItems$[iCount])
    NEXT
END SUB


SUB ListView_LoadData()
    DIM iNext, iCnt, szBufr$
    DIM iTmp AS WORD
    DIM ob AS ONEBYTE
    DIM lvc AS LV_COLUMN
    DIM lngStyle AS LONG

    IF EXIST("pw.dat") <> -1 THEN EXIT SUB

    iNext = 0
    OPEN "pw.dat" FOR BINARY AS FP1

    GET$ FP1, 3, szBufr$
    IF LCASE$(szBufr$) <> "mpv" THEN GOTO CLEANUP

    ' get major version
    GET$ FP1, sizeof(iTmp), &iTmp
    IF LOWORD(iTmp) <> 1 THEN GOTO CLEANUP

    FOR iCnt = 0 TO 4
        GET$ FP1, sizeof(iNext), &iNext

        ListView_SetColumnWidth(ListView1, iCnt, iNext)
    NEXT

    ' get header/enc/pw
    GET$ FP1, 1, &ob

$comment

      0   1   2   3   4   5   6   7
     _______________________________
    |   |   |   |   |   |   |   |   |
    | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
    |   |   |   |   |   |   |   |   |
     ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

    bit 0 - use custom column names?
    bit 1 - hide password?
    bit 2 - reserved for future use
    bit 3 - reserved for future use
    bit 4 - reserved for future use
    bit 5 - reserved for future use
    bit 6 - reserved for future use
    bit 7 - reserved for future use

$comment

    IF ob.b0 = 1 THEN
       lvc.mask = LVCF_TEXT

        FOR iCnt = 0 TO 4
            szColumns$[iCnt] = ""
            GET$ FP1, sizeof(iTmp), &iTmp

            IF iTmp <> 0 THEN
                GET$ FP1, iTmp, szBufr$

                szColumns$[iCnt] = LEFT$(szBufr$, iTmp)
                lvc.pszText = szColumns$[iCnt]
                SendMessage(ListView1, LVM_SETCOLUMN, iCnt, &lvc)
            END IF
        NEXT
    END IF

    IF ob.b1 = 0 THEN
       SendMessage(Edit4, EM_SETPASSWORDCHAR, 0, 0)
    ELSE
       SendMessage(Edit4, EM_SETPASSWORDCHAR, ASC("?"), 0)
    END IF

    iNext = 0
    WHILE NOT EOF(FP1)
        FOR iCnt = 0 TO 4
            szItems$[iCnt] = ""
            GET$ FP1, sizeof(iTmp), &iTmp

            IF iTmp <> 0 THEN
                GET$ FP1, iTmp, szBufr$

                szItems$[iCnt] = LEFT$(szBufr$, iTmp)
            END IF
        NEXT

        ListView_AddItems()
        INCR iNext
    WEND

CLEANUP:
    CLOSE FP1
END SUB


SUB ListView_WriteData()
    DIM lvi AS LVITEM
    DIM i, cnt
    DIM wTmp AS WORD
    DIM ob AS ONEBYTE

    lvi.mask       = LVIF_TEXT
    lvi.cchTextMax = MAXTEXT_SIZE

    OPEN "pw.dat" FOR BINARY NEW AS FP1
    PUT$ FP1, "MPV", 3	' identifier

    wTmp = MAKEWORD(1, 0)	' major / minor
    PUT$ FP1, &wTmp, sizeof(wTmp)

    FOR cnt = 0 TO 4
        i = ListView_GetColumnWidth(ListView1, cnt)
        PUT$ FP1, &i, sizeof(i)
    NEXT

    ob.b0 = 1 ' column headers
    ob.b1 = 0 ' password

    PUT$ FP1, &ob, 1   ' reserved bits

    IF ob.b0 = 1 THEN
        FOR cnt = 0 TO 4
            AddRecord(FP1, szColumns$[cnt])
        NEXT
    END IF

    FOR i = 0 to ListView_GetItemCount(ListView1) - 1
        lvi.iItem    = i
        FOR cnt = 0 TO 4
            lvi.iSubItem = cnt
            lvi.pszText  = szItems$[cnt]
            ListView_GetItem(ListView1, &lvi)

            AddRecord(FP1, szItems$[cnt])
        NEXT
    NEXT
    CLOSE FP1
END SUB


SUB AddRecord(fp AS file *, szIn$)
    DIM iTmp AS WORD

    iTmp = LEN(szIn$)
    PUT$ fp, &iTmp, sizeof(iTmp)
    PUT$ fp, szIn$, iTmp
END SUB


FUNCTION CompareFunc(lParam1 AS LPARAM, lParam2 AS LPARAM, SortType AS LPARAM) AS CB_INT
    DIM buffer$, buffer1$
    DIM lvi AS LVITEM

    lvi.mask       = LVIF_TEXT
    lvi.pszText    = buffer$
    lvi.cchTextMax = MAXTEXT_SIZE

    IF SortType = 9 OR SortType = 10 THEN
        lvi.iSubItem = 4
    ELSEIF SortType = 7 OR SortType = 8 THEN
        lvi.iSubItem = 3
    ELSEIF SortType = 5 OR SortType = 6 THEN
        lvi.iSubItem = 2
    ELSEIF SortType = 3 OR SortType = 4 THEN
        lvi.iSubItem = 1
    ELSE
        lvi.iSubItem = 0
    END IF

    SendMessage(ListView1, LVM_GETITEMTEXT, lParam1, &lvi)
    lstrcpy(buffer1$, buffer$)
    SendMessage(ListView1, LVM_GETITEMTEXT, lParam2, &lvi)

    IF MOD(SortType, 2) THEN
        FUNCTION = lstrcmpi(buffer1$, buffer$)
    END IF

    FUNCTION = lstrcmpi(buffer$, buffer1$)
END FUNCTION


SUB UpdatelParam()
    DIM lvi AS LVITEM
    DIM cnt

    cnt = ListView_GetItemCount(ListView1)
    lvi.mask     = LVIF_PARAM
    lvi.iSubItem = 0
    lvi.iItem    = 0

    WHILE cnt > 0
        lvi.lParam = lvi.iItem
        SendMessage(ListView1, LVM_SETITEM, 0, &lvi)
        INCR lvi.iItem
        DECR cnt
    WEND
END SUB
