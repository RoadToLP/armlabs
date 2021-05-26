.include "asm/macro.s"

	.text
FUNCTION_DEFINE itos
//itos - convert integer to char*
itos:	
	PUSHTEMP
	MOV	X22, X1
	MOV	X19, #10
.itos_0:
	UDIV	X20, X0, X19 
	MUL	X21, X20, X19
	SUB	X21, X0, X21
	ADD	X21, X21, #0x30 //X21 = X0%10 + 0X30
	STRB	W21, [X22]
	MOV	X0, X20 //X0 = X0/10
	CMP	X0, #0	//CHECK IF X0 == 0
	ADD	X22, X22, #1
	BNE	.itos_0
	EOR	X19, X19, X19
	STRB	W19, [X22]
	MOV 	X0, X1
	BL	revstr
	POPTEMP
	RET
FUNCTION_END	itos

//strlen - calculare string length
FUNCTION_DEFINE strlen
strlen:
	PUSHTEMP
	MOV	X19, X0		//Copy original pointer and work with copy
.strlen_0:
	LDRB	W20, [X19] 	//Get current byte
	CMP 	W20, #0		//Check if it is zero
	BEQ	.strlen_1	//If yes, this is string end
	ADD	X19, X19, #1	//Otherwise, increment copy pointer
	B	.strlen_0	//And recheck
.strlen_1:
	SUB	X19, X19, X0	//Substact original from copy to get real string length
	MOV	X0, X19		//Move it to return register
	POPTEMP
	RET
FUNCTION_END	strlen
//swapb - swap two bytes. Takes two pointers

FUNCTION_DEFINE	swapb
swapb:
	PUSHTEMP
	LDRB	W19, [X0]	//Take first byte
	LDRB	W20, [X1]	//Take second byte
	STRB	W20, [X0]	//Save second byte in first ptr
	STRB	W19, [X1]	//Save first byte in second ptr
	POPTEMP
	RET
FUNCTION_END	swapb
	
//revstr - reverse string
FUNCTION_DEFINE revstr
revstr:
	PUSHTEMP
	MOV	X19, X0		//Save original pointer
	BL 	strlen
	MOV	X21, X0		//Save string length
	MOV	X20, X19	//Copy original pointer to new register
	ADD	X20, X20, X21	//Shift it to '\0' right after the end of string
	DEC	X20		//And move it to the end
	ASR	X21, X21, #1	//Divide string length by 2
	MOV	X22, X19
	CMP	X21, #0
	BEQ	.revstr_1
.revstr_0:
	MOV	X0, X19
	MOV	X1, X20
	BL	swapb
	DEC	X21
	CMP	X21, #0
	BEQ	.revstr_1
	INC	X19
	DEC	X20
	B	.revstr_0
.revstr_1:
	MOV	X0, X22
	POPTEMP
	RET

FUNCTION_END	revstr
//stoi - takes X0 as ptr to string and returns integer (yeah it overflows, but who doesn't?)
//returns zero if incorrect symbol found

FUNCTION_DEFINE stoi
stoi:
	PUSHTEMP
	MOV	X19, X0
	BL	strlen
	MOV	X20, X0
	MOV	X0, #0
	MOV 	X23, #1
	MOV	X24, #10
	ADD	X19, X19, X20
stoi_loop:
	DEC 	X20
	DEC	X19
	LDRB	W22, [X19]
	CMP	W22, #0xA
	BEQ	stoi_final
	SUB	X22, X22, #0x30
	CMP	X22, #10
	BGE	stoi_fail
	MUL	X22, X22, X23
	ADD 	X0, X0, X22
	MUL	X23, X23, X24
stoi_final:
	CMP 	X20, #0
	BNE 	stoi_loop
	B 	stoi_ret
stoi_fail:
	MOV	X0, #0
stoi_ret:
	POPTEMP
	RET
FUNCTION_END	stoi

//strcnt - count how many words are in string, with specified delimiter
//X0 - string
//X1 - delimiter
//If delimiter is, for example, ';', then "aboba;;;;bobaboba" will be treated as 2 words (repetative delimiters should be skipped)
FUNCTION_DEFINE	strcnt
strcnt:
	PUSHTEMP
	MOV	X19, X0
	MOV	X20, X1
	MOV	X21, XZR  //count
	MOV	X28, 1  //trigger flag

strcnt_loop:
	LDRB	W22, [X19]
	CMP	X22, #0
	BEQ	strcnt_ret
	CMP	X22, '\n' //get that \n out there
	BEQ	strcnt_delim
	CMP	X22, X20
	BNE	strcnt_default
strcnt_delim:
	CMP	X28, #1
	BEQ	strcnt_final
	MOV	X28, #1
	B	strcnt_final
strcnt_default:
	CMP	X28, #1
	BNE	strcnt_final
	MOV	X28, #0
	INC	X21
strcnt_final:
	INC	X19
	B	strcnt_loop
strcnt_ret:
	MOV	X0, X21
	POPTEMP
	RET
FUNCTION_END	strcnt





/* strsplit - returns pointer to Array64 of pointers to strings
 * So first, we should understand how much words are in our string
 * We will use internal function named strcnt
 * X0 - string
 * X1 - delimiter
 * X2 - place where to make array
 */
FUNCTION_DEFINE	strsplit
strsplit:
	PUSHTEMP
	MOV	X19, X0
	MOV	X20, X1
	MOV	X21, X2
	BL	strcnt 	//we have length of array
	MOV	X22, X0
	MOV	X0, X21
	MOV	X1, X22
	BL	makeArray64 //Create an array
	CMP	X22, #0
	BEQ 	strsplit_ret
	MOV	X23, X21
	PUSH	X22
	MOV	X24, #8
	MUL	X22, X22, X24
	ADD	X23, X23, X22
	POP 	X22
	MOV	X24, #1
	MOV	X26, #1
	MOV	X0, X21
	MOV	X1, #0
	MOV	X2, X23
	BL	setArr64Element
strsplit_loop:
	LDRB	W25, [X19]
	CMP	X25, #0
	BEQ	strsplit_ret
	CMP	X25, '\n'
	BEQ	strsplit_delim
	CMP	X25, '\t'
	BEQ	strsplit_delim
	CMP	X25, X20
	BNE	strsplit_default
strsplit_delim:
	CMP	X24, #1
	BEQ	strsplit_final
	STRB	WZR, [X23]
	INC	X23
	CMP	X26, X22
	BEQ	strsplit_final
	MOV	X0, X21
	MOV	X1, X26
	MOV	X2, X23
	BL	setArr64Element
	INC	X26
	MOV	X24, #1
	B	strsplit_final
strsplit_default:
	MOV	X24, XZR
	STRB	W25, [X23]
	INC	X23
strsplit_final:
	INC	X19
	B	strsplit_loop
strsplit_ret:
	MOV	X0, X21
	POPTEMP
	RET
FUNCTION_END	strsplit

/* strcpy - copy string to pointer. Returns number of copyed bytes
 * X0 - where to
 * X1 - what to
 */
FUNCTION_DEFINE strcpy
strcpy:
	PUSHTEMP
	MOV	X19, X0
	MOV	X20, X1
	MOV	X28, XZR
strcpy_loop:
	LDRB	W21, [X20]
	CMP	X21, #0
	BEQ 	strcpy_ret
	STRB	W21, [X19]
	INC	X20
	INC	X19
	INC	X28
	B 	strcpy_loop
strcpy_ret:
	MOV	X0, X28
	POPTEMP
	RET
FUNCTION_END	strcpy
	


/* strmerge - opposite of strsplit.	
 * X0 - array of strings
 * X1 - size of array
 * X2 - delimiter
 * X3 - string to place
 */
FUNCTION_DEFINE strmerge
strmerge:
	PUSHTEMP
	CMP 	X1, #0
	BEQ	strmerge_ret
	MOV	X19, X0
	MOV	X20, X1
	MOV	X21, X2
	MOV	X22, X3
	MOV	X23, XZR
	MOV	X24, XZR	//This will signalize that last word was skipped
	MOV	X25, XZR	//Count how many words were actually non-zero
strmerge_loop:
	MOV	X0, X19
	MOV	X1, X23
	BL	getArr64Element
	CMP	X0, #0
	BNE	strmerge_cont
	INC	X23
	MOV	X24, #1
	CMP	X23, X20
	BEQ 	strmerge_ret
	B	strmerge_loop
strmerge_cont:
	INC	X25
	MOV	X24, #0
	MOV	X1, X0
	MOV	X0, X22
	BL	strcpy
	INC	X23
	CMP	X23, X20
	BEQ	strmerge_ret
	ADD	X22, X22, X0
	STRB	W21, [X22]
	INC	X22
	B 	strmerge_loop
strmerge_ret:
	CMP	X25, #0
	BEQ	strmerge_realret
	CMP	X24, #0
	BEQ	strmerge_realret
	DEC	X22
	STRB	WZR, [X22]
strmerge_realret:
	MOV	X0, X3
	POPTEMP
	RET
FUNCTION_END	strmerge


	
/* memset - fill memory with constant byte
 * X0 - Where
 * X1 - With
 * X2 - How many
 */
FUNCTION_DEFINE memset
memset:
	PUSHTEMP
	MOV	X19, X0
	MOV	X20, X1
	MOV	X21, X2
memset_loop:
	CMP	X21, #0
	BEQ	memset_ret
	STRB	W1, [X19]
	DEC	X21
	INC	X19
	B	memset_loop
memset_ret:
	POPTEMP
	RET
FUNCTION_END	memset
