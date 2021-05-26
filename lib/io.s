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

/* dynRead - reads line from X0 fd
 * Returns address of fresh line
 * Pretty difficult thing, which will use mmap.
 * Just like in heap, we should not forget munmap to prevent memory leaks
 */
FUNCTION_DEFINE	dynRead
dynRead:
	PUSHTEMP
	MOV	X19, X0
	MOV	X8, #0xde
	MOV	X0, #0
	MOV	X1, #0x1000
	MOV	X2, #3		// Basically PROT_READ | PROT_WRITE
	MOV	X3, #34		// Basically MAP_PRIVATE | MAP_ANONYMOUS
	MOV	X4, #-1
	MOV	X5, #0
	SVC 	#0		//mmap
	//Now we have our dynamic memory. By default, it has 0x1000 bytes, default page length. We will expand it later, if needed with mremap
	MOV	X20, X0		//Here we will store base page address
	MOV	X21, X0		//And here will be used as pointer to be written
	MOV	X28, #0		//This will be used as counter
	MOV	X27, #0x1000	//This is page size counter
dynRead_loop:
	MOV	X0, X19
	MOV	X1, X21
	MOV	X2, #1
	BL	read		//We will read it character by character, searching for \n or, if it will return 0, it means ctrl-d met
	CMP	X0, #0		//Thats what I'm talking about
	BEQ	dynRead_fillZero
	LDRB	W22, [X21]
	CMP	W22, #0xa	//Checking if it is newline
	BEQ	dynRead_ret
	INC	X21
	INC	X28
	CMP	X28, X27
	BNE	dynRead_loop	//Continue loop, nothing bad happened
	//Now we are pretty fucked. We should mremap + ensure new pointers and sizes
	PUSH	X28
	MOV	X28, #0x1000
	MOV	X26, X27	//Old size
	ADD	X27, X27, X28
	POP	X28		//Now X27 contains new size. Make mremap
	MOV	X0, X20
	MOV	X1, X26
	MOV	X2, X27
	MOV	X3, #1		//MREMAP_MAYMOVE
	MOV	X4, #0
	MOV	X8, #0xd8
	SVC	#0		//mremap
	MOV	X20, X0		//new base address
	MOV	X21, X0		//prepare new current pointer
	ADD	X21, X21, X26	//And add old size (offset) to it
	//Everything looks normal, continue
	B	dynRead_loop
dynRead_fillZero:
	LDRB	WZR, [X21]
dynRead_ret:
	MOV	X0, X20		//Base address contains beginning of our string
	POPTEMP
	RET
FUNCTION_END	dynRead


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




