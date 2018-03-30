.globl main

.data
	.align 2
	window: .word 0:25
	newLine: .asciiz "\n"
	
	.eqv $k, $s0
	.eqv $i, $t0
	.eqv $isFirstOfSeq, $s1		# 0: true; 1: false
	.eqv $isFirstStat, $s2		# 0: true; 1: false
	.eqv $sum, $t1
	.eqv $minS, $t2
	.eqv $maxS, $t3
	.eqv $minY, $t4
	.eqv $maxY, $t5

.text

main:
	jal nextInt
	move $k, $v0

	jal sequenceLoop
	endCore:
	jal printStats

	# exit
	li $v0, 10
	syscall
	
nextInt:
	li $v0, 5
	syscall
	jr $ra
	
printInt:
	li $v0, 1
	syscall

	la $a0, newLine
	li $v0, 4
	syscall
				
	jr $ra
	
printStats:
	move $a0, $minS
	jal printInt
	move $a0, $maxS
	jal printInt
	move $a0, $minY
	jal printInt
	move $a0, $maxY
	jal printInt
	
	jr $ra
	
sequenceLoop:
	jal nextInt
	beqz $v0, endSequenceLoop
	sll $i, $i, 2
	sw $v0, window($i)
	srl $i, $i, 2

	# -- COMPUTE STATS FOR S -- #
	bnez $isFirstOfSeq, doStatsS
		move $minS, $v0					# load current integer
		move $maxS, $v0					# load current integer
		j afterStatsS
	doStatsS:
		blt $v0, $minS, setMinS
		bgt $v0, $maxS, setMaxS
		j afterStatsS
		setMinS:
			move $minS, $v0
			j afterStatsS
		setMaxS:
			move $maxS, $v0
			
	afterStatsS:
	li $isFirstOfSeq, 1					# set is as false
	
	# -- UPDATE SUM -- #
	add $sum, $sum, $v0				# sum += currentInt
	
	# -- PRINT Y ITEM OR NOT -- #
	addi $t6, $k, -1
	bne $i, $t6, afterWindowUpdate
		move $a0, $sum
		jal printInt
		bnez $isFirstStat, doStatsY
			move $minY, $sum
			move $maxY, $sum
			li $isFirstStat, 1
			j afterStatsY
		doStatsY:
			blt $sum, $minY, setMinY
			bgt $sum, $maxY, setMaxY
			j afterStatsY
			setMinY:
				move $minY, $sum
				j afterStatsY
			setMaxY:
				move $maxY, $sum

		afterStatsY:
		lw $t7, window($0)				# load first of window
		sub $sum, $sum, $t7
		jal shiftWindow
		addi $i, $i, -1
		
	afterWindowUpdate:
	addi $i, $i, 1
	j sequenceLoop
	
endSequenceLoop:
	j endCore
	
shiftWindow:
	move $t6, $0							# counter
	addi $s3, $k, -1
	loop:
		bge $t6, $s3, endLoop				# i < len(window)-1?
		addi $t6, $t6, 1					# i++ (we need the next item)
		sll $t6, $t6, 2						# i*=4
		lw $t7, window($t6)					# load item from window
		
		beqz $t7, endLoop					# window[i+1] == 0?
			srl $t6, $t6, 2					# i /= 4
			addi $t6, $t6, -1				# i--
			sll $t6, $t6, 2					# i *= 4
			sw $t7, window($t6)				# window[i] = window[i+1]
			srl $t6, $t6, 2					# i /= 4
					
		addi $t6, $t6, 1					# i++
		j loop
		
	endLoop:
		jr $ra
