	.text
	.file	"loop.c"
	.globl	main                    // -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   // @main
// %bb.0:
	sub	sp, sp, #16             // =16
	str	wzr, [sp, #12]
	str	wzr, [sp, #8]
.LBB0_1:                                // =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #8]
	cmp	w8, #10                 // =10
	b.ge	.LBB0_4
// %bb.2:                               //   in Loop: Header=BB0_1 Depth=1
// %bb.3:                               //   in Loop: Header=BB0_1 Depth=1
	ldr	w8, [sp, #8]
	add	w8, w8, #1              // =1
	str	w8, [sp, #8]
	b	.LBB0_1
.LBB0_4:
	ldr	w0, [sp, #12]
	add	sp, sp, #16             // =16
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        // -- End function
	.ident	"clang version 10.0.1 (https://github.com/termux/termux-packages 6c2f9eab313cd099ce3cb97038f4ec27735a742f)"
	.section	".note.GNU-stack","",@progbits