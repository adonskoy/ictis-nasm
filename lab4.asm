section .bss 
char resb 1 
section .data 
global _start ;начало тела программы 

func: 
    cmp byte [char], 10 ;сравнение символа с символом перехода на новую строку 
    je _end 

    cmp byte [char], 32 ;сравнение символа с пробелом 
    je _swap 
    jne inc_len
    
    
inc_len:
    add esi,1
    jmp _write

_swap: ;переход на новую строку 
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
_read: ;чтение строки 
    mov eax,3 
    mov ebx,2 
    mov ecx,char 
    mov edx,1 
    int 80h 
    call func 

_write: ;вывод слова на новую строку 
    mov eax,4 
    mov ebx,1 
    mov ecx,char 
    mov edx,1 
    int 80h 
    jmp _read

_end: 
    ; вывод \n 
    mov byte [char], 10 
    mov eax,4 
    mov ebx,1 
    mov ecx,char 
    mov edx,1 
    int 80h 
   
   
    mov eax,1 ;конец программы 
    mov ebx,0 
    int 80h