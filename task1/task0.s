global main
extern printf

segment .data 
format1  db      "Argument %d: %s",0x0a,0, 0x0a,0
format2  db     "number of Args: %d",0x0a,0

segment .text           
        global  main            ; let the linker know about main
        extern  printf          ; resolve printf from libc
main:
        push    ebp             ; prepare stack frame for main
        mov     ebp, esp
        sub     esp, 8
        mov     edi, dword[ebp+8]    ; get argc into edi
        mov     esi, dword[ebp+12]   ; get first argv string into esi

        push    edi
        push    format2
        call    printf

        mov     ebx, 0               ;counter

start_loop:
        xor     eax, eax
        
        push    dword [esi] 
        push    dword ebx
        push    format1
        call    printf

        add     ebx ,1    
        add     esi, 4     
        dec     edi             
        cmp     edi, 0          
        jnz     start_loop      
end_loop:
        xor     eax, eax
        leave
        ret
