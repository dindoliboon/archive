' declare float variables
DIM I AS FLOAT
DIM N AS FLOAT

' show our fake window
CLS
PRINT ""
PRINT ""
PRINT ""
PRINT "    ÉÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ»"
PRINT "    ³                                                                    ³"
PRINT "    ³  š        This is a percentage bar demo in console mode         š  ³"
PRINT "    ³                                                                    ³"
PRINT "    ĆÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄĀÄÄÄÄÄÄÄÄ´"
PRINT "    ³                                                           ³        ³"
PRINT "    ³  °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°  ³     %  ³"
PRINT "    ³                                                           ³        ³"
PRINT "    ČÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄĮÄÄÄÄÄÄÄÄ¼"

' set max value to 10000 in float
N = 10000.0

' loop it
FOR I = 1.0 TO N
    ' draw blue line using spaces
    ' PANEL 10.0 + I / N * 55.0, 10, 7.0 + I / N * 55.0, 7, 15, 1, 32, 0

    ' draw line using astrisk
    LOCATE 10, 7.0 + I / N * 55.0, 0
    PRINT "Ū"

    ' display percentage as integer
    LOCATE 10, 67, 0
    PRINT STR$((int)( I / N * 100.0))
NEXT

' restore cursor below fake window
LOCATE 12, 1, 1
