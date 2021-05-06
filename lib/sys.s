#include <sys.h>
//exit - exit
        .globl exit
        .p2align 2
        .type exit, @function
exit:
        MOV     X8, #0x5d
        SVC     #0
        RET
.Lfunc_end5:
        .size exit, .Lfunc_end5-exit
