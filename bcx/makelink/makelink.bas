' ==========================================================================
' BCX COM EXAMPLE
' Creates a Windows shortcut to an executable, adding several properties.
'
' BCX.ICO and icon update by RainbowSally
' ==========================================================================


' ==========================================================================
' INCLUDE HEADERS REQUIRED FOR COM
' ==========================================================================
#include <shlguid.h>
#include <objbase.h>


' ==========================================================================
' MISCELLANEOUS VARIABLES
' ==========================================================================
CONST CHAR_PTR = char *
DIM szFile$
DIM szTarget$
DIM szDesc$
DIM szIcon$


' ==========================================================================
' MAIN CODE
' ==========================================================================
szFile$   = AppPath$(EXEModule$()) & "test.exe"
szTarget$ = AppPath$(EXEModule$()) & "shortcut to test.lnk"
szIcon$   = AppPath$(EXEModule$()) & "bcx.ico"
szDesc$   = "Shortcut to test.lnk using BCX!"

IF CreateLink(szFile$, szTarget$, szDesc$, szIcon$) = S_OK THEN
    MSGBOX "Your shortcut has been created!",  "Look at that, BCX does DO COM!"
ELSE
    MSGBOX "An error occured while trying to create your shortcut", "Aw man..."
END IF


' --------------------------------------------------------------------------
' DESCRIPTION: Creates a Windows shortcut
'       INPUT: string to EXE, string to shortcut, string to description,
'              string to icon
'      OUTPUT: HRESULT to success or failure
'       USAGE: result = CreateLink("c:\in.exe", "c:\out.lnk, "description")
'     RETURNS: S_OK if the interface is supported, E_NOINTERFACE if not.
' --------------------------------------------------------------------------
FUNCTION CreateLink(lpszPathObj AS LPCSTR, lpszPathLink AS LPSTR, lpszDesc AS LPSTR, lpszIcon AS LPSTR) AS HRESULT
    DIM hres AS HRESULT
    DIM psl  AS IShellLink*

    ' Added this line to initialize the COM object
    CoInitialize(NULL)

    ' Get a pointer to the IShellLink interface. 
    hres = CoCreateInstance(&CLSID_ShellLink, NULL, CLSCTX_INPROC_SERVER, &IID_IShellLink, &psl)

    IF (SUCCEEDED(hres)) THEN
        DIM ppf AS IPersistFile*

        ' Sets shortcut location
        psl->lpVtbl->SetPath(psl, lpszPathObj)

        ' Sets shortcut description
        psl->lpVtbl->SetDescription(psl, lpszDesc)

        ' Gives shortcut an icon
        psl->lpVtbl->SetIconLocation(psl, lpszIcon, 0)

        ' Make it full screen
        psl->lpVtbl->SetShowCmd(psl, SW_SHOWMAXIMIZED)

        ' Set default path
        psl->lpVtbl->SetWorkingDirectory(psl, AppPath$(lpszPathObj))

        ' Set arguments
        psl->lpVtbl->SetArguments(psl, "-arg1 -arg2 -arg3")

        ' **** OTHER PROPERTIES ARE AVAILABLE! ****
        ' DO NOT UNCOMMENT UNLESS YOU DEFINE THE OTHER PARAMETERS
        ' * READ THE MICROSOFT PSDK FOR MORE INFO *
        ' psl->lpVtbl->SetHotkey(psl, wHotkey)
        ' psl->lpVtbl->SetIDList(psl, pidl)
        ' psl->lpVtbl->SetRelativePath(psl, pszPathRel, NULL)

        ' Query IShellLink for the IPersistFile interface for saving the 
        ' shortcut in persistent storage. 
        hres = psl->lpVtbl->QueryInterface(psl, &IID_IPersistFile, &ppf)
 
        IF (SUCCEEDED(hres)) THEN
            DIM wsz[MAX_PATH] AS WORD
 
            ' Ensure that the string is ANSI. 
            MultiByteToWideChar(CP_ACP, 0, lpszPathLink, -1, wsz, MAX_PATH)
 
            ' Save the link by calling IPersistFile::Save. 
            hres = ppf->lpVtbl->Save(ppf, wsz, TRUE)
            ppf->lpVtbl->Release(ppf)
        END IF
        psl->lpVtbl->Release(psl)
    END IF

    ' Added this line to Uninitialize the COM object
    CoUninitialize()

    FUNCTION = hres
END FUNCTION


' --------------------------------------------------------------------------
' DESCRIPTION: Wrapper for GetModuleFileName()
'       INPUT: n/a
'      OUTPUT: String to full path name
'       USAGE: buffer$ = EXEModule$()
'     RETURNS: c:\your application path\your file.exe
' --------------------------------------------------------------------------
FUNCTION EXEModule$()
    DIM buffer$

    GetModuleFileName(NULL, buffer$, 2047)
    FUNCTION = buffer$
END FUNCTION


' --------------------------------------------------------------------------
' DESCRIPTION: Gets a path from full path name
'       INPUT: String to full path name
'      OUTPUT: String to path name
'       USAGE: buffer$ = AppPath$("c:\your directory\your file.exe")
'     RETURNS: c:\your directory\
' --------------------------------------------------------------------------
FUNCTION AppPath$(path$)
    FUNCTION = LEFT$(path$, LastPosChar(path$, "\") + 1)
END FUNCTION


' --------------------------------------------------------------------------
' DESCRIPTION: Gets exe from full path name
'       INPUT: String to full path name
'      OUTPUT: String to EXE name
'       USAGE: buffer$ = EXEName$("c:\your directory\your file.exe")
'     RETURNS: your file.exe
' --------------------------------------------------------------------------
FUNCTION EXEName$(path$)
    FUNCTION = RIGHT$(path$, LEN(path$) - (LastPosChar(path$, "\") + 1))
END FUNCTION


' --------------------------------------------------------------------------
' DESCRIPTION: Returns last occurance of a string
'       INPUT: String of characters, String of one character
'      OUTPUT: Integer to position
'       USAGE: buffer = LastPosChar("c:\your directory\your file.exe", "\")
'     RETURNS: 17
' --------------------------------------------------------------------------
FUNCTION LastPosChar(szLine AS CHAR_PTR, szChar AS CHAR_PTR)
    !int iCount = 0;
    !int iPos   = -1;

    !while (*szLine != '\0')
    !{
    !    if (*szLine == *szChar) iPos = iCount;
    !    iCount ++;
    !    ++ szLine;
    !}

    FUNCTION = iPos
END FUNCTION
