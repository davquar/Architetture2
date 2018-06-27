# Write a function that does a binary search, given:
#	- the address of an ordered integer array;
#	- the index of the first item to start from;
#	- the number of items to consider;
#	- the integer to search.
# Print the indexes that you visit.

.globl main

.data
	.align 2
	space: .asciiz " "
	V: .word 0:101
	
.text

main:
	li $v0, 5
	syscall
	move $t0, $v0
	
	nextValue:
		beq $t2, $t0, afterLoop
		sll $t3, $t2, 2
		li $v0, 5
		syscall
		sw $v0, V($t3)
		addi $t2, $t2, 1
		j nextValue
	afterLoop:
	
	li $v0, 5
	syscall
	move $t1, $v0
	
	la $a0, V
	move $a1, $0
	move $a2, $t0
	move $a3, $t1
	jal binsearch
	
	move $a0, $v0
	li $v0, 1
	syscall

	li $v0, 10
	syscall

.eqv $v, $a0
.eqv $start, $a1
.eqv $n, $a2
.eqv $x, $a3
.eqv $addr, $t0
.eqv $item, $t1
.eqv $i, $t2
.eqv $temp, $t3
binsearch:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $start, 4($sp)
	sw $n, 8($sp)
	
	bnez $n, visit
	li $v0, -1
	j return
	
	visit:
	div $i, $n, 2
	add $i, $i, $start
	sll $addr, $i, 2
	add $addr, $v, $addr
	lw $item, ($addr)
	
	move $temp, $a0
	li $v0, 1
	move $a0, $i
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	move $a0, $temp
	
	# comparisons
	
	blt $item, $x, searchAfter
	bgt $item, $x, searchBefore
	
	# else: value==x --> found!
	move $v0, $i
	j return
	
	searchAfter:
		div $temp, $n, 2
		subi $n, $n, 1
		addi $start, $i, 1
		sub $n, $n, $temp
		jal binsearch
		j return
		
	searchBefore:
		div $n, $n, 2
		jal binsearch
		j return
		
	return:
		lw $ra, 0($sp)
		lw $start, 4($sp)
		lw $n, 8($sp)
		addi $sp, $sp, 12
		jr $ra