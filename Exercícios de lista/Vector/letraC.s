_start:

                ldr r0, =first
                mov r1, #10
                ldr r2, [r0]        @greater element of array
                ldr r3, [r0], #4    @lesser element of array
                mov r4, #0          @auxiliar

main_loop:
                bl .bigger_less_vector
                bl .end_loop


.bigger_less_vector:
                stmfd sp!, {lr}
loop:                    
                cmp r1, #0
                beq endf
                ldr r4, [r0]
                cmp r4, r2
                movgt r2, r4
                cmp r4, r3
                movlt r3, r4
                add r0, r0, #4
                sub r1, r1, #1
                b loop
endf:
                ldmfd sp!, {pc}
                bx lr

.end_loop:
                b .end_loop



.data
first:  .word 14, 10, 2, 35, 24, 51, 16, 37, 28, 19

