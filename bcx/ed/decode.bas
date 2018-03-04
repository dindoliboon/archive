' #########################################################################

    TYPE ED_TYPE
        lData AS INTEGER
    END TYPE

    STATIC buf$
    STATIC tmp AS INTEGER
    STATIC ksz AS INTEGER
    STATIC EDT AS ED_TYPE

    KILL "dout.txt"
    OPEN COMMAND$ FOR BINARY AS FP_Input
    OPEN "key.txt" FOR BINARY AS FP_Key
    OPEN "dout.txt" FOR BINARY NEW AS FP_Output

    ' grab key pad size
    GET$ FP_Input, 1, &EDT
    ksz = EDT.lData

    ' move to the next byte
    SEEK FP_Input, 1

    WHILE NOT EOF(FP_Input)
        buf$ = ""
        tmp  = 0

        GET$ FP_Input, ksz, &EDT
        SEEK FP_Key, EDT.lData

        GET$ FP_Key, 1, buf$
        tmp = ASC(buf$)
        PUT$ FP_Output, CHR$(tmp), 1
    Wend
    CLOSE FP_Output
    CLOSE FP_Key
    CLOSE FP_Input

' #########################################################################
