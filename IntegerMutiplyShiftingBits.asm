#Name:  	Mitchell R. Garnatz
#Assignment:	Assignment 4
#Description:	This program does an integer multiply using adds and shifts. First the user is
#		prompt to input two positive integers between 0 and 32767. If the inputs are not
#		in range, the user will be asked to give a new input value. The program then uses
#		two loops to compute the product of the two values input by the user. The product
#		is then output with a prompt at the end of the program.

.data
input1: 	.asciiz "Input 1st number: "
input2:		.asciiz "Input 2nd number: "
errorMessage:	.asciiz "Error, the input was not in range. Please input a new value. \n"
product:	.asciiz "Product of these two numbers: "

.text
main:   
	addi 	$t0, $zero, 0		#Lower bound for input integer
	addi 	$t1, $zero, 32767	#Upper bound for input integer
	li   	$t4, 31			#Counter for Multiplication
	li   	$s2, 1			#Used for comparing bit in multiplier
	li	$s3, 0			#Product to be returned
	
	li	$v0, 4			#Code to print string
	la	$a0, input1		#Address of string to print
	syscall				#Displays input1 prompt
	
	li 	$v0, 5			#Code to get integer from user
	syscall				#Call for user to input
	move	$t2, $v0		#Store integer in $t2
	
	sge 	$s0, $t2, $t0		#Compare if user input is greater than or equal to 0
	sle 	$s1, $t2, $t1		#Compare if user input is less than or equal to 32767
	
InputLoop1:
	beq $s0, $s1, ExitInput1	#If $s0 == $s1 exit
	
	li 	$v0, 4			#Code to print string
	la	$a0, errorMessage	#Address of string to print
	syscall				#Displays errorMessage prompt
	
	li	$v0, 4			#Code to print string
	la	$a0, input1		#Address of string to print
	syscall				#Displays input1 prompt
	
	li 	$v0, 5			#Code to get integer from user
	syscall				#Call for user to input
	move	$t2, $v0		#Store integer in $t2
	
	sge 	$s0, $t2, $t0		#Compare if user input is greater than or equal to 0
	sle 	$s1, $t2, $t1		#Compare if user input is less than or equal to 32767
	
	j InputLoop1			#Jump to top of the loop to compare $s0 to $s1
		
ExitInput1:
	li	$v0, 4			#Code to print string
	la	$a0, input2		#Address of string to print
	syscall				#Displays input1 prompt
	
	li 	$v0, 5			#Code to get integer from user
	syscall				#Call for user to input
	move	$t3, $v0		#Store integer in $t3
	
	sge 	$s0, $t3, $t0		#Compare if user input is greater than or equal to 0
	sle 	$s1, $t3, $t1		#Compare if user input is less than or equal to 32767
	
InputLoop2:
	beq $s0, $s1, ExitInput	#If $s0 == $s1 exit
	
	li 	$v0, 4			#Code to print string
	la	$a0, errorMessage	#Load address of string to print
	syscall				#Displays errorMessage prompt
	
	li	$v0, 4			#Code to print string
	la	$a0, input2		#Address of string to print
	syscall				#Displays input1 prompt
	
	li 	$v0, 5			#Code to get integer from user
	syscall				#Call for user to input
	move	$t3, $v0		#Store integer in $t3
	
	sge $s0, $t3, $t0		#Compare if user input is greater than or equal to 0
	sle $s1, $t3, $t1		#Compare if user input is less than or equal to 32767
	
	j InputLoop2			#Jump to top of the loop to compare $s0 to $s1

ExitInput:
	move $s0, $t2			#Store temporary as saved temporary $s0
	move $s1, $t3			#Store temporary as saved temporary $s1

MultiplyInputs:
	beq $t4, 0, ExitProgram	#If $t4 == 0 go to ExitProgram
	
	and $t0, $s0, $s2		#Compare the furtherst right bit in $s0 to see it is 1 or 0
	beq $t0, $s2, Add		#If $t0 == 1 go to Add
	sll $s1, $s1, 1			#Shift multiplicand left by 1
	srl $s0, $s0, 1			#Shift multiplier right by 1 bit
	subi $t4, $t4, 1		#Decriment counter in $t4 by 1
	
	j MultiplyInputs		#Jump to MultiplyInputs loop
	
Add:	
	add $s3, $s3, $s1		#Add value in $s1 to the current product in $s3
	sll $s1, $s1, 1			#Shift multiplicand left by 1
	srl $s0, $s0, 1			#Shift multiplier right by 1 bit
	subi $t4, $t4, 1		#Decriment counter in $t4 by 1
	
	j MultiplyInputs		#Jump to MultiplyInputs loop

ExitProgram:
	li 	$v0, 4			#Code to print string
	la	$a0, product		#Load address of string to print
	syscall				#Displays product prompt
	
	li $v0, 1			#Load address to print integer
	move $a0, $s3			#Move product in $s3 to $a0
	syscall				#Print $a0

	li $v0, 10			#Load call to end program
	syscall				#End program
		
	
