.global _start

_start:

    mov r0, #500  @n
    mov r1, #0    @day
    mov r2, #1    @month
    ldr r3, =2021 @year
    
main_loop:
        // Suponha que o dividendo esteja em R0 e o divisor em R1
		mov r6, #4
        mov r5, r3, LSR #2     // Divide o dividendo (R3) pelo divisor (R6) e coloca o resultado em R5
        mul  r7, r6, r5     // Multiplica o divisor (R6) pelo quociente (R5) e coloca o resultado em R7
        sub  r7, r3, r7     // Subtrai o resultado da multiplicação do dividendo (R3)

        // Agora, o valor em R7 contém o resto da divisão

        cmp r7, #0          @ano bissexto
        beq bissexto
        bne not_bissexto

not_bissexto:    
	cmp r0, #0
        beq end_not_bissexto

        cmp r2, #1
        beq days_31
        cmp r2, #2
        beq days_28
        cmp r2, #3
        beq days_31
        cmp r2, #4
        beq days_30
        cmp r2, #5
        beq days_31
        cmp r2, #6
        beq days_30
        cmp r2, #7
        beq days_31
        cmp r2, #8
        beq days_31
        cmp r2, #9
        beq days_30
        cmp r2, #10
        beq days_31
        cmp r2, #11
        beq days_30
        cmp r2, #12
        beq days_31

days_30:
        cmp r1, #30
        addeq r2, r2, #1
        moveq r1, #0
        b end_switch

days_31:
        cmp r1, #31
        bne end_switch
        cmp r2, #12
        beq dezembro
        add r2, r2, #1
        mov r1, #0
		b end_switch
dezembro:
		mov r1, #0
		add r3, r3, #1
		mov r2, #1
        b end_switch

days_28:
        cmp r1, #28
        addeq r2, r2, #1
        moveq r1, #0
        b end_switch

end_switch:
        add r1,r1 ,#1
        sub r0, r0, #1
        b not_bissexto

end_not_bissexto:
       b end

bissexto:
        cmp r0, #0
        beq end_bissexto

        cmp r2, #1
        beq days_31_bissexto
        cmp r2, #2
        beq days_29
        cmp r2, #3
        beq days_31_bissexto
        cmp r2, #4
        beq days_30_bissexto
        cmp r2, #5
        beq days_31_bissexto
        cmp r2, #6
        beq days_30_bissexto
        cmp r2, #7
        beq days_31_bissexto
        cmp r2, #8
        beq days_31_bissexto
        cmp r2, #9
        beq days_30_bissexto
        cmp r2, #10
        beq days_31_bissexto
        cmp r2, #11
        beq days_30_bissexto
        cmp r2, #12
        beq days_31_bissexto

days_29:
        cmp r1, #29
        addeq r2, r2, #1
        moveq r1, #0
        b end_switch_bissexto        

days_30_bissexto:
        cmp r1, #30
        addeq r2, r2, #1
        moveq r1, #0
        b end_switch_bissexto

days_31_bissexto:
        cmp r1, #31
		bne end_switch_bissexto
		cmp r2, #12
		beq dezembro_bissexto
        add r2, r2, #1
        mov r1, #0
		b end_switch_bissexto
dezembro_bissexto:
		mov r1, #0
		add r3, r3, #1
		mov r2, #1
        b end_switch_bissexto

end_switch_bissexto:
        add r1,r1 ,#1
        sub r0, r0, #1
        b bissexto

end_bissexto:
       b end                        

end:  
        b end

