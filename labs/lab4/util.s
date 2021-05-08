

/* customTan - calculates this function and writes midcalculations in a file
 * X0 - fd of writeable file
 * D0 - function argument
 * D1 - presicion
 * Since output is D0, probably, X0 will be set if error occured. The only way it happens if we got invalid argument. Or overflow happened.
 */
 	.globl customTan
	.p2align 2
	.type customTan, @function
customTan:
	PUSHTEMP
	FMOV	D19, D0
	FMOV	D20, D1
	MOV	X19, X0
	MOV	X28, #1 	//counter
	MOV	X20, #2
	FMOV	D28, XZR
customTan_cycle:	
	MUL	X0, X28, X20
	BL	bernoulliNumber
	FMOV	D21, D0
	FMOV	D0, #-4
	MOV	X0, X28
	BL	pow
	FMUL	D21, D21, D0
	FMOV	D22, #1
	FMOV	D0, #4
	MOV	X0, X28
	BL	pow
	FSUB	D22, D22, D0
	FMUL	D21, D21, D22
	FMOV	D0, X28
	FADD	D0, D0, #1
	BL	tgamma
	FDIV	D21, D21, D0
	MUL	X0, X28, X20
	DEC	X0
	FMOV	D0, D19
	BL	pow
	FMUL	D21, D21, D0 	//D21 holds serie element
	FADD	D28, D28, D21
	MOV	X0, X28
	FMOV	D0, D19
	FMOV	D1, D28
	FMOV	D2, D21
	BL	printf
	FCMP	D21, D20
	BLE	customTan_ret
	INC	X28
	B	customTan_cycle
customTan_ret:
	MOV	D0, D28
	POPTEMP
	RET
.customTan_end:
	.size customTan, .customTan_end-customTan


/* bernoulliNumber - fucking mathematical shit with stupid recursive formula and I FUCKING DON'T KNOW WHAT TO DO WITH MEMORY BECAUSE IT WILL LEAK LIKE CUNT!
 *









fresult:
	.asciz "%d: tan(%lf) = %lf. Serie element - %lf\n"
	.size 41

	.type result, @object
	.comm result, 128, 1
