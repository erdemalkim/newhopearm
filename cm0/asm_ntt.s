.macro	montgomery 	help, q, rlog, input
	SUB \help,\q,#2
    MUL \help,\input
    AND \help,\rlog
    MUL \help,\q
    ADD \input,\help
    LSR \input,#18
.endm


.macro barrett input
	LSL r2,\input,#2
	ADD r2,\input	
    LSR r2,#16
	MUL r2,r7
    SUB \input,r2
.endm


.macro butterfly inc
	LDR r4,[r0]	
	UXTH r3,r4
	LSR r4,#16


	LDR r6,[r0,\inc] 
	UXTH r5,r6
	LSR r6,#16


	MOV r12,r3
	MOV r11,r4

	
	ADD r3,r5
    MOV r7,r14
    barrett r3


	ADD r4,r6		
    barrett r4


	LSL r4,#16
	ORR r3,r4
	STR r3,[r0]

	MOV r3,r12
	ADD r3,r8
	SUB r3,r5
	LDRH r2,[r1]
	MUL r3,r2

	MOV r5,#1
	LSL r5,#18
	SUB r5,#1

    montgomery r4,r7,r5,r3

	MOV r4,r11
	ADD r4,r8
	SUB r4,r6
	MUL r4,r2

    montgomery r2,r7,r5,r4

	LSL r4,#16
	ORR r3,r4
	STR r3,[r0,\inc] 
.endm


.macro lazy_butterfly inc

	LDR r4,[r0]	
	UXTH r3,r4
	LSR r4,#16

    mov r5,\inc
	LDR r6,[r0,r5] 
	UXTH r5,r6
	LSR r6,#16


	MOV r2,r3
	MOV r11,r4
	ADD r2,r5
	ADD r4,r6		

	LSL r4,#16
	ORR r2,r4
	STR r2,[r0]

	ADD r3,r8
	SUB r3,r5
	LDRH r2,[r1]
	MUL r3,r2

	MOV r7,r12
    MOV r5,r14

    montgomery r4,r5,r7,r3

    MOV r4,r11
	ADD r4,r8
	SUB r4,r6
	MUL r4,r2

    montgomery r2,r5,r7,r4

    mov r5,\inc
	LSL r4,#16
	ORR r3,r4
	STR r3,[r0,r5] 



.endm

.macro doublefly
    LDR r4,[r0]	
	UXTH r3,r4
	LSR r4,#16
   
    MOV r2,r3
    ADD r3,r4
	MOV r12,r3

    ADD r2,r8
    SUB r2,r4

    mov r5,r9
    sub r7,r1,r5
    LSL r7,#1
    ADD r5,r7

    LDR r7,[r5]
    UXTH r5,r7
    LSR r7,#16

    MUL r2,r5

	MOV r4,r10
    MOV r3,r14

    montgomery r6,r3,r4,r2


    MOV r11,r2
        
    
	LDR r6,[r0,#4]
	UXTH r5,r6
	LSR r6,#16




    MOV r2,r5
    
    ADD r5,r6
    
    ADD r2,r8
    SUB r6,r2,r6
    MUL r6,r7

    montgomery r7,r3,r4,r6

    MOV r7,r3
    MOV r4,r11
    MOV r3,r12

	
	ADD r3,r5
    barrett r3


	ADD r4,r6		
    barrett r4


	LSL r4,#16
	ORR r3,r4
	STR r3,[r0]

	MOV r3,r12

	ADD r3,r8

	SUB r3,r5


	LDRH r2,[r1]


	MUL r3,r2

	MOV r5,r10

    
    montgomery r4,r7,r5,r3

	MOV r4,r11

	ADD r4,r8

	SUB r4,r6

	MUL r4,r2

    montgomery r2,r7,r5,r4

	LSL r4,#16
	ORR r3,r4
	STR r3,[r0,#4] 
.endm



@----------------------------------------------------------------------------
@
@ void asm_ntt(uint16_t* poly, const uint16_t* omegas);
@
.align 2    
.global	asm_ntt
.type	asm_ntt, %function
asm_ntt:
	push {r4-r7,lr}
    mov r4,r8
    mov r5,r9
    mov r6,r10
    mov r7,r11
    push {r4-r7}
    mov r4,r12
    mov r5,r14
    push {r4,r5}


    MOV r4,#3
    LSL r4,#12
    ADD r4,#1
	MOV r14,r4
    LSL r3,r4,#2
    ADD r4,r3
	MOV r8,r4
    MOV r4,#1
    LSL r4,#18
    SUB r4,#1
	MOV r10,r4


	MOV r9,r1
		

	MOV r4,#1
    LSL  r4,#9
        
	ADD r1,r4

	LSL r4,#2

    ADD r0,r4
		
	



nttloop:
    SUB r1,#2
	SUB r0,#8
	

	doublefly 


	CMP r1,r9
	BGT nttloop


    
		
    MOV r7,#0
	MOV r12,r7

outll2:
    MOV r4,#1
    LSL r4,#8
	ADD r1,r4

	LSL r4,#3 
		
	ADD r4,r12
	ADD r0,r4


 

l2loop:

    SUB r1,#2
	SUB r0,#16	
	

	LDR r4,[r0]	
	UXTH r3,r4
	LSR r4,#16
	LDR r6,[r0,#8]
	UXTH r5,r6
	LSR r6,#16


	MOV r2,r3
	MOV r11,r4


	ADD r2,r5

	ADD r4,r6		



	LSL r4,#16
	ORR r2,r4
	STR r2,[r0]


	ADD r3,r8

	SUB r3,r5


	LDRH r2,[r1]

	MUL r3,r2


	MOV r7,r10
    MOV r5,r14


    montgomery r4,r5,r7,r3


	MOV r4,r11

	ADD r4,r8

	SUB r4,r6

	MUL r4,r2


    montgomery r2,r5,r7,r4

	LSL r4,#16
	ORR r3,r4
	STR r3,[r0,#8] 


	CMP r1,r9
	BGT l2loop


	MOV r5,r12
	SUB r0,r5
	ADD r5,#4
	MOV r12,r5


	CMP r5,#4	
	BLE outll2


    nop

        	
    MOV r7,#0
	MOV r10,r7

outll3:

	MOV r4,#128
    ADD r1,r4

    LSL r4,#4
    ADD r4,r10
    ADD r0,r4

	

l3loop:

    SUB r1,#2
	SUB r0,#32	
	

    butterfly #16
	

	CMP r1,r9
	BGT l3loop

    MOV r3,r10
	SUB r0,r3
	ADD r3,#4
	MOV r10,r3

	CMP r3,#12
	BLE outll3

    MOV r12,r5


	nop
    
		
    MOV r7,#0
	MOV r10,r7

outll4:
	MOV r4,#64 
	ADD r1,r4

	LSL r4,#5 
		
	ADD r4,r10
	ADD r0,r4


 

l4loop:

    SUB r1,#2
	SUB r0,#64	
	
    lazy_butterfly #32
	CMP r1,r9
	BGT l4loop


	MOV r5,r10
	SUB r0,r5
	ADD r5,#4
	MOV r10,r5


	CMP r5,#28	
	BLE outll4




	nop
		
        MOV r7,#0
	MOV r10,r7

outll5:
	MOV r4,#32
	ADD r1,r4

	LSL r4,#6
		
	
	ADD r4,r10
	ADD r0,r4



l5loop:
    SUB r1,#2
	SUB r0,#128	

    butterfly #64


	CMP r1,r9
	BGT l5loop


	MOV r3,r10
	SUB r0,r3
	ADD r3,#4
	MOV r10,r3


	CMP r3,#60
	BLE outll5


    MOV r12,r5

	nop
		
    MOV r7,#0
	MOV r10,r7

outll6:
	MOV r4,#16 
	ADD r1,r4

	LSL r4,#7 
		
	ADD r4,r10
	ADD r0,r4


 

l6loop:

	SUB r1,#2
    MOV r5,#128
    LSL r6,r5,#1
	SUB r0,r6	
	
    lazy_butterfly #128
    

	CMP r1,r9
	BGT l6loop


	MOV r7,r10
	SUB r0,r7
	ADD r7,#4
	MOV r10,r7


	CMP r7,#124	
	BLE outll6


		
    MOV r7,#0
	MOV r10,r7

outll7:
	MOV r4,#8
	ADD r1,r4

	LSL r4,#8
		
	
	ADD r4,r10
	ADD r0,r4



l7loop:

    SUB r1,#2
    MOV r5,#1
    LSL r5,#8
    LSL r6,r5,#1
	SUB r0,r6	
	
	
	LDR r4,[r0]	
	UXTH r3,r4
	LSR r4,#16

	LDR r6,[r0,r5] 
	UXTH r5,r6
	LSR r6,#16


	MOV r11,r3
	

	
	ADD r3,r5

    

    MOV r7,r14

    barrett r3

    MOV r12,r4
	ADD r4,r6		

    barrett r4


	LSL r4,#16
	ORR r3,r4
	STR r3,[r0]

	MOV r3,r11

	ADD r3,r8

	SUB r3,r5


	LDRH r2,[r1]

	MUL r3,r2


	MOV r5,#1
	LSL r5,#18
	SUB r5,#1


    montgomery r4,r7,r5,r3


	MOV r4,r12

	ADD r4,r8

	SUB r4,r6

	MUL r4,r2

    montgomery r2,r7,r5,r4


	LSL r4,#16
	ORR r3,r4
    MOV r7,#1
    LSL r7,#8
	STR r3,[r0,r7] 


	CMP r1,r9
	BGT l7loop


	MOV r7,r10
	SUB r0,r7
	ADD r7,#4
	MOV r10,r7



	CMP r7,#252
	BLE outll7

    MOV r12,r5

	nop
		
    MOV r7,#0
	MOV r10,r7

outll8:
	MOV r4,#4 
	ADD r1,r4

	LSL r4,#9 
		
	ADD r4,r10
	ADD r0,r4


 

l8loop:

    SUB r1,#2
    MOV r5,#1
    LSL r5,#9
    LSL r6,r5,#1
	SUB r0,r6	
	
	LDR r4,[r0]	
	UXTH r3,r4
	LSR r4,#16


	LDR r6,[r0,r5] 
	UXTH r5,r6
	LSR r6,#16


	MOV r2,r3
	MOV r11,r4


	ADD r2,r5

	ADD r4,r6		

	

	LSL r4,#16
	ORR r2,r4
	STR r2,[r0]

	ADD r3,r8

	SUB r3,r5


	LDRH r2,[r1]

	MUL r3,r2

	MOV r7,r12
    MOV r5,r14

    montgomery r4,r5,r7,r3


	MOV r4,r11

	ADD r4,r8

	SUB r4,r6

	MUL r4,r2

    montgomery r2,r5,r7,r4

	LSL r4,#16
	ORR r3,r4
    MOV r5,#1
    LSL r5,#9
	STR r3,[r0,r5] 


	CMP r1,r9
	BGT l8loop


	MOV r7,r10
	SUB r0,r7
	ADD r7,#4
	MOV r10,r7


    SUB r5,#4
	CMP r7,r5
	BLE outll8


    LDR r7,=0x3fc
    MOV r10,r0
    ADD r0,r7

outll9:
	

	
	LDR r4,[r0]	
	UXTH r3,r4
	LSR r4,#16

    MOV r5,#1
    LSL r5,#10
	LDR r6,[r0,r5] 
	UXTH r5,r6
	LSR r6,#16


	MOV r9,r3
	MOV r11,r4

	
	ADD r3,r5

    MOV r7,r14

    barrett r3
	ADD r4,r6		
    barrett r4


	LSL r4,#16
	ORR r3,r4
	STR r3,[r0]

	MOV r3,r9

	ADD r3,r8

	SUB r3,r5	

    barrett r3


	MOV r4,r11

	ADD r4,r8

	SUB r4,r6

    barrett r4
    


	LSL r4,#16
	ORR r3,r4
    MOV r7,#1
    LSL r7,#10
	STR r3,[r0,r7]


	SUB r0,#4
    CMP r0,r10

	BGE outll9


endntt:
    pop {r4,r5}
    mov r12,r4
    mov r14,r5


    pop {r4-r7}
    mov r8,r4
    mov r9,r5
    mov r10,r6
    mov r11,r7

	pop {r4-r7,pc}
	bx lr


@----------------------------------------------------------------------------
@
@ void asm_mulcoef_otf(uint16_t* poly, const uint16_t* factors);
@

.global	asm_mulcoef_otf
.type	asm_mulcoef_otf, %function
asm_mulcoef_otf:
	push {r4-r7,lr}
    mov r3,r8
    mov r4,r9
    mov r5,r10
    mov r6,r11
    mov r7,r12
    push {r3-r7}
    

    MOV r4,#3
    LSL r4,#12
    ADD r4,#1
	MOV r9,r4

    MOV r4,#1
    LSL r4,#18
    SUB r4,#1
	MOV r10,r4
    
    mov r8,r0
    mov r4,#1
    lsl r4,#10
    add r8,r4

    mov r11,r1

loopmcotf:
    mov r12,r0

    ldm r0,{r2,r3}
    ldm r1,{r4,r5}

	UXTH r6,r2
	LSR r2,#16

	UXTH r7,r4
	LSR r4,#16

    mul r6,r7
    mul r2,r4

    mov r4,r10
    mov r0,r9

    montgomery 	r7, r0, r4, r6
    montgomery 	r7, r0, r4, r2

    lsl r2,#16
    orr r2,r6


	UXTH r6,r3
	LSR r3,#16

	UXTH r7,r5
	LSR r5,#16

    mul r6,r7
    mul r3,r5


    montgomery 	r7, r0, r4, r6
    montgomery 	r7, r0, r4, r3

    lsl r3,#16
    orr r3,r6

    mov r0,r12

    stm r0, {r2,r3}
            
    cmp r0,r8
    blt loopmcotf

@end first loop


    mov r1,r11

    mov r4,#1
    lsl r4,#10 
    add r8,r4

loopmc1:
    mov r12,r0

    ldm r0,{r2,r3}
    ldm r1,{r4,r5}

	UXTH r6,r2
	LSR r2,#16

	UXTH r7,r4
	LSR r4,#16

    mul r6,r7
    mul r2,r4

    mov r0,#7
    mul r6,r0
    mul r2,r0

    mov r4,r10
    mov r0,r9

    montgomery 	r7, r0, r4, r6
    montgomery 	r7, r0, r4, r2

    lsl r2,#16
    orr r2,r6


	UXTH r6,r3
	LSR r3,#16

	UXTH r7,r5
	LSR r5,#16
    


    mul r6,r7
    mul r3,r5

    mov r0,#7
    mul r6,r0
    mul r3,r0

    mov r0,r9

    montgomery 	r7, r0, r4, r6
    montgomery 	r7, r0, r4, r3

    lsl r3,#16
    orr r3,r6

    mov r0,r12

    stm r0, {r2,r3}
            
    cmp r0,r8
    blt loopmc1

    pop {r3-r7}

    mov r8,r3
    mov r9,r4
    mov r10,r5
    mov r11,r6
    mov r12,r7

	pop {r4-r7,pc}


@----------------------------------------------------------------------------
@
@ void asm_mulcoef(uint16_t* poly, const uint16_t* factors);
@

.global	asm_mulcoef
.type	asm_mulcoef, %function
asm_mulcoef:
	push {r4-r7,lr}
    mov r4,r8
    mov r5,r9
    mov r6,r10
    mov r7,r12
    push {r4-r7}
    

    MOV r4,#3
    LSL r4,#12
    ADD r4,#1
	MOV r9,r4

    MOV r4,#1
    LSL r4,#18
    SUB r4,#1
	MOV r10,r4
    
    mov r8,r0
    mov r4,#1
    lsl r4,#11 
    add r8,r4

loopmc:
    mov r12,r0

    ldm r0,{r2,r3}
    ldm r1,{r4,r5}

	UXTH r6,r2
	LSR r2,#16

	UXTH r7,r4
	LSR r4,#16

    mul r6,r7
    mul r2,r4

    mov r4,r10
    mov r0,r9

    montgomery 	r7, r0, r4, r6
    montgomery 	r7, r0, r4, r2

    lsl r2,#16
    orr r2,r6


	UXTH r6,r3
	LSR r3,#16

	UXTH r7,r5
	LSR r5,#16

    mul r6,r7
    mul r3,r5


    montgomery 	r7, r0, r4, r6
    montgomery 	r7, r0, r4, r3

    lsl r3,#16
    orr r3,r6

    mov r0,r12

    stm r0, {r2,r3}
            
    cmp r0,r8
    blt loopmc

    pop {r4-r7}
    mov r8,r4
    mov r9,r5
    mov r10,r6
    mov r12,r7

	pop {r4-r7,pc}


/* 
**************************************************************
The following functions are just for speed measuring purposes. 
**************************************************************
*/


.global	test_butterfly
.type	test_butterfly, %function
test_butterfly:
	push {r4-r7,lr}
    mov r4,r8
    mov r5,r11
    mov r6,r12
    mov r7,r14
    push {r4-r7}

    
    butterfly #16

    pop {r4-r7}
    mov r8,r4
    mov r11,r5
    mov r12,r6
    mov r14,r7

	pop {r4-r7,pc}


.global	test_lazy_butterfly
.type	test_lazy_butterfly, %function
test_lazy_butterfly:
	push {r4-r7,lr}
    mov r4,r8
    mov r5,r11
    mov r6,r12
    mov r7,r14
    push {r4-r7}


    lazy_butterfly #16
    
    pop {r4-r7}
    mov r8,r4
    mov r11,r5
    mov r12,r6
    mov r14,r7

	pop {r4-r7,pc}



.global	test_doublefly
.type	test_doublefly, %function
test_doublefly:
	push {r4-r7,lr}
    mov r3,r9
    mov r4,r8
    mov r5,r11
    mov r6,r12
    mov r7,r14
    push {r3-r7}

    mov r9,r1
    doublefly
    
    pop {r3-r7}
    mov r9,r3
    mov r8,r4
    mov r11,r5
    mov r12,r6
    mov r14,r7

	pop {r4-r7,pc}





