section .bss 
char resb 1 
section .data 
global _start ;начало тела программы 

func: 
    cmp byte [char], 10 ;сравнение символа с символом перехода на новую строку 
    je _end 
    cmp byte [char], 32 ;сравнение символа с пробелом 
    je _swap 
    jmp _write 

_swap: ;переход на новую строку 
    mov byte [char], 10 
    ret ;возврат из подпрограммы 
    section .text 

_start: 
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
    call _swap
    mov eax,4 
    mov ebx,1 
    mov ecx,char 
    mov edx,1 
    int 80h 
    ;конец программы 
    mov eax,1 
    mov ebx,0 
    int 80h