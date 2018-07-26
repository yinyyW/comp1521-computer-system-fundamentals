# COMP1521 Lab 04 ... Simple MIPS assembler


### Global data

   .data
msg1:
   .asciiz "n: "
msg2:
   .asciiz "n! = "
eol:
   .asciiz "\n"

### main() function

   .data
   .align 2
main_ret_save:
   .word 4

   .text
   .globl main

main:
   sw   $ra, main_ret_save
   la	$a0, msg1   #printf("n:")
   li	$v0, 4
   syscall
   li	$vo, 5      #scanf("%d", &n)
   syscall
   move $a1, $v0    #printf("!n = ")
   la   $a0, msg2
   li   $v0, 4
   syscall
   jal  fac         #call fac function
   la   $a0, $v0    #print integer
   li   $v0, 1
   syscall
   la   $a0, eol    #printf("\n")
   li   $v0, 4
   syscall

#  ... your code for main() goes here

   lw   $ra, main_ret_save
   jr   $ra           # return

### fac() function

   .data
   .align 2
fac_ret_save:
   .space 4

   .text
   .globl fac
fac:
   sw   $ra, fac_ret_save
   move $s0, $a1    #save num into s0 register
   li   $t1, 1      #load product in t1 register
   li   $t0, 1      #load index i in t0 register
for:
   bgt  $t0, $s0, end_for
   mult $t1, $t0    #product = product * i
   mflo $t1
   addi $t0, $t0, 1 #i++
   j    for
end_for:
   move $v0, $t1
#  ... your code for fac() goes here

   lw   $ra, fac_ret_save
   jr   $ra            # return ($v0)

