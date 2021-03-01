	.text
	.file	"foo.c"
	.globl	add                     // -- Begin function add
	.p2align	2
	.type	add,@function
add:                                    // @add
// %bb.0:
	sub	sp, sp, #16             // =16
	str	w0, [sp, #12]
	str	w1, [sp, #8]
	ldr	w8, [sp, #12]
	ldr	w9, [sp, #8]
	add	w0, w8, w9
	add	sp, sp, #16             // =16
	ret
.Lfunc_end0:
	.size	add, .Lfunc_end0-add
                                        // -- End function
	.globl	sub                     // -- Begin function sub
	.p2align	2
	.type	sub,@function
sub:                                    // @sub
// %bb.0:
	sub	sp, sp, #16             // =16
	str	w0, [sp, #12]
	str	w1, [sp, #8]
	ldr	w8, [sp, #12]
	ldr	w9, [sp, #8]
	subs	w0, w8, w9
	add	sp, sp, #16             // =16
	ret
.Lfunc_end1:
	.size	sub, .Lfunc_end1-sub
                                        // -- End function
	.ident	"clang version 10.0.1 (https://github.com/termux/termux-packages 6c2f9eab313cd099ce3cb97038f4ec27735a742f)"
	.section	".note.GNU-stack","",@progbits
