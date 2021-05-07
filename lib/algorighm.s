.include "asm/macro.s"

	.text
	.p2align 2
	.globl sort
	.type sort, @function
//sort - sorts an array of halfwords in ascending order. Takes X0 as array pointer and X1 as array length
sort:
	PUSHTEMP
	MOV X19, X0
	MOV X20, X1
	DEC X20
	MOV X21, #1 // X21 means that array is sorted
	MOV X23, 0
	MOV X24, 0
main_sort:
	MOV X22, 0
	MOV X21, #1
	loop:
		MOV	X0, X19
		MOV	X1, X22
		BL 	getArrElement
		MOV	X23, X0
		MOV	X0, X19
		MOV	X1, X22
		INC	X1
		BL	getArrElement
		MOV	X24, X0
		CMP 	X23, X24
		BLE	skip
		MOV	X21, #0
		MOV	X0, X19
		MOV	X1, X22
		MOV	X2, X24
		BL	setArrElement
		MOV	X0, X19
		MOV	X1, X22
		INC	X1
		MOV	X2, X23
		BL	setArrElement
		skip:
		INC	X22
		CMP	X22, X20
		BNE	loop
	
	CMP	X21, #1
	BNE	main_sort
	MOV	X0, X19
	POPTEMP
	RET
.sort_end:
	.size sort, .sort_end-sort

		
		
		
		
		
	
	
