DIM szInput$

INPUT "Please type in your name: ", szInput$
IF LEN(szInput$) = 0 THEN
	szInput$ = "anonymous"
END IF

PRINT "Hello ", szInput$, ", how are you doing?"
