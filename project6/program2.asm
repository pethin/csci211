# Peter Nguyen -- 4/24/17
# program.asm -- Reads two lines from files and concatenates them

.data
buffer:	.space	1024
error_fopen: .asciiz "Error opening file: "
prompt: .asciiz "Enter filename: "
title:	.asciiz "========== String Manipulation ==========\n"
label1:	.asciiz "Line 1: "
label2:	.asciiz "Line 2: "
label3:	.asciiz "Concatenated lines: "

.text
main:
	la	$a0, prompt	# Prompt for filename
	jal	print

	la	$a0, buffer	# Read filename
	li	$a1, 1024
	li	$a2, 0		# 0 = stdin stream
	jal	readline
	
	jal	create
	move	$s5, $v0	# $s5 = filename

	li	$v0, 13
	move	$a0, $s5
	li	$a1, 0
	syscall
	bgez	$v0, continue

	la	$a0, error_fopen	# Print error
	jal	print
	move	$a0, $s5
	jal	print
	jal	newline
	
	b	terminate

continue:
	jal	newline
	move	$s0, $v0	# $s0 = file descriptor
	
	la	$a0, buffer	# Read first line of file
	li	$a1, 1024
	move	$a2, $s0
	jal	readline

	la	$a0, buffer
	jal	create
	move	$s1, $v0	# $s1 = first line

	la	$a0, buffer	# Read second line of file
	li	$a1, 1024
	move	$a2, $s0
	jal	readline
	
	la	$a0, buffer
	jal	create
	move	$s2, $v0	# $s2 = second line

	move	$a0, $s1	# Concatenate lines
	move	$a1, $s2
	jal	append
	move	$s3, $v0	# $s3 = concatenated lines

	la	$a0, title	# Print title
	jal	print

	la	$a0, label1	# Print line1 label
	jal	print
	move	$a0, $s1	# Print line1
	jal	print
	jal	newline

	la	$a0, label2	# Print line2 label
	jal	print
	move	$a0, $s2	# Print line2
	jal	print
	jal	newline

	la	$a0, label3	# Print concat label
	jal	print
	move	$a0, $s3	# Print concat
	jal	print
	jal	newline

terminate:
	li	$v0, 10
	syscall


# Reads in at most one less than buffer size
# Stops after EOF or newline
# $a0 - String buffer address
# $a1 - Size of buffer
# $a2 - File descriptor
# $v0 - Successful (0 = failure, 1 = success)
readline:
	addi	$sp, $sp, -28
	sw	$ra, 4($sp)
	sw	$a0, 8($sp)
	sw	$a1, 12($sp)
	sw	$a2, 16($sp)
	sw	$s0, 20($sp)
	sw	$s1, 24($sp)

	move	$s0, $a0	# $s0 = buffer pointer
	move	$s1, $a1	# $s1 = remaining buffer size
	addi	$s1, $s1, -1	# Save one byte for \0

read_char:
	bltz	$s1, readline_end
	li	$v0, 14
	lw	$a0, 16($sp)
	move	$a1, $s0
	li	$a2, 1
	syscall

	lb	$t1, 0($s0)
	beq	$t1, '\n', readline_end	# If newline

	addi	$s0, $s0, 1
	addi	$s1, $s1, -1
	beqz	$v0, readline_end	# If EOF
	
	b	read_char

readline_end:
	li	$t0, '\0'	# Add null terminator
	sb	$t0, 0($s0)

	lw	$ra, 4($sp)
	lw	$a0, 8($sp)
	lw	$a1, 12($sp)
	lw	$a2, 16($sp)
	lw	$s0, 20($sp)
	lw	$s1, 24($sp)
	addi	$sp, $sp, 28
	jr	$ra


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
