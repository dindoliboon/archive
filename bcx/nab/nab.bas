' #########################################################################

    GLOBAL iButton
    GLOBAL iCheckbox
    GLOBAL iRadio
    GLOBAL iStatic
    GLOBAL iScrollBar
    GLOBAL iEdit
    GLOBAL iListBox
    GLOBAL iComboBox
    GLOBAL iControl

    GLOBAL parent_hwnd

    ' get user's hwnd
    parent_hwnd = VAL(COMMAND$)

    ' get parent's info first
    EnumChildWinProc((HWND)parent_hwnd, (LPARAM)12345)

    ' get all child controls next
    EnumChildWindows((HWND)parent_hwnd, EnumChildWinProc, 0)

' #########################################################################

FUNCTION EnumChildWinProc(hwnd AS HWND, lParam AS LPARAM) AS BOOL CALLBACK
    STATIC dwExStyle$
    STATIC lpClassName$
    STATIC lpWindowName$
    STATIC dwStyle$
    STATIC x$
    STATIC y$
    STATIC nWidth$
    STATIC nHeight$
    STATIC hMenu$
    STATIC lpKeyName$
    STATIC lpTemp$
    STATIC rc AS RECT
    STATIC a  AS LONG

    ' extended window style
    a = GetWindowLong(hwnd, GWL_EXSTYLE)
    dwExStyle$ = TRIM$(STR$(a))

    ' registered class name
    GetClassName(hwnd, lpClassName$, 2048)

    ' window name
    GetWindowText(hwnd, lpWindowName$, 2048)

    ' window style
    a = GetWindowLong(hwnd, GWL_STYLE)
    dwStyle$ = TRIM$(STR$(a))

    ' horizontal position of window
    GetWindowRect(hwnd, &rc)        ' get control
    a = rc.left
    GetWindowRect((HWND)parent_hwnd, &rc)    ' get parent
    x$ = TRIM$(STR$((a-rc.left)-2))

    ' vertical position of window
    GetWindowRect(hwnd, &rc)        ' get control
    a = rc.top
    GetWindowRect((HWND)parent_hwnd, &rc)    ' get parent
    y$ = TRIM$(STR$((a-rc.top)-20))

    ' window width
    GetWindowRect(hwnd, &rc)
    a = (rc.right-rc.left)
    nWidth$ = TRIM$(STR$(a))

    ' window height
    GetWindowRect(hwnd, &rc)
    a = (rc.bottom-rc.top)
    nHeight$ = TRIM$(STR$(a))

    a = GetWindowLong(hwnd, GWL_ID)
    hMenu$ = TRIM$(STR$(a))

    SELECT CASE(LCASE$(lpClassName$))
    CASE "button"
        INCR iButton
        lpKeyName$ = "Button" & TRIM$(STR$(iButton))
    CASE "checkbox"
        INCR iCheckbox
        lpKeyName$ = "Checkbox" & TRIM$(STR$(iCheckbox))
    CASE "radio"
        INCR iRadio
        lpKeyName$ = "Radio" & TRIM$(STR$(iRadio))
    CASE "static"
        INCR iStatic
        lpKeyName$ = "Static" & TRIM$(STR$(iStatic))
    CASE "scrollbar"
        INCR iScrollBar
        lpKeyName$ = "ScrollBar" & TRIM$(STR$(iScrollBar))
    CASE "edit"
        INCR iEdit
        lpKeyName$ = "Edit" & TRIM$(STR$(iEdit))
    CASE "listbox"
        INCR iListBox
        lpKeyName$ = "ListBox" & TRIM$(STR$(iListBox))
    CASE "combobox"
        INCR iComboBox
        lpKeyName$ = "ComboBox" & TRIM$(STR$(iComboBox))
    ELSE
        IF lParam = 12345 THEN
            lpKeyName$ = "Form1"
        ELSE
            INCR iControl
            lpKeyName$ = "Control" & TRIM$(STR$(iControl))
        END IF
    END SELECT

    ' read template file and replace strings
    lpTemp$ = ReadContents$("cw.txt")
    lpTemp$ = REPLACE$(lpTemp$, "\Name", lpKeyName$)
    lpTemp$ = REPLACE$(lpTemp$, "\ID", hMenu$)
    lpTemp$ = REPLACE$(lpTemp$, "\ExStyles", dwExStyle$)
    lpTemp$ = REPLACE$(lpTemp$, "\Class", lpClassName$)
    lpTemp$ = REPLACE$(lpTemp$, "\Caption", lpWindowName$)
    lpTemp$ = REPLACE$(lpTemp$, "\Styles", dwStyle$)
    lpTemp$ = REPLACE$(lpTemp$, "\x", x$)
    lpTemp$ = REPLACE$(lpTemp$, "\y", y$)
    lpTemp$ = REPLACE$(lpTemp$, "\w", nWidth$)
    lpTemp$ = REPLACE$(lpTemp$, "\h", nHeight$)

    ' show new createwindow code
    PRINT lpTemp$

    FUNCTION = TRUE
END FUNCTION

' #########################################################################

FUNCTION ReadContents$(szFile$)
    STATIC fReturn$ * 65535
    STATIC fBuffer$

    fReturn$ = ""
    OPEN szFile$ FOR INPUT AS FP_ReadContents
    WHILE NOT EOF(FP_ReadContents)
        LINE INPUT FP_ReadContents, fBuffer$
        fReturn$ = Join$(3, fReturn$, fBuffer$, CHR$(10))
    WEND
    CLOSE FP_ReadContents

    FUNCTION = fReturn$
END FUNCTION

' #########################################################################
