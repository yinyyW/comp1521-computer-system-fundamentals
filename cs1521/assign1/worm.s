#
# COMP1521 18s1 -- Assignment 1 -- Worm on a Plane!
#
# Base code by Jashank Jeremy and Wael Alghamdi
# Tweaked (severely) by John Shepherd
#
# Set your tabstop to 8 to make the formatting decent

# Requires:
#  - [no external symbols]

# Provides:
	.globl	wormCol
	.globl	wormRow
	.globl	grid
	.globl	randSeed

	.globl	main
	.globl	clearGrid
	.globl	drawGrid
	.globl	initWorm
	.globl	onGrid
	.globl	overlaps
	.globl	moveWorm
	.globl	addWormToGrid
	.globl	giveUp
	.globl	intValue
	.globl	delay
	.globl	seedRand
	.globl	randValue

	# Let me use $at, please.
	.set	noat

# The following notation is used to suggest places in
# the program, where you might like to add debugging code
#
# If you see e.g. putc('a'), replace by the three lines
# below, with each x replaced by 'a'
#
# print out a single character
# define putc(x)
# 	addi	$a0, $0, x
# 	addiu	$v0, $0, 11
# 	syscall
# 
# print out a word-sized int
# define putw(x)
# 	add 	$a0, $0, x
# 	addiu	$v0, $0, 1
# 	syscall

####################################
# .DATA
	.data

	.align 4
wormCol:	.space	40 * 4
	.align 4
wormRow:	.space	40 * 4
	.align 4
grid:		.space	20 * 40 * 1

randSeed:	.word	0
dot:        .byte '.'
at:         .byte '@'
body:       .byte 'o'

main__0:	.asciiz "Invalid Length (4..20)"
main__1:	.asciiz "Invalid # Moves (0..99)"
main__2:	.asciiz "Invalid Rand Seed (0..Big)"
main__3:	.asciiz "Iteration "
main__4:	.asciiz "Blocked!\n"

	# ANSI escape sequence for 'clear-screen'
main__clear:	.asciiz "\033[H\033[2J"
# main__clear:	.asciiz "__showpage__\n" # for debugging

giveUp__0:	.asciiz "Usage: "
giveUp__1:	.asciiz " Length #Moves Seed\n"

####################################
# .TEXT <main>
	.text
main:

# Frame:	$fp, $ra, $s0, $s1, $s2, $s3, $s4
# Uses: 	$a0, $a1, $v0, $s0, $s1, $s2, $s3, $s4
# Clobbers:	$a0, $a1

# Locals:
#	- `argc' in $s0
#	- `argv' in $s1
#	- `length' in $s2
#	- `ntimes' in $s3
#	- `i' in $s4

# Structure:
#	main
#	-> [prologue]
#	-> main_seed
#	  -> main_seed_t
#	  -> main_seed_end
#	-> main_seed_phi
#	-> main_i_init
#	-> main_i_cond
#	   -> main_i_step
#	-> main_i_end
#	-> [epilogue]
#	-> main_giveup_0
#	 | main_giveup_1
#	 | main_giveup_2
#	 | main_giveup_3
#	   -> main_giveup_common

# Code:
	# set up stack frame
	sw	$fp, -4($sp)
	sw	$ra, -8($sp)
	sw	$s0, -12($sp)
	sw	$s1, -16($sp)
	sw	$s2, -20($sp)
	sw	$s3, -24($sp)
	sw	$s4, -28($sp)
	la	$fp, -4($sp)
	addiu	$sp, $sp, -28

	# save argc, argv
	add	$s0, $0, $a0
	add	$s1, $0, $a1

	# if (argc < 3) giveUp(argv[0],NULL);
	slti	$at, $s0, 4
	bne	$at, $0, main_giveup_0

	# length = intValue(argv[1]);
	addi	$a0, $s1, 4	# 1 * sizeof(word)
	lw	$a0, ($a0)	# (char *)$a0 = *(char **)$a0
	jal	intValue

	# if (length < 4 || length >= 40)
	#     giveUp(argv[0], "Invalid Length");
	# $at <- (length < 4) ? 1 : 0
	slti	$at, $v0, 4
	bne	$at, $0, main_giveup_1
	# $at <- (length < 40) ? 1 : 0
	slti	$at, $v0, 40
	beq	$at, $0, main_giveup_1
	# ... okay, save length
	add	$s2, $0, $v0

	# ntimes = intValue(argv[2]);
	addi	$a0, $s1, 8	# 2 * sizeof(word)
	lw	$a0, ($a0)
	jal	intValue

	# if (ntimes < 0 || ntimes >= 100)
	#     giveUp(argv[0], "Invalid # Iterations");
	# $at <- (ntimes < 0) ? 1 : 0
	slti	$at, $v0, 0
	bne	$at, $0, main_giveup_2
	# $at <- (ntimes < 100) ? 1 : 0
	slti	$at, $v0, 100
	beq	$at, $0, main_giveup_2
	# ... okay, save ntimes
	add	$s3, $0, $v0

main_seed:
	# seed = intValue(argv[3]);
	add	$a0, $s1, 12	# 3 * sizeof(word)
	lw	$a0, ($a0)
	jal	intValue

	# if (seed < 0) giveUp(argv[0], "Invalid Rand Seed");
	# $at <- (seed < 0) ? 1 : 0
	slt	$at, $v0, $0
	bne	$at, $0, main_giveup_3

main_seed_phi:
	add	$a0, $0, $v0
	jal	seedRand

	# start worm roughly in middle of grid

	# startCol: initial X-coord of head (X = column)
	# int startCol = 40/2 - length/2;
	addi	$s4, $0, 2
	addi	$a0, $0, 40
	div	$a0, $s4
	mflo	$a0
	# length/2
	div	$s2, $s4
	mflo	$s4
	# 40/2 - length/2
	sub	$a0, $a0, $s4

	# startRow: initial Y-coord of head (Y = row)
	# startRow = 20/2;
	addi	$s4, $0, 2
	addi	$a1, $0, 20
	div	$a1, $s4
	mflo	$a1

	# initWorm($a0=startCol, $a1=startRow, $a2=length)
	add	$a2, $0, $s2
	jal	initWorm

main_i_init:
	# int i = 0;
	add	$s4, $0, $0
main_i_cond:
	# i <= ntimes  ->  ntimes >= i  ->  !(ntimes < i)
	#   ->  $at <- (ntimes < i) ? 1 : 0
	slt	$at, $s3, $s4
	bne	$at, $0, main_i_end

	# clearGrid();
	jal	clearGrid

	# addWormToGrid($a0=length);
	add	$a0, $0, $s2
	jal	addWormToGrid

	# printf(CLEAR)
	la	$a0, main__clear
	addiu	$v0, $0, 4	# print_string
	syscall

	# printf("Iteration ")
	la	$a0, main__3
	addiu	$v0, $0, 4	# print_string
	syscall

	# printf("%d",i)
	add	$a0, $0, $s4
	addiu	$v0, $0, 1	# print_int
	syscall

	# putchar('\n')
	addi	$a0, $0, 0x0a
	addiu	$v0, $0, 11	# print_char
	syscall

	# drawGrid();
	jal	drawGrid

	# Debugging? print worm pos as (r1,c1) (r2,c2) ...

	# if (!moveWorm(length)) {...break}
	add	$a0, $0, $s2
	jal	moveWorm
	bne	$v0, $0, main_moveWorm_phi

	# printf("Blocked!\n")
	la	$a0, main__4
	addiu	$v0, $0, 4	# print_string
	syscall

	# break;
	j	main_i_end

main_moveWorm_phi:
	addi	$a0, $0, 1
	jal	delay

main_i_step:
	addi	$s4, $s4, 1
	j	main_i_cond
main_i_end:

	# exit (EXIT_SUCCESS)
	# ... let's return from main with `EXIT_SUCCESS' instead.
	addi	$v0, $0, 0	# EXIT_SUCCESS

main__post:
	# tear down stack frame
	lw	$s4, -24($fp)
	lw	$s3, -20($fp)
	lw	$s2, -16($fp)
	lw	$s1, -12($fp)
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	jr	$ra

main_giveup_0:
	add	$a1, $0, $0	# NULL
	j	main_giveup_common
main_giveup_1:
	la	$a1, main__0	# "Invalid Length"
	j	main_giveup_common
main_giveup_2:
	la	$a1, main__1	# "Invalid # Iterations"
	j	main_giveup_common
main_giveup_3:
	la	$a1, main__2	# "Invalid Rand Seed"
	# fall through
main_giveup_common:
	# giveUp ($a0=argv[0], $a1)
	lw	$a0, ($s1)	# argv[0]
	jal	giveUp		# never returns

####################################
# clearGrid() ... set all grid[][] elements to '.'
# .TEXT <clearGrid>
	.text
clearGrid:

# Frame:	$fp, $ra, $s0, $s1
# Uses: 	$s0, $s1, $t1, $t2
# Clobbers:	$t1, $t2

# Locals:
#	- `row' in $s0
#	- `col' in $s1
#	- `&grid[row][col]' in $t1
#	- '.' in $t2

# Code:
	# set up stack frame
	sw	$fp, -4($sp)
	sw	$ra, -8($sp)
	sw	$s0, -12($sp)
	sw	$s1, -16($sp)
	la	$fp, -4($sp)
	addiu	$sp, $sp, -16

### TODO: Your code goes here
    li  $s0, 20
    li  $s1, 40
    la  $t1, grid   # $t1 = &grid[0][0]
    lb  $t2, dot    # $t2 = '.'
    li  $t3, 0      #t3 = row = 0
    li  $t4, 0      #t4 = col = 0
loopROW:
    beq $t3, $s0, end_loopROW
loopCOL:
    beq $t4, $s1, end_loopCOL
    #compute offbytes
    mul  $t0, $t3, $s1
    add  $t0, $t0, $t4
    add  $t5, $t0, $t1   #get &grid[row][col]
    sb   $t2, 0($t5)
    addi $t4, $t4, 1
    j    loopCOL
end_loopCOL:
    li   $t4, 0
    addi $t3, $t3, 1
    j    loopROW
end_loopROW:
	# tear down stack frame
	lw	$s1, -12($fp)
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	jr	$ra


####################################
# drawGrid() ... display current grid[][] matrix
# .TEXT <drawGrid>
	.text
drawGrid:

# Frame:	$fp, $ra, $s0, $s1, $t1
# Uses: 	$s0, $s1
# Clobbers:	$t1

# Locals:
#	- `row' in $s0
#	- `col' in $s1
#	- `&grid[row][col]' in $t1

# Code:
	# set up stack frame
	sw	$fp, -4($sp)
	sw	$ra, -8($sp)
	sw	$s0, -12($sp)
	sw	$s1, -16($sp)
	la	$fp, -4($sp)
	addiu	$sp, $sp, -16

### TODO: Your code goes here
    li  $s0, 20
    li  $s1, 40
    la  $t1, grid   #get grid's address
    li  $t3, 0      #t3 = row = 0
    li  $t4, 0      #t4 = col = 0

loop_ROW:
    beq $t3, $s0, end_loop_ROW
loop_COL:
    beq $t4, $s1, end_loop_COL
    #compute offbytes
    mul  $t0, $t3, $s1
    add  $t0, $t0, $t4
    add  $t5, $t0, $t1   #get &grid[row][col]
    lb   $t2, ($t5)      #load grid[row][col] into $t2
    move $a0, $t2         #printf("grid[row][col]")
    li   $v0, 11
    syscall
    addi $t4, $t4, 1
    j    loop_COL
end_loop_COL:
    li   $t4, 0
    #printf("\n")
    li   $a0, '\n'
    li   $v0, 11
    syscall
    addi $t3, $t3, 1
    j    loop_ROW


end_loop_ROW:
	# tear down stack frame
	lw	$s1, -12($fp)
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	jr	$ra


####################################
# initWorm(col,row,len) ... set the wormCol[] and wormRow[]
#    arrays for a worm with head at (row,col) and body segements
#    on the same row and heading to the right (higher col values)
# .TEXT <initWorm>
	.text
initWorm:

# Frame:	$fp, $ra
# Uses: 	$a0, $a1, $a2, $t0, $t1, $t2
# Clobbers:	$t0, $t1, $t2

# Locals:
#	- `col' in $a0
#	- `row' in $a1
#	- `len' in $a2
#	- `newCol' in $t0
#	- `nsegs' in $t1
#	- temporary in $t2

# Code:
	# set up stack frame
	sw	$fp, -4($sp)
	sw	$ra, -8($sp)
	la	$fp, -4($sp)
	addiu	$sp, $sp, -8

### TODO: Your code goes here
    addi $t0, $a0, 1    #newCol = col + 1
    li   $t1, 1         #nsegs = 1
    la   $t2, wormCol   #$t2 = &wormCol
    la   $t3, wormRow   #$t3 = &wormRow
    sw   $a0, ($t2)     #*wormCol[0] = col
    sw   $a1, ($t3)     #*wormRow[0] = row
    li   $t4, 40        #COL = 40
    li   $t5, 4         #sizeof(int) = 4

init_loop:
    beq  $t1, $a2, end_init_loop    #for(nsegs = 1; nsegs < len; nsegs++) 
    beq  $t0, $t4, end_init_loop    #if (newCol == COL) break;
    mul $t6, $t5, $t1               #$t6 = offset
    add $t7, $t2, $t6               #get &wormCol[nsegs]
    sw  $t0, ($t7)                  #*wormCol[nsegs] = newCol
    addi $t0, $t0, 1                #newCol++

    add $t8, $t3, $t6               #get &wormRow[nsegs]
    sw  $a1, ($t8)                  #*wormRow[nsegs] = Row

    addi $t1, $t1, 1                #nsegs++
    j   init_loop
end_init_loop:
	# tear down stack frame
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	jr	$ra


####################################
# ongrid(col,row) ... checks whether (row,col)
#    is a valid coordinate for the grid[][] matrix
# .TEXT <onGrid>
	.text
onGrid:

# Frame:	$fp, $ra
# Uses: 	$a0, $a1, $v0
# Clobbers:	$v0

# Locals:
#	- `col' in $a0
#	- `row' in $a1

# Code:

### TODO: complete this function

	# set up stack frame
	sw  $fp, -4($sp)
	sw  $a0, -8($sp)
	sw  $a1, -12($sp)
	sw  $ra, -16($sp)
	la  $fp, -4($sp)
	addiu $sp, $sp, -16

    # code for function
    li  $t0, 40                 # $t0 = NCOLS = 40
    li  $t1, 20                 # $t1 = NROWS = 20
    blt $a0, $zero, return_zero_Ongrid # col < 0
    bge $a0, $t0, return_zero_Ongrid   # col >= NCOLS
    blt $a1, $zero, return_zero_Ongrid # row < 0
    bge $a1, $t1, return_zero_Ongrid   # row >=NROWS
    j   return_one_Ongrid

return_zero_Ongrid:
    li  $v0, 0
    j   Exit_grid
return_one_Ongrid:
    li  $v0, 1
    j   Exit_grid
	# tear down stack frame
Exit_grid:
    lw  $ra, -12($fp)
    lw  $a1, -8($fp)
    lw  $a0, -4($fp)
    la  $sp, 4($fp)
    lw  $fp, ($fp)
    jr  $ra

####################################
# overlaps(r,c,len) ... checks whether (r,c) holds a body segment
# .TEXT <overlaps>
	.text
overlaps:

# Frame:	$fp, $ra
# Uses: 	$a0, $a1, $a2
# Clobbers:	$t6, $t7

# Locals:
#	- `col' in $a0
#	- `row' in $a1
#	- `len' in $a2
#	- `i' in $t6

# Code:

### TODO: complete this function

	# set up stack frame
	sw  $fp, -4($sp)
	sw  $a0, -8($sp)
	sw  $a1, -12($sp)
	sw  $a2, -16($sp)
	sw  $ra, -20($sp)
	la  $fp, -4($sp)
	addiu $sp, $sp, -20

    # code for function
    li  $t6, 0                      # index i = 0
    li  $t7, 4                      #sizeof(int) = 4
    la  $t4, wormCol                #get &wormCol[0]
    la  $t5, wormRow                #get &wormRow[0]
loopOver:
    beq $t6, $a2, end_loopOver       #for(i=0; i<len; i++)
    mul $t0, $t6, $t7               # $t0 = offset
    add $t1, $t0, $t4               #get &wormCol[i]
    add $t2, $t0, $t5               #get &wormRow[i]
    lw  $t1, ($t1)                  #t1 = *wormCol[i]
    lw  $t2, ($t2)                  #t2 = *wormRow[i]
    bne $t1, $a0, CONTINUE
    bne $t2, $a1, CONTINUE
    j   return_one_over
CONTINUE:
    addi $t6, $t6, 1
    j   loopOver
return_one_over:
    li  $v1, 1
    j   EXIT_over
end_loopOver:
    li  $v1, 0
    j   EXIT_over
	# tear down stack frame
EXIT_over:
	lw  $ra, -16($fp)
	lw  $a2, -12($fp)
    lw  $a1, -8($fp)
    lw  $a0, -4($fp)
    la  $sp, 4($fp)
    lw  $fp, ($fp)
    jr  $ra


####################################
# moveWorm() ... work out new location for head
#         and then move body segments to follow
# updates wormRow[] and wormCol[] arrays

# (col,row) coords of possible places for segments
# done as global data; putting on stack is too messy
	.data
	.align 4
possibleCol: .space 8 * 4	# sizeof(word)
possibleRow: .space 8 * 4	# sizeof(word)

# .TEXT <moveWorm>
	.text
moveWorm:

# Frame:	$fp, $ra, $s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7
# Uses: 	$s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7, $t0, $t1, $t2, $t3
# Clobbers:	$t0, $t1, $t2, $t3

# Locals:
#	- `col' in $s0
#	- `row' in $s1
#	- `len' in $s2
#	- `dx' in $s3
#	- `dy' in $s4
#	- `n' in $s7
#	- `i' in $t0
#	- tmp in $t1
#	- tmp in $t2
#	- tmp in $t3
# 	- `&possibleCol[0]' in $s5
#	- `&possibleRow[0]' in $s6

# Code:
	# set up stack frame
	sw	$fp, -4($sp)
	sw	$ra, -8($sp)
	sw	$s0, -12($sp)
	sw	$s1, -16($sp)
	sw	$s2, -20($sp)
	sw	$s3, -24($sp)
	sw	$s4, -28($sp)
	sw	$s5, -32($sp)
	sw	$s6, -36($sp)
	sw	$s7, -40($sp)
	la	$fp, -4($sp)
	addiu	$sp, $sp, -40

### TODO: Your code goes here
    move $s2, $a0						# $s2 = len
	li	$s3, -1							# $s3 = dx
	li	$s4, -1							# $s4 = dy
	la	$s5, possibleCol                # $s5 = &possibleCol[0]
	la	$s6, possibleRow                # $s6 = &possibleRow[0]
	li	$s7, 0							# n = $s7 = 0
	li	$t9, 1							# $t1 = 1, -1<= dx <= 1
	
loop_dx:
	bgt	$s3, $t9, end_loop_dx
loop_dy:
	bgt	$s4, $t9, end_loop_dy
	la	$t2, wormCol					# $t2 = &wormCol[0]
	la	$t3, wormRow					# $t3 = &wormRow[0]
	lw	$s0, ($t2)						# $s0 = *wormCol[0]
	lw	$s1, ($t3)						# $s1 = *wormRow[0]
	add	$s0, $s0, $s3					# $s0 = wormCol[0] + dx = col
	add $s1, $s1, $s4					# $s1 = wormRow[0] + dy = row

	move $a0, $s0
	move $a1, $s1
	jal onGrid							#call onGrid function

	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal overlaps
	
	beq $v0, $zero, go_next_dy
	bnez $v1, go_next_dy

	li	$t4, 4							#sizeof(int) = 4
	mul $t5, $t4, $s7					# $t5 = offset = 4 * n
	add $t6, $s5, $t5					# $t6 = &possibleCol[n]
	add $t7, $s6, $t5					# $t7 = &possibleRow[n]
	sw 	$s0, ($t6)						# possibleCol[n] = col
	sw  $s1, ($t7)						# possibleRow[n] = row
	addi $s7, $s7, 1					# n++
	j	go_next_dy

go_next_dy:
	addi $s4, $s4, 1					#dy++
	j	loop_dy
end_loop_dy:
	addi $s3, $s3, 1					#dx++
	li	$s4, -1
	j	loop_dx
end_loop_dx:
	beq	$s7, $zero, return_zero_move

    addi $t0, $s2, -1					# i = $t0 = len -  1
loop_len:
	beq	$t0, $zero, end_loop_len
	la	$t2, wormCol					# &wormCol[0]
	la	$t3, wormRow					# &wormRow[0]
	li	$t4, 4							# sizeof(int) = 4
	mul $t5, $t4, $t0					# $t5 = offbyte(i)
	add	$t6, $t2, $t5					# &wormCol[i]
	add $t7, $t3, $t5					# &wormRow[i]
	addi $t2, $t6, -4					# &wormCol[i-1]
	addi $t3, $t7, -4					# &wormRow[i-1]
	lw	$t2, ($t2)						# $t2 = *wormCol[i-1]
	lw	$t3, ($t3)						# $t3 = *wormRow[i-1]
	sw	$t2, ($t6)						# wormCol[i] = wormCol[i-1]
	sw	$t3, ($t7)						# wormRow[i] = wormRow[i-1]
	addi $t0, $t0, -1					# i--
	j	loop_len

end_loop_len:
	move $a0, $s7
	jal	randValue						# randValue(n)
	move $t0, $v0						# i = randValue(n)

	li	$t4, 4
	mul	$t2, $t4, $t0					# $t2 = offset = 4 * i
	add $t3, $s5, $t2					# $t3 = &possibleCol[i]
	add $t4, $s6, $t2					# $t4 = &possibleRow[i]
	lw	$t3, ($t3)						# $t3 = possibleCol[i]
	lw	$t4, ($t4)						# $t4 = possibleRow[i]
	la	$t5, wormCol					# $t5 = &wormCol[0]
	la	$t6, wormRow					# $t6 = &wormRow[0]
	sw	$t3, ($t5)						# wormCol[0] = possibleCol[i]
	sw	$t4, ($t6)						# wormRow[0] = possibleRow[i]
	j	return_one_move

return_one_move:
	li	$v0, 1
	j	EXIT_MOVE
return_zero_move:
	li	$v0, 0
	j	EXIT_MOVE    

	# tear down stack frame
EXIT_MOVE:
	lw	$s7, -36($fp)
	lw	$s6, -32($fp)
	lw	$s5, -28($fp)
	lw	$s4, -24($fp)
	lw	$s3, -20($fp)
	lw	$s2, -16($fp)
	lw	$s1, -12($fp)
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)

	jr	$ra

####################################
# addWormTogrid(N) ... add N worm segments to grid[][] matrix
#    0'th segment is head, located at (wormRow[0],wormCol[0])
#    i'th segment located at (wormRow[i],wormCol[i]), for i > 0
# .TEXT <addWormToGrid>
	.text
addWormToGrid:

# Frame:	$fp, $ra, $s0, $s1, $s2, $s3
# Uses: 	$a0, $s0, $s1, $s2, $s3, $t1
# Clobbers:	$t1

# Locals:
#	- `len' in $a0
#	- `&wormCol[i]' in $s0
#	- `&wormRow[i]' in $s1
#	- `grid[row][col]'
#	- `i' in $t0

# Code:
	# set up stack frame
	sw	$fp, -4($sp)
	sw	$ra, -8($sp)
	sw	$s0, -12($sp)
	sw	$s1, -16($sp)
	sw	$s2, -20($sp)
	sw	$s3, -24($sp)
	la	$fp, -4($sp)
	addiu	$sp, $sp, -24

### TODO: your code goes here
    li  $t0, 1                      #i = 1
    la  $s0, wormCol                #s0 = &wormCol[0]
    la  $s1, wormRow                #s1 = &wormRow[0]
    li  $s2, 20                     #s2 = NROWS
    li  $s3, 40                     #s3 = NCOLS
    lw  $t1, ($s0)                  #t1 = *wormCol[0] = col
    lw  $t2, ($s1)                  #t2 = *wormRow[0] = row
    mul $t3, $t2, $s3               #t3 = offbyte
    add $t3, $t3, $t1
    la  $t4, grid                   #t4 = &grid[0][0]
    add $t5, $t4, $t3               #t5 = &grid[row][col]
    lb  $t6, at                     #t6 = '@'
    sb  $t6, ($t5)                  #grid[row][col] = '@'
loopAdd:
    beq $t0, $a0, end_loopAdd
    add $s0, $s0, 4                 #s0 = &wormCol[0+i]
    add $s1, $s1, 4                 #s1 = &wormRow[0+i]
    lw  $t1, ($s0)                  #t1 =*wormCol[i] = col
    lw  $t2, ($s1)                  #t2 =*wormRow[i] = row
    mul $t3, $t2, $s3               #t3 = offbyte
    add $t3, $t3, $t1
    add $t5, $t4, $t3               #t5 = &grid[row][col]
    lb  $t6, body                   #t6 = 'o'
    sb  $t6, ($t5)                  #grid[row][col] = 'o'
    addi $t0, $t0, 1                #i++
    j   loopAdd
end_loopAdd:
	# tear down stack frame
	lw	$s3, -20($fp)
	lw	$s2, -16($fp)
	lw	$s1, -12($fp)
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	jr	$ra

####################################
# giveUp(msg) ... print error message and exit
# .TEXT <giveUp>
	.text
giveUp:

# Frame:	frameless; divergent
# Uses: 	$a0, $a1
# Clobbers:	$s0, $s1

# Locals:
#	- `progName' in $a0/$s0
#	- `errmsg' in $a1/$s1

# Code:
	add	$s0, $0, $a0
	add	$s1, $0, $a1

	# if (errmsg != NULL) printf("%s\n",errmsg);
	beq	$s1, $0, giveUp_usage

	# puts $a0
	add	$a0, $0, $s1
	addiu	$v0, $0, 4	# print_string
	syscall

	# putchar '\n'
	add	$a0, $0, 0x0a
	addiu	$v0, $0, 11	# print_char
	syscall

giveUp_usage:
	# printf("Usage: %s #Segments #Moves Seed\n", progName);
	la	$a0, giveUp__0
	addiu	$v0, $0, 4	# print_string
	syscall

	add	$a0, $0, $s0
	addiu	$v0, $0, 4	# print_string
	syscall

	la	$a0, giveUp__1
	addiu	$v0, $0, 4	# print_string
	syscall

	# exit(EXIT_FAILURE);
	addi	$a0, $0, 1 # EXIT_FAILURE
	addiu	$v0, $0, 17	# exit2
	syscall
	# doesn't return

####################################
# intValue(str) ... convert string of digits to int value
# .TEXT <intValue>
	.text
intValue:

# Frame:	$fp, $ra
# Uses: 	$t0, $t1, $t2, $t3, $t4, $t5
# Clobbers:	$t0, $t1, $t2, $t3, $t4, $t5

# Locals:
#	- `s' in $t0
#	- `*s' in $t1
#	- `val' in $v0
#	- various temporaries in $t2

# Code:
	# set up stack frame
	sw	$fp, -4($sp)
	sw	$ra, -8($sp)
	la	$fp, -4($sp)
	addiu	$sp, $sp, -8

	# int val = 0;
	add	$v0, $0, $0

	# register various useful values
	addi	$t2, $0, 0x20 # ' '
	addi	$t3, $0, 0x30 # '0'
	addi	$t4, $0, 0x39 # '9'
	addi	$t5, $0, 10

	# for (char *s = str; *s != '\0'; s++) {
intValue_s_init:
	# char *s = str;
	add	$t0, $0, $a0
intValue_s_cond:
	# *s != '\0'
	lb	$t1, ($t0)
	beq	$t1, $0, intValue_s_end

	# if (*s == ' ') continue; # ignore spaces
	beq	$t1, $t2, intValue_s_step

	# if (*s < '0' || *s > '9') return -1;
	blt	$t1, $t3, intValue_isndigit
	bgt	$t1, $t4, intValue_isndigit

	# val = val * 10
	mult	$v0, $t5
	mflo	$v0

	# val = val + (*s - '0');
	sub	$t1, $t1, $t3
	add	$v0, $v0, $t1

intValue_s_step:
	# s = s + 1
	addi	$t0, $t0, 1	# sizeof(byte)
	j	intValue_s_cond
intValue_s_end:

intValue__post:
	# tear down stack frame
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	jr	$ra

intValue_isndigit:
	# return -1
	addi	$v0, $0, -1
	j	intValue__post

####################################
# delay(N) ... waste some time; larger N wastes more time
#                            makes the animation believable
# .TEXT <delay>
	.text
delay:

# Frame:	$fp, $ra
# Uses: 	$a0
# Clobbers:	$t0, $t1, $t2

# Locals:
#	- `n' in $a0
#	- `x' in $f6
#	- `i' in $t0
#	- `j' in $t1
#	- `k' in $t2

# Code:
	# set up stack frame
	sw	$fp, -4($sp)
	sw	$ra, -8($sp)
	la	$fp, -4($sp)
	addiu	$sp, $sp, -8

### TODO: your code goes here
    li  $t0, 0                          # i = 0
    li  $t1, 0                          # j = 0
    li  $t2, 0                          # k = 0
    li  $t3, 400                        # $t3 = 400
    li  $t4, 100                        # $t4 = 100
    li  $t5, 3                          # $t5 = x = 3
loop_i:
    beq $t0, $a0, end_loop_i
loop_j:
    beq $t1, $t3, end_loop_j
loop_k:
    beq $t2, $t4, end_loop_k
    mul $t5, $t5, 3
    addi $t2, $t2, 1                    #k++
    j   loop_k
end_loop_k:
    li  $t2, 0
    addi $t1, $t1, 1                    #j++
    j   loop_j
end_loop_j:
    li  $t1, 0
    addi $t0, $t0, 1                    #i++
    j   loop_i
end_loop_i:
	# tear down stack frame
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	jr	$ra


####################################
# seedRand(Seed) ... seed the random number generator
# .TEXT <seedRand>
	.text
seedRand:

# Frame:	$fp, $ra
# Uses: 	$a0
# Clobbers:	[none]

# Locals:
#	- `seed' in $a0

# Code:
	# set up stack frame
	sw	$fp, -4($sp)
	sw	$ra, -8($sp)
	la	$fp, -4($sp)
	addiu	$sp, $sp, -8

	# randSeed <- $a0
	sw	$a0, randSeed

seedRand__post:
	# tear down stack frame
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	jr	$ra

####################################
# randValue(n) ... generate random value in range 0..n-1
# .TEXT <randValue>
	.text
randValue:

# Frame:	$fp, $ra
# Uses: 	$a0
# Clobbers:	$t0, $t1

# Locals:	[none]
#	- `n' in $a0

# Structure:
#	rand
#	-> [prologue]
#       no intermediate control structures
#	-> [epilogue]

# Code:
	# set up stack frame
	sw	$fp, -4($sp)
	sw	$ra, -8($sp)
	la	$fp, -4($sp)
	addiu	$sp, $sp, -8

	# $t0 <- randSeed
	lw	$t0, randSeed
	# $t1 <- 1103515245 (magic)
	li	$t1, 0x41c64e6d

	# $t0 <- randSeed * 1103515245
	mult	$t0, $t1
	mflo	$t0

	# $t0 <- $t0 + 12345 (more magic)
	addi	$t0, $t0, 0x3039

	# $t0 <- $t0 & RAND_MAX
	and	$t0, $t0, 0x7fffffff

	# randSeed <- $t0
	sw	$t0, randSeed

	# return (randSeed % n)
	div	$t0, $a0
	mfhi	$v0

rand__post:
	# tear down stack frame
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	jr	$ra

