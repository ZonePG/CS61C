.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.

# void write_matrix(char *fileName, int *matrix, int row, int col) {
#     FILE *fp;
#     if((fptr=fopen("xxx.bin","wb"))==NULL) {
#         puts("Cannot Open File");
#     }
#
#     fwrite(&mat->rows,sizeof(int), 1, fptr);
#     fwrite(&mat->cols,sizeof(int), 1, fptr);
#     fwrite(mat->matrix,sizeof(int), (mat->rows*mat->cols),fptr);
#
#     fclose(fp);
# }

# ==============================================================================
write_matrix:
    # Prologue
    addi sp sp -32
    sw ra 0(sp)
    sw s0 4(sp)  # row
    sw s1 8(sp)  # col
    sw s2 12(sp) # fp
    sw s3 16(sp) # matrix
    sw s4 20(sp) # matrix size

    # sp + 24 as point
    sw a2 24(sp)
    sw a3 28(sp)

    mv s0 a2
    mv s1 a3
    mv s3 a1

    # call fopen
    mv a1 a0
    li a2 1
    jal fopen

    mv s2 a0
    li t0 -1
    beq s2 t0 err_fopen

    # call fwrite
    mv a1 s2
    addi t0 sp 24
    mv a2 t0
    li a3 2
    li a4 4
    jal fwrite
    li t0 2
    bne a0 t0 err_fwrite

    # call fwrite matrix
    mv a1 s2
    mv a2 s3
    mul s4 s0 s1
    mv a3 s4
    li a4 4
    jal fwrite
    bne a0 s4 err_fwrite

    # fclose
    mv a1 s2
    jal fclose
    li t0 -1
    beq a0 t0 err_fclose

    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    addi sp sp 32

    ret

err_fopen:
    li a1 53
    jal exit2

err_fwrite:
    li a1 54
    jal exit2

err_fclose:
    li a1 55
    jal exit2
