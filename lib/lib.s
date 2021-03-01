	.text
	.globl itos
	.p2align 2
	.type itos, @function
//stob - convert char* to integer
itos:
	MOV	X22, X1
	MOV	X19, #10
.itos_0:
	SDIV	X20, X0, X19
	MUL	X21, X20, X19
	SUBS	X21, X0, X21
	ADD	X21, X21, #0x31 //X21 = X0%10 + 0X31
	STRB	W21, [X22]
	MOV	X0, X20 //X0 = X0/10
	CMP	X0, #0	//CHECK IF X0 == 0
	ADD	X22, X22, #1
	BNE	.itos_0
	EOR	X19, X19, X19
	STRB	W19, [X22]
	MOV 	X0, X1
//	BL	.reverse
	RET
.Lfunc_end0:
	.size itos, .Lfunc_end0-itos

	.globl print
	.p2align 2
	.type print, @function
print:
	MOV	X19, X0
.print_0:
	LDRB	W20, [X19]
	CMP 	W20, #0
	BEQ	.print_1
	ADD	X19, X19, #1
	B	.print_0
.print_1:
	MOV	X1, X0
	MOV	X0, #1
	MOV	X2, X19
	MOV	X8, #0x40
	SVC	#0
	RET
.Lfunc_end1:
	.size print, .Lfunc_end1-print

