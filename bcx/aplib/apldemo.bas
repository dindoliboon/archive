' aPLib Demo
' This example will compress a msg and save it to a file. Running the
' program again will decompress the msg and display it. Then it will
' be deleted. aPLib was created by Joergen Ibsen.
'
' http://apack.cjb.net/

#include "aplib.h"

' structure for our data file
TYPE file_t         ' 16 bytes header
    sig$[3]         ' 4 bytes
    major AS SHORT  ' 2 bytes
    minor AS SHORT  ' 2 bytes
    psize AS LONG   ' 4 bytes
    usize AS LONG   ' 4 bytes
END TYPE

DIM fHead      AS file_t
DIM wrkAlloc   AS HGLOBAL
DIM wrkLock    AS LPVOID
DIM pkdAlloc   AS HGLOBAL
DIM pkdLock    AS LPVOID
DIM upkAlloc   AS HGLOBAL
DIM upkLock    AS LPVOID
DIM ipBuf$ * 32768
DIM msg$
DIM ans$

' setup default header
fHead.sig$  = "BTP"
fHead.major = 1
fHead.minor = 0

' check if file exists
IF EXIST("message.btp") <> -1 THEN
    PRINT "No message has been stored!"
    PRINT ""

    ' get input and store size
    PRINT "Type a msg to store (. to quit):"
    DO
        INPUT msg$

        IF msg$ = "." THEN EXIT LOOP
        ipBuf$ = ipBuf$ & msg$ & CHR$(13) & CHR$(10)
    LOOP
    fHead.usize = LEN(ipBuf$)
    
    ' check if worth compressing
    IF fHead.usize < 5 THEN
        PRINT "Ha! You expect to compress this? Type something longer."
        GOTO cleanup
    END IF

    ' allocate memory for storing compressed data
    pkdAlloc = GlobalAlloc(GMEM_MOVEABLE or GMEM_ZEROINIT, fHead.usize)
    IF NOT pkdAlloc THEN    
        PRINT "Unable to allocate enough memory for packed data."
        GOTO cleanup
    ELSE
        pkdLock = GlobalLock(pkdAlloc)
    END IF

    ' allocate memory for temporary compression data
    wrkAlloc = GlobalAlloc(GMEM_MOVEABLE or GMEM_ZEROINIT, _aP_workmem_size(fHead.usize))
    IF NOT wrkAlloc THEN
        PRINT "Unable to allocate enough memory for temporary storage."
        GOTO cleanup
    ELSE
        wrkLock = GlobalLock(wrkAlloc)
    END IF

    ' compress input and save data
    fHead.psize = _aP_pack(ipBuf$, pkdLock, fHead.usize, wrkLock, NULL)
    OPEN "message.btp" FOR BINARY NEW AS FP1
        PUT$ FP1, &fHead, sizeof(fHead)
        PUT$ FP1, pkdLock, fHead.psize
    CLOSE FP1
ELSE
    ' read data header and store packed msg
    OPEN "message.btp" FOR BINARY AS FP1
        GET$ FP1, sizeof(fHead), &fHead
        GET$ FP1, fHead.psize, ipBuf$
    CLOSE FP1

    ' check if valid BTP file
    IF LCASE$(fHead.sig$) <> "btp" THEN
        PRINT "This is not a valid BCX Text Packer file!"
        GOTO cleanup
    END IF

    ' check for version signature
    IF fHead.major <> 1 THEN
        PRINT "A newer version of BCX Text Packer is needed!"
        GOTO cleanup
    END IF

    ' allocate memory for decompressing data
    upkAlloc = GlobalAlloc(GMEM_MOVEABLE or GMEM_ZEROINIT, fHead.usize)
    IF NOT upkAlloc THEN
        PRINT "Unable to allocate enough memory for unpacked data."
        GOTO cleanup
    ELSE
        upkLock = GlobalLock(upkAlloc)
    END IF

    ' decompress data from memory
    _aP_depack_asm_fast(ipBuf$, upkLock)
    upkLock$ = LEFT$(upkLock$, fHead.usize)

    ' check file size
    IF fHead.usize <> LEN(upkLock) THEN
        PRINT "The unpacked size is not equal. Something went wrong"
        GOTO cleanup
    END IF

    ' print saved msg
    PRINT "Your last msg was:"
    PRINT upkLock$

    ' ask to remove file
    INPUT "Would you like to remove the msg? [y/n]: ", ans$

    ' remove file if yes
    SELECT CASE ans$
    CASE "Y", "y"
        PRINT "Now removing msg..."
        KILL  "message.btp"
    END SELECT
END IF

cleanup:

    IF upkLock  THEN GlobalUnlock(upkLock)
    IF upkAlloc THEN GlobalFree(upkAlloc)

    IF wrkLock  THEN GlobalUnlock(wrkLock)
    IF wrkAlloc THEN GlobalFree(wrkAlloc)

    IF pkdLock  THEN GlobalUnlock(pkdLock)
    IF pkdAlloc THEN GlobalFree(pkdAlloc)
