#include <array.h>
.include "asm/macro.s"

//makeArray - initialize array at location. X0 - location, X1 - length. (ocasionally, we use 16 bit array, so here we go)
	.text
	.p2align 2
	.globl makeArray
	.type makeArray, @function
makeArray:
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

.makeArray_end:
	.size makeArray, .makeArray_end-makeArray

//getArrElement - get element and store it in X0. X0 - location, X1 - index
	.p2align 2
	.globl getArrElement
	.type getArrElement, @function
getArrElement:
	PUSHTEMP
	MOV	X19, X0
	MOV	X20, X1
	MOV	X21, #2
	MUL 	X20, X20, X21
	ADD	X19, X19, X20
	LDURH	W0, [X19]
	POPTEMP
	RET
.getArrElement_end:
	.size getArrElement, .getArrElement_end-getArrElement

	.p2align 2
	.globl setArrElement
	.type setArrElement, @function
setArrElement:
	PUSHTEMP
	MOV	X19, X0
	MOV	X20, X1
	MOV	X21, #2
	MUL 	X20, X20, X21
	ADD	X19, X19, X20
	STURH 	W2, [X19]
	POPTEMP
	RET
.setArrElement_end:
	.size setArrElement, .setArrElement_end-setArrElement

	

