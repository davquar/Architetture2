.globl main

.data
.align 2

rowsPrompt: .asciiz "How many rows? "
colsPrompt: .asciiz "How many columns? "
nextPrompt: .asciiz "Next string: "

printText: .asciiz "Your matrix is:\n"

rows: .word 0
cols: .word 0
matrix: .word 0:100
addr: .byte 0

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
	move $t3, $a0
	la $a0, matrix($a0)			# matrix + (col*i + j)*4
	
	# here we should strip the \n character...
	 
	li $a1, 20					# set max number of character to read
	li $v0, 8					# load "read string" service
	syscall
	
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
	
	# GO ON
	addi $t1, $t1, 1			# i++
	j printColLoop
	
printColEnd:
	# PREPARE FOR NEXT ROW
	addi $t0, $t0, 1			# increment row index
	li $t1, 0					# reset column index
	j printRowLoop

printEnd: # --  --  -- #

li $v0, 10
syscall