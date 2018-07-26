# COMP1521 18s2 Week 05 Lab
#
# Matrix data #8

   .data
N: .word  8
M: .word  4
P: .word  8
A: .word  1, 2, 3, 4
   .word  1, 2, 4, 3
   .word  1, 3, 2, 4
   .word  1, 3, 4, 2
   .word  2, 1, 3, 4
   .word  2, 1, 4, 3
   .word  2, 3, 1, 4
   .word  2, 3, 4, 1
B: .word  1, 2, 3, 4, 4, 3, 2, 1
   .word  2, 3, 4, 1, 1, 4, 3, 2
   .word  3, 4, 1, 2, 2, 1, 4, 3
   .word  4, 1, 2, 3, 3, 2, 1, 4
C: .space 256

# COMP1521 18s1 Week 05 Lab
#
# Main program to drive matrix multiplication
# Assumes that labels N,M,P,A,B,C exist, and
# refer to appropriate objects/values
   .data
labelA:
   .asciiz "A:\n"
labelB:
   .asciiz "\nB:\n"
labelC:
   .asciiz "\nC:\n"

   .text
   .globl main
main:
   # set up stack frame for main()
   sw   $fp, -4($sp)
   la   $fp, -4($sp)
   sw   $ra, -4($fp)
   addi $sp, $sp, -8

   # print matrix A
   la   $a0, labelA
   li   $v0, 4
   syscall
   lw   $a0, N
   lw   $a1, M
   la   $a2, A
   jal  printMatrix

   # print matrix B
   la   $a0, labelB
   li   $v0, 4
   syscall
   lw   $a0, M
   lw   $a1, P
   la   $a2, B
   jal  printMatrix

   # multiply C = A x B
   lw   $a0, N             # matrix dimensions in $a?
   lw   $a1, M
   lw   $a2, P
   addi $sp, $sp, -4       # matrix addresses on stack
   la   $t0, A
   sw   $t0, ($sp)         # push(&A)
   addi $sp, $sp, -4
   la   $t0, B
   sw   $t0, ($sp)         # push(&B)
   addi $sp, $sp, -4
   la   $t0, C
   sw   $t0, ($sp)         # push(&C)
   jal  multMatrices
   nop
   addi $sp, $sp, 12       # clean args off stack

   # print matrix C
   la   $a0, labelC
   li   $v0, 4
   syscall
   lw   $a0, N
   lw   $a1, P
   la   $a2, C
   jal  printMatrix

   # return 0 and clean up stack
   li   $v0, 0
   lw   $ra, -4($fp)
   la   $sp, 4($fp)
   lw   $fp, ($fp)
   jr   $ra

# COMP1521 18s1 Week 05 Lab
#
# void printMatrix(int nrows, int ncols, int m[nrows][ncols])
# {
#    for (int r = 0; r < nrows; r++) {
#       for (int c = 0; c < ncols; c++) {
#          printf(" %3d", m[r][c]);
#       }
#       printf("\n");
#    }
# }

   .text
   .globl printMatrix
printMatrix:
   # register usage:
   # nrows is $s0, ncols is $s1, r is $s2, c is $s3

   # set up stack frame for printMatrix()
   sw   $fp, -4($sp)
   la   $fp, -4($sp)
   sw   $ra, -4($fp)
   sw   $s0, -8($fp)
   sw   $s1, -12($fp)
   sw   $s2, -16($fp)
   sw   $s3, -20($fp)
   addi $sp, $sp, -24

   # set up registers
   move $s0, $a0
   move $s1, $a1
   
   # for r in 0..nrows-1
   li   $s2, 0
print_loop1:
   bge  $s2, $s0, print_end1
   # for c in 0..ncols-1
   li   $s3, 0
print_loop2:
   bge  $s3, $s1, print_end2
   # get m[r][c]
   li   $t1, 4            # sizeof(int)
   mul  $t0, $s2, $s1
   mul  $t0, $t0, $t1     # offset of start of row r
   mul  $t1, $s3, $t1     # offset of col c within row
   add  $t0, $t0, $t1     # offset from start of matrix
   add  $t0, $t0, $a2
   lw   $a0, ($t0)        # a0 = m[r][c]
   li   $v0, 1
   syscall                # printf("%d", a0)
   li   $a0, ' '
   li   $v0, 11
   syscall                # putchar(' ')
   addi $s3, $s3, 1       # c++
   j    print_loop2
print_end2:
   li   $a0, '\n'         # putchar('\n')
   li   $v0, 11
   syscall
   addi $s2, $s2, 1       # r++
   j    print_loop1
print_end1:

   # clean up stack and return
   lw   $ra, -4($fp)
   lw   $s0, -8($fp)
   lw   $s1, -12($fp)
   lw   $s2, -16($fp)
   lw   $s3, -20($fp)
   la   $sp, 4($fp)
   lw   $fp, ($fp)
   jr   $ra

# COMP1521 18s1 Week 05 Lab
#
# void multMatrices(int n, int m, int p,
#                   int A[n][m], int B[m][p], int C[n][p])
# {
#    for (int r = 0; r < n; r++) {
#       for (int c = 0; c < p; c++) {
#          int sum = 0;
#          for (int i = 0; i < m; i++) {
#             sum += A[r][i] * B[i][c];
#          }
#          C[r][c] = sum;
#       }
#    }
# }

   .text
   .globl multMatrices
multMatrices:
   # possible register usage:
   # n is $s0, m is $s1, p is $s2,
   # r is $s3, c is $s4, i is $s5, sum is $s6
    sw	 $fp, -4($sp)
    la	 $fp, -4($sp)
    sw	 $ra, -4($fp)
    sw	 $a0, -8($fp)	    
    sw	 $a1, -12($fp)
    sw	 $a2, -16($fp)
    sw	 $s0, -20($fp)
    sw	 $s1, -24($fp)
    sw	 $s2, -28($fp)
    sw   $s3, -32($fp)
    addi $sp, $sp, -36
   # set up stack frame for multMatrices()

   # implement above C code
    move $s0, $a0   #s0 = n
    move $s1, $a1	#s1 = m
    move $s2, $a2	#s2 = p
    li	 $s3, 4		#s3 = sizeof(int) = 4
    li	 $t0, 0		#r = 0
    li	 $t1, 0		#c = 0
    li	 $t2, 0		#i = 0
loopN:
    beq  $t0, $s0, end_loopN
loopP:
    beq	 $t1, $s2, end_loopP
    li	 $t8, 0		#sum = 0
loopM:
    beq  $t2, $s1, end_loopM
    #load A[r][i]
    lw	 $t3, 44($sp)	#get address of matrix A[0][0]
    mul	 $t4, $s1, $s3	#compute bytes of each row
    mul	 $t5, $t4, $t0	#get r(th) row 
    mul	 $t6, $t2, $s3	#get i(th) offset
    add	 $t6, $t5, $t6	
    add	 $t6, $t6, $t3	#t6 = A[r][i]
    lw   $t6, ($t6)
    #load B[i][c]
    lw	 $t3, 40($sp)	#load matrix B[0][0]
    mul	 $t4, $s2, $s3	#compute bytes of each row
    mul	 $t5, $t4, $t2	#get i(th) row 
    mul	 $t7, $t1, $s3	#get c(th) offset
    add	 $t7, $t5, $t7	
    add	 $t7, $t7, $t3	#t7 = B[i][c]
    lw   $t7, ($t7)
    #mult two num
    mul	 $t3, $t6, $t7	#t3 = A[r][i] * B[i][c]
    add	 $t8, $t8, $t3	#sum = sum + t3
    addi $t2, $t2, 1	#i++
    j	 loopM
end_loopM:
    lw	 $t3, 36($sp)	#load matrix C
    mul	 $t4, $s2, $s3	#compute bytes of each row
    mul	 $t5, $t4, $t0	#get i(th) row 
    mul	 $t6, $t1, $s3	#get c(th) offset
    add	 $t6, $t5, $t6	
    add	 $t6, $t6, $t3	#t7 = B[i][c]
    sw   $t8, 0($t6)
    addi $t1, $t1, 1	#c++
    li   $t2, 0
    j    loopP
end_loopP:
    addi $t0, $t0, 1	#r++
    li   $t1, 0
    j    loopN
end_loopN:
    lw   $s3, -32($fp)
    lw	 $s2, -28($fp)
    lw	 $s1, -24($fp)
    lw	 $s0, -20($fp)
    lw	 $a2, -16($fp)
    lw	 $a1, -12($fp)
    lw	 $a0, -8($fp)
    lw	 $ra, -4($fp)
    la   $sp, 4($fp)
    lw   $fp, 0($fp)
    jr   $ra
   # clean up stack and return
