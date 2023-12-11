/**********************************************************************/
/*   This is a code which implement a menu that are used to call the  */
/*   functions of the Lab05 using the beaglebone black in assembly    */
/*   Made by Prof Thiago Werley and student Guilherme Araújo Floriano */
/*   Last version: 03/10/2023                                         */
/**********************************************************************/

/*For run this code, execute setenv ipaddr 10.4.1.2; setenv serverip 10.4.1.1; tftp 0x80000000 /tftpboot/startup.bin; go 0x80000000 */

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


.equ VECTOR_BASE, 0x4030CE00 // Vector Base on BBB

/* Data Section */
.section .data

/*Flag para ajudar a entender que a opção foi apertada e devemos voltar para o menu*/
flag_gpio: .word 0
.global flag_gpio 

.section .text,"ax"
         .code 32
         .align 4

/********************************************************/
/* Vector table */
/********************************************************/
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

.global _vector_table

/********************************************************/
/* Startup Code */
/********************************************************/
_start:
    
    @ /* Configure Interruption */     
    @ bl .interrupt_setup

    /* Configure CP15 */
    bl .cp15_configure

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

    /* Hardware setup */
    bl .disable_wdt

    /* GPIO setup */
    bl .gpio_setup

    bl .rtc_setup

/********************************************************/
/* Main Code */
/********************************************************/
.global .main_loop
.type .main_loop, %function
.main_loop:
    /* Call the menu prompt*/
    bl .print_menu

    /* Read the option */
    bl .menu

    ldr r0, =CRLF
    bl .print_string

    ldr r0, =dash
    bl .print_string

    /*Infinit loop */
    b .main_loop 

/* Read-Only Data Section */
.section .rodata
.align 4

CRLF:                       .asciz "\n\r"
dump_separator:             .asciz "  :  "
dash:                       .asciz "-------------------------\n\r"

.global CRLF

/* BSS Section */
.section .bss
.align 4

.equ BUFFER_SIZE, 16
_string1: .fill BUFFER_SIZE
_string2: .fill BUFFER_SIZE
n_str1: .fill 1
n_str2: .fill 1
