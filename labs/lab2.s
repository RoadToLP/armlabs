#include <string.h>
.include "../lib/asm/macro.s"

	.text
	.globl _start
	.p2align 2
	.type _start, @function
_start:
	ADRP 	X0, matrix
	ADD	X0, X0, :lo12:matrix
	MOV	X1, 3
	MOV	X2, 4
	BL 	genMatrix
	EOR	X0, X0, X0
	BL 	exit
.func_end:
	.size _start, .func_end-_start

	.type matrix, @object
	.comm matrix, 0x2000, 1
