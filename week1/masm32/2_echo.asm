
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

    push offset string
    call StdOut

    call ExitProcess
end start
