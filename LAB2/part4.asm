	.text
main:	jal createPopulateArray

	again:	
	      	jal cMult

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
		 
	beq	$t0, 1, again
	bnez 	$t0, main
				
	j stop
	
createPopulateArray:	#get array size
			la 	$a0, arraysize
			li 	$v0, 4
			syscall
			
			li 	$v0, 5
			syscall
	
			move 	$a1, $v0 #a1 = array size

			#dynamic allocation
			sll 	$s0, $a1, 2 
			move 	$a0, $s0
			li 	$v0, 9
			syscall
						
			move 	$s1, $v0  #s1 = beginning address of the array
			move 	$a0, $v0
			li 	$s3, 0
						
			addi 	$sp, $sp, -12
			sw	$a0, 0($sp)
			sw	$a1, 4($sp)
			
			la 	$a0, enterelem
			li 	$v0, 4
			syscall
			
			move 	$s3, $a1

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

   			printArr: 	la	$a0, Arr #"Orijinal Array: ["
					li	$v0, 4
					syscall
   			
   					lw	$s1, 0($sp) #a0 beginning address of the array
   					printVal:	la	$a0, space
							li	$v0, 4
							syscall
			    	   	
    	   						# Printing out the number
    							lw 	$a0, 0($s1)
  							li 	$v0, 1 	
   							syscall
   	
   							addi 	$s3, $s3, 1	#increment the index 
   							addi 	$s1, $s1, 4
   	
   							blt 	$s3, $a1, printVal
									
   					la	$a0, endl	
					li	$v0, 4
					syscall		  											
			jr	$ra

cMult:	la	$a0, low
	li	$v0, 4
	syscall
	
	# Get user input
	li 	$v0, 5
    	syscall
    	   	
    	move 	$a2, $v0  # $a1 has the beginning of the range
    	
    	la	$a0, high
	li	$v0, 4
	syscall
	
	# Get user input
	li 	$v0, 5
    	syscall
    	   	
    	lw	$a0, 0($sp) #a0 beginning address of the array
	lw	$a1, 4($sp) #a1 size   	
    	move 	$a3, $v0  # $a3 contains the end of the range
    	
    	move $s6, $a0 #copy the array pointer
    	move $v1, $a1 # initialize new array size
    					
delete:		
	li $s3,0 #no of items processed
	
	loop1: 	beq  	$s3, $a1 done
		lw  	$s2, 0($a0)
		addi 	$s3, $s3, 1
		addi	$a0, $a0, 4
		beq 	$a2, $s2, do1
		j loop1
					
	do1:	addi $v1, $v1, -1 
		j loop1
	
	done: 	sll 	$s0, $v1, 2 
		move 	$a0, $s0
		li 	$v0, 9
		syscall
				
		move	$a0, $s6	#a0 points to the beginning of the array again
		sw	$v0, 8($sp) 	#store beginning address of the new array in sp
						
		li $s3,0 #reset the no of items processed		
		
	loop2: 	beq 	$s3,$a1 next
		lw 	$s2, 0($a0)
		addi 	$s3, $s3, 1
		addi 	$a0, $a0, 4
		bne 	$a2, $s2, do2
		j loop2	
	
	do2:	sw 	$s2, 0($v0)
		addi 	$v0, $v0,4
		j loop2
			
	next:	move 	$a1, $v1 # 
		lw 	$a0, 8($sp) #a0 points to the new array
		move 	$s6, $a0  #copy the new array pointer
		addi 	$a2, $a2, 1
		ble 	$a2, $a3, delete
		
	lw 	$a0, 0($sp)
	lw	$a1, 4($sp) #a1 size
	print:	la	$a0, Arr2 
		li	$v0, 4
		syscall
		
		lw 	$s1, 8($sp)
		li 	$s3, 0
		printVal2:	la	$a0, space
				li	$v0, 4
				syscall
			   	   	
    	   			# Printing out the number
    				lw 	$a0, 0($s1)
  				li 	$v0, 1 	
   				syscall
   	
   				addi 	$s3, $s3, 1	#increment the index 
   				addi 	$s1, $s1, 4
   	
   				blt 	$s3, $v1, printVal2
	la	$a0, endl	
	li	$v0, 4
	syscall	
	
	lw $v0, 8($sp)
	sw	$v0, 0($sp)
	sw	$v1, 4($sp)
	jr	$ra
	
																
stop: 
	li	$v0, 10
	syscall	
	
		.data
low:		.asciiz "Enter the beginning of the range: "	
high:		.asciiz "Enter the end of the range: "		
arraysize:	.asciiz "Array size: "	
continueOrNot:	.asciiz "Enter 0 to stop, 1 to compress multible array: "
endl:		.asciiz "\n"	
enterelem:	.asciiz "enter elements one by one\n"
input:		.asciiz "Input: "
space:		.asciiz "  "
Arr:		.asciiz "Orijinal Array:"
Arr2:		.asciiz "New Array:"

	
