.global _start
@ .equ X, 0
@ .equ A, 0
@ .equ B, 1

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
			
            addgt r7, r6, r5
            moveq r6, r5
            moveq r7, r6
            addlt r6, r5, r7
            mla r7, r7, r6, r7 @B = B + B*A        
            add r5, r5, #1
            b while
endw:       
	
	