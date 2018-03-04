$COMMENT
###########################################################################

file copy tests based on a file that is 14,290,800 bytes

chunk size		milliseconds took to complete
      1 byte		19,468.0 ms
      2 bytes		10,385.0 ms
      4 bytes		 5,839.0 ms
      8 bytes		 3,575.0 ms
     16 bytes		 2,454.0 ms
     32 bytes		 1,873.0 ms
     64 bytes		 1,520.4 ms
    128 bytes		 1,369.8 ms
    256 bytes		 1,289.8 ms
    512 bytes		 1,284.0 ms
  1,024 bytes		 1,364.5 ms
  2,048 bytes		   989.4 ms
  4,096 bytes		   937.6 ms
  8,192 bytes		   903.0 ms
 16,384 bytes		   965.6 ms
 32,768 bytes		   963.4 ms
 65,536 bytes		   959.4 ms
131,072 bytes		  1112.0 ms
262,144 bytes		  1271.0 ms

###########################################################################
$COMMENT

    DIM CHUNK_SIZE AS DWORD
    CHUNK_SIZE = 8192

    DIM dwSize AS DWORD
    DIM dwBufr AS DWORD
    DIM buffer$ * CHUNK_SIZE + 1
    DIM fByte$ * 1
    DIM iKey[256]
    DIM iPos
    DIM xPos
    DIM kCheck

    ' reset table
    FOR xPos = 0 to 255
        iKey[xPos] = -1
    NEXT

    ' Load key into memory
    iPos = 0
    OPEN "key.txt" FOR BINARY AS FP_LoadKey
    WHILE NOT EOF(FP_LoadKey)
        ' grab next character
        SEEK FP_LoadKey, iPos
        GET$ FP_LoadKey, 1, fByte$

        xPos = ASC(fByte$)
        IF iKey[xPos] = - 1 THEN
            iKey[xPos] = iPos
        ELSE
            srand(time(NULL))
            IF mod(rand(), 2) = 1 THEN iKey[xPos] = iPos
        END IF

        ' continue reading
        INCR iPos
    WEND
    CLOSE FP_LoadKey
    PRINT "Key table filled!"

    ' adjust our padding size based on key size
    kCheck = LOF("key.txt")
    IF kCheck <= 256 THEN
        kCheck = 1
    ELSEIF kCheck <= 65536 THEN
        kCheck = 2
    ELSE
        ' don't even bother with a 3-block pad
        ' because the key could be around 15 MB
        kCheck = 4
    END IF

    ' Print decoded contents to file
    dwSize = LOF(COMMAND$)
    dwBufr = CHUNK_SIZE

    KILL "eout.txt"
    PRINT "Beginning to encode file..."
    OPEN COMMAND$ FOR BINARY AS FP_Input
    OPEN "eout.txt" FOR BINARY NEW AS FP_Output

    ' set the 1st byte to the size of the keyblock
    PUT$ FP_Output, &kCheck, 1

    WHILE NOT EOF(FP_Input)
        IF dwSize < dwBufr THEN
            dwBufr = dwSize
        ELSE
            dwBufr = CHUNK_SIZE
        END IF

        GET$ FP_Input, dwBufr, buffer$

        FOR iPos = 0 TO dwBufr - 1
            ! fByte[0] = buffer[iPos];

            PUT$ FP_Output, &iKey[ASC(fByte$)], kCheck
        NEXT

        dwSize -= dwBufr
    WEND

    CLOSE FP_Input
    CLOSE FP_Output

' #########################################################################
