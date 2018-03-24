## Simple thing that takes:
##	1. An operation: {add, multiply, divide};
##	2. Two integers
## And prints out the result.

.globl main

.data
	promptOp: .asciiz "Select the operation (0:sum; 1:mul; 2:div): "
	prompt1: .asciiz "1st integer: "
	prompt2: .asciiz "2nd integer: "
	resultDescr: .asciiz "The result is: "
	
.text

main:
	# operation prompt
	la $a0, promptOp
	li $v0, 4
	syscall
	
	# read operation choice
	li $v0, 5
	syscall
	
	# restart if the operation is not valid
	ble $v0, -1, main
	bge $v0, 3, main
	
	# store the operation
	move $t0, $v0

	# 1st number prompt
	la $a0, prompt1
	li $v0, 4
	syscall

	# read number 1
	li $v0, 5
	syscall
	
	# store number 1
	move $t1, $v0
	
	# 2nd number prompt
	la $a0, prompt2
	li $v0, 4
	syscall
	
	# read number 2
	li $v0, 5
	syscall
	
	# dispatch to the correct operation
	beqz $t0, addSelected
	beq $t0, 1, mulSelected
	beq $t0, 2, divSelected
	
	addSelected:
	# add them up
		addu $a1, $t1, $v0
		j continue
		
	mulSelected:
	# multiply them up
		mulu $a1, $t1, $v0
		j continue
		
	divSelected:
	# divide them up
		divu $a1, $t1, $v0
		j continue
		
	continue:
	
	# print result introduction text
	la $a0, resultDescr
	li $v0, 4
	syscall
	
	# take the result
	move $a0, $a1
	
	# print result
	li $v0, 1
	syscall
	
	# finish
	li $v0, 10
	syscall