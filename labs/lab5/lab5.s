.include "macro.s"

FUNCTION_DEFINE resizeImage
resizeImage:
	PUSHTEMP
	MOV	X19, X0
	MOV	X20, X1
	FMOV	D19, D0
	FMOV	D20, D1
	MOV	X21, X4
	MOV	X22, X5		//Save inputs
	PUSH	X2
	PUSH	X3
	MOV	X27, XZR	//Declare counters
	MOV	X28, XZR
resizeImage_loopx:
	UCVTF	D21, X27	
	FMUL	D21, D21, D19
	FMOV	D0, D21
	PUSHTEMP
	BL	floor
	POPTEMP
	FCVTZU	X0, D0
	MOV	X23, X0		//Calculate x_old = floor(x_new*x_ratio)
resizeImage_loopy:
	UCVTF	D21, X28
	FMUL	D21, D21, D20
	FMOV	D0, D21
	PUSHTEMP
	BL	floor
	POPTEMP
	FCVTZU	X0, D0
	MOV	X24, X0		//Calculate y_old = floor(y_new*y_ratio)
	//X25 will contain new pixel address
	MOV	X25, X23	//Move X to X25
	//Copy new width
	//////////////////////////////
	POP	X5
	POP	X4
	MUL	X24, X24, X4	//Multiply Y with old width
	PUSH	X4
	PUSH	X5
	ADD	X25, X25, X24	//Move Y*width to X25. X25 = (Y*oldWidth)+X
	MOV	X0, #3
	MUL	X25, X25, X0	//Multiply X25 with 3
	ADD	X25, X25, X20
	//Now X25 contains old pixel address
	MOV	X26, XZR	
	MUL	X26, X28, X21	//X26 will be equal y_new*newwidth
	ADD	X26, X26, X27	//X26 = (y_new*newwidth)+x_new
	MUL	X26, X26, X0	//X26 = ((y_new*newwidth)+x_new) * 3
	ADD	X26, X26, X19
	//X26 contains new pixel  address
	//Now we should copy RGB
	ADD	X25, X25, #2
	LDRB	W0, [X25]
	STRB	W0, [X26]
	INC	X26
	DEC	X25
	LDRB	W0, [X25]
	STRB	W0, [X26]
	INC	X26
	DEC	X25
	LDRB	W0, [X25]
	STRB	W0, [X26]
	//RGB copied
	INC	X28
	CMP	X28, X22 	//Until X28 != Height
	BNE	resizeImage_loopy
	//We are out of loopy
	MOV	X28, #0		//Reset y counter
	INC	X27
	CMP	X27, X21	//Until X27 != width
	BNE	resizeImage_loopx
	//Out of cycle, ret
	POP	X5
	POP	X4
	POPTEMP
	RET
FUNCTION_END resizeImage

