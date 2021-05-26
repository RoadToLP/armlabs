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
	BL	dynRead		//Read string, X0 will contain our string
	PUSH	X0		//Save this pointer
	BL	strlen		//Calculate its length
	CMP	X0, #0		//If no data read, exit
	BEQ	success
	/* While we have string length in X0, we should allocate load of memory, like x10 of default size.
	 * It is very inefficient, but smart allocating in array constructor is PRETTY HARD
	 * The only reason why we should do it because of strings like
	 * a a a a a a a a a ... and so on
	 * Because we should store pointer to string, which is 8 bytes, and string itself, which is pretty like 2 bytes in worst scenario (a and '\0')
	 * every this word allocates 10 bytes at least. Bigger words are better for memory, small words are pretty hard to swallow
	 */
	MOV	X12, X0		//Save string length
	MOV	X1, X0
	MOV	X0, #10
	MUL	X1, X1, X0	//Now X1 has 10*strlen
	MOV	X0, #0
	MOV	X2, #3
	MOV	X3, #34
	MOV	X4, #-1
	MOV	X5, #0
	MOV	X8, #0xde
	SVC	#0		//Invoke mmap
	MOV	X13, X0		//Save array pointer
	MOV	X0, X12		//Reload string length
	MOV	X19, X0
	POP	X0
	ADD	X19, X19, X0	//Now we have end of string
	DEC	X19
	LDRB	W8, [X19]	//Get last symbol of string
	CMP	W8, '\n'	//Check if it is newline
	BEQ	newline_present
	INC	X10 		//After that cycle, we will exit
newline_present:
	MOV	X14, X0		//Now save string pointer because we should munmap it
	//X0 contains pointer to string
	PUSH	X0
	MOV	X1, ' '
	BL	strcnt		//get number of words
	MOV	X9, X0
	POP	X0
	MOV	X2, X13
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
	//So now we should allocate memory for resulting string. It should be at most length of initial string
	PUSH	X0
	PUSH	X1
	PUSH	X2
	PUSH	X3
	PUSH	X4
	PUSH	X5
	MOV	X0, #0
	MOV	X1, X12
	MOV	X2, #3
	MOV	X3, #34
	MOV	X4, #-1		//Pretty mess
	MOV	X5, #0
	MOV	X8, #0xde
	SVC	#0
	MOV	X15, X0
	POP	X5
	POP	X4
	POP	X3
	POP	X2
	POP	X1
	POP	X0
	MOV	X3, X15
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
	//Cleanup more line MUNMAP
	MOV	X0, X14
	MOV	X1, X12
	MOV	X8, #0xd7
	SVC	#0
	MOV	X0, X15
	MOV	X1, X12
	MOV	X8, #0xd7
	SVC	#0
	MOV	X1, #10
	MUL	X1, X12, X1
	MOV	X0, X13
	MOV	X8, #0xd7
	SVC	#0
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
