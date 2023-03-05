.data                         /* put the following in data segment */
 
hello_str:                    /* our string                        */
        .string "Hello, world!\n"
 
                              /* string length                       */
        .set hello_str_length, . - hello_str - 1
 
.text                         /* поместить следующее в сегмент кода */
 
.globl  main                  /* main - глобальный символ, видимый
                                 за пределами текущего файла        */
.type   main, @function       /* main - function (not data)       */
 
 
main:
        movl    $4, %eax      /* поместить номер системного вызова write = 4 в регистр %eax           */
        movl    $1, %ebx      /* first parameter - to %ebx reg;
                                 number of file descriptor
                                 stdout = 1                         */
 
        movl    $hello_str, %ecx  /* второй параметр - в регистр %ecx;
                                     указатель на строку            */
 
        movl    $hello_str_length, %edx /* третий параметр - в регистр
                                           %edx; длина строки       */
 
        int     $0x80         /* вызвать прерывание 0x80            */
 
        movl    $1, %eax      /* номер системного вызова exit = 1   */
        movl    $0, %ebx      /* передать 0 как значение параметра  */
        int     $0x80         /* вызвать exit(0)                    */
 
        .size   main, . - main    /* размер функции main            */