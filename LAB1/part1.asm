	.text
	#array pointers
	la	$t7, array
	la	$t8, array
	la	$t9, array
#get the number of elements from user
	la	$a0, message1	#"Number of elements: "
	li	$v0, 4
	syscall
	
	li 	$v0, 5
    	syscall

   	# Move the no of elements to $t0
   	move 	$t0, $v0
 	
 	
 	la	$a0, message5  #"Enter inputs one by one\n"
	li	$v0, 4
	syscall	
	
 	
 	li 	$t3,0 #index 
   	
getVal:	la	$a0, message2	#"Input: "
	li	$v0, 4
	syscall
	
	# Get user input
	li 	$v0, 5
    	syscall
    	   	
    	move 	$t1, $v0

	sw 	$t1, 0($t7)	#store user input in the array
   	
   	add 	$t3, $t3, 1		#increment the index 
   	
   	add 	$t7, $t7, 4
   	
   	blt 	$t3,$t0, getVal

   	addi 	$t7, $t7, -4   	
#display array content
	la	$a0, message3	#"Array:"
	li	$v0, 4
	syscall 
	

  	li 	$t3,0 #reset index 
 
printVal:	la	$a0, space
		li	$v0, 4
		syscall
			
    	   	
    	   	# Printing out the number
    		lw 	$a0, 0($t8)
  		li 	$v0, 1 	
   		syscall
   	
   		addi 	$t3, $t3, 1	#increment the index 
   		addi 	$t8, $t8, 4
   	
   		blt 	$t3,$t0, printVal

		addi 	$t8, $t8, -4
 
	
		la	$a0, message4	#"Is polindrom: "
		li	$v0, 4
		syscall 

 		addi	$t9,$t9, -4
		addi	$t8,$t8, 4
 		
pol:	ble	$t8,$t9 printYes	#if all inputs are processed and satisfy the polindrom condition, print yes
	
	addi	$t9,$t9,4
	addi	$t8,$t8,-4
	
	lw	$t5, 0($t9)
	lw	$t6, 0($t8)
	
	beq	$t5,$t6,pol
	
	la	$a0, no
	li	$v0, 4
	syscall
	j	done
	
printYes:	la	$a0, yes
		li	$v0, 4
		syscall	
	   	   	   	    	   	   	   	    	   	   	   	   	   	   	    	   	   	   	    	   	   	   	
#stop execution
done:	li	$v0, 10
	syscall
	
		.data
array: 		.space 80
message1:	.asciiz	"Number of elements: "
message2:	.asciiz	"Input: "
message3:	.asciiz	"Array:"
space:		.asciiz "  "
message4:	.asciiz "\nIs polindrom: "
yes:		.asciiz "YES"
no:		.asciiz "NO"
message5:	.asciiz "Enter inputs one by one\n"
	
