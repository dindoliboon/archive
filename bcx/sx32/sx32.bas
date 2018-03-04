' #########################################################################

    CONST MAX_SIZE    = 260             ' max file path size
    CONST MAX_FILES   = 3               ' number of archived files

    STATIC szBuffer$   * MAX_SIZE        ' name of INF file
    STATIC szAction$                     ' action
    STATIC szTmpPath$  * MAX_SIZE        ' application Path
    STATIC szTmpFile$  * MAX_SIZE        ' string Table Buffer
    STATIC hInstance  AS HINSTANCE       ' program Instance
    STATIC hCurFiles                     ' current Proccessed File
    STATIC hError     AS BOOL            ' extract error code

    szAction$ = "open"                  ' run associated file
    hCurFiles = 0

    ' get program instance
    hInstance =  GetModuleHandle(NULL)

    ' find temporary path
    GetTempPathA(MAX_SIZE, szTmpPath$)

    ' extract all files
    DO WHILE (hCurFiles <> MAX_FILES)
        INCR hCurFiles
        szBuffer$ = ""
        LoadString(hInstance, hCurFiles, szTmpFile$, MAX_SIZE)
        lstrcat(szBuffer$, szTmpPath$)
        lstrcat(szBuffer$, szTmpFile$)

        IF Extract_Resource(MAKEINTRESOURCE(hCurFiles), szBuffer$,        _
            hInstance) = FALSE THEN
            MessageBox(0, szBuffer$, "Failed to extract file!", MB_OK)
        END IF
    WEND

    ' run our installation file
    '  note : installation file is the last file
    hError = (int) ShellExecuteA(0, szAction$, szBuffer$, 0, 0, 0)
    IF (int) hError = 0 or (int) hError <= 32 THEN
        MessageBox(0, szBuffer$, "Unable to execute file!", MB_OK)
    END IF

    ' exit our program
    ExitProcess(0)

' #########################################################################

FUNCTION Extract_Resource( _
    szRes$,                _
    szOut$,                _
    hInst AS HINSTANCE     _
    ) AS BOOL

    STATIC hFindResource   AS HRSRC
    STATIC hLoadResource   AS HGLOBAL
    STATIC hSizeOfResource AS DWORD
    STATIC hLockResource   AS LPVOID
    STATIC hlcreat         AS HFILE

    ' search for our resource
    hFindResource = FindResource(hInst, szRes$, RT_RCDATA)
    IF hFindResource = NULL THEN
        FUNCTION = FALSE
    END IF

    ' load resource into memory
    hLoadResource = LoadResource(hInst, hFindResource)
    IF hLoadResource = NULL THEN
        FUNCTION = FALSE
    END IF

    ' get resource size
    hSizeOfResource = SizeofResource(hInst, hFindResource)

    ' lock resource in place
    hLockResource = LockResource(hLoadResource)
    IF hLockResource = NULL THEN
        FUNCTION = FALSE
    END IF

    ' dump contents to a file
    hlcreat = _lcreat(szOut$, 0)
    IF hlcreat = HFILE_ERROR THEN
        FUNCTION = FALSE
    END IF

    IF _hwrite(hlcreat, hLockResource, hSizeOfResource) = HFILE_ERROR THEN
        FUNCTION = FALSE
    END IF

    IF _lclose(hlcreat) = HFILE_ERROR THEN
        FUNCTION = FALSE
    END IF

    FUNCTION = TRUE
END FUNCTION

' #########################################################################
