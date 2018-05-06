.globl main

.data
	.align 2
	vector: .word 0:1000
	visited: .byte 0:1000
	openBracket: .asciiz "("
	closedBracket: .asciiz ")"
	
.text

.eqv $n, $t0

.macro takeInt (%regDst)
	li $v0, 5
	syscall
	move %regDst, $v0
.end_macro

.macro writeVector (%index, %value)
	sll $v1, %index, 2
	sw %value, vector($v1)
.end_macro

.macro isLeaf (%index)
	
.end_macro

main:
	# take number of integers
	takeInt ($n)
	writeVector ($0, $n)
	addiu $n, $n, 1
	
	# save n integers
	addiu $t1, $0, 1					# counter
	
	askLoop:
	
	beq $t1, $n, endAskLoop
		takeInt ($t2)
		writeVector ($t1, $t2)
		addiu $t1, $t1, 1
		j askLoop
	
	endAskLoop:
	
	
	li $v0, 10
	syscall


# a0: vector's address
# a1: current index in vector
printExpression:
	move $t1, $a0
	move $v0, 1
	sb $v0, visited($a1)			# flag the current node as visited
	
	la $a0, openBracket				# print open bracket
	syscall
	
	
	