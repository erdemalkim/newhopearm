
.macro	montgomery 	help, q, rlog, input
	SUB \help,\q,#2
    MUL \help,\input
    AND \help,\rlog
    MUL \help,\q
    ADD \input,\help
    LSR \input,#18
.endm

.macro barrett free,q,input
	LSL \free,\input,#2
	ADD \free,\input	
    LSR \free,#16
	MUL \free,\q
    SUB \input,\free
.endm



@----------------------------------------------------------------------------
@
@ void asm_poly_add(poly *r, poly *b);
@    


.global	asm_poly_add
.type	asm_poly_add, %function
asm_poly_add    :
    push {r4-r7,lr}
    mov r4,r8
    mov r5,r9
    push {r4,r5}
    MOV r4,#3
    LSL r4,#12
    ADD r4,#1
	MOV r9,r4

    mov r8,r0
    mov r2,#1
    lsl r2,#11
    add r8,r2
looppa:
    ldm r0,{r3,r4}
    ldm r1,{r5}
    sub r0,#8

	UXTH r6,r3
	LSR r3,#16

	UXTH r7,r5
	LSR r5,#16

    add r3,r5
    add r6,r7

    mov r5,r9

    barrett r7,r5,r3
    barrett r7,r5,r6

    lsl r3,#16
    orr r3,r6

    ldm r1,{r5}

	UXTH r6,r4
	LSR r4,#16

	UXTH r7,r5
	LSR r5,#16

    add r4,r5
    add r6,r7

    mov r5,r9

    barrett r7,r5,r4
    barrett r7,r5,r6

    lsl r4,#16
    orr r4,r6

    stm r0,{r3,r4}       


    cmp r0,r8
    BLT looppa
        
    pop {r4,r5}
    mov r8,r4
    mov r9,r5

	pop {r4-r7,pc}
	bx lr



@----------------------------------------------------------------------------
@
@ void asm_poly_pointwise(poly *r, poly *a, poly *b);
@    


.global	asm_poly_pointwise
.type	asm_poly_pointwise, %function
asm_poly_pointwise    :
    push {r4-r7,lr}
    mov r4,r8
    mov r5,r9
    mov r6,r10
    mov r7,r11
    push {r4-r7}

    MOV r4,#1
    LSL r4,#18
    SUB r4,#1
	MOV r11,r4

    mov r4,#24
    lsl r4,#7
    mov r3,#114
    orr r4,r3
    mov r10,r4

    MOV r4,#3
    LSL r4,#12
    ADD r4,#1
	MOV r9,r4

    mov r8,r0
    mov r4,#1
    lsl r4,#11
    add r8,r4
    
    
looppp:
    
    ldm r2,{r5}

    UXTH r4,r5
	LSR r5,#16


    mov r7, r10
    
    mul r4,r7
    mul r5,r7

    
    mov r6,r9
    mov r3,r11
    montgomery r7,r6,r3 r4
    montgomery r7,r6,r3 r5

    
    ldm r1,{r7}

    UXTH r3,r7
	LSR r7,#16
    
    mul r4,r3
    mul r5,r7

    mov r3,r11
    montgomery r7,r6,r3,r4
    montgomery r7,r6,r3,r5
    
    lsl r5,#16
    orr r5,r4   

    stm r0,{r5}       


    cmp r0,r8
    BLT looppp
       


    pop {r4-r7} 
    mov r8,r4
    mov r9,r5
    mov r10,r6
    mov r11,r7

	pop {r4-r7,pc}
	bx lr


    





