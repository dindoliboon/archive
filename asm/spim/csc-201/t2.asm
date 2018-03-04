# =========================================================================
#
#       NAME: 
#       DATE: June 13, 2001
# ASSIGNMENT: Test #3, CSC-201-01
#  OBJECTIVE: Nested procedure
#
# =========================================================================

.data
.align 2

# =========================================================================

ent_int: .asciiz "Enter an integer: "
prompt1: .asciiz "I will receive an A on this test\n"
prompt2: .asciiz "I will get an A on this test\n"
prompt3: .asciiz "I'm not sure I received an A on this test\n"
prompt4: .ascii  "You've been trick, "
         .asciiz "because you did not come to take the test\n"

# =========================================================================

.text
.align 2

# =========================================================================
# PURPOSE: Print prompt one
#   INPUT: n/a
#  OUTPUT: n/a
# =========================================================================

proc_1:
	la	$a0, prompt1
	li	$v0, 4
	syscall				# print prompt one

	li	$v0, 10
	syscall				# exit program

# =========================================================================
# PURPOSE: Print prompt two
#   INPUT: n/a
#  OUTPUT: n/a
# =========================================================================

proc_2:
	la	$a0, prompt2
	li	$v0, 4
	syscall				# print prompt two

	j	proc_1			# call procedure one

# =========================================================================
# PURPOSE: Print prompt three
#   INPUT: n/a
#  OUTPUT: n/a
# =========================================================================

proc_3:
	la	$a0, prompt3
	li	$v0, 4
	syscall				# print prompt three

	j	proc_1			# call procedure one

# =========================================================================
# PURPOSE: Print prompt four
#   INPUT: n/a
#  OUTPUT: n/a
# =========================================================================

proc_4:
	la	$a0, prompt4
	li	$v0, 4
	syscall				# print prompt four

	li	$v0, 10
	syscall				# exit program

# =========================================================================
# PURPOSE: Get number from keyboard and compare
#   INPUT: n/a
#  OUTPUT: n/a
# =========================================================================

read_cmp:
	la	$a0, ent_int
	li	$v0, 4
	syscall				# print "Enter integer"

	li	$v0, 5
	syscall				# read integer

	bgt	$v0, 0, proc_2
	blt	$v0, 0, proc_3
	beq	$v0, 0, proc_4

# =========================================================================
# PURPOSE: Call read integer and compare function
#   INPUT: n/a
#  OUTPUT: n/a
# =========================================================================

main:
	j	read_cmp

	li	$v0, 10
	syscall				# exit the program

# =========================================================================
# :::::::::::::::::::::::::::: END OF PROGRAM! ::::::::::::::::::::::::::::
# =========================================================================
