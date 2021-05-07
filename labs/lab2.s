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
	MOV	X0, 0
	ADRP	X1, input
	ADD	X1, X1, :lo12:input
	MOV	X2, 32
	BL 	read
	ADRP	X0, input
	ADD	X0, X0, :lo12:input
	BL	stoi
	ADRP	X1, rndm
	ADD	X1, X1, :lo12:rndm
	BL	itos
	BL	print
	EOR	X0, X0, X0
	BL 	exit
.func_end:
	.size _start, .func_end-_start

	.type input, @object
	.comm input, 32, 1
	
	.type rndm, @object
	.comm rndm, 0x32, 1

	.type matrix, @object
	.comm matrix, 0x2000, 1
