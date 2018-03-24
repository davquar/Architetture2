# calcola somma colonne matrice

.globl main

.data
	.align 2
	matrix:			.word 0:100
	sums:			.word 0:100
	askNumRows:		.asciiz "How many rows? "
	askNumCols:		.asciiz "How many cols? "
	askNext:		.asciiz "Next integer: "
	tab:			.asciiz "\t"
	
.eqv $numRows, $t0
.eqv $numCols, $t1
.eqv $i, $t2
.eqv $j, $t3
.eqv $addr, $t4
.eqv $colSize, $t5
.eqv $tempSum, $t6
	
.text

main:
	li $colSize, 4
	# ASK HOW MANY ROWS AND COLUMNS
	# Rows
	la $a0, askNumRows
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $numRows, $v0
	
	# Columns
	la $a0, askNumCols
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $numCols, $v0
	
	# -------------------
	
	# ASK VALUES
	li $i, 0
	li $j, 0
	askRowLoop:	beq $i, $numRows, endAskLoop
	askColLoop:
		beq $j, $numCols, endAskColLoop
		
		la $a0, askNext
		li $v0, 4
		syscall
	
		li $v0, 5
		syscall
	
		# Calculate offset
		mul $addr, $colSize, $i			# colSize*i
		add $addr, $addr, $j			# colSize*i + j
		sll $addr, $addr, 2				# (colSize*i + j)*4
		la $addr, matrix($addr)			#
		
		# Store word
		sw $v0, ($addr)					# store read number into the matrix
		
		addi $j, $j, 1
		j askColLoop
	
	endAskColLoop:
		move $j, $0
		addi $i, $i, 1
		j askRowLoop
		
	endAskLoop:
	
	# --- END ASK --- #
	# --- COMPUTE SUMS --- #
	move $i, $0
	move $j, $0
	sumColLoop:
		move $tempSum, $0
		beq $j, $numCols, endSum
	sumRowLoop:
		beq $i, $numRows, endRowLoop
		
		# Calculate offset
		mul $addr, $colSize, $i			# colSize*i
		add $addr, $addr, $j			# colSize*i + j
		sll $addr, $addr, 2				# (colSize*i + j)*4
		la $addr, matrix($addr)			#
		
		lw $t7, ($addr)
		addu $tempSum, $tempSum, $t7
		
		addi $i, $i, 1
		j sumRowLoop
	endRowLoop:
		# print row sum
		move $a0, $tempSum
		li $v0, 1
		syscall
		
		la $a0, tab
		li $v0, 4
		syscall
		
		# adjust row and col indexes
		move $i, $0
		addi $j, $j, 1
		j sumColLoop
	endSum:
	
	
	# EXIT
	li $v0, 10
	syscall