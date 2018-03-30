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
	jal nextInt					# get k
	move $k, $v0
	
	jal sequenceLoop			# core of the program

	endCore:
	jal printStats				# print minimums and maximums

	exit:
	li $v0, 10
	syscall
	
# get an integer via syscall 5 #
nextInt:
	li $v0, 5
	syscall
	jr $ra

# print the integer in $a0, followed by "\n"	
printInt:
	li $v0, 1
	syscall

	la $a0, newLine
	li $v0, 4
	syscall
				
	jr $ra
	
# print the statistics of S and Y
printStats:
	move $a0, $minS
	jal printInt
	move $a0, $maxS
	jal printInt
	move $a0, $minY
	jal printInt
	move $a0, $maxY
	jal printInt
	
	j exit
	
# loop that gets an integer at a time, computes statistics and updates the sliding window
sequenceLoop:
	jal nextInt							# get the next integer
	beqz $v0, endSequenceLoop			# break loop if 0 is given
	sll $i, $i, 2						# left-shift the index to use is as offset in the array
	sw $v0, window($i)					# store the integer in the array
	srl $i, $i, 2						# right-shift back the index to use it in the loop

	# -- COMPUTE STATS FOR S -- #
	bnez $isFirstOfSeq, doStatsS		# if this is not the first number of the sequence, compute statistics
		move $minS, $v0					# else initialize the minimum of S
		move $maxS, $v0					# and the maximum of S
		li $isFirstOfSeq, 1				# now the next number will not be the first anymore --> set it to false (1)
		j afterStatsS
	doStatsS:
		blt $v0, $minS, setMinS			# if this is the new minimum, update it
		bgt $v0, $maxS, setMaxS			# else if this is the new maximum, update it
		j afterStatsS
		setMinS:
			move $minS, $v0
			j afterStatsS
		setMaxS:
			move $maxS, $v0
			
	afterStatsS:
	
	# -- UPDATE SUM -- #
	add $sum, $sum, $v0					# increment the sum with the current integer
	
	# -- PRINT Y ITEM OR NOT -- #
	addi $t6, $k, -1					# $t6 = k-1	
	bne $i, $t6, afterWindowUpdate		# if we haven't already got k numbers, skip the math; else...
		move $a0, $sum
		jal printInt					# print the sum (uses $a0)
		bnez $isFirstStat, doStatsY		# if this isn't going to be the first statistic, do calculate it
			move $minY, $sum			# else initialize the minimum of Y
			move $maxY, $sum			# and its maximum
			li $isFirstStat, 1			# now the next is not going to be the first statistic anymore --> set it to false (1)
			j afterStatsY
		doStatsY:
			blt $sum, $minY, setMinY	# if this is the new minimum, update it
			bgt $sum, $maxY, setMaxY	# else if this is the new maximum, update it
			j afterStatsY
			setMinY:
				move $minY, $sum
				j afterStatsY
			setMaxY:
				move $maxY, $sum

		afterStatsY:
		lw $t7, window($0)				# load first number of window
		sub $sum, $sum, $t7				# subtract it from the current sum
		jal shiftWindow					# move all the items in the window, 1 position to left
		addi $i, $i, -1					# now we have room for another integer --> decrement the counter
		
	afterWindowUpdate:
	addi $i, $i, 1						# increment counter
	j sequenceLoop
	
endSequenceLoop:
	j endCore

# shift 1 place to left, all the items in the window
shiftWindow:
	move $t6, $0						# counter i
	addi $s3, $k, -1					# $s3 = k-1
	loop:
		bge $t6, $s3, endLoop			# if i>k-1, end this loop; else...
		addi $t6, $t6, 1				# i++ (we need the next item)
		sll $t6, $t6, 2					# i*=4
		lw $t7, window($t6)				# load item from window
		
		beqz $t7, endLoop				# if window[i+1] == 0, end this loop (becaouse all the rest is 0); else...
			srl $t6, $t6, 2				# i /= 4
			addi $t6, $t6, -1			# i--
			sll $t6, $t6, 2				# i *= 4
			sw $t7, window($t6)			# window[i] = window[i+1]
			srl $t6, $t6, 2				# i /= 4
					
		addi $t6, $t6, 1				# i++
		j loop
		
	endLoop:
		jr $ra
