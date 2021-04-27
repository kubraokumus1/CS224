	.text	
main:	#get input number from user
	la	$a0, input
	li	$v0, 4
	syscall
		
	li 	$v0, 5
	syscall
	
	move 	$s0, $v0 #s0 = input number
		
	#get n from user
	la	$a0, n
	li	$v0, 4
	syscall
	
	li 	$v0, 5
	syscall
	
	move 	$s1, $v0 #s1 = n
	
	
	la	$a0, ($s0)
	li	$v0, 34
	syscall
	
	la 	$a0, endl
	li 	$v0, 4
	syscall
	
	li 	$s5, 32	
	sub	$s3, $s5, $s1 #s3 = 32-n
	
	ori 	$s2, $zero, -1  #s2 = 0xffffffff
	
	srlv	$s2, $s2, $s3
	
	xor	$s0, $s0, $s2
	
	move	$a0, $s0
	li	$v0, 34
	syscall
	
	
	la 	$a0, endl
	li 	$v0, 4
	syscall
	
	
	#ask user if s/he whats to continue
	la 	$a0, continueOrNot
	li 	$v0, 4
	syscall
	
	
	li 	$v0, 5
	syscall
	
	move	$s4, $v0
	 
	la 	$a0, endl
	li 	$v0, 4
	syscall
	
	bnez 	$s4, main 
				
 	li	$v0, 10
	syscall	
	
	
		.data
input:		.asciiz "input number: "	
n:		.asciiz "n: "
endl:		.asciiz "\n"
continueOrNot:	.asciiz "Do you want to continue? Enter 0 to stop: "

