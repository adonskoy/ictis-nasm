section .bss
x resd 1

section .data
a dw -10
b dw 20
c dw 5

section .text
global _start
_start: 
main:   mov ax,[a]  ;значение а в регистр ах
        neg ax      ;-а в ах
        sar ax,1    ;-а/2 в ах

        mov bx,[b]  ;значение b в bx
        add bx,1    ;b+1 в bx
        sal bx,2    ;4(b+1) в bx

        mov cx,[c]  ;значение c в сх
        neg cx      ;-c в cx
        mov dx,cx   ;-с в dx
        sal cx,1    ;-2c в cx
        add cx,dx   ;-3c в cx

        add ax,bx   ;-a/2 + 4(b+1) в ax
        add ax,cx   ;-a/2 + 4(b+1) - 3c в  ax

        mov [x],ax  ;-a/2 + 4(b+1) - 3c в  x

end:    mov ebx,0   ;exitcode 0
        mov eax,1   ;exit
        int 0x80