
	.text
main: 
#get array size
	la 	$a0, arraysize
	li 	$v0, 4
	syscall
			
	li 	$v0, 5
	syscall
	
	move 	$a1, $v0 #a1 = array size
	jal	createPopulateArray
	
	la 	$a0, ispalindrom
	li 	$v0, 4
	syscall
	
	jal	checkdPalinrome
	
	la 	$a0, endl
	li 	$v0, 4
	syscall


	jal countFrequency
 	
 		
	#ask user if s/he whats to continue		
	la	$a0, continueOrNot
	li	$v0, 4
	syscall
	
	
	li 	$v0, 5
	syscall
	
	move	$t0, $v0
	
	la 	$a0, endl
	li 	$v0, 4
	syscall
	
	bnez 	$t0, main 
				
	j stop


createPopulateArray:	#dynamic allocation
			sll 	$s0, $a1, 2 
			move 	$a0, $s0
			li 	$v0, 9
			syscall
			
			
			move 	$s1, $v0  #s1 = beginning address of the array
			move 	$s4, $v0
			
			
			addi 	$sp, $sp, -4
			sw	$s1, 0($sp)
			
			addi	$s4, $s4, -4 
			
			la 	$a0, enterelem
			li 	$v0, 4
			syscall
			
			move 	$s3, $a1
			addi 	$sp, $sp, -4
			sw	$s1, 0($sp) 
			
			getVal:	la	$a0, input	#"Input: "
				li	$v0, 4
				syscall
	
				# Get user input
				li 	$v0, 5
    				syscall
    	   	
    				move 	$s2, $v0  # $t2 has the input value

				sw 	$s2, 0($s1)	#store user input in the array 	
   				add 	$s1, $s1, 4
   				addi 	$s3, $s3, -1	
   				bnez 	$s3, getVal	
   				
			jr	$ra

checkdPalinrome:ble	$s1, $s4 printYes	#if all inputs are processed and satisfy the polindrom condition, print yes
	
		addi	$s4, $s4, 4
		addi	$s1, $s1, -4
	
		lw	$s5, 0($s4)
		lw	$s6, 0($s1)
	
		beq	$s5, $s6,checkdPalinrome
	
		la	$a0, no
		li	$v0, 4
		syscall
		jr	$ra
	
printYes:	la	$a0, yes
		li	$v0, 4
		syscall	
		jr	$ra
			

countFrequency:	la 	$a0, index
		li 	$v0, 4
		syscall
			
		li 	$v0, 5
		syscall
			
		move 	$a2, $v0 # a2= index
		
		lw	$a0, 0($sp)
		addi 	$sp, $sp, 4

		sll 	$s5, $a2, 2 #find adress of the element
		add 	$a0, $a0, $s5 
		lw 	$s6, ($a0) # s6 stores the value in the given index

		li 	$s4, 0 # s4 = counter				
		
		sub 	$a0,$a0,$s5 #a0 points to the first element
		
		loop:	lw 	$s2, 0($a0)
			beq 	$s6, $s2, increment #if they are equal, increment the counter 
			continue:	addi 	$s3, $s3, 1 #incremet the index
					addi 	$a0, $a0, 4
					blt 	$s3, $a1, loop
					beq	$s3, $a1, done
		
			increment:	addi 	$s4,$s4,1 
					j continue
		
			
		done: 	#print the no of occurences of the number in the given index
			la 	$a0, noOfOccur
			li 	$v0, 4
			syscall
		
			move $a0, $s4
			li $v0, 1
			syscall
			
			la $a0, endl
			li $v0, 4
			syscall
		
		jr	$ra

stop: 	li	$v0, 10
	syscall
   		  	
   	
		.data
arraysize:	.asciiz "Array size: "	
enterelem:	.asciiz "enter elements one by one\n"
input:		.asciiz "Input: "
yes:		.asciiz "YES"
no:		.asciiz "NO"
ispalindrom:	.asciiz "Is Palindrom: "
continueOrNot:	.asciiz "Do you want to continue? Enter 0 to stop: "
endl:		.asciiz "\n"
index: 		.asciiz "index: "
noOfOccur:	.asciiz "No of occurrences: " 
