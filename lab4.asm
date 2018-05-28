; sys_exit        equ     1
; sys_read        equ     3
; sys_write       equ     4
; stdin           equ     0
; stdout          equ     1
; stderr          equ     3

; ; SECTION     .data
; ; szName          db      " 123 456"
; ; Name_Len        equ     $-szName
; ; szHello         db      "Hello ", 0
; ; Hello_Len       equ     $-szHello

; ; SECTION     .bss
; ; lpBuffer        resb    7
; ; Buf_Len         equ     $-lpBuffer
    
; ; SECTION     .text
; ; global      _start
    
; ; _start:
; ;     ; Вывод строки
; ;     mov     ecx, szName
; ;     mov     edx, Name_Len
; ;     call    DisplayText

; ;     mov     ecx, lpBuffer
; ;     mov     edx, Buf_Len
; ;     call    ReadText
; ;     push    eax



; ;     mov AX, [szName]
; ;     mov DS, AX
; ;     mov ES, AX
; ;     mov CX, Name_Len ; размер строки
; ;     lea edi, [szName]     ; адрес первого символа строки
; ;     mov AL, ' ' ; разделитель слов
; ;     xor BX, BX  ; счетчик слов
    

; ;     repe scasb      ; пропускаем пробелы
; ;     je exit     ; кроме пробелов ничего нет – закончить
; ;     inc BX      ; нарастить счетчик
; ;     repne scasb ; ищем конец слова
; ;     jne exit        ; строка закончилась – закончить
; ;     jmp teest

; ; teest:
; ;     mov     ecx, szHello     
; ;     mov     edx, edi 
; ;     add     ecx, 1         
; ;     call    DisplayText    

; ;     pop     edx
; ;     mov     ecx, lpBuffer
; ;     call    DisplayText
; ;     jmp     exit
    
; ; DisplayText:
; ;     mov     eax, sys_write
; ;     mov     ebx, stdout
; ;     int     80H 
; ;     ret
    
; ; ReadText:
; ;     mov     ebx, stdin
; ;     mov     eax, sys_read
; ;     int     80H
; ;     ret

; ; exit:               ; BX – счетчик слов
; ;    mov ebx,0   ;exitcode 0
; ;     mov eax,1   ;exit
; ;     int 0x80




; ; ; exit:             ; BX – счетчик слов
; SECTION     .data
; s1  db  '   text   string  for  example  $'
; len dw  32
; SECTION     .text
; global      _start
    
; _start:
;     mov AX, [s1]
;     mov DS, AX
;     mov ES, AX
;     mov CX, [len] ; размер строки
;     lea DI, [s1]      ; адрес первого символа строки
;     mov AL, ' ' ; разделитель слов
;     xor BX, BX  ; счетчик слов
;     ; cld
;         mov     ecx, s1
;     mov     edx, len
;     call    DisplayText
; next:
;     repe scasb      ; пропускаем пробелы
;     je exit     ; кроме пробелов ничего нет – закончить
;     inc BX      ; нарастить счетчик
;     repne scasb ; ищем конец слова
;     jne exit        ; строка закончилась – закончить
;     jmp next

; DisplayText:
;     mov     eax, sys_write
;     mov     ebx, stdout
;     int     80H 
;     ret


; ; exit:               ; BX – счетчик слов
; exit:               ; BX – счетчик слов
;    mov ebx,0   ;exitcode 0
;     mov eax,1   ;exit
;     int 0x80
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