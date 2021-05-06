#include <string.h>
#include <io.h>
.include "asm/macro.s"
//print - print a string to it's '\0'
        .globl print
        .p2align 2
        .type print, @function
print:
        PUSHTEMP
        MOV     X19, X0
        BL      strlen
        MOV     X2, X0
        MOV     X1, X19
        MOV     X0, #1
        MOV     X8, #0x40
        SVC     #0
        POPTEMP
        RET
.Lfunc_end4:
        .size print, .Lfunc_end4-print
