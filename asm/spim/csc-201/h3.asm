# =========================================================================
#
#       NAME: 
#       DATE: May 30, 2001
# ASSIGNMENT: Homework #3, CSC-201-01
#  OBJECTIVE: Read 4 numbers from the keyboard. Find the total sum and
#             product for the numbers.
#
# =========================================================================

.data
.align 2

prompt1: .asciiz "Enter 4 numbers.\n"
prompt2: .asciiz "The sum is "
prompt3: .asciiz "The product is "
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

	beq	$t0, 4, read_number_e	# exit if counter is equal to 4

	li	$v0, 5
	syscall				# read integer

	add	$t0, $t0, 1		# increment counter
	add	$t1, $t1, $v0		# store sum
	mul	$t2, $t2, $v0		# store product

	j	read_number		# jump to beginning of loop

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

	li	$v0, 10
	syscall				# exit program

# =========================================================================
# :::::::::::::::::::::::::::: END OF PROGRAM! ::::::::::::::::::::::::::::
# =========================================================================
