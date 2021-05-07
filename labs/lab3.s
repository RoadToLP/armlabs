.include "../lib/asm/macro.s"
	.text
	.p2align 2
	.globl _start
	.type _start, @function

_start:
	ADRP	X1, countme
	ADD	X1, X1, :lo12:countme
	PUSH	X1
	MOV	X0, XZR
	MOV	X2, 256
	BL	read
	POP	X0
	MOV	X1, ' '
	ADRP	X2, splitted
	ADD	X2, X2, :lo12:splitted
	BL	strsplit
	MOV	X0, XZR
	BL	exit





._start_end:
	.size _start, ._start_end-_start

	.type splitted, @object
	.comm splitted, 0x1000, 1



	.type countme, @object
	.comm countme, 256, 1
