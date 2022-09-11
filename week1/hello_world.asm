
.model small                            ;use small memory model

.data                                   ;data segment
    message db 'Hello, World!$'         ;string: message ('$' is string termination character)
    
.code                                   ;code segment
main proc                               ;main procedure
    lea ax, data                        ;load data segment address to ax
    mov ds, ax                          ;ds store value of ax
  
    lea dx, message                     ;load message address to dx

    mov ah, 9                           ;these two lines print string indicated by
    int 21h                             ;ds:dx register

    mov ah, 4ch                         ;these two lines end the program
    int 21h                             ;and return the control to the operating system
    
main endp
end
  
  

  
  
