.data
printf_format:
        .string "<%s>\n"

#define READ_CHUNK 128

.text

/* char *read_str(int *is_eof) */
read_str:
        pushl %ebp
        movl  %esp, %ebp

        pushl %ebx              /* сохранить регистры                */
        pushl %esi
        pushl %edi

        movl  $0,   %ebx        /* прочитано байт                    */
        movl  $READ_CHUNK, %edi /* размер буфера                     */
        pushl %edi
        call  malloc
        addl  $4, %esp          /* убрать аргументы                  */
        movl  %eax, %esi        /* указатель на начало буфера        */
        decl  %edi              /* в конце должен быть нулевой байт, 
                                   зарезервировать место для него    */

        pushl stdin             /* fgetc() всегда будет вызываться с 
                                   этим аргументом                   */

1: /* read_start */
        call  fgetc             /* прочитать 1 символ                */
        cmpl  $0xa, %eax        /* новая строка '\n'?                */
        je    2f                /* read_end                          */
        cmpl  $-1, %eax         /* конец файла?                      */
        je    4f                /* eof_yes                           */
        movb  %al, (%esi,%ebx,1)  /* записать прочитанный символ в 
                                   буфер                             */
        incl  %ebx              /* инкрементировать счётчик 
                                   прочитанных байт                  */
        cmpl  %edi, %ebx        /* буфер заполнен?                   */
        jne   1b                /* read_start                        */

        addl  $READ_CHUNK, %edi /* увеличить размер буфера           */
        pushl %edi              /* размер                            */
        pushl %esi              /* указатель на буфер                */
        call  realloc
        addl  $8, %esp          /* убрать аргументы                  */
        movl  %eax, %esi        /* результат в %eax — новый указатель 
                                                                     */
        jmp   1b                /* read_start                        */
2: /* read_end */

3: /* eof_no */
        movl  8(%ebp), %eax     /* *is_eof = 0                       */
        movl  $0, (%eax)
        jmp   5f                /* eof_end                           */
4: /* eof_yes */
        movl  8(%ebp), %eax     /* *is_eof = 1                       */
        movl  $1, (%eax)
5: /* eof_end */

        movb  $0, (%esi,%ebx,1) /* записать в конец буфера '\0'      */

        movl  %esi, %eax        /* результат в %eax                  */

        addl  $4, %esp          /* убрать аргумент fgetc()           */

        popl  %edi              /* восстановить регистры             */
        popl  %esi              
        popl  %ebx

        movl  %ebp, %esp
        popl  %ebp
        ret

/*
struct list_node
{
  struct list_node *prev;
  char *str;
};
*/

.globl main
main:
        pushl %ebp
        movl  %esp, %ebp

        subl  $4, %esp          /* int is_eof;                       */

        movl  $0, %edi          /* в %edi будет храниться указатель на 
                                   предыдущую структуру              */

1: /* read_start */
        leal  -4(%ebp), %eax    /* %eax = &is_eof;                   */
        pushl %eax
        call  read_str
        movl  %eax, %esi        /* указатель на прочитанную строку 
                                   поместить в %esi                  */

        pushl $8                /* выделить 8 байт под структуру     */
        call  malloc

        movl  %edi, (%eax)      /* указатель на предыдущую структуру */
        movl  %esi, 4(%eax)     /* указатель на строку               */

        movl  %eax, %edi        /* теперь эта структура — предыдущая */

        addl  $8, %esp          /* убрать аргументы                  */

        cmpl  $0, -4(%ebp)      /* is_eof == 0?                      */
        jne   2f
        jmp   1b
2: /* read_end */


3: /* print_start */
                                /* просматривать список в обратном 
                                   порядке, так что в %edi адрес 
                                   текущей структуры                 */
        pushl 4(%edi)           /* указатель на строку из текущей 
                                   структуры                         */
        pushl $printf_format
        call  printf            /* вывести на экран                  */

        addl  $4, %esp          /* убрать из стека только 
                                   $printf_format                    */
        call  free              /* освободить память, занимаемую 
                                   строкой                           */

        pushl %edi              /* указатель на структуру для 
                                   освобождения памяти               */
        movl  (%edi), %edi      /* заменить указатель в %edi на 
                                   следующий                         */
        call  free              /* освободить память, занимаемую 
                                   структурой                        */

        addl  $8, %esp          /* убрать аргументы                  */

        cmpl  $0, %edi          /* адрес новой структуры == NULL?    */
        je    4f
        jmp   3b
4: /* print_end */

        movl  $0, %eax          /* выйти с кодом 0                   */

return:
        movl  %ebp, %esp
        popl  %ebp
        ret