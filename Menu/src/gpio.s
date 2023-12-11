.global .gpio_setup
.type .gpio_setup, %function

/* GPIO */
.equ GPIO1_OE, 0x4804C134
.equ GPIO1_SETDATAOUT, 0x4804C194
.equ GPIO1_CLEARDATAOUT, 0x4804C190
.equ GPIO1_IRQSTATUS_SET0, 0x4804C034
.equ GPIO1_RISINGDETECT, 0x4804C148
.equ GPIO1_IRQSTATUS_0,       0x4804C02c

.global GPIO1_CLEARDATAOUT

/* GPIO Clock Setup */
.equ CM_PER_GPIO1_CLKCTRL, 0x44e000AC


/*INTC */
.equ INTC_BASE,            0x48200000
.equ INTC_SIR_IRQ,         0x48200040
.equ INTC_CONTROL,         0x48200048
.equ INTC_ILR,             0x48200100
.equ INTC_MIR_CLEAR0,      0x48200088
.equ INTC_MIR_CLEAR1,      0x482000A8
.equ INTC_MIR_CLEAR2,      0x482000C8
.equ INTC_MIR_CLEAR3,      0x482000E8

/********************************************************
GPIO SETUP
********************************************************/
.gpio_setup:
    /* set clock for GPIO1, TRM 8.1.12.1.31 */
    ldr r0, =CM_PER_GPIO1_CLKCTRL
    ldr r1, =0x40002
    str r1, [r0]

    /* set pin 21 for output, led USR0, TRM 25.3.4.3 */
    ldr r0, =GPIO1_OE
    ldr r1, [r0]
    bic r1, r1, #(0xf<<21)
    str r1, [r0]

    /* set pin GPIO1_28 for output (Button) */
    ldr r0, =GPIO1_OE
    ldr r1, [r0]
    orr r1, r1, #(1<<28) 
    str r1, [r0]

    /* Set  GPIO1_28 for 1A innterruption*/
    ldr r0, =GPIO1_IRQSTATUS_SET0
    ldr r1, [r0]
    orr r1, r1, #(1<<28)
    str r1, [r0]

    ldr r0, =GPIO1_RISINGDETECT
    ldr r1, [r0]
    orr r1, r1, #(1<<28)
    str r1, [r0]
    
    /*Configure GPIO1A*/
    ldr r0, =INTC_MIR_CLEAR3
    mov r1, #(0x1<<2)
    str r1, [r0]

    bx lr
/********************************************************/

/********************************************************
Blink LED BBB
********************************************************/

.global .led_ON
.type .led_ON, %function
.led_ON:
stmfd sp!, {r0-r1, lr}
    ldr r0, =GPIO1_SETDATAOUT
    ldr r1, =(1<<21)
    str r1, [r0]
    ldmfd sp!, {r0-r1, pc}
    bx lr


.global .led_OFF
.type .led_OFF, %function
.led_OFF:
stmfd sp!, {r0-r1, lr}
    ldr r0, =GPIO1_CLEARDATAOUT
    ldr r1, =(1<<21)
    str r1, [r0]
    ldmfd sp!, {r0-r1, pc} 
    bx lr
    
.global .gpio_isr_handler
.type .gpio_isr_handler, %function    

.gpio_isr_handler:
    stmfd sp!, {r0-r1, lr}

    ldr r0, =GPIO1_IRQSTATUS_0
    mov r1, #0x10000000
    str r1, [r0]

    ldr r0, =GPIO1_CLEARDATAOUT
    ldr r1, =(0xf<<21)
    str r1, [r0]

    ldr r0, =flag_gpio
    mov r1, #1
    str r1, [r0]

    ldmfd sp!, {r0-r1, pc}    
    bx lr
