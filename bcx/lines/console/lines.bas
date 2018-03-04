CreateLine(COMMAND$)

SUB CreateLine(CmdLine$)
	DIM buffer$
	DIM lines, target
        DIM hMemory AS HGLOBAL
        DIM pMemory AS LPVOID

	IF VAL(CmdLine$) < 1 THEN
		PRINT "Copies a specific number of lines to the clipboard."
		PRINT ""
		PRINT "LINES end-range"
		PRINT ""
		PRINT "end-range must be greater than 0"
		EXIT SUB
	END IF

	lines  = 0
	target = VAL(CmdLine$)

        OpenClipboard(NULL)
        hMemory = GlobalAlloc(GMEM_MOVEABLE, 10 * target)
        pMemory = GlobalLock(hMemory)
        pMemory$ = ""

	DO
                INCR lines
		pMemory$ = pMemory$ & TRIM$(STR$(lines))

		IF lines >= target THEN
			EXIT LOOP
                ELSE
			pMemory$ = pMemory$ & CHR$(13) & CHR$(10)
                END IF
	LOOP

        EmptyClipboard()
        SetClipboardData(CF_TEXT, hMemory)
        CloseClipboard()
        GlobalUnlock(hMemory)
        GlobalFree(hMemory)

	PRINT "1 -", STR$(target), " has been copied to the clipboard."
END SUB
