	.text	
main:	la	$a0, menu
	li	$v0, 4
	syscall

	li 	$v0, 5
	syscall
	
	move 	$t0, $v0 
	
	li $t1, 1
	li $t2, 2
	li $t3, 3
	
	beq $t0, $t1, option1 #checkPattern
	beq $t0, $t2, option2 #recursiveSummation
	beq $t0, $t3, stop   
	
option1: 



	j main

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
            		addi $t0, $0, 2    
            		slt  $t0, $s0, $t0 # s0 <= 1 ?
            		beq  $t0, $0, else # no: go to else  
            		addi $v0, $0, 1    # yes: return 1
            		addi $sp, $sp, 8   # restore $sp
            		jr   $ra           # return
      	      else: 	addi $s0, $s0, -1  # n = n - 1
            		jal  recursiveSummation     # recursive call: 
                                   			# recursiveSummation(N-1)
            		lw   $s0, 4($sp)   # pop $a0 (= saved n)
            		add  $v0, $s0, $v0 # N + recursiveSummation(N-1)
            		lw   $ra, 0($sp)   # pop $ra
            		addi $sp, $sp, 8   # restore $sp
            		jr   $ra           # return			

		
stop: 	li	$v0, 10
	syscall				
								
		.data
menu:		.asciiz " Menu \n1-checkPattern\n2-recursiveSummation \n3-stop \nEnter the number of the subprogram you want to run: "		
enterN:		.asciiz "N: "	
resultMessage:	.asciiz "Result of summation: "
endl:		.asciiz "\n"
