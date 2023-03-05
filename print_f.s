.data
printf_format:
        .string "%d\n"
 
.text
        /* printf(printf_format, %eax); */
        pushl %eax              /* argument to print       */
        pushl $printf_format    /* format argument         */
        call  printf            /* call printf()           */
        addl  $8, %esp          /* align stack             */