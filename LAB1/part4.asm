	.text
	.globl main	
main:
   	
# get B
	la	$a0, getb
	li	$v0, 4
	syscall

	li 	$v0, 5
    	syscall

    	move 	$a2, $v0	

# get C
	la	$a0, getc
	li	$v0, 4
	syscall

	li 	$v0, 5
    	syscall

    	move 	$a1, $v0    	    	

# get D
	la	$a0, getd
	li	$v0, 4
	syscall

	li 	$v0, 5
    	syscall

    	move 	$a0, $v0	
    	
 #compute and print the result   	
    	jal 	compute
    	   	
    	la	$a0, result
	li	$v0, 4
	syscall	
	
	li 	$v0, 1
    	move 	$a0, $t3
   	syscall
		
    		
#stop    			
    	li	$v0, 10
	syscall				

compute:	mult	$a2,$a1
		mflo	$t0		#t0 = b*c
		sub	$t1,$a0,$a1 	# t1 = d-c
		div	$t1,$a2
		mfhi	$t2 		#t2 = (d-c)modb
		div 	$t2,$a1   
		mflo 	$t3		# t3 = ((d-c)modb)/c
		add	$t3, $t0,$t3	#t3 = (b*c)+((d-c)modb)/c
		jr	$ra

	.data
getb:	.asciiz	"B: "
getc:	.asciiz	"C: "
getd:	.asciiz	"D: "
result: .asciiz "A = "
