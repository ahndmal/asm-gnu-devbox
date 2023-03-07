/*
    #include <stdio.h>

    int main()
    {
    unsigned int a, c;

    a = 1;
    switch(a)
    {
        case 0:
        c = 5;
        break;

        case 1:
        c = 15;
        break;

        case 3:
        c = 35;
        break;

        default:
        c = 100;
        break;
    }

    printf("%u\n", c);
    return 0;
    }
*/

.data
printf_format:
        .string "%u\n"

.text
.globl main

main:
        pushl %ebp
        movl  %esp, %ebp

        movl  $1, %eax          /* получить в %eax некоторое 
                                   интересующее нас значение         */

                                /* мы предусмотрели случаи только для 
                                   0, 1, 3, поэтому,                 */
        cmpl  $3, %eax          /* если %eax больше 3 
                                   (как беззнаковое),                */
        ja    case_default      /*     go to default                 */

        jmp   *jump_table(,%eax,4) /* перейти по адресу, содержащемуся 
                                   в памяти jump_table + %eax*4      */

.section .rodata
        .p2align 4
jump_table:                     /* addresses array                   */
        .long case_0            /* адрес этого элемента массива: 
                                                     jump_table + 0  */
        .long case_1            /*                   jump_table + 4  */
        .long case_default      /*                   jump_table + 8  */
        .long case_3            /*                   jump_table + 12 */
.text

case_0:
        movl  $5, %ecx          /* case-block                   */
        jmp   switch_end        /* imitate break — go to end 
                                   switch                            */

case_1:
        movl  $15, %ecx
        jmp   switch_end

case_3:
        movl  $35, %ecx
        jmp   switch_end

case_default:
        movl  $100, %ecx

switch_end:

        pushl %ecx              /* output %ecx to screen, exit      */
        pushl $printf_format
        call  printf

        movl  $0, %eax

        movl  %ebp, %esp
        popl  %ebp
        ret