/* gpio */
.equ GPIO1_OE,				0x4804C134
.equ GPIO1_SETDATAOUT,		0x4804C194
.equ GPIO1_CLEARDATAOUT,	0x4804C190	

/* Clock TRM 8.1.12.1 */
.equ CM_PER_GPIO1_CLKCTRL,	0x44e000AC 

/*Módulo de Controle */
.equ CNTMDL_BASE,       	0x44E10854

/*CONTROL MODULE*/
.equ GPIO2_RXD0,                0x990

/* cpsr */
.equ CPSR_I,	0x80
.equ CPSR_F,	0x40
.equ CPSR_IRQ,	0x12
.equ CPSR_USR,	0x10
.equ CPSR_FIQ,	0x11
.equ CPSR_SVC,	0x13
.equ CPSR_ABT,	0x17
.equ CPSR_UND,	0x18
.equ CPSR_SYS,	0x1F

/* Watch Dog Timer */
.equ WDT_BASE, 0x44E35000

/* UART */
.equ UART0_BASE, 0x44E09000

/* init */
_start:
	mrs r0, cpsr
	bic r0, r0, #0x1F @ clear mode bits
	orr r0, r0, #0x13 @ set SVC mode
	orr r0, r0, #0xC0 @ disable FIQ and IRQ
	msr cpsr, r0
	
	bl .gpio_setup
	bl .disable_wdt

.main_loop:
	bl .hexa_terminal 
	bl .delay
    bl .led_hexa
	b .main_loop

.delay:
    stmfd sp!,{r1-r2,lr}
	ldr r1, =0x0fffffff
.wait:
    sub r1, r1, #1
    cmp r1, #0
    bne .wait
    ldmfd sp!,{r1-r2,lr}
	bx lr
	
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

//Imprime uma string até o '\0'
// R0 -> Endereço da string
/********************************************************/
.print_string:
    stmfd sp!,{r0-r2,lr}
    mov r1, r0
.print:
    ldrb r0,[r1],#1
    and r0, r0, #0xff
    cmp r0, #0
    beq .end_print
    bl .uart_putc

    adr r0, prox_linha
	bl .uart_putc

    b .print

.end_print:
    ldmfd sp!,{r0-r2,pc}
    bx lr
/********************************************************/


/******************************************************
contagem
********************************************************/
.hexa_terminal:
	adr r0, contagem
    stmfd sp!,{r0-r2,lr}
	bl .print_string
    ldmfd sp!,{r0-r2,pc}
	bx lr


/*******************************************************
print_hexa
*******************************************************/

.led_hexa:
	 	stmfd sp!,{r0-r2,lr}
		ldr r1, =(1<<21)
		ldr r2, =0xf
laço:
		ldr r0, =GPIO1_SETDATAOUT
		str r1, [r0]
		
		bl .delay
		
		ldr r0, =GPIO1_CLEARDATAOUT
		str r1, [r0]
		
		bl .delay
		
		add r1, r1, #0x200000
		
		sub r2, r2, #1
		cmp r2, #0
		bne laço
		ldmfd sp!,{r0-r2,pc}  
		bx lr
/******************************************************/

/***************************************/
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

contagem: .asciz "0123456789ABCDEF\n\r"
prox_linha: .asciz "\n\r"











