#Name:  	Mitchell R. Garnatz
#Assignment:	Assignment 9
#Description:	This program computes the maximum performance gain using Amdahl's law
#		by taking inputs from the user for a number of processors and 
#		a percent. The output is then displayed, and the program jumps
#		back to repeat again.

.data		
processors:	.asciiz "Number of processors: "	
percent:	.asciiz "Percent: "
invalid:	.asciiz "The input was invalid.\n\n"
output:		.asciiz "The maximum performance gain: "
newInput:	.asciiz "\n\n"

.text
main:		
	li	$t0, 0			#$t0 = 0
	li	$t4, 100		#$t4 = 100

	li	$v0, 4			#Code to print string
	la	$a0, processors		#Load address of string to print
	syscall				#Print string
	
	li	$v0, 5			#Code to get integer from user
	syscall				#Get integer
	move	$t1, $v0		#Move $v0 to $t1
	
	sgt	$s0, $t1, $t0		#Set $s0 = 1 if $t1 > $t0, else 0
	
processorInput:
	beqz	$t1, endProgram		#If $t1 == 0, go to endProgram
	beq	$s0, 1, percentInput	#If $s0 == 1, go to percentInput
	
	li	$v0, 4			#Code to print string
	la 	$a0, invalid		#Load address of string to print
	syscall				#Print string
			
	li	$v0, 4			#Code to print string
	la	$a0, processors		#Load address of string to print
	syscall				#Print string
	
	li	$v0, 5			#Code to get integer from user
	syscall				#Get integer
	move	$t1, $v0		#Move $v0 to $t1
	
	sgt	$s0, $t1, $t0		#Set $s0 = 1 if $t1 > 0, else 0
	
	j	processorInput		#Jump to processorInput
	
percentInput:
	li	$v0, 4			#Code to print string
	la	$a0, percent		#Load address of string to print
	syscall				#Print string
	
	li 	$v0, 5			#Code to get integer from the user
	syscall				#Get integer
	move	$t2, $v0		#Move $v0 to $t2
	
	sgt	$s0, $t2, $t0		#Set $s0 = 1 if $t2 > 0
	slt	$s1, $t2, $t4		#Set $s1 = 1 if $t2 < 100
	
percentLoop:	
	beq	$s0, $s1, exitInput	#If $s0 = $s1, go to exitInput
	
	li	$v0, 4			#Code to print string
	la	$a0, percent		#Load address of string to print
	syscall				#Print string
	
	li 	$v0, 5			#Code to get integer from user
	syscall				#Get integer
	move	$t2, $v0		#Move $v0 to $t2
	
	sgt	$s0, $t2, $t0		#Set $s0 = 1 if $t2 > 0
	slt	$s1, $t2, $t4		#Set $s1 = 1 if $t2 < 100
	
	j 	percentLoop		#Jump to percentLoop
	
exitInput:	
	li	$t0, 1			#$t0 = 1
	
	mtc1 	$t4, $f0		#Move $t4 to coprocessor $f0 (100.0)
	cvt.s.w $f0, $f0		#Convert to float
	
	mtc1 	$t2, $f1		#Move $t2 to coprocessor $f1 (percent)
	cvt.s.w $f1, $f1		#Convert to float
	
	mtc1 	$t1, $f2		#Move $t1 to coprocessor $f2 (processor)
	cvt.s.w $f2, $f2		#Convert to float
	
	mtc1 	$t0, $f3		#Move $0 to coprocessor $f3  (1.0)
	cvt.s.w $f3, $f3		#Convert to float
	
	div.s	$f10, $f1, $f0		#$f10 = $f1 / $f0   	 (percent / 100.0)
	sub.s	$f11, $f3, $f10		#$f11 = $f3 - $f10   	(1 - p)
	div.s	$f12, $f10, $f2		#$f12 = $f10 / $f2	(p / n)
	add.s	$f13, $f11, $f12	#$f13 = $f11 + $f12	(1-p) + (p/n)
	div.s	$f14, $f3, $f13		#$f14  = $f3 / $f13 	1 / ((1-p) + (p/n))
	
	li	$v0, 4			#Code to print string
	la	$a0, output		#Load address of string to print
	syscall				#Print string
	
	li	$v0, 2			#Code to print float
	mov.s	$f12, $f14		#Move result held in $f14 to $f12
	syscall				#Print float (maximum performance gain)
	
	li	$v0, 4			#Code to print string
	la	$a0, newInput		#Load address of string to print
	syscall				#Print string
	
	j main				#Jump to main

endProgram:
	li 	$v0, 10			#Load code to end program
	syscall				#End program