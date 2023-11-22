        lda #2 ; A = 2
        sta 2 ; X = 2
initialize
        sta 70,X ; ram[70+x] = A
        adc #1 ; A++
        inc 2 ; X++
        cmp #50 ; compare A to 50
        bne initialize ; repeat until A = 50

        lda #2 ; A = 2
        sta 2 ; X = 2
outer_loop
        lda 70,X ; A = ram[70+X]
        cmp #0 ; compare A to 0
        beq next_number ; if A = 0, A is not prime, so go to the next number
        sta 69 ; ram[69] = A
inner_loop
        clc ; clear carry
        adc 69 ; A = A+ram[69]
        tay ; Y = A
        lda 69 ; A = ram[69]
        cpy #50 ; TODO compare Y to 50
        bpl next_number ; if Y is bigger than 50 go to next number
        lda #0 ; A = 0
        sta 70,Y ; ram[70+Y] = 0, marked as not prime
        tya ; A = Y
        jmp inner_loop

next_number
        inc 2 ; X++
        cpx #50 ; TODO compare X to 50
        bne outer_loop ; if X = 50 we are done

