	.text
	.file	"foo.c"
	.globl	kek                     // -- Begin function kek
	.p2align	2
	.type	kek,@function
kek:                                    // @kek
// %bb.0:
	sub	sp, sp, #16             // =16
	str	w0, [sp, #12]
	ldr	w0, [sp, #12]
	add	sp, sp, #16             // =16
	ret
.Lfunc_end0:
	.size	kek, .Lfunc_end0-kek
                                        // -- End function
	.globl	main                    // -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   // @main
// %bb.0:
	sub	sp, sp, #32             // =32
	stp	x29, x30, [sp, #16]     // 16-byte Folded Spill
	add	x29, sp, #16            // =16
	mov	w0, #48879
	movk	w0, #57005, lsl #16
	stur	wzr, [x29, #-4]
	bl	kek
	ldp	x29, x30, [sp, #16]     // 16-byte Folded Reload
	add	sp, sp, #32             // =32
	ret
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        // -- End function
	.ident	"clang version 10.0.1 (https://github.com/termux/termux-packages 6c2f9eab313cd099ce3cb97038f4ec27735a742f)"
	.section	".note.GNU-stack","",@progbits
