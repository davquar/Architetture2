.globl main

.data
.align 2

sizePrompt: .asciiz "How many string do you want? "
nextPrompt: .asciiz "Input the next string: "
yourStrings: .asciiz "Your strings are: "

stringCount: .word 0
vector: .word 0:100

.text

main:

# print ask string
la $a0, sizePrompt			# load first prompt address
li $v0, 4					# prepare "print string" service
syscall

# read number of string
li $v0, 5					# prepare "read integer" service
syscall

sw $v0, stringCount			# store string count to memory
move $t1, $v0				# save string count to a register

li $t0, 0					# initialize a counter to 0
askLoop:
	beq $t0, $t1, afterAskLoop
	
	# show next string prompt
	la $a0, nextPrompt
	li $v0, 4
	syscall
	
	# calculate offset in vector
	sll $a0, $t0, 8
	la $a0, vector($a0)
	
	# store next string
	li $a1, 20
	li $v0, 8
	syscall
	
	addi $t0, $t0, 1
	j askLoop

afterAskLoop:

# print description string
la $a0, yourStrings
li $v0, 4
syscall

li $t0, 0					# reset counter to 0
printLoop:
	beq $t0, $t1, afterPrintLoop
	
	# compute offset and print
	sll $a0, $t0, 8
	la $a0, vector($a0)		# load address of the next string
	li $v0, 4				# load "print string" service
	syscall
	
	addi $t0, $t0, 1
	j printLoop

afterPrintLoop:

li $v0, 10
syscall