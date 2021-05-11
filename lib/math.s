.include "./asm/macro.s"
//pow - return power of integer
FUNCTION_DEFINE pow
pow:
        PUSHTEMP
        MOV     X19, X0
        MOV     X20, X1
        DEC     X20
.pow_0:
        MUL     X19, X19, X0
	BVS	powFail	
        DEC     X20
        CMP     X20, #0
        BNE     .pow_0
        MOV     X0, X19
        POPTEMP
        RET
powFail:
	MOV	X8, #1
	MOV	X0, XZR
	POPTEMP
	RET
FUNCTION_END	pow

//mod - return remainder. X0 - dividend, X1, divisor
FUNCTION_DEFINE	mod
mod:
	PUSHTEMP
	MOV	X19, X0
	MOV	X20, X1
	SDIV	X19, X19, X20
	MUL	X19, X19, X20
	SUB	X0, X0, X19
	POPTEMP
	RET
FUNCTION_END	mod

