# Write function called avgdiff that given two strings, computes the
# average difference between the ASCII codes of the characters in the same position.

# X = abcdef
# Y = aaaaaa
# avgdiff --> (0+1+2+3+4+5)/6 = 2.5

# X = granturco
# Y = abcdefghi
# avgdiff --> (6+16+(-2)+10+15+15+11+(-5)+6)/9 = 8.0

# Write a main that:
# 1. Reads the two strings of the same length (max 100 chars)
# 2. Calls avgdiff and passes the address of the two strings
# 3. Prints out the result

.globl main

.data
	.align 2
	X: .space 100
	Y: .space 100
	
.text

.macro isOver(%src, %dst)
	move %dst, $0
	beq %src, $0, yes
	beq %src, '\n', yes
	j end
	yes: li %dst, 1
	end:
.end_macro

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
	jal avgdiff
	
	li $v0, 2
	syscall
	
	li $v0, 10
	syscall

.eqv $i, $t0
.eqv $x, $t1
.eqv $y, $t2
.eqv $addr, $t3
.eqv $sum, $t4
avgdiff:
	add $addr, $a0, $i
	lb $x, ($addr)
	isOver($x, $v0)
	beq $v0, 1, return
	add $addr, $a1, $i
	lb $y, ($addr)
	
	sub $v0, $x, $y
	add $sum, $sum, $v0
	addi $i, $i, 1
	j avgdiff
	
	return:
		mtc1 $i, $f0
		mtc1 $sum, $f12
		div.s $f12, $f12, $f0
		jr $ra