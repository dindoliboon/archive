# =========================================================================
#
#       NAME: Instructor
#       DATE: June 13, 2001
# ASSIGNMENT: Class Example #3, CSC-201-01
#  OBJECTIVE: Leaf example
#
# =========================================================================

.data
.align 2

# =========================================================================

prompt1: .asciiz "Enter 4 integers:\n"
prompt2: .asciiz "The answer to (g + h) - (i + j) is "
newline: .asciiz "\n"

# =========================================================================
# :::::	OP ::::	ARGUMENTS :::::::::::::	COMMENTS ::::::::::::::::::::::::::
# =========================================================================

.text
.align 2

# =========================================================================
# PURPOSE: Adds four numbers and subtracts them
#   INPUT: $a0, $a1, $a2, $a3
#  OUTPUT: $v0
# =========================================================================

leaf_example:
	sub	$s0, $sp, 12		# adjust stack for 3 items
	sw	$t1, 8($sp)		# save register $t1
	sw	$t0, 4($sp)		# save register $t0
	sw	$s0, 0($sp)		# save register $s0

	add	$t0, $a0, $a1		# registers $t0
	add	$t1, $a2, $a3		# registers $t1
	sub	$s0, $t0, $t1		# f = $t0 - $t1
	
	add	$v0, $s0, $zero		# returns f ($v0 = $s0 + 0)

	lw	$s0, 0($sp)		# restore register $s0
	lw	$t0, 4($sp)		# restore register $t0
	lw	$t1, 8($sp)		# restore register $t1
	add	$sp, $sp, 12		# adjust stack to delete 3 items

	jr	$ra			# return to caller

# =========================================================================

main:

# =========================================================================
#
# $a0 - g
# $a1 - h
# $a2 - i
# $a3 - j
#
# =========================================================================

	la	$a0, prompt1
	li	$v0, 4
	syscall				# print "Enter 4 numbers"

	li	$v0, 5
	syscall				# read number from keyboard
	move	$a0, $v0		# store g

	li	$v0, 5
	syscall				# read number from keyboard
	move	$a1, $v0		# store h

	li	$v0, 5
	syscall				# read number from keyboard
	move	$a2, $v0		# store i

	li	$v0, 5
	syscall				# read number from keyboard
	move	$a3, $v0		# store j

	add	$t0, $t0, 10
	jal	leaf_example		# $v0 = leaf_example($a0)

	la	$a0, prompt2
	li	$v0, 4
	syscall				# print "The answer"

	move	$a0, $v0		# move $v0 into $a0
	li	$v0, 1			# load print int
	syscall				# print answer

	la	$a0, newline
	li	$v0, 4
	syscall				# print newline

	li	$v0, 10			# load exit program
	syscall				# exit the program

# =========================================================================
# :::::::::::::::::::::::::::: END OF PROGRAM! ::::::::::::::::::::::::::::
# =========================================================================
