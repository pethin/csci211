# Peter Nguyen -- 4/10/17
# program.asm -- Outputs number of instructions executed between keypresses
# Registers used:
# 	s0 - first character entered
# 	s1 - second character entered
# 	s2 - poll counter
# 	t0 - control register

.data
char1:	.asciiz	"First character: "
char2:	.asciiz	"Second character: "
ninst:	.asciiz	"Number of instructions exec. between keypresses: "

.text
main:
	lui	$t0, 0xffff	# Control register
poll_char1:
	lw	$t1, 0($t0)
	andi	$t1, $t1, 0x00000001
	beqz	$t1, poll_char1

store_char1:
	lb	$s0, 4($t0)	# Read data register
	li	$s2, 5 # 5 inst. executed after keypress

poll_char2:
	lw	$t1, 0($t0)
	andi	$t1, $t1, 0x00000001
	bnez	$t1, store_char2
	addiu	$s2, $s2, 5 # 5 inst. per poll
	b	poll_char2

store_char2:
	lb	$s1, 4($t0)

output_results:
	la	$a0, char1	# Output first character
	move	$a1, $s0
	jal	print_char
	
	la	$a0, char2	# Output second char
	move	$a1, $s1
	jal	print_char
	
	la	$a0, ninst	# Output num. inst.
	move	$a1, $s2
	jal	print_uint

terminate:
	li $v0, 10		# Terminate the program
	syscall


###
# Print character with preceding text
# a0 - text address
# a1 - character to print
###
print_char:
	li	$v0, 4		# Print text
	syscall
	li	$v0, 11		# Print character
	move	$a0, $a1
	syscall
	li	$v0, 11		# Print newline
	li	$a0, '\n'
	syscall
	jr	$ra		# Return


###
# Print unsigned integer with preceding text
# a0 - text address
# a1 - integer to print
###
print_uint:
	li	$v0, 4		# Print text
	syscall
	li	$v0, 36		# Print unsigned integer
	move	$a0, $a1
	syscall
	li	$v0, 11		# Print newline
	li	$a0, '\n'
	syscall
	jr	$ra		# Return
