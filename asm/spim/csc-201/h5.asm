# =========================================================================
#
#       NAME: 
#       DATE: June 04, 2001
# ASSIGNMENT: Homework #5, CSC-201-01
#  OBJECTIVE: Read a set of non-negative integers from the keyboard and
#             printout the number of times each integer occurs in the input
#             stream. Assume the integers are in accending order. The last
#             integer, must be a negative number. This will indicate the
#             end of the input. If only a negative number is entered,
#             display a message notifing the user that only positive
#             integers are allowed.
#
# =========================================================================

.data
.align 2

# =========================================================================

prompt1: .ascii  "You made a booboo, because the program's "
         .asciiz "input value must be positive integer.\n"
prompt2: .asciiz "Enter non-negative integers (negative to quit).\n"
prompt3: .asciiz " occurs "
prompt4: .asciiz " times\n"

# =========================================================================

.text
.align 2

main:

# =========================================================================
#
# $s0 - counter
# $t0 - current integer
# $t1 - previous integer
#
# =========================================================================
# :::::	OP ::::	ARGUMENTS :::::::::::::	COMMENTS ::::::::::::::::::::::::::
# =========================================================================

	la	$a0, prompt2
	li	$v0, 4
	syscall				# print "Enter number"

	li	$s0, 0			# counter          = 0
	li	$t0, 0			# current integer  = 0
	li	$t1, 0			# previous integer = 0

# =========================================================================

Read_Num:

	li	$v0, 5
	syscall				# get number from keyboard

	move	$t0, $v0		# save current integer

	bgt	$t0, -1, Else		# check if current > -1
	beq	$s0, 0, BooBoo		# exit if negative

	jal	ShowResult		# display occurance

	j	Read_Num_End		# exit loop

# =========================================================================

Else:

	beq	$s0, 0, IncrCntr	# if counter = 0, cnt += 1
	beq	$t1, $t0, IncrCntr	# if previous = current, cnt += 1

	jal	ShowResult		# display occurance

	li	$s0, 1			# reset counter to 1
	move	$t1, $t0		# previous = current
	j	Read_Num		# jump to beginning of loop

# =========================================================================

IncrCntr:

	add	$s0, $s0, 1		# increment counter
	move	$t1, $t0		# previous = current
	j	Read_Num		# jump to beginning of loop

# =========================================================================

BooBoo:

	li	$v0, 4
	la	$a0, prompt1
	syscall				# print "error message"

	j	Read_Num_End		# exit loop

# =========================================================================

ShowResult:

	move	$a0, $t1
	li	$v0, 1
	syscall				# print previous integer

	la	$a0, prompt3
	li	$v0, 4
	syscall				# print " occurs "

	move	$a0, $s0
	li	$v0, 1
	syscall				# print occurance

	la	$a0, prompt4
	li	$v0, 4
	syscall				# print " times\n"

	jr	$ra			# return to caller

# =========================================================================

Read_Num_End:

# =========================================================================

	li	$v0, 10
	syscall				# exit the program

# =========================================================================
# :::::::::::::::::::::::::::: END OF PROGRAM! ::::::::::::::::::::::::::::
# =========================================================================
