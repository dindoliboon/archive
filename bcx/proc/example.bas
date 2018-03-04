DIM hDLL AS HMODULE
DIM plug AS FARPROC
DIM iVal

hDLL = LoadLibrary   ("mul2.dll")
plug = GetProcAddress(hDLL, "_plug")

iVal = plug(2, 5)
PRINT iVal

FreeLibraryAndExitThread(hDLL, 0)
