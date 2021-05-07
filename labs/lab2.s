#include <string.h>
.include "../lib/asm/macro.s"

	.text
	.globl _start
	.p2align 2
	.type _start, @function
_start:
	ADRP 	X0, matrix
	ADD	X0, X0, :lo12:matrix
	MOV	X1, #12
	MOV	X2, #16 //why not
	BL 	genMatrix
	MOV	X19, #0
	MOV	X20, #0
rowCycle:
	LDR	X21, [X0]
	MOV	X20, #0
	PUSH	X0
	columnCycle:
		BL 	rand
		LSR	X0, X0, #48
		MOV	X2, X0
		MOV 	X0, X21
		MOV	X1, X20
		BL	setArrElement
		INC	X20
		CMP	X20, #16
		BNE 	columnCycle
	POP	X0
	ADD	X0, X0, #8
	INC	X19
	CMP	X19, #12
	BNE	rowCycle
	ADRP 	X0, matrix
	ADD	X0, X0, :lo12:matrix
	MOV	X1, #12
	MOV	X2, #16
	BL	sortMatrix
	MOV	X0, #0
	BL	exit
		
		

.func_end:
	.size _start, .func_end-_start
	
	.type matrix, @object
	.comm matrix, 0x3000, 1
