.equ RTC_BASE, 0x44E3E000
.global .delay
.global .delay_1s
.type .delay, %function
.type .delay_1s, %function

/********************************************************
DELAY
********************************************************/
.delay:
    stmfd sp!,{r0-r2,lr}
    ldr r1, =0xfffffff
.wait:
    sub r1, r1, #0x1
    cmp r1, #0
    bne .wait
    ldmfd sp!,{r0-r2,pc}
    bx lr
/********************************************************/
.delay_1s:
    stmfd sp!,{r0-r2,lr}
    ldr  r0,=RTC_BASE
    ldrb r1, [r0, #0] //seconds
.wait_second:
    ldrb r2, [r0, #0] //seconds
    cmp r2, r1
    beq .wait_second
ldmfd sp!,{r0-r2,pc}
