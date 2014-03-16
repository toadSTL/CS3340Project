.data
startMessage: 	.asciiz 	"JUMBLINE 2 (copy) \nPlease input a number (5, 6, 7):\n"
num:		.word		# For user input
randomChars:	.word 0:3	# Number
.text
	la 	$a0, 	startMessage	# Load the start message into memory
	li 	$v0, 	4		# Load the function Print String
	syscall				# Print the string
	
	li	$v0,	5		# Load the function for Read Int
	syscall				# Read the int (num)
	
	add	$a0,	$v0,	$0	# Load the int for comparison
	jal 	Gen_random_characters
	add 	$a0,	$v0,	$0	# Move the return value of Gen_random_characters to arguemnt position for printing
	li	$v0,	4		# Load print string service
	syscall
	
	li	$v0,	10
	syscall 	

	# Initialize count to 0
	# Character Gen Subroutine
	# Takes $a0 as an arguement = length of the string
	# Returns $v0 a pointer to the string created

#************************************************************************************************
#
# args: $a0 is the dessired length
# return: $v0 will be the address of the string
#************************************************************************************************
Gen_random_characters:
		move 	$t0, 	$0		# $t0 = 0
		move 	$t1, 	$a0		# Move given value into $t1, $t1 = (5-7)
		addi 	$t2, 	$0, 	8	# $t2 = 8
		la 	$t3,	randomChars	# $t3 contains the address of the random characters 
		Gen_ran_char_loop:
			beq 	$t0, 	$t1, 	Gen_null_fill # If we have generated the correct number of characters, fill the rest with NULL
			li 	$a0, 	0
			li 	$a1, 	25		# Set the upper bound for the random number
   			li 	$v0,	42		# Load the random number generation service
   			syscall				# Generate a random number between 0 and 25
   			addi 	$a0, 	$a0, 	65	# Increase the random number by 65 so that range is 65 - 90
   			sb	$a0, 	($t3)		# Save the random character
   			addi 	$t3,	$t3,	1	# Make $t3 a pointer to the next space for a char
   			addi 	$t0, 	$t0, 	1	# Increment $t0
   			j 	Gen_ran_char_loop
   		Gen_null_fill:
   			beq 	$t0, 	$t2, 	Gen_exit	# If all 8 spaces of array are filled with either null or a random character exit
   			sb 	$0, 	($t3)	 		# Place a NULL on the end of the string
   			addi 	$t3,	$t3,	1		# Make $t3 a pointer to the next space for a char
   			addi 	$t0, 	$t0, 	1	# Increment $t0
   			j 	Gen_null_fill
   		Gen_exit:
   			la	$v0, 	randomChars
   			jr 	$ra
 