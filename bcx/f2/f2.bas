DIM value AS LONG
DIM result AS LONG

value = VAL(COMMAND$)
result = fibonacci(1, 0, value)

PRINT "The answer is", STR$(result)

FUNCTION fibonacci(first, second, sequence)
	IF sequence = 0 THEN
		FUNCTION = second
	ELSE
		FUNCTION = fibonacci(first + second, first, sequence - 1)
	END IF
END FUNCTION