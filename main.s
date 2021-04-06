#include "lib/lib.h"
	.text
	.globl	_start
	.p2align 2
	.type main,@function
_start:
	SUB	SP, SP, #8
	MOV 	X0, #0xbeef
	MOVK	X0, #0xdead, lsl #16
	MOV 	X1, SP
	BL	itos
	BL	print
	MOV	X0, #0
	BL	exit
.Lfunc_end0:
	.size _start, .Lfunc_end0-_start
