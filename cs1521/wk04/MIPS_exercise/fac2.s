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




fac:  
    addi $sp,$sp,-8     #adjust stack for 2 items  
    sw   $ra,4($sp)     #save the return address  
    sw   $a0,0($sp)     #save the argument  
  
    slti $t0,$a0,1      #test for n<1  
    beq  $t0,$zero, L1    #if n>=1,go to L1  

    addi $v1,$zero,1    #return 1  
    addi $sp,$sp,8      #pop 2 items off stack  
    jr   $ra        #return to caller1  
  
L1: addi $a0,$a0,-1     #n>=1;argument gets(n-1)  
    jal  fac       #call fact with(n-1)  
  
    lw  $a0,0($sp)      #return from jal:return restore argument.h  
    lw  $ra,4($sp)      #restore the return address  
    addi $sp,$sp,8      #adjust stack pointer to pop 2 items  
  
    mul $v1,$a0,$v1     #return n * fact(n-1)  
    jr  $ra         #;return to the caller  
