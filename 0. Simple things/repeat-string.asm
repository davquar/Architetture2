## Takes a string and prints it n times

.globl main

.data
buffer: .word 1
askString: .asciiz "Write the string that you want to repeat: "
askNumber: .asciiz "How many times do you want to repeat it? "
sep: .asciiz ". "

.text

main:
la $a0, askString		# loads the address of the prompt string
li $v0, 4				# loads the "print string" service
syscall

la $a0, buffer			# loads the buffer address
li $a1, 100				# accept 100 characters max
li $v0, 8				# loads the "read string" service
syscall

la $a0, askNumber		# loads the address of the 2nd prompt string
li $v0, 4				# loads the "print string" service
syscall

li $v0, 5				# loads the "read integer" service
syscall

move $t0, $v0			# saves the user input
li $t1, 0				# initialize a counter

loop: beq $t0, $t1 afterLoop
	move $a0, $t1		# loads the index to print
	addi $a0, $a0, 1	# start to print from 1
	li $v0, 1			# loads the "print integer" service
	syscall
	
	la $a0, sep			# loads the separator string
	li $v0, 4			# loads the "print string" service
	syscall
	
	la $a0, buffer		# loads the address of the string
	li $v0, 4			# loads the "print string" service
	syscall
	
	addi $t1, $t1, 1	# increments counter
	j loop

afterLoop:
li $v0, 10
syscall