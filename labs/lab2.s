#include <string.h>
.include "../lib/asm/macro.s"

	.text
	.globl _start
	.p2align 2
	.type _start, @function
_start:
	ADRP	X0, hello
	ADD	X0, X0, :lo12:hello
	BL	puts
	BL	nextInt
	PUSH	X0
	BL	nextInt
	PUSH	X0
	ADRP 	X0, matrix
	ADD	X0, X0, :lo12:matrix
	POP	X2
	POP	X1
	PUSH	X0
	MOV	X22, X1
	MOV	X23, X2
	BL 	genMatrix
	ADRP	X0, enterData
	ADD	X0, X0, :lo12:enterData
	BL	puts
	MOV	X19, #0
	MOV	X20, #0
	POP	X0
rowCycle:
	LDR	X21, [X0]
	MOV	X20, #0
	PUSH	X0
	columnCycle:
		BL	nextInt
		MOV	X1, 0x10000
		BL 	mod
		MOV	X2, X0
		MOV 	X0, X21
		MOV	X1, X20
		BL	setArrElement
		INC	X20
		CMP	X20, X23
		BNE 	columnCycle
	POP	X0
	ADD	X0, X0, #8
	INC	X19
	CMP	X19, X22
	BNE	rowCycle
	ADRP 	X0, matrix
	ADD	X0, X0, :lo12:matrix
	MOV	X1, X22
	MOV	X2, X23
	BL	sortMatrix
	//According to martix architecture we need to iterate through columns
	MOV	X20, XZR
outRow:
	ADRP 	X0, matrix
	ADD	X0, X0, :lo12:matrix
	PUSH	X22
	outColumn:
		PUSH	X0
		LDR	X19, [X0]
		MOV	X0, X19
		MOV	X1, X20
		BL	getArrElement
		BL	printInt
		ADRP 	X0, delim
		ADD	X0, X0, :lo12:delim
		BL	puts
		POP	X0
		ADD	X0, X0, #8
		DEC	X22
		CMP	X22, #0
		BNE	outColumn
	POP	X22
	ADRP 	X0, nline
	ADD	X0, X0, :lo12:nline
	BL	puts
	INC	X20
	CMP	X20, X23
	BNE 	outRow
	MOV	X0, #0
	BL	exit
		
		

.func_end:
	.size _start, .func_end-_start
	
hello:
	.asciz "Enter dimensions of matrix. Width and height line by line\n\0"
	.size  hello, 59

enterData:
	.asciz "Now enter data (shorts) line by line. You are filling matrix column by column, up to down.\n\0"
	.size  enterData, 92

delim:	
	.asciz "  \0" //no shit boi
	.size  delim, 3
nline:
	.asciz "\n\0"
	.size  nline, 2

	.type matrix, @object
	.comm matrix, 0x3000, 1
