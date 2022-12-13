#Name:  	Mitchell R. Garnatz
#Assignment:	Assignment 8, Program 1
#Description:	Requests the user to enter a byte of data and then create the 12-bit 
#		Hamming code. The program is to then output this in hex.

.data		
inputByte:	.asciiz "\nInput a byte in decimal: "
outputPrompt:	.asciiz "The 12-bit Hamming code is: "	

.text
main:	
	li	$t2, 255		#$t2 = 255
	li	$t0, 0			#$t0 = 0
	li	$t1, 1			#$t1 = 0
	
	li	$s4, 1			#1, $s4 = 1
	li	$s5, 2			#2, $s5 = 2
	li	$s6, 4			#4, $s6 = 4
	li	$s7, 8			#8, $s7 = 8
	li	$t5, 0			#counter = 0
	li	$t7, 0			#$t7 = 0

	li 	$v0, 4			#Code to print string
	la 	$a0, inputByte		#Load address of string to print
	syscall				#Print inputByte string
	
	li 	$v0, 5			#Code to get integer from user
	syscall				#Get user input for integer
	move	$t3, $v0		#Move byte input to $t3 from $v0
	
	slt	$s0, $t3, $t0		#Input must be between 0 and 255
	sgt	$s1, $t3, $t2		# 0 <= $t3 <= 255
	
Loop1:	
	beq	$s0, $s1, parityOne	#If $s0 == $s1, go to parityOne
	
	li 	$v0, 4		
	la 	$a0, inputByte		#Input invalid, request another integer input
	syscall				#by repeating input code
	
	li 	$v0, 5
	syscall	
	move	$t3, $v0
	
	slt	$s0, $t3, $t0
	sgt	$s1, $t3, $t2
	
	j Loop1				#Jump to Loop1
	
parityOne:				#Evaluate bits 11, 9, 7, 5, 3

	li	$s1, 1			#$s1 = 1
	li	$t6, 0			#$t6 = 0
	li	$t7, 0			#$t7 = 0
	
	addi	$t4, $zero, 0		#$t40 = 0
	add	$t4, $t4, $t3		#$t4 = $t4 + $t3, $t4 = input byte
	
	srl	$t4, $t4, 1		#Shift $t4 by 1 bit to evaluate the 11th bit
	move	$s2, $t4		#Move $t4 to $s2
	andi	$t0, $s2, 1		#And the last bit in $s2 with 1
	move 	$s0, $t0		#Move resutl to $s0

	jal	check			#Jump and link to check
	
	srl	$t4, $t4, 2		#Shift $t4 by 2 bits to evaluate the 9th bit
	move	$s2, $t4
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	
	srl	$t4, $t4, 1		#Shift $t4 by 1 bit to evaluate the 7th bit
	move	$s2, $t4
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	srl	$t4, $t4, 2		#Shift $t4 by 2 bits to evaluate the 5th bit
	move	$s2, $t4
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	srl	$t4, $t4, 1		#Shift $t4 by 1 bit to evaluate the 3rd bit
	move	$s2, $t4
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	move	$s4, $t5		#Move $t5 to $s4
	
	j	parityTwo		#Jump to parityTwo

parityTwo:				#Evaluate bits 11, 10, 7, 6, 3

	li	$s1, 1			#s1 = 1
	li	$t6, 0			#$t6 = 0
	li	$t7, 0			#$t7 = 0
	li	$t5, 0			#$t5 = 0
	
	addi	$t4, $zero, 0		#$t4 = 0
	add	$t4, $t4, $t3		#$t4 = $t4 + $t3
	
	srl	$t4, $t4, 1		#Shift $t4 by 1 bit to evaluate the 11th bit
	move	$s2, $t4		#Move $t4 to $s2
	andi	$t0, $s2, 1		#And the last bit of $s2 with 1
	move 	$s0, $t0		#Move $t0 to $s0
	
	jal	check
	
	srl	$t4, $t4, 1		#Shift $t4 by 1 bit to evaluate the 10th bit
	move	$s2, $t4
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	srl	$t4, $t4, 2		#Shift $t4 by 2 bits to evaluate the 7th bit
	move	$s2, $t4
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	srl	$t4, $t4, 1		#Shift $t4 by 1 bits to evaluate the 6th bit
	move	$s2, $t4
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	srl	$t4, $t4, 2		#Shift $t4 by 2 bits to evaluate the 3rd bit
	move	$s2, $t4
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	move	$s5, $t5		#Move $t5 to $s5
	
	j	parityFour		#Jump parityFour
	
parityFour:				#Evaluate bits 12, 7, 6, 5
	li	$s1, 1
	li	$t6, 0
	li	$t7, 0
	li	$t5, 0
	
	addi	$t4, $zero, 0
	add	$t4, $t4, $t3		
	
	move	$s2, $t4		#Shift $t4 by 0 bits to evaluate the 12th bit
	andi	$t0, $s2, 1		
	move 	$s0, $t0

	jal	check
	
	srl	$t4, $t4, 4		#Shift $t4 by 4 bit to evaluate the 7th bit
	move	$s2, $t4
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	
	srl	$t4, $t4, 1		#Shift $t4 by 1 bit to evaluate the 6th bit
	move	$s2, $t4
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	srl	$t4, $t4, 1		#Shift $t4 by 1 bit to evaluate the 5th bit
	move	$s2, $t4
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	move	$s6, $t5		#Move $t5 to $s6
	
	j	parityEight		#Jump to parity Eight

parityEight:				#Evaluate bits 12, 11, 10, 9
	li	$s1, 1
	li	$t6, 0
	li	$t7, 0
	li	$t5, 0
	
	addi	$t4, $zero, 0
	add	$t4, $t4, $t3		
	
	move	$s2, $t4		#Shift $t4 by 0 bits to evaluate the 12th bit
	andi	$t0, $s2, 1		
	move 	$s0, $t0

	jal	check
	
	srl	$t4, $t4, 1		##Shift $t4 by 1 bit to evaluate the 11th bit
	move	$s2, $t4
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	
	srl	$t4, $t4, 1		#Shift $t4 by 1 bit to evaluate the 10th bit
	move	$s2, $t4
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	srl	$t4, $t4, 1		#Shift $t4 by 1 bits to evaluate the 9th bit
	move	$s2, $t4
	andi	$t0, $s2, 1		
	move 	$s0, $t0
	
	jal	check
	
	move	$s7, $t5		#Move $t5 to $s7
	
	j	setHammingVal		#Jump to setHammingVal

check:
	beq	$s0, $s1, increment	#If $s0 == $s1, go to increment
	jr	$ra			#Jump to register unconditionally

increment:
	add	$t5, $t5, 1		#$t5 = $t5 + 1
	jr	$ra			#Jump to register unconditionally
	
setHammingVal:				#Check values in $s4, $s5, $s6, and $s7
					#If odd, value = 1
					#If even, value = 0
	
	move	$s2, $s4		#Move $s4 to $s2
	andi	$t0, $s2, 1		#And immediate $s2 and 1
	move	$s4, $t0		#Move $t0 to $s4
	
	move	$s2, $s5		#Move $s5 to $s2
	andi	$t0, $s2, 1		#And immediate $s2 and 1
	move	$s5, $t0		#Move $t0 to $s5
	
	move	$s2, $s6		#Move $s6 to $s2
	andi	$t0, $s2, 1		#And immediate $s2 and 1
	move	$s6, $t0		#Move $t0 to $s6
	
	move	$s2, $s7		#Move $s7 to #s2
	andi	$t0, $s2, 1		#And immediate $s2 and 1
	move	$s7, $t0		#Move $t0 to $s7
	
	
hammingCodeVar:
	addi	$t0, $zero, 0		#Result  $t0 = 0
	addi	$t1, $zero, 1		#Counter $t1 = 0
	move	$s0, $t1
	
addOne:
	or	$t0, $s4, $t0		#Or $s4 and $t0, add first bit to hamming code
	sll	$t0, $t0, 1		#Shift $t0 left 1 bit
	
addTwoToThree:
	or 	$t0, $s5, $t0		#Or $s5 and $t0, add 2nd bit to hamming code
	sll	$t0, $t0, 1		#Shift $t0 left 1 bit
	
	addi	$t4, $zero, 0		#$t4 = 0
	add	$t4, $t4, $t3		#$t4 = $t4 + $t3, $t4 = original input byte
	srl	$t4, $t4, 7		#Shift $t4 right 7 bits to 3rd evaluate bit
	or	$t0, $t4, $t0		#Or $t4 and $t0
	sll	$t0, $t0, 1		#Shift $t0 left 1 bit
	
addFourToSeven:
	or 	$t0, $s6, $t0		#Or $t0 and $s6, add 4th bit to hamming code
	sll	$t0, $t0, 1		#Shift $t0 left 1 bit
	
	addi	$t4, $zero, 0		#$t4 = 0
	add	$t4, $t4, $t3		#$t4 = $t4 + $t3, $t4 = original input byte
	srl	$t4, $t4, 6		#Shift $t4 right 6 bits to 5th evaluate bit
	move	$s2, $t4		#Move $t4 to $s2
	andi	$t7, $s2, 1		#And immediate $s2 and 1, store in $t7
	move	$s4, $t7		#Move $t7 to $s4
	or	$t0, $s4, $t0		#Or $s4 and $t0
	sll	$t0, $t0, 1		#Shift $t0 left 1 bit
	
	
	addi	$t4, $zero, 0		#Repeat above steps
	add	$t4, $t4, $t3		
	srl	$t4, $t4, 5		#Shift $t4 right 5 bits to evaluate 6th bit
	move	$s2, $t4
	andi	$t7, $s2, 1
	move	$s4, $t7
	or	$t0, $s4, $t0		
	sll	$t0, $t0, 1		#Shift $t0 left 1 bit
	
	addi	$t4, $zero, 0
	add	$t4, $t4, $t3		
	srl	$t4, $t4, 4		#Shift $t4 right 4 bits to evaluate 7th bit
	move	$s2, $t4
	andi	$t7, $s2, 1
	move	$s4, $t7
	or	$t0, $s4, $t0		
	sll	$t0, $t0, 1		#Shift $t0 left 1 bit

addEightToTwelve:
	or 	$t0, $s7, $t0		#Or $s7 and $t0, add 8th bit to hamming code
	sll	$t0, $t0, 1		#Shift $t0 left 1 bit
	
	addi	$t4, $zero, 0		#$t4 = 0
	add	$t4, $t4, $t3		#$t4 = $t4 + $t3, $t4 = original input bit
	srl	$t4, $t4, 3		#Shift $t4 right 3 bits to evaluate 9th bit
	move	$s2, $t4		#Move $t4 to $s2
	andi	$t7, $s2, 1		#And immediate $s2 and 1, store result in $t7
	move	$s4, $t7		#Move $t7 to $s4
	or	$t0, $s4, $t0		#Or $s4 and $t0
	sll	$t0, $t0, 1		#Shift $t0 left 1 bit
	
	addi	$t4, $zero, 0		#Repeat above steps
	add	$t4, $t4, $t3		
	srl	$t4, $t4, 2		#Shift $t4 right 2 bits to evaluate 10th bit
	move	$s2, $t4
	andi	$t7, $s2, 1
	move	$s4, $t7
	or	$t0, $s4, $t0		
	sll	$t0, $t0, 1
	
	addi	$t4, $zero, 0
	add	$t4, $t4, $t3		
	srl	$t4, $t4, 1		#Shift $t4 right 1 bit to evaluate 11th bit
	move	$s2, $t4
	andi	$t7, $s2, 1
	move	$s4, $t7
	or	$t0, $s4, $t0		
	sll	$t0, $t0, 1
	
	addi	$t4, $zero, 0
	add	$t4, $t4, $t3		#Do not shift $t4 right, evaluate the 12th bit
	move	$s2, $t4		
	andi	$t7, $s2, 1
	move	$s4, $t7
	or	$t0, $s4, $t0		#After this Or statement the hamming code is fully constructed
	

end:
	li	$v0, 4			#Code to print string
	la	$a0, outputPrompt	#Load address of string to print
	syscall				#Print string
	
	li	$v0, 34			#Code to print integer in hex
	move	$a0, $t0		#Move $t0 t0 $a0
	syscall				#Print integer in hex
	
	li 	$v0, 10			#Code to end program
	syscall				#End program
	
	
	
	
	
	
	
	
	
