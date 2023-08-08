
section .data
        mask EQU 0x002D
        format2  db      "%d",0x0a,0
        state: dw 0x1234
 
section .text
        global  main            ; let the linker know about main
        extern  printf          ; resolve printf from libc

main:
        push ebp
        mov ebp,esp
        push mask
        call rand_num
        add esp,4
        pop ebp
        ret



rand_num:

        mov edx, 20             ;loop_ counter
start_loop:
        mov eax, mask
        xor eax, [state] ; count number of 1's
        jpe case_odd              ; 
        stc

case_odd:
        rcr word[state], 1

        mov ebx, [state]

        pushad
        pushfd
        push ebx
        push format2
        call printf
        add esp, 8
        popfd
        popad

        dec edx
        cmp edx,0
        jge start_loop 

        ret