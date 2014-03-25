.data
buffer: .space 20

clear:
.asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"

logo:
.ascii "\n\n\n"
.ascii ".--------------.--------------.--------------.--------------.--------------.--------------.--------------.--------------.\n"
.ascii "|     _____    | _____  _____ | ____    ____ |   ______     |   _____      |     _____    | ____  _____  |  _________   |\n"
.ascii "|    |_   _|   ||_   _||_   _|||_   \\  /   _||  |_   _ \\    |  |_   _|     |    |_   _|   ||_   \\|_   _| | |_   ___  |  |\n"
.ascii "|      | |     |  | |    | |  |  |   \\/   |  |    | |_) |   |    | |       |      | |     |  |   \\ | |   |   | |_  \\_|  |\n"
.ascii "|   _  | |     |  | '    ' |  |  | |\\  /| |  |    |  __'.   |    | |   _   |      | |     |  | |\\ \\| |   |   |  _|  _   |\n"
.ascii "|  | |_' |     |  .  `--'  /  | _| |_\\/_| |_ |   _| |__) |  |   _| |__/ |  |     _| |_    | _| |_\\   |_  |  _| |___/ |  |\n"
.ascii "|  `.___.'     |    `.__.'    ||_____||_____||  |_______/   |  |________|  |    |_____|   ||_____||____| | |_________|  |\n"
.ascii "|              |              |              |              |              |              |              |              |\n"
.ascii "'--------------'--------------'--------------'--------------'--------------'--------------'--------------'--------------'\n"
.ascii "                                                     .--------------.\n"
.ascii "                                                     |    _____     |\n"
.ascii "                                                     |   / ___ `.   |\n" 
.ascii "                                                     |  |_/___) |   |\n" 
.ascii "                                                     |   .'____.'   |\n"
.ascii "                                                     |  / /____     |\n"
.ascii "                                                     |  |_______|   |\n"
.ascii "                                                     |              |\n"
.asciiz "                                                     '--------------'\n"


main_menu_text:
.ascii "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
.ascii "                                                        Main Menu\n"
.ascii "                                         1 Number of characters to choose from.\n"
.ascii "                                         2 Game play instructions.\n"
.ascii "                                         3 Exit\n\n"
.asciiz "Please select your menu option and press enter: "

number_of_characters:
.asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nChoose how many characters you want to play with (5-7): "

instructions_text:
.ascii "\n\n                                                Instructions go here\n"
.ascii "         *****************************************************************************************************\n"
.ascii "         *****************************************************************************************************\n"
.ascii "         *****************************************************************************************************\n"
.ascii "         *****************************************************************************************************\n"
.ascii "         *****************************************************************************************************\n"
.ascii "         *****************************************************************************************************\n"
.ascii "         *****************************************************************************************************\n"
.ascii "         *****************************************************************************************************\n"
.ascii "         *****************************************************************************************************\n"
.ascii "         *****************************************************************************************************\n"
.ascii "         *****************************************************************************************************\n"
.ascii "         *****************************************************************************************************\n"
.ascii "         *****************************************************************************************************\n\n"
.asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nPress 0  and the enter to return back to the main menu: "

#******************************************************************************************************************************************
#logic under here
.text
main:				# (main) this is the outer loop for the display and the menu
	jal display_logo	# jump to display_logo_subroutine
	jal display_menu	# jump to display_menu subroutine

main_loop:			# inner loop to keep reading the input, procees, and jump back to outer loop
	jal read_input		# jump to read  the user input
	jal process_input	# take the input and jump to process_input
	j main
	
display_logo:
	la $a0, logo		# put logo in a0
	j print_string		# jump to print_string and print logo
	
display_menu:
	la $a0, main_menu_text	# load address of main menu text to a0
	j print_string		# jump  to print string 
	
display_number_of_characters:
	jal display_logo
	la $a0, number_of_characters
	li $v0, 4		# sets the syscall code
	syscall			# calls the system to display the number of char
	jal num_of_char_input

	
display_instructions:
	la $a0, instructions_text
	li $v0, 4		# sets the syscall code
	syscall			# calls the system to display the instructions
	jal read_input
	jal process_input


	
print_string:	
	li $v0, 4		# sets the syscall code
	syscall			# calls the system to display the string		
	jr $ra			# return back to main:
	
read_input:

     	la $a1, buffer 		#load byte space into address
     	li $v0,5       		#read integer input <------------------------------------------------ here
	syscall	
	move $a0 $v0
	jr $ra
	
process_input:
	move $s0,$a0 		#save string to $s0
	beq $s0, 0, main
	beq $s0, 1, display_number_of_characters
	beq $s0, 2, display_instructions
	beq $s0, 3, exit
	
clear_screen:
	la $a0, clear
	j print_string
	
exit:
	li $v0, 10		#exit the program gracefully
	syscall
	


.include "characterRandGenerator.asm"
