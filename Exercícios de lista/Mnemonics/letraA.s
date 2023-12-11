.global _start

_start:

    mrs r0, cpsr
	bic r0, r0, #0x1F @ clear mode bits
	orr r0, r0, #0x13 @ set SVC mode
	orr r0, r0, #0xC0 @ disable FIQ and IRQ
	msr cpsr, r0
    
main_loop:

            mov r5, #0 @ X
            mov r6, #0 @ A
            mov r7, #1 @ B
while:  
			cmp r5, #5
            bge endw

            cmp r5, #3
            ble if01
            add r7, r6, r5
			b elseif02
if01:       
            bne elseif01
            mov r6, r5
            mov r7, r6
			b elseif02
elseif01:   
            bge elseif02
            add r6, r5, r7
elseif02:   
            mla r7, r7, r6, r7 @B = B + B*A        
            add r5, r5, #1
            b while
endw:       
	
	