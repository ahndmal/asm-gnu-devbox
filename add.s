.data
val1:
    .long       0x1234
val2:
    .long       0x5678

.text

.globl main
main:
    movl    $4, %eax
    movl    (val1), %eax
    addl    (val2), %eax
