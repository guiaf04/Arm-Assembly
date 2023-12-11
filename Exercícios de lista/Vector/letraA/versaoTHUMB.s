.global _start
_start:
	
	.global _start

_start:
	
	mrs r0, cpsr
	orr r0, r0, #0x10
	msr cpsr, r0
	
    mov r0, #10     @length of array
    ldr r1, =array1 @address of array1
    ldr r2, =array2 @address of array2
    ldr r3, =result @address of result
    mov r4, #0      @auxiliary register
    
main_loop:

for:    cmp r0, #0
        beq end

        ldr r5, [r1] @load array1 element
        ldr r6, [r2] @load array2 element
		mov r4, r5
        add r4, r6  @add array1 and array2 elements
        str r4, [r3] @store result
        sub r0, #1  @decrement counter
		add r1, #4
		add r2, #4
		add r3,#4
        b for

end:  
        b end

.data
array1: .word 1,2,3,4,5,6,7,8,9,10
array2: .word 11,12,13,14,15,16,17,18,19,20
result: .word 0,0,0,0,0,0,0,0,0,0
