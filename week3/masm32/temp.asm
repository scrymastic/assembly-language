.386
.model flat, stdcall
option casemap:none

include C:\masm32\include\masm32rt.inc

.data
    out1 db "first number: ", 0
    out2 db "second number: ", 0
    out3 db "third number: ", 0

.data?

    str1 db 2 dup (?)
    str2 db 12 dup (?)
    str3 db 12 dup (?)

.code
start:

    invoke StdOut, offset out1
    invoke StdIn, offset str1, 2

    invoke StdOut, offset out2
    invoke StdIn, offset str2, 11
    invoke StdIn, offset str2, 11

    invoke StdOut, offset out3
    invoke StdIn, offset str3, 11

    inkey
    invoke ExitProcess, 0
end start
