
.globl main

# Leggo e stampo un vettore di interi separati da spazio in ordine opposto
# N < 100

.data
.align 2

# numero di elementi
N: .word 0

# definizione del vettore di al massimo 100 elementi interi in memoria
vettore: .word 0:100

prompt: .asciiz "Quanti elementi vuoi inserire? "
chiediel: .asciiz "Prossimo elemento: "

.text

main:
# chiedo quanti elementi inserire
	la $a0, prompt		# indirizzo della stringa da stampare
	li $v0, 4		# print string
	syscall
# leggo e memorizzo N
	li $v0, 5		# read integer
	syscall
	sw $v0, N
	move $t1, $v0		# copio N in un registro

# leggo N elementi e li memorizzo
	li $t0, 0		# inizializzo l'indice degli elementi
ciclo:	beq $t0, $t1, fine_ciclo
	# chiedo un elemento e lo memorizzo
	la $a0, chiediel	# prompt per chiedere un elemento
	li $v0, 4		# print string
	syscall
	li $v0, 5		# read integer
	syscall
	
	# calcolo la distanza dall'inizio del vettore (offset)
	sll $s0, $t0, 2		# indice * 4
	sw $v0, vettore($s0)	# vettore[indice] = x

	addi $t0, $t0, 1	# incremento l'indice degli elementi
	j	ciclo		# rieseguo il test

fine_ciclo:
# leggo N elementi dalla memoria e li stampo separati da spazio dall'ultimo al primo

	lw 	$t3, N
	subi 	$t3, $t3, 1	# indice dell'elemento N-1 esimo
	sll	$t3, $t3, 2	# (N-1)*4     offset dell'ultimo elemento
stampa:	blt	$t3, $zero, fine
	
	# leggo l'elemento dalla memoria
	lw	$a0, vettore($t3)

	# stampare l'elemento che si trova all'offset $t3
	li $v0, 1		# print integer
	syscall
	
	# stampare uno spazio
	li $a0, ' '
	li $v0, 11
	syscall

	# decrementare l'offset
	subi	$t3, $t3, 4	# passiamo all'elemento precedente
	j stampa
fine:
	li $v0, 10		# fine programma
	syscall
