.text

// double min_array(double *array, int n);
// X0 = array
// X1 = n
.global min_array
min_array:
    STP X29, X30, [SP, #-16]!

    LDR D2, [X0], #8
min_array_loop:
    SUB X1, X1, #1
    CBZ X1, min_array_end
    LDR D0, [X0], #8
    FMIN D2, D2, D0
    B min_array_loop

min_array_end:
    FMOV D0, D2 
    LDP X29, X30, [SP], #16
    RET

// double max_array(double *array, int n);
// X0 = array
// X1 = n
.global max_array
max_array:
    STP X29, X30, [SP, #-16]!

    LDR D2, [X0], #8
max_array_loop:
    SUB X1, X1, #1
    CBZ X1, max_array_end
    LDR D0, [X0], #8
    FMAX D2, D2, D0
    B max_array_loop

max_array_end:
    FMOV D0, D2 
    LDP X29, X30, [SP], #16
    RET

// double min_plus_max(double *array, int n);
.global min_plus_max
min_plus_max:
    STP X29, X30, [SP, #-16]!

    MOV X19, X0
    MOV X20, X1

    BL min_array
    FMOV D16, D0

    MOV X0, X19
    MOV X1, X20
    BL max_array

    FADD D0, D0, D16
    LDP X29, X30, [SP], #16
    RET
