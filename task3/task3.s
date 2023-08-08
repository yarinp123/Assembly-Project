      ;based on some code snippets from the presentation
section .data
        format  db      "%s",0x0a,0
        format2  db      "%d",0x0a,0
        hexa_format db "%02hhx",0x0a,0
        

        x_struct: dd 6
        x_val: db 1,0xf0,1,2,0x44,0x4f ; A byte is eight bits, a word is 2 bytes (16 bits), 
                                        ; a doubleword is 4 bytes (32 bits), and a quadword is 8 (64 bits)

        y_struct: dd 5
        y_val: db 1,1,2,0x44,1 ; A byte is eight bits, a word is 2 bytes (16 bits), 
                                ; a doubleword is 4 bytes (32 bits), and a quadword is 8 (64 bits)

section .bss
        addition_array: resd 1
        min_val: resd 1
        diff: resd 1
 
section .text
        global  main            ; let the linker know about main
        extern  printf          ; resolve printf from libc
        extern malloc

main:
        push ebp
        mov ebp,esp

        push dword y_struct
        push dword x_struct
        call multi_add
        add esp,8

        mov esi,addition_array
        push esi
        call print_multi
        add esp,4

        pop ebp
        ret

print_multi:
        push ebp
        mov ebp,esp
        mov ecx, 0 ; set index to 0
        mov edx, 6

loop:
        mov esi, [addition_array+ecx]

        pushad ; pusha, make sure is in dwords
        push    dword esi     ; must dereference esi; points to argv
        push    hexa_format
        call printf
        add esp, 8
        popad

        inc ecx ; prepare for next
        dec edx ; are we done?
        jnz loop
        pop ebp
        ret

get_max_min:

        mov edx, [eax]
        sub edx,[ebx]
        jl first_bigger
        ret

first_bigger:
        mov ecx, eax
        mov eax, ebx
        mov ebx, ecx
        ret


multi_add: 
        pushad ; pusha, make sure is in dwords
        push ebp
        mov ebp,esp

        mov eax, x_struct ;todo arg
        mov ebx, y_struct ;todo arg
        push ebx
        push eax
        call get_max_min
        add esp,8

        pushad
        push dword[eax]
        call malloc
        add esp,4
        mov dword[addition_array], eax
        popad

        mov ecx, 0 ; set index to 0
        mov edx, [ebx]  ; length of min_val

        mov ebx, [eax]  ; length of max_val
        mov eax, ebx    ; eax=length of max_val
        sub eax, edx    ; eax=length of max_val- length of min_val= diff
        mov ebx, eax    ;ebx=diff
        
        and al, al ; clear CF

do_rep: 
        
        mov eax, [y_val+ecx] 
        adc eax, [x_val+ecx]
        mov [addition_array+ecx], eax

        inc ecx ; prepare for next
        dec edx ; are we done?
        jnz do_rep
        
second_loop:

        mov eax, 0
        adc eax, [x_val+ecx]
        mov [addition_array+ecx], eax

        inc ecx ; prepare for next
        dec ebx ; are we done?
        jnz second_loop

        pop ebp
        popad
        ret