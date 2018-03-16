
.globl main

# Leggo e stampo una matrice di X*Y interi separati da spazio
# X*Y < 100

.data
.align 2

# numero di colonne e righe
X: .word 0
Y: .word 0

# definizione della matrice di al massimo 100 elementi interi in memoria
matrice: .word 0:100

promptR: .asciiz "Quante righe vuoi inserire? "
promptC: .asciiz "Quante colonne vuoi inserire? "
chiediel: .asciiz "Prossimo elemento: "

.text

main:
# chiedo quanti elementi inserire
	la $a0, promptR		# indirizzo della stringa da stampare
	li $v0, 4		# print string
	syscall
# leggo e memorizzo Y
	li $v0, 5		# read integer
	syscall
	sw $v0, Y
	move $s0, $v0		# Y

# chiedo quanti elementi inserire
	la $a0, promptC		# indirizzo della stringa da stampare
	li $v0, 4		# print string
	syscall
# leggo e memorizzo X
	li $v0, 5		# read integer
	syscall
	sw $v0, X
	move $s1, $v0		# X

# leggo Y righe di X elementi e li memorizzo
	li $t0, 0		# inizializzo l'indice y 
	li $t1, 0		# inizializzo l'indice x 
	
cicloR:	beq $t0, $s0, fine_cicloR
cicloC: beq $t1, $s1, fine_cicloC

	# chiedo un elemento e lo memorizzo
	la $a0, chiediel	# prompt per chiedere un elemento
	li $v0, 4		# print string
	syscall
	li $v0, 5		# read integer
	syscall
	
	# calcolo la distanza dall'inizio della matrice (offset)
	# (X*y+x)*dim_elemento
	mul $t3, $s1, $t0	# X*y
	add $t3, $t3, $t1	# X*y+x
	sll $t3, $t3, 2		# (X*y+x)*4 -> offset in byte	
	sw $v0, matrice($t3)	# matrice[y][x] = valore

	addi $t1, $t1, 1	# incremento l'indice x
	j	cicloC		# continuo con la colonna seguente della stessa riga
	
fine_cicloC:
	li $t1, 0		# x  = 0
	addi $t0, $t0, 1	# y += 1
	j	cicloR

fine_cicloR:
# leggo dalla memoria Y righe di X elementi e li stampo
	li $t0, 0		# inizializzo l'indice y 
	li $t1, 0		# inizializzo l'indice x

stampaR: beq $t0, $s0, fine_stampaR
stampaC: beq $t1, $s1, fine_stampaC

	# calcolo la distanza dall'inizio della matrice (offset)
	# (X*y+x)*dim_elemento
	mul $t3, $s1, $t0	# X*y
	add $t3, $t3, $t1	# X*y+x
	sll $t3, $t3, 2		# (X*y+x)*4 -> offset in byte	
	lw $a0, matrice($t3)	# valore da stampare = matrice[y][x]

	# chiedo un elemento e lo memorizzo
	li $v0, 1		# print integer
	syscall
	li $a0, ' '
	li $v0, 11		# print char
	syscall

	addi $t1, $t1, 1	# incremento l'indice x
	j	stampaC		# continuo con la colonna seguente della stessa riga
	
fine_stampaC:
	li $a0, '\n'		# accapo
	li $v0, 11		# print char
	syscall
	
	li $t1, 0		# x  = 0
	addi $t0, $t0, 1	# y += 1
	j	stampaR

fine_stampaR:

fine:
	li $v0, 10		# fine programma
	syscall
	