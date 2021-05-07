.include "asm/macro.s"

	.text
	.globl genMatrix
	.p2align 2
	.type genMatrix, @function

/* genMatrix - initialize matrix (loc, width, height)
 * So basically,  we have array of arrays, each element points to column (handy with our task)
 * Data will be stored right after array, so we can imagine like that
 * Matrix		              col1   col2 ....
 * |                                  |      |
 * col1, col2, col3...................[0,0], [1,0]...
 * I think this architecture is pretty good for our task.
 */

genMatrix:
	PUSHTEMP
	MOV	X19, X0
	MOV	X20, X1
	MOV	X21, X2
	MOV	X28, X0
	//calculate offset for data
	MOV 	X22, X19
	MOV 	X23, X20
	MOV	X24, 8
	MUL	X23, X23, X24
	ADD	X22, X22, X23 
	//now X22 contain address of new data

genMatrix_loop:
	STUR	X22, [X19]
	MOV	X0, X22
	MOV	X1, X21
	BL 	makeArray 	//array is initialized
	MOV	X22, X0		//new offset
	DEC	X20
	CMP	X20, #0
	ADD	X19, X19, #8
	BNE 	genMatrix_loop

	MOV	X0, X28
	POPTEMP
	RET
.genMatrix_end:
	.size genMatrix, .genMatrix_end-genMatrix

	
//sortMatrix - sort colums of matrix(less gooo). X0 - matrix, X1 - width, X2 - height
	.globl sortMatrix
	.p2align 2
	.type sortMatrix, @function
sortMatrix:
	PUSHTEMP
	MOV	X19, X0
	MOV	X20, X1
	MOV	X21, X2
sortMatrix_loop:
	LDR	X0, [X19]
	MOV	X1, X21
	BL	sort
	ADD	X19, X19, #8
	DEC	X20
	CMP 	X20, #0
	BNE	sortMatrix_loop
	POPTEMP
	RET
.sortMatrix_end:
	.size sortMatrix, .sortMatrix_end-sortMatrix
	
	


	

