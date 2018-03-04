# =========================================================================
#
#       NAME: 
#       DATE: May 28, 2001
# ASSIGNMENT: Homework #2, CSC-201-01
#  OBJECTIVE: Read an integer from the keyboard and quadruple the number.
#             Then subtract the quadrupled number by the input number. Then
#             apply an if/then statement. If the number is equal to 10,
#             multiply by 3 and subtract by 50. If the number is less than
#             10, multiply by 2 and print "That's all folks". Otherwise,
#             multiply by 4 and subtract by 6. The number should be shown
#             each time a mathematical operation has been applied, except
#             for the if/then statements. The final result must be shown.
#
# =========================================================================

.data
.align 2

prompt1: .asciiz "   Enter a number: "
prompt2: .asciiz "    Input doubled: "
prompt3: .asciiz "   Doubled result: "
prompt4: .asciiz "Subtracted result: "
prompt5: .asciiz "That's all folks\n"
prompt6: .asciiz "The output is "
newline: .asciiz "\n"

.text
.align 2

main:

# =========================================================================
#
# $t0 - input number
# $t1 - input number * 2
# $t2 - input number * 4
# $t3 - input number * 4 - input number
#
# =========================================================================
# :::::	OP ::::	ARGUMENTS :::::::::::::	COMMENTS ::::::::::::::::::::::::::
# =========================================================================

	la	$a0, prompt1
	li	$v0, 4
	syscall				# print "Enter a number: "

	li	$v0, 5
	syscall				# read number from keyboard

	move	$t0, $v0		# save orginal number

# =========================================================================

	add	$t1, $t0, $t0		# double = input + input

	la	$a0, prompt2
	li	$v0, 4
	syscall				# print " Input doubled: "

	move	$a0, $t1
	li	$v0, 1
	syscall				# print doubled number

	la	$a0, newline
	li	$v0, 4
	syscall				# print new line

# =========================================================================

	add	$t2, $t1, $t1		# quadruple = double + double

	la	$a0, prompt3
	li	$v0, 4
	syscall				# print "Doubled result: "

	move	$a0, $t2
	li	$v0, 1
	syscall				# print doubled number

	la	$a0, newline
	li	$v0, 4
	syscall				# print new line

# =========================================================================

	sub	$t3, $t2, $t0		# answer = quadruple - input

	la	$a0, prompt4
	li	$v0, 4
	syscall				# print "Subtracted result: "

	move	$a0, $t3
	li	$v0, 1
	syscall				# print doubled number

	la	$a0, newline
	li	$v0, 4
	syscall				# print new line

# =========================================================================
#
# $t0 - input number
# $t1 - result
#
# =========================================================================

	beq	$t0, 10, equal10	# if input = 10, goto equal10
	j	equal10_end

equal10:

	add	$t1, $t0, $t0		# answer = input + input
	add	$t1, $t1, $t0		# answer = answer + input
	sub	$t1, $t1, 50		# answer = answer - 50

equal10_end:

# =========================================================================

	blt	$t0, 10, less10		# if input < 10, goto less10
	j	less10_end

less10:

	add	$t1, $t0, $t0		# answer = input + input

	la	$a0, prompt5
	li	$v0, 4
	syscall				# print "That's all folks"

less10_end:

# =========================================================================

	bgt	$t0, 10, big10		# if input > 10, goto big10
	j	big10_end

big10:

	add	$t1, $t0, $t0		# answer = input + input
	add	$t1, $t1, $t0		# answer = answer + input
	add	$t1, $t1, $t0		# answer = answer + input
	sub	$t1, $t1, 6		# answer = answer - 6

big10_end:

# =========================================================================

	la	$a0, prompt6
	li	$v0, 4
	syscall				# print "The output is "

	move	$a0, $t1
	li	$v0, 1
	syscall				# print final answer

	la	$a0, newline
	li	$v0, 4
	syscall				# print new line

# =========================================================================

	li	$v0, 10
	syscall				# exit program

# =========================================================================
# :::::::::::::::::::::::::::: END OF PROGRAM! ::::::::::::::::::::::::::::
# =========================================================================
