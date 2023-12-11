.global .print_string
.global .print_timer
.global .print_nstring
.global .print_hello
.global .print_contagem_leds
.global .read_args
.global .scanf

.type .print_string, %function
.type .print_timer, %function
.type .print_nstring, %function
.type .print_hello, %function
.type .print_contagem_leds, %function
.type .read_args, %function
.type .scanf, %function

/* GPIO */
.equ GPIO1_OE, 0x4804C134
.equ GPIO1_SETDATAOUT, 0x4804C194
.equ GPIO1_CLEARDATAOUT, 0x4804C190

/********************************************************
PRINTF 
********************************************************/
.global _printf
.type _printf, %function

_printf:
    ldr r12, =buffer_printf
    stmia r12!, {r4-r11, lr}  
    
    mov r4, r0
    mov r5, #0 
    
0:  ldrb r0, [r4], #1  
    cmp r0, #'%'
    beq 1f

    cmp r0, #0
    beq 3f

    bl .uart_putc
    b 0b

1:  add r5, r5, #1

    cmp r5, #1
    moveq r0, r1
    beq 2f

    cmp r5, #2
    moveq r0, r2
    beq 2f

    cmp r5, #3
    moveq r0, r3
    beq 2f

    ldmfd sp!, {r0}
  
2:
    ldrb r6, [r4], #1

    cmp r6, #'s'
    ldreq r7, =.print_string

    cmp r6, #'d'
    ldreq r7, =.int_to_ascii

    cmp r6, #'c'
    ldreq r7, =.uart_putc

    cmp r6, #'x'
    ldreq r7, =.hex_to_ascii

    blx r7
    b 0b

3:   
    ldmdb r12!, {r4-r11, pc}

//r0 -> endereço do buffer
//Sem retorno
.scanf:
    stmfd sp!,{r1-r2, pc}

    mov r1, r0
0:    
    bl .uart_getc
    cmp r0, #'\r' //r0 é retorno de uart_getc
    beq 1f
    str r1, [r0, r2] //r2 - offset
    b 0b

1:
    ldmfd sp!,{r1-r2, lr}


//********endereço em r0 e tamanho em r1**********
.read_args:
stmfd sp!,{r2-r5,lr}
    mov r2,#0
    mov r3,r0
    loop_arg:
        bl .uart_getc
        cmp r0,#'\r'
        beq fim_l1
        bl .uart_putc
        strb r0,[r3],#1
        add r2,#1
        b loop_arg
    fim_l1:
    strb r2,[r1],#1
ldmfd sp!,{r2-r5,pc}
/********************************************************/


/********************************************************
Imprime uma string até o '\0'
// R0 -> Endereço da string
/********************************************************/
_print_string:
.print_string:
    stmfd sp!,{r0-r2,lr}
    mov r1, r0
.print:
    ldrb r0,[r1],#1
    and r0, r0, #0xff
    cmp r0, #0
    beq .end_print
    bl .uart_putc
    b .print
    
.end_print:
    ldmfd sp!,{r0-r2,pc}
/********************************************************/
//PRINTAR TIMER 
/* RECEIVES : R12 - ENDEREÇO DO BUFFER */
.print_timer:
    stmfd sp!,{r0-r2, lr}
.prinTimer:
    ldrb r0,[r12],#1 //124 contém endereço da string
    and r0, r0, #0xff //Serve para identificar o \0
    cmp r0, #47
    beq .end_prinTimer
    bl .uart_putc
    b .prinTimer

.end_prinTimer:
    ldmfd sp!,{r0-r2,pc}


/********************************************************
Imprime n caracteres de uma string
// R0 -> Endereço da string R1-> Número de caracteres
/********************************************************/
.print_nstring:
    stmfd sp!,{r0-r2,lr}
    mov r2, r0
.print_n:
    ldrb r0,[r2],#1
    bl .uart_putc
    subs r1, r1, #1
    beq .end_print
    b .print_n
    
.end_print_n:
    ldmfd sp!,{r0-r2,pc}
    
/********************************************************/

.print_hello:
    stmfd sp!, {r0-r2, lr}
    ldr r0, =CRLF
    bl .print_string
    ldr r0, =hello
    bl .print_string
    ldmfd sp!, {r0-r2, pc}
    bx lr

.print_contagem_leds:
    stmfd sp!,{r0-r10,lr}
    ldr r0, =0x1
    ldr r2, =(1<<21)
    ldr r3, =0xf
laço:
    ldr r6, =flag_gpio  //verificação se a interrupção aconteceu
    ldr r6, [r6]
    cmp r6, #1
    beq end

    /*Print the value of sequence */
    bl .int_to_ascii

    bl .print_line_break

    /* Blink the led with the bin of sequence */
    ldr r1, =GPIO1_SETDATAOUT    
    str r2, [r1]
    bl .delay

    ldr r1, =GPIO1_CLEARDATAOUT
    str r2, [r1]
    bl .delay

    /* Increment the sequence */
    add r0, r0, #1
    add r2, r2, #0x200000
    sub r3, r3, #1

    cmp r3, #0
    bne laço
end:
    ldr r0, =GPIO1_CLEARDATAOUT
    ldr r1, =(1<<21)
    str r1, [r0]    

    ldr r0, =flag_gpio
    mov r1, #0
    str r1, [r0]
   
    ldmfd sp!,{r0-r10,pc}  
	bx lr

.print_line_break:
    stmfd sp!,{r0-r2,lr}
    ldr r0, =CRLF
    bl .print_string
    ldmfd sp!,{r0-r2,pc}
    bx lr

.section .rodata
.align 4    

hello: .asciz "Hello world!!!\n\r"
buffer_printf:              .skip 256 //ANALISAR
