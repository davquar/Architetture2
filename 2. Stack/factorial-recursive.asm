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
	addi $sp, $sp, -8				# reserve a two-word stack space
	sw $ra, 0($sp)					# save current $ra in stack
	
	sw $n, 4($sp)					# save current $n in stack
	
	beq $n, 1, tail					# base case check
	addi $n, $n, -1					
	jal fact						# recursive call

	tail:							# tail of recursion
		lw $t1, 4($sp)				# restore (n-1) from stack
		mul $n, $n, $t1				# compute n(n-1)
		
		addi $sp, $sp, 8			# free the two-word stack space
		lw $ra, 0($sp)				# restore current $ra from stack
		
		jr $ra						# resume where you left
	

# prompts for an integer, and saves it in $n
askAndSave:
	la $a0, nPrompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $n, $v0
	addi $n, $n, 1					# I'm not sure why
	
	jr $ra
	
# shows an intro string, and the result
showResult:
	la $a0, rString
	li $v0, 4
	syscall
	
	move $a0, $n
	li $v0, 1
	syscall
	
	jr $ra
