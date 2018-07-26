# COMP1521 Practice Prac Exam #1
# strings

   .data

s1:
   .asciiz "@%&*@%"
s2:
   .space  50  
   .align  2
# COMP1521 Practice Prac Exam #1
# main program + show function

   .data
m1:
   .asciiz "s1 = "
m2:
   .asciiz "s2 = "
m3:
   .asciiz "nv = "
   .align  2

   .text
   .globl main
main:
   addi $sp, $sp, -4
   sw   $fp, ($sp)
   la   $fp, ($sp)
   addi $sp, $sp, -4
   sw   $ra, ($sp)

   la   $a0, m1
   la   $a1, s1
   jal  showString   # printf("s1 = %s\n",s1)

   la   $a0, s1
   la   $a1, s2
   jal  novowels     # nv = novowels(s1, s2)
   move $s1, $v0

   la   $a0, m1
   la   $a1, s1
   jal  showString   # printf("s1 = %s\n",s1)
   la   $a0, m2
   la   $a1, s2
   jal  showString   # printf("s1 = %s\n",s1)
   la   $a0, m3
   move $a1, $s1
   jal  showInt      # printf("vn = %d\n", n)

   lw   $ra, ($sp)
   addi $sp, $sp, 4
   lw   $fp, ($sp)
   addi $sp, $sp, 4
   j    $ra

# params: msg=$a0, str=$a1
# locals: msg=$s0, str=$s1
showString:
   addi $sp, $sp, -4
   sw   $fp, ($sp)
   la   $fp, ($sp)
   addi $sp, $sp, -4
   sw   $ra, ($sp)
   addi $sp, $sp, -4
   sw   $s0, ($sp)
   addi $sp, $sp, -4
   sw   $s1, ($sp)

   move $s0, $a0
   move $s1, $a1

   move $a0, $s0
   li   $v0, 4
   syscall           # printf("%s",msg)
   move $a0, $s1
   li   $v0, 4
   syscall           # printf("%s",str)
   li   $a0, '\n'
   li   $v0, 11
   syscall           # printf("\n")

   lw   $s1, ($sp)
   addi $sp, $sp, 4
   lw   $s0, ($sp)
   addi $sp, $sp, 4
   lw   $ra, ($sp)
   addi $sp, $sp, 4
   lw   $fp, ($sp)
   addi $sp, $sp, 4
   j    $ra

# params: msg=$a0, val=$a1
# locals: msg=$s0, val=$s1
showInt:
   addi $sp, $sp, -4
   sw   $fp, ($sp)
   la   $fp, ($sp)
   addi $sp, $sp, -4
   sw   $ra, ($sp)
   addi $sp, $sp, -4
   sw   $s0, ($sp)
   addi $sp, $sp, -4
   sw   $s1, ($sp)

   move $s0, $a0
   move $s1, $a1

   move $a0, $s0
   li   $v0, 4
   syscall           # printf("%s",msg)
   move $a0, $s1
   li   $v0, 1
   syscall           # printf("%d",val)
   li   $a0, '\n'
   li   $v0, 11
   syscall           # printf("\n")

   lw   $s1, ($sp)
   addi $sp, $sp, 4
   lw   $s0, ($sp)
   addi $sp, $sp, 4
   lw   $ra, ($sp)
   addi $sp, $sp, 4
   lw   $fp, ($sp)
   addi $sp, $sp, 4
   j    $ra
# COMP1521 Practice Prac Exam #1
# int novowels(char *src, char *dest)

   .text
   .globl novowels

# params: src=$a0, dest=$a1
novowels:
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
   # if you need to save more $s? registers
   # add the code to save them here

# function body
# locals: ...
# locals: src=$s0, dest=$s1, i=$s2, j=$s3, n=$s4, ch=$s5

   # add code for your novwels function here
   move $s0, $a0
   move $s1, $a1
   li   $s2, 0
   li   $s3, 0
   li   $s4, 0
loop:
   add  $t0, $s0, $s2
   lb   $s5, ($t0)
   beq  $s5, $0, end_loop   
   move $a0, $s5
   jal  isvowel
   beq  $v0, $0, not_vowel
   addi $s4, $s4, 1         #n++
   addi $s2, $s2, 1         #i++
   j    loop
not_vowel:
   add  $t1, $s1, $s3   # t1 = &dest[j]
   sb   $s5, ($t1)      # dest[j] = ch
   addi $s3, $s3, 1     # j++
   addi $s2, $s2, 1     # i++
   j    loop            # jump to start
end_loop:
   add  $t2, $s1, $s3   # t2 = &dest[j]
   sb   $0, ($t2)       # dest[j] = '\0'
   move $v0, $s4

# epilogue
   # if you saved more than two $s? registers
   # add the code to restore them here
   lw   $s1, ($sp)
   addi $sp, $sp, 4
   lw   $s0, ($sp)
   addi $sp, $sp, 4
   lw   $ra, ($sp)
   addi $sp, $sp, 4
   lw   $fp, ($sp)
   addi $sp, $sp, 4
   j    $ra

#####

# auxiliary function
# int isvowel(char ch)
isvowel:
# prologue
   addi $sp, $sp, -4
   sw   $fp, ($sp)
   la   $fp, ($sp)
   addi $sp, $sp, -4
   sw   $ra, ($sp)

# function body
   li   $t0, 'a'
   beq  $a0, $t0, match
   li   $t0, 'A'
   beq  $a0, $t0, match
   li   $t0, 'e'
   beq  $a0, $t0, match
   li   $t0, 'E'
   beq  $a0, $t0, match
   li   $t0, 'i'
   beq  $a0, $t0, match
   li   $t0, 'I'
   beq  $a0, $t0, match
   li   $t0, 'o'
   beq  $a0, $t0, match
   li   $t0, 'O'
   beq  $a0, $t0, match
   li   $t0, 'u'
   beq  $a0, $t0, match
   li   $t0, 'U'
   beq  $a0, $t0, match

   li   $v0, 0
   j    end_isvowel
match:
   li   $v0, 1
end_isvowel:

# epilogue
   lw   $ra, ($sp)
   addi $sp, $sp, 4
   lw   $fp, ($sp)
   addi $sp, $sp, 4
   j    $ra
