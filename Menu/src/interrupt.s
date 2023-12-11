.global .interrupt_setup
.type .interrupt_setup, %function
.global .irq_handler
.type .irq_handler, %function

/* CPSR */
.equ CPSR_I,   0x80
.equ CPSR_F,   0x40
.equ CPSR_IRQ, 0x12
.equ CPSR_USR, 0x10
.equ CPSR_FIQ, 0x11
.equ CPSR_SVC, 0x13
.equ CPSR_ABT, 0x17
.equ CPSR_UND, 0x1B
.equ CPSR_SYS, 0x1F



/*******************************
Stack
/*******************************/
.set StackModeSize,  0x100

.equ StackUSR, (_stack_end - 0*StackModeSize)
.equ StackFIQ, (_stack_end - 1*StackModeSize)
.equ StackIRQ, (_stack_end - 2*StackModeSize)
.equ StackSVC, (_stack_end - 3*StackModeSize)
.equ StackABT, (_stack_end - 4*StackModeSize)
.equ StackUND, (_stack_end - 5*StackModeSize)
.equ StackSYS, (_stack_end - 6*StackModeSize)


.interrupt_setup:
    stmfd sp!, {r0-r12, lr}     // save registers

     /* init */
    mrs r0, cpsr
    bic r0, r0, #0x1F            // clear mode bits
    orr r0, r0, #CPSR_SVC        // set SVC mode
    orr r0, r0, #(CPSR_F | CPSR_I)        // disable FIQ and IRQ
    msr cpsr, r0


   /* Stack setup */
    mov r0, #(CPSR_I | CPSR_F) | CPSR_SVC
    msr cpsr_c, r0
    ldr sp,=StackSVC
  
    mov r0, #(CPSR_I | CPSR_F) | CPSR_IRQ
    msr cpsr_c, r0
    ldr sp,=StackIRQ

    mov r0, #(CPSR_I | CPSR_F) | CPSR_FIQ
    msr cpsr_c, r0
    ldr sp,=StackFIQ

    mov r0, #(CPSR_I | CPSR_F) | CPSR_UND
    msr cpsr_c, r0
    ldr sp,=StackUND

    mov r0, #(CPSR_I | CPSR_F) | CPSR_ABT
    msr cpsr_c, r0
    ldr sp,=StackABT

    mov r0, #(CPSR_I | CPSR_F) | CPSR_SYS
    msr cpsr_c, r0
    ldr sp,=StackSYS

    //   mov r0, #(CPSR_I | CPSR_F) | CPSR_USR
    mov r0, # CPSR_USR
    msr cpsr_c, r0
    ldr sp,=StackUSR

    ldmfd sp!, {r0-r12, lr}     // restore registers
    bx lr

.irq_handler:
        stmfd sp!, {r0-r2, r11, lr}
        mrs r11, spsr
        
        ldr r0, =interrupt
        bl .print_string

 	/* Interrupt Source */
	ldr r0,=INTC_BASE
	ldr r1, [r0, #0x40]
 
	and r1,r1, #0x7f // receive irq_number

        /* GPIO 1A*/
        cmp r1, #98
        bleq .gpio_isr_handler
        
        /* RTC */
        cmp r1, #75
        bleq .rtc_isr

        /* new IRQ */
        ldr r0, =INTC_BASE 
        ldr r1, =0x1
        str r1, [r0, #0x48]

        /*Data Sync Barrier */
	dsb
        msr spsr, r11
        ldmfd sp!, {r0-r2, r11, pc}^

.section .rodata
.align 4

interrupt: .asciz "interrupt process!\n"
