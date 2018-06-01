# We have a list represented by an array.
# The array has these requirements:
# - starts at index 0;
# - the value -1 tells that the list is over;
# - each chell contains the index of the next item.
#
# E.g.	1,4,2,6,9,-1,3,5,7,8,10
#		0->1->4->9->8->7->5->-1
#
# Write a function called countEvenInList that:
# - takes the address of the vector just described;
# - returns the number of even values in it.
#
# E.g.  1, 4, 2, 6, 9, -1, 3, 5, 7, 8, 10
#		(0)?1?(4)?9?(8)?7?5?-1
# Returns 3

.globl main
.data
.align 2
	list: .word -1:20
	
.text

.eqv $i, $t0		# index in list
.eqv $offs, $t1		# offset in list
.eqv $n, $t2		# number of items
main:
	move $i, $0
	li $v0, 5
	syscall
	move $n, $v0
	
	nextNumber:
	beq $i, $n, populated
	sll $offs, $i, 2
	li $v0, 5
	syscall
	sw $v0, list($offs)
	addi $i, $i, 1
	j nextNumber
	
	populated:
	la $a0, list
	jal countEvenInList
	move $a0, $v0
	
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
.eqv $addr, $a0
.eqv $i, $t0		# index in list
.eqv $offs, $t1		# offset in list
.eqv $val, $t2		# value at index i
.eqv $even, $t3		# 0 if even | 1 if odd (a copy of the LSB)
.eqv $count, $v0	# mumber of even things
countEvenInList:
	move $i, $0
	move $count, $0
	
	traverse:
	sll $offs, $i, 2
	add $offs, $offs, $addr
	lw $val, ($offs)
	andi $even, $i, 1				# check if $i is odd
	xori $even, $even, 1			# flip lsb of $even
	add $count, $count, $even
	beq $val, -1, endTraverse
	move $i, $val
	j traverse
	
	endTraverse:
	jr $ra
	