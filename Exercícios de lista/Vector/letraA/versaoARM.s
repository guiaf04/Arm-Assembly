.global _start

_start:

    mov r0, #10     @length of array
    ldr r1, =array1 @address of array1
    ldr r2, =array2 @address of array2
    ldr r3, =result @address of result
    mov r4, #0      @auxiliary register
    
main_loop:

for:    cmp r0, #0
        beq end

        ldr r5, [r1], #4 @load array1 element
        ldr r6, [r2], #4 @load array2 element
        add r4, r5, r6  @add array1 and array2 elements
        str r4, [r3], #4 @store result
        sub r0, r0, #1  @decrement counter
        b for

end:  
        b end

.data
array1: .word 1,2,3,4,5,6,7,8,9,10
array2: .word 11,12,13,14,15,16,17,18,19,20
result: .word 0,0,0,0,0,0,0,0,0,0
