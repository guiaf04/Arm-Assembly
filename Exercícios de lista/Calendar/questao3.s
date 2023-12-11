.global _start

_start:

    mov r0, #253  @n
    mov r1, #1    @day
    mov r2, #1    @month
    ldr r3, =2023 @year
    
main_loop:
	ldr r6, =365
        cmp r0, r6
        bgt end
for:    
	cmp r0, #0
        beq endf

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
        addeq r2, r2, #1
        moveq r1, #0
        b end_switch

days_28:
        cmp r1, #28
        addeq r2, r2, #1
        moveq r1, #0
        b end_switch

end_switch:
        add r1,r1 ,#1
        sub r0, r0, #1
        b for
endf:
       

end:  
        b end

