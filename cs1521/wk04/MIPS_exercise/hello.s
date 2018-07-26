# COMP1521 Lab 04 ... Example MIPS program
#
# Implements something like the C code:
#
# char name[100];
#
# void say_hello(char *nm) {
#    printf("Hello, ");
#    printf("%s",nm);
#    printf("\n");
# }
#
# int main(void) {
#    printf("Your name: ");
#    fgets(name, 100, stdin);
#    say_hello(name);
#    return 0;
# }

   .data
msg1:
   .asciiz "Your name: "
name:
   .space 100         # char name[100];

   .data
   .align 2
main_ret_save:        # place to save $ra
   .word 4            # in case we make a function call

   .text
   .globl main

main:
   sw   $ra, main_ret_save
   la   $a0, msg1
   li   $v0, 4        # printf("Your name: ");
   syscall
   la   $a0, name
   li   $a1, 100
   li   $v0, 8        # fgets(buf, 100, stdin)
   syscall
                      # syscall leaves name in arg register
   jal  say_hello     # say_hello(name)
   lw   $ra, main_ret_save
   jr   $ra           # return

   .data
msg2:
   .asciiz "Hello, "
eol:
   .asciiz "\n"

   .data
   .align 2
hello_ret_save:       # place to save $ra
   .space 4           # in case we make a function call

   .text
   .globl say_hello
say_hello:
   sw   $ra, hello_ret_save
   move $s0, $a0      # s0 = nm
   la   $a0, msg2
   li   $v0, 4        # printf("Hello, ");
   syscall
   move $a0, $s0
   li   $v0, 4        # printf("%s", nm);
   syscall
   la   $a0, eol
   li   $v0, 4        # printf("\n");
   syscall
   lw   $ra, hello_ret_save
   jr   $ra            # return

