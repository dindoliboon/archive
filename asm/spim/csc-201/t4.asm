# =========================================================================
#
#       NAME: 
#       DATE: June 18, 2001
# ASSIGNMENT: Test #4, CSC-201-01
#  OBJECTIVE: Read a list of grades from a data file and find the
#             trunciate average, max, and min value of the list, and
#             amount of A's, B's, C's, D's, and F's in the list
#
# =========================================================================
# $t7 - counter
# $t8 - check
# $t9 - sum
# $s0 - avg
# $s1 - min
# $s2 - max
# $s3 - A
# $s4 - B
# $s5 - C
# $s6 - D
# $s7 - F
# ======================================================================

.data
.align 2
newline:  .asciiz "\n"
prompt1:  .asciiz "Enter a list of non-negative numbers, one at a time\n"
prompt2:  .asciiz "The maximum number is "
prompt3:  .asciiz "The mimimum number is "
prompt4:  .asciiz "The data file is empty\n"
prompt5:  .asciiz "The trunicated average is "
prompt6:  .asciiz "The amount of A's were "
prompt7:  .asciiz "The amount of B's were "
prompt8:  .asciiz "The amount of C's were "
prompt9:  .asciiz "The amount of D's were "
prompt10: .asciiz "The amount of F's were "

.text
.align 2

# ======================================================================
# PURPOSE: Exits the application
# ======================================================================

exit:
	li	$v0, 10
	syscall					# exit the program


# ======================================================================
# PURPOSE: Reads a list of non-negative numbers from the keyboard
# ======================================================================

read_num:
	la	$a0, prompt1
	li	$v0, 4
	syscall					# print "enter list"

	add	$t7, $zero, $zero		# counter = 0 + 0
	add	$t8, $zero, $zero		# check   = 0 + 0
	add	$t9, $zero, $zero		# sum     = 0 + 0
	add	$s0, $zero, $zero		# avg     = 0 + 0
	add	$s1, $zero, $zero		# min     = 0 + 0
	add	$s2, $zero, $zero		# max     = 0 + 0
	add	$s3, $zero, $zero		# A       = 0 + 0
	add	$s4, $zero, $zero		# B       = 0 + 0
	add	$s5, $zero, $zero		# C       = 0 + 0
	add	$s6, $zero, $zero		# D       = 0 + 0
	add	$s7, $zero, $zero		# F       = 0 + 0

loop:
	li	$v0, 5
	syscall					# read in integer

	blt	$v0, 0, exit_loop		# if $v0 < 0 goto exit_loop

	add	$t9, $t9, $v0			# sum = sum + input
	add	$t7, $t7, 1			# increment counter by one

	beq	$t8, $zero, set_value		# if check = 0, setup values
	j	test_numbers			# values already setup, skip

set_value:
	add	$s1, $zero, $v0			# min   = input
	add	$s2, $zero, $v0			# max   = input
	add	$t8, $zero, 1			# check = 1

test_numbers:
	blt	$v0, $s1, set_min		# if input < min, goto set_min
	bgt	$v0, $s2, set_max		# if input > max, goto set_max
	j	check_grade			# if none, skip

set_min:
	add	$s1, $zero, $v0			# min   = input
	j	check_grade

set_max:
	add	$s2, $zero, $v0			# max   = input
	j	check_grade

check_grade:
	bgt	$v0, 89, grade_a		# if $v0 == A goto grade_a
	bgt	$v0, 79, grade_b		# if $v0 == B goto grade_b
	bgt	$v0, 69, grade_c		# if $v0 == C goto grade_c
	bgt	$v0, 59, grade_d		# if $v0 == D goto grade_d

	add	$s7, $s7, 1			# increment F by one

	j	loop				# read more numbers

grade_a:
	add	$s3, $s3, 1			# increment A by one
	j	loop

grade_b:
	add	$s4, $s4, 1			# increment B by one
	j	loop

grade_c:
	add	$s5, $s5, 1			# increment C by one
	j	loop

grade_d:
	add	$s6, $s6, 1			# increment D by one
	j	loop

exit_loop:
	jr	$ra				# return to caller

# ======================================================================
# PURPOSE: Displays results
# ======================================================================
results:
	beq	$t7, $zero, empty		# if counter == 0, empty!
	j	print_results			# otherwise, print results

empty:
	la	$a0, prompt4
	li	$v0, 4
	syscall					# print "empty"

	jr	$ra				# return to caller

print_results:
	div	$s0, $t9, $t7			# average = sum / counter

	la	$a0, prompt2
	li	$v0, 4
	syscall					# print "max is ..."

	add	$a0, $zero, $s2
	li	$v0, 1
	syscall					# print max

	la	$a0, newline
	li	$v0, 4
	syscall					# print new line

	la	$a0, prompt3
	li	$v0, 4
	syscall					# print "min is ..."

	add	$a0, $zero, $s1
	li	$v0, 1
	syscall					# print min

	la	$a0, newline
	li	$v0, 4
	syscall					# print new line

	la	$a0, prompt5
	li	$v0, 4
	syscall					# print "avg is ..."

	add	$a0, $zero, $s0
	li	$v0, 1
	syscall					# print avg

	la	$a0, newline
	li	$v0, 4
	syscall					# print new line

	la	$a0, prompt6
	li	$v0, 4
	syscall					# print "A is ..."

	add	$a0, $zero, $s3
	li	$v0, 1
	syscall					# print A

	la	$a0, newline
	li	$v0, 4
	syscall					# print new line

	la	$a0, prompt7
	li	$v0, 4
	syscall					# print "B is ..."

	add	$a0, $zero, $s4
	li	$v0, 1
	syscall					# print B
	
	la	$a0, newline
	li	$v0, 4
	syscall					# print new line

	la	$a0, prompt8
	li	$v0, 4
	syscall					# print "C is ..."

	add	$a0, $zero, $s5
	li	$v0, 1
	syscall					# print C

	la	$a0, newline
	li	$v0, 4
	syscall					# print new line

	la	$a0, prompt9
	li	$v0, 4
	syscall					# print "D is ..."

	add	$a0, $zero, $s6
	li	$v0, 1
	syscall					# print D

	la	$a0, newline
	li	$v0, 4
	syscall					# print new line

	la	$a0, prompt10
	li	$v0, 4
	syscall					# print "F is ..."

	add	$a0, $zero, $s7
	li	$v0, 1
	syscall					# print F

	la	$a0, newline
	li	$v0, 4
	syscall					# print new line

	jr	$ra				# return to caller

# ======================================================================
# PURPOSE: Calls other procedures, exits program
# ======================================================================

main:
	jal	read_num			# call read number
	jal	results				# call display results

	j	exit				# exit program
	
# ======================================================================
# ::::::::::::::::::::::::::: END OF PROGRAM :::::::::::::::::::::::::::
# ======================================================================
