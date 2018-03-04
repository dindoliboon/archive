# =========================================================================
#
#       NAME: 
#       DATE: June 06, 2001
# ASSIGNMENT: Homework #6, CSC-201-01
#  OBJECTIVE: Find C^2. C^2 = A^2 + B^2. Use procedure calls.
#
# =========================================================================

.data
.align 2

# =========================================================================

prompt1: .asciiz "Enter A: "
prompt2: .asciiz "Enter B: "
prompt3: .asciiz "C^2 = "
newline: .asciiz "\n"

# =========================================================================

.text
.align 2

# =========================================================================
# PURPOSE: Obtain 2 numbers from the keyboard.
#   INPUT: n/a
#  OUTPUT: $s0 = A^2, $s1 = B^2
# =========================================================================

input:
	la	$a0, prompt1
	li	$v0, 4
	syscall				# print "Enter A"

	li	$v0, 5
	syscall				# get A

	mul	$s0, $v0, $v0		# square A

	la	$a0, prompt2
	li	$v0, 4
	syscall				# print "Enter B"

	li	$v0, 5
	syscall				# get B

	mul	$s1, $v0, $v0		# square B

	jr	$ra			# return to caller

# =========================================================================
# PURPOSE: Print C^2 result to the screen.
#   INPUT: $s0 = A^2, $s1 = B^2
#  OUTPUT: n/a
# =========================================================================

output:

	la	$a0, prompt3
	li	$v0, 4
	syscall				# print "C^2 = "

	add	$t0, $s0, $s1		# C^2 = A^2 + B^2

	move	$a0, $t0
	li	$v0, 1
	syscall				# print C^2

	la	$a0, newline
	li	$v0, 4
	syscall				# print new line

	jr	$ra			# return to caller

# =========================================================================
# PURPOSE: Call input & output functions. Exit program.
#   INPUT: n/a
#  OUTPUT: n/a
# =========================================================================
	
main:

	jal	input			# call input function
	jal	output			# call output function

	li	$v0, 10
	syscall				# exit the program

# =========================================================================
# :::::::::::::::::::::::::::: END OF PROGRAM! ::::::::::::::::::::::::::::
# =========================================================================
