	.text
	.file	"division.c"
	.globl	main                    // -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   // @main
// %bb.0:
	sub	sp, sp, #16             // =16
	mov	w8, #123
	mov	w9, #10
	str	wzr, [sp, #12]
	str	w8, [sp, #8]
	ldr	w8, [sp, #8]
	sdiv	w10, w8, w9
	mul	w9, w10, w9
	subs	w8, w8, w9
	str	w8, [sp, #8]
	ldr	w0, [sp, #8]
	add	sp, sp, #16             // =16
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        // -- End function
	.ident	"clang version 10.0.1 (https://github.com/termux/termux-packages 6c2f9eab313cd099ce3cb97038f4ec27735a742f)"
	.section	".note.GNU-stack","",@progbits
