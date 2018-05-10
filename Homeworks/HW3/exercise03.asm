.globl main

.data
	.align 2
	vector: .word 15,-1,-2,-3,3,-1,7,-3,-666,-666,5,8,-666,-666,6,9
	openBracket: .asciiz "("
	closedBracket: .asciiz ")"
	newLine: .asciiz "\n"
	opChars: .byte '*','+','-','^'
	mulChar: .asciiz "*"
	addChar: .asciiz "+"
	subChar: .asciiz "-"
	powChar: .asciiz "^"
	emptyChar: .asciiz " "
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

.eqv $isLeafLeft $t3
.eqv $isLeafRight $t4
.eqv $opNode $t5
.eqv $leftValue $t6
.eqv $rightValue $t7

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
	beq $a0, $MUL, isMul
	beq $a0, $ADD, isAdd
	beq $a0, $SUB, isSub
	beq $a0, $POW, isPow
	la $a0, emptyChar
	j print
	isAdd:
		la $a0, addChar
		j print
	isMul:
		la $a0, mulChar
		j print
	isSub:
		la $a0, subChar
		j print
	isPow:
		la $a0, powChar
		j print
	print:
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
	jal nextStep
	
	la $a0, newLine
	li $v0, 4
	syscall
	
	jal printExpression
	
	li $v0, 10
	syscall


# a0: vector's address
# a1: current index in vector
printExpression:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $index, 4($sp)
	
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
		j returnPrint
	
	notLeaf:
		mul	$left, $index, 2			# left index
		addi $right, $left, 1			# right index

		move $index, $left
		jal printExpression
		
		lw $index, 4($sp)
		printOperation ($index)

		mul $index, $index, 2
		addi $index, $index, 1
		jal printExpression
		
	returnPrint:
		la $a0, closedBracket
		li $v0, 4
		syscall

		lw $ra, 0($sp)
		lw $index, 4($sp)
		addi $sp, $sp, 8
		jr $ra

# ------------------------------- #

# a1: current index in vector
nextStep:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $index, 4($sp)
	
	mul $left, $index, 2
	addi $right, $left, 1
	
	bgt $left, $n, skipOperation
	bgt $right, $n, skipOperation
	
	isLeaf ($left)
	move $isLeafLeft, $v0
	isLeaf ($right)
	move $isLeafRight, $v0
	
	bne $isLeafLeft, 1, skipOperation
	bne $isLeafRight, 1, skipOperation
	
	# do operation
	readVector ($index, $opNode)
	beq $opNode, $MUL, isMul
	beq $opNode, $ADD, isAdd
	beq $opNode, $SUB, isSub
	beq $opNode, $POW, isPow

	isAdd:
		add $opNode, $leftValue, $rightValue
		j writeResult
	isMul:
		mul $opNode, $leftValue, $rightValue
		j writeResult
	isSub:
		sub $opNode, $leftValue, $rightValue
		j writeResult
	isPow:
		# write pow
		
	writeResult:
		sll $v0, $index, 2
		sw $opNode, vector($v0)
		sll $v0, $left, 2
		li $a0, $EMPTY
		sw $a0, vector($left)
		sll $v0, $right, 2
		sw $a0,  vector($right)
		
	j returnDo
	# end operation
	
	skipOperation:
	
	bgt $left, $n, tryRight
	move $index, $left
	jal nextStep
	
	tryRight:
		bgt $right, $n, returnDo
		move $index, $right
		jal nextStep
	
	returnDo:
	lw $ra, 0($sp)
	lw $index, 4($sp)
	addi $sp, $sp, 8
	jr $ra