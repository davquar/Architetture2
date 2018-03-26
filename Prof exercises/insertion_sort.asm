################################################################################
# Insertion sort (con non più di 200 valori)
################################################################################

.globl main

.data
.align 2
#                 0123012301230123012301230123
prompt1: .asciiz "Quanti valori inseriamo? "
prompt2: .asciiz "Prossimo valore "
N:	 .word 0
vettore: .word 0:200

################################################################################

.text

# nel seguito cerco di usare registri simili per valori simili quando chiamo le funzioni
.eqv $vettore	$a0	# indirizzo iniziale del vettore
.eqv $N		$a1	# numero di elementi nel vettore

# main program
main:
	# leggo N e gli N valori che inserisco nel vettore
	# leggi_valori(vettore) -> N
	la $vettore, vettore
	jal leggi_valori
	sw $v0, N		# salvo il risultato N in memoria

	# li ordino con insertion_sort(vettore, N)
	# NON assumo che $a0 contenga ancora l'indirizzo del vettore
	la $vettore, vettore 
	move $N, $v0		# N
	jal insertion_sort	# insertion_sort(vettore=$a0, N=$a1)
	
	# NON assumo che $a0 e $a1 restino invariati
	la $vettore, vettore 
	lw $N, N		# rileggo N dalla memoria
	jal stampa_valori	# stampa_valori(vettore=$a0, N=$a1)

	# termino il programma
	li $v0, 10
	syscall

################################################################################

# lettura valori(vettore) -> N
# questa è una funzione foglia quindi posso usare tranquillamente i registri $tN
# sto attento a non usare nomi già definiti prima
.eqv $vett	$t0	# mi copierò da parte l'indirizzo iniziale del vettore perchè $a0 è usato dalle syscall
.eqv $num_el	$t1	# N
.eqv $k		$t2	# indice del ciclo
.eqv $off	$t3	# offset dell'elemento k
.eqv $ind	$t4	# indirizzo dell'elemento k

leggi_valori:
	move $vett, $vettore	# mi copio l'indirizzo del vettore perchè $a0 serve per le syscall

	# stampo prompt1
	li $v0, 4
	la $a0, prompt1
	syscall

	# leggo il valore N
	li $v0, 5
	syscall

	# salvo N in un registro temporaneo perchè $v0 serve per le syscall
	move $num_el, $v0	# N

	li $k, 0		# inizializzo l'indice del ciclo k=0

	# eseguo N volte
loop_lettura:
	# while (k<N)
	beq $k, $num_el, fine_lettura	# se ho finito di inserire esco dalla funzione
	
	# altrimenti stampo prompt2
	la $a0, prompt2
	li $v0, 4
	syscall
	
	# leggo un intero (un valore)
	li $v0, 5
	syscall
	
	# lo memorizzo nel vettore
	sll $off, $k, 2		# offset = k*4
	add $ind, $vett, $off	# indirizzo = vettore + offset
	sw $v0, ($ind)		# salvo l'elemento: vettore[k] = valore
	
	addi $k, $k, 1		# incremento l'indice: k += 1
	j loop_lettura		# e continuo il ciclo

fine_lettura:
	move $v0, $num_el	# risultato = N
	jr $ra			# si torna al chiamante

################################################################################

# stampa valori: vedi esempi dell'altro giorno 
# (per ora guardate direttamente il contenuto della memoria nel simulatore)
stampa_valori:
	# eseguo N volte
		# leggere l'elemento i dal vettore
		# stamparlo
		# stampare uno spazio
	# torna al chiamante
	jr $ra

################################################################################

# ordino i valori con insertion_sort(vettore, N)
# questa non è una funzione foglia (chiama insert) per cui uso i registri $sN
# sto attento a non usare nomi già definiti prima
# e riuso le definizioni $vettore=$a0 e $N=$a1 che ho fatto prima
.eqv $temp_N	$s0	# visto che uso $a1 come argomento di insert, mi tengo da parte N=$a1 che mi serve qui
.eqv $i		$s1	# indice i dell'elemento da inserire
.eqv $address	$s2	# indirizzo dell'elemento nel vettore
.eqv $valore	$s3	# valore corrente da inserire nella posizione giusta
# e definisco i nomi per chiamare in modo più leggibile insert 
.eqv $M		$a1	# numero di elementi nella parte ordinata del vettore
.eqv $X		$a2	# valore da inserire nel vettore

insertion_sort:
	# salviamo su stack $ra perchè questa funzione usa un jal che sovrascrive $ra
	addi $sp, $sp, -4			# alloco 1 word su stack
	sw   $ra, 0($sp)			# salvo $ra

	move $temp_N $N				# copio in altro registro $a1 che mi servirà nel ciclo

	# per ciascun elemento dall'indice 1 a N-1
	li $i, 1				# indice dei valori da inserire, si parte dal secondo elemento

	# while (i<N)
ciclo_insertion_sort:
	beq $i, $temp_N, fine_insertion_sort	# se ho finito gli elementi finisco la funzione

	# altrimenti calcolo la posizione in memoria e leggo il valore in un registro
	sll $address, $i, 2			# offset = i*4
	add $address, $address, $vettore	# indirizzo dell'elemento = vettore + offset
	lw  $valore, ($address)			# leggo l'elemento da inserire
	
	# lo inserisco nella parte già ordinata del vettore al suo posto usando insert(vettore, i, valore)
	# insert(vettore=$a0, i=$a1, valore=$a2)
	move $M, $i
	move $X, $valore
		
	jal insert
	
	addi $i, $i, 1				# e passo al prossimo elemento
	j    ciclo_insertion_sort		# continuando il while
	
fine_insertion_sort:
	# ripristino $ra dallo stack
	lw   $ra, 0($sp)	# leggo $ra
	addi $sp, $sp,  4	# disalloco 1 word su stack

	# torna al chiamante
	jr $ra

################################################################################

# insert(vettore=$a0, M=$a1, X=$a2) -> None

# do un nome ai registri che uso, questa è una funzione foglia e quindi posso usare liberamente i registri $tN
# riuso i nomi $vettore=$a0 $M=$a1 e $X=$a2
.eqv $indirizzo $t0	# indirizzo dell'elemento corrente
.eqv $Y $t1		# valore con cui confronto X

insert:
	# dato un elemento X ed un vettore ordinato di M elementi
	# scandisco il vettore con puntatori a partire dalla fine (M) (in tempo O(M))
	sll  $indirizzo, $M, 2				# offset=4*M	(della posizione M)
	add  $indirizzo, $indirizzo, $vettore		# vettore+offset = indirizzo in memoria di vettore[M]

ciclo_insert:
	# se siamo arrivati all'indirizzo iniziale del vettore ovvero alla posizione i=0
	beq  $indirizzo, $vettore, salva_X_ed_esci	# si salva vettore[0] = X e si esce

	# altrimenti si passa a confrontare X e vettore[i-1]
	lw   $Y, -4($indirizzo)				# Y=vettore[i-1]
	blt  $Y, $X, salva_X_ed_esci			# se Y<X passo a memorizzare X in questa posizione
	
	# altrimenti sposto Y di un posto in avanti
	sw   $Y, ($indirizzo)				# vettore[i] = vettore[i-1]
	# e continuo il ciclo con l'elemento precedente
	subi $indirizzo, $indirizzo, 4			# indirizzo di vettore[i-1]
	j    ciclo_insert				# continuo il ciclo col prossimo elemento

salva_X_ed_esci:
	# altrimenti inserisco il valore X (gli altri li abbiamo spostati) e termino la funzione
	sw   $X, ($indirizzo)				# vettore[i] = X
	jr   $ra					# torno al chiamante

###################################################################################################################