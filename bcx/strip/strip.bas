CALL OpenInput(COMMAND$)

SUB OpenInput(file$)
	DIM backup$, buffer$
	DIM size1#, size2#, result#

	IF EXIST(file$) <> -1 THEN
		PRINT "Input file does not exist!"
		EXIT SUB
	ELSE
		backup$ = CreateBackup$(file$)
	END IF

	size1# = LOF(backup$)
	size2# = 0.0
	result# = 0.0

	OPEN backup$ FOR INPUT AS FP1
	OPEN file$ FOR BINARY NEW AS FP2
		WHILE NOT EOF(FP1)
			LINE INPUT FP1, buffer$

			buffer$ = TRIM$(buffer$)
			size2# = size2# + LEN(buffer$) + 1.0

			PUT$ FP2, buffer$, LEN(buffer$)
			PUT$ FP2, CHR$(10), 1
		WEND
	CLOSE FP2
	CLOSE FP1

	IF size2 > size1 THEN
		PRINT "Woah, this should not happen!"
		PRINT "The output is larger than the input!"
	ELSEIF size2 = size1 THEN
		PRINT "There was no change in size"
	ELSE
		result# = (size2# / size1#)
		PRINT "The output file is smaller by", 100.0 - (result# * 100.0), "%"
	END IF
END SUB

FUNCTION CreateBackup$(file$)
	DIM buffer$
	DIM counter

	counter = 0
	DO
		buffer$ = file$ & "." & TRIM$(STR$(counter))

		IF EXIST(buffer$) = -1 THEN
			INCR counter
		ELSE
			COPYFILE file$, buffer$
			EXIT LOOP
		END IF
	LOOP

	FUNCTION = buffer$
END FUNCTION
