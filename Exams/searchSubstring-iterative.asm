# Write a function searchSubstring that takes the addresses two strings of the same length, called:
#  - text;
#  - query.
#	
# It should check if the second string is inside the first, and return:
#  - the start position if yes;
#  - -1 if not present.
#
# E.g.
# text = "Topolino va al mare con Topolina e le nipotine Emy, Ely, Evy"
# query = "mare"
# result = 15
# -- ITERATIVE IMPLEMENTATION --
#	

.globl main
.data
.align 2
	text: .space 100
	query: .space 100

.text
main:
	li $v0, 8
	la $a0, text
	li $a1, 100
	syscall

	li $v0, 8
	la $a0, query
	li $a1, 100
	syscall
	
	la $a0, text
	la $a1, query
	jal searchSubstring
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	li $v0, 10
	syscall

.eqv $pos, $s0		# position to return
.eqv $i, $t0		# text index
.eqv $j, $t1		# query index
.eqv $t, $t2		# text character
.eqv $q, $t3		# query character
.eqv $offI, $t4		# offset in text string
.eqv $offJ, $t5		# offset in query string
searchSubstring:
	li $pos, -1
	li $i, -1
	move $j, $0
	check:
	addi $i, $i, 1
	add $offI, $a0, $i
	add $offJ, $a1, $j
	lb $t, ($offI)
	lb $q, ($offJ)
	beq $t, '\0', endText
	beq $t, '\n', endText
	beq $q, '\0', endText
	beq $q, '\n', endText
	bne $t, $q, nextTextChar
		bne $pos, -1, notFirst
			move $pos, $i
		notFirst:
		addi $j, $j, 1
		j check

	nextTextChar:
	move $j, $0
	li $pos, -1
	j check
	
	endText:
	move $v0, $pos
	
	jr $ra