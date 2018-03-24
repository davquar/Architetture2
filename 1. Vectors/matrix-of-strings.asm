.globl main

.data
.align 2

rowsPrompt: .asciiz "How many rows? "
colsPrompt: .asciiz "How many columns? "
nextPrompt: .asciiz "Next string: "
newLine: .asciiz "\n"
tab: .asciiz "\t"

printText: .asciiz "Your matrix is:\n"

rows: .word 0
cols: .word 0
matrix: .word 0:100

.text

main:

#
# ASK AND STORE NUMBER OF ROWS
#
la $a0, rowsPrompt				# load prompt address
li $v0, 4						# load "print string" service
syscall

li $v0, 5						# load "read integer" service
syscall

move $s0, $v0					# move the user input in a temporary register
sw $v0, rows					# also store the user input in memory

#
# ASK AND STORE NUMBER OF COLUMNS
#
la $a0, colsPrompt				# load prompt address
li $v0, 4						# load "print string" service
syscall

li $v0, 5						# load "read integer" service
syscall

move $s1, $v0					# move the user input in a temporary register
sw $v0, cols					# also store the user input in memory

#
# STRINGS INPUT LOOP
#
li $t0, 0						# row index
li $t1, 0						# column index

askRowLoop: beq $t0, $s0, askEnd
askColLoop:
	beq $t1, $s1, askColEnd
	
	la $a0, nextPrompt			# load prompt address
	li $v0, 4					# load "print string" service
	syscall
	
	# OFFSET COMPUTATION
	mul $a0, $s1, $t0			# col*i
	add $a0, $a0, $t1			# col*i + j
	sll $a0, $a0, 8				# (col*i + j)*255
	la $a0, matrix($a0)			# 
	
	li $a1, 20					# set max number of character to read
	li $v0, 8					# load "read string" service
	syscall
		
	# STRIP \N CHARACTER
	li $t4, 0					# initialize a counter register
	add $t4, $t4, $a0
	removeN:
		lb $s3, ($t4)			# load 1st character
		addi $t4, $t4, 1
		bnez $s3, removeN
		beq $t4, $a1, afterRemoveN
		subiu $t4, $t4, 2
		sb $0, ($t4)
	afterRemoveN:
	
	# GO ON
	addi $t1, $t1, 1			# i++
	j askColLoop
	
askColEnd:
	# PREPARE FOR NEXT ROW
	addi $t0, $t0, 1			# increment row index
	li $t1, 0					# reset column index
	j askRowLoop

askEnd: # --  --  -- #	
	
#
# SHOW PRESENTATION TEXT
#
la $a0, printText				# load text address
li $v0, 4						# load "print string" service
syscall

#
# STRINGS PRINT LOOP
#
li $t0, 0						# row index
li $t1, 0						# column index

printRowLoop: beq $t0, $s0, printEnd
printColLoop:
	beq $t1, $s1, printColEnd
		
	# OFFSET COMPUTATION
	mul $a0, $s1, $t0			# col*i
	add $a0, $a0, $t1			# col*i + j
	sll $a0, $a0, 8				# (col*i + j)*255
	la $a0, matrix($a0)			# matrix + (col*i + j)*4
	
	li $v0, 4					# load "print string" service
	syscall
	
	# PRINT \t
	la $a0, tab
	li $v0, 4
	syscall
	
	# GO ON
	addi $t1, $t1, 1			# i++
	j printColLoop
	
printColEnd:
	# PRINT \N
	la $a0, newLine
	li $v0, 4
	syscall
	
	# PREPARE FOR NEXT ROW
	addi $t0, $t0, 1			# increment row index
	li $t1, 0					# reset column index
	j printRowLoop

printEnd: # --  --  -- #

li $v0, 10
syscall
