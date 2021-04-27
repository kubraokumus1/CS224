	.text	
main:	la	$a0, menu
	li	$v0, 4
	syscall

	li 	$v0, 5
	syscall
	
	move 	$t0, $v0 
	
	li 	$t1, 1
	li 	$t2, 2
	
	beq 	$t0, $t1, option1 #checkPattern
	beq 	$t0, $t2, option2 #recursiveSummation
	j stop   

#check pattern		
option1: 
	addi 	$sp, $sp, -16
	
	#get input value
	la	$a0, input
	li	$v0, 4
	syscall

	li 	$v0, 5
	syscall
	
	move 	$a1, $v0 # $a1 = input value
		
	# get n
	la	$a0, n
	li	$v0, 4
	syscall

	li 	$v0, 5
	syscall
	
	move 	$a2, $v0 # $a2 = n
	
	#get pattern
	la	$a0, pattern
	li	$v0, 4
	syscall

	li 	$v0, 5
	syscall
	
	move 	$a0, $v0 # $a0 = pattern to search
	sw 	$a0, 0($sp) # sp(0) = pattern
	
	#display the input in the binary form
	
	la	$a0, disInputLabel
	li	$v0, 4
	syscall
	
	move 	$a0, $a1
	li 	$v0, 35
   	syscall
   	
   	la	$a0, endl
	li	$v0, 4
	syscall
	
	#display the pattern in the binary form
	
	la	$a0, disPatternLabel
	li	$v0, 4
	syscall
	
	lw 	$a0, 0($sp) # a0 = pattern
	li 	$v0, 35
   	syscall
   	
   	la	$a0, endl
	li	$v0, 4
	syscall
		
	lw 	$a0, 0($sp) # a0 = pattern
	jal checkPattern
	j main
	
# a0 = pattern
# a1 = input to search
# a2 = n	
checkPattern:
	li $s0, -1
	li $s1, 32
	li $s3, 32 # to check how many bits are left to look at  
	li $s4, 0 #pattern matching counter
	
	sub $s1, $s1, $a2 # s1 = 32-n
	
	srlv $s0, $s0, $s1 # s0 is in the format like 000..000111  (in this case n = 3 so the 3 rightmost bits are 1)
		
	loop: 	sub $s3, $s3, $a2 # n bits which will be proceed
		blez $s3, done
		and $s2, $s0, $a1  # take n bits of the input value to check
		beq $a0, $s2, incCount # increment the counter if the pattern matches
		sllv $s0, $s0, $a2 # shift n bits left
		sllv $a0, $a0, $a2 # shift pattern to the n bits left
		j loop
	
	incCount:
		addi $s4, $s4, 1
		sllv $s0, $s0, $a2 # shift n bits left
		sllv $a0, $a0, $a2 # shift pattern to the n bits left
		j loop
	done:	
		#print count
		la	$a0, count
		li	$v0, 4
		syscall
		
		move $a0, $s4
		li $v0, 1
   		syscall
   		
   		la	$a0, endl
		li	$v0, 4
		syscall
		
		
		jr   $ra 
#recursiveSummation
option2:	#get N from user
		la	$a0, enterN
		li	$v0, 4
		syscall
	
		li 	$v0, 5
		syscall
	
		move 	$s0, $v0 #s0 = N
	
		la	$a0, resultMessage
		li	$v0, 4
		syscall
		
		jal recursiveSummation
		
		#print result
    		move $a0, $v0
    		li $v0, 1
   		syscall
   		
   		la	$a0, endl
		li	$v0, 4
		syscall
   	
   j main
	
recursiveSummation: 	addi $sp, $sp, -8  # make room for 2 items
            		sw   $s0, 4($sp)   # push $a0
           		sw   $ra, 0($sp)   # push $ra
            		li $s1,2   
            		slt  $s1, $s0, $s1# s0 <= 1 ?
            		beq  $s1, $0, else # no: go to else  
            		addi $v0, $0, 1    # yes: return 1
            		addi $sp, $sp, 8   # restore $sp
            		jr   $ra           # return
      	      else: 	addi $s0, $s0, -1  # n = n - 1
            		jal  recursiveSummation     # recursive call: 
                                   			# recursiveSummation(N-1)
            		lw   $s0, 4($sp)   # pop $s0 (= saved n)
            		add  $v0, $s0, $v0 # N + recursiveSummation(N-1)
            		lw   $ra, 0($sp)   # pop $ra
            		addi $sp, $sp, 8   # restore $sp
            		jr   $ra           # return			

		
stop: 	li	$v0, 10
	syscall				
								
		.data
menu:		.asciiz " Menu \n1-checkPattern\n2-recursiveSummation \nelse to stop \nEnter the number of the subprogram you want to run: "		
input:		.asciiz "Enter the integer input: "
disInputLabel: .asciiz "Input in binary: "
disPatternLabel:
		.asciiz "Pattern in binary: "
n:		.asciiz "Enter n: "
count:		.asciiz "Matching pattern count = "
pattern:	.asciiz "Enter the integer pattern: "
enterN:		.asciiz "N: "	
resultMessage:	.asciiz "Result of summation: "
endl:		.asciiz "\n"
