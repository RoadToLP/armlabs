.macro	INC, REG
	ADD 	\REG, \REG, #1
.endmacro

.macro	DEC, REG
	SUB 	\REG, \REG, #1
.endmacro

.macro	PUSH, REG
	MOV 	X29, SP
	STR	\REG, [X29, #-8]!
	MOV	SP, X29
.endmacro

.macro	POP, REG
	MOV	X29, SP
	LDR	\REG, [X29], #8
	MOV	SP, X29
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
	PUSH	X30
.endmacro

.macro	POPTEMP
	POP	X30
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
	MOV	\REG, #\VAL
	MOVK	\REG, #\VAL>>16, lsl #16
	MOVK	\REG, #\VAL>>32, lsl #32
	MOVK	\REG, #\VAL>>48, lsl #48
.endmacro
