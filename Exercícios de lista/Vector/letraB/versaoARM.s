.global _start

_start:

    mov r0, #10         @length of array
    ldr r1, =array1     @address of array1
    mov r2, #0          @result
    ldr r3, [r1]        @biggest number
    ldr r4, [r1]	    @less number
    
main_loop:

for:    cmp r0, #0
        beq endf
		
		ldr r5, [r1] @aux
		
        cmp r3, r5
        ldrlt r3, [r1]

        cmp r4, r5
        ldrgt r4, [r1]

        sub r0, r0, #1  @decrement counter
        add r1, r1, #4  @increment array
        b for
		
endf:
        add r2, r3, r4  @add biggest and less number 

end:  
        b end

.data
array1: .word 1353,8242,2453,4004,4531,60,37,58,679,102
