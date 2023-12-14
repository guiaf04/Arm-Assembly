.equ INTC_BASE,            0x48200000
.equ INTC_SIR_IRQ,         0x48200040
.equ INTC_CONTROL,         0x48200048
.equ INTC_ILR,             0x48200100
.equ INTC_MIR_CLEAR2,      0x482000C8


/* gpio */
.equ GPIO1_OE,				   0x4804C134
.equ GPIO1_SETDATAOUT,		0x4804C194
.equ GPIO1_CLEARDATAOUT,	0x4804C190	

/* Clock TRM 8.1.12.1 */
.equ CM_PER_GPIO1_CLKCTRL,	0x44e000AC
.equ CM_RTC_RTC_CLKCTRL,   0x44E00800
.equ CM_RTC_CLKSTCTRL,     0x44E00804 

/* RTC */
.equ RTC_BASE,             0x44E3E000
.equ SECONDS_REG,          0x44E3E000
.equ MINUTES_REG,          0x44E3E004
.equ HOURS_REG,            0x44E3E008
.equ RTC_CTRL_REG,         0x44E3E040
.equ RTC_STATUS_REG,       0x44E3E044
.equ RTC_INTERRUPTS_REG,   0x44E3E048
.equ RTC_OSC_REG,          0x44E3E054
.equ KICK0R,               0x44E3E06C
.equ KICK1R,               0x44E3E070

/*Módulo de Controle */
.equ CNTMDL_BASE,       	0x44E10854

/* Watch Dog Timer */
.equ WDT_BASE,             0x44E35000

/* UART */
.equ UART0_BASE,           0x44E09000

/* CPSR */
.equ CPSR_I,               0x80
.equ CPSR_F,               0x40
.equ CPSR_IRQ,             0x12
.equ CPSR_USR,             0x10
.equ CPSR_FIQ,             0x11
.equ CPSR_SVC,             0x13
.equ CPSR_ABT,             0x17
.equ CPSR_UND,             0x1B
.equ CPSR_SYS,             0x1F

/* Vector table */
_vector_table:
    ldr   pc, _reset     /* reset - _start           */
    ldr   pc, _undf      /* undefined - _undf        */
    ldr   pc, _swi       /* SWI - _swi               */
    ldr   pc, _pabt      /* program abort - _pabt    */
    ldr   pc, _dabt      /* data abort - _dabt       */
    nop                  /* reserved                 */
    ldr   pc, _irq       /* IRQ - read the VIC       */
    ldr   pc, _fiq       /* FIQ - _fiq               */

_reset: .word _start
_undf:  .word 0x4030CE24 /* undefined               */
_swi:   .word 0x4030CE28 /* SWI                     */
_pabt:  .word 0x4030CE2C /* program abort           */
_dabt:  .word 0x4030CE30 /* data abort              */
         nop
_irq:   .word 0x4030CE38  /* IRQ                     */
_fiq:   .word 0x4030CE3C  /* FIQ                     */


/* Startup Code */
_start:

   /* Set V=0 in CP15 SCTRL register - for VBAR to point to vector */
   mrc    p15, 0, r0, c1, c0, 0    // Read CP15 SCTRL Register
   bic    r0, #(1 << 13)           // V = 0
   mcr    p15, 0, r0, c1, c0, 0    // Write CP15 SCTRL Register

   /* Set vector address in CP15 VBAR register */
   ldr     r0, =_vector_table
   mcr     p15, 0, r0, c12, c0, 0  //Set VBAR

   /* init */
   mrs r0, cpsr
   bic r0, r0, #0x1F            // clear mode bits
   orr r0, r0, #CPSR_SVC        // set SVC mode
   orr r0, r0, #(CPSR_F)        // disable FIQ
   and r0, r0, #~(CPSR_I)       // enable IRQ
   msr cpsr, r0


   /* IRQ Handler */
   ldr r0, =_irq
   ldr r1, =.irq_handler
   str r1, [r0]

   /* SWI Handler */
   ldr r0, _swi
   ldr r1, =.swi_handler
   str r1, [r0]
  	

   /* Hardware Setup */
   bl .gpio_setup
   bl .disable_wdt
   bl .rtc_setup
   bl .main


.main:
      bl .delay_1s
      bl .main

.rtc_setup:
   stmfd sp!,{r0-r1,lr}

    /*  Clock enable for RTC TRM 8.1.12.6.1 */
    ldr r0, =CM_RTC_CLKSTCTRL
    ldr r1, =0x2
    str r1, [r0]
    ldr r0, =CM_RTC_RTC_CLKCTRL
    str r1, [r0]

    /* Disable write protection TRM 20.3.5.23 e 20.3.5.24 */
    ldr r0, =RTC_BASE
    ldr r1, =0x83E70B13
    str r1, [r0, #0x6c]
    ldr r1, =0x95A4F1E0
    str r1, [r0, #0x70]
    
    /* Select external clock*/
    ldr r1, =0x48
    str r1, [r0, #0x54]


    /* Interrupt setup */
    ldr r1, =0x04     /* interrupt every second */
    //ldr r1, =0x05     /* interrupt every minute */
    //ldr r1, =0x06     /* interrupt every hour */
    str r1, [r0, #0x48]

    /* Enable RTC */
    ldr r0, =RTC_BASE
    ldr r1, =(1<<0)
    str r1, [r0, #0x40]  

    /*rtc irq setup */
.wait_rtc_update:
    ldr r1, [r0, #0x44]
    and r1, r1, #1
    cmp r1, #0
    bne .wait_rtc_update

    /* RTC Interrupt configured as IRQ Priority 0 */
    //RTC Interrupt number 75
    ldr r0, =INTC_ILR
    mov r1, #0    
    strb r1, [r0, #75] 


    /* Interrupt mask */
    ldr r0, =INTC_BASE
    mov r1,#(1<<11)  
    str r1, [r0, #0xc8] //(75 and 72--> Bit 11 do 3º registrador (MIR CLEAR2))

    
    /* Load context */	
    ldmfd sp!,{r0-r1,pc}
    bx lr

.gpio_setup:
    /* set clock for GPIO1, TRM 8.1.12.1.31 */
    ldr r0, =0x44e00000
    add r0, #0xAC
    mov r2, #1
    lsl r1, r2, #1
    lsl r3, r2, #18
    orr r1, r1, r3
    str r1, [r0]

    ldr r0, =CNTMDL_BASE
    mov r1, #7
    str r1, [r0]


    /* set pin 21 for output, led USR0, TRM 25.3.4.3 */

    ldr r0, =GPIO1_OE
    ldr r1, [r0]
    bic r1, r1, #(1<<21)
    bic r1, r1, #(1<<22)
    bic r1, r1, #(1<<23)
    bic r1, r1, #(1<<24)
    str r1, [r0]
    bx lr

.disable_wdt: 
    /* TRM 20.4.3.8 */
    stmfd sp!,{r0-r1,lr}
    ldr r0, =WDT_BASE
    
    ldr r1, =0xAAAA
    str r1, [r0, #0x48]
    bl .poll_wdt_write

    ldr r1, =0x5555
    str r1, [r0, #0x48]
    bl .poll_wdt_write

    ldmfd sp!,{r0-r1,pc}

.poll_wdt_write:
    ldr r1, [r0, #0x34]
    and r1, r1, #(1<<4)
    cmp r1, #0
    bne .poll_wdt_write
    bx lr

.irq_handler:
        stmfd sp!, {r0-r2, r11, lr}
        mrs r11, spsr
        
 	/* Interrupt Source */
	ldr r0,=INTC_BASE
	ldr r1, [r0, #0x40]

	and r1,r1, #0x7f // receive irq_number

	/* if rtc interrupt */
	cmp r1, #75  /* TRM 6.3 Table 6-1*/
	bleq .rtc_irq_delay

        /* new IRQ */
        ldr r0, =INTC_BASE 
        ldr r1, =0x1
        str r1, [r0, #0x48]

        /*Data Sync Barrier */
	dsb
        msr spsr, r11
        ldmfd sp!, {r0-r2, r11, pc}^

.swi_handler:
      stmfd sp!,{r0-r12,lr}
      ldr r0, [lr, #-4]
      bic r1, r0, #0xFF000000
      bl .gpio_handler
      ldmfd sp!,{r0-r12,pc}^


.rtc_irq_delay:
      stmfd sp!,{r0-r5,lr}
      ldr r1, =HOURS_REG
      ldr r2, =MINUTES_REG
      ldr r3, =SECONDS_REG

      // Hours dezenas
      ldr r0, [r1]
      lsl r0, r0, #4
      and r0, r0, #0x3
      add r0, r0, #0x30
      bl .uart_putc

      // Hours unidades
      ldr r0, [r1]
      and r0, r0, #0xF
      add r0, r0, #0x30
      bl .uart_putc

      // :
      mov r0, #58
      bl .uart_putc

      // Minutes dezenas
      ldr r0, [r2]
      lsl r0, r0, #4
      and r0, r0, #0x7
      add r0, r0, #0x30
      bl .uart_putc

      // Minutes unidades
      ldr r0, [r2]
      and r0, r0, #0xF
      add r0, r0, #0x30
      bl .uart_putc

      // :
      mov r0, #58
      bl .uart_putc

      // Seconds dezenas
      ldr r0, [r3]
      lsl r0, r0, #4
      and r0, r0, #0x7
      add r0, r0, #0x30
      bl .uart_putc

      // Seconds unidades
      ldr r0, [r3]
      and r0, r0, #0xF
      add r0, r0, #0x30
      bl .uart_putc

      // \r
      mov r0, #13
      bl .uart_putc

      ldmfd sp!,{r0-r5,pc}
      bx lr

.delay_1s:
    stmfd sp!,{r0-r2,lr}
    ldr  r0,=RTC_BASE
    ldrb r1, [r0, #0] //seconds
.wait_second:
    ldrb r2, [r0, #0] //seconds
    cmp r2, r1
    beq .wait_second
    ldmfd sp!,{r0-r2,pc}

.uart_putc:
   stmfd sp!,{r1-r2,lr}
   ldr     r1, =UART0_BASE

.wait_tx_fifo_empty:
   ldr r2, [r1, #0x14] 
   and r2, r2, #(1<<5)
   cmp r2, #0
   beq .wait_tx_fifo_empty

   strb    r0, [r1]
   ldmfd sp!,{r1-r2,pc}
   bx lr

.gpio_handler:
   stmfd sp!,{r0-r2,lr}

   ldr r0, =GPIO1_SETDATAOUT
   @ ldr r1, =0x1E00000
   ldr r1, =(1<<21)
   str r1, [r0]

   bl .delay_1s

   ldr r0, =GPIO1_CLEARDATAOUT
   @ ldr r1, =0x1E00000
   ldr r1, =(1<<21)
   str r1, [r0]
   bl .delay_1s   

   ldmfd sp!,{r0-r1,pc}
   bx lr   

/********************************************************/
.fiq_handler:
   b .      // infinite loop
/********************************************************/
.undefined_handler:
   b .     
/********************************************************/
@ .swi_handler:
@    b .
/********************************************************/
.prefetch_abort_handler:
   b .      
/********************************************************/
.data_abort_handler:
   b .      
/********************************************************/

