# Write a MIPS program that:
# 1. takes two strings of max length 100
# 2. compares them with a separate function
# 3. prints one of {"first", "second", "equal"} respectively if first>second, ...

# The comparison should work in this way:
# - takes the addresses of the two strings
# - returns one of {-1, 1, 0}

.globl main
.data
	X: .space 100
	Y: .space 100
	firstTxt: .asciiz "first"
	secondTxt: .asciiz "second"
	equalTxt: .asciiz "equal"
	
.text

main:
	li $v0, 8
	la $a0, X
	li $a1, 100
	syscall
	
	li $v0, 8
	la $a0, Y
	li $a1, 100
	syscall
	
	la $a0, X
	la $a1, Y
	jal strcmp
	
	beq $v0, 1, printFirst
	beq $v0, -1, printSecond
	la $a0, equalTxt
	j print
	
	printFirst:
		la $a0, firstTxt
		j print
		
	printSecond:
		la $a0, secondTxt
		j print
	
	print:
		li $v0, 4
		syscall
		
	li $v0, 10
	syscall
	
.eqv $i, $t0	# index
.eqv $addr, $t1	# address in X or Y
.eqv $x, $t2	# value X[i]
.eqv $y, $t3	# value Y[i]
strcmp:
	li $v0, 0
	add $addr, $a0, $i
	lb $x, ($addr)
	add $addr, $a1, $i
	lb $y, ($addr)
	
	bne $x, $0, xnz
		bne $y, $0, second
			j equal
	xnz:
		beq $y, $0, first
		
	bne $x, '\n', xnn
		bne $y, '\n', second
			j equal
	xnn:
		beq $y, '\n', first	
	
	bgt $x, $y, first
	blt $x, $y, second
	j next
	
	first:
		li $v0, 1
		j return
	
	second:
		li $v0, -1
		j return
		
	equal:
		li $v0, 0
		j return
				
	next:
		addi $i, $i, 1
		j strcmp
		
	return:
		jr $ra
