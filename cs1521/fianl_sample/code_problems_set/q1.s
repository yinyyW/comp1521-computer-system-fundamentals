# COMP1521 Final Exam
# void colSum(matrix, N, array)

   .text
   .globl colSum

# params: matrix=$a0, N=$a1, array=$a2
colSum:
# prologue
   addi $sp, $sp, -4
   sw   $fp, ($sp)
   la   $fp, ($sp)
   addi $sp, $sp, -4
   sw   $ra, ($sp)
   addi $sp, $sp, -4
   sw   $s0, ($sp)
   addi $sp, $sp, -4
   sw   $s1, ($sp)
   addi $sp, $sp, -4
   sw   $s2, ($sp)
   addi $sp, $sp, -4
   sw   $s3, ($sp)
   addi $sp, $sp, -4
   sw   $s4, ($sp)
   addi $sp, $sp, -4
   sw   $s5, ($sp)
   # if you need to save more than six $s? registers
   # add extra code here to save them on the stack

# locals: m=#s0, N=$s1, a=$s2, row=$s3, col=$s4, sum=$s5
    li  $s4, 0  #col =0
    move $s1, $a1   # s1 = N
    move $s0, $a0
    move $s2, $a2
loop:
    beq $s4, $s1, end_loop
    li  $s5, 0  #sum = 0
    li  $s3, 0  #row = 0
loop2:
    beq $s3, $s1, end_loop2
    mul $t0, $s1, $s3   # t0 = [row][0]
    add $t0, $t0, $s4   # [row][col]
    li  $t1, 4          #sizeof(int)
    mul $t0, $t0, $t1
    add $t0, $s0, $t0   # &m[row][col]
    lw  $t0, ($t0)      # m[row][col]
    add $s5, $s5, $t0   # sum = sum + m[row][col]
    addi $s3, $s3, 1    #row++
    j   loop2
end_loop2:
    mul $t2, $t1, $s4   #t2 = offset col by a[]
    add $t2, $t2, $s2    # t2 = &a[col]
    sw  $s5, ($t2)      # a[col] = sum
    addi $s3, $s3, 1    # col++
    j   loop
end_loop:
    
    
    


# epilogue
   # if you saved more than six $s? registers
   # add extra code here to restore them
   lw   $s5, ($sp)
   addi $sp, $sp, 4
   lw   $s4, ($sp)
   addi $sp, $sp, 4
   lw   $s3, ($sp)
   addi $sp, $sp, 4
   lw   $s2, ($sp)
   addi $sp, $sp, 4
   lw   $s1, ($sp)
   addi $sp, $sp, 4
   lw   $s0, ($sp)
   addi $sp, $sp, 4
   lw   $ra, ($sp)
   addi $sp, $sp, 4
   lw   $fp, ($sp)
   addi $sp, $sp, 4
   j    $ra

