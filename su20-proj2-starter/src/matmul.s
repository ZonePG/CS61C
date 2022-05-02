.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)

# void matmul(int* m0, int row0, int col0, int *m1, int row1, int col1, int *d) {
#     if (row0 < 1 || col0 < 1) {
#         exit(2);
#     }
#
#     if (row1 < 1 || col1 < 1) {
#         exit(3);
#     }
#
#     if (col0 != row1) {
#         exit(4);
#     }
#
#     for (int i = 0; i < row0; i++) {
#         for (int j = 0; j < col1; j++) {
#            d[i * col0 + j] = dot(&m0[i * col0], &m1[j], col0, 1, col1);
#         }
#     }
# }

# =======================================================
matmul:

    # Prologue
    addi sp, sp, -40
    sw s0 0(sp)   # m0
    sw s1 4(sp)   # row0
    sw s2 8(sp)   # col0
    sw s3 12(sp)  # m1
    sw s4 16(sp)  # row1
    sw s5 20(sp)  # col1
    sw s6 24(sp)  # d
    sw s7 28(sp)  # i
    sw s8 32(sp)   # j
    sw ra 36(sp)

    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3
    mv s4 a4
    mv s5 a5
    mv s6 a6

    # mv a0 s0
    # mv a1 s1
    # mv a2 s2
    # jal print_int_array

    # mv a0 s3
    # mv a1 s4
    # mv a2 s5
    # jal print_int_array

    li t0 1
    blt s1 t0 err_m0
    blt s2 t0 err_m0
    blt s4 t0 err_m1
    blt s5 t0 err_m1
    bne s2 s4 err_match

outer_loop_start:
    li s7 0

outer_continue:
    mv a1 s7
    bge s7 s1 outer_loop_end

inner_loop_start:
    li s8 0

inner_continue:
    bge s8 s5 inner_loop_end

    # Call dot function, caller saved
    mv a0 s0
    slli t0 s8 2
    add a1 s3 t0
    mv a2 s2
    li a3 1
    mv a4 s5
    jal dot
    sw a0 0(s6)

    # mv a1 a0
    # jal print_int

    # li a1 ' '
    # jal print_char

    addi s8 s8 1
    addi s6 s6 4
    j inner_continue

inner_loop_end:
    addi s7 s7 1
    slli t0 s2 2
    add s0 s0 t0
    j outer_continue

outer_loop_end:
    # Epilogue
    lw s0 0(sp)   # m0
    lw s1 4(sp)   # row0
    lw s2 8(sp)   # col0
    lw s3 12(sp)  # m1
    lw s4 16(sp)  # row1
    lw s5 20(sp)  # col1
    lw s6 24(sp)  # d
    lw s7 28(sp)  # i
    lw s8 32(sp)   # j
    lw ra 36(sp)
    addi sp, sp, 40
    ret

err_m0:
    li a1 2
    jal exit2

err_m1:
    li a1 3
    jal exit2

err_match:
    li a1 4
    jal exit2
