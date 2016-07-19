.global chacha_perm_asm
.type chacha_perm_asm, %function

.syntax unified
.cpu cortex-m3

// operates on r0 as output and r1 as input pointer
// assumes space of 64 bytes following both pointers

chacha_perm_asm:
    push {r0-r12, r14} // preserve everything

    ldm r1!, {r0, r2-r12, r14}
    push {r9, r14} // store 8 and 12 on the stack
    ldm r1!, {r9, r14} // get 13, 14
    ldr r1, [r1, #0] // get 15

    // new double-round starts here
    // QUARTERROUND( 1, 5, 9,13) [r2 r6 r10 r9]
    add r2, r6
    eor r9, r2
    ror r9, r9, #16
    add r10, r9
    eor r6, r10
    ror r6, r6, #20
    add r2, r6
    eor r9, r2
    ror r9, r9, #24
    add r10, r9
    eor r6, r10
    ror r6, r6, #25
    // QUARTERROUND( 2, 6,10,14) [r3 r7 r11 r14]
    add r3, r7
    eor r14, r3
    ror r14, r14, #16
    add r11, r14
    eor r7, r11
    ror r7, r7, #20
    add r3, r7
    eor r14, r3
    ror r14, r14, #24
    add r11, r14
    eor r7, r11
    ror r7, r7, #25
    // QUARTERROUND( 3, 7,11,15) [r4 r8 r12 r1]
    add r4, r8
    eor r1, r4
    ror r1, r1, #16
    add r12, r1
    eor r8, r12
    ror r8, r8, #20
    add r4, r8
    eor r1, r4
    ror r1, r1, #24
    add r12, r1
    eor r8, r12
    ror r8, r8, #25

    // switch from memory
    push {r10, r11} // store [9] and [10]
    ldr r10, [sp, #8] // retrieve [8]
    ldr r11, [sp, #12] // retrieve [12]

    // QUARTERROUND( 0, 4, 8,12) [r0 r5 r10 r11]
    add r0, r5
    eor r11, r0
    ror r11, r11, #16
    add r10, r11
    eor r5, r10
    ror r5, r5, #20
    add r0, r5
    eor r11, r0
    ror r11, r11, #24
    add r10, r11
    eor r5, r10
    ror r5, r5, #25
    // halfway there

    // QUARTERROUND( 1, 6,11,12) [r2 r7 r12 r11]
    add r2, r7
    eor r11, r2
    ror r11, r11, #16
    add r12, r11
    eor r7, r12
    ror r7, r7, #20
    add r2, r7
    eor r11, r2
    ror r11, r11, #24
    add r12, r11
    eor r7, r12
    ror r7, r7, #25
    // QUARTERROUND( 2, 7, 8,13) [r3 r8 r10 r9]
    add r3, r8
    eor r9, r3
    ror r9, r9, #16
    add r10, r9
    eor r8, r10
    ror r8, r8, #20
    add r3, r8
    eor r9, r3
    ror r9, r9, #24
    add r10, r9
    eor r8, r10
    ror r8, r8, #25

    // switch from memory
    str r10, [sp, #8] // store [8]
    str r11, [sp, #12] // store [12]
    pop {r10, r11} // retrieve [9] and [10]

    //  QUARTERROUND( 0, 5,10,15) [r0 r6 r11 r1]
    add r0, r6
    eor r1, r0
    ror r1, r1, #16
    add r11, r1
    eor r6, r11
    ror r6, r6, #20
    add r0, r6
    eor r1, r0
    ror r1, r1, #24
    add r11, r1
    eor r6, r11
    ror r6, r6, #25
    // QUARTERROUND( 3, 4, 9,14) [r4 r5 r10 r14]
    add r4, r5
    eor r14, r4
    ror r14, r14, #16
    add r10, r14
    eor r5, r10
    ror r5, r5, #20
    add r4, r5
    eor r14, r4
    ror r14, r14, #24
    add r10, r14
    eor r5, r10
    ror r5, r5, #25

    // new double-round starts here
    // QUARTERROUND( 1, 5, 9,13) [r2 r6 r10 r9]
    add r2, r6
    eor r9, r2
    ror r9, r9, #16
    add r10, r9
    eor r6, r10
    ror r6, r6, #20
    add r2, r6
    eor r9, r2
    ror r9, r9, #24
    add r10, r9
    eor r6, r10
    ror r6, r6, #25
    // QUARTERROUND( 2, 6,10,14) [r3 r7 r11 r14]
    add r3, r7
    eor r14, r3
    ror r14, r14, #16
    add r11, r14
    eor r7, r11
    ror r7, r7, #20
    add r3, r7
    eor r14, r3
    ror r14, r14, #24
    add r11, r14
    eor r7, r11
    ror r7, r7, #25
    // QUARTERROUND( 3, 7,11,15) [r4 r8 r12 r1]
    add r4, r8
    eor r1, r4
    ror r1, r1, #16
    add r12, r1
    eor r8, r12
    ror r8, r8, #20
    add r4, r8
    eor r1, r4
    ror r1, r1, #24
    add r12, r1
    eor r8, r12
    ror r8, r8, #25

    // switch from memory
    push {r10, r11} // store [9] and [10]
    ldr r10, [sp, #8] // retrieve [8]
    ldr r11, [sp, #12] // retrieve [12]

    // QUARTERROUND( 0, 4, 8,12) [r0 r5 r10 r11]
    add r0, r5
    eor r11, r0
    ror r11, r11, #16
    add r10, r11
    eor r5, r10
    ror r5, r5, #20
    add r0, r5
    eor r11, r0
    ror r11, r11, #24
    add r10, r11
    eor r5, r10
    ror r5, r5, #25
    // halfway there

    // QUARTERROUND( 1, 6,11,12) [r2 r7 r12 r11]
    add r2, r7
    eor r11, r2
    ror r11, r11, #16
    add r12, r11
    eor r7, r12
    ror r7, r7, #20
    add r2, r7
    eor r11, r2
    ror r11, r11, #24
    add r12, r11
    eor r7, r12
    ror r7, r7, #25
    // QUARTERROUND( 2, 7, 8,13) [r3 r8 r10 r9]
    add r3, r8
    eor r9, r3
    ror r9, r9, #16
    add r10, r9
    eor r8, r10
    ror r8, r8, #20
    add r3, r8
    eor r9, r3
    ror r9, r9, #24
    add r10, r9
    eor r8, r10
    ror r8, r8, #25

    // switch from memory
    str r10, [sp, #8] // store [8]
    str r11, [sp, #12] // store [12]
    pop {r10, r11} // retrieve [9] and [10]

    //  QUARTERROUND( 0, 5,10,15) [r0 r6 r11 r1]
    add r0, r6
    eor r1, r0
    ror r1, r1, #16
    add r11, r1
    eor r6, r11
    ror r6, r6, #20
    add r0, r6
    eor r1, r0
    ror r1, r1, #24
    add r11, r1
    eor r6, r11
    ror r6, r6, #25
    // QUARTERROUND( 3, 4, 9,14) [r4 r5 r10 r14]
    add r4, r5
    eor r14, r4
    ror r14, r14, #16
    add r10, r14
    eor r5, r10
    ror r5, r5, #20
    add r4, r5
    eor r14, r4
    ror r14, r14, #24
    add r10, r14
    eor r5, r10
    ror r5, r5, #25

    // new double-round starts here
    // QUARTERROUND( 1, 5, 9,13) [r2 r6 r10 r9]
    add r2, r6
    eor r9, r2
    ror r9, r9, #16
    add r10, r9
    eor r6, r10
    ror r6, r6, #20
    add r2, r6
    eor r9, r2
    ror r9, r9, #24
    add r10, r9
    eor r6, r10
    ror r6, r6, #25
    // QUARTERROUND( 2, 6,10,14) [r3 r7 r11 r14]
    add r3, r7
    eor r14, r3
    ror r14, r14, #16
    add r11, r14
    eor r7, r11
    ror r7, r7, #20
    add r3, r7
    eor r14, r3
    ror r14, r14, #24
    add r11, r14
    eor r7, r11
    ror r7, r7, #25
    // QUARTERROUND( 3, 7,11,15) [r4 r8 r12 r1]
    add r4, r8
    eor r1, r4
    ror r1, r1, #16
    add r12, r1
    eor r8, r12
    ror r8, r8, #20
    add r4, r8
    eor r1, r4
    ror r1, r1, #24
    add r12, r1
    eor r8, r12
    ror r8, r8, #25

    // switch from memory
    push {r10, r11} // store [9] and [10]
    ldr r10, [sp, #8] // retrieve [8]
    ldr r11, [sp, #12] // retrieve [12]

    // QUARTERROUND( 0, 4, 8,12) [r0 r5 r10 r11]
    add r0, r5
    eor r11, r0
    ror r11, r11, #16
    add r10, r11
    eor r5, r10
    ror r5, r5, #20
    add r0, r5
    eor r11, r0
    ror r11, r11, #24
    add r10, r11
    eor r5, r10
    ror r5, r5, #25
    // halfway there

    // QUARTERROUND( 1, 6,11,12) [r2 r7 r12 r11]
    add r2, r7
    eor r11, r2
    ror r11, r11, #16
    add r12, r11
    eor r7, r12
    ror r7, r7, #20
    add r2, r7
    eor r11, r2
    ror r11, r11, #24
    add r12, r11
    eor r7, r12
    ror r7, r7, #25
    // QUARTERROUND( 2, 7, 8,13) [r3 r8 r10 r9]
    add r3, r8
    eor r9, r3
    ror r9, r9, #16
    add r10, r9
    eor r8, r10
    ror r8, r8, #20
    add r3, r8
    eor r9, r3
    ror r9, r9, #24
    add r10, r9
    eor r8, r10
    ror r8, r8, #25

    // switch from memory
    str r10, [sp, #8] // store [8]
    str r11, [sp, #12] // store [12]
    pop {r10, r11} // retrieve [9] and [10]

    //  QUARTERROUND( 0, 5,10,15) [r0 r6 r11 r1]
    add r0, r6
    eor r1, r0
    ror r1, r1, #16
    add r11, r1
    eor r6, r11
    ror r6, r6, #20
    add r0, r6
    eor r1, r0
    ror r1, r1, #24
    add r11, r1
    eor r6, r11
    ror r6, r6, #25
    // QUARTERROUND( 3, 4, 9,14) [r4 r5 r10 r14]
    add r4, r5
    eor r14, r4
    ror r14, r14, #16
    add r10, r14
    eor r5, r10
    ror r5, r5, #20
    add r4, r5
    eor r14, r4
    ror r14, r14, #24
    add r10, r14
    eor r5, r10
    ror r5, r5, #25

    // new double-round starts here
    // QUARTERROUND( 1, 5, 9,13) [r2 r6 r10 r9]
    add r2, r6
    eor r9, r2
    ror r9, r9, #16
    add r10, r9
    eor r6, r10
    ror r6, r6, #20
    add r2, r6
    eor r9, r2
    ror r9, r9, #24
    add r10, r9
    eor r6, r10
    ror r6, r6, #25
    // QUARTERROUND( 2, 6,10,14) [r3 r7 r11 r14]
    add r3, r7
    eor r14, r3
    ror r14, r14, #16
    add r11, r14
    eor r7, r11
    ror r7, r7, #20
    add r3, r7
    eor r14, r3
    ror r14, r14, #24
    add r11, r14
    eor r7, r11
    ror r7, r7, #25
    // QUARTERROUND( 3, 7,11,15) [r4 r8 r12 r1]
    add r4, r8
    eor r1, r4
    ror r1, r1, #16
    add r12, r1
    eor r8, r12
    ror r8, r8, #20
    add r4, r8
    eor r1, r4
    ror r1, r1, #24
    add r12, r1
    eor r8, r12
    ror r8, r8, #25

    // switch from memory
    push {r10, r11} // store [9] and [10]
    ldr r10, [sp, #8] // retrieve [8]
    ldr r11, [sp, #12] // retrieve [12]

    // QUARTERROUND( 0, 4, 8,12) [r0 r5 r10 r11]
    add r0, r5
    eor r11, r0
    ror r11, r11, #16
    add r10, r11
    eor r5, r10
    ror r5, r5, #20
    add r0, r5
    eor r11, r0
    ror r11, r11, #24
    add r10, r11
    eor r5, r10
    ror r5, r5, #25
    // halfway there

    // QUARTERROUND( 1, 6,11,12) [r2 r7 r12 r11]
    add r2, r7
    eor r11, r2
    ror r11, r11, #16
    add r12, r11
    eor r7, r12
    ror r7, r7, #20
    add r2, r7
    eor r11, r2
    ror r11, r11, #24
    add r12, r11
    eor r7, r12
    ror r7, r7, #25
    // QUARTERROUND( 2, 7, 8,13) [r3 r8 r10 r9]
    add r3, r8
    eor r9, r3
    ror r9, r9, #16
    add r10, r9
    eor r8, r10
    ror r8, r8, #20
    add r3, r8
    eor r9, r3
    ror r9, r9, #24
    add r10, r9
    eor r8, r10
    ror r8, r8, #25

    // switch from memory
    str r10, [sp, #8] // store [8]
    str r11, [sp, #12] // store [12]
    pop {r10, r11} // retrieve [9] and [10]

    //  QUARTERROUND( 0, 5,10,15) [r0 r6 r11 r1]
    add r0, r6
    eor r1, r0
    ror r1, r1, #16
    add r11, r1
    eor r6, r11
    ror r6, r6, #20
    add r0, r6
    eor r1, r0
    ror r1, r1, #24
    add r11, r1
    eor r6, r11
    ror r6, r6, #25
    // QUARTERROUND( 3, 4, 9,14) [r4 r5 r10 r14]
    add r4, r5
    eor r14, r4
    ror r14, r14, #16
    add r10, r14
    eor r5, r10
    ror r5, r5, #20
    add r4, r5
    eor r14, r4
    ror r14, r14, #24
    add r10, r14
    eor r5, r10
    ror r5, r5, #25

    // new double-round starts here
    // QUARTERROUND( 1, 5, 9,13) [r2 r6 r10 r9]
    add r2, r6
    eor r9, r2
    ror r9, r9, #16
    add r10, r9
    eor r6, r10
    ror r6, r6, #20
    add r2, r6
    eor r9, r2
    ror r9, r9, #24
    add r10, r9
    eor r6, r10
    ror r6, r6, #25
    // QUARTERROUND( 2, 6,10,14) [r3 r7 r11 r14]
    add r3, r7
    eor r14, r3
    ror r14, r14, #16
    add r11, r14
    eor r7, r11
    ror r7, r7, #20
    add r3, r7
    eor r14, r3
    ror r14, r14, #24
    add r11, r14
    eor r7, r11
    ror r7, r7, #25
    // QUARTERROUND( 3, 7,11,15) [r4 r8 r12 r1]
    add r4, r8
    eor r1, r4
    ror r1, r1, #16
    add r12, r1
    eor r8, r12
    ror r8, r8, #20
    add r4, r8
    eor r1, r4
    ror r1, r1, #24
    add r12, r1
    eor r8, r12
    ror r8, r8, #25

    // switch from memory
    push {r10, r11} // store [9] and [10]
    ldr r10, [sp, #8] // retrieve [8]
    ldr r11, [sp, #12] // retrieve [12]

    // QUARTERROUND( 0, 4, 8,12) [r0 r5 r10 r11]
    add r0, r5
    eor r11, r0
    ror r11, r11, #16
    add r10, r11
    eor r5, r10
    ror r5, r5, #20
    add r0, r5
    eor r11, r0
    ror r11, r11, #24
    add r10, r11
    eor r5, r10
    ror r5, r5, #25
    // halfway there

    // QUARTERROUND( 1, 6,11,12) [r2 r7 r12 r11]
    add r2, r7
    eor r11, r2
    ror r11, r11, #16
    add r12, r11
    eor r7, r12
    ror r7, r7, #20
    add r2, r7
    eor r11, r2
    ror r11, r11, #24
    add r12, r11
    eor r7, r12
    ror r7, r7, #25
    // QUARTERROUND( 2, 7, 8,13) [r3 r8 r10 r9]
    add r3, r8
    eor r9, r3
    ror r9, r9, #16
    add r10, r9
    eor r8, r10
    ror r8, r8, #20
    add r3, r8
    eor r9, r3
    ror r9, r9, #24
    add r10, r9
    eor r8, r10
    ror r8, r8, #25

    // switch from memory
    str r10, [sp, #8] // store [8]
    str r11, [sp, #12] // store [12]
    pop {r10, r11} // retrieve [9] and [10]

    //  QUARTERROUND( 0, 5,10,15) [r0 r6 r11 r1]
    add r0, r6
    eor r1, r0
    ror r1, r1, #16
    add r11, r1
    eor r6, r11
    ror r6, r6, #20
    add r0, r6
    eor r1, r0
    ror r1, r1, #24
    add r11, r1
    eor r6, r11
    ror r6, r6, #25
    // QUARTERROUND( 3, 4, 9,14) [r4 r5 r10 r14]
    add r4, r5
    eor r14, r4
    ror r14, r14, #16
    add r10, r14
    eor r5, r10
    ror r5, r5, #20
    add r4, r5
    eor r14, r4
    ror r14, r14, #24
    add r10, r14
    eor r5, r10
    ror r5, r5, #25

    // new double-round starts here
    // QUARTERROUND( 1, 5, 9,13) [r2 r6 r10 r9]
    add r2, r6
    eor r9, r2
    ror r9, r9, #16
    add r10, r9
    eor r6, r10
    ror r6, r6, #20
    add r2, r6
    eor r9, r2
    ror r9, r9, #24
    add r10, r9
    eor r6, r10
    ror r6, r6, #25
    // QUARTERROUND( 2, 6,10,14) [r3 r7 r11 r14]
    add r3, r7
    eor r14, r3
    ror r14, r14, #16
    add r11, r14
    eor r7, r11
    ror r7, r7, #20
    add r3, r7
    eor r14, r3
    ror r14, r14, #24
    add r11, r14
    eor r7, r11
    ror r7, r7, #25
    // QUARTERROUND( 3, 7,11,15) [r4 r8 r12 r1]
    add r4, r8
    eor r1, r4
    ror r1, r1, #16
    add r12, r1
    eor r8, r12
    ror r8, r8, #20
    add r4, r8
    eor r1, r4
    ror r1, r1, #24
    add r12, r1
    eor r8, r12
    ror r8, r8, #25

    // switch from memory
    push {r10, r11} // store [9] and [10]
    ldr r10, [sp, #8] // retrieve [8]
    ldr r11, [sp, #12] // retrieve [12]

    // QUARTERROUND( 0, 4, 8,12) [r0 r5 r10 r11]
    add r0, r5
    eor r11, r0
    ror r11, r11, #16
    add r10, r11
    eor r5, r10
    ror r5, r5, #20
    add r0, r5
    eor r11, r0
    ror r11, r11, #24
    add r10, r11
    eor r5, r10
    ror r5, r5, #25
    // halfway there

    // QUARTERROUND( 1, 6,11,12) [r2 r7 r12 r11]
    add r2, r7
    eor r11, r2
    ror r11, r11, #16
    add r12, r11
    eor r7, r12
    ror r7, r7, #20
    add r2, r7
    eor r11, r2
    ror r11, r11, #24
    add r12, r11
    eor r7, r12
    ror r7, r7, #25
    // QUARTERROUND( 2, 7, 8,13) [r3 r8 r10 r9]
    add r3, r8
    eor r9, r3
    ror r9, r9, #16
    add r10, r9
    eor r8, r10
    ror r8, r8, #20
    add r3, r8
    eor r9, r3
    ror r9, r9, #24
    add r10, r9
    eor r8, r10
    ror r8, r8, #25

    // switch from memory
    str r10, [sp, #8] // store [8]
    str r11, [sp, #12] // store [12]
    pop {r10, r11} // retrieve [9] and [10]

    //  QUARTERROUND( 0, 5,10,15) [r0 r6 r11 r1]
    add r0, r6
    eor r1, r0
    ror r1, r1, #16
    add r11, r1
    eor r6, r11
    ror r6, r6, #20
    add r0, r6
    eor r1, r0
    ror r1, r1, #24
    add r11, r1
    eor r6, r11
    ror r6, r6, #25
    // QUARTERROUND( 3, 4, 9,14) [r4 r5 r10 r14]
    add r4, r5
    eor r14, r4
    ror r14, r14, #16
    add r10, r14
    eor r5, r10
    ror r5, r5, #20
    add r4, r5
    eor r14, r4
    ror r14, r14, #24
    add r10, r14
    eor r5, r10
    ror r5, r5, #25

    // new double-round starts here
    // QUARTERROUND( 1, 5, 9,13) [r2 r6 r10 r9]
    add r2, r6
    eor r9, r2
    ror r9, r9, #16
    add r10, r9
    eor r6, r10
    ror r6, r6, #20
    add r2, r6
    eor r9, r2
    ror r9, r9, #24
    add r10, r9
    eor r6, r10
    ror r6, r6, #25
    // QUARTERROUND( 2, 6,10,14) [r3 r7 r11 r14]
    add r3, r7
    eor r14, r3
    ror r14, r14, #16
    add r11, r14
    eor r7, r11
    ror r7, r7, #20
    add r3, r7
    eor r14, r3
    ror r14, r14, #24
    add r11, r14
    eor r7, r11
    ror r7, r7, #25
    // QUARTERROUND( 3, 7,11,15) [r4 r8 r12 r1]
    add r4, r8
    eor r1, r4
    ror r1, r1, #16
    add r12, r1
    eor r8, r12
    ror r8, r8, #20
    add r4, r8
    eor r1, r4
    ror r1, r1, #24
    add r12, r1
    eor r8, r12
    ror r8, r8, #25

    // switch from memory
    push {r10, r11} // store [9] and [10]
    ldr r10, [sp, #8] // retrieve [8]
    ldr r11, [sp, #12] // retrieve [12]

    // QUARTERROUND( 0, 4, 8,12) [r0 r5 r10 r11]
    add r0, r5
    eor r11, r0
    ror r11, r11, #16
    add r10, r11
    eor r5, r10
    ror r5, r5, #20
    add r0, r5
    eor r11, r0
    ror r11, r11, #24
    add r10, r11
    eor r5, r10
    ror r5, r5, #25
    // halfway there

    // QUARTERROUND( 1, 6,11,12) [r2 r7 r12 r11]
    add r2, r7
    eor r11, r2
    ror r11, r11, #16
    add r12, r11
    eor r7, r12
    ror r7, r7, #20
    add r2, r7
    eor r11, r2
    ror r11, r11, #24
    add r12, r11
    eor r7, r12
    ror r7, r7, #25
    // QUARTERROUND( 2, 7, 8,13) [r3 r8 r10 r9]
    add r3, r8
    eor r9, r3
    ror r9, r9, #16
    add r10, r9
    eor r8, r10
    ror r8, r8, #20
    add r3, r8
    eor r9, r3
    ror r9, r9, #24
    add r10, r9
    eor r8, r10
    ror r8, r8, #25

    // switch from memory
    str r10, [sp, #8] // store [8]
    str r11, [sp, #12] // store [12]
    pop {r10, r11} // retrieve [9] and [10]

    //  QUARTERROUND( 0, 5,10,15) [r0 r6 r11 r1]
    add r0, r6
    eor r1, r0
    ror r1, r1, #16
    add r11, r1
    eor r6, r11
    ror r6, r6, #20
    add r0, r6
    eor r1, r0
    ror r1, r1, #24
    add r11, r1
    eor r6, r11
    ror r6, r6, #25
    // QUARTERROUND( 3, 4, 9,14) [r4 r5 r10 r14]
    add r4, r5
    eor r14, r4
    ror r14, r14, #16
    add r10, r14
    eor r5, r10
    ror r5, r5, #20
    add r4, r5
    eor r14, r4
    ror r14, r14, #24
    add r10, r14
    eor r5, r10
    ror r5, r5, #25

    // new double-round starts here
    // QUARTERROUND( 1, 5, 9,13) [r2 r6 r10 r9]
    add r2, r6
    eor r9, r2
    ror r9, r9, #16
    add r10, r9
    eor r6, r10
    ror r6, r6, #20
    add r2, r6
    eor r9, r2
    ror r9, r9, #24
    add r10, r9
    eor r6, r10
    ror r6, r6, #25
    // QUARTERROUND( 2, 6,10,14) [r3 r7 r11 r14]
    add r3, r7
    eor r14, r3
    ror r14, r14, #16
    add r11, r14
    eor r7, r11
    ror r7, r7, #20
    add r3, r7
    eor r14, r3
    ror r14, r14, #24
    add r11, r14
    eor r7, r11
    ror r7, r7, #25
    // QUARTERROUND( 3, 7,11,15) [r4 r8 r12 r1]
    add r4, r8
    eor r1, r4
    ror r1, r1, #16
    add r12, r1
    eor r8, r12
    ror r8, r8, #20
    add r4, r8
    eor r1, r4
    ror r1, r1, #24
    add r12, r1
    eor r8, r12
    ror r8, r8, #25

    // switch from memory
    push {r10, r11} // store [9] and [10]
    ldr r10, [sp, #8] // retrieve [8]
    ldr r11, [sp, #12] // retrieve [12]

    // QUARTERROUND( 0, 4, 8,12) [r0 r5 r10 r11]
    add r0, r5
    eor r11, r0
    ror r11, r11, #16
    add r10, r11
    eor r5, r10
    ror r5, r5, #20
    add r0, r5
    eor r11, r0
    ror r11, r11, #24
    add r10, r11
    eor r5, r10
    ror r5, r5, #25
    // halfway there

    // QUARTERROUND( 1, 6,11,12) [r2 r7 r12 r11]
    add r2, r7
    eor r11, r2
    ror r11, r11, #16
    add r12, r11
    eor r7, r12
    ror r7, r7, #20
    add r2, r7
    eor r11, r2
    ror r11, r11, #24
    add r12, r11
    eor r7, r12
    ror r7, r7, #25
    // QUARTERROUND( 2, 7, 8,13) [r3 r8 r10 r9]
    add r3, r8
    eor r9, r3
    ror r9, r9, #16
    add r10, r9
    eor r8, r10
    ror r8, r8, #20
    add r3, r8
    eor r9, r3
    ror r9, r9, #24
    add r10, r9
    eor r8, r10
    ror r8, r8, #25

    // switch from memory
    str r10, [sp, #8] // store [8]
    str r11, [sp, #12] // store [12]
    pop {r10, r11} // retrieve [9] and [10]

    //  QUARTERROUND( 0, 5,10,15) [r0 r6 r11 r1]
    add r0, r6
    eor r1, r0
    ror r1, r1, #16
    add r11, r1
    eor r6, r11
    ror r6, r6, #20
    add r0, r6
    eor r1, r0
    ror r1, r1, #24
    add r11, r1
    eor r6, r11
    ror r6, r6, #25
    // QUARTERROUND( 3, 4, 9,14) [r4 r5 r10 r14]
    add r4, r5
    eor r14, r4
    ror r14, r14, #16
    add r10, r14
    eor r5, r10
    ror r5, r5, #20
    add r4, r5
    eor r14, r4
    ror r14, r14, #24
    add r10, r14
    eor r5, r10
    ror r5, r5, #25

    // new double-round starts here
    // QUARTERROUND( 1, 5, 9,13) [r2 r6 r10 r9]
    add r2, r6
    eor r9, r2
    ror r9, r9, #16
    add r10, r9
    eor r6, r10
    ror r6, r6, #20
    add r2, r6
    eor r9, r2
    ror r9, r9, #24
    add r10, r9
    eor r6, r10
    ror r6, r6, #25
    // QUARTERROUND( 2, 6,10,14) [r3 r7 r11 r14]
    add r3, r7
    eor r14, r3
    ror r14, r14, #16
    add r11, r14
    eor r7, r11
    ror r7, r7, #20
    add r3, r7
    eor r14, r3
    ror r14, r14, #24
    add r11, r14
    eor r7, r11
    ror r7, r7, #25
    // QUARTERROUND( 3, 7,11,15) [r4 r8 r12 r1]
    add r4, r8
    eor r1, r4
    ror r1, r1, #16
    add r12, r1
    eor r8, r12
    ror r8, r8, #20
    add r4, r8
    eor r1, r4
    ror r1, r1, #24
    add r12, r1
    eor r8, r12
    ror r8, r8, #25

    // switch from memory
    push {r10, r11} // store [9] and [10]
    ldr r10, [sp, #8] // retrieve [8]
    ldr r11, [sp, #12] // retrieve [12]

    // QUARTERROUND( 0, 4, 8,12) [r0 r5 r10 r11]
    add r0, r5
    eor r11, r0
    ror r11, r11, #16
    add r10, r11
    eor r5, r10
    ror r5, r5, #20
    add r0, r5
    eor r11, r0
    ror r11, r11, #24
    add r10, r11
    eor r5, r10
    ror r5, r5, #25
    // halfway there

    // QUARTERROUND( 1, 6,11,12) [r2 r7 r12 r11]
    add r2, r7
    eor r11, r2
    ror r11, r11, #16
    add r12, r11
    eor r7, r12
    ror r7, r7, #20
    add r2, r7
    eor r11, r2
    ror r11, r11, #24
    add r12, r11
    eor r7, r12
    ror r7, r7, #25
    // QUARTERROUND( 2, 7, 8,13) [r3 r8 r10 r9]
    add r3, r8
    eor r9, r3
    ror r9, r9, #16
    add r10, r9
    eor r8, r10
    ror r8, r8, #20
    add r3, r8
    eor r9, r3
    ror r9, r9, #24
    add r10, r9
    eor r8, r10
    ror r8, r8, #25

    // switch from memory
    str r10, [sp, #8] // store [8]
    str r11, [sp, #12] // store [12]
    pop {r10, r11} // retrieve [9] and [10]

    //  QUARTERROUND( 0, 5,10,15) [r0 r6 r11 r1]
    add r0, r6
    eor r1, r0
    ror r1, r1, #16
    add r11, r1
    eor r6, r11
    ror r6, r6, #20
    add r0, r6
    eor r1, r0
    ror r1, r1, #24
    add r11, r1
    eor r6, r11
    ror r6, r6, #25
    // QUARTERROUND( 3, 4, 9,14) [r4 r5 r10 r14]
    add r4, r5
    eor r14, r4
    ror r14, r14, #16
    add r10, r14
    eor r5, r10
    ror r5, r5, #20
    add r4, r5
    eor r14, r4
    ror r14, r14, #24
    add r10, r14
    eor r5, r10
    ror r5, r5, #25

    // new double-round starts here
    // QUARTERROUND( 1, 5, 9,13) [r2 r6 r10 r9]
    add r2, r6
    eor r9, r2
    ror r9, r9, #16
    add r10, r9
    eor r6, r10
    ror r6, r6, #20
    add r2, r6
    eor r9, r2
    ror r9, r9, #24
    add r10, r9
    eor r6, r10
    ror r6, r6, #25
    // QUARTERROUND( 2, 6,10,14) [r3 r7 r11 r14]
    add r3, r7
    eor r14, r3
    ror r14, r14, #16
    add r11, r14
    eor r7, r11
    ror r7, r7, #20
    add r3, r7
    eor r14, r3
    ror r14, r14, #24
    add r11, r14
    eor r7, r11
    ror r7, r7, #25
    // QUARTERROUND( 3, 7,11,15) [r4 r8 r12 r1]
    add r4, r8
    eor r1, r4
    ror r1, r1, #16
    add r12, r1
    eor r8, r12
    ror r8, r8, #20
    add r4, r8
    eor r1, r4
    ror r1, r1, #24
    add r12, r1
    eor r8, r12
    ror r8, r8, #25

    // switch from memory
    push {r10, r11} // store [9] and [10]
    ldr r10, [sp, #8] // retrieve [8]
    ldr r11, [sp, #12] // retrieve [12]

    // QUARTERROUND( 0, 4, 8,12) [r0 r5 r10 r11]
    add r0, r5
    eor r11, r0
    ror r11, r11, #16
    add r10, r11
    eor r5, r10
    ror r5, r5, #20
    add r0, r5
    eor r11, r0
    ror r11, r11, #24
    add r10, r11
    eor r5, r10
    ror r5, r5, #25
    // halfway there

    // QUARTERROUND( 1, 6,11,12) [r2 r7 r12 r11]
    add r2, r7
    eor r11, r2
    ror r11, r11, #16
    add r12, r11
    eor r7, r12
    ror r7, r7, #20
    add r2, r7
    eor r11, r2
    ror r11, r11, #24
    add r12, r11
    eor r7, r12
    ror r7, r7, #25
    // QUARTERROUND( 2, 7, 8,13) [r3 r8 r10 r9]
    add r3, r8
    eor r9, r3
    ror r9, r9, #16
    add r10, r9
    eor r8, r10
    ror r8, r8, #20
    add r3, r8
    eor r9, r3
    ror r9, r9, #24
    add r10, r9
    eor r8, r10
    ror r8, r8, #25

    // switch from memory
    str r10, [sp, #8] // store [8]
    str r11, [sp, #12] // store [12]
    pop {r10, r11} // retrieve [9] and [10]

    //  QUARTERROUND( 0, 5,10,15) [r0 r6 r11 r1]
    add r0, r6
    eor r1, r0
    ror r1, r1, #16
    add r11, r1
    eor r6, r11
    ror r6, r6, #20
    add r0, r6
    eor r1, r0
    ror r1, r1, #24
    add r11, r1
    eor r6, r11
    ror r6, r6, #25
    // QUARTERROUND( 3, 4, 9,14) [r4 r5 r10 r14]
    add r4, r5
    eor r14, r4
    ror r14, r14, #16
    add r10, r14
    eor r5, r10
    ror r5, r5, #20
    add r4, r5
    eor r14, r4
    ror r14, r14, #24
    add r10, r14
    eor r5, r10
    ror r5, r5, #25




    // and now it is done, we unpack
    push {r1} // save the value in r0 to make room for the output address
    ldr r1, [sp, #12] // skip over some stack stuff
    stm r1!, {r0, r2-r8}
    ldm sp, {r2-r4} // load three registers that are temporarily on the stack
    stm r1!, {r3, r10-r12}
    stm r1!, {r4, r9, r14}
    str r2, [r1, #0]

    add sp, #12
    pop {r0-r12, r14} // restore everything
    bx lr
