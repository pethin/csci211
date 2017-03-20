# Peter Nguyen -- 2/27/17
# program.asm -- Stats system
# Registers used:
# 	s0 - number of ints
#	s1 - sum
#	s2 - integer average

.data
array:		.space	40 # 10 word array
two_fp:		.float	2.0
mode_arr:	.space	40 # 10 word array
int_prompt:	.asciiz	"Please enter an integer (-9 when done): "
sum_txt:	.asciiz "Sum: "
avg_txt:	.asciiz "Integer Average: "
min_txt:	.asciiz "Minimum: "
max_txt:	.asciiz "Maximum: "
above_avg_txt:	.asciiz "Number of Integers Above Avg: "
below_avg_txt:	.asciiz "Number of Integers Below Avg: "
median_txt:	.asciiz "Median: "

.text
main:
	la	$a0, array	# Read integers
	li	$a1, 10
	jal	read_ints
	move	$s0, $v0	# Save # of ints to $s0
	
	beqz	$s0, terminate	# Terminate the program if no integers entered
	
	la	$a0, array	# Calculate the sum
	move	$a1, $s0
	jal	sum
	move	$s1, $v0	# Save sum to $s1
	
	la	$a0, sum_txt	# Print the sum
	move	$a1, $s1
	jal	print_int
	
	move	$a0, $s1	# Calculate the average
	move	$a1, $s0
	jal	avg
	move	$s2, $v0	# Save average to $s2
	
	la	$a0, avg_txt	# Print the average
	move	$a1, $s2
	jal	print_int
	
	la	$a0, array	# Find the minimum
	move	$a1, $s0
	jal	min
	
	la	$a0, min_txt	# Print the minimum
	move	$a1, $v0
	jal	print_int
	
	la	$a0, array	# Find the maximum
	move	$a1, $s0
	jal	max
	
	la	$a0, max_txt	# Print the maximum
	move	$a1, $v0
	jal	print_int
	
	la	$a0, array	# Count above average
	move	$a1, $s0
	move	$a2, $s2
	jal	above_avg
	
	la	$a0, above_avg_txt	# Print the # above average
	move	$a1, $v0
	jal	print_int
	
	la	$a0, array	# Count below average
	move	$a1, $s0
	move	$a2, $s2
	jal	below_avg
	
	la	$a0, below_avg_txt	# Print the # below average
	move	$a1, $v0
	jal	print_int
	
	la	$a0, array	# Sort the array
	move	$a1, $s0
	jal	sort
	
	la	$a0, array	# Find the median
	move	$a1, $s0
	jal median
	
	la	$a0, median_txt	# Print the median
	move	$a1, $v0
	jal	print_float
	
	j terminate


###
# Read integers into array
# a0 - array address
# a1 - max number of integers
# v0 - number of integers read
###
read_ints:
	li	$t0, 0		# Initialize number of ints to 0
	move	$t1, $a0	# Initialize $t1 to array address

prompt_loop:
	beq	$t0, $a1, read_ints_end # Return if max ints read
	
	li	$v0, 4		# Prompt user for integer
	la	$a0, int_prompt
	syscall
	
	li	$v0, 5		# Read user input into `$v0`
	syscall
	
	beq	$v0, -9, read_ints_end # Return if -9 is entered
	sw	$v0, ($t1)	# Store the integer into array[$t0]
	
	addi	$t1, $t1, 4	# Increment the array pointer
	addi	$t0, $t0, 1	# Increment # of ints
	b 	prompt_loop	# Continue loop

read_ints_end:
	move	$v0, $t0	# Return number of ints read
	jr	$ra


###
# Sum integers in array
# a0 - array address
# a1 - number of integers
# v0 - sum of integers
###
sum:
	li	$t0, 0		# Initialize loop counter to 0
	li	$v0, 0		# Initialize sum to 0

sum_loop:
	beq	$t0, $a1, sum_end # Print sum after adding all integers
	
	lw	$t1, ($a0)	# Read array[$t0] into $t1
	add	$v0, $v0, $t1	# Add array[$t1] to $t3
	
	addi	$t0, $t0, 1	# Add 1 to loop counter
	addi	$a0, $a0, 4	# Increment array pointer
	b	sum_loop	# Continue loop

sum_end:
	jr	$ra


###
# Calculates average
# a0 - sum of array
# a1 - number of integers
# v0 - average of integers
###
avg:
	div	$a0, $a1	# Divide sum by # of ints
	mflo	$v0		# Move quotient to $v0
	jr	$ra


###
# Sorts integers in array (insertion sort)
# a0 - array address
# a1 - number of integers
###
sort:				# Insertion sort
	li	$t0, 0		# i = 0

sort_outer_loop:		# for i < $a1
	addi	$t0, $t0, 1	# i = i + 1
	bge	$t0, $a1, end_sort
	move	$t1, $t0	# j = i

sort_inner_loop:
	# while j > 0 && array[j-1] > array[j]
	bltz	$t1, sort_outer_loop
	
	sll	$t2, $t1, 2	# $t2 = array + j * 4
	addu	$t2, $t2, $a0
	
	lw	$t4, ($t2)	# $t4 = array[j]
	addi	$t2, $t2, -4
	lw	$t5, ($t2)	# $t5 = array[j-1]
	
	ble	$t5, $t4, sort_outer_loop
	
	sw	$t4, ($t2)	# swap array[j] and array[j-1]
	addi	$t2, $t2, 4
	sw	$t5, ($t2)
	
	addi	$t1, $t1, -1	# j = j - 1
	
	b	sort_inner_loop

end_sort:			# End of insertion sort
	jr	$ra


###
# Find the minimum value in an array
# a0 - array address
# a1 - number of integers
# v0 - minimum value
###
min:
	beqz	$a1, min_end
	
	lw	$v0, ($a0)	# $v0 = array[0]
	
	sll	$t0, $a1, 2	# $t0 = array + $a1 * 4
	addu	$t0, $t0, $a0

min_loop:
	addi	$a0, $a0, 4
	bge	$a0, $t0, min_end # while ($a0 < $t0)
	
	lw	$t1, ($a0)
	bge	$t1, $v0, min_loop # if ($t1 < $v0)
	move	$v0, $t1	  # $v0 = $t1

	b	min_loop

min_end:
	jr	$ra


###
# Find the maximum value in an array
# a0 - array address
# a1 - number of integers
# v0 - maximum value
###
max:
	beqz	$a1, max_end
	
	lw	$v0, ($a0)	# $v0 = array[0]
	
	sll	$t0, $a1, 2	# $t0 = array + $a1 * 4
	addu	$t0, $t0, $a0

max_loop:
	addi	$a0, $a0, 4
	bge	$a0, $t0, max_end # while ($a0 < $t0)
	
	lw	$t1, ($a0)
	ble	$t1, $v0, max_loop # if ($t1 > $v0)
	move	$v0, $t1	  # $v0 = $t1

	b	max_loop

max_end:
	jr	$ra


###
# Count the number of integers above the average
# a0 - array address
# a1 - number of integers
# a2 - average value
# v0 - number of integers above average
###
above_avg:
	li	$v0, 0		# $v0 = 0
	
	sll	$t1, $a1, 2	# $t0 = array + $a1 * 4
	addu	$t1, $t1, $a0
	
	addi	$a0, $a0, -4	# Compensate for addition in loop

above_avg_loop:
	addi	$a0, $a0, 4
	bge	$a0, $t1, above_avg_end # while ($a0 < $t0)
	
	lw	$t2, ($a0)
	ble	$t2, $a2, above_avg_loop # if ($t2 > $a2)
	addi	$v0, $v0, 1	  # Increment counter

	b	above_avg_loop

above_avg_end:
	jr	$ra


###
# Count the number of integers below the average
# a0 - array address
# a1 - number of integers
# a2 - average value
# v0 - number of integers below average
###
below_avg:
	li	$v0, 0		# $v0 = 0
	
	sll	$t1, $a1, 2	# $t0 = array + $a1 * 4
	addu	$t1, $t1, $a0
	
	addi	$a0, $a0, -4	# Compensate for addition in loop

below_avg_loop:
	addi	$a0, $a0, 4
	bge	$a0, $t1, below_avg_end # while ($a0 < $t0)
	
	lw	$t2, ($a0)
	bge	$t2, $a2, below_avg_loop # if ($t2 < $a2)
	addi	$v0, $v0, 1	  # Increment counter

	b	below_avg_loop

below_avg_end:
	jr	$ra


###
# Calculates the median of a sorted array
# a0 - sorted array address
# a1 - number of integers
# v0 - median (float)
###
median:
	andi	$t0, $a1, 1	# $t0 = 1 if $a1 is odd
	bnez	$t0, median_odd
	b	median_even

median_odd:
	addi	$t0, $a1, -1	# Get the middle offset
	sll	$t0, $t0, 1
	
	add	$t0, $t0, $a0	# Get the address
	lw	$t0, ($t0)	# Get the integer
	
	mtc1	$t0, $f0	# Convert to float
	cvt.s.w	$f0, $f0
	mfc1	$v0, $f0

	b	median_end

median_even:
	sll	$t0, $a1, 1	# Get the right middle offset
	
	add	$t0, $t0, $a0	# Get the addresses
	addi	$t1, $t0, -4
	
	lw	$t0, ($t0)	# Get the integers
	lw	$t1, ($t1)
	
	mtc1	$t0, $f0	# Convert to float
	mtc1	$t1, $f1
	cvt.s.w	$f0, $f0
	cvt.s.w	$f1, $f1

	add.s	$f0, $f0, $f1	# Calculate average
	l.s	$f1, two_fp
	div.s	$f0, $f0, $f1
	mfc1	$v0, $f0

median_end:
	jr	$ra


###
# Print integer with preceding text
# a0 - text address
# a1 - integer to print
###
print_int:
	li	$v0, 4		# Print text
	syscall
	li	$v0, 1		# Print integer
	move	$a0, $a1
	syscall
	li	$v0, 11		# Print newline
	li	$a0, '\n'
	syscall
	jr	$ra		# Return

###
# Print float with preceding text
# a0 - text address
# a1 - float to print
###
print_float:
	li	$v0, 4		# Print text
	syscall
	li	$v0, 2		# Print float
	mtc1	$a1, $f12
	syscall
	li	$v0, 11		# Print newline
	li	$a0, '\n'
	syscall
	jr	$ra		# Return

###
# Terminate
###
terminate:
	li $v0, 10		# Terminate the program
	syscall
