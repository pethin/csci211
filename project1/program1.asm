# Peter Nguyen -- 1/29/17
# program1.asm -- A program that computes and prints `b + (a - c)`
# Registers used:
# 	t0 - used to hold the result.
# 	t1 - used to hold temporary values.
# 	$v0 - syscall instruction code.
# 	$a0 - syscall parameter -- the integer to print.

.data
a: .word 1337
b: .word 42
c: .word 9000

.text
main:
	lw	$t0, a		# Load `a` into $t0
	lw	$t1, c		# Load `c` into $t1
	sub	$t0, $t0, $t1	# $t0 = a - c
	lw	$t1, b		# Load `b` into $t0
	add	$t0, $t1, $t0	# result = $t0 = b + (a - c)

	li	$v0, 1		# Load syscall read_int into $v0
	move	$a0, $t0	# Move the result into $a0
	syscall			# Print the integer in register $a0

	li $v0, 10	# System call to terminate
	syscall		# Terminate the program
