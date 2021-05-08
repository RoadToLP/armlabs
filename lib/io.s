.include "asm/macro.s"
//puts - print a string to it's '\0' to stdout
        .globl puts
        .p2align 2
        .type puts, @function
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
.Lfunc_end4:
        .size puts, .Lfunc_end4-puts

//open - open file and return fd. X0 - filename, X1 - flags
	.globl open
	.p2align 2
	.type open, @function
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
.open_end:
	.size open, .open_end-open
	

//read - reads X2 bytes from X0 fd to X1 string.
	.globl read
	.p2align 2
	.type read, @function
read:
	PUSHTEMP
	MOV	X8, #0x3f
	SVC	#0
	POPTEMP
	RET
.read_end:
	.size read, .read_end-read
	
//write - writes X2 bytes to X0 fd from X1 string
	.globl write
	.p2align 2
	.type write, @function
write:
	PUSHTEMP
	MOV	X8, #0x40
	SVC 	#0
	POPTEMP
	RET
.write_end:
	.size write, .write_end-write

//close - closes X0 fd
	.globl close
	.p2align 2
	.type close, @function
close:
	PUSHTEMP
	MOV	X8, #0x39
	SVC	#0
	POPTEMP
	RET
.close_end:
	.size close, .close_end-close

//nextInt - asks for input and returns number(can get only 23 bytes of input)
	.globl nextInt
	.p2align 2
	.type nextInt, @function
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
.nextInt_end:
	.size	nextInt, .nextInt_end-nextInt

//printInt - basically, just a wrapper for itos and print, just making it better. X0 contains numba
	.globl printInt
	.p2align 2
	.type printInt, @function
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
.printInt_end:
	.size	printInt, .printInt_end-printInt




