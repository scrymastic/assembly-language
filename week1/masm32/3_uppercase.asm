
.386 
.model flat, stdcall 
option casemap:none 

include \masm32\include\masm32rt.inc

.data

.data?
    string db 33 dup (?)
    

.code 
start:
    push 32 
    push offset string
    call StdIn

    mov ebx, 0

    upper_loop:
        cmp [string+ebx], 0
        je break

        cmp [string+ebx], 97
        jl continue

        cmp [string+ebx], 122
        jg continue

        sub [string+ebx], 32

    continue:
        inc ebx
        jmp upper_loop

    break:
        push offset string
        call StdOut
        

    call ExitProcess
end start
