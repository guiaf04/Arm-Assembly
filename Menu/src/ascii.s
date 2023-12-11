.global .int_to_ascii
.global .conv_ascii_int
.global .conv_ascii_hex
.global .hex_to_ascii
.global .dec_digit_to_ascii
.global .hex_digit_to_ascii
.global .converte_asc
.global div

.type .int_to_ascii, %function
.type .conv_ascii_int, %function
.type .conv_ascii_hex, %function
.type .hex_to_ascii, %function
.type .dec_digit_to_ascii, %function
.type .hex_digit_to_ascii, %function
.type .converte_asc, %function
.type div, %function

/********************************************************
Division
//Input  --> Num: R0, Den: R1 
//Output --> Quot: R0, Rem: R1
********************************************************/
div:
    stmfd sp!,{r2-r4,lr}
    mov r2, r0
    mov r3, r1
    mov r0, #0
div_loop:
    cmp r2,r3
    blt fim_div 
    sub r2, r2, r3
    add r0, r0, #1
    b div_loop
fim_div:
    mov r1, r2
    ldmfd sp!, {r2-r4, pc}
/********************************************************/

/********************************************************
Converte int to ascii e imprime
//Input  --> R0
********************************************************/
.int_to_ascii:
    stmfd sp!,{r0-r2,lr}
    mov r2, #0
0:
    mov r1, #10
    cmp r0, r1
    blt 1f
    bl div
    stmfd sp!,{r1}
    add r2, r2, #1
    b 0b
1:
    add r0, r0, #0x30
    bl .uart_putc
    cmp r2, #0
    ble 2f
    sub r2, r2, #1
    ldmfd sp!, {r0}    
    b 1b
2:
    ldmfd sp!, {r0-r2, pc}
/********************************************************
Converte ascii para int com o end no r1, tam no r2 e retorno em r0
********************************************************/
.conv_ascii_int:
    stmfd sp!,{r1-r4,lr}
    mov r4,#0
    mov r3,#10
    cmp r2,#0
    bne ok 
    b .fim_conv
    ok:
        ldrb r0,[r1],#1
        bl .convert_ascii_hex
        mul r4,r3
        add r4,r0
        sub r2,#1
        cmp r2,#0
        bne ok
    .fim_conv:
    mov r0,r4
    ldmfd sp!, {r1-r4, pc}
/********************************************************/
.global .convert_ascii_hex
.conv_ascii_hex:
    
    mov r0,r4
    ldmfd sp!, {r1-r4, pc}
    
//recebe o hexa/int 0-9 em asci_hexa em r0 e retorna o hexa em r0
.convert_ascii_hex:
stmfd sp!,{r1-r5,lr}
    and r0, r0, #0xff
    cmp r0,#'9'
    bgt maior
    sub r0,#'0'
    b fim_conv
    maior:
        sub r0,#87
    fim_conv:
   
ldmfd sp!,{r1-r5,pc}


/********************************************************/
.dec_digit_to_ascii:
	add r0,r0,#0x30
	bx lr


.hex_digit_to_ascii:
       stmfd sp!,{r0-r2,lr} 
       ldr r1, =ascii
       ldrb r0, [r1, r0]
       
       ldmfd sp!, {r0-r2, pc}
/********************************************************/

/********************************************************
Converte HEX para ASCCI
********************************************************/
.hex_to_ascii:
    stmfd sp!,{r0-r3,lr}
    mov r1, r0

    mov r0, #0
    mov r3, #28
    ldr r2, =ascii

ascii_loop:
    mov r0, r1, LSR r3
    and r0, r0, #0x0f 
    ldrb r0, [r2, r0]
    bl .uart_putc
    subs r3, r3, #4
    bne ascii_loop
    mov r0, r1
    and r0, r0, #0x0f 
    ldrb r0, [r2, r0]
    bl .uart_putc

    ldmfd sp!,{r0-r3,pc}

/*******************************************************/
//FUNÇÃO QUE CONVERTER ASCII PARA HEXADECIMAL E RETORNA EM R3
// r0 -> endereço do buffer
// r1 -> quantidade de números recebidos
// r3 -> retorno
.converte_asc:
    stmfd sp!,{r0,r1,r2,r4,lr}
    mov r3, #4
    sub r1, r1, #1
    mul r4, r1, r3

    add r0, #2 //adiciona 2 para n pegar o 0x
    mov r3, #0

loop_converte_asc_int: 
    ldrb r1, [r0], #1
    cmp r1, #0x3a
    blt numero
    cmp r1, #0x47
    blt maiscula
	cmp r1, #0x67
    blt minuscula

test_converte_asc_int:
	cmp r4, #-4
    beq end_converte_asc_int
	b loop_converte_asc_int

numero:
    sub r1, #0x30
    orr r3, r1, LSL r4
    sub r4, #4
    b test_converte_asc_int

maiscula:
    sub r1, #55
    orr r3, r1, LSL r4
    sub r4, #4
    b test_converte_asc_int

minuscula:
    sub r1, #87
    orr r3, r1, LSL r4
    sub r4, #4
    b test_converte_asc_int

end_converte_asc_int:
    /* ldr r0, =hello
    bl .print_string */
    ldmfd sp!,{r0,r1,r2,r4,pc}

.section .rodata
.align 4

ascii:                      .asciz "0123456789ABCDEF"
