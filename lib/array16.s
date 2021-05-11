.include "asm/macro.s"

//makeArray16 - initialize array at location. X0 - location, X1 - length. (ocasionally, we use 16 bit array, so here we go)
	.text
FUNCTION_DEFINE	makeArray16
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
FUNCTION_END	makeArray16

//getArr16Element - get element and store it in X0. X0 - location, X1 - index
FUNCTION_DEFINE	getArr16Element
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
FUNCTION_END	getArr16Element


FUNCTION_DEFINE	setArr16Element
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
FUNCTION_END	setArr16Element

