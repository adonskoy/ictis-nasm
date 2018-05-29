sys_exit        equ     1
sys_read        equ     3
sys_write       equ     4
stdin           equ     0
stdout          equ     1
stderr          equ     3

section .bss 
char resb 1 
section .data 
global _start               ;начало тела программы 

func: 
    cmp byte [char], 10     ;сравнение символа с символом перехода на новую строку 
    je _end 

    cmp byte [char], 32     ;сравнение символа с пробелом 
    je _swap 
    jne inc_len
    
    
inc_len:
    add esi,1
    jmp _write

_swap:                      ;переход на новую строку 
    cmp byte esi,0
    jne new_line
    je _read


new_line:
    mov esi,0
    mov byte [char], 10 
    jmp _write

section .text 

_start: 
    mov esi,0
_read:                      ; чтение символа
   
    mov ecx,char 
    mov edx,1 
    call ReadText
    call func 

_write:                     ; запись символа
    mov eax,4 
    mov ebx,1 
    mov ecx,char 
    mov edx,1 
    int 80h 
    jmp _read

DisplayText:
    mov     eax, sys_write
    mov     ebx, stdout
    int     80H 
    ret
    
ReadText:
    mov     eax, sys_read
    mov     ebx, stdin
    int     80H
    ret

_end: 
    mov byte [char], 10     ; вывод \n 
    mov eax,4 
    mov ebx,1 
    mov ecx,char 
    mov edx,1 
    int 80h 
   
    mov eax,1               ;конец программы 
    mov ebx,0 
    int 80h