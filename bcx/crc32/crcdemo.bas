' CRC-32 Demo
' This example will calculate the CRC-32 checksum for any file.
' It is the work of G. Adam Stanislav and the full assembly source
' code and package is available at his web site.
'
' http://www.geocities.com/SiliconValley/Heights/7394/

#include "crc32.h"

DIM hFile      AS HFILE
DIM dwFileSize AS DWORD
DIM rAlloc     AS HGLOBAL
DIM szCrc$

' open file
hFile = _lopen(COMMAND$, OF_READ)
IF hFile = HFILE_ERROR THEN
    PRINT "Unable to open file."
    GOTO usage
END IF

' get size of file
dwFileSize = GetFileSize((HANDLE)hFile, NULL)
IF dwFileSize = 0xFFFFFFFF THEN
    PRINT "Unable to get file size."
    GOTO usage
END IF

' allocate memory to read data
rAlloc = GlobalAlloc(GMEM_FIXED, dwFileSize)
IF rAlloc = NULL THEN
    PRINT "Unable to allocate enough memory."
    GOTO usage
END IF

' read file into buffer
IF _lread(hFile, rAlloc, dwFileSize) = HFILE_ERROR THEN
    PRINT "Unable to read file."
    GOTO usage
END IF

' calculate CRC-32
wsprintf(szCrc, "The CRC-32 of %s is %X.", COMMAND$, ArrayCrc32(rAlloc, dwFileSize))
PRINT szCrc$
GOTO cleanup

usage:
    PRINT "------------------------------------------"
    PRINT "CRC-32 library (crc32.dll), version 2"
    PRINT "Copyright (c) 1997, 1999 G. Adam Stanislav"
    PRINT "All rights reserved."
    PRINT ""
    PRINT "For more information send e-mail to"
    PRINT "whizkid@bigfoot.com"
    PRINT "------------------------------------------"
    PRINT "USAGE:"
    PRINT "    CRCDEMO.EXE filename.ext"

cleanup:
    ' release buffer
    GlobalFree(rAlloc)

    ' close the file
    _lclose(hFile)
