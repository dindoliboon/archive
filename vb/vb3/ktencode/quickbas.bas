'This function has been modified to work in QuickBASIC.  This function
'was originally designed in VISUAL BASIC for WINDOWS 3.0 and was modified
'for use in QuickBASIC.  There were a few changes but everything works
'as described in the READTHIS.TXT file.

'This is just a simple DEMO program to try the function.  Have fun!
'Programmed by Karl D Albreckt  (KARL25@AOL.COM)
'Please read the READTHIS.TXT file!
'Thank you


DECLARE FUNCTION KTEncrypt$ (password$, strng$, Flag%, Errors$)
Msg$ = "Hello, this is a test string to scramble."

CommandLoop:

CLS
PRINT Msg$
PRINT : PRINT : PRINT : PRINT : PRINT : PRINT
PRINT STRING$(80, "-");
LINE INPUT "PASSWORD:"; password$
PRINT "0 - Encode  or  1 - Decode"
OK = 0
DO WHILE OK = 0
  a$ = INKEY$
  IF a$ = "1" OR a$ = "0" THEN OK = 1
LOOP
which% = VAL(a$)

Msg$ = KTEncrypt$(password$, Msg$, which%, Errors$)
IF Errors$ <> "" THEN
  BEEP

  PRINT : PRINT : PRINT "            " + Errors$
  PRINT : PRINT " Press any key"
  a$ = INPUT$(1)
END IF

GOTO CommandLoop

'Programmed by Karl Albrecht (KARL25@AOL.COM)
FUNCTION KTEncrypt$ (password$, original$, Flag%, Errors$)
  
  'Dimension the Adjust array
  REDIM Adjust(4)
  
  'Set error capture routine
  ON LOCAL ERROR GOTO ErrorHandler

  'Preserve original string and work on strng$
  strng$ = original$

  
  
  'Check for errors (Errorcodes are custom)
  'Is there Password??
  IF LEN(password$) = 0 THEN ERROR 100
  
  'Is there a strng$ to work with?
  IF LEN(strng$) = 0 THEN ERROR 110

  'Check to see if it is an encoded file
  IF RIGHT$(strng$, 5) = STRING$(5, 255) THEN
    'if encoding warn!
    IF Flag% = 0 THEN ERROR 120
  ELSE
    'If decoding warn
    IF Flag% <> 0 THEN ERROR 130
  END IF
  

  
  'Create a four part encryption code based on password
  'First Adjust code based on length of password
  Adjust(1) = LEN(password$)
  
  'If first character ascii code even make adjust negative
  IF ASC(LEFT$(password$, 1)) / 2 = INT(ASC(LEFT$(password$, 1)) / 2) THEN
    Adjust(1) = Adjust(1) * -1
  END IF

  'Second Adjust code based on first and last character ascii codes
  Adjust(2) = ASC(LEFT$(password$, 1)) - ASC(RIGHT$(password$, 1))

  'Third code based on average of all ascii codes
  TotalAscii = 0
  FOR Looper = 1 TO LEN(password$)
    TotalAscii = TotalAscii + ASC(MID$(password$, Looper, 1))
  NEXT Looper
  Adjust(3) = INT(TotalAscii / LEN(password$) / 3)

  'Fourth code based on previous three
  Adjust(4) = Adjust(1) + Adjust(2) + Adjust(3)

  
  
  'Now check if any Adjust codes are zero
  'If it is zero make it not zero (any number is fine!)
  FOR Looper = 1 TO 4
    IF Adjust(Looper) = 0 THEN Adjust(Looper) = Looper + LEN(password$)
  NEXT Looper

  
  'Now check if any adjusts are the same
  NotYet% = 1
  DO WHILE NotYet%
    NotYet% = 0
    FOR Loop1 = 1 TO 4
      FOR Loop2 = 1 TO 4
        'Don't compare same items
        IF Loop1 <> Loop2 THEN
          
          'Check for a match
          IF Adjust(Loop1) = Adjust(Loop2) THEN
            Adjust(Loop2) = Adjust(Loop2) + LEN(password$)
            
            'Make sure we didn't make it zero
            IF Adjust(Loop2) = 0 THEN Adjust(2) = Adjust(Loop2) + LEN(password$)
            
            NotYet% = 1
          END IF

        END IF
      NEXT Loop2
    NEXT Loop1
  LOOP


  
  
  'Encode or deocde
  Counts = 0: Looper = 0

  'Loop until scanned though the whole file
  DO WHILE Looper < LEN(strng$)
    
    'Add to Looper
    Looper = Looper + 1

    'Keep Adjust code Counts from 1 to 4
    Counts = Counts + 1
    IF Counts = 5 THEN Counts = 1
    
    'Get the character to change
    ToChange = ASC(MID$(strng$, Looper, 1))
    
    'ENCODE   Flag%=0
    IF Flag% = 0 THEN
      
      'If adjustment to high or low then reverse the coding and
      'add in a chr$(255) to mark the change
      IF ToChange - Adjust(Counts) < 1 OR ToChange - Adjust(Counts) > 254 THEN
        
        Addin$ = CHR$(255) + CHR$(ToChange + Adjust(Counts))
        strng$ = LEFT$(strng$, Looper - 1) + Addin$ + MID$(strng$, Looper + 1)
        Looper = Looper + 1
      
      'If adjustment OK then just cahnge the character
      ELSE
        
        MID$(strng$, Looper, 1) = CHR$(ToChange - Adjust(Counts))

      END IF

    'DECODE  Flag% <> 0
    ELSE
      
      'If find a CHR$(255) then remove it and set Flag255% to
      'ensure reverse codes on next pass reverse coding
      IF ToChange = 255 THEN
        
        strng$ = LEFT$(strng$, Looper - 1) + MID$(strng$, Looper + 1)
        Flag255% = 1
        'Since CHR$(255) was removed we need to back up Looper
        'and Counts because characters all shifted to the left
        Looper = Looper - 1
        Counts = Counts - 1
      
      'If not CHR$(255) then decode watching if Flag255% is set
      ELSE
        IF Flag255% = 1 THEN
          MID$(strng$, Looper, 1) = CHR$(ToChange - Adjust(Counts))
          Flag255% = 0
        ELSE
          MID$(strng$, Looper, 1) = CHR$(ToChange + Adjust(Counts))
        END IF
      END IF

    END IF
    
  LOOP

  
  
  
  'Set function equal to changed string
  IF Flag% = 0 THEN
    
    'Tack on CHR$(255) to end so it can be recognized as encoded
    KTEncrypt$ = strng$ + STRING$(5, 255)

  ELSE
    
    KTEncrypt$ = strng$
  
  END IF

  'Make sure Errors$ is cleared
  Errors$ = ""

  EXIT FUNCTION



ErrorHandler:
  SELECT CASE ERR

    'Illegal Function Call --> out of range ASCII code
    CASE 5
      Errors$ = "INVALID PASSWORD!"

    'Is there Password??
    CASE 100
      Errors$ = "NO PASSWORD!"
      
    'Is there a strng$ to work with?
    CASE 110
      Errors$ = "NO STRING!"

    'Encoding a encoded file?
    CASE 120
      IF UCASE$(Errors$) = "FORCE" THEN
        RESUME NEXT
      ELSE
        Errors$ = "FILE ALREADY ENCODED!"
      END IF

    'Decoding a non-encoded file?
    CASE 130
      IF UCASE$(Errors$) = "FORCE" THEN
        RESUME NEXT
      ELSE
        Errors$ = "FILE NOT ENCODED!"
      END IF
    
    'Unanticipated
    CASE ELSE
      Errors$ = STR$(ERR)

  END SELECT
  
  KTEncrypt$ = original$
  EXIT FUNCTION

END FUNCTION

