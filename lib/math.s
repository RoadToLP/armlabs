#include <math.h>
.include "./asm/macro.s"
//pow - return power of integer
        .globl pow
        .p2align 2
        .type pow, @function
pow:
        PUSHTEMP
        MOV     X19, X0
        MOV     X20, X1
        DEC     X20
.pow_0:
        MUL     X19, X19, X0
        DEC     X20
        CMP     X20, #0
        BNE     .pow_0
        MOV     X0, X19
        POPTEMP
        RET
.Lfunc_end6:
        .size pow, .Lfunc_end6-pow
