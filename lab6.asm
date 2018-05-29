sys_exit        equ     1
sys_read        equ     3
sys_write       equ     4
stdin           equ     0
stdout          equ     1
stderr          equ     3

SECTION     .data
pointer db 5

SECTION     .bss
lpBuffer1   resb    700
Buf_Len1    equ     $-lpBuffer1

lpBuffer2   resb    700
Buf_Len2    equ     $-lpBuffer2

lpBuffer3   resb    700
Buf_Len3    equ     $-lpBuffer3

SECTION     .text
global      _start

len:
    push    ebx
    mov     ecx,0
    dec     ebx
    
count:
    inc     ecx
    inc     ebx
    cmp     byte [ebx],0
    jnz     count
    
    dec     ecx
    pop     ebx
    ret

insertion:
    mov     edx, [pointer]      ; выводим первые pointer символов
    mov     ecx, lpBuffer1
    call    DisplayText
    
    mov     ebx, lpBuffer2
    call    len
    dec     ecx
    
    mov     edx, ecx            ; выводим вторую строку
    mov     ecx, lpBuffer2
    call    DisplayText
    
    mov     ebx, lpBuffer1
    call    len
    dec     ecx

    mov     edx, ecx            ; выводим остаток первой строки
    mov     ecx, lpBuffer1
    add     ecx, [pointer]
    call    DisplayText

    ret

atoi:
    xor     eax, eax 
.top:
    movzx   ecx, byte [edx]     ; получаем символ
    inc     edx 
    cmp     ecx, '0'
    jb      .done
    cmp     ecx, '9'
    ja      .done
    sub     ecx, '0'            ; конвертируем в число
    imul    eax, 10             ; домножаем на 10
    add     eax, ecx            ; добавляем в текущее число
    jmp     .top 
.done:
    ret

_start:
    mov     ecx, lpBuffer1      ; Считываем входные данные
    mov     edx, Buf_Len1
    call    ReadText
    
    mov     ecx, lpBuffer2
    mov     edx, Buf_Len2
    call    ReadText

    mov     ecx, lpBuffer3
    mov     edx, Buf_Len3
    call    ReadText
    mov     edx, lpBuffer3
    call    atoi
    mov     [pointer], eax

    call    insertion           ; делаем вставку 
    jmp     Exit
    
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

Exit:  
    mov     eax, sys_exit
    xor     ebx, ebx
    int     80H