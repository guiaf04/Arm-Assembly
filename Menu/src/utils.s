.global _check_sum
.global _memcmp_chksum
.global _memcmp
.global _sizeofString
.global .memory_clear
.global .memory_dump
.global check_sum
.global .memcmp_chksum
.global .memcmp

.type  _check_sum, %function
.type _memcmp_chksum, %function
.type _memcmp, %function
.type _sizeofString, %function
.type .memory_clear, %function
.type .memory_dump, %function
.type check_sum, %function
.type .memcmp_chksum, %function
.type .memcmp, %function                


//Receives: RO - Ponteiro para mem1
//Receives: R1 - quantidade de bytes
//Returns : R0 - soma de bytes
_check_sum:
    stmfd sp!,{r1-r3,lr}
	
    mov r2, r0
    mov r0, #0

0:  
	cmp r1,#0
    beq 1f
    ldrb r3, [r2], #1
    add r0,r0,r3
    sub r1,r1,#1
    b 0b
1:  
	
    ldmfd sp!,{r1-r3,pc}


//Para entrar nessa função mem1 e mem2 devem ter a mesma quantidade de bytes
//RO - Ponteiro para mem1
//R1 - ponteiro para mem2
//R2 - quantidade de bytes
//Retorno: R0 = 0 -> conteudos iguais
//Retorno: R0 != 0 -> conteudos diferentes
_memcmp_chksum:
	stmfd sp!,{r1-r4,lr}

	mov r4, r1 //Guardando o ponteiro para mem2
	
	mov r1, r2 //faz isso pois r1 serve como parâmetro de check_sum
	bl _check_sum
	
	mov r3, r0 //checksum da mem1, pois o resultado vem em r0
	
	mov r0, r4 //colocando ponteiro de mem2 em r0
	bl _check_sum //checksum da mem2
	
	sub r0, r3,r0 //Testando se o contéudo deles é igual, entretanto esse teste não leva em conta se as strings são um anagrama da outra
    
   	ldmfd sp!,{r1-r4,pc}


//RO - Ponteiro para mem1
//R1 - ponteiro para mem2
//R2 - quantidade de bytes
//Retorno: R0 = 0 -> conteudos iguais
//Retorno: R0 != 0 -> conteudos diferentes
_memcmp:
    stmfd sp!,{r1-r6,lr}

    mov r3, r0
    mov r4, r1 
    mov r0, r2
0:  
	cmp r2,#0
    beq 1f

	ldrb r5, [r3], #1
    ldrb r6, [r4], #1
   
    cmp r5, r6
    bne 1f
	sub r0,r0,#1
    sub r2,r2,#1
    b 0b
1:    
   ldmfd sp!,{r1-r6,pc}


//Receives: r0 -> ponteiro para string
//Retorno : r0 -> com a quantidade de caracteres
_sizeofString:
	stmfd sp!,{r1-r2, pc}

	mov r1, r0 	//Salvando ponteiro para string
	mov r0, #0
0:
	ldrb r2, [r1], #1 	//r2 ficará recebendo bytes até que chegue em \0
	cmp r2, #'\0'
	beq 1f
	add r0, #1
	b 0b
1:
	ldmfd sp!,{r1-r2, lr}


string2: .asciz "123"
  

/********************************************************
Limpa memória
R0-> Endereço
R1-> Tamanho
/********************************************************/
.memory_clear:
    stmfd sp!,{r0-r2,lr}
    add     r1, r1, r0
    mov     r2, #0
0:
    cmp     r0, r1
    strlt   r2, [r0], #4
    blt     0b
    ldmfd sp!,{r0-r2,pc}
/********************************************************/

/********************************************************
Memory Dump
------------
Imprime o conteúdo da memória.
R0 -> Endereço inicial
R1 -> Quantidade de endereços 
********************************************************/
.memory_dump:
    stmfd sp!,{r0-r3,lr}
    mov r2, r0
    mov r3, r1

dump_loop:  
    // Imprime o endereço
    ldr r0, =hex_prefix
    mov r1, #2
    bl .print_nstring
    mov r0, r2
    bl .hex_to_ascii 

    // Imprime o separador '  :  '
    ldr r0, =dump_separator
    mov r1, #5
    bl .print_nstring

    // Imprime o conteúdo
    ldr r0, =hex_prefix
    mov r1, #2
    bl .print_nstring
    ldr r0, [r2], #4
    bl .hex_to_ascii
    
    //Salta linha
    ldr r0,=CRLF
    mov r1, #2
    bl .print_nstring

    //Verifica se já terminou
    subs r3, r3, #4
    bne dump_loop

    ldmfd sp!,{r0-r3,pc}




/********************************************************/
// Calcula o checksum de uma região
//RO - Ponteiro para mem1
//R1 - quantidade de bytes
//Retorno
// R0: Soma dos bytes (32 bits)
/********************************************************/
check_sum:
    stmfd sp!,{r1-r3,lr}
    
    mov r2, r0
    mov r0, #0

 0: cmp r1,#0
    beq 1f
    ldrb r3, [r2], #1
    add r0,r0,r3
    sub r1,r1,#1
    b 0b
1:    
    ldmfd sp!,{r1-r3,pc}
/********************************************************/

/********************************************************/
// Compara o checksum de duas regiões de memória
//RO - Ponteiro para mem1
//R1 - ponteiro para mem2
//R2 - quantidade de bytes
//Retorno
//R0 = 0 -> checksums iguais
//R0 != 0 -> checksums diferentes
/********************************************************/
.memcmp_chksum:
	stmfd sp!,{r1-r4,lr}

	mov r4, r1
	
	mov r1, r2
	bl check_sum
	
	mov r3, r0 //checksum da mem1
	
	mov r0, r4
	bl check_sum //checksum da mem2
	
	sub r0, r3,r0
    
   	ldmfd sp!,{r1-r4,pc}
/********************************************************/

/********************************************************/
// Compara o conteúdo de duas regiões de memória
//RO - Ponteiro para mem1
//R1 - ponteiro para mem2
//R2 - quantidade de bytes
//Retorno
//R0 = 0 -> conteudos iguais
//R0 != 0 -> conteudos diferentes
/********************************************************/
.memcmp:
    stmfd sp!,{r1-r6,lr}

    mov r3, r0
    mov r4, r1 
    mov r0, r2
 0: cmp r2,#0
    beq 1f
    ldrb r5, [r3], #1
    ldrb r6, [r4], #1
   
    cmp r5, r6
    bne 1f
	sub r0,r0,#1
    sub r2,r2,#1
    b 0b
1:    
   ldmfd sp!,{r1-r6,pc}
/********************************************************/

CRLF:                       .asciz "\n\r"
dump_separator:             .asciz "  :  "
hex_prefix:                 .asciz "0x"
