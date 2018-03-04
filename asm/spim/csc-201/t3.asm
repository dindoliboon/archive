# =========================================================================
#
#       NAME: 
#       DATE: June 13, 2001
# ASSIGNMENT: Test #3, CSC-201-01
#  OBJECTIVE: Find min/max values
#
# =========================================================================

.data
.align 2

# =========================================================================

newline: .asciiz "\n"
prompt1: .asciiz "Enter 10 integers\n"
prompt2: .asciiz "Min value is: "
prompt3: .asciiz "Max value is: "

# =========================================================================

.text
.align 2

# =========================================================================
# PURPOSE: Read a set of 10 integers and find min/max values
#   INPUT: n/a
#  OUTPUT: n/a
# =========================================================================
# $t0 - counter
# $t1 - last value
# $t2 - test value
# $s0 - min
# $s1 - max
# =========================================================================

proc_1:

	la	$a0, prompt1
	li	$v0, 4
	syscall				# print "Enter numbers"

	add	$t0, $zero, $zero
	add	$t1, $zero, $zero
	add	$t2, $zero, $zero
	add	$s0, $zero, $zero
	add	$s1, $zero, $zero	# initalize values to 0

read:

	beq	$t0, 10, reade		# exit if counter is equal to 10

	li	$v0, 5
	syscall				# read integer

	move	$t1, $v0		# save last value

	add	$t0, $t0, 1		# increment counter

	beq	$t2, 0, enable0		# if $t2 == 0, goto enable0
	j	noenable

enable0:
	add	$t2, $zero, 1		# set temp to 1

	add	$s0, $zero, $t0		# save last value
	add	$s1, $zero, $t0		# save last value
noenable:

	bgt	$t1, $s1, set_max	# if input > max, goto set_max
	blt	$t1, $s0, set_min	# if input < min, goto set_min

	j	read			# jump to beginning of loop

set_max:
	add	$s1, $t1, $zero		# save max
	j	read

set_min:
	add	$s0, $t1, $zero		# save min
	j	read

reade:
	jr	$ra

# =========================================================================
# PURPOSE: Display min/max values
#   INPUT: n/a
#  OUTPUT: n/a
# =========================================================================

proc_2:

	la	$a0, prompt2
	li	$v0, 4
	syscall				# print "Min is ..."

	add	$a0, $s0, $zero
	li	$v0, 1
	syscall				# print min


	la	$a0, newline
	li	$v0, 4
	syscall				# print newline

	la	$a0, prompt3
	li	$v0, 4
	syscall				# print "Max is ..."

	add	$a0, $s1, $zero
	li	$v0, 1
	syscall				# print max

	la	$a0, newline
	li	$v0, 4
	syscall				# print newline

	jr	$ra

# =========================================================================
# PURPOSE: Call min/max values and print integers
#   INPUT: n/a
#  OUTPUT: n/a
# =========================================================================

main:
	jal	proc_1			# get min/max values
	jal	proc_2			# display min/max values

	li	$v0, 10
	syscall				# exit the program

# =========================================================================
# :::::::::::::::::::::::::::: END OF PROGRAM! ::::::::::::::::::::::::::::
# =========================================================================
