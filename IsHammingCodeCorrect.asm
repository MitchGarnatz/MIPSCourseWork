#Name:  	Mitchell R. Garnatz
#Assignment:	Assignment 8, Program 2
#Description:	Requests he user to enter a 12-bit Hamming code and determine if it 
#		is correct or not. If correct, it is to display a message to that effect. 
#		If incorrect, it is to display a message say it was incorrect and what 
#		the correct data is (the 12-bit Hamming code) again in hex. 


.data		
enterCode:	.asciiz "Enter a 12-bit Hamming code: "
correct:	.asciiz "The Hamming code is correct."
incorrect:	.asciiz "The Hamming code was incorrect. \nThe corrected code is: "

.text
main:
	li	$t2, 5095		#Max value for a 12-bit code
	li	$t0, 0			#Min value for 12-bit code

	li	$v0, 4			#Code to print string
	la	$a0, enterCode		#Load address of string to print
	syscall				#Print string
	
	li	$v0, 5			#Code to get integer from user
	syscall				#Call to get integer
	move	$t3, $v0		#Move $v0 to $t3
	
	slt	$s0, $t3, $t0		#If $t3 < $t0, $s0 = 1, else 0
	sgt	$s1, $t3, $t2		#If $t3 > $t2, $s0 = 1, else 0
	
Loop1:	
	beq	$s0, $s1, exitInput	#s0 == $s1, go to exitInput
	
	li 	$v0, 4			#Coode to print string
	la 	$a0, enterCode		#Load address of string
	syscall				#Print string
	
	li 	$v0, 5			#Code to get integer from user
	syscall				#Get integer from user
	move	$t3, $v0		#Move $v0 to $t3, $t3 contains Hamming code
	
	slt	$s0, $t3, $t0		#If $t3 < $t0, $s0 = 1, else 0
	sgt	$s1, $t3, $t2		#If $t3 > $t2, $s0 = 1, else 0
	
	j Loop1				#jump Loop1
	
exitInput:
	li	$t1, 0			#Will contain 1 or 0
	li	$t2, 0			#Will contain 1 or 0
	li	$t4, 0			#Will contain 1 or 0
	li	$t8, 0			#Will contain 1 or 0
	
parityOne:				#bits 11, 9, 7, 5, 3, 1
	li	$s1, 1			#$s1 = 1
	li	$t7, 0			#$t7 = 0
	
	addi	$t5, $zero, 0		#$t5 = 0
	add	$t5, $t5, $t3		#move 12-bit code to $t5
	
	srl	$t5, $t5, 1		#Shift right 1 bit to evaluate 11th bit
	move	$s2, $t5		#Move $t5 to $s2
	andi	$t0, $s2, 1		#See if the last bit is a 1 or a 0
	move 	$s0, $t0		#Move the bit stored in $t0 to $s0

	jal	check			#Jump to check
		
	srl	$t5, $t5, 2		#Shift right 2 bits to evaluate 9th bit 
	move	$s2, $t5		
	andi	$t0, $s2, 1		
	move 	$s0, $t0		
	
	jal	check			#Jump to check
		
	srl	$t5, $t5, 2		#Shift right 2 bits to evaluate 7th bit 
	move	$s2, $t5		
	andi	$t0, $s2, 1		
	move 	$s0, $t0		
	
	jal	check			#Jump to check
	
	srl	$t5, $t5, 2		#Shift right 2 bits to evaluate 5th bit 
	move	$s2, $t5
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check			#Jump to check
	
	srl	$t5, $t5, 2		#Shift right 2 bits to evalutae 3rd bit
	move	$s2, $t5
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	srl	$t5, $t5, 2		#Shift right 2 bits to evaluate 1st bit
	move	$s2, $t5
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check			#Jump to check
	
	move	$t1, $t7		#Move the counter $t7 to $t1
	
	j	parityTwo		#Jump to parityTwo
	
parityTwo:
	li	$s1, 1			#s1 = 1
	li	$t7, 0			#Set counter $t7 to 0
	
	addi	$t5, $zero, 0		#$t5 = 0
	add	$t5, $t5, $t3		#$t5 = orginal 12-bit hamming code in $t3
	
	srl	$t5, $t5, 1		#Shift right 1 bit to evaluate 11th bit
	move	$s2, $t5		#Move $t5 to $s2
	andi	$t0, $s2, 1		#See if the last bit is a 1 or a 0
	move 	$s0, $t0		#Move result of comparison stored in $t0 to $s0

	jal	check			#Jump to check
	
	srl	$t5, $t5, 1		#Shift right 1 bit to evaluate 10th bit
	move	$s2, $t5
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check			#Jump to check
	
	srl	$t5, $t5, 3		#Shift right 3 bits to evaluate 7th bit
	move	$s2, $t5
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check			#Jump to check
	
	srl	$t5, $t5, 1		#Shift right 1 bit to evaluate 6th bit
	move	$s2, $t5
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check			#Jump to check
	
	srl	$t5, $t5, 3		#Shift right 3 bits to evaluate 3rd bit
	move	$s2, $t5
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check			#Jump to check
	
	srl	$t5, $t5, 1		#Shift right 1 bit to evaluate the 2nd bit
	move	$s2, $t5
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check			#Jump to check
	
	move	$t2, $t7		#Move counter in $t7 to $t2
	
	j	parityFour		#Jump to parityFour
	
parityFour:
	li	$s1, 1			#$s1 = 1
	li	$t7, 0			#Set counter $t7 = 0
	
	addi	$t5, $zero, 0		#$t5 = 0
	add	$t5, $t5, $t3		#t5 = original 12-bit hamming code in $t5
	
	move	$s2, $t5		#Move $t5 to $t2
	andi	$t0, $s2, 1		#See if the last bit is a 1 or a 0 in position of bit 12
	move 	$s0, $t0		#Move $t0 to $s0

	jal	check			#Jump to check
	
	srl	$t5, $t5, 5		#Shift right 5 bits to evaluate the 7th bit
	move	$s2, $t5		
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	srl	$t5, $t5, 1		#Shift right 1 bit to evaluate the 6th bit
	move	$s2, $t5
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	srl	$t5, $t5, 1		#Shift right 1 bit to evaluate the 5th bit
	move	$s2, $t5
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	srl	$t5, $t5, 1		#Shift right 1 bit to evaluate the 4th bit
	move	$s2, $t5
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	move	$t4, $t7		#Move $t7 to $t4
	
	j	parityEight		#Jump to parityEight

parityEight:
	li	$s1, 1			#$s1 = 1
	li	$t7, 0			#Set counter $t7 = 0
	
	addi	$t5, $zero, 0		#$t5 = 0
	add	$t5, $t5, $t3		#Move the 12-bit hamming code in $t3 to $t5
	
	move	$s2, $t5		#Move $t5 to $s2
	andi	$t0, $s2, 1		#See if the last bit is a 1 or a 0 for the 12th bit
	move 	$s0, $t0		#Move $t0 to $s0

	jal	check			#Jump check
	
	srl	$t5, $t5, 1		#Shift right 1 bit to evaluate the 11th bit
	move	$s2, $t5
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	srl	$t5, $t5, 1		#Shift right 1 bit to evaluate the 10th bit
	move	$s2, $t5
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	srl	$t5, $t5, 1		#Shift right 1 bit to evaluate the 9th bit
	move	$s2, $t5
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	srl	$t5, $t5, 1		#Shift right 1 bit to evaluate the 8th bit
	move	$s2, $t5
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	move	$t8, $t7		#Move $t7 to $t8
	
	j	checkForError		#Jump to checkForError

check:
	beq	$s0, $s1, increment	#If $s0 == $s1 go to increment
	jr	$ra			#Return to jal statement

increment:
	add	$t7, $t7, 1		#$t7 = $t7 + 1
	jr	$ra			#Return to jal statement

checkForError:				#If values in $t1, $t2, $t4, $t8 are even there is no change, if 
					#odd they must be added to the counter of the index to be inverted
					
	addi	$t5, $zero, 0		#$t5 = 0
	li	$s1, 0			#$s1 = 0

	move	$s0, $t1		#Move $t1 to $s0 (check value in $t1)
	andi	$t0, $s0, 1		#If last digit in $s0 is 1, $t0 = 1. Else $t0 = 0
	move	$s1, $t0		#Move $t0 to $s1
	
	jal	errorValue1		#Jump to errorValue1
	
	move	$s0, $t2		#Repeat checking if value in $t2 is odd or even
	andi	$t0, $s0, 1	
	move	$s1, $t0
	
	jal	errorValue2
	
	move	$s0, $t4		#Repeat checking if value in $t4 is odd or even
	andi	$t0, $s0, 1
	move	$s1, $t0
	
	jal	errorValue4
	
	move	$s0, $t8		#Repeat checking if value in $t8 is odd or even
	andi	$t0, $s0, 1
	move	$s1, $t0
	
	jal	errorValue8
	
	j	checkForFix		#Jump to checkForFix
	
errorValue1:
	beq	$s1, 1, addOne		#If $s1 == 1, go to addOne
	jr	$ra
addOne:	
	add	$t5, $t5, 1		#Increment value of invalid bit by 1
	jr	$ra
	
errorValue2:
	beq	$s1, 1, addTwo		#If $s1 == 1, go to addTwo
	jr	$ra
addTwo:	
	add	$t5, $t5, 2		#Increment value of invalid bit by 2
	jr	$ra
errorValue4:
	beq	$s1, 1, addFour		#If $s1 == 1, go to addFour
	jr	$ra
addFour:	
	add	$t5, $t5, 4		#Increment value of invalid bit by 4
	jr	$ra
errorValue8:
	beq	$s1, 1, addEight	#If $s1 == 1, go to addEight
	jr	$ra
addEight:		
	add	$t5, $t5, 8		#Increment value of invalid bit by 8
	jr	$ra
	

	
checkForFix:				#if $t5 == 0 there is no error
					#else, go to bit of $t5 and invert it to correct code.
						
	li	$t1, 12			#t1 = 12
	li	$t2, 0			#t2 = 0
	li	$s0, 1			#s0 = 1
	li	$s2, 0			#s2 = 0
	li	$t6, 0			#$t6 = 0, final string
	
	addi	$t4, $zero, 0		#$t4 = 0
	addi	$t6, $zero, 0		#$t6 = 0
	add	$t4, $t4, $t3		#$t4 = $t4 + $t3, $t4 = the original hamming code
	
	move 	$s1, $t5		#Move $t5 to $s1, index of bit to invert
	beqz	$s1, noError		#If $s1 == 0, go to noError
	
fixLoop:
	beq 	$s0, $s1, flipBit	#If $s0 == value to change, filp
	
	sub	$t2, $t1, $s0		#$t2 = $t1 - $s0
	srlv	$t4, $t4, $t2		#Shift $t4 right $t2 bits
	
	move	$s2, $t4		#Move $t4 to $s2
	or	$t6, $t6, $s2 		#Combine the strings $t6 and $s2 into $t6
	add	$s0, $s0, 1		#$s0 = $s0 + 1 (Increment counter)
	
	beq	$s0, 13, stringFixed	#If $s0 == 13, go to String
	
	addi	$t4, $zero, 0		#$t4 = 0
	add	$t4, $t4, $t3		#$t4 = $t4 + $t3, $t4 = the orignial hamming code
	sll	$t6, $t6, 1		#Shift the result string left 1 bit
	
	j	fixLoop			#Jump to fixLoop
	
flipBit:
	li	$t7, 0			#$t7 = 0

	sub	$t2, $t1, $s0		#$t2 = $t1 - $s0
	srlv	$t4, $t4, $t2		#Shift $t4 by $t2 bits to the right
	
	move	$s2, $t4		#Move $t4 to $s2
	andi	$t7, $s2, 1		#Check if the bit in the furthest position right is 0 or 1
	move	$s4, $t7		#Move $t7 to $s4
	
	beq	$s4, 1, flipToZero	#If $s4 == 1, flipToZero
	beq	$s4, 0, flipToOne	#If $s4 == 0, flipToOne
	
flipToZero:
	addi	$t4, $zero, 0		#$t4 = 0
	add	$t4, $t4, $t3		#$t4 = $t4 + $t3, $t4 = the original hamming code

	sub	$t2, $t1, $s0		#$t2 = $t1 - $s0
	srlv	$t4, $t4, $t2		#Shift $t4 by $t2 bits to the right
	
	move	$s2, $t4		#Move $t4 to $s2
	or	$t6, $t6, $s2 		#Combine strings
	sub	$t6, $t6, 1		#Change last bit from 1 to 0
	add	$s0, $s0, 1		#Increment counter by 1
	
	j	finishResult		#Jump to finish result
	
flipToOne:
	addi	$t4, $zero, 0		#Same as above block of code flipToZero,
	add	$t4, $t4, $t3		#except 1 is added to $t6 to change the bit 
					#from 0 to 1
	sub	$t2, $t1, $s0		
	srlv	$t4, $t4, $t2
	
	move	$s2, $t4
	or	$t6, $t6, $s2 
	add	$t6, $t6, 1
	add	$s0, $s0, 1
	
	j	finishResult	
	
finishResult:
	beq 	$s0, 13, stringFixed	#If $s0 == 13, go to stringFixed
	
	addi	$t4, $zero, 0		#$t4 = 0
	add	$t4, $t4, $t3		#$t4 = $t4 + $t3
	sll	$t6, $t6, 1		#Shift $t6 by 1 bit to the left
	
	sub	$t2, $t1, $s0		#$t2 = $t1 - $s0
	srlv	$t4, $t4, $t2		#Shift $t4 by $t2 bits to the right
	
	move	$s2, $t4		#Move $t4 to $s2
	andi	$t0, $s2, 1		#Set the $t0 = to 1 or 0 if the last bit in $s2 is a 1 or 0
	move	$s2, $t0		#Move $t0 to $s2
	add	$s0, $s0, 1		#$s0 = $s0 + 1
	
	j	bitIsOne		#Jump to bitIsOne
	
bitIsOne:
	beqz	$s2, finishResult	#If $s2 == 0, go to finishResult and last bit in $t6 remains 0
	add	$t6, $t6, 1		#Set the bit in the last bit of $t6 to 1
	j 	finishResult		#Jump to finishResult
	
noError:
	add	$t6, $t6, $t4		#Set $t6 = the hamming code input by user in $t4
	
	li	$v0, 4			#Code to print string
	la	$a0, correct		#Load address of string to print	
	syscall				#Print string
	
	j	end			#Jump to end
	
stringFixed:
	li	$v0, 4			#Code to print string
	la	$a0, incorrect		#Load address of string to print	
	syscall				#Print string
	
	li	$v0, 34			#Code to print number in hexadecimal
	move	$a0, $t6		#Move $t6 to $a0
	syscall				#Print number in hexidecimal
	
	j 	end			#Jump to end

end:
	li	$v0, 10			#Load code to end program
	syscall				#End program
