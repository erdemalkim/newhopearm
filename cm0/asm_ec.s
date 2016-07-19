.align 2
.thumb

.macro f x  @uses r3-r5;r14

    mov r3,#42
    lsl r4,r3,#6
    add r3,r4
    mul r3,\x
    lsr r3,#25
    mov r4,#3
    lsl r4,#12
    add r4,#1
    mov r14,r4
    
    mul r4,r3

    sub r4,\x,r4
    mov r5,r14
    sub r5,#1
    sub r4,r5,r4
    asr r4,#31
    sub r3,r4


    mov r4,#1
    and r4,r3
    lsr r5,r3,#1
    add r4,r5
    

    sub r3,#1
    mov r5,#1
    and r5,r3
    lsr r3,#1
    add r3,r5


    mov r5,r14
    lsl r5,#1   
    mul r5,r4
    sub \x,r5
    asr r5, \x, #31
    add \x, r5
    eor \x, r5    

.endm



.macro get_k_mov input rbit store
    lsl \input,#3
    add \input,\rbit
    f \input
    mov \store,\input
    push {r3,r4} 

.endm


.macro get_k input rbit store
    lsl \input,#3
    add \input,\rbit
    f \input
    add \store,\input
    push {r3,r4} 

.endm


.macro extract_k free,k
    mov \free,#3
    lsl \free,#13
    add \free,#2
    sub \free,#1
    sub \k,\free,\k
    asr \k,#31
.endm


.macro calculate_store k nk tmp3 offset @uses r3,r4

    pop {r3,r4}
    and r3,\k
    and r4,\nk
    eor r3,r4   @r3 == v_tmp[2]
    add r3,\tmp3
    mov r4,#3
    and r3,r4

 
.endm



asm_helprec_internal:

    push {r4-r7,lr}
    mov r4,r8
    mov r5,r10
    mov r6,r11
    mov r7,r12
    push {r4-r7}
    mov r4,r9
    mov r5,r14
    push {r4,r5}


    mov r11,r2

    
    mov r4,#1
    and r1,r4
    lsr r2,r1,#1


    mov r4,#3
    lsl r4,#14
    add r4,#4
    

    mul r1,r4
    mul r2,r4



    ldr r7,[r0]
    uxth r6,r7
    lsr r7,#16


    get_k_mov r6,r1,r12
    get_k_mov r7,r2,r9
    
  

    mov r7,#1
    lsl r7,#9
    ldr r7,[r0,r7]
    uxth r6,r7
    lsr r7,#16

    get_k r6,r1,r12
    get_k r7,r2,r9


    mov r7,#1
    lsl r7,#10
    ldr r7,[r0,r7]


    uxth r6,r7
    lsr r7,#16

    
    get_k r6,r1,r12
    get_k r7,r2,r9


    mov r7,#1
    lsl r7,#9
    lsl r5,r7,#1
    add r7,r5
    ldr r7,[r0,r7]
    uxth r6,r7
    lsr r7,#16


    lsl r6,#3
    add r6,r1
    f r6        @r3,r4
    add r6,r12

    mov r5,#3
    lsl r5,#13
    add r5,#2
    
    sub r5,#1
    sub r6,r5,r6
    
    asr r6,#31

    and r3,r6
    mvn r5,r6
    and r4,r5

    eor r3,r4 


    neg r4,r3
    mov r8,r4



    lsl r3,#1
    sub r3,r6

    mov r4,#3
    and r3,r4


    mov r1,r3


    lsl r7,#3
    add r7,r2
    f r7    @r3,r4
    add r7,r9
 
    mvn r5,r6

    mov r0,#3
    lsl r0,#13
    add r0,#2


    add r7,#1
    sub r7,r0,r7
    asr r7,#31


    and r3,r7
    mvn r0,r7
    and r4,r0
    eor r3,r4

    neg r4,r3
    mov r9,r4

    lsl r3,#1
    sub r3,r7
    mov r4,#3
    and r3,r4
    lsl r3,#16
    orr r3,r1


    mov r4,#1
    lsl r4,#9
    lsl r2,r4,#1
    add r4,r2

    mov r2,r11

    str r3,[r2,r4]



    calculate_store r7,r0,r9
    lsl r1,r3,#16
    calculate_store r6,r5,r8
    orr r3,r1

    mov r4,#1
    lsl r4,#10
    str r3,[r2,r4]


    calculate_store r7,r0,r9
    lsl r1,r3,#16    
    calculate_store r6,r5,r8
    orr r3,r1
    
    mov r4,#1
    lsl r4,#9
    str r3,[r2,r4]


    calculate_store r7,r0,r9
    lsl r1,r3,#16
    calculate_store r6,r5,r8
    orr r3,r1

    str r3,[r2]


    pop {r4,r5}
    mov r9,r4
    mov r14,r5
    pop {r4-r7}
    mov r8,r4
    mov r10,r5
    mov r11,r6
    mov r12,r7

    pop {r4-r7,pc}





 


.macro one_internal 
    mov r3,#3
    and r3,r7   @r3 = rbit1<<1 | rbit


    lsr r7,#2

    push {r0,r1,r2,r7}

    mov r1,r3
    bl asm_helprec_internal
    
    pop {r0,r1,r2,r7}

    add r0,#4
    add r2,#4

.endm
    



.macro oneinternal
    mov r4,#3
    and r4,r7
    lsr r7,#2
    push {r0,r1,r2,r7}
    mov r1,r4
    bl asm_helprec_internal
    pop {r0,r1,r2,r7}
    add r0,#4
    add r2,#4
.endm


.macro one_byte
    oneinternal
    oneinternal
    oneinternal 
    oneinternal
.endm


.macro key4bytes
    ldm r1,{r7}
    one_byte
    one_byte
    one_byte 
    one_byte
.endm



.macro g inout
    mov r2,#42
    lsl r3,r2,#6
    add r2,r3
 

    mov r3,#3
    lsl r3,#12
    add r3,#1
    LSL r6,r3,#3

    LSL r7,r3,#2

  
    MUL r2,\inout,r2
    LSR r3,r2,#27

    MOV r2,r7
    MUL r2,r3,r2
    SUB r2,\inout,r2
    
    SUB r2,r7,r2
    SUB r2,#1
    ASR r2,#31
    SUB r3,r2
    MOV r2,#1 
    AND r2,r3,r2
    
    LSR r3,#1
    ADD r3,r2
    MUL r3,r6
    SUB \inout,r3,\inout


    ASR r2,\inout,#31
    ADD \inout,r2
    EOR \inout,r2
.endm

asm_8bits_key:
    push {r4-r7,lr}
    mov r4,r8
    mov r5,r10
    mov r6,r11
    mov r7,r12

    push {r4,r7}

    add r1,r3
    add r2,r3


    
    mov r3,#3
    lsl r3,#9
 

    ldr r4,[r2,r3]
    uxth r5,r4
    lsr r4,#16


    ldr r6,[r2]
    uxth r7,r6
    lsr r6,#16

    lsl r6,#1
    lsl r7,#1



    
    add r6,r4
    add r7,r5


    
    mov r3,r8
    lsr r3,#4

    mul r6,r3
    mul r7,r3



    ldr r4,[r1]
    uxth r5,r4
    lsr r4,#16

    lsl r4,#3
    lsl r5,#3


        
    add r4,r8
    add r5,r8

    sub r4,r6
    sub r5,r7


    mov r11,r2
    g  r4
    mov r10,r4
    g  r5
    mov r12,r5
    mov r2,r11
    
    mov r3,#3
    lsl r3,#9


    ldr r4,[r2,r3]
    uxth r5,r4
    lsr r4,#16

    mov r3,#1
    lsl r3,#9
    

    ldr r6,[r2,r3]
    uxth r7,r6
    lsr r6,#16

    lsl r6,#1
    lsl r7,#1



    
    add r6,r4
    add r7,r5

    mov r4,r3
    
    mov r3,r8
    lsr r3,#4

    mul r6,r3
    mul r7,r3



    ldr r4,[r1,r4]
    uxth r5,r4
    lsr r4,#16

    lsl r4,#3
    lsl r5,#3


        
    add r4,r8
    add r5,r8

    sub r4,r6
    sub r5,r7


    mov r11,r2
    g r4
    mov r10,r4
    g r5 
    mov r12,r5

    mov r2,r11       


    mov r3,#3
    lsl r3,#9


    ldr r4,[r2,r3]
    uxth r5,r4
    lsr r4,#16

    mov r3,#1
    lsl r3,#10
    

    ldr r6,[r2,r3]
    uxth r7,r6
    lsr r6,#16

    lsl r6,#1
    lsl r7,#1



    
    add r6,r4
    add r7,r5

    mov r4,r3
    
    mov r3,r8
    lsr r3,#4

    mul r6,r3
    mul r7,r3



    ldr r4,[r1,r4]
    uxth r5,r4
    lsr r4,#16

    lsl r4,#3
    lsl r5,#3


        
    add r4,r8
    add r5,r8

    sub r4,r6
    sub r5,r7

    mov r11,r2

    g r4
    add r10,r4
    
    g r5
    add r12,r5

    mov r2,r11  

    mov r3,#3
    lsl r3,#9


    ldr r6,[r2,r3]
    uxth r7,r6
    lsr r6,#16

  
    
    mov r4,r8
    lsr r4,#4

    mul r6,r4
    mul r7,r4



    ldr r4,[r1,r3]
    uxth r5,r4
    lsr r4,#16

    lsl r4,#3
    lsl r5,#3


        
    add r4,r8
    add r5,r8

    sub r4,r6
    sub r5,r7

    mov r11,r2

    g r4 
    add r10,r4
    
    g r5
    add r12,r5
    mov r2,r11

    mov r3,r8
    lsr r3,#1

    mov r4,r10
    mov r5,r12
    
    sub r4,r3
    sub r5,r3

    lsr r4,#31
    lsr r5,#31

    mov r3,#1

    and r4,r3
    lsl r4,r3
    and r5,r3

    orr r5,r4
    push {r5}


    add r1,#4
    add r2,#4 

    
    mov r3,#3
    lsl r3,#9


    ldr r4,[r2,r3]
    uxth r5,r4
    lsr r4,#16


    ldr r6,[r2]
    uxth r7,r6
    lsr r6,#16

    lsl r6,#1
    lsl r7,#1



    
    add r6,r4
    add r7,r5


    
    mov r3,r8
    lsr r3,#4

    mul r6,r3
    mul r7,r3



    ldr r4,[r1]
    uxth r5,r4
    lsr r4,#16

    lsl r4,#3
    lsl r5,#3


        
    add r4,r8
    add r5,r8

    sub r4,r6
    sub r5,r7
    
    mov r11,r2
    g r4
    mov r10,r4
    g r5
    mov r12,r5
    mov r2,r11

    mov r3,#3
    lsl r3,#9


    ldr r4,[r2,r3]
    uxth r5,r4
    lsr r4,#16

    mov r3,#1
    lsl r3,#9
    

    ldr r6,[r2,r3]
    uxth r7,r6
    lsr r6,#16

    lsl r6,#1
    lsl r7,#1



    
    add r6,r4
    add r7,r5

    mov r4,r3
    
    mov r3,r8
    lsr r3,#4

    mul r6,r3
    mul r7,r3



    ldr r4,[r1,r4]
    uxth r5,r4
    lsr r4,#16

    lsl r4,#3
    lsl r5,#3


        
    add r4,r8
    add r5,r8

    sub r4,r6
    sub r5,r7

    mov r11,r2
    g r4
    mov r10,r4
    g r5
    mov r12,r5
    mov r2,r11

    mov r3,#3
    lsl r3,#9


    ldr r4,[r2,r3]
    uxth r5,r4
    lsr r4,#16

    mov r3,#1
    lsl r3,#10
    

    ldr r6,[r2,r3]
    uxth r7,r6
    lsr r6,#16

    lsl r6,#1
    lsl r7,#1



    
    add r6,r4
    add r7,r5

    mov r4,r3
    
    mov r3,r8
    lsr r3,#4

    mul r6,r3
    mul r7,r3



    ldr r4,[r1,r4]
    uxth r5,r4
    lsr r4,#16

    lsl r4,#3
    lsl r5,#3


        
    add r4,r8
    add r5,r8

    sub r4,r6
    sub r5,r7

    mov r11,r2
    g r4
    add r10,r4
    
    g r5
    add r12,r5
    mov r2,r11    

    mov r3,#3
    lsl r3,#9


    ldr r6,[r2,r3]
    uxth r7,r6
    lsr r6,#16

  
    
    mov r4,r8
    lsr r4,#4

    mul r6,r4
    mul r7,r4



    ldr r4,[r1,r3]
    uxth r5,r4
    lsr r4,#16

    lsl r4,#3
    lsl r5,#3


        
    add r4,r8
    add r5,r8

    sub r4,r6
    sub r5,r7

    mov r11,r2


    g r4
    add r10,r4
    

    g r5    
    add r12,r5
    mov r2,r11

    mov r3,r8
    lsr r3,#1

    mov r4,r10
    mov r5,r12
    
    sub r4,r3
    sub r5,r3

    lsr r4,#31
    lsr r5,#31

    mov r3,#1

    and r4,r3
    mov r3,#3
    lsl r4,r3
    and r5,r3
    mov r3,#2
    lsl r5,r3

    orr r5,r4
    pop {r4}

    orr r5,r4
    push {r5}

    add r1,#4
    add r2,#4 


    mov r3,#3
    lsl r3,#9
 

    ldr r4,[r2,r3]
    uxth r5,r4
    lsr r4,#16


    ldr r6,[r2]
    uxth r7,r6
    lsr r6,#16

    lsl r6,#1
    lsl r7,#1



    
    add r6,r4
    add r7,r5


    
    mov r3,r8
    lsr r3,#4

    mul r6,r3
    mul r7,r3



    ldr r4,[r1]
    uxth r5,r4
    lsr r4,#16

    lsl r4,#3
    lsl r5,#3


        
    add r4,r8
    add r5,r8

    sub r4,r6
    sub r5,r7
    
    mov r11,r2
    g r4    
    mov r10,r4
    g r5
    mov r12,r5

    mov r2,r11
    
    mov r3,#3
    lsl r3,#9


    ldr r4,[r2,r3]
    uxth r5,r4
    lsr r4,#16

    mov r3,#1
    lsl r3,#9
    

    ldr r6,[r2,r3]
    uxth r7,r6
    lsr r6,#16

    lsl r6,#1
    lsl r7,#1



    
    add r6,r4
    add r7,r5

    mov r4,r3
    
    mov r3,r8
    lsr r3,#4

    mul r6,r3
    mul r7,r3



    ldr r4,[r1,r4]
    uxth r5,r4
    lsr r4,#16

    lsl r4,#3
    lsl r5,#3


        
    add r4,r8
    add r5,r8

    sub r4,r6
    sub r5,r7

    mov r11,r2
    g r4
    add r10,r4
    g r5
    add r12,r5
    mov r2,r11

    mov r3,#3
    lsl r3,#9


    ldr r4,[r2,r3]
    uxth r5,r4
    lsr r4,#16

    mov r3,#1
    lsl r3,#10
    

    ldr r6,[r2,r3]
    uxth r7,r6
    lsr r6,#16

    lsl r6,#1
    lsl r7,#1



    
    add r6,r4
    add r7,r5

    mov r4,r3
    
    mov r3,r8
    lsr r3,#4

    mul r6,r3
    mul r7,r3



    ldr r4,[r1,r4]
    uxth r5,r4
    lsr r4,#16

    lsl r4,#3
    lsl r5,#3


        
    add r4,r8
    add r5,r8

    sub r4,r6
    sub r5,r7

    mov r11,r2
    g r4
    add r10,r4
    
    g r5
    add r12,r5
    mov r2,r11

    mov r3,#3
    lsl r3,#9


    ldr r6,[r2,r3]
    uxth r7,r6
    lsr r6,#16

  
    
    mov r4,r8
    lsr r4,#4

    mul r6,r4
    mul r7,r4



    ldr r4,[r1,r3]
    uxth r5,r4
    lsr r4,#16

    lsl r4,#3
    lsl r5,#3


        
    add r4,r8
    add r5,r8

    sub r4,r6
    sub r5,r7


    mov r11,r2
    g r4
    add r10,r4
    g r5
    add r12,r5
    mov r2,r11

    mov r3,r8
    lsr r3,#1

    mov r4,r10
    mov r5,r12
    
    sub r4,r3
    sub r5,r3

    lsr r4,#31
    lsr r5,#31

    mov r3,#1

    and r4,r3
    and r5,r3

    mov r3,#5
    lsl r4,r3
    mov r3,#4
    lsl r5,r3

    orr r5,r4


    pop {r4}

    orr r5,r4
    push {r5}


    add r1,#4
    add r2,#4 

    
    mov r3,#3
    lsl r3,#9


    ldr r4,[r2,r3]
    uxth r5,r4
    lsr r4,#16


    ldr r6,[r2]
    uxth r7,r6
    lsr r6,#16

    lsl r6,#1
    lsl r7,#1



    
    add r6,r4
    add r7,r5


    
    mov r3,r8
    lsr r3,#4

    mul r6,r3
    mul r7,r3



    ldr r4,[r1]
    uxth r5,r4
    lsr r4,#16

    lsl r4,#3
    lsl r5,#3


        
    add r4,r8
    add r5,r8

    sub r4,r6
    sub r5,r7
    
    mov r11,r2

    g r4
    mov r10,r4
    
    g r5
    mov r12,r5
    mov r2,r11    
    
    mov r3,#3
    lsl r3,#9


    ldr r4,[r2,r3]
    uxth r5,r4
    lsr r4,#16

    mov r3,#1
    lsl r3,#9
    

    ldr r6,[r2,r3]
    uxth r7,r6
    lsr r6,#16

    lsl r6,#1
    lsl r7,#1



    
    add r6,r4
    add r7,r5

    mov r4,r3
    
    mov r3,r8
    lsr r3,#4

    mul r6,r3
    mul r7,r3



    ldr r4,[r1,r4]
    uxth r5,r4
    lsr r4,#16

    lsl r4,#3
    lsl r5,#3


        
    add r4,r8
    add r5,r8

    sub r4,r6
    sub r5,r7


    mov r11,r2
    g r4
    add r10,r4
    g r5
    add r12,r5

    mov r2,r11

    mov r3,#3
    lsl r3,#9


    ldr r4,[r2,r3]
    uxth r5,r4
    lsr r4,#16

    mov r3,#1
    lsl r3,#10
    

    ldr r6,[r2,r3]
    uxth r7,r6
    lsr r6,#16

    lsl r6,#1
    lsl r7,#1



    
    add r6,r4
    add r7,r5

    mov r4,r3
    
    mov r3,r8
    lsr r3,#4

    mul r6,r3
    mul r7,r3



    ldr r4,[r1,r4]
    uxth r5,r4
    lsr r4,#16

    lsl r4,#3
    lsl r5,#3


        
    add r4,r8
    add r5,r8

    sub r4,r6
    sub r5,r7


    mov r11,r2
    g r4
    add r10,r4
    
    g r5
    add r12,r5
    mov r2,r11  

    mov r3,#3
    lsl r3,#9


    ldr r6,[r2,r3]
    uxth r7,r6
    lsr r6,#16

  
    
    mov r4,r8
    lsr r4,#4

    mul r6,r4
    mul r7,r4



    ldr r4,[r1,r3]
    uxth r5,r4
    lsr r4,#16

    lsl r4,#3
    lsl r5,#3


        
    add r4,r8
    add r5,r8

    sub r4,r6
    sub r5,r7

    mov r11,r2    
    g r4
    add r10,r4
    g r5
    add r12,r5
    mov r2,r11

    mov r3,r8
    lsr r3,#1

    mov r4,r10
    mov r5,r12
    
    sub r4,r3
    sub r5,r3

    lsr r4,#31
    lsr r5,#31

    mov r3,#1

    and r4,r3
    mov r3,#7
    lsl r4,r3
    and r5,r3
    mov r3,#6
    lsl r5,r3

    orr r5,r4
    pop {r4}

    orr r5,r4
    
    mov r0,r5
endl:

    pop {r4,r7}
    mov r8,r4
    mov r10,r5
    mov r11,r6
    mov r12,r7

    pop {r4-r7,pc} 

.macro setKey 
    push {r0}
    bl asm_8bits_key
    mov r5,r0
    pop {r0}
   
    mov r3,#4

    push {r0,r5}
    bl asm_8bits_key
    lsl r4,r0,#8
    pop {r0,r5}
    orr r5,r4

    mov r3,#4

    push {r0,r5}
    bl asm_8bits_key
    lsl r4,r0,#16
    pop {r0,r5}
    orr r5,r4


    mov r3,#4

    push {r0,r5}
    bl asm_8bits_key
    lsl r4,r0,#24
    pop {r0,r5}
    orr r5,r4
    add r0,#4
    str r5,[r0]
.endm


@----------------------------------------------------------------------------
@
@ void asm_helprec(poly *c, const poly *v, const unsigned char *seed, unsigned char nonce)
@

.global	asm_helprec
.type	asm_helprec, %function
asm_helprec:

    push {r4-r7,lr}
    key4bytes
    key4bytes
    key4bytes
    key4bytes
    key4bytes
    key4bytes
    key4bytes
    key4bytes
    pop {r4-r7,pc}

@----------------------------------------------------------------------------
@
@ void asm_rec(unsigned char *key, const poly *v, const poly *c);
@

.global asm_rec   
.type asm_rec, %function

asm_rec:
    push {r4-r7,lr}
    mov r4,r8
    push {r4}


    
        MOV r3,#3
    LSL r3,#16
    ADD r3,#16
    mov r8,r3

    eor r4,r4
    eor r5,r5
    eor r6,r6
    eor r7,r7


    stm r0,{r4,r5,r6,r7}
    stm r0,{r4,r5,r6,r7}

    sub r0,#32


    eor r3,r3
    sub r0,#4


    setKey
    mov r3,#4
    setKey
    mov r3,#4
    setKey
    mov r3,#4
    setKey
    mov r3,#4
    setKey
    mov r3,#4
    setKey
    mov r3,#4
    setKey
    mov r3,#4
    setKey


    pop {r4}
    mov r8,r4
    pop {r4-r7,pc} 


    
