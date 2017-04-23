# Peter Nguyen -- 4/24/17
# program.asm -- Dynamically creates two strings and concatenates them

.data
title:	.asciiz "========== String Manipulation ==========\n"
str1:	.asciiz "This is a test"
str2:	.asciiz " of our string routines"
label1:	.asciiz "String 1: "
label2:	.asciiz "String 2: "
label3:	.asciiz "Concatenated string: "

.text
main:
	la	$a0, str1	# Create dynamic string from str1
	jal	create
	move	$s0, $v0	# $s0 = create(str1)

	la	$a0, str2	# Create dynamic string from str2
	jal	create
	move	$s1, $v0	# $s1 = create(str2)

	move	$a0, $s0	# Concatenate $s0 and $s1
	move	$a1, $s1
	jal	append
	move	$s2, $v0	# $s2 = concatenated string

	la	$a0, title	# Print title
	jal	print

	la	$a0, label1	# Print str1 label
	jal	print
	move	$a0, $s0	# Print str1
	jal	print
	jal	newline

	la	$a0, label2	# Print str2 label
	jal	print
	move	$a0, $s1	# Print str2
	jal	print
	jal	newline

	la	$a0, label3	# Print str3 label
	jal	print
	move	$a0, $s2	# Print str3
	jal	print
	jal	newline

	li	$v0, 10
	syscall


# Returns the length of a string
# $a0 - Address of string
# $v0 - Length of string
length:
	li	$v0, 0
	move	$t0, $a0
length_loop:
	lb	$t1, 0($t0)
	beqz	$t1, length_end
	addi	$t0, $t0, 1
	addi	$v0, $v0, 1
	b	length_loop
length_end:
	jr	$ra


# Creates a dynamically allocated string
# $a0 - Address of string
# $v0 - Pointer to dynamically allocated string
create:
	sw	$ra, 0($sp)	# Store stack pointer
	sw	$a0, -4($sp)	# and string address
	addi	$sp, $sp, -8

	jal	length

	move	$a0, $v0
	addi	$a0, $a0, 1	# Add 1 for null-terminator
	li	$v0, 9
	syscall			# $v0 = dynamically allocated string

	lw	$t0, 4($sp)	# $t0 = address of static string
	move	$t1, $v0	# $t1 = address of dynamic string

create_loop:
	lb	$t2, 0($t0)
	sb	$t2, 0($t1)
	beqz	$t2, create_end
	addi	$t0, $t0, 1
	addi	$t1, $t1, 1
	b	create_loop

create_end:
	addi	$sp, $sp, 8
	lw	$ra, 0($sp)
	lw	$a0, -4($sp)
	jr	$ra


# Concatenates two strings
# $a0 - Address of first string
# $a1 - Address of second string
# $v0 - Pointer to concatenated string
append:
	sw	$ra, 0($sp)	# Store stack pointer
	sw	$a0, -4($sp)	# and string addresses
	sw	$a1, -8($sp)
	sw	$s0, -12($sp)	# and $s0, $s1
	sw	$s1, -16($sp)
	addi	$sp, $sp, -20

	jal	length		# $s0 = length of first string
	move	$s0, $v0
	
	lw	$a0, 4($sp)	# $s1 = length of second string
	jal	length
	move	$s1, $v0

	move	$a0, $s0
	add	$a0, $a0, $s1
	addi	$a0, $a0, 1	# Add 1 for null-terminator
	li	$v0, 9
	syscall			# $v0 = dynamically allocated string

	lw	$t0, 16($sp)	# $t0 = address of str1
	lw	$t1, 12($sp)	# $t1 = address of str2
	move	$t2, $v0	# $t2 = address of dynamic string

copy_str1_loop:
	lb	$t3, 0($t0)
	sb	$t3, 0($t2)
	addi	$s0, $s0, -1	# Decrement # remaining characters
	addi	$t0, $t0, 1	# Increment str1 pointer
	addi	$t2, $t2, 1	# Increment new string pointer
	bgtz	$s0, copy_str1_loop

copy_str2_loop:
	lb	$t3, 0($t1)
	sb	$t3, 0($t2)
	addi	$s1, $s1, -1
	addi	$t1, $t1, 1
	addi	$t2, $t2, 1
	bgez	$s1, copy_str2_loop

append_end:
	addi	$sp, $sp, 20
	lw	$ra, 0($sp)
	lw	$a0, -4($sp)
	lw	$a1, -8($sp)
	lw	$s0, -12($sp)
	lw	$s1, -16($sp)
	jr	$ra


# Prints a string
# $a0 - address of string
print:
	sw	$v0, 0($sp)
	addi	$sp, $sp, -4

	li	$v0, 4
	syscall

	addi	$sp, $sp, 4
	lw	$v0, 0($sp)
	jr	$ra


# Prints a newline
newline:
	sw	$a0, 0($sp)
	sw	$v0, -4($sp)
	addi	$sp, $sp, -8

	li	$a0, '\n'
	li	$v0, 11
	syscall

	addi	$sp, $sp, 8
	lw	$a0, 0($sp)
	lw	$v0, -4($sp)
	jr	$ra
