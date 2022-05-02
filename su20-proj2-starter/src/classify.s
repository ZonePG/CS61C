.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

# int classify(int argc, char **argv, int flag) {
#     if (argc != 5) {
#         exit(49);
#     }
#
#
#     # load metrics
#     char *M0_PATH = argv[1];
#     char *M1_PATH = argv[2];
#     char *INPUT_PATH = argv[3];
#     char *OUTPUT_PATH = argv[4];
#
#     int *m0_row = malloc(sizeof(int));
#     int *m0_col = malloc(sizeof(int));
#     int *m0 = read_matrix(M0_PATH, m0_row, m0_col);
#
#     int *m1_row = malloc(sizeof(int));
#     int *m1_col = malloc(sizeof(int));
#     int *m1 = read_matrix(M1_PATH, m1_row, m1_col);
#
#     int *input_row = malloc(sizeof(int));
#     int *input_col = malloc(sizeof(int));
#     int *input = read_matrix(INPUT_PATH, m1_row, m1_col);
#
#     # run layer
#     int hidden_layer_size = *m0_row * *input_col;
#     int *hidden_layer = malloc(hidden_layer_size * sizeof(int));
#     matmul(m0, m0_row, m0_col, input, input_row, input_col, hidden_layer);
#     relu(hidden_layer, hidden_layer_size);
#
#     int scores_size = *m1_row * *input_col;
#     int *scores = malloc(scores_size * sizeof(int));
#     matmul(m1, m1_row, m1_col, hidden_layer, *m0_row, *input_col, scores);
#
#     # output
#     write_matrix(OUTPUT_PATH, scores, *m1_row, *input_col);
#
#     # argmax
#     int index = argmax(scores, scores_size);
#
#     println(index);
# }

    # Prologue
    addi sp sp -56
    sw ra 0(sp)
    sw s0 4(sp) # argv
    sw s1 8(sp) # flag
    sw s2 12(sp) # *m0_row or index
    sw s3 16(sp) # *m0_col
    sw s4 20(sp) # *m0
    sw s5 24(sp) # *m1_row
    sw s6 28(sp) # *m1_col
    sw s7 32(sp) # *m1
    sw s8 36(sp) # *input_row
    sw s9 40(sp) # *input_col
    sw s10 44(sp) # *input
    sw s11 48(sp) # *hidden_layer
    # 52(sp) store scores

    mv s0 a1
    mv s1 a2

    li t0 5
    bne a0 t0 err_argc

    # =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    li a0 4
    jal malloc
    mv s2 a0
    beqz s2 err_malloc

    li a0 4
    jal malloc
    mv s3 a0
    beqz s3 err_malloc

    lw a0 4(s0)
    mv a1 s2
    mv a2 s3
    jal read_matrix
    mv s4 a0

    # Load pretrained m1
    li a0 4
    jal malloc
    mv s5 a0
    beqz s5 err_malloc

    li a0 4
    jal malloc
    mv s6 a0
    beqz s6 err_malloc

    lw a0 8(s0)
    mv a1 s5
    mv a2 s6
    jal read_matrix
    mv s7 a0

    # Load input matrix
    li a0 4
    jal malloc
    mv s8 a0
    beqz s8 err_malloc

    li a0 4
    jal malloc
    mv s9 a0
    beqz s9 err_malloc

    lw a0 12(s0)
    mv a1 s8
    mv a2 s9
    jal read_matrix
    mv s10 a0


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    lw t0 0(s2)
    lw t1 0(s9)
    mul t0 t0 t1 # hidden_layer_size

    slli a0 t0 2
    jal malloc
    mv s11 a0    # hidden_layer
    beqz s11 err_malloc

    # 1. call matmul, m0 * input
    mv a0 s4
    lw a1 0(s2)
    lw a2 0(s3)
    mv a3 s10
    lw a4 0(s8)
    lw a5 0(s9)
    mv a6 s11
    jal matmul

    # 2. relu hidden_layer
    mv a0 s11
    lw t0 0(s2)
    lw t1 0(s9)
    mul a1 t0 t1 # hidden_layer_size
    jal relu

    # 3. call matmul, m1 * hidden_layer
    lw t0 0(s5)
    lw t1 0(s9)
    mul t0 t0 t1 # scores_size
    slli a0 t0 2
    jal malloc
    beqz a0 err_malloc
    sw a0 52(sp)    # scores

    mv a0 s7
    lw a1 0(s5)
    lw a2 0(s6)
    mv a3 s11
    lw a4 0(s2)
    lw a5 0(s9)
    lw a6 52(sp)
    jal matmul


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0 16(s0)
    lw a1 52(sp)
    lw a2 0(s5)
    lw a3 0(s9)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================

    # free m0
    mv a0 s2
    jal free
    mv a0 s3
    jal free
    mv a0 s4
    jal free

    # Call argmax
    lw a0 52(sp)
    lw t0 0(s5)
    lw t1 0(s9)
    mul a1 t0 t1 # scores_size
    jal argmax
    mv s2 a0  # index

    bne s1 x0 no_print

    # Print classification
    mv a1 s2
    jal print_int

    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

no_print:

    # free
    mv a0 s5
    jal free
    mv a0 s6
    jal free
    mv a0 s7
    jal free

    mv a0 s8
    jal free
    mv a0 s9
    jal free
    mv a0 s10
    jal free

    mv a0 s11
    jal free

    # free scores
    lw a0 52(sp)
    jal free

    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp) # argv or index
    lw s1 8(sp) # flag
    lw s2 12(sp) # *m0_row
    lw s3 16(sp) # *m0_col
    lw s4 20(sp) # *m0
    lw s5 24(sp) # *m1_row
    lw s6 28(sp) # *m1_col
    lw s7 32(sp) # *m1
    lw s8 36(sp) # *input_row
    lw s9 40(sp) # *input_col
    lw s10 44(sp) # *input
    lw s11 48(sp) # *hidden_layer
    addi sp sp 52

    ret

err_argc:
    li a1 49
    jal exit2

err_malloc:
    li a1 48
    jal exit2
