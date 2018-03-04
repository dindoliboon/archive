# =========================================================================
#
#       NAME: Instructor
#       DATE: May 30, 2001
# ASSIGNMENT: Class Example #2, CSC-201-01
#  OBJECTIVE: Display the number of vowels in a string
#
# =========================================================================

.text

main:

# =========================================================================
#
# $a0 - points to the string
#
# =========================================================================
# :::::	OP ::::	ARGUMENTS :::::::::::::	COMMENTS ::::::::::::::::::::::::::
# =========================================================================

	la	$a0, str		# store str into $a0
	jal	vcount			# $v0 = calls vcount($a0)

	move	$a0, $v0		# move $v0 into $a0
	li	$v0, 1			# load print int
	syscall				# print answer

	la	$a0, endl		# store new line into $a0
	li	$v0, 4			# load print string
	syscall				# print newline

	li	$v0, 10			# load exit program
	syscall				# exit the program

# =========================================================================
# PURPOSE: vowelp - takes a single character as a parameter and return 1 if
#          the character is a (lower case) vowel otherwise return 0.
#   INPUT: $a0 - holds characters
#  OUTPUT: $v0 - returns 0 or 1
# =========================================================================

vowelp:

	li	$v0, 0			# store 0 as default value
	beq	$a0, 'a', yes		# if a0 = a, v0 = 1
	beq	$a0, 'e', yes		# if a0 = e, v0 = 1
	beq	$a0, 'i', yes		# if a0 = i, v0 = 1
	beq	$a0, 'o', yes		# if a0 = o, v0 = 1
	beq	$a0, 'u', yes		# if a0 = u, v0 = 1
	beq	$a0, 'A', yes		# if a0 = A, v0 = 1
	beq	$a0, 'E', yes		# if a0 = E, v0 = 1
	beq	$a0, 'I', yes		# if a0 = I, v0 = 1
	beq	$a0, 'O', yes		# if a0 = O, v0 = 1
	beq	$a0, 'U', yes		# if a0 = U, v0 = 1
	jr	$ra			# return to caller

yes:

	li	$v0, 1			# vowel available, true
	jr	$ra			# return to caller

# =========================================================================
# PURPOSE: vcount - use vowelp to count the vowels in a string.
#   INPUT: $a0 - holds string address
#          $s0 - holds number of vowels
#  OUTPUT: $v0 - returns number of vowels
# =========================================================================

vcount:

	sub	$sp, $sp, 16		# save register on stack
	sw	$a0, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$ra, 12($sp)

	li	$s0, 0			# count of vowels
	move	$s1, $a0		# address of string

nextc:

	lb	$a0, ($s1)		# get next character
	beqz	$a0, done		# zero marks end
	jal	vowelp			# calls vowelp
	add	$s0, $s0, $v0		# add 0 or 1 to count
	add	$s1, $s1, 1		# move along string
	b	nextc			# branch to nextc

done:

	move	$v0, $s0		# use v0 for result	

	lw	$a0, 0($sp)		# restore register
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$ra, 12($sp)
	add	$sp, $sp, 16
	jr	$ra

# =========================================================================
# :::::::::::::::::::::::::::::: data segment :::::::::::::::::::::::::::::
# =========================================================================

.data
str:  .asciiz "long time ago in a galaxy far away"
endl: .asciiz "\n"

# =========================================================================
# :::::::::::::::::::::::::::: END OF PROGRAM! ::::::::::::::::::::::::::::
# =========================================================================
