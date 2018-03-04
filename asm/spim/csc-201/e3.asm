# =========================================================================
#
#       NAME: 
#       DATE: June 06, 2001
# ASSIGNMENT: Example #3, CSC-201-01
#  OBJECTIVE: Print "Hello World!" once then create a for loop starting
#             from 0 to 99. Every 8th integer (0, 8, 16, 24, ... ) should
#             be displayed on the screen.
#
# =========================================================================

.data
.align 2

# =========================================================================

prompt1: .asciiz "Hello World!\n"
prompt2: .asciiz "The current integer is: "
newline: .asciiz "\n"

# =========================================================================

.text
.align 2

main:

# =========================================================================
# $s0 - counter
# =========================================================================
# :::::	OP ::::	ARGUMENTS :::::::::::::	COMMENTS ::::::::::::::::::::::::::
# =========================================================================

	la	$a0, prompt1
	li	$v0, 4
	syscall				# print "Hello World!"

	li	$s0, 0			# initialize counter

# =========================================================================

itbegins:

	andi	$t0, $s0, 7		# perform binary with $s0 and 7

	beq	$s0, 99, itends		# if counter == 99, goto itends
	bne	$t0, 0, nomsg		# if $t0 == 0, goto nomsg

	la	$a0, prompt2
	li	$v0, 4
	syscall				# print "The current integer is: "

	move	$a0, $s0
	li	$v0, 1
	syscall				# print counter

	la	$a0, newline
	li	$v0, 4
	syscall				# print new line

nomsg:

	addi	$s0, $s0, 1		# counter = counter + 1
	j	itbegins		# jump to start of loop

itends:

# =========================================================================

	li	$v0, 10
	syscall				# exit program

# =========================================================================
# :::::::::::::::::::::::::::: END OF PROGRAM! ::::::::::::::::::::::::::::
# =========================================================================
