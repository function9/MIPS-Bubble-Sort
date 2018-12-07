.data
	arrayA: .word 6,12,1,14,9,3,17,4,12,10
	format: .asciiz ", "
	open: .asciiz "{"
	close: .asciiz "}"
	begin: .asciiz "program start"
	new: .asciiz "\n\0"
	end: .asciiz "program end"
.text

.globl main

main:
	la 		$t1,arrayA
	li      $t2, 0 #j
	li      $t3, 0 #i
	li      $s1, 9 #arraylength
	li		$t4, 10
	li		$t5, 0
	la		$s5, 0($t1)
	li		$v0, 4
	la		$a0, begin
	syscall
	la		$a0, new
		syscall
	j		print
	loop:
		bge	$t2, 10, print
		li		$t5, 1
		move    $t3, $0
		subu    $s2, $s1, $t2
		move	$t1, $s5
		sort:
			bge     $t3, $s2, exitSort
			lw      $a0, 0($t1) 
			lw		$a1, 4($t1)
			ble     $a0, $a1, skip
			sw		$a1, 0($t1)
			sw		$a0, 4($t1)
			skip:
				addiu		$t3, $t3, 1
				addu		$t1, $t1, 4
				j			sort
		exitSort:
			addiu   $t2, $t2, 1
			j loop
		
	print:
		li		$v0, 4
		la		$a0, open
		syscall
		li		$t4, 10
		move	$t1, $s5
		printloop:
		beq		$t4, $0, printexit
		li		$v0, 1
		lw		$a0, 0($t1)
		syscall
		li		$v0, 4
		la		$a0, format
		syscall
		addi $t1, $t1, 4
		sub $t4, $t4, 1
		j printloop
	printexit:
		li		$v0, 4
		la		$a0, close
		syscall
		la		$a0, new
		syscall
		beq		$t5, $0, loop
		j	exit
	exit:
		la		$a0, end
		syscall
		li $v0, 10
		syscall