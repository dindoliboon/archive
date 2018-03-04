# =========================================================================
#
#       NAME: 
#       DATE: June 06, 2001
# ASSIGNMENT: Example #2, CSC-201-01
#  OBJECTIVE: Create two seperate decision branches. The first one will
#             simulate the AND operator and the second one will simulate
#             the OR operator. For example, if (x == y) && (y == z),
#             if (x == y) || (x == z).
#
# =========================================================================

.data
.align 2

# =========================================================================

prompt1: .asciiz "$t0 == $t1 && $t1 == $t2\n"
prompt2: .asciiz "$t0 != $t1 && $t1 != $t2\n"
prompt3: .asciiz "$t0 == $t1 || $t0 == 4\n"
prompt4: .asciiz "$t0 != $t1 || $t0 != 4\n"
prompt5: .asciiz "Enter a number: "

# =========================================================================

.text
.align 2

main:

# =========================================================================
#
# $t0 - first variable
# $t1 - second variable
# $t2 - combination of $t0 and $t1
#
# =========================================================================
# :::::	OP ::::	ARGUMENTS :::::::::::::	COMMENTS ::::::::::::::::::::::::::
# =========================================================================

	la	$a0, prompt5
	li	$v0, 4
	syscall				# print "Enter a number"

	li	$v0, 5
	syscall				# get number from keyboard
	move	$t0, $v0		# save first variable

# =========================================================================

	la	$a0, prompt5
	li	$v0, 4
	syscall				# print "Enter a number"

	li	$v0, 5
	syscall				# get number from keyboard
	move	$t1, $v0		# save second variable

# =========================================================================

	mul	$t2, $t0, $t1		# $t2 = $t0 * $t1

	bne	$t0, $t1, neqt0t1	# if $t0 != $t1, goto neqt0t1
	bne	$t1, $t2, neqt0t1	# if $t1 != $t2, goto neqt0t1

	la	$a0, prompt1
	li	$v0, 4
	syscall				# print "$t0 == $t1 && $t1 == $t2"

	j	neqt0t1_e		# goto next if/then statement

# =========================================================================

neqt0t1:

	la	$a0, prompt2
	li	$v0, 4
	syscall				# print "$t0 != $t1 && $t1 != $t2"

neqt0t1_e:

# =========================================================================

	add	$t2, $t0, $t1		# $t2 = $t0 + $t1

	beq	$t0, $t1, equt0t1	# if $t0 == $t1, goto equt0t1
	beq	$t0, 4, equt0t1		# if $t0 == 4, goto equt0t1

	la	$a0, prompt4
	li	$v0, 4
	syscall				# print "$t0 != $t1 || $t0 != 4"

	j	equt0t1_e		# goto end of equt0t1

# =========================================================================

equt0t1:

	la	$a0, prompt3
	li	$v0, 4
	syscall				# print "$t0 == $t1 || $t0 == 4"

equt0t1_e:

# =========================================================================

	li	$v0, 10
	syscall				# exit program

# =========================================================================
# :::::::::::::::::::::::::::: END OF PROGRAM! ::::::::::::::::::::::::::::
# =========================================================================
