.section .rodata /* Сегмент read-only data */
str_d:
        .asciz "%d\n"
array_start:
        .long 1,2,32,6,8,-100
.set count_el, (.-array_start)/4


.globl main
.type main, @function
.text /* cs -- code segment */

main:

        movl $0, %ecx /* запишем константу 0 в %ecx */
        movl array_start, %ebx /* Записать элемент (1) в %ebx */
        jmp is_last /* перепрыгнуть сразу на проверку is_last */



search:
        movl array_start(,%ecx,4), %eax /* Запишем array_start+%ecx*4 в %eax, заметьте мы не берем адрес($) */
        cmpl %eax, %ebx /* Проверим %ebx == %eax ? */
        jge above /* если %ebx >= %eax (если ebx уже больше eax то пропустит присваивание)   */ 
        movl %eax, %ebx /* переместить %eax в %ebx (значит оно уже наибольшее) */
above:
        inc %ecx /* Увеличить %ecx на 1*/

is_last:
        cmpl $count_el, %ecx /* %ecx == константе count_el? */
        jl search /* if( %ecx < $count_el) goto search; */
/* Если уже не меньше, продолжаем*/

pushl %ebx /* Поместить в стек число из %ebx */
pushl $str_d /* Поместить адрес строки в стек */
call printf /* printf(&str_d, edx); */
addl $2*4, %esp /* Переместить стек на 2 ячейки выше(для intel) */ 