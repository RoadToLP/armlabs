.include "asm/macro.s"
/* isPalindrome - checks if string is palindrome
 * X0 - pointer to string
 */
 	.p2align 2
	.globl isPalindrome
	.type isPalindrome, @function
isPalindrome:
	PUSHTEMP
	MOV	X19, X0
	BL	strlen
	ADD	X20, X19, X0
	CMP	X0, #0
	BLE	isPalindrome_ret
	DEC	X20
	MOV	X0, #1 	//Assume that string is palindrome
isPalindrome_loop:
	LDRB	W22, [X19]
	LDRB	W23, [X20]
	CMP	X22, X23
	BNE	isPalindrome_failret
	SUB	X24, X20, X19
	CMP	X24, #1
	BLE	isPalindrome_ret
	INC	X19
	DEC	X20
	B	isPalindrome_loop
isPalindrome_failret:
	MOV	X0, #0
isPalindrome_ret:
	POPTEMP
	RET
.isPalindrome_end:
	.size isPalindrome, .isPalindrome_end-isPalindrome


