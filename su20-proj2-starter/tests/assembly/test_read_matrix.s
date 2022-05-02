.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"

.text

# int main() {
#     int *row, *col;
#     row = (int *) malloc(sizeof(int));
#     col = (int *) malloc(sizeof(int));
#     int *matrix = read_matrix(file_path, row, col);
#     print_int_array(matrix);
#     return 0;
# }

main:
    # Read matrix into memory
    li a0 4
    jal malloc
    mv s0 a0
    beqz s0 err_malloc

    li a0 4
    jal malloc
    mv s1 a0
    beqz s0 err_malloc

    la a0 file_path
    mv a1 s0
    mv a2 s1
    jal read_matrix
    mv s2 a0

    # Print out elements of matrix
    mv a0 s2
    lw a1 0(s0)
    lw a2 0(s1)
    jal print_int_array


    # Terminate the program
    jal exit

err_malloc:
    li a1 48
    jal exit2
