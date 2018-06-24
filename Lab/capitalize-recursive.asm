# Write a MIPS program that:
# 1. takes a null-terminated string
# 2. modifies it following these rules:
# 	- a word is a contiguous sequence of letters ranging [a-zA-Z];
#	- every other character is a word separator
#	- the program should capitalize the first and last character of each word
#	- all the other letters should be lower-case.

# I:	paOliNO 113		|	grisù il dr4gh3tto
# O:	PaolinO 113		|	GriSù IL DR4GH3TtO

.globl main
.data
	.align 2
	String: .space 100
	
.text

.macro isLetter(%src, %dst)
	blt %src, 'A', nope
		ble %src, 'Z', yes

	blt %src, 'a', nope
		ble %src, 'z', yes
		j nope
		
	yes:
		li %dst, 1
		j end
	nope:
		li %dst, 0
	end:
.end_macro

.macro isOver(%src, %dst)
	beq %src, $0, yes
	beq %src, '\n', yes
	li %dst, 0
	j end
	yes: li %dst, 1
	end:
.end_macro

main:
	la $a0, String
	li $a1, 100
	li $v0, 8
	syscall
	
	move $a0, $0
	jal capitalize
	
	la $a0, String
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall

.eqv $i, $a0	# current index
.eqv $j, $t1	# current index + 1
.eqv $k, $t2	# current index - 1
.eqv $char, $t3	# current char
.eqv $next, $t4	# next char
.eqv $prev, $t5	# previous char
capitalize:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $i, 4($sp)
	
	lb $char, String($i)
	isOver($char, $v0)
	beq $v0, 1, return
	isLetter($char, $v0)
	beq $v0, $0, nextChar
		addi $j, $i, 1
		subi $k, $i, 1
		lb $next, String($j)
		lb $prev, String($k)
		bltz $k, setUpper
		isLetter($prev, $v0)
		beq $v0, $0, setUpper
		isLetter($next, $v0)
		beq $v0, $0, setUpper
		
		bge $char, 'a', nextChar
		addi $char, $char, 32
		sb $char, String($i)
		j nextChar
		
	setUpper:
		ble $char, 'Z', nextChar
		subi $char, $char, 32
		sb $char, String($i)
		
	nextChar:
		addi $i, $i, 1
		jal capitalize
		
	return:
		lw $ra, 0($sp)
		lw $i, 4($sp)
		addi $sp, $sp, 8
		jr $ra
