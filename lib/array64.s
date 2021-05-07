.include "asm/macro.s"

//makeArray16 - initialize array at location. X0 - location, X1 - length. (ocasionally, we use 16 bit array, so here we go)
	.text
	.p2align 2
	.globl makeArray64
	.type makeArray64, @function
makeArray64:
	PUSHTEMP
	MOV	X19, X0
	MOV	X20, X1
	MOV	W21, #0
cycle:
	STURH	W21, [X19]
	ADD	X19, X19, #8
	DEC	X20
	CMP	X20, #0
	BNE	cycle
	MOV	X0, X19
	POPTEMP
	RET

.makeArray64_end:
	.size makeArray64, .makeArray64_end-makeArray64

//getArr64Element - get element and store it in X0. X0 - location, X1 - index
	.p2align 2
	.globl getArr64Element
	.type getArr64Element, @function
getArr64Element:
	PUSHTEMP
	MOV	X19, X0
	MOV	X20, X1
	MOV	X21, #8
	MUL 	X20, X20, X21
	ADD	X19, X19, X20
	LDR	X0, [X19]
	POPTEMP
	RET
.getArr64Element_end:
	.size getArr64Element, .getArr64Element_end-getArr64Element

	.p2align 2
	.globl setArr64Element
	.type setArr64Element, @function
setArr64Element:
	PUSHTEMP
	MOV	X19, X0
	MOV	X20, X1
	MOV	X21, #8
	MUL 	X20, X20, X21
	ADD	X19, X19, X20
	STR 	X2, [X19]
	POPTEMP
	RET
.setArr64Element_end:
	.size setArr64Element, .setArr64Element_end-setArr64Element

	

