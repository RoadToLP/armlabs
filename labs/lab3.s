.include "../lib/asm/macro.s"
	.text
	.p2align 2
	.globl _start
	.type _start, @function

_start:
	POP	X0
	CMP	X0, #2
	BEQ	argc_pass
	ADRP	X0, usage
	ADD	X0, X0, :lo12:usage
	BL 	puts
	B	fail
	
argc_pass:
	POP	X0		//executable name
	POP	X0		//File to open
	SUB	SP, SP, #24 	//Recover stack (why?)
	MOV	X1, O_WRONLY | O_CREAT | O_TRUNC
	MOV	X2, S_IRUSR | S_IWUSR | S_IRGRP
	BL	open
	CMP	X0, #-1		//check if file can't be opened
	BNE	open_pass
	ADRP	X0, openfail
	ADD	X0, X0, :lo12:openfail
	BL 	puts
	B	fail
open_pass:			//now we are talking
	/* Algorithm itself is pretty easy. Since we are reading from stdin, and hopefully, it is not from file using < (it will replace stdin fd with file fd and everything will be fucked up)
	 * So '\n's are not misunderstanded. read() from kb will read data only to \n, and we can use it to simplify our work
	 * Finally, there is our plan:
	 * 1. Read string to memory
	 * 2. Split string into array
	 * 3. Check every entry if it is palindrome
	 * 4. If not, just remove pointer from the array (merge skips zero entry)
	 * 5. Merge array into string
	 * 6. Write it to file, with \n at the end
	 * 7. Clean used data (with memset, will implement later)
	 * Just because read() behaves like a bitch we should check if line ended with '\n' and if it is false, we should exit without \n at the end. Prob useful i guess
	 * We have plenty of registers X8-X18 haven't been used completely, we can abuse it
	 */
	MOV	X28, X0		//Save an fd. Pretty useless, because it is 3, but just to be safe
	MOV	X10, #0		//Will be used as trigger if string is null-terminated
	//Tell user what we want from them
	ADRP	X0, help
	ADD	X0, X0, :lo12:help
	BL	puts

main_loop:
	MOV	X0, #0
	ADRP	X1, input
	ADD	X1, X1, :lo12:input
	PUSH	X1
	MOV	X2, #1023
	BL	read		//Read string, X0 holds how many bytes read
	POP	X1
	CMP	X0, #0		//If no data read, exit
	BEQ	success
	MOV	X19, X1
	ADD	X19, X19, X0
	DEC	X19
	LDRB	W8, [X19]	//Get last symbol of string
	CMP	W8, '\n'	//Check if it is newline
	BEQ	newline_present
	INC	X10 		//After that cycle, we will exit
newline_present:
	MOV	X0, X1
	PUSH	X0
	MOV	X1, ' '
	BL	strcnt		//get number of words
	MOV	X9, X0
	POP	X0
	ADRP	X2, arr
	ADD	X2, X2, :lo12:arr
	BL	strsplit	//Finally split
	PUSH	X0
	MOV	X11, #0
	//Now comedy begins
line_loop:
	CMP	X11, X9
	BEQ	line_end
	POP	X0
	PUSH	X0
	MOV	X1, X11
	BL	getArr64Element
	BL	isPalindrome
	CMP	X0, #1
	BEQ	word_good
	POP	X0
	PUSH	X0
	MOV	X1, X11
	MOV	X2, #0
	BL	setArr64Element
word_good:
	INC	X11
	B 	line_loop
line_end:
	//array is now filtered, ready to merge
	POP	X0
	MOV	X1, X9
	MOV	X2, ' '
	ADRP	X3, res
	ADD	X3, X3, :lo12:res
	BL	strmerge
	//Merged. Check its LENGTH
	PUSH	X0
	BL	strlen
	MOV	X2, X0
	POP	X1
	MOV	X0, X28		//fd
	BL	write
	CMP	X10, #1		//remember trigger?
	BEQ	success		//success
	//\n found, continue
	ADRP	X1, nline
	ADD	X1, X1, :lo12:nline
	MOV	X0, X28
	MOV	X2, #1
	BL	write
	//Make cleanup
	ADRP	X0, input
	ADD	X0, X0, :lo12:input
	MOV	X1, #0
	MOV	X2, 1024
	BL	memset
	ADRP	X0, res
	ADD	X0, X0, :lo12:res
	BL	memset
	ADRP	X0, arr
	ADD	X0, X0, :lo12:arr
	MOV	X2, 10240
	BL	memset
	//And reset

	B	main_loop	//finally

fail:
	MOV	X0, #1
	BL	exit


success:
	MOV	X0, X28
	BL	close
	ADRP	X0, farewell
	ADD	X0, X0, :lo12:farewell
	BL	puts
	MOV	X0, XZR
	BL	exit

._start_end:
	.size _start, ._start_end-_start


help:
	.asciz "[+] File opened for writing\nNow please enter lines to format. You can stop entering data by pressing Ctrl+D whenever you want.\n"
.help_end:
	.size help,  .help_end-help

farewell:
	.asciz "\n[+] Formatted data had been written to your file.\nSee you next time ;)\n"
.farewell_end:
	.size farewell, .farewell_end-farewell

usage:
	.asciz "Usage: ./lab3 <file>\n\0"
.usage_end:
	.size usage, .usage_end-usage

openfail:
	.asciz "[-] Failed to open specified file for writing, exiting.\n\0"
.openfail_end:
	.size openfail, .openfail_end-openfail

	.type input, @object
	.comm input, 1024, 1

	.type arr, @object //if someone will try to write 'a a a ...' just don't do that
	.comm arr, 10240, 1
	
	.type res, @object
	.comm res, 1024, 1

nline:
	.asciz "\n\0" //really?
	.size nline, 2
