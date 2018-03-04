' -------------------------------------------------------------------------
'    DATE: July 24, 2001
' PROJECT: PBEL 1.0
' PURPOSE: Asks the user which error code they would like to view. Users
'          have the ability to view all error codes at once and can even
'          add their own error codes to the list.
' COMPILE: BUILD.BAT
' -------------------------------------------------------------------------
#include <assert.h>
DIM iGError
DIM szGDesc$

CALL ProcessMenu()

' -------------------------------------------------------------------------
'   INPUT: none
'  OUTPUT: none
' PURPOSE: Processes the various menu choices
' -------------------------------------------------------------------------
SUB ProcessMenu()
    DIM iChosen
    DIM iTmp

    DO
        iChosen = DisplayMenu()

        SELECT CASE iChosen
        CASE 1
            CALL ViewError(AskThis("Which error code would you like to see? "))

            IF LEN(szGDesc$) THEN
                PRINT "Error code [", iGError ," ] stands for ", szGDesc$
            ELSE
                PRINT "Error code [", iGError ," ] does not exist."
                IF AskThis("Would you like to add it to the database (1 to add)? ") = 1 THEN
                    CALL AddError(iGError)
                END IF
            END IF
        CASE 2
            iTmp = AskThis("What error code would you like to add? ")

            IF CheckError(iTmp) = TRUE THEN
                PRINT "Error code [", iTmp ," ] already exists."
            ELSE
                CALL AddError(iTmp)
            END IF
        CASE 3
            CALL ListErrors()
        CASE 4
            EXIT SUB
        CASE ELSE
            PRINT "Invalid choice!"
        END SELECT

        PRINT "Press any key to continue..."
        KEYPRESS
    UNTIL iChosen = 4
END SUB

' -------------------------------------------------------------------------
'   INPUT: none
'  OUTPUT: iChoice
' PURPOSE: Displays the main menu, accepts choice
' -------------------------------------------------------------------------
FUNCTION DisplayMenu()
    DIM iChoice

    CLS
    PRINT "PB Error Code List"
    PRINT "~~~~~~~~~~~~~~~~~~"
    PRINT "1. View Error Code"
    PRINT "2. Add Error Code"
    PRINT "3. List All Error Codes"
    PRINT "4. Exit Program"
    PRINT ""
    INPUT "> " iChoice

    FUNCTION = iChoice
END FUNCTION

' -------------------------------------------------------------------------
'   INPUT: szMsg$
'  OUTPUT: iTmp
' PURPOSE: Prompts the user and returns a integer value
' -------------------------------------------------------------------------
FUNCTION AskThis(szMsg$)
    DIM iTmp

    INPUT szMsg$ iTmp
    FUNCTION = iTmp
END FUNCTION

' -------------------------------------------------------------------------
'   INPUT: iError
'  OUTPUT: none
' PURPOSE: Seeks error code in file and places it in the global buffer
' -------------------------------------------------------------------------
SUB ViewError(iError)
    DIM szBuffer$

    ' data file MUST exist
    assert(EXIST("error.dat")  == -1)

    szGDesc$ = ""
    iGError  = iError

    OPEN "error.dat" FOR INPUT AS FP1
        WHILE NOT EOF(FP1)
            LINE INPUT FP1, szBuffer$

            IF iError = VAL(LEFT$(szBuffer$, 4)) THEN
                szGDesc$ = RIGHT$(szBuffer$, LEN(szBuffer$) - 8)
                iGError = iError

                CLOSE FP1
                EXIT SUB
            END IF
        WEND
    CLOSE FP1
END SUB

' -------------------------------------------------------------------------
'   INPUT: iError
'  OUTPUT: TRUE if iError exists, otherwise FALSE
' PURPOSE: Checks if an error code exists in the file
' -------------------------------------------------------------------------
FUNCTION CheckError(iError)
    DIM szBuffer$

    ' data file MUST exist
    assert(EXIST("error.dat")  == -1)

    OPEN "error.dat" FOR INPUT AS FP2
        WHILE NOT EOF(FP2)
            LINE INPUT FP2, szBuffer$

            IF iError = VAL(LEFT$(szBuffer$, 4)) THEN
                CLOSE FP2

                FUNCTION = TRUE
            END IF
        WEND
    CLOSE FP2

    FUNCTION = FALSE
END FUNCTION

' -------------------------------------------------------------------------
'   INPUT: iError
'  OUTPUT: none
' PURPOSE: Adds an error code to error.dat
' -------------------------------------------------------------------------
SUB AddError(iError)
    DIM dwLength AS DWORD
    DIM szMsg$
    DIM szError$

    ' data file MUST exist
    assert(EXIST("error.dat")  == -1)

    PRINT "Type a brief description to store (2047 char max):"
    INPUT szMsg$

    szError$ = TRIM$(STR$(iError))

    OPEN "error.dat" FOR APPEND AS FP3
        FPRINT FP3, szError$, SPACE$(8 - LEN(szError$)), szMsg$
    CLOSE FP3
END SUB

' -------------------------------------------------------------------------
'   INPUT: none
'  OUTPUT: none
' PURPOSE: Lists all the error codes in the error.dat file
' -------------------------------------------------------------------------
SUB ListErrors()
    DIM szBuffer$
    DIM szError$
    DIM szDesc$
    DIM iError

    OPEN "error.dat" FOR INPUT AS FP1
        WHILE NOT EOF(FP1)
            LINE INPUT FP1, szBuffer$
            iError  = VAL(LEFT$(szBuffer$, 4))
            szDesc$ = RIGHT$(szBuffer$, LEN(szBuffer$) - 8)
            szError$ = TRIM$(STR$(iError))

            PRINT szError$, SPACE$(8 - LEN(szError$)), szDesc$
        WEND
    CLOSE FP1
END SUB
