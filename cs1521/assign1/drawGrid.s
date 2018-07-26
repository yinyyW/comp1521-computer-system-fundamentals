        .data
dot:    .byte '.'
	.align 4
grid:		.space	20 * 40 * 1



    .text   
main:   
    li  $s0, 20
    li  $s1, 40
    la  $t1, grid   # $t1 = &grid[0][0]
    lb  $t2, dot
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
    jr   $ra
