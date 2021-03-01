	.text
	.file	"call.c"
	.globl	add                     // -- Begin function add
	.p2align	2
	.type	add,@function
add:                                    // @add
// %bb.0:
	sub	sp, sp, #16             // =16
	str	w0, [sp, #12]
	ldr	w8, [sp, #12]
	add	w0, w8, #1              // =1
	add	sp, sp, #16             // =16
	ret
.Lfunc_end0:
	.size	add, .Lfunc_end0-add
                                        // -- End function
	.globl	main                    // -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   // @main
// %bb.0:
	sub	sp, sp, #32             // =32
	stp	x29, x30, [sp, #16]     // 16-byte Folded Spill
	add	x29, sp, #16            // =16
	mov	w8, wzr
	stur	wzr, [x29, #-4]
	ldur	w0, [x29, #-4]
	str	w8, [sp, #8]            // 4-byte Folded Spill
	bl	add
	stur	w0, [x29, #-4]
	ldr	w0, [sp, #8]            // 4-byte Folded Reload
	ldp	x29, x30, [sp, #16]     // 16-byte Folded Reload
	add	sp, sp, #32             // =32
	ret
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        // -- End function
	.ident	"clang version 10.0.1 (https://github.com/termux/termux-packages 6c2f9eab313cd099ce3cb97038f4ec27735a742f)"
	.section	".note.GNU-stack","",@progbits
