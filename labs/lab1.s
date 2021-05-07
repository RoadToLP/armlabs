#include <lib.h>

/*	Expression
 *	(a*c)/d+(d*b)/e-c^2/(a*d)
 *	a - 16
 *	b - 16
 *	c - 32
 *	d - 16
 *	e - 32
 *	
 */

a:	.short 10
b:	.short 20
c:	.int 40
d:	.short 30
e:	.int 10


	.text
	.globl	_start
	.p2align 2
	.type main,@function
_start:
	SUB	SP, SP, #8
	ADR	X0, a
	LDRH	W19, [X0]
	ADR	X0, b
	LDRH	W20, [X0]
	ADR	X0, c
	LDR	W21, [X0]
	ADR	X0, d
	LDRH	W22, [X0]
	ADR	X0, e
	LDR	W23, [X0]
	MOV	X24, X19
	MUL	X24, X24, X21
	BVS	overflow
	SDIV	X24, X24, X20
	MOV	X25, X22
	MUL	X25, X25, X20
	BVS	overflow
	SDIV	X25, X25, X23
	MOV	X0, X21
	MOV	X1, #2
	BL	pow
	CMP	X8, 1
	BEQ	overflow
	MOV	X26, X0
	MOV	X27, X19
	MUL	X27, X27, X22
	BVS	overflow
	SDIV	X26, X26, X27
	MOV	X0, X24
	ADD	X0, X0, X25
	SUB	X0, X0, X26
	MOV	X1, SP
	BL	itos
	BL	puts
	MOV	X0, #0
	BL	exit

overflow:
	ADRP	X0, strOverflow
	ADD	X0, X0, #:lo12:strOverflow
	BL 	puts
	MOV	X0, #-1
	BL 	exit
	

strOverflow:
	.asciz "Overflow detected! Exiting\n\0"
	.size strOverflow, 28


.Lfunc_end0:
	.size _start, .Lfunc_end0-_start
