.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.

# int dot(int* vec0, int *vec1, int len, int stride1, int stride2) {
#      if (len < 1) {
#          exit(5)
#      }
#
#      if (stride1 < 1) {
#          exit(6)
#      }
#
#      if (stride2 < 1) {
#          exit(6)
#      }
#
#      int sum = 0;
#      for (int i = 0; i < len; i++) {
#          sum += vec0[i * stride1] * vec1[i * stride2];
#      }
#      return sum;
#  }

# =======================================================
dot:
    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)   # vec0
    sw s1, 4(sp)   # vec1
    sw s2, 8(sp)   # len
    sw s3, 12(sp)  # stride1
    sw s4, 16(sp)  # stride2
    sw s5, 20(sp)  # sum
    sw s6, 24(sp)  # i

    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3
    mv s4 a4

    li t0 1
    blt s2 t0 err_len
    blt s3 t0 err_stride
    blt s4 t0 err_stride


loop_start:
    li s5 0
    li s6 0

loop_continue:
    bge s6 s2 loop_end
    lw t0 0(s0)
    lw t1 0(s1)
    mul t0 t0 t1
    add s5 s5 t0

    addi s6 s6 1
    slli t0 s3 2
    add s0 s0 t0
    slli t0 s4 2
    add s1 s1 t0
    j loop_continue

loop_end:
    mv a0, s5
    # Epilogue

    lw s0, 0(sp)   # vec0
    lw s1, 4(sp)   # vec1
    lw s2, 8(sp)   # len
    lw s3, 12(sp)  # stride1
    lw s4, 16(sp)  # stride2
    lw s5, 20(sp)  # sum
    lw s6, 24(sp)  # i
    addi sp sp 28
    ret

err_len:
    li a1 5
    jal exit2

err_stride:
    li a1 6
    jal exit2
