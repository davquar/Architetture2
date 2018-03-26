# Factorial function: iterative implementation.

.globl main

.data
	.align 2
	
	nPrompt: .asciiz "Enter an integer: "
	rString: .asciiz "n! is: "
	
	.eqv $nth, $t0
	.eqv $n, $t1
	.eqv $i, $t2
	
.text

main:
	jal promptAndSave		# ask and save an integer value
	addi $i, $n, -1			# initialize the decrementing counter
	jal fact				# call factorial function
	jal printResult			# show result
	
	# exit
	li $v0, 10
	syscall
	
promptAndSave:
	la $a0, nPrompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $n, $v0
	
	jr $ra
	
fact:
	beq $i, $0, endFact			# base case
	mul $n, $n, $i				# n *= i
	addi $i, $i, -1				# i -= 1
	j fact						# loop
	
endFact:
	jr $ra						# return
	
printResult:
	la $a0, rString
	li $v0, 4
	syscall
	
	move $a0, $n
	li $v0, 1
	syscall
	
	jr $ra