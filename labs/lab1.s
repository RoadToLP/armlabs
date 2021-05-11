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
	MOV	W24, W19
	MUL	W24, W24, W21
	BVS	overflow
	UDIV	W24, W24, W20
	MOV	W25, W22
	MUL	W25, W25, W20
	BVS	overflow
	UDIV	W25, W25, W23
	BVS	overflow
	MOV	W0, W21
	MOV	X1, #2
	BL	pow
	CMP	X8, 1
	BEQ	overflow
	MOV	W26, W0
	MOV	W27, W19
	MUL	W27, W27, W22
	BVS	overflow
	SDIV	W26, W26, W27
	BVS	overflow
	MOV	W0, W24
	ADD	W0, W0, W25
	BVS	overflow
	SUB	W0, W0, W26
	BVS	overflow
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
