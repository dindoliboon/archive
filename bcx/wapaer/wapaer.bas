GLOBAL bmpBuffer$
DIM    exePath$

' get random bitmap name
FillBuffer()

' create the full name of the bitmap
GetModuleFileName(GetModuleHandle(NULL), exePath$, 1023)
exePath$ = LEFT$(exePath$, INSTRREV(exePath$, "\") + 1) & bmpBuffer$

' update wallpaper
SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, exePath$, SPIF_UPDATEINIFILE)

SUB FillBuffer()
    DIM ffd AS WIN32_FIND_DATA
    DIM hFind AS HANDLE
    DIM count
    DIM rn

    rn = 0

PerformLoop:
    count = 0
    hFind = FindFirstFile("*.bmp", &ffd)
    IF hFind THEN
        WHILE LEN(ffd.cFileName$) > 0
            IF ffd.cFileName$ <> ".." AND ffd.cFileName$ <> "." THEN
                INCR count

                IF rn > 0 AND rn = count THEN
                    bmpBuffer$ = ffd.cFileName$
                    EXIT LOOP ' so we can call FindClose later
                END IF
            END IF

            IF NOT FindNextFile(hFind, &ffd) THEN
                EXIT LOOP
            END IF
        WEND
    END IF
    FindClose(hFind)

    ' attempt to create a random number
    IF rn = 0 AND count > 0 THEN
        srand(time(NULL))
        rn = (int)mod(rand() * sqrt(rand()) + time(NULL), count) + 1
        GOTO PerformLoop
    END IF
END SUB
