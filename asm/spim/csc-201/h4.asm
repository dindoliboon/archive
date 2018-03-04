# =========================================================================
#
#       NAME: 
#       DATE: May 30, 2001
# ASSIGNMENT: Homework #4, CSC-201-01
#  OBJECTIVE: Read any amount of numbers from the keyboard. Find the total
#             sum and product for the numbers. Also print the amount of
#             numbers given.
#
# =========================================================================

.data
.align 2

prompt1: .asciiz "Enter any amount of numbers (0 to exit)\n"
prompt2: .asciiz "The sum is "
prompt3: .asciiz "The product is "
prompt4: .asciiz "The number of integers entered was "
newline: .asciiz "\n"

.text
.align 2

main:

# =========================================================================
#
# $t0 - counter
# $t1 - sum
# $t2 - product
#
# =========================================================================
# :::::	OP ::::	ARGUMENTS :::::::::::::	COMMENTS ::::::::::::::::::::::::::
# =========================================================================

	la	$a0, prompt1
	li	$v0, 4
	syscall				# print "Enter 4 numbers.\n"

	li	$t0, 0			# counter = 0
	li	$t1, 0			# sum = 0
	li	$t2, 1			# product = 1

# =========================================================================

read_number:

	li	$v0, 5
	syscall				# read integer

	beq	$v0, 0, check		# exit if not a number or 0

	add	$t0, $t0, 1		# increment counter
	add	$t1, $t1, $v0		# store sum
	mul	$t2, $t2, $v0		# store product

	j	read_number		# jump to beginning of loop

check:
	bne	$t0, 0, read_number_e	# exit if numbers were entered
	li	$t2, 0			# product = 0

read_number_e:

# =========================================================================

	la	$a0, prompt2
	li	$v0, 4
	syscall				# print "The sum is "

	move	$a0, $t1
	li	$v0, 1
	syscall				# print sum

	la	$a0, newline
	li	$v0, 4
	syscall				# print new line

# =========================================================================

	la	$a0, prompt3
	li	$v0, 4
	syscall				# print "The product is "

	move	$a0, $t2
	li	$v0, 1
	syscall				# print product

	la	$a0, newline
	li	$v0, 4
	syscall				# print new line

# =========================================================================

	la	$a0, prompt4
	li	$v0, 4
	syscall				# print "The number of ... "

	move	$a0, $t0
	li	$v0, 1
	syscall				# print counter

	la	$a0, newline
	li	$v0, 4
	syscall				# print new line

# =========================================================================

	li	$v0, 10
	syscall				# exit program

# =========================================================================
# :::::::::::::::::::::::::::: END OF PROGRAM! ::::::::::::::::::::::::::::
# =========================================================================
