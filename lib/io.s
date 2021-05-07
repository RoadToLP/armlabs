#include <string.h>
#include <io.h>
.include "asm/macro.s"
//print - print a string to it's '\0'
        .globl print
        .p2align 2
        .type print, @function
print:
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
        .size print, .Lfunc_end4-print

//open - open file and return fd*. X0 - filename, X1 - flags
	.globl open
	.p2align 2
	.type open, @function
open:
	PUSHTEMP
	MOV	X2, X1
	MOV	X1, X0
	MOV	X0, #-100
	MOV	X8, #0x38
	SVC	#0
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
	




