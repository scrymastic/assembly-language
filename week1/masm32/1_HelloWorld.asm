.386 
.model flat, stdcall 
option casemap:none 


include \masm32\include\masm32rt.inc

.data
    msg db "Hello, World!", 0

.code 
start: 
    push offset msg
    call StdOut

    call ExitProcess
end start
