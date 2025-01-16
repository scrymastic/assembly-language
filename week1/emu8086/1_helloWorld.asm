
.model small                            ; use small memory model

.data                                   ; data segment
    message db 'Hello, World!$'         ; string to be printed ('$' is string termination character)
    
.code                                   ; code segment
    main proc                           ; main procedure
        lea ax, data                    ; load data segment address to ax
        mov ds, ax                      ; ds stores value of ax

        lea dx, message                 ; load message address to dx

        mov ah, 9                       ; these two lines print string indicated by ds:dx register
        int 21h                         ;

        mov ah, 4ch                     ; these two lines end the program and return the control to the operating system
        int 21h                         ;

    main endp
end
  
  

  
  
