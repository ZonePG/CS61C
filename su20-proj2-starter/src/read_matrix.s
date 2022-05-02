.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.

# int *read_matrix(char *fileName, int *row, int *col) {
#     FILE *fp;
#     if ((fp = fopen("xxx.bin", "rb")) == NULL) {
#         return 0;
#     }
#
#     fread(&mat->rows, sizeof(int), fp);
#     fread(&mat->cols, sizeof(int), fp);
#
#     mat->matrix = (int *)malloc(sizeof(int) * (mat->rows * mat->cols));
#     fread(mat->matrix, sizeof(double), (mat->rows * mat->cols), fp);
#
#     fclose(fp);
#     return mat->matrix;
# }

# ==============================================================================
read_matrix:

    # Prologue
    addi sp sp -24
    sw ra 0(sp)
    sw s0 4(sp)  # row
    sw s1 8(sp)  # col
    sw s2 12(sp) # fp
    sw s3 16(sp) # matrix
    sw s4 20(sp) # matrix size

    mv s0 a1
    mv s1 a2

    # call fopen
    mv a1 a0
    li a2 0
    jal fopen

    mv s2 a0
    li t0 -1
    beq s2 t0 err_fopen

    # call fread
    mv a1 s2
    mv a2 s0
    li a3 4
    jal fread
    li t0 4
    bne a0 t0 err_fread

    mv a1 s2
    mv a2 s1
    li a3 4
    jal fread
    li t0 4
    bne a0 t0 err_fread

    # malloc matrix
    lw t0 0(s0)
    lw t1 0(s1)
    mul s4 t0 t1
    slli s4 s4 2
    mv a0 s4
    jal malloc
    mv s3 a0
    beqz s3 err_malloc

    # fread matrix
    mv a1 s2
    mv a2 s3
    mv a3 s4
    jal fread
    bne a0 s4 err_fread

    # fclose
    mv a1 s2
    jal fclose
    li t0 -1
    beq a0 t0 err_fclose

    # Epilogue
    mv a0 s3

    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    addi sp sp 24

    ret

err_fopen:
    li a1 50
    jal exit2

err_fread:
    li a1 51
    jal exit2

err_malloc:
    li a1 48
    jal exit2

err_fclose:
    li a1 55
    jal exit2
