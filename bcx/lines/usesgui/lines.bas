CONST ClassName1$ = "display_lines"

CreateLine(COMMAND$, (HINSTANCE) GetModuleHandle(NULL))

SUB CreateLine(CmdLine$, hInst AS HINSTANCE)
	DIM Form AS HWND
	DIM Edit AS HWND
	DIM wc   AS WNDCLASS
	DIM buffer$
	DIM lines, target

	IF VAL(CmdLine$) < 1 OR VAL(CmdLine$) > 5500 THEN
		PRINT "Copies a specific number of lines to the clipboard."
		PRINT ""
		PRINT "LINES number"
		PRINT ""
		PRINT "Value must be between 0 and 5501."
		EXIT SUB
	END IF

	lines  = 0
	target = VAL(CmdLine$)

	wc.style           = 0
	wc.lpfnWndProc     = WndProc
	wc.cbClsExtra      = 0
	wc.cbWndExtra      = 0
	wc.hInstance       = hInst
	wc.hIcon           = NULL
	wc.hCursor         = NULL
	wc.hbrBackground   = NULL
	wc.lpszMenuName    = NULL
	wc.lpszClassName   = ClassName1$
	RegisterClass(&wc)

	Form = CreateWindow(ClassName1$, "", DS_MODALFRAME | WS_POPUP, _
		0, 0, 0, 0, NULL, NULL, hInst,NULL)

	Edit = CreateWindow("edit", NULL, WS_CHILD | ES_MULTILINE, _
		0, 0, 0, 0, Form, 0, hInst, NULL)

	DO
		IF lines >= target THEN EXIT LOOP
		INCR  lines

		buffer$ = buffer$ & TRIM$(STR$(lines))
		IF lines <> target THEN
			buffer$ = buffer$ & CHR$(13) & CHR$(10)
		END IF
	LOOP

	SetWindowText(Edit, buffer$)
	SendMessage(Edit, EM_SETSEL, 0, -1)
	SendMessage(Edit, WM_COPY, 0, 0)

	PRINT "1 -", STR$(target), " has been copied to the clipboard."

	DestroyWindow(Form)
END SUB

CALLBACK FUNCTION WndProc()
	SELECT CASE Msg
	CASE WM_DESTROY 
		PostQuitMessage(0)
		EXIT FUNCTION
	END SELECT

	FUNCTION = DefWindowProc(hWnd, Msg, wParam, lParam)
END FUNCTION
