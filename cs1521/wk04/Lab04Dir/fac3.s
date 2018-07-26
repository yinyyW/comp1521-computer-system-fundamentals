# COMP1521 18s2 Week 04 Lab
# Compute factorials, recursive function


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
   move  $a0, $v0
   jal   fac                #call fac function
   la    $a0, msg2           #printf("n! = ")
   li    $v0, 4
   syscall
   move  $a0, $v1           #print integer(n!)
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
   # set up stack frame
## ... code for prologue goes here ...
   sw    $fp, -4($sp)       #push $fp into stack
   la    $fp, -4($sp)       #save $fp of this function
   sw    $ra, -4($fp)       #save return address
   sw    $a0, -8($fp)       #save argument
   addi  $sp, $sp, -12     #reset $sp
   # code for fac()

## ... code for fac() goes here ...

   blt   $a0, 1, return_one 
   addi  $a0, $a0, -1
   jal   fac               #call the function recursively fac(n-1) * n
   lw    $a0, -8($fp)       #restore argument
   lw    $ra, -4($fp)       #clean up stack frame
   la    $sp, 4($fp)
   lw    $fp, ($fp)

   mul   $v1, $a0, $v1
   jr    $ra

## ... code for epilogue goes here ...
# if(n == 1)
return_one:
   li    $v1, 1
   lw    $a0, -8($fp)
   lw    $ra, -4($fp)
   la    $sp, 4($fp)
   lw    $fp, ($fp)
   jr    $ra
