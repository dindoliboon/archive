# =========================================================================
#
#       NAME: 
#       DATE: June 06, 2001
# ASSIGNMENT: Test #2, CSC-201-01
#  OBJECTIVE: Find the discriminant of the quadratic equation b^2 - 4ac.
#
# =========================================================================

.data
.align 2

# =========================================================================

asc1:    .asciiz "There is no real solution\n"
asc2:    .asciiz "There is two unique solutions\n"
asc3:    .asciiz "There is one solution that is doubled\n"
prm1:    .asciiz "Enter A: "
prm2:    .asciiz "Enter B: "
prm3:    .asciiz "Enter C: "

# =========================================================================

.text
.align 2

# =========================================================================
# PURPOSE: Obtain 3 numbers from the keyboard.
#   INPUT: n/a
#  OUTPUT: $s0 = A, $s1 = B, $s2 = C
# =========================================================================

input:

	la	$a0, prm1
	li	$v0, 4
	syscall				# print "Enter A"

	li	$v0, 5
	syscall				# get A

	move	$s0, $v0		# store A in $s0

	la	$a0, prm2
	li	$v0, 4
	syscall				# print "Enter B"

	li	$v0, 5
	syscall				# get B

	move	$s1, $v0		# store B in $s1

	la	$a0, prm3
	li	$v0, 4
	syscall				# print "Enter C"

	li	$v0, 5
	syscall				# get C

	move	$s2, $v0		# store C in $s2

	jr	$ra			# return to caller

# =========================================================================
# PURPOSE: Execute the quadratic equation
#   INPUT: n/a
#  OUTPUT: $t0 = answer
# =========================================================================

multiply:

	mul	$t0, $s0, $s2		# $t0 = A * C
	mul	$t0, $t0, 4		# $t0 = $t0 * 4
	mul	$t1, $s1, $s1		# $t1 = B * B
	sub	$t0, $t1, $t0		# $t0 = $t1 - $t0

	blt	$t0, 0, les0		# if $t0 < 0, goto les0
	bgt	$t0, 0, gre0		# if $t0 > 0, goto gre0

	la	$a0, asc3		# load "one solution doubled"
	j	print			# since its not 0 < or > 0.

les0:

	la	$a0, asc1		# load "no solution"
	j	print

gre0:

	la	$a0, asc2		# load "two unique solutions"

print:

	li	$v0, 4
	syscall				# print message
	
	jr	$ra			# return to caller


# =========================================================================
# PURPOSE: Call input & multiply functions. Exit program.
#   INPUT: n/a
#  OUTPUT: n/a
# =========================================================================
	
main:

	jal	input			# call input function
	jal	multiply		# call multiply function

	li	$v0, 10
	syscall				# exit the program

# =========================================================================
# :::::::::::::::::::::::::::: END OF PROGRAM! ::::::::::::::::::::::::::::
# =========================================================================
