.include "macro.s"

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
	SCVTF	D27, X28
	FMOV	D28, XZR
customTan_cycle:	
	MUL	X0, X28, X20 	//2n
	BL	bernoulliNumber //B_2n
	FMOV	D21, D0 	//D21 - B_2n
	MOV	X0, #-4
	SCVTF	D0, X0
	SCVTF	D1, X28
	PUSHTEMP
	BL	pow
	POPTEMP
	FMUL	D21, D21, D0 	//D21 - B_2n*(-4)^n
	MOV	X0, #1
	SCVTF	D22, X0		//D22 - 1
	MOV	X0, #4
	SCVTF	D0, X0		
	SCVTF	D1, X28		
	PUSHTEMP
	BL	pow
	POPTEMP
	FSUB	D22, D22, D0	//D22 - 1-4^n
	FMUL	D21, D21, D22 	//D21 - (b_2n*(-4)^n*(1-4^n))
	SCVTF	D0, X28
	FADD	D0, D0, D0
	FADD	D0, D0, D27
	PUSHTEMP
	BL	tgamma
	POPTEMP
	FDIV	D21, D21, D0	//D21 - D21/(2n!)
	MUL	X0, X28, X20	//X0  - 2n
	DEC	X0		//X0  - 2n-1
	SCVTF	D1, X0		//D1  - 2n-1
	FMOV	D0, D19		//D0  - x
	PUSHTEMP
	BL	pow
	POPTEMP
	FMUL	D21, D21, D0 	//D21  - D21 * x^(2n-1)
	FADD	D28, D28, D21	
	ADR	X0, result
	MOV	X1, #127
	ADR	X2, fresult
	MOV	X3, X28
	FMOV	D0, D19
	FMOV	D1, D28
	FMOV	D2, D21
	PUSHTEMP
	BL	snprintf
	POPTEMP
	MOV	X0, X19
	ADR	X1, result
	MOV	X2, #127
	PUSHTEMP
	BL	write
	POPTEMP
	FMOV	D0, D21
	PUSHTEMP
	BL	fabs
	POPTEMP
	FCMP	D0, D20
	BLE	customTan_ret
	INC	X28
	B	customTan_cycle
customTan_ret:
	FMOV	D0, D28
	POPTEMP
	RET
.customTan_end:
	.size customTan, .customTan_end-customTan

//.asciz "%d: tan(%lf) = %lf. Serie element - %lf\n"

/* binomialCoefficient - tells what it do itself
 * X0 - n
 * X1 - k
 * The only purpose of this function is bernoulliNumber. Good news that this function isn't called recursively, so PUSHTEMP and POPTEMP are usable and we do not need to fuck around with memory
 */
FUNCTION_DEFINE binomialCoefficient
binomialCoefficient:
	PUSHTEMP
	MOV	X19, X0
	MOV	X20, X1
	SCVTF	D0, X19
	FMOV	D27, #1
	FADD	D0, D0, D27
	BL	tgamma
	FMOV	D19, D0
	SCVTF	D0, X20
	FADD	D0, D0, D27
	BL	tgamma
	FMOV	D20, D0
	SUB	X21, X19, X20
	SCVTF	D0, X21
	FADD	D0, D0, D27
	BL	tgamma
	FMOV	D21, D0
	// D19 - n!, D20 - k!, D21 - (n-k)!
	FMOV	D0, D19
	FDIV	D0, D0, D20
	FDIV	D0, D0, D21
	POPTEMP
	RET
FUNCTION_END	binomialCoefficient








/* bernoulliNumber - fucking mathematical shit with stupid recursive formula.
 * Since this is recursive formula, it will consume a lot of memory to calculate, if we will use PUSHTEMP and POPTEMP (they use cumulatively 20*8 bytes of stack memory).
 * So only way to avoid this to minimize usable memory, which is pretty hard.
 * The other problem that performance of naive computation sucks dicks
 * We could use dzetta function, but it sucks dicks too.
 * The only way to overcome this is make a cache of numbers, so, it will be pretty fast
 * The other optimization technique is to skip odd arguments, if they are greater than 1 (when 1, then -1/2 wtf)
 * Let's try this, maybe it will work properly
 * Basically, X0 is only input here
 */
FUNCTION_DEFINE bernoulliNumber
bernoulliNumber:
	CMP	X0, #0
	BEQ	bernoulliNumber_oneret
	CMP	X0, #1
	BEQ	bernoulliNumber_calc
	PUSH	X20
	PUSH	X21
	PUSH	X22
	MOV	X21, #2
	UDIV	X20, X0, X21
	MSUB	X22, X20, X21, X0
	MOV	X1, X22
	POP	X22
	POP	X21
	POP	X20
	CMP	X1, #0
	BEQ	bernoulliNumber_func
	FMOV	D0, #0
	RET
bernoulliNumber_oneret:
	MOV	X0, #1
	SCVTF	D0, X0
	RET

bernoulliNumber_func:
//Now, we can ask cache if we have queried number
	PUSHTEMP
	ADR	X19, cache
	LDR	X20, [X19]
	CMP	X20, X0
	BLE	bernoulliNumber_precalc
	MOV	X21, #8
	MUL	X0, X0, X21
	ADD	X19, X19, X0
	LDR	D0, [X19]
	POPTEMP
	RET
bernoulliNumber_precalc:
	POPTEMP
bernoulliNumber_calc:
	PUSH	X30	//obviously push ret
	PUSH	X19	//push X19, will be used for safe X0, basically, n
	PUSH	X20 	//This is k
	PUSH	D19	//Which will be overwritten, as it is sum
	PUSH	D20	//This is partical sum
	PUSH	XZR	//This is used to normalize stack alignment (because libc doesn't give a fuck that we have sp not divisible by 16)
	MOV	X19, X0
	MOV	X20, #1
	FMOV	D19, XZR
	FMOV	D20, XZR
bernoulliNumber_cycle:
	CMP	X20, X19	//Because of fucking matematicians, whose include higher limit
	BGT 	bernoulliNumber_final
	MOV	X0, X19
	INC	X0
	MOV	X1, X20
	INC	X1
	BL	binomialCoefficient
	FMOV	D20, D0			//This (n+1/k+1) thingy
	SUB	X0, X19, X20
	BL 	bernoulliNumber		//This calls recursion
	//To avoid using other registers lets we will FMUL directly into D20
	FMUL	D20, D20, D0
	//Finally, add this to sum
	FADD	D19, D19, D20
	INC	X20
	B	bernoulliNumber_cycle
bernoulliNumber_final:
	//After recursive hell, we can PUSH and POP whatever we want, because, you know, why not
	PUSH	D21
	PUSH	D22
	PUSH	D27
	FMOV	D27, #1
	FMOV	D21, #-1 // -1
	SCVTF	D22, X19 // n
	FADD	D22, D22, D27 // n+1
	FDIV	D21, D21, D22 //-1/n+1
	FMUL	D19, D19, D21 //SUM * -1/n+1
	FMOV	D0, D19
	//insert number into cache
	PUSH	X21
	PUSH	X22
	ADR	X21, cache
	MOV	X22, #8
	MUL	X22, X19, X22
	STR	X19, [X21]
	ADD	X21, X21, X22
	STR	D0, [X21]
	POP	X22
	POP	X21

	//CAREFULLY pop registers
	POP	D27
	POP	D22
	POP	D21
	POP	XZR
	POP	D20
	POP	D19
	POP	X20
	POP	X19
	POP	X30
	RET
//Fucking finally
FUNCTION_END bernoulliNumber


fresult:
	.asciz "%d: tan(%lf) = %lf. Serie element - %lf\n"
	.size fresult, 41

	.type result, @object
	.comm result, 128, 1
	
	.type cache, @object
	.comm cache, 0x2000, 1
