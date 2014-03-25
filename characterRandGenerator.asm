.data

shuffle_input_buffer: .space 26
randChar: .space 26
numberChar: .space 16

shuffle_text_q: .asciiz "\n\n\nEnter a word or *shuffle to shuffle characters: "
space: .asciiz " "
input_text: .asciiz "enter number of character to play with: " 
error_input: .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nInput is out of boundry. Please input from 5-7: "
bottom_justify: .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
.text
main1:

	la $a0, input_text
	li $v0, 4		# sets the syscall code
	syscall			# calls the system to display the number of char
	la $a1, numberChar		# load byte space into $a1
num_of_char_input:
addi $sp, $sp, -28	# make space on the stack to store saved registers
add $s0, $sp ,$zero
	num_char_input2:
     	li $v0,5       			# read user input <---------------------------------------- here
	syscall	
	jal check_input5
	move $t0 $v0			# move user input into $t0
	la $a0 logo
	li $v0 4
	syscall
	la $a0 bottom_justify
	syscall
	numberCharLoop:				# outer loop for character generator
		li $a1, 26			# uperbound to random generator
		li $v0, 42			# set v0 to syscall 42
		syscall				
		addi $a0 $a0, 65		# add 65 to the number generator to conform to ascii
		jal store_char_stack		# jump and link to label
		jal compare_char
		
		numberCharLoop2:		# inner loop for character genarator
			sw $a0 0($s0)			# store $a0 into stack address		
			li $v0 11			# set $v0 to syscall 11
			syscall
			la $a0, space			# space to make characters more readable
			li $v0, 4
			syscall
			addi $t1 $t1 1			# use $t1 as a counter 
			addi $s0 $s0 4			
			bne $t0 $t1 numberCharLoop 	# compare user input to counter
			jal store_char_stack
			add $s0 $t0 $zero 
			addi $sp, $sp, 28
			jal shuffle_char_loop #shuffle characters
			
	addi $sp, $sp, 68
	li $v0, 10		#exit the program gracefully
	syscall
			
store_char_stack:
	#load values of stack into $s*   (* = 1-7)
	lw $s1, -4($s0)   
	lw $s2, -8($s0)  
	lw $s3, -12($s0)
	lw $s4, -16($s0)
	lw $s5, -20($s0)
	lw $s6, -24($s0)
	lw $s7, -28($s0)
	jr $ra

compare_char:
     # compare $a0 to values in stack  
	beq $a0 $s1 numberCharLoop
	beq $a0 $s2 numberCharLoop
	beq $a0 $s3 numberCharLoop
	beq $a0 $s4 numberCharLoop
	beq $a0 $s5 numberCharLoop
	beq $a0 $s6 numberCharLoop
	jr $ra
	
shuffle_char_loop:
	addi $sp $sp -56	
	jal clear_s_registers
	add $s3 $sp $zero
		# print text for testing purposes
	la $a0 shuffle_text_q
	li $v0 4
	syscall
	# input user string in buffer
	la $a1 shuffle_input_buffer
	li $v0 8
	syscall
		la $a0 logo
	li $v0 4
	syscall
	la $a0 bottom_justify
	syscall
	shuffle_char_loop2:	
		add $a1 $s0 $zero	# set upper boundry for random generator
		li $v0 42	# set $v0 to call random integer
		syscall
		addi $a0 $a0 1
		jal store_shuffle_char
		jal compare_shuffle_char
	
		shuffle_char_loop3:
			sw $a0 0($s3)
		
			add $s7 $a0 $zero	# set $s7 to value of $a0
			add $s2 $zero $zero
			addi $s2 $s2 4		# set $s2 t0 4
			mult $s7 $s2		# multiply random # from 0-6 and multiply by 4
	
			mflo $s1		# set $t3 to product of $t1 and $t2
			add $s4 $sp $s1 	# subtract $s3 from upper bound of stack address
			addi $s4 $s4 24
			lw $a0 ($s4)		# set $a0 to $t4 contents
			li $v0 11		# print character
			syscall
			la $a0, space		# space to make characters more readable
			li $v0, 4
			syscall
			addi $t7 $t7 1 
			addi $s3 $s3 4
			add $a0 $s7 $zero
			bne $t7 $s0 shuffle_char_loop2
	j done

check_input5:
	beq $v0 5 return
	bne $v0 5 check_input6
check_input6:
	beq $v0 6 return
	bne $v0 6 check_input7
check_input7:
	beq $v0 7 return
	bne $v0 7 display_error_input
	
return:	jr $ra

		
	
store_shuffle_char:
	lw $t0 -4($s3)
	lw $t1 -8($s3)
	lw $t2 -12($s3)
	lw $t3 -16($s3)
	lw $t4 -20($s3)
	lw $t5 -24($s3)
	lw $t6 -28($s3)
	jr $ra


compare_shuffle_char:
	beq $a0 $t0 shuffle_char_loop2
	beq $a0 $t1 shuffle_char_loop2
	beq $a0 $t2 shuffle_char_loop2
	beq $a0 $t3 shuffle_char_loop2
	beq $a0 $t4 shuffle_char_loop2
	beq $a0 $t5 shuffle_char_loop2
	beq $a0 $t6 shuffle_char_loop2
	jr $ra
	
clear_s_registers:
	add $s1 $zero $zero
	add $s2 $zero $zero
	add $s3 $zero $zero
	add $s4 $zero $zero
	add $s5 $zero $zero
	add $s6 $zero $zero
	add $s7 $zero $zero
	jr $ra
	
display_error_input:
	la $a0, logo		# put logo in a0
	li $v0, 4		# sets the syscall code
	syscall			# calls the system to display the string
	la $a0, error_input	# load address of error input to a0
	li $v0, 4		# sets the syscall code
	syscall	
	li $v0,5       			# read user input <-------------------------------------- here
	syscall			# calls the system to display the string		
	j check_input5
	
done:
	li $v0, 10		#exit the program gracefully
	syscall
