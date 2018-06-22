# Write a recursive log2(X, Y) function that computes the integer log_2 of X*Y.

# log2(X, Y) = 0					if X=1 and Y=1
# log2(X, Y) = 1 + log2(X, Y/2)		if X=1 and Y>1 (note: integer division)
# log2(X, Y) = 1 + log2(X/2, Y) 	else (note: integer division)

.globl main
.data
.text

.eqv $x, $a0
.eqv $y, $a1

main:
	li $v0, 5
	syscall
	move $x, $v0
	li $v0, 5
	syscall
	move $y, $v0
	
	move $v0, $0
	jal	log2
	
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall

log2:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $x, 4($sp)
	sw $y, 8($sp)
	
	bgt $x, 1, xgt
	bgt $y, 1, ygt

	# x == 1, y == 1 --> base case
	j return
	
	# x > 1
	xgt:
		div $x, $x, 2
		jal log2
		j return
	
	# y > 1
	ygt:
		div $y, $y, 2
		jal log2
		j return
				
	return:
		addi $v0, $v0, 1
		addi $sp, $sp, 12
		lw $ra, 0($sp)
		lw $x, 4($sp)
		lw $y, 8($sp)
		jr $ra