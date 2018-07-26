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
