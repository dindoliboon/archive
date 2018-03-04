DIM value AS LONG
DIM result AS LONG

value = VAL(COMMAND$)
result = fibonacci(value)

PRINT "The answer is", STR$(result)

FUNCTION fibonacci(sequence)
	IF sequence = 0 OR sequence = 1 THEN
		FUNCTION = sequence
	ELSE
		FUNCTION = fibonacci(sequence - 1) + fibonacci(sequence - 2)
	END IF
END FUNCTION
