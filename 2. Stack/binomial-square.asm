# Computes the square of a binomial.
# (a + b)^2 = a^2 + 2ab + b^2
# does not work, anyway.

.globl main

.data
	.align 2
	aPrompt: .asciiz "Enter a: "
	bPrompt: .asciiz "Enter b: "	
	rString: .asciiz "(a + b)^2 is: "
	
	.eqv $prompt, $a0
	.eqv $a, $t1
	.eqv $b, $t2
	.eqv $r, $t3
	.eqv $temp, $t4
	
.text

main:
	# ask and save 1st value
	la $prompt, aPrompt			# chose 1st prompt
	jal promptAndRead			# call function
	move $a, $v0				# save read value
	
	# free stack space
	addi $sp, $sp, 4
	sw $ra, ($sp)
	
	# ask and save 2nd value
	la $prompt, bPrompt			# chose 2nd prompt
	jal promptAndRead			# call function
	move $b, $v0				# save read value
	
	# free stack space
	addi $sp, $sp, 4
	sw $ra, ($sp)
	
	# - - - #
	
	# calculate a^2
	move $a0, $a
	jal square
	
	# free stack space
	addi $sp, $sp, 4
	sw $ra, ($sp)
	
	move $r, $a0
	
	# calculate b^2
	move $a0, $b
	jal square
	
	# free stack space
	addi $sp, $sp, 4
	sw $ra, ($sp)
	
	add $r, $r, $a0
	
	# calculate 2ab
	jal middle

	# free stack space
	addi $sp, $sp, 4
	sw $ra, ($sp)
	
	add $r, $r, $temp
	
	# display result
	la $a0, rString
	li $v0, 4
	syscall
	
	move $a0, $r
	li $v0, 1
	syscall
	
	# EXIT
	li $v0, 10
	syscall
	

# asks for a value, and saves it in $v0
promptAndRead:
	# reserve stack space
	addi $sp, $sp, -4
	sw $ra, ($sp)

	# print prompt
	li $v0, 4
	syscall
	
	# save value
	li $v0, 5
	syscall
	move $a, $v0
	
	# resume in main
	jr $ra
	
# computes x^2 (x = $a0)
square:
	# reserve stack space
	addi $sp, $sp, -4
	sw $ra, ($sp)

	mul $a0, $a0, $a0		# x*x
	jr $ra

# computes 2xy
middle:
	# reserve stack space
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	mul $temp, $a, $b
	mul $temp, $temp, 2
	
	jr $ra