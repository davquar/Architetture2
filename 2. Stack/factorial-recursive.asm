# Recursive factorial implementation

.globl main

.data
	.align 2
	
	nPrompt: .asciiz "Enter an integer: "
	rString: .asciiz "n! is: "
	
	.eqv $n, $t0
	
.text

main:
	jal askAndSave
	jal fact
	jal showResult
	
	# exit
	li $v0, 10
	syscall
	
fact:
	# reserve stack space
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	sw $n, 4($sp)
	
	beq $n, 1, tail
	addi $n, $n, -1
	jal fact
	
	tail:
		lw $t1, 4($sp)
		
		# free stack space
		addi $sp, $sp, 4
		lw $ra, 0($sp)
		
		mul $n, $n, $t1
		jr $ra
	
	jr $ra
	
	
askAndSave:
	la $a0, nPrompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $n, $v0
	
	jr $ra
	
showResult:
	la $a0, rString
	li $v0, 4
	syscall
	
	move $a0, $n
	li $v0, 1
	syscall
	
	jr $ra