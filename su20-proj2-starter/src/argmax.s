.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.

# int argmax(int *vec, int num) {
#     if (num < 1) {
#         exit;
#     }
#     int index = 0;
#     int max = vec[0];
#     for (int i = 1; i < num; i++) {
#         if (vec[i] > max) {
#             max = vec[i];
# 	    index = i;
#         }
#     }
#     return index;
# }

# =================================================================
argmax:
    # Prologue
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)

    mv s0 a0 # vec
    mv s1 a1 # num

    li t0 1
    blt s1 t0 err_ret
loop_start:
    li s2 0 # index
    lw s3 0(s0) # max
    li s4 1 # i
    addi s0 s0 4

loop_continue:
    bge s4, s1, loop_end
    lw t0 0(s0)
    ble t0 s3 increment
    mv s3 t0
    mv s2 s4

increment:
    addi s0 s0 4
    addi s4 s4 1
    j loop_continue

loop_end:
    # Epilogue
    mv a0, s2
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    addi sp, sp, 20
    ret

err_ret:
    li a1 7
    jal exit2
