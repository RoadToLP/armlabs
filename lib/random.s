.include "asm/macro.s"
//rand - returns random number from /dev/urandom
.urandom:
	.asciz "/dev/urandom\0"
	.size .urandom, 13
	.type .res, @object
	.comm .res, 8, 1


	.text
FUNCTION_DEFINE	rand
rand:
	PUSHTEMP
	ADRP	X0, .urandom
	ADD	X0, X0, #:lo12:.urandom
	MOV	X1, 0
	BL 	open
	ADRP	X1, .res
	ADD	X1, X1, #:lo12:.res
	MOV	X2, #8
	BL	read
	LDR	X0, [X1]
	POPTEMP
	RET
FUNCTION_END	rand
