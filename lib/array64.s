.include "asm/macro.s"

//makeArray16 - initialize array at location. X0 - location, X1 - length. (ocasionally, we use 16 bit array, so here we go)
	.text
FUNCTION_DEFINE makeArray64
makeArray64:
	PUSHTEMP
	CMP	X1, #0
	BEQ	makeArray64_ret
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
makeArray64_ret:
	POPTEMP
	RET

FUNCTION_END	makeArray64

//getArr64Element - get element and store it in X0. X0 - location, X1 - index
FUNCTION_DEFINE	getArr64Element
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
FUNCTION_END	getArr64Element


FUNCTION_DEFINE	setArr64Element
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
FUNCTION_END	setArr64Element
	

