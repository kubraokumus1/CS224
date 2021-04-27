	.text
	.globl main	

main:

# get a
	la	$a0, geta
	li	$v0, 4
	syscall

	li 	$v0, 5
    	syscall

    	move 	$a3, $v0 #a0 = a
    	
# get b
	la	$a0, getb
	li	$v0, 4
	syscall

	li 	$v0, 5
    	syscall

    	move 	$a2, $v0	

# get c
	la	$a0, getc
	li	$v0, 4
	syscall

	li 	$v0, 5
    	syscall

    	move 	$a1, $v0    	    	

# get d
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

compute:	sub 	$t0, $a2, $a1 	#t0 = b-c
		mult 	$a3,$t0 	# a*(b-c) 	
		mflo 	$t1
		div 	$t1, $a0   	# a*(b-c) % d
		mfhi 	$t3
		jr 	$ra 
	.data
geta:	.asciiz	"a: "
getb:	.asciiz	"b: "
getc:	.asciiz	"c: "
getd:	.asciiz	"d: "
result: .asciiz "a * (b - c) % d = "
