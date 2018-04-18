section .bss
x resd 1



section .data
a dw -10
b dw 20
c dw 5

section .text
global _start
_start:
main:   mov cx,[c]  ;значение с в регистр сх
		mov ax,[a]  ;значение с в регистр сх
		mov bx,[b]  ;значение с в регистр сх
        neg cx      ;-с в сх
        sal cx,1    ;-2c в cх
        add cx,[b]    ;b+(-2с) в сx
        mov dx,cx  ;значение cx в bx
        sal dx,2    ;4(b+(-2c)) в bx
        add dx,cx	;4(b+(-2c)) + (b+(-2c)) в bx
        neg dx		; -5(b+(-2c))
        add cx,2	; -5(b+(-2c)) + 2
        add cx, [a]	; -5(b+(-2c)) + 2 + a
        ; mov [x], cx

end:    mov ebx,0   ;exitcode 0
        mov eax,1   ;exit
        int 0x80
;X = A – 5( B – 2C ) + 2

; assemble and link with:
; nasm -f elf printf-test.asm && gcc -m32 -o printf-test printf-test.o

; section .text
; global main
; extern printf

; main:

;   mov eax, 0xDEADBEEF
;   push eax
;   push message
;   call printf
;   add esp, 8
;   ret

; message db "Register = %08X", 10, 0




; test   AL, 0FFh     ; четное число единиц ?
; jn     test   AL, 0FFh
; jp      test   AL, 0FFh
; jn 	 	test   AL, 0FFh      
; jn 	 	test   AL, 0FFh      
; jn add A,1
