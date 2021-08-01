.set	O_RDONLY,	0
.set	O_WRONLY,	1
.set	O_RDWR,		2
.set 	O_CREAT,	64
.set 	O_TRUNC,	01000
.set S_IRWXU, 0000700    /* RWX mask for owner */
.set S_IRUSR, 0000400    /* R for owner */
.set S_IWUSR, 0000200    /* W for owner */
.set S_IXUSR, 0000100    /* X for owner */

.set S_IRWXG, 0000070    /* RWX mask for group */
.set S_IRGRP, 0000040    /* R for group */
.set S_IWGRP, 0000020    /* W for group */
.set S_IXGRP, 0000010    /* X for group */

.set S_IRWXO, 0000007    /* RWX mask for other */
.set S_IROTH, 0000004    /* R for other */
.set S_IWOTH, 0000002    /* W for other */
.set S_IXOTH, 0000001    /* X for other */


.macro FUNCTION_DEFINE,	FUNC
	.globl \FUNC
	.p2align 2
	.type \FUNC, @function
.endmacro

.macro FUNCTION_END, FUNC
.\FUNC\()_end:
	.size \FUNC, .\FUNC\()_end-\FUNC
.endmacro

.macro	INC, REG
	ADD 	\REG, \REG, #1
.endmacro

.macro	DEC, REG
	SUB 	\REG, \REG, #1
.endmacro

.macro	PUSH, REG
	MOV 	X15, SP
	STR	\REG, [X15, #-8]!
	MOV	SP, X15
.endmacro

.macro	POP, REG
	MOV	X15, SP
	LDR	\REG, [X15], #8
	MOV	SP, X15
.endmacro

.macro	PUSHTEMP
	PUSH	X19
	PUSH	X20
	PUSH	X21
	PUSH	X22
	PUSH	X23
	PUSH	X24
	PUSH	X25
	PUSH	X26
	PUSH	X27
	PUSH	X28
	PUSH 	X29
	PUSH	X30
	PUSH	D19
	PUSH	D20
	PUSH	D21
	PUSH	D22
	PUSH	D23
	PUSH	D24
	PUSH	D25
	PUSH	D26
	PUSH	D27
	PUSH	D28
	PUSH	D29
.endmacro

.macro	POPTEMP
	POP	D29
	POP	D28
	POP	D27
	POP	D26
	POP	D25
	POP	D24
	POP	D23
	POP	D22
	POP	D21
	POP	D20
	POP	D19
	POP	X30
	POP	X29
	POP	X28
	POP	X27
	POP	X26
	POP	X25
	POP	X24
	POP	X23
	POP	X22
	POP	X21
	POP	X20
	POP	X19
.endmacro

.macro  MOVA, REG, VAL
	MOV	\REG, #\VAL<<48>>48
	MOVK	\REG, #\VAL<<32>>48, lsl #16
	MOVK	\REG, #\VAL<<16>>48, lsl #32
	MOVK	\REG, #\VAL>>48, lsl #48
.endmacro
