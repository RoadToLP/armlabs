.include "asm/macro.s"
//exit - exit
FUNCTION_DEFINE exit
exit:
        MOV     X8, #0x5d
        SVC     #0
        RET
FUNCTION_END	exit
