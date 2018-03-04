# =========================================================================
#
#       NAME: 
#       DATE: May 24, 2001
# ASSIGNMENT: Example #1, CSC-201-01
#  OBJECTIVE: Obtain name from keyboard and greet user.
#
# =========================================================================

.data
.align 2

# =========================================================================

prompt1: .asciiz "Enter your name: "
prompt2: .asciiz "Hello "
prompt3: .asciiz "You have logged on successfully!\n"

# =========================================================================

.text
.align 2

main:

# =========================================================================
#
# $a1 - user name
#
# =========================================================================
# :::::	OP ::::	ARGUMENTS :::::::::::::	COMMENTS ::::::::::::::::::::::::::
# =========================================================================

	la	$a0, prompt1
	li	$v0, 4
	syscall				# print "Enter your name:"

	li	$a1, 30
	li	$v0, 8
	syscall				# read name from keyboard

	move	$a1, $a0		# save string into a0

	la	$a0, prompt2
	li	$v0, 4
	syscall				# print "Hello"

	move	$a0, $a1
	li	$v0, 4
	syscall				# print typed in name

	la	$a0, prompt3
	li	$v0, 4
	syscall				# print "You have logged ... "

# =========================================================================

	li	$v0, 10
	syscall				# exit program

# =========================================================================
# :::::::::::::::::::::::::::: END OF PROGRAM! ::::::::::::::::::::::::::::
# =========================================================================
