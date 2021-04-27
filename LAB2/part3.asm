	.text
main:	jal	createPopulateArray
	again:	
		jal 	delete

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
			
delete:	la	$a0, valueToDel
	li	$v0, 4
	syscall
	
	# Get user input
	li 	$v0, 5
    	syscall
    	   	
    	move 	$a2, $v0  # $a2 has the value to be deleted


	lw	$a0, 0($sp) #a0 beginning address of the array
	lw	$a1, 4($sp) #a1 size
	
	move 	$v1, $a1 # initialize new array size
	
	li 	$s3, 0
	
	loop1: 	beq 	$s3, $a1 done
		lw 	$s2, 0($a0)
		addi 	$s3, $s3, 1
		addi 	$a0, $a0, 4
		beq 	$a2, $s2, do1
		j loop1
					
	do1:	addi 	$v1, $v1, -1 
		j loop1
	
	done: 	sll 	$s0, $v1, 2 
		move 	$a0, $s0
		li 	$v0, 9
		syscall
				
		lw	$a0, 0($sp)	
		sw	$v0, 8($sp) #beginning address of the new array
				
		
		li 	$s3,0
		
		
	loop2: 	beq 	$s3, $a1 print
		lw 	$s2, 0($a0)
		addi 	$s3, $s3, 1
		addi 	$a0, $a0, 4
		bne 	$a2, $s2, do2
		j loop2	
	
	do2:	sw 	$s2, 0($v0)
		addi 	$v0, $v0,4
		j loop2
		
	
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
	
	lw 	$v0, 8($sp)
	sw	$v0, 0($sp)
	sw	$v1, 4($sp)
	jr	$ra
																
stop: 
	li	$v0, 10
	syscall	
	
		.data
valueToDel:	.asciiz "Enter the value to be deleted: "		
arraysize:	.asciiz "Array size: "	
continueOrNot:	.asciiz "Enter 0 to stop, 1 to compress array: "
endl:		.asciiz "\n"	
enterelem:	.asciiz "enter elements one by one\n"
input:		.asciiz "Input: "
space:		.asciiz "  "
Arr:		.asciiz "Orijinal Array:"
Arr2:		.asciiz "New Array:"

	
