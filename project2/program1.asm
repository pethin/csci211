# Peter Nguyen -- 2/13/17
# program1.asm -- Calculates 10 week salary
# Registers used:
# 	t0 - number of work hours
# 	t1 - number of double-time hours
# 	t2 - used to hold total number of hours
# 	t3 - pay rate
# 	t4 - total salary
# 	t5 - used to hold counter
# 	t6 - used to hold stop count

.data
rate:	.word	0	# Pay rate in whole dollars
num_weeks:	.word 10	# The number of weeks to read in
rate_prompt:	.asciiz	"Please enter the pay rate (in whole dollars): "
week_prompt:	.asciiz "Please enter hours worked on week "
prompt_end:	.asciiz ": "
salary_prompt:	.asciiz "Your total salary is: $"

.text
main:
	# Prompt user for pay rate
	li	$v0, 4
	la	$a0, rate_prompt
	syscall
	# Read the pay rate into `rate`
	li	$v0, 5
	syscall
	sw	$v0, rate

read_rates:
	li	$t5, 1	
	lw	$t6, num_weeks
	li	$t2, 0

loop:
	# If counter > num_weeks, terminate
	bgt	$t5, $t6, terminate
	
	# Prompt user
	li	$v0, 4
	la	$a0, week_prompt
	syscall
	li	$v0, 1
	move	$a0, $t5
	syscall
	li	$v0, 4
	la	$a0, prompt_end
	syscall
	# Read user input into `$v0`
	li	$v0, 5
	syscall
	# Add user input to total number of hours
	add	$t2, $t2, $v0
	# Increment the counter
	addi	$t5, $t5, 1
	# Print the current total salary
	b	calc_salary

calc_salary:
	# Calculate work hours
	move	$t0, $t2
	li	$t7, 40
	ble	$t2, $t7, continue
overtime:
	li	$t0, 40
	addi	$t1, $t2, -40	# double-time hours = total - 40
	sll	$t1, $t1, 1	# convert double-time hours to regular-time hours
	addu	$t0, $t0, $t1	# add the converted hours
continue:
	lw	$t3, rate	# load the pay rate
	mulo	$t4, $t0, $t3	# multiply pay rate by total work-hours

print_salary:
	li	$v0, 4
	la	$a0, salary_prompt
	syscall
	li	$v0, 1
	move	$a0, $t4
	syscall
	li	$v0, 11
	li	$a0, '\n'
	syscall
	# Return to the loop
	b	loop

terminate:
	li $v0, 10	# System call to terminate
	syscall		# Terminate the program
