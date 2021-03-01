#include "lib/lib.s"
	.text
	.globl	main
	.p2align 2
	.type main,@function
main:
	MOV X0, #1234
	LDR X1, =s
	BL	itos
	BL	print
	RET
.Lfunc_end0:
	.size main, .Lfunc_end0-main
	.type s, @object
	.comm s, 8, 1

