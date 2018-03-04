DIM hDLL AS HMODULE
DIM plug AS FARPROC
DIM iVal
DIM F$

F$ = FINDFIRST$("*.DLL")
WHILE LEN(F$) > 0
    hDLL = LoadLibrary   (F$)
    plug = GetProcAddress(hDLL, "_plug")

    IF plug <> NULL THEN
        PRINT "Calling the DLL ", F$
        iVal = plug(5, 2)
        PRINT iVal
    END IF

    FreeLibrary(hDLL)
    F$ = FINDNEXT$
WEND

ExitThread(0)  ' <- required to stop crashin
