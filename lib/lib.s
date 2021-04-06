#include "lib.h"

.macro	PUSH, REG
	MOV 	X29, SP
	STR	\REG, [X29, #-8]!
	MOV	SP, X29
.endmacro

.macro	POP, REG
	MOV	X29, SP
	LDR	\REG, [X29], #8
	MOV	SP, X29
.endmacro

.macro	PUSHTEMP
	PUSH	X19
	PUSH	X20
	PUSH	X21
	PUSH	X22
	PUSH	X23
	PUSH	X24
	PUSH	X25
	PUSH	X26
	PUSH	X27
	PUSH	X28
	PUSH	X30
.endmacro

.macro	POPTEMP
	POP	X30
	POP	X28
	POP	X27
	POP	X26
	POP	X25
	POP	X24
	POP	X23
	POP	X22
	POP	X21
	POP	X20
	POP	X19
.endmacro


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
	SDIV	X20, X0, X19 
	MUL	X21, X20, X19
	SUBS	X21, X0, X21
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
	.text
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
	SUB	X20, X20, #1	//And move it to the end
	ASR	X21, X21, 1	//Divide string length by 2
	MOV	X22, X19
.revstr_0:
	MOV	X0, X19
	MOV	X1, X20
	BL	swapb
	SUB	X21, X21, 1
	CMP	X21, #0
	BEQ	.revstr_1
	ADD	X19, X19, #1
	SUB	X20, X20, #1
	B	.revstr_0
.revstr_1:
	MOV	X0, X22
	POPTEMP
	RET

.Lfunc_end3:
	.size revstr, .Lfunc_end3-revstr

//print - print a string to it's '\0'
	.globl print
	.p2align 2
	.type print, @function
print:
	PUSHTEMP
	MOV	X19, X0
	BL	strlen
	MOV 	X2, X0
	MOV	X1, X19
	MOV	X0, #1
	MOV	X8, #0x40
	SVC	#0
	POPTEMP
	RET
.Lfunc_end4:
	.size print, .Lfunc_end4-print


//exit - exit
	.globl exit
	.p2align 2
	.type exit, @function
exit:
	MOV	X8, #0x5d
	SVC	#0
	RET
.Lfunc_end5:
	.size exit, .Lfunc_end5-exit

