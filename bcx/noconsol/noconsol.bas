$COMMENT

    NoConsole 1.0 -- Marc van den Dikkenberg, (C) December 1998 (Freeware)

    A small tweak To prevent PB/CC programs From opening a Console
    window At startup --  essential For writing true GUI applications!

    Simply compile your program To an executable, And run this patch.
    Thanks To Steve Hutchesson For discovering this gem!

                * Note: USE At YOUR OWN RISK! *

                ~~~ The PowerBASIC Archives ~~~
                   http://www.pbarchives.org
                  http://www.xs4all.nl/~excel

$COMMENT

IF argc < 2 THEN
    DisplayUsage()
ELSE
    CheckTarget(COMMAND$)
END IF

SUB CheckTarget(szTarget$)
    DIM szFile$

    szFile$ = szTarget$
    IF EXIST(szFile$) <> -1 THEN
        IF UCASE$(RIGHT$(szTarget$, 4)) <> ".exe" THEN
            szFile$ = szTarget$ & ".exe"
        END IF

        IF EXIST(szFile$) = -1 THEN
            PatchTarget(szFile$)
        ELSE
            DisplayUsage()
        END IF
    ELSE
        PatchTarget(szFile$)
    END IF
END SUB

SUB PatchTarget(szTarget$)
    DIM szByte$

    OPEN szTarget$ FOR BINARY AS FP1
        SEEK FP1, 0xDC
        GET$ FP1, 1, szByte$
        SEEK FP1, 0xDC

        IF szByte$ = CHR$(2) THEN
            PUT$ FP1, CHR$(3), 1
            PRINT "SUCCESS: ", szTarget$, " has been unpatched."
        ELSE
            PUT$ FP1, CHR$(2), 1
            PRINT "SUCCESS: ", szTarget$, " has been patched."
        END IF
    CLOSE FP1
END SUB

SUB DisplayUsage()
    PRINT "NoConsole 1.0 Patch 1", CRLF$
    PRINT "A small tweak to prevent 32-bit console programs from opening a"
    PRINT "console window at startup.", CRLF$
    PRINT "NoConsole [drive:][path]filename", CRLF$
    PRINT "  [drive:][path]filename Specifies the location and name of the"
    PRINT "                         file you want to patch", CRLF$
    PRINT "  Run filename through NoConsole again to remove patch."
END SUB
