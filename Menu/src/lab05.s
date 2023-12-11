.global .menu
.global .Lab05
.global .read_lm35
.global .print_menu

.type .menu, %function
.type .Lab05, %function
.type .read_lm35, %function
.type .print_menu, %function


/*A function which just print the prompt of menu*/
.print_menu:
    stmfd sp!, {r0-r3, lr}
    ldr r0, =inicio
    bl .print_string
    ldr r0, =opcao1
    bl .print_string
    ldr r0, =opcao2
    bl .print_string
    ldr r0, =opcao3
    bl .print_string
    ldr r0, =opcao4
    bl .print_string
    ldr r0, =opcao5
    bl .print_string
    ldmfd sp!, {r0-r3, pc}
    bx lr

/*Funtion which read the option and compare*/
.menu:
    stmfd sp!,{r0-r10, lr}

    //lendo a primeira string e somando os bytes dela
    ldr r0, =_string1
    ldr r1, =n_str1
    bl .read_args  // r1 vai conter o contador de bytes da string lida

    mov r4, #5      // r4 - contador de opcoes
    mov r5, #0x31   // r5 - valor inicial do contador de opcoes (0x31 = 1 em ascii)

loop:

    ldr r0, =_string2
    mov r1, r5
    strb r1, [r0], #1
    ldr r2, =n_str2
    mov r1, #1
    strb r1, [r2], #1


    //compara conteúdo das strings
    ldr r0, =_string1
    ldr r1, =_string2
    ldr r3, =n_str1
    ldrb r2, [r3]
    bl _memcmp  //retorno em r0

    //se sao iguais
    cmp r0, #0
    beq .igual

    add r5, r5, #1
    sub r4, r4, #1
    cmp r4, #0
    bne loop

    b .diferente //caso nao tenha encontrado nenhuma string igual, sair do loop e ir para diferente

.Lab05:
    stmfd sp!, {r0-r3, lr}
    //lendo a primeira string e somando os bytes dela
    ldr r0, =primeira
    bl .print_string
    ldr r0, =_string1
    ldr r1, =n_str1
    bl .read_args  // r1 vai conter o contador de bytes da string lida 

    ldr r0, =CRLF
    bl .print_string

    ldr r0, =_string1
    ldr r2, =n_str1
    ldrb r1, [r2]
    bl _check_sum
    mov r3, r0  //r3 - guarda a soma de bytes da string 1
    ///////////////////////////////////////////

    //lendo a segunda string e somando os bytes dela
    ldr r0, =segunda
    bl .print_string
    ldr r0, =_string2
    ldr r1, =n_str2
    bl .read_args  // r1 vai conter o contador de bytes da string lida 

    ldr r0, =CRLF
    bl .print_string

    ldr r0, =_string2
    ldr r2, =n_str2
    ldrb r1, [r2]
    bl _check_sum // r0 - guarda a soma dos bytes da string 2
    //////////////////////////////////////////

    //comparar a quantidade de bytes das strings
    // se for diferente ja encerra o codigo
    cmp r3, r0
    bne .diferente

    //compara conteúdo das strings
    ldr r0, =_string1
    ldr r1, =_string2
    ldr r3, =n_str1
    ldrb r2, [r3]
    bl _memcmp  //retorno em r0

    //se sao iguais
    cmp r0, #0
    beq .igual

    //se sao diferentes
    b .diferente

.fim:
    ldmfd sp!, {r0-r10, pc}
    bx lr

.diferente:
    ldr r0, =invalid
    bl .print_string
    b .fim 

/*Pula para a função equivalente à opção*/
.igual:
    cmp r5, #0x31
    bleq .print_contagem_leds

    cmp r5, #0x32
    bleq .print_hello

    cmp r5, #0x33
    bleq .read_lm35

    cmp r5, #0x34
    bleq .print_time

    b .fim


/* Set up GPIO pin */
.read_lm35:
    stmfd sp!, {r0-r3, lr}
    // Set up ADC pin P9_40
        ldr r0, =0x44E10800 /* ADC base address */
        ldr r1, =0x0 /* Set ADC to read from AIN0 */
        str r1, [r0, #0x40] /* Write to step config register */
        mov r1, #0x1 /* Set start bit */
        str r1, [r0, #0x44] /* Write to control register */
    wait_for_conversion:
        ldr r6, =flag_gpio
        ldr r6, [r6]
        cmp r6, #1
        bleq end_lm
        ldr r1, [r0, #0x48] /* Read status register */
        tst r1, #0x8000 /* Check end of conversion bit */
        beq wait_for_conversion
        ldr r1, [r0, #0x4C] /* Read conversion result */
        ldr r2, =0xFFF /* Set maximum ADC value */
        udiv r1, r1, r2 /* Convert to voltage */
        mov r2, #1800 /* Set reference voltage to 1.8V */
        udiv r1, r1, r2 /* Convert to millivolts */
        mov r2, #10 /* Set scaling factor */
        mul r1, r1, r2 /* Scale to degrees Celsius */
        /* r1 now contains the temperature in degrees Celsius */

end_lm:
    mov r0, #0
    str r0, [r6]
    ldmfd sp!, {r0-r3, pc}
    bx lr

.section .rodata
.align 4

inicio:                      .asciz "\n\rSeja bem vindo! Escolha uma opcao para continuar\n\r"
opcao1:                      .asciz "1 - Contagem de LEDs\n\r"
opcao2:                      .asciz "2 - Hello World\n\r"
opcao3:                      .asciz "3 - Leitura do LM35\n\r"
opcao4:                      .asciz "4 - Timer\n\r"
opcao5:                      .asciz "5 - Sair\n\r"
primeira:                    .asciz "Digite a primeira string:\n\r"
segunda:                     .asciz "Digite a segunda string:\n\r"
iguais:                      .asciz "\n\rsao iguais\n\r"
invalid:                     .asciz "\n\rOpção Inválida, selecione uma das seguintes: \n\r"


/* Data Section */
.section .data
.align 4

/* BSS Section */
.section .bss
.align 4

.equ BUFFER_SIZE, 16
_string1: .fill BUFFER_SIZE
_string2: .fill BUFFER_SIZE
n_str1: .fill 1
n_str2: .fill 1

