# shit implementation of fibonacci, doesn't work.

.globl main

.data
	.align 2
	
	nPrompt: .asciiz "Insert an integer: "
	rString: .asciiz "fib(n) is: "
	
	.eqv $nth, $s0
	.eqv $n, $t0
	.eqv $nPrec, $t1
	.eqv $i, $t2

.text

main:
	# show prompt
	la $a0, nPrompt
	li $v0, 4
	syscall
	
	# read integer
	li $v0, 5
	syscall
	
	move $nth, $v0
	
	li $n, 2
	li $nPrec, 1
	
	jal fib
	
	# show result string
	la $a0, rString
	li $v0, 4
	syscall
	
	# show result
	move $a0, $n
	li $v0, 1
	syscall
	
	# exit
	li $v0, 10
	syscall

fib:	
	subi $nPrec, $n, 1
	addu $n, $n, $nPrec
	
	jal fib
	
	beq $i, $nth, endFib
	
endFib:
	jr $ra
