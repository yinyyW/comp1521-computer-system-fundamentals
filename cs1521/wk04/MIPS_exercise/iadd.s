	.data
x:	.space 4
y:	.space 4
ask1:	.asciiz "First number: "
ask2:	.asciiz "Second number: "
eol:	.asciiz "\n"

	.text
main:
	la  $a0, ask1
	li  $v0, 4
	syscall
	li  $v0, 5
	syscall
	sw  $v0, x

	la  $a0, ask2
	li  $v0, 4
	syscall
	li  $v0, 5
	syscall
	sw  $v0, y

	lw  $t0, x
	lw  $t1, y
	add $a0,$t0, $t1
	li  $v0, 1
	syscall

	la  $a0, eol
	li  $v0, 4
	syscall

	jr  $ra
