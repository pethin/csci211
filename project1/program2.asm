# Peter Nguyen -- 1/29/17
# program2.asm -- A program that prompts the user for two integers `a` and `b`
# 	and computes/prints the sum, difference, product, quotient, and modulo

.data
prompt:	.asciiz	"Please enter an integer "
p_a:	.asciiz	"(a): "
p_b:	.asciiz	"(b): "

ab_sum:	.asciiz "a + b = "

ab_sub:	.asciiz "a - b = "
ba_sub:	.asciiz "b - a = "

ab_mul:	.asciiz	"a * b = "

ab_div:	.asciiz	"a / b = "
ab_mod:	.asciiz	"a mod b = "

ba_div:	.asciiz	"b / a = "
ba_mod:	.asciiz	"b mod a = "

.text
main:
	# Prompt user for integer `a`
	li	$v0, 4		# Load syscall print_string into $v0
	la	$a0, prompt	# Load address of main prompt into $a0
	syscall			# Print `prompt`
	li	$v0, 4		# Load syscall print_string into $v0
	la	$a0, p_a	# Load address of end of prompt
	syscall			# Print the end of the prompt
	# Read integer `a` from console into $t0
	li	$v0, 5		# Load syscall read_int into $v0
	syscall			# Read an integer
	move	$t0, $v0	# Store the integer into $t0

	# Prompt user for integer `b`
	li	$v0, 4		# Load syscall print_string into $v0
	la	$a0, prompt	# Load address of main prompt into $a0
	syscall			# Print `prompt`
	li	$v0, 4		# Load syscall print_string into $v0
	la	$a0, p_b	# Load address of end of prompt
	syscall
	# Read integer `b` from console into $t1
	li	$v0, 5		# Load syscall read_int into $v0
	syscall			# Read an integer
	move	$t1, $v0	# Store the integer into $t1

sum:
	add	$t2, $t0, $t1	# $t2 = a + b
	# Print sum of `a` and `b`
	li	$v0, 4		# Load syscall print_string into $v0
	la	$a0, ab_sum	# Load address of "a + b = " into $a0
	syscall			# Print the string at $a0
	li	$v0, 1		# Load syscall print_integer into $v0
	move	$a0, $t2	# Move the sum into $a0
	syscall			# Print the sum
	li	$v0, 11		# Load syscall print_char into $v0
	li	$a0, '\n'	# Load a newline into $a0
	syscall			# Print a newline

difference:
	sub	$t2, $t0, $t1	# $t2 = a - b
	# Print "a - b"
	li	$v0, 4		# Load syscall print_string into $v0
	la	$a0, ab_sub	# Load address of "a - b = " into $a0
	syscall			# Print the string at $a0
	li	$v0, 1		# Load syscall print_integer into $v0
	move	$a0, $t2	# Move the difference into $a0
	syscall			# Print the difference
	li	$v0, 11		# Load syscall print_char into $v0
	li	$a0, '\n'	# Load a newline into $a0
	syscall			# Print a newline

	sub	$t2, $zero, $t2	# $t2 = -(a - b) = b - a
	# Print "b - a"
	li	$v0, 4		# Load syscall print_string into $v0
	la	$a0, ba_sub	# Load address of "b - a = " into $a0
	syscall			# Print the string at $a0
	li	$v0, 1		# Load syscall print_integer into $v0
	move	$a0, $t2	# Move the difference into $a0
	syscall			# Print the difference
	li	$v0, 11		# Load syscall print_char into $v0
	li	$a0, '\n'	# Load a newline into $a0
	syscall			# Print a newline

multiply:
	mult	$t0, $t1	# Multiply `a` and `b`
	mflo	$t2		# $t2 = a * b
				# If |a * b| > 2,147,483,647, there will be overflow
	# Print product of `a` and `b`
	li	$v0, 4		# Load syscall print_string into $v0
	la	$a0, ab_mul	# Load address of "a * b = " into $a0
	syscall			# Print the string at $a0
	li	$v0, 1		# Load syscall print_integer into $v0
	move	$a0, $t2	# Move the product into $a0
	syscall			# Print the product
	li	$v0, 11		# Load syscall print_char into $v0
	li	$a0, '\n'	# Load a newline into $a0
	syscall			# Print a newline

division:
	div	$t0, $t1	# Divide `a` by `b`
	mflo	$t2		# $t2 = a / b
	mfhi	$t3		# $t3 = a mod b
	# Print quotient
	li	$v0, 4		# Load syscall print_string into $v0
	la	$a0, ab_div	# Load the address of "a / b = " into $a0
	syscall			# Print the string at $a0
	li	$v0, 1		# Load syscall print_integer into $v0
	move	$a0, $t2	# Move the integer quotient into $a0
	syscall			# Print the integer quotient
	li	$v0, 11		# Load syscall print_char into $v0
	li	$a0, '\n'	# Load a newline into $a0
	syscall			# Print a newline
	# Print remainder
	li	$v0, 4		# Load syscall print_string into $v0
	la	$a0, ab_mod	# Load the address of "a mod b = " into $a0
	syscall			# Print the string at $a0
	li	$v0, 1		# Load syscall print_integer into $v0
	move	$a0, $t3	# Move the remainder into $a0
	syscall			# Print the remainder
	li	$v0, 11		# Load syscall print_char into $v0
	li	$a0, '\n'	# Load a newline into $a0
	syscall			# Print a newline

	div	$t1, $t0	# Divide `b` by `a`
	mflo	$t2		# $t2 = b / a
	mfhi	$t3		# $t3 = b mod a
	# Print quotient
	li	$v0, 4		# Load syscall print_string into $v0
	la	$a0, ba_div	# Load the address of "b / a = " into $a0
	syscall			# Print the string at $a0
	li	$v0, 1		# Load syscall print_integer into $v0
	move	$a0, $t2	# Move the integer quotient into $a0
	syscall			# Print the integer quotient
	li	$v0, 11		# Load syscall print_char into $v0
	li	$a0, '\n'	# Load a newline into $a0
	syscall			# Print a newline
	# Print remainder
	li	$v0, 4		# Load syscall print_string into $v0
	la	$a0, ba_mod	# Load the address of "b mod a = " into $a0
	syscall			# Print the string at $a0
	li	$v0, 1		# Load syscall print_integer into $v0
	move	$a0, $t3	# Move the remainder into $a0
	syscall			# Print the remainder
	li	$v0, 11		# Load syscall print_char into $v0
	li	$a0, '\n'	# Load a newline into $a0
	syscall			# Print a newline

terminate:
	li $v0, 10	# System call to terminate
	syscall		# Terminate the program
