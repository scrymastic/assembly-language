
.model small                        ;use small memory model

.stack 100
.data
    str db 36 dup ('$')             ;create a string
    lfcr db 10, 13, '$'             ;line feed and carriage return

.code
    main proc
        lea ax, data                ;load data segment address to ax
        mov ds,ax                   ;ds stores value of ax

         
        lea dx, str                 ;dx stores the address of string

        mov ah, 10                  ;these two lines get a string from input and store them into address indicated by ds:dx register pair
        int 21h                     ;
        
        lea dx, lfcr                ;dx stores the address of lfcr
        
        mov ah, 9                   ;these two lines print string indicated by ds:dx register pair
        int 21h                     ;

        
        lea dx, str + 2             ;dx stores the address of first character in entered string. Ex: if you enter 'hello', the str will be: $, 5 (length of 'hello'), h, e, l, l , o, 0dh, $, $, ...
        
        mov ah, 9                   ;these two lines print string indicated by ds:dx register pair                   
        int 21h                     ;
        
        mov ah,4ch                  ;these two lines end the program and return the control to opreating system
        int 21h                     ;
    main endp
 end
        
    
    
