.align 2
.thumb


@----------------------------------------------------------------------------
@
@ void asm_csc_for(unsigned char *in, const unsigned char *n)
@    


.global	asm_csc_for;
.type	asm_csc_for, %function
asm_csc_for:
    push {r4-r7,lr}
    
    
    ldm r1!,{r3,r4}
    stm r0!,{r3,r4}
    eor r3,r3
    eor r4,r4
    stm r0!,{r3,r4}
    


    pop {r4-r7,pc}
    bx lr





@----------------------------------------------------------------------------
@
@ void asm_init(unsigned char *out, unsigned char *k,unsigned char *in)
@ 


.global asm_init;
.type asm_init, %function
asm_init:
    push {r4-r7,lr}


    ldm r3,{r4,r5,r6,r7}
    stm r0,{r4,r5,r6,r7}

    ldm r1,{r4,r5,r6,r7}
    stm r0,{r4,r5,r6,r7}
    ldm r1,{r4,r5,r6,r7}
    stm r0,{r4,r5,r6,r7}


   
    ldm r2,{r6,r7}
    ldm r2,{r4,r5}    
    stm r0,{r4,r5,r6,r7}

    pop {r4-r7,pc}
    bx lr
    


@----------------------------------------------------------------------------
@
@ void asm_quarterround(uint32_t *x)
@ 
.global asm_quarterround
.func asm_quarterround

asm_quarterround:
	// Save low registers
	push {r4-r7}

	// Copy high to low registers
	mov	r3, r8
	mov	r4, r9
	mov	r5, r10
	mov	r6, r11
	mov	r7, r12
	// Save high registers
	push {r3-r7}
	// See Readme for explanation of
	// register allocation.

	// Rotate constants are buffered as good as possible
	mov	r5, #16
	mov	r6, #20
	mov	r7, #24

	// Round 1
	//=======================================
	ldr	r1, [r0]
	ldr	r2, [r0, #16]
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #48]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #16]
	str	r3, [r0, #32]
	str	r4, [r0, #48]

	//=======================================

	ldr	r1, [r0, #4]
	ldr	r2, [r0, #20]
	ldr	r3, [r0, #36]
	ldr	r4, [r0, #52]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r10, r2
	str	r3, [r0, #36]
	str	r4, [r0, #52]
	
	//=======================================

	ldr	r1, [r0, #8]
	ldr	r2, [r0, #24]
	ldr	r3, [r0, #40]
	ldr	r4, [r0, #56]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r2
	mov	r12, r3
	str	r4, [r0, #56]
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #28]
	ldr	r3, [r0, #44]
	ldr	r4, [r0, #60]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r8, r2
	mov	r11, r3
	
	//=======================================

	ldr	r1, [r0, #0]
	mov	r2, r10
	mov	r3, r12
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #20]
	str	r3, [r0, #40]
	str	r4, [r0, #60]
	
	//=======================================

	ldr	r1, [r0, #4]
	mov	r2, r9
	mov	r3, r11
	ldr	r4, [r0, #48]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #24]
	str	r3, [r0, #44]
	mov	r10, r4
	
	//=======================================

	ldr	r1, [r0, #8]
	mov	r2, r8
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #52]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #28]
	mov	r8, r3
	mov	r11, r4
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #16]
	ldr	r3, [r0, #36]
	ldr	r4, [r0, #56]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r3
	mov	r12, r4

	//=======================================

	// Round 2
	//=======================================
	ldr	r1, [r0]
	mov	r3, r8
	mov	r4, r10
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #16]
	str	r3, [r0, #32]
	str	r4, [r0, #48]

	//=======================================

	ldr	r1, [r0, #4]
	ldr	r2, [r0, #20]
	mov	r3, r9
	mov	r4, r11
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r10, r2
	str	r3, [r0, #36]
	str	r4, [r0, #52]
	
	//=======================================

	ldr	r1, [r0, #8]
	ldr	r2, [r0, #24]
	ldr	r3, [r0, #40]
	mov	r4, r12
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r2
	mov	r12, r3
	str	r4, [r0, #56]
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #28]
	ldr	r3, [r0, #44]
	ldr	r4, [r0, #60]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r8, r2
	mov	r11, r3
	
	//=======================================

	ldr	r1, [r0, #0]
	mov	r2, r10
	mov	r3, r12
	
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #20]
	str	r3, [r0, #40]
	str	r4, [r0, #60]
	
	//=======================================

	ldr	r1, [r0, #4]
	mov	r2, r9
	mov	r3, r11
	ldr	r4, [r0, #48]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #24]
	str	r3, [r0, #44]
	mov	r10, r4
	
	//=======================================

	ldr	r1, [r0, #8]
	mov	r2, r8
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #52]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #28]
	mov	r8, r3
	mov	r11, r4
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #16]
	ldr	r3, [r0, #36]
	ldr	r4, [r0, #56]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r3
	mov	r12, r4

	//=======================================

	// Round 3
	//=======================================
	ldr	r1, [r0]
	mov	r3, r8
	mov	r4, r10
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #16]
	str	r3, [r0, #32]
	str	r4, [r0, #48]

	//=======================================

	ldr	r1, [r0, #4]
	ldr	r2, [r0, #20]
	mov	r3, r9
	mov	r4, r11
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r10, r2
	str	r3, [r0, #36]
	str	r4, [r0, #52]
	
	//=======================================

	ldr	r1, [r0, #8]
	ldr	r2, [r0, #24]
	ldr	r3, [r0, #40]
	mov	r4, r12
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r2
	mov	r12, r3
	str	r4, [r0, #56]
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #28]
	ldr	r3, [r0, #44]
	ldr	r4, [r0, #60]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r8, r2
	mov	r11, r3
	
	//=======================================

	ldr	r1, [r0, #0]
	mov	r2, r10
	mov	r3, r12
	
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #20]
	str	r3, [r0, #40]
	str	r4, [r0, #60]
	
	//=======================================

	ldr	r1, [r0, #4]
	mov	r2, r9
	mov	r3, r11
	ldr	r4, [r0, #48]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #24]
	str	r3, [r0, #44]
	mov	r10, r4
	
	//=======================================

	ldr	r1, [r0, #8]
	mov	r2, r8
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #52]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #28]
	mov	r8, r3
	mov	r11, r4
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #16]
	ldr	r3, [r0, #36]
	ldr	r4, [r0, #56]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r3
	mov	r12, r4

	//=======================================

	// Round 4
	//=======================================
	ldr	r1, [r0]
	mov	r3, r8
	mov	r4, r10
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #16]
	str	r3, [r0, #32]
	str	r4, [r0, #48]

	//=======================================

	ldr	r1, [r0, #4]
	ldr	r2, [r0, #20]
	mov	r3, r9
	mov	r4, r11
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r10, r2
	str	r3, [r0, #36]
	str	r4, [r0, #52]
	
	//=======================================

	ldr	r1, [r0, #8]
	ldr	r2, [r0, #24]
	ldr	r3, [r0, #40]
	mov	r4, r12
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r2
	mov	r12, r3
	str	r4, [r0, #56]
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #28]
	ldr	r3, [r0, #44]
	ldr	r4, [r0, #60]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r8, r2
	mov	r11, r3
	
	//=======================================

	ldr	r1, [r0, #0]
	mov	r2, r10
	mov	r3, r12
	
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #20]
	str	r3, [r0, #40]
	str	r4, [r0, #60]
	
	//=======================================

	ldr	r1, [r0, #4]
	mov	r2, r9
	mov	r3, r11
	ldr	r4, [r0, #48]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #24]
	str	r3, [r0, #44]
	mov	r10, r4
	
	//=======================================

	ldr	r1, [r0, #8]
	mov	r2, r8
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #52]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #28]
	mov	r8, r3
	mov	r11, r4
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #16]
	ldr	r3, [r0, #36]
	ldr	r4, [r0, #56]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r3
	mov	r12, r4

	//=======================================

	// Round 5
	//=======================================
	ldr	r1, [r0]
	mov	r3, r8
	mov	r4, r10
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #16]
	str	r3, [r0, #32]
	str	r4, [r0, #48]

	//=======================================

	ldr	r1, [r0, #4]
	ldr	r2, [r0, #20]
	mov	r3, r9
	mov	r4, r11
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r10, r2
	str	r3, [r0, #36]
	str	r4, [r0, #52]
	
	//=======================================

	ldr	r1, [r0, #8]
	ldr	r2, [r0, #24]
	ldr	r3, [r0, #40]
	mov	r4, r12
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r2
	mov	r12, r3
	str	r4, [r0, #56]
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #28]
	ldr	r3, [r0, #44]
	ldr	r4, [r0, #60]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r8, r2
	mov	r11, r3
	
	//=======================================

	ldr	r1, [r0, #0]
	mov	r2, r10
	mov	r3, r12
	
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #20]
	str	r3, [r0, #40]
	str	r4, [r0, #60]
	
	//=======================================

	ldr	r1, [r0, #4]
	mov	r2, r9
	mov	r3, r11
	ldr	r4, [r0, #48]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #24]
	str	r3, [r0, #44]
	mov	r10, r4
	
	//=======================================

	ldr	r1, [r0, #8]
	mov	r2, r8
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #52]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #28]
	mov	r8, r3
	mov	r11, r4
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #16]
	ldr	r3, [r0, #36]
	ldr	r4, [r0, #56]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r3
	mov	r12, r4

	//=======================================

	// Round 6
	//=======================================
	ldr	r1, [r0]
	mov	r3, r8
	mov	r4, r10
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #16]
	str	r3, [r0, #32]
	str	r4, [r0, #48]

	//=======================================

	ldr	r1, [r0, #4]
	ldr	r2, [r0, #20]
	mov	r3, r9
	mov	r4, r11
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r10, r2
	str	r3, [r0, #36]
	str	r4, [r0, #52]
	
	//=======================================

	ldr	r1, [r0, #8]
	ldr	r2, [r0, #24]
	ldr	r3, [r0, #40]
	mov	r4, r12
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r2
	mov	r12, r3
	str	r4, [r0, #56]
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #28]
	ldr	r3, [r0, #44]
	ldr	r4, [r0, #60]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r8, r2
	mov	r11, r3
	
	//=======================================

	ldr	r1, [r0, #0]
	mov	r2, r10
	mov	r3, r12
	
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #20]
	str	r3, [r0, #40]
	str	r4, [r0, #60]
	
	//=======================================

	ldr	r1, [r0, #4]
	mov	r2, r9
	mov	r3, r11
	ldr	r4, [r0, #48]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #24]
	str	r3, [r0, #44]
	mov	r10, r4
	
	//=======================================

	ldr	r1, [r0, #8]
	mov	r2, r8
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #52]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #28]
	mov	r8, r3
	mov	r11, r4
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #16]
	ldr	r3, [r0, #36]
	ldr	r4, [r0, #56]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r3
	mov	r12, r4

	//=======================================

	// Round 7
	//=======================================
	ldr	r1, [r0]
	mov	r3, r8
	mov	r4, r10
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #16]
	str	r3, [r0, #32]
	str	r4, [r0, #48]

	//=======================================

	ldr	r1, [r0, #4]
	ldr	r2, [r0, #20]
	mov	r3, r9
	mov	r4, r11
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r10, r2
	str	r3, [r0, #36]
	str	r4, [r0, #52]
	
	//=======================================

	ldr	r1, [r0, #8]
	ldr	r2, [r0, #24]
	ldr	r3, [r0, #40]
	mov	r4, r12
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r2
	mov	r12, r3
	str	r4, [r0, #56]
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #28]
	ldr	r3, [r0, #44]
	ldr	r4, [r0, #60]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r8, r2
	mov	r11, r3
	
	//=======================================

	ldr	r1, [r0, #0]
	mov	r2, r10
	mov	r3, r12
	
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #20]
	str	r3, [r0, #40]
	str	r4, [r0, #60]
	
	//=======================================

	ldr	r1, [r0, #4]
	mov	r2, r9
	mov	r3, r11
	ldr	r4, [r0, #48]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #24]
	str	r3, [r0, #44]
	mov	r10, r4
	
	//=======================================

	ldr	r1, [r0, #8]
	mov	r2, r8
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #52]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #28]
	mov	r8, r3
	mov	r11, r4
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #16]
	ldr	r3, [r0, #36]
	ldr	r4, [r0, #56]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r3
	mov	r12, r4

	//=======================================

	// Round 8
	//=======================================
	ldr	r1, [r0]
	mov	r3, r8
	mov	r4, r10
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #16]
	str	r3, [r0, #32]
	str	r4, [r0, #48]

	//=======================================

	ldr	r1, [r0, #4]
	ldr	r2, [r0, #20]
	mov	r3, r9
	mov	r4, r11
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r10, r2
	str	r3, [r0, #36]
	str	r4, [r0, #52]
	
	//=======================================

	ldr	r1, [r0, #8]
	ldr	r2, [r0, #24]
	ldr	r3, [r0, #40]
	mov	r4, r12
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r2
	mov	r12, r3
	str	r4, [r0, #56]
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #28]
	ldr	r3, [r0, #44]
	ldr	r4, [r0, #60]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r8, r2
	mov	r11, r3
	
	//=======================================

	ldr	r1, [r0, #0]
	mov	r2, r10
	mov	r3, r12
	
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #20]
	str	r3, [r0, #40]
	str	r4, [r0, #60]
	
	//=======================================

	ldr	r1, [r0, #4]
	mov	r2, r9
	mov	r3, r11
	ldr	r4, [r0, #48]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #24]
	str	r3, [r0, #44]
	mov	r10, r4
	
	//=======================================

	ldr	r1, [r0, #8]
	mov	r2, r8
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #52]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #28]
	mov	r8, r3
	mov	r11, r4
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #16]
	ldr	r3, [r0, #36]
	ldr	r4, [r0, #56]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r3
	mov	r12, r4

	//=======================================

	// Round 9
	//=======================================
	ldr	r1, [r0]
	mov	r3, r8
	mov	r4, r10
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #16]
	str	r3, [r0, #32]
	str	r4, [r0, #48]

	//=======================================

	ldr	r1, [r0, #4]
	ldr	r2, [r0, #20]
	mov	r3, r9
	mov	r4, r11
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r10, r2
	str	r3, [r0, #36]
	str	r4, [r0, #52]
	
	//=======================================

	ldr	r1, [r0, #8]
	ldr	r2, [r0, #24]
	ldr	r3, [r0, #40]
	mov	r4, r12
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r2
	mov	r12, r3
	str	r4, [r0, #56]
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #28]
	ldr	r3, [r0, #44]
	ldr	r4, [r0, #60]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r8, r2
	mov	r11, r3
	
	//=======================================

	ldr	r1, [r0, #0]
	mov	r2, r10
	mov	r3, r12
	
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #20]
	str	r3, [r0, #40]
	str	r4, [r0, #60]
	
	//=======================================

	ldr	r1, [r0, #4]
	mov	r2, r9
	mov	r3, r11
	ldr	r4, [r0, #48]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #24]
	str	r3, [r0, #44]
	mov	r10, r4
	
	//=======================================

	ldr	r1, [r0, #8]
	mov	r2, r8
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #52]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #28]
	mov	r8, r3
	mov	r11, r4
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #16]
	ldr	r3, [r0, #36]
	ldr	r4, [r0, #56]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r3
	mov	r12, r4

	//=======================================
	
	// Round 10
	//=======================================
	ldr	r1, [r0]
	mov	r3, r8
	mov	r4, r10
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #16]
	str	r3, [r0, #32]
	str	r4, [r0, #48]

	//=======================================

	ldr	r1, [r0, #4]
	ldr	r2, [r0, #20]
	mov	r3, r9
	mov	r4, r11
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r10, r2
	str	r3, [r0, #36]
	str	r4, [r0, #52]
	
	//=======================================

	ldr	r1, [r0, #8]
	ldr	r2, [r0, #24]
	ldr	r3, [r0, #40]
	mov	r4, r12
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r9, r2
	mov	r12, r3
	str	r4, [r0, #56]
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #28]
	ldr	r3, [r0, #44]
	ldr	r4, [r0, #60]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	mov	r8, r2
	mov	r11, r3
	
	//=======================================

	ldr	r1, [r0, #0]
	mov	r2, r10
	mov	r3, r12
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #0]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #20]
	str	r3, [r0, #40]
	str	r4, [r0, #60]
	
	//=======================================

	ldr	r1, [r0, #4]
	mov	r2, r9
	mov	r3, r11
	ldr	r4, [r0, #48]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #4]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #24]
	str	r3, [r0, #44]
	str	r4, [r0, #48]
	
	//=======================================

	ldr	r1, [r0, #8]
	mov	r2, r8
	ldr	r3, [r0, #32]
	ldr	r4, [r0, #52]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #8]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #28]
	str	r3, [r0, #32]
	str	r4, [r0, #52]
	
	//=======================================

	ldr	r1, [r0, #12]
	ldr	r2, [r0, #16]
	ldr	r3, [r0, #36]
	ldr	r4, [r0, #56]
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]),16);
	eor	r4, r1
	ror	r4, r5
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]),12);
	eor	r2, r3
	ror	r2, r6
	// x[a] = PLUS(x[a],x[b]);
	add	r1, r2
	// x[d] = ROTATE(XOR(x[d],x[a]), 8);
	eor	r4, r1
	str	r1, [r0, #12]
	ror	r4, r7
	// x[c] = PLUS(x[c],x[d]);
	add	r3, r4
	// x[b] = ROTATE(XOR(x[b],x[c]), 7);
	eor	r2, r3
	mov	r1, #25
	ror	r2, r1

	str	r2, [r0, #16]
	str	r3, [r0, #36]
	str	r4, [r0, #56]

	//=======================================

	// restore high registers
	pop {r3-r7}
	// Copy low to high registers
	mov	r8, r3
	mov	r9, r4
	mov	r10, r5
	mov	r11, r6
	mov	r12, r7

	pop {r4-r7}
	bx lr
.endfunc



@----------------------------------------------------------------------------
@
@ void asm_add_and_store(unsigned char *out, uint32_t *x,uint32_t *j)
@ 
.global asm_add_and_store
.func asm_add_and_store

asm_add_and_store:
	push {r4-r6}
	
	//=======================================
	ldr	r3, [r1]
	ldr	r4, [r2]
	
	ldr	r5, [r1, #4]
	ldr	r6, [r2, #4]
	
	add r3, r4
	str	r3, [r0]

	ldr	r3, [r1, #8]
	ldr	r4, [r2, #8]

	add r5, r6
	str	r5, [r0, #4]

	ldr	r5, [r1, #12]
	ldr	r6, [r2, #12]
	
	add r3, r4
	str	r3, [r0, #8]

	ldr	r3, [r1, #16]
	ldr	r4, [r2, #16]

	add r5, r6
	str	r5, [r0, #12]

	ldr	r5, [r1, #20]
	ldr	r6, [r2, #20]
	
	add r3, r4
	str	r3, [r0, #16]

	ldr	r3, [r1, #24]
	ldr	r4, [r2, #24]

	add r5, r6
	str	r5, [r0, #20]

	ldr	r5, [r1, #28]
	ldr	r6, [r2, #28]
	
	add r3, r4
	str	r3, [r0, #24]

	ldr	r3, [r1, #32]
	ldr	r4, [r2, #32]

	add r5, r6
	str	r5, [r0, #28]

	ldr	r5, [r1, #36]
	ldr	r6, [r2, #36]
	
	add r3, r4
	str	r3, [r0, #32]

	ldr	r3, [r1, #40]
	ldr	r4, [r2, #40]

	add r5, r6
	str	r5, [r0, #36]

	ldr	r5, [r1, #44]
	ldr	r6, [r2, #44]
	
	add r3, r4
	str	r3, [r0, #40]

	ldr	r3, [r1, #48]
	ldr	r4, [r2, #48]

	add r5, r6
	str	r5, [r0, #44]

	ldr	r5, [r1, #52]
	ldr	r6, [r2, #52]
	
	add r3, r4
	str	r3, [r0, #48]

	ldr	r3, [r1, #56]
	ldr	r4, [r2, #56]

	add r5, r6
	str	r5, [r0, #52]

	ldr	r5, [r1, #60]
	ldr	r6, [r2, #60]
	
	add r3, r4
	str	r3, [r0, #56]

	ldr	r3, [r1, #64]
	ldr	r4, [r2, #64]

	add r5, r6
	str	r5, [r0, #60]

	add r3, r4
	str	r3, [r0, #64]
	
	//=======================================

	pop {r4-r6}
	bx lr
.endfunc


