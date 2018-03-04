# =========================================================================
#
#       NAME: 
#       DATE: May 23, 2001
# ASSIGNMENT: Homework #1, CSC-201-01
#  OBJECTIVE: Read an integer from the keyboard and double the number. Then
#             double the result. Finally, subtract the input number from
#             the quadrupled number. The number should be shown each time
#             a mathematical operation has been applied.
#
# =========================================================================

.data
.align 2

# =========================================================================

prompt1: .asciiz "Enter a number: "
prompt2: .asciiz " Input doubled: "
prompt3: .asciiz "Doubled result: "
prompt4: .asciiz "  Final answer: "
newline: .asciiz "\n"

# =========================================================================

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
	syscall				# print "  Final answer: "

	move	$a0, $t3
	li	$v0, 1
	syscall				# print doubled number

	la	$a0, newline
	li	$v0, 4
	syscall				# print new line

# =========================================================================

	li	$v0, 10
	syscall				# exit program

# =========================================================================
# :::::::::::::::::::::::::::: END OF PROGRAM! ::::::::::::::::::::::::::::
# =========================================================================
