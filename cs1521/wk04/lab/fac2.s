# COMP1521 18s2 Week 04 Lab
# Compute factorials, iterative function


### Global data

   .data
msg1:
   .asciiz "n  = "
msg2:
   .asciiz "n! = "
eol:
   .asciiz "\n"

### main() function
   .text
   .globl main
main:
   #  set up stack frame
   sw    $fp, -4($sp)       # push $fp onto stack
   la    $fp, -4($sp)       # set up $fp for this function
   sw    $ra, -4($fp)       # save return address
   sw    $s0, -8($fp)       # save $s0 to use as ... int n;
   addi  $sp, $sp, -12      # reset $sp to last pushed item

   #  code for main()
   li    $s0, 0             # n = 0;
   
   la    $a0, msg1
   li    $v0, 4
   syscall                  # printf("n  = ");

## ... rest of code for main() goes here ...
   li    $v0, 5             #scanf("%d", &n)
   syscall
   move  $a0, $v0           #call fac function
   jal   fac
   la    $a0, msg2          #printf("n! = ")
   li    $v0, 4
   syscall
   move  $a0, $v1           #printf("n")
   li    $v0, 1
   syscall
   la    $a0, eol
   li    $v0, 4
   syscall                  # printf("\n");

   # clean up stack frame
   lw    $s0, -8($fp)       # restore $s0 value
   lw    $ra, -4($fp)       # restore $ra for return
   la    $sp, 4($fp)        # restore $sp (remove stack frame)
   lw    $fp, ($fp)          # restore $fp (remove stack frame)

   li    $v0, 0
   jr    $ra                # return 0

# fac() function

fac:
   # setup stack frame

## ... code for prologue goes here ...
   sw	 $fp, -4($sp)       #push $fp in this stack
   la    $fp, -4($sp)       #set up $fp in this function
   sw    $ra, -4($fp)       #save return address
   sw    $a0, -8($fp)      #save argument
   sw    $t0, -12($fp)      
   sw    $t1, -16($fp)      #save local variables
   addi  $sp, $sp, -20
   # code for fac()

## ... code for fac() goes here ...
   li    $t0, 1             # i = 1
   li    $t1, 1             # product = 1
for:
   bgt   $t0, $a0, end_for
   mul  $t1, $t0, $t1
   addi  $t0, $t0, 1
   j     for
end_for:
   move  $v1, $t1
   # clean up stack frame
   lw    $t1, -16($fp)      #restore $t1
   lw    $t0, -12($fp)      #restore $t0
   lw    $a0, -8($fp)       #restore $a0
   lw    $ra, -4($fp)       #restore $ra
   la    $sp, 4($fp)        #remove stack frame
   lw    $fp, 0($fp)        #remove stack frame
   jr    $ra
## ... code for epilogue goes here ...
