#Name:  	Mitchell R. Garnatz
#Assignment:	Assignment 1 MIPSSort
#Description:	This program takes an input from the user to deterimine the size of the array. The size
#		must be between 3-10, and if the user input is out of range the user is prompt to 
#		give another input. Once a valid size is input, the user inputs this many integers
#		that are placed into an unsorted array. The unsorted array is then output. Next the program 
#	 	sorts the array in acending order using bubbleSort. The final sorted array is then output.

.data
array:		.space 40
prompt: 	.asciiz "\nPlease enter the size of the unsortedarray from 3-10: "
inputNumber:	.asciiz "Input a number: "
initialList:	.asciiz "List entered: "
sortedList:	.asciiz "\nSorted list: "
space:		.asciiz " "
.text

main:
	li $t1, 10		#Create storage in $t1
	la $a1, array		#Give pointer to array 
	addi $t1, $zero, 2	#Lower bound for array size (must be greater than)
	addi $t2, $zero, 11	#Upper bound for array size (must be less than)
	
	li	$v0, 4		#Code to print string
	la	$a0, prompt	#Address of string to print
	syscall			#Displays the prompt
	
	li 	$v0, 5		#Code to get integer from user
	syscall			#Call for user to input
	move	$t0, $v0	#Store integer in $t0
	
	sgt $s0, $t0, $t1	#Compare if user input is greater than 2
	slt $s1, $t0, $t2	#Compare if user input is less than 11

				#Get valid input for size of array	
Loop1: 
	beq $s0, $s1, exit	#If $s0 is equal to $s1 go to exit (input is valid)
		
	li	$v0, 4		#Code to print string
	la	$a0, prompt	#Address of string to print	
	syscall			#Displays the prompt
	
	li 	$v0, 5		#Code to get integer from user
	syscall			#Call for user to input
	move	$t0, $v0	#Store integer in $t0
		
	sgt $s0, $t0, $t1	#Compare if user input is greater than 2
	slt $s1, $t0, $t2	#Compare if user input is less than 11
		
	j Loop1			#Jump to Loop1
		
exit:
	addi $t1, $zero, 0	#$t1 = 0
	addi $t2, $zero, 4	#$t2 = 4
	mult $t0, $t2		#Make space in the array
	mflo $s0		#Save space of array
	
				#Store user input values into array
Loop2: 
	beq $t1, $s0, exit2	#If sufficient values have been added exit
					
	li $v0, 4		#Promt the user to enter a number	
	la $a0, inputNumber	#Address of String
	syscall			#Print String
		
	li $v0, 5		#Address of input integer
	syscall			#Prompt user
		
	move $s1, $v0		#Move input to $s1
	sw $s1, array($t1)	#Store $s1 in array
		
	addi $t1, $t1, 4	#$t1 = $t1 + 4
		
	j Loop2			#Jump to Loop2
		
exit2:

	addi $t1, $zero, 0	#$t1 = 0
	li $v0, 4		#Address of String
	la $a0, initialList	#Get String initialList
	syscall			#Print String

				#Print numbers that are in the unsorted array
Loop3:
	beq $t1, $s0, exit3	#If $t1 = $s0 go to exit3
		
	lw $t6, array($t1)	#Load address of array and store in $t6
		
	addi $t1, $t1, 4	#$t1 = 4t1 + 4
		
	li $v0, 1		#Address of printing integer
	move $a0, $t6		#Move $t6 to $a0
	syscall			#Print integer in $a0
	
	li $v0, 4		#Address of String
	la $a0, space		#Load String space in $a0
	syscall			#Print String
		
	j Loop3			#Jump to Loop3
		
exit3:
	la $a1, array		#Load address of array into $a1
	addi $s1, $t0, -1	#$s1 = $t0 + (-1)   ($t0 = number of elements in array)
	addi $s2, $t0, -1	#$s2 = $t0 + (-1)   ($t0 = number of elements in array)
	
				#Sort elements in increasing order
Loop4:	
	beqz $s2, Loop5		#If $s2 = 0 go to Loop5
	
	addi $s2, $s2, -1	#Decrement $s2 by 1
	lw $t5, 0($a1)		#Load address 0 from array in $t5
	lw $t6, 4($a1)		#Load address 4 from array in $t6
		
	addi $a1, $a1, 4	#Shift array
	ble $t5, $t6, Loop4	#If $t5 <= $t6 go to Loop4
	sw $t5, 0($a1)		#Store $t5 in address 0 of array
	sw $t6, -4($a1)		#Store $t6 in address infront of 0 in array
		
	bnez $s2, Loop4		#If $s2 != 0 go to Loop4
	
				#If counter $s1 is not zero loop back through the array to sort
Loop5:
	la $a1, array		#Load address of array in $a1
	addi $s1, $s1, -1	#Decriment $s1 after finishing Loop4
	add $s2, $s2, $s1	#$s2 = $s2 + $s1 (since $s2=0 store the decrimented $s1 in it)
	bnez $s1, Loop4		#If $s1 is != 0 go to Loop4
	
Exit5:
	
	addi $t0, $zero, 0	#$t0 = 0
	
	li $v0, 4		#Load address to print String
	la $a0, sortedList	#Load string to print into $a0
	syscall			#Print string

				#Print numbers that are in the sorted array
Loop6:
	beq $t0, $s0, exit6	#If $t0 = $s0 go to exit6
	
	lw $t6, array($t0)	#Load address $t0 in array to $t6
		
	addi $t0, $t0, 4	#$t0 = $t0 + 4
		
	li $v0, 1		#Load address to print integer
	move $a0, $t6		#Move $t6 to $a0
	syscall			#Print $a0
		
	li $v0, 4		#Load address to print String
	la $a0, space		#Load address of string space into $a0
	syscall			#Print string
		
	j Loop6			#Jump to Loop6
		
exit6:
	li $v0, 10		#Load call to end program
	syscall			#End program
	
	
	
	
