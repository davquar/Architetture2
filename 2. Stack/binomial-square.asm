# Computes the square of a binomial.
# (a + b)^2 = a^2 + 2ab + b^2

.globl main

.data
	.align 2
	aPrompt: .asciiz "Enter a: "
	bPrompt: .asciiz "Enter b: "	
	rString: .asciiz "(a + b)^2 is: "
	
	.eqv $a, $t1
	.eqv $b, $t2
	.eqv $r, $t3
	.eqv $temp, $t4
	
.text

main:
	# ask and save 1st value
	la $a0, aPrompt				# chose 1st prompt
	jal promptAndRead			# call function
	move $a, $v0				# save read value
	
	# free stack space
	addi $sp, $sp, 4
	sw $ra, ($sp)
	
	# ask and save 2nd value
	la $a0, bPrompt				# chose 2nd prompt
	jal promptAndRead			# call function
	move $b, $v0				# save read value
	
	# free stack space
	addi $sp, $sp, 4
	sw $ra, ($sp)
	
	# - - - #
	
	# calculate a^2
	move $a0, $a				# prepare value for "a"
	jal square					# call function (uses $a0)
	
	# free stack space
	addi $sp, $sp, 4
	sw $ra, ($sp)
	
	# r = a^2
	move $r, $a0
	
	# calculate b^2
	move $a0, $b				# prepare value for "b"
	jal square					# call function (uses $a0)
	
	# free stack space
	addi $sp, $sp, 4
	sw $ra, ($sp)
	
	# r += b^2 
	add $r, $r, $a0
	
	# calculate 2ab
	jal middle					# call function

	# free stack space
	addi $sp, $sp, 4
	sw $ra, ($sp)
	
	# r += 2ab
	add $r, $r, $temp
	
	# - - - #
	
	# show pre-result string
	la $a0, rString
	li $v0, 4
	syscall
	
	# show result
	move $a0, $r
	li $v0, 1
	syscall
	
	# exit
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
	
	# resume in main
	jr $ra
	
# computes x^2 (x = $a0)
square:
	# reserve stack space
	addi $sp, $sp, -4
	sw $ra, ($sp)

	mul $a0, $a0, $a0
	
	# resume in "main"
	jr $ra

# computes 2xy
middle:
	# reserve stack space
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	mul $temp, $a, $b
	mul $temp, $temp, 2
	
	# resume in "main"
	jr $ra
