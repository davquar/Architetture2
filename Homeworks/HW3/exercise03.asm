.globl main

.data
	.align 2
	vector: .word 15,-1,-2,-3,3,-1,7,-3,-666,-666,5,8,-666,-666,6,9
	openBracket: .asciiz "("
	closedBracket: .asciiz ")"
	opChars: .byte '*','+','-','^'
	mulChar: .asciiz "*"
	addChar: .asciiz "+"
	subChar: .asciiz "-"
	powChar: .asciiz "^"
.text

.eqv $n, $t0
.eqv $index, $a1
.eqv $left, $t1
.eqv $right, $t2

.eqv $MUL, -1
.eqv $ADD, -2
.eqv $SUB, -3
.eqv $POW, -4
.eqv $EMPTY, -666

.macro takeInt (%regDst)
	li $v0, 5
	syscall
	move %regDst, $v0
.end_macro

.macro writeVector (%index, %value)
	sll $v1, %index, 2
	sw %value, vector($v1)
.end_macro

.macro readVector (%index, %regDst)
	sll $v1, %index, 2
	lw %regDst, vector($v1)
.end_macro

# v0 = {1 if true, 0 else}
.macro isLeaf (%index)
	li $v0, 0
	# check if children exist
	mul $t7, %index, 2					# left child
	bgt $t7, $n, true
	addi $t7, $t7, 1					# right child
	bgt $t7, $n, true
	# check if has empty children
	readVector ($t7, $t6)
	bne $t6, $EMPTY, almostFalse
	j true
	almostFalse:
		addi $t7, $t7, -1
		readVector ($t7, $t6)
		bne $t6, $EMPTY, false
	true:
		li $v0, 1
	false:
.end_macro

.macro printOperation (%index)
	readVector (%index, $a0)
	beq $a0, $ADD, isAdd
	isAdd:
		la $a0, addChar
	li $v0, 4
	syscall
.end_macro

main:
	# take number of integers
	#takeInt ($n)
	#writeVector ($0, $n)
	#addiu $n, $n, 1
	
	# save n integers
	#addiu $t1, $0, 1					# counter
	addiu $n, $0, 15
	
	askLoop:
	
	#beq $t1, $n, endAskLoop
#		takeInt ($t2)
#		writeVector ($t1, $t2)
#		addiu $t1, $t1, 1
#		j askLoop
#	endAskLoop:
	addi $index, $0, 1
	jal printExpression
	
	li $v0, 10
	syscall


# a0: vector's address
# a1: current index in vector
printExpression:
	addi $sp, $sp, -8				# reserve a two-word stack space
	sw $ra, 0($sp)					# save current $ra in stack
	sw $index, 4($sp)					# save current index in stack
	
	# print open bracket
	la $a0, openBracket
	li $v0, 4
	syscall
	
	# check if we need to print the value
	isLeaf ($index)
	beqz $v0, notLeaf
		readVector ($index, $a0)		# vector(4*$a1) --> $a0
		li $v0, 1
		syscall
		la $a0, closedBracket
		li $v0, 4
		syscall
		j return
	
	notLeaf:
		mul	$left, $index, 2			# left index
		addi $right, $left, 1			# right index

		move $index, $left
		jal printExpression
		
		printOperation ($index)

		move $index, $right
		jal printExpression
			
	return:
	addi $sp, $sp, 8			# free the two-word stack space
	lw $ra, 0($sp)				# restore current $ra from stack
	lw $index, 4($sp)			# restore index from stack
	jr $ra						# resume where you left
