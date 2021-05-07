.include "asm/macro.s"

//makeArray16 - initialize array at location. X0 - location, X1 - length. (ocasionally, we use 16 bit array, so here we go)
	.text
	.p2align 2
	.globl makeArray16
	.type makeArray16, @function
makeArray16:
	PUSHTEMP
	MOV	X19, X0
	MOV	X20, X1
	MOV	W21, #0
cycle:
	STURH	W21, [X19]
	ADD	X19, X19, #2
	DEC	X20
	CMP	X20, #0
	BNE	cycle
	MOV	X0, X19
	POPTEMP
	RET

.makeArray16_end:
	.size makeArray16, .makeArray16_end-makeArray16

//getArr16Element - get element and store it in X0. X0 - location, X1 - index
	.p2align 2
	.globl getArr16Element
	.type getArr16Element, @function
getArr16Element:
	PUSHTEMP
	MOV	X19, X0
	MOV	X20, X1
	MOV	X21, #2
	MUL 	X20, X20, X21
	ADD	X19, X19, X20
	LDURH	W0, [X19]
	POPTEMP
	RET
.getArr16Element_end:
	.size getArr16Element, .getArr16Element_end-getArr16Element

	.p2align 2
	.globl setArr16Element
	.type setArr16Element, @function
setArr16Element:
	PUSHTEMP
	MOV	X19, X0
	MOV	X20, X1
	MOV	X21, #2
	MUL 	X20, X20, X21
	ADD	X19, X19, X20
	STURH 	W2, [X19]
	POPTEMP
	RET
.setArr16Element_end:
	.size setArr16Element, .setArr16Element_end-setArr16Element

	

