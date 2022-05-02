.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.

# void relu(int *vec, int num) {
#     if (num < 1) {
#         exit(8);
#     }
#
#     for (int i = 0; i < num; i++) {
#         if (vec[i] < 0) {
#             vec[i] = 0;
# 	}
#     }
# }

# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -12
    sw s0 0(sp) # vec
    sw s1 4(sp) # num
    sw s2 8(sp) # i

    mv s0 a0
    mv s1 a1

    li t0 1
    ble s1 t0 err_len

loop_start:
    li s2 0

loop_continue:
    bge s2, s1, loop_end
    lw t0 0(s0)
    bge t0 x0 increment
    sw x0 0(s0)

increment:
    addi s2, s2, 1
    addi s0, s0, 4
    j loop_continue

loop_end:
    # Epilogue
    lw s0, 0(sp) # vec
    lw s1, 4(sp) # num
    lw s2, 8(sp) # i
    addi sp, sp, 12
    ret

err_len:
    li a1 8
    jal exit2
