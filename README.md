# assmeble

Put number of system call 'write = 4' into %eax registry:

```asm
movl    $4, %eax
```

Source is value of 4, destination — %eax registry. The 'l' suffix in the command tells that it should work with operands with 4 bytes length.

Suffixes:

- b (byte) — 1 byte,
- w (word) — 2 bytes,
- l (long) — 4 bytes,
- q (quad) — 8 bytes.

Write $42 into %al registry (it has 1 byte size):

```
movb    $42, %al
```

Math

inc operand
dec operand

add source, accepter
sub source, accepter

mul множитель_1
