# Recursive implementation of Fibonacci. To finish

.globl main

.data
	.align 2
	
	nPrompt: .asciiz "Insert an integer: "
	rString: .asciiz "fib(n) is: "
	
	.eqv $n, $t0
	.eqv $nPrec, $t1

.text

main:
	jal askAndSave
	jal fib
	jal showResult
	
	# exit
	li $v0, 10
	syscall

fib:
	addi $sp, $sp, -12			# reserve 3 words
	sw $ra, 0($sp)
	
	beq $n, 1, tail
	
	sw $n, 4($sp)				# save current n
	sw $nPrec, 8($sp)			# useless
	
	addi $n, $n, -1
	addi $nPrec, $n, -2
	
	jal fib
	
	tail:
		lw $n, 4($sp)			# restore n
		lw $nPrec, 8($sp)	
		
		add $n, $n, $nPrec		# do n += n-1
		
		addi $sp, $sp, 12		# free the 3 words
		lw $ra, 0($sp)			# restore $ra
		
		jr $ra					# resume where you left
	
askAndSave:
	# show prompt
	la $a0, nPrompt
	li $v0, 4
	syscall
	
	# read integer
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