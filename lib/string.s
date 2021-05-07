#include "string.h"
.include "asm/macro.s"

	.text
	.globl itos
	.p2align 2
	.type itos, @function
//itos - convert integer to char*
itos:	
	PUSHTEMP
	MOV	X22, X1
	MOV	X19, #10
.itos_0:
	UDIV	X20, X0, X19 
	MUL	X21, X20, X19
	SUB	X21, X0, X21
	ADD	X21, X21, #0x30 //X21 = X0%10 + 0X30
	STRB	W21, [X22]
	MOV	X0, X20 //X0 = X0/10
	CMP	X0, #0	//CHECK IF X0 == 0
	ADD	X22, X22, #1
	BNE	.itos_0
	EOR	X19, X19, X19
	STRB	W19, [X22]
	MOV 	X0, X1
	BL	revstr
	POPTEMP
	RET
.Lfunc_end0:
	.size itos, .Lfunc_end0-itos

//strlen - calculare string length
	.globl strlen
	.p2align 2
	.type strlen, @function
strlen:
	PUSHTEMP
	MOV	X19, X0		//Copy original pointer and work with copy
.strlen_0:
	LDRB	W20, [X19] 	//Get current byte
	CMP 	W20, #0		//Check if it is zero
	BEQ	.strlen_1	//If yes, this is string end
	ADD	X19, X19, #1	//Otherwise, increment copy pointer
	B	.strlen_0	//And recheck
.strlen_1:
	SUB	X19, X19, X0	//Substact original from copy to get real string length
	MOV	X0, X19		//Move it to return register
	POPTEMP
	RET
.Lfunc_end1:
	.size strlen, .Lfunc_end1-strlen
//swapb - swap two bytes. Takes two pointers

	.globl swapb
	.p2align 2
	.type swapb, @function

swapb:
	PUSHTEMP
	LDRB	W19, [X0]	//Take first byte
	LDRB	W20, [X1]	//Take second byte
	STRB	W20, [X0]	//Save second byte in first ptr
	STRB	W19, [X1]	//Save first byte in second ptr
	POPTEMP
	RET
.Lfunc_end2:
	.size swapb, .Lfunc_end2-swapb

	
//revstr - reverse string
	.globl revstr
	.p2align 2
	.type revstr, @function

revstr:
	PUSHTEMP
	MOV	X19, X0		//Save original pointer
	BL 	strlen
	MOV	X21, X0		//Save string length
	MOV	X20, X19	//Copy original pointer to new register
	ADD	X20, X20, X21	//Shift it to '\0' right after the end of string
	DEC	X20		//And move it to the end
	ASR	X21, X21, #1	//Divide string length by 2
	MOV	X22, X19
	CMP	X21, #0
	BEQ	.revstr_1
.revstr_0:
	MOV	X0, X19
	MOV	X1, X20
	BL	swapb
	DEC	X21
	CMP	X21, #0
	BEQ	.revstr_1
	INC	X19
	DEC	X20
	B	.revstr_0
.revstr_1:
	MOV	X0, X22
	POPTEMP
	RET

.Lfunc_end3:
	.size revstr, .Lfunc_end3-revstr

//stoi - takes X0 as ptr to string and returns integer (yeah it overflows, but who doesn't?)
//returns zero if incorrect symbol found

	.p2align 2
	.globl stoi
	.type stoi, @function
stoi:
	PUSHTEMP
	MOV	X19, X0
	BL	strlen
	MOV	X20, X0
	MOV	X0, #0
	MOV 	X23, #1
	MOV	X24, #10
	ADD	X19, X19, X20
stoi_loop:
	DEC 	X20
	DEC	X19
	LDRB	W22, [X19]
	CMP	W22, #0xA
	BEQ	stoi_final
	SUB	X22, X22, #0x30
	CMP	X22, #10
	BGE	stoi_fail
	MUL	X22, X22, X23
	ADD 	X0, X0, X22
	MUL	X23, X23, X24
stoi_final:
	CMP 	X20, #0
	BNE 	stoi_loop
	B 	stoi_ret
stoi_fail:
	MOV	X0, #0
stoi_ret:
	POPTEMP
	RET
.stoi_end:
	.size stoi, .stoi_end-stoi
