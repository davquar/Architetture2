# Write a function called len, that calculates the length of a list
# stored as a vector of children: each item can contain:
#	- '-1': no successor;
#	- the index [0; N-1] of the next node
# This function should also print the indexes of the visited positions.
# The function should take:
#	- the address of the list;
#	- the number of items in the list [1; 100];
#	- the position of the current node.

.globl main

.data
	.align 2
	L: .space 101
	
.text

main:
	li $v0, 5
	syscall
	move $t0, $v0
	
	nextValue:
		beq $t1, $t0, afterLoop
		sll $t2, $t1, 2
		li $v0, 5
		syscall
		sw $v0, L($t2)
		addi $t1, $t1, 1
		j nextValue
	afterLoop:
	
	la $a0, L
	move $a1, $t0
	move $a2, $0
	jal len
	
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall

.eqv $addr, $a0
.eqv $n, $a1
.eqv $i, $a2
.eqv $val, $t0
.eqv $h, $s1
len:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $addr, 4($sp)
	sw $n, 8($sp)
	sw $i, 12($sp)
	
	move $s0, $a0		# temporary save $a0 elsewhere
	li $v0, 1
	move $a0, $i
	syscall
	move $a0, $s0		# restore $a0
	addi $h, $h, 1
	
	sll $val, $i, 2
	add $val, $addr, $val
	lw $val, ($val)
	
	beq $val, -1, return
	move $i, $val
	jal len
	
	return:
		lw $ra, 0($sp)
		lw $addr, 4($sp)
		lw $n, 8($sp)
		lw $i, 12($sp)
		bnez $i, skipCopy
		move $v0, $h
		skipCopy:
		addi $sp, $sp, 16
		jr $ra