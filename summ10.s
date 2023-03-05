/*
    #include <stdio.h>

    int main()
    {
    int eax, ecx;
    eax = 0;
    ecx = 10;
    do
    {
        eax += ecx;
    } while(--ecx);
    printf("%d\n", eax);
    return 0;
    }
*/

.data
printf_format:
        .string "%d\n"
 
.text
.global main
main:
        movl  $0, %eax          /* в %eax будет результат, поэтому в 
                                   начале его нужно обнулить         */
        movl  $10, %ecx         /* 10 шагов цикла                    */
 
sum:
        addl  %ecx, %eax        /* %eax = %eax + %ecx                */
        loop  sum
 
        /* %eax = 55, %ecx = 0 */
 
/*
 * следующий код выводит число в %eax на экран и завершает программу
 */
        pushl %eax
        pushl $printf_format
        call  printf
        addl  $8, %esp
 
        movl  $0, %eax
        ret