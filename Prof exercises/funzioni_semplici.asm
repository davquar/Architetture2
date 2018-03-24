

# A(x,y) = b(x) + c(y)
# b(x)   = d(x) + 42
# c(y)   = 3 * y
# d(x)   = 400 - x

# A(1,2) = b(1) + c(2) =
#	 = [d(1) + 42] + [ 3*2 ]
#	 = [(400-1)+42]+[3*2]
#	 = 400 -1 +42 +6 = 448-1 = 447


.globl main

.text

main:
	# legge x ed y
	li $v0, 5
	syscall
	move $a0, $v0
	
	li $v0, 5
	syscall
	move $a1, $v0
	# chiama A(x, y)
	jal A
	
	# stampa il risultato
	move $a0, $v0
	li $v0, 1
	syscall
	
	# fine
	li $v0, 10
	syscall
	
# A($a0=x, $a1=y) = x
A:
	# salvo $ra su stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# $a0=x
	jal b
	# salvare il risultato da qualche parte
	move $t0, $v0
	
	# $a0=y=$a1
	move $a0, $a1	# copio y nel primo argomento
	jal c	
	
	add $v0, $v0, $t0	
	# ripristino $ra
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra


# b(x)   = d(x) + 42
b:
	# salvo $ra su stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# $a0 resta x
	jal d
	add $v0, $v0, 42
	# ripristino $ra da stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4	
	jr $ra
	
# c(y)   = 3 * y
c:	mul $v0, $a0, 3
	jr $ra
	
# d(x)   = 400 - x
d:	li $v0, 400
	sub $v0, $v0, $a0
	jr $ra
