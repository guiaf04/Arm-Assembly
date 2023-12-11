.text

.global discriminant
discriminant: 
    STP X29, X30, [SP, #-16]!
    
    FMUL D3, D1, D1 //b²
    FMOV D4, #4
    FMUL D4, D4, D0 //4a
    FMUL D4, D4, D2 //4ac
    FSUB D3, D3, D4 //b² - 4ac

    FMOV D0, D3 // D0 IS THE RETURN OF FUNCTION, WHICH IS THE DELTA
    
    LDP X29, X30, [SP], #16
    RET

.global quadraticFormula
quadraticFormula:    
    STP X29, X30, [SP, #-16]!

    FMOV D16, D0
    BL discriminant
    FMOV D3, D0
    FMOV D0, D16

    FCMP D3, #0.0
    BLT negative
    FSQRT D3, D3 //D3 IS THE SQRT OF DELTA

    FMOV D7, #2

    //FNEG D5, D1 //-b
    FSUB D5, D3, D1 // -b + sqrt delta
    FDIV D5, D5, D7
    FDIV D5, D5, D0 // /2a
    STR D5, [X0]

    FNEG D6, D1 //-b
    FSUB D6, D6, D3 // -b - sqrt delta
    FDIV D6, D6, D7
    FDIV D6, D6, D0 // /2a
    STR D6, [X1]

    FCMP D3, #0.0
    BEQ zero
    BGT positive
    BLT negative

    zero:
        MOV W0, #0
        B end

    positive:
        MOV W0, #1
        B end

    negative:
        MOV W0, #-1

    end:

    LDP X29, X30, [SP], #16
    RET