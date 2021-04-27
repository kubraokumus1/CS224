	.text	
main:	la	$a0, enterN #ask user the no of nodes
	li	$v0, 4
	syscall
	
	li 	$v0, 5
	syscall
	
	move 	$a0, $v0 
	
	addi 	$sp, $sp, 16 # in case of this is the second call of main program, restore the sp 
	
# make room for 4 items in sp
# I will store the no of nodes in sp(0);
# address of the original linked list in sp(4);
# address of the recursively created linked list in sp(8);
# address of the iteratively created linked list in sp(12).	
	addi 	$sp, $sp, -16  			
	sw 	$a0, 0($sp) # no of nodes 
	jal	createLinkedList
	
menu:	la	$a0, menuM
	li	$v0, 4
	syscall

	li 	$v0, 5
	syscall
	
	move 	$t0, $v0 
	
	li 	$t1, 1
	li 	$t2, 2
	li 	$t3, 3
	li 	$t4, 4
		
	lw 	$a0, 4($sp) #$a0 points to the original list
	
	beq 	$t0, $zero, main # create a new linked list from user inputs
	beq 	$t0, $t1, display_Reverse_Order_Recursively 
	beq 	$t0, $t2, duplicateListIterative
	beq 	$t0, $t3, duplicateListRecursive 
	beq 	$t0, $t4, printLinkedList  
	j stop

display_Reverse_Order_Recursively:
	move 	$s2, $a0 # s2 points to first node for now
	
	la	$a0, displayReverseLabel
	li	$v0, 4
	syscall
	
recursive_call:
	addi 	$sp, $sp, -16  # make room for 4 items
	sw 	$s0, 12($sp)
	sw 	$s1, 8($sp)
	sw 	$s2, 4($sp)   # push beginning address
	sw 	$ra, 0($sp)   # push $ra
		
	lw 	$s0, 0($s2)
	lw 	$s1, 4($s2)
	bnez  	$s0, next
	jr   	$ra
	
next: 	move 	$s2, $s0   # next node
      	jal  	recursive_call
	
# printNode		
	move	$a0, $s1	# $s1: Data of current node
	li	$v0, 1		
	syscall	
   	
   	la	$a0, space
	li	$v0, 4
	syscall
	
	lw   	$ra, 0($sp)   # pop $ra
	lw 	$s0, 12($sp)
	lw 	$s1, 8($sp)
	lw 	$s2, 4($sp) 
	 
	addi 	$sp, $sp, 16   # restore $sp
	jr   	$ra
	  	 
duplicateListIterative: 
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move	$s0, $a0	# $s0: no. of nodes to be created.
	lw 	$s1, 0($s0) 	# address of the next node
	lw 	$s2, 4($s0)	# data value of the node

# Create the first node: header.
	li	$a0, 8
	li	$v0, 9
	syscall
# Save list head pointer 
	move	$s3, $v0	# $s3 points to the first and last node of the linked list.
	move	$s4, $v0	# $s4 now points to the list head.
	
	sw	$s2, 4($s4)	# Store the data value of the original node.
	
copyNode:
# No. of nodes created compared with the number of nodes to be created.
	beqz	$s1, done

	li	$a0, 8 		
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s4.
	sw	$v0, 0($s4)
# Now make $s4 pointing to the newly created node.
	move	$s4, $v0	# $s2 now points to the new node.
	move	$s0, $s1
	lw 	$s1, 0($s0) 	# address of the next node
	lw 	$s2, 4($s0)	#data value of the node

	sw	$s2, 4($s4)	# Store the data value.
	j	copyNode
done:
# The last node is pointed by $s2.
	sw	$zero, 0($s4)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	sw	$v0, 12($sp) #store the beginning address of the iteratively created linked list in sp(12)
	j menu
	
duplicateListRecursive: 
	addi 	$sp, $sp, -20 # make room for 4 items
	sw 	$s2, 16($sp)
	sw 	$s0, 12($sp)
	sw 	$s1, 8($sp)
	sw 	$a0, 4($sp)   # push $a0
	sw 	$ra, 0($sp)   # push $ra
		
	lw 	$s0, 0($a0)
	lw 	$s1, 4($a0)
	bnez  	$s0, nextNode
	
	#create last node
	li	$a0, 8 		
	li	$v0, 9
	syscall
	
	move 	$s2, $v0	#s2 points to the last node
	sw 	$s1, 4($s2)	#store data value of the last node of the original linked list
	
	addi 	$sp, $sp, 20  			
	jr   	$ra
nextNode: 
	move 	$a0, $s0   # next node
     	jal  	duplicateListRecursive
      
createNode: 
	li 	$a0, 8 		
	li 	$v0, 9
	syscall
		
	sw 	$s2, 0($v0) #connect to the next node
	sw 	$s1, 4($v0) #store the data of the original linked list

	lw 	$ra, 0($sp)   # pop $ra
	lw 	$s2, 16($sp)
	lw 	$s0, 12($sp)
	lw 	$s1, 8($sp)
	lw 	$a0, 4($sp)  
	addi 	$sp, $sp, 20  # restore $sp
	
	move 	$s2, $v0
	sw 	$v0, 8($sp)  #store the beginning address of the recursivly created list in sp(8)	
	jr   	$ra
	
createLinkedList:	
# $a0: No. of nodes to be created
# $v0: returns list head
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move	$s0, $a0	# $s0: no. of nodes to be created.
	li	$s1, 1		# $s1: Node counter
# Create the first node: header.
	li	$a0, 8
	li	$v0, 9
	syscall
#Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 points to the list head.	
# get the first data value from the user
	la	$a0, firstData
	li	$v0, 4
	syscall
	
	li 	$v0, 5
	syscall
	
	move 	$s4, $v0	
	sw	$s4, 4($s2)	# Store the data value.
	
addNode:
	beq	$s1, $s0, allDone
	addi	$s1, $s1, 1	# Increment node counter.
	
	li	$a0, 8 	
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.	
	
# get the next node data value from the user
	la	$a0, nextData
	li	$v0, 4
	syscall
	
	li 	$v0, 5
	syscall
	
	move 	$s4, $v0
	sw	$s4, 4($s2)	# Store the data value.	
	j	addNode
allDone:
# The last node is pointed by $s2.
	sw	$zero, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	sw 	$v0, 4($sp) #store the original list pointer in the sp(4)
	jr	$ra	
						
printLinkedList:
	addi	$sp, $sp, -16
	sw	$s0, 12($sp)
	sw	$s1, 8($sp)
	sw	$s2, 4($sp)
	sw	$s3, 0($sp)

	la	$a0, printMenuLabel
	li	$v0, 4
	syscall
	
	li 	$v0, 5
	syscall
	
	move 	$s0, $v0 
	
	li 	$s1, 1
	li 	$s2, 2
	li 	$s3, 3
	
	beq 	$s0, $s1, original	 
	beq 	$s0, $s2, iterativelyCreated
	beq 	$s0, $s3, recursivelyCreated
	
original: 
	lw	$s3, 0($sp)
	lw	$s2, 4($sp)
	lw	$s1, 8($sp)
	lw	$s0, 12($sp)
	addi	$sp, $sp, 16 #restore sp
	
	lw 	$a0, 4($sp)
 	j print
	  
recursivelyCreated:
	lw	$s3, 0($sp)
	lw	$s2, 4($sp)
	lw	$s1, 8($sp)
	lw	$s0, 12($sp)
	addi	$sp, $sp, 16 #restore sp
	
	lw 	$a0, 8($sp) # take the beginning address of the recursively created linked list
	j print
	 
iterativelyCreated:
	lw	$s3, 0($sp)
	lw	$s2, 4($sp)
	lw	$s1, 8($sp)
	lw	$s0, 12($sp)
	addi	$sp, $sp, 16 # restore sp
		
	lw 	$a0, 12($sp) # take the beginning address of the iteratively created linked list
	j print	  	  			  	  		
	
# Print linked list nodes in the following format
# --------------------------------------
# Node No: xxxx (dec)
# Address of Current Node: xxxx (hex)
# Address of Next Node: xxxx (hex)
# Data Value of Current Node: xxx (dec)
# --------------------------------------

print:	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

# $v0: points to the linked list.
# $s0: Address of current
# s1: Address of next
# $2: Data of current
# $s3: Node counter
	move 	$s0, $a0	# $s0: points to the current node.
	li   	$s3, 0
printNextNode:
	beq	$s0, $zero, printedAll
	lw	$s1, 0($s0)	
	lw	$s2, 4($s0)	
	addi	$s3, $s3, 1

	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s0: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	move	$a0, $s0
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	

# Now consider next node.
	move	$s0, $s1	# Consider next node.
	j	printNextNode
printedAll:

	la	$a0, endl
	li	$v0, 4
	syscall
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
																									
							
stop: 	addi 	$sp, $sp, 20   # restore $sp

	li	$v0, 10
	syscall				
																																	
		.data
line:		.asciiz "\n --------------------------------------"		
enterN:		.asciiz	"How many nodes do you want to create: "
firstData:	.asciiz	"Enter the first node data: "	
nextData:	.asciiz	"Enter the next node data: "
menuM:		.asciiz "\n Menu \n0-Create a new linked list\n1-display_Reverse_Order_Recursively\n2-duplicateListIterative \n3-duplicateListRecursive \n4-print linked list \nEnter the number of the subprogram you want to run: "
endl:		.asciiz "\n"
space:		.asciiz "  "
displayReverseLabel:
		.asciiz "Reverse Order: "
nodeNumberLabel:
		.asciiz	"\n Node No.: "	
addressOfCurrentNodeLabel:
		.asciiz	"\n Address of Current Node: "		
addressOfNextNodeLabel:
		.asciiz	"\n Address of Next Node: "	
dataValueOfCurrentNode:
		.asciiz	"\n Data Value of Current Node: "	
doubledRecLabel: 
		.asciiz "Lnnked list has doubled recursivly. You can print it by entering 4"		
printMenuLabel:
		.asciiz "\n1-Original\n2-Iteratively Created\n3-Recursivly Created\nEnter the number of the linked list you want to print:"
