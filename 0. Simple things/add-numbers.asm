## Simple thing that takes two integers and prints their sum

.globl main

.data
	prompt1: .asciiz "1st integer: "
	prompt2: .asciiz "2nd integer: "
	resultDescr: .asciiz "The result is: "
	
.text

main:
	# 1st number prompt
	la $a0, prompt1
	li $v0, 4
	syscall

	# read number 1
	li $v0, 5
	syscall
	
	# store user input
	move $t0, $v0
	
	# 2nd number prompt
	la $a0, prompt2
	li $v0, 4
	syscall
	
	# read number 2
	li $v0, 5
	syscall
	
	# add them up
	addu $a1, $v0, $t0
	
	# print result introduction text
	la $a0, resultDescr
	li $v0, 4
	syscall
	
	# take the result
	move $a0, $a1
	
	# print result
	li $v0, 1
	syscall
	
	# finish
	li $v0, 10
	syscall