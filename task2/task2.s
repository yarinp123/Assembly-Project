      ;based on some code snippets from the presentation
        section .data
format  db      "%s",0x0a,0
format2  db      "%d",0x0a,0
hexa_format db "%02hhx",0x0a,0
multi:
x_struct: dd 5
x_num: db 0xaa, 1,2,0x44,0x4f ; A byte is eight bits, a word is 2 bytes (16 bits), 
                              ; a doubleword is 4 bytes (32 bits), and a quadword is 8 (64 bits)




        section .text
        global  main            ; let the linker know about main
        extern  printf          ; resolve printf from libc
main:
        push ebp
        mov ebp,esp
        mov esi,x_struct
        push esi
        call print_multi
        add esp,4
        pop ebp
        ret

print_multi:

        push ebp
        mov ebp,esp
        
        mov ecx, 0 ; set index to 0
        mov edx, [x_struct]
do_rep:
        mov esi, [x_num+ecx]


        pushad ; pusha, make sure is in dwords
        push    dword esi     ; must dereference esi; points to argv
        push    hexa_format
        call printf
        add esp, 8
        popad

        inc ecx ; prepare for next
        dec edx ; are we done?
        jnz do_rep
        pop ebp
        ret