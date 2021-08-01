#include <stdio.h>
#include <stdlib.h>
#include <math.h>

.include "macro.s"

	.globl main
	.type main, @function
	.p2align 2
main:
	ADR	X0, flog
	MOV     X1, O_WRONLY | O_CREAT | O_TRUNC
        MOV     X2, S_IRUSR | S_IWUSR | S_IRGRP
        BL      open
        CMP     X0, #-1         //check if file can't be opened
        BNE     open_pass
        ADRP    X0, openfail
        ADD     X0, X0, :lo12:openfail
        BL      puts
        B       fail
open_pass:
	PUSH	X0
	PUSH	XZR
	ADR	X0, help
	BL	printf
	ADR	X1, arg
	ADR	X2, pres
	ADR	X0, finput
	BL	scanf
	ADR	X0, arg
	ADR	X1, pres
	LDR	D0, [X0]
	FMOV	D19, D0
	PUSHTEMP
	BL	fabs
	POPTEMP
	MOVA	X28, 0x3FF921FB54442D18
	FMOV	D31, X28
	FCMP	D0, D31
	BGE	fail
	FMOV	D0, D19
	POP	XZR
	POP	X0
	PUSH	D0
	PUSH	XZR
	LDR	D1, [X1]
	FMOV	D31, XZR
	FCMP	D1, D31
	BLE	fail
	BL	customTan
	POP	XZR
	POP	D1
	PUSH	D1
	PUSH	D0
	FMOV	D0, D1
	BL	tan
	FMOV	D1, D0
	POP	D3
	POP	D0
	FMOV	D2, D0
	ADR	X0, foutput
	BL	printf
	MOV	X0, #0
	BL 	exit
fail:
	MOV	X0, #-1
	BL	exit
.main_end:
	.size main, .main_end-main

	
	.type arg, @object
	.comm arg, 8, 1

	.type pres, @object
	.comm pres, 8, 1



finput:
	.asciz "%lf %lf"
	.size finput, 8

help:
	.asciz "Please enter two float values: argument of function and desirable presicion\nPlease make sure that argument is from -pi/2 to +pi/2 and presicion is positive\nOtherwise program will abort without any message.\n"
	.size help, 131


foutput:
	.asciz "tan(%.10lf) from libm: %.10lf\nOurs tan(%.10lf): %.10lf\n"
	.size foutput, 44

flog:	
	.asciz ".log"
	.size flog, 5
openfail:
	.asciz "[-] Failed to open log file. Make sure you are in a writable directory, and check permissions if .log file exists"

