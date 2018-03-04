# =========================================================================
#
#       NAME: 
#       DATE: June 11, 2001
# ASSIGNMENT: Homework #7, CSC-201-01
#  OBJECTIVE: Compute the nth Fibonacci number F(n) where
#             F(n) = 0, if n = 0
#             F(n) = 1, if n = 1
#             F(n) = F(n-1) + F(n-2), otherwise
#
# =========================================================================

.data
.align 2

# =========================================================================

prompt1: .asciiz "Enter integer: "
prompt2: .asciiz " is the correct answer.\n"

# =========================================================================

.text
.align 2

# =========================================================================
# PURPOSE: Fibonacci procedure
#   INPUT: $a0 - a, $a1 - b, $a2 - count
#  OUTPUT: $v0 - value
# =========================================================================

fab:
	beq	$a2, 0, equ0		# if count == 0, goto equ0
	addi	$a2, $a2, -1		# count = count - 1
	add	$t0, $a1, 0		# temp = b
	add	$a1, $a0, 0		# b = a
	add	$a0, $t0, $a0		# a = temp + b
	j fab

equ0:
	add	$v0, $a1, 0		# $v0 = b
	jr	$ra			# return to caller

# =========================================================================
# PURPOSE: Fibonacci procedure. Exit program.
#   INPUT: n/a
#  OUTPUT: n/a
# =========================================================================

main:
	la	$a0, prompt1
	li	$v0, 4
	syscall				# print "Enter integer"

	li	$v0, 5
	syscall				# read integer

	li	$a0, 1			# store first argument
	li	$a1, 0			# store second argument
	add	$a2, $v0, 0		# store third argument

	jal	fab			# call fab function

	add	$a0, $v0, 0
	li	$v0, 1
	syscall				# print answer

	la	$a0, prompt2
	li	$v0, 4
	syscall				# print " is the answer"

	li	$v0, 10
	syscall				# exit the program

# =========================================================================
# :::::::::::::::::::::::::::: END OF PROGRAM! ::::::::::::::::::::::::::::
# =========================================================================
