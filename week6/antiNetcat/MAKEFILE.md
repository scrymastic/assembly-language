nasm -f elf64 -o antiNetcat.o antiNetcat.asm

ld -o antiNetcat antiNetcat.o
