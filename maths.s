.text
        movl  $72, %eax
        incl  %eax              /* в %eax число 73                   */
        decl  %eax              /* в %eax число 72                   */
 
        movl  $48, %eax
        addl  $16, %eax         /* в %eax число 64                   */
 
        movb  $5, %al
        movb  $5, %bl
        mulb  %bl               /* в регистре %ax произведение 
                                   %al × %bl = 25                    */