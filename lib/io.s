.include "asm/macro.s"
//puts - print a string to it's '\0' to stdout
	.text
FUNCTION_DEFINE puts
puts:
        PUSHTEMP
        MOV     X19, X0
        BL      strlen
        MOV     X2, X0
        MOV     X1, X19
        MOV     X0, #1
        MOV     X8, #0x40
        SVC     #0
        POPTEMP
        RET
FUNCTION_END	puts

//open - open file and return fd. X0 - filename, X1 - flags
FUNCTION_DEFINE	open
open:
	PUSHTEMP
	MOV	X3, X2
	MOV	X2, X1
	MOV	X1, X0
	MOV	X0, #-100
	MOV	X8, #0x38
	SVC	#0
	MOV	X19, X0
	LSR	X19, X19, 63
	CMP	X19, #1
	BNE	open_ret
	MOV	X0, #-1
open_ret:
	POPTEMP
	RET
FUNCTION_END	open

//read - reads X2 bytes from X0 fd to X1 string.
FUNCTION_DEFINE read
read:
	PUSHTEMP
	MOV	X8, #0x3f
	SVC	#0
	POPTEMP
	RET
FUNCTION_END	read

//write - writes X2 bytes to X0 fd from X1 string
FUNCTION_DEFINE write
write:
	PUSHTEMP
	MOV	X8, #0x40
	SVC 	#0
	POPTEMP
	RET
FUNCTION_END	write

//close - closes X0 fd
FUNCTION_DEFINE close
close:
	PUSHTEMP
	MOV	X8, #0x39
	SVC	#0
	POPTEMP
	RET
FUNCTION_END	close

//nextInt - asks for input and returns number(can get only 23 bytes of input)
FUNCTION_DEFINE	nextInt
nextInt:
	PUSHTEMP
	EOR	X0, X0, X0
	SUB	SP, SP, #0x18
	MOV	X1, SP
	MOV	X2, #0x17
	BL	read
	MOV	X29, SP
	ADD	X29, X29, X0
	STRB	WZR, [X29]
	MOV	X0, SP
	BL	stoi
	ADD	SP, SP, #0x18
	POPTEMP
	RET
FUNCTION_END	nextInt

//printInt - basically, just a wrapper for itos and print, just making it better. X0 contains numba
FUNCTION_DEFINE printInt
printInt:
	PUSHTEMP
	MOV	X19, X0
	SUB	SP, SP, #0x18
	MOV	X1, SP
	BL	itos
	BL	puts
	ADD	SP, SP, #0x18
	POPTEMP
	RET
FUNCTION_END	printInt




