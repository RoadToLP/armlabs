#include <stdio.h>
#include <stdlib.h>

	.globl main
	.type main, @function
	.p2align 2
main:
	ADR	X1, arg
	ADR	X2, pres
	ADR	X0, finput
	BL	scanf
	ADR	X0, arg
	ADR	X1, pres
	LDR	D0, [X0]
	LDR	D1, [X1]
	BL	customTan
	MOV	X0, #255
	BL 	exit
.main_end:
	.size main, .main_end-main

	
	.type arg, @object
	.comm arg, 8, 1

	.type pres, @object
	.comm pres, 8, 1



finput:
	.asciz "%lf %lf"
	.size finput, 8

foutput:
	.asciz "tan(%lf) from libm: %lf\nOurs tan(%lf): %lf\n"
	.size foutput, 44

flog:	
	.asciz ".log"
	.size flog, 5
openfail:
	.asciz "[-] Failed to open log file. Make sure you are in a writable directory, and check permissions if .log file exists"

