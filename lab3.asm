section .bss
x resd 1

section .data
a db 11011111b
c dw 0

section .text
global _start

ISTRUE:		add cx, 1
			jmp short end

ISX1:		test ax, 00000010b
			je end
			jne ISX3

ISX3:		test ax, 00001000b
			je ISX6_2
			jne ISX7_1

ISX7_1:		test ax,10000000b
			je NOTX7_1
			jne NOTX6_1

NOTX6_1:	test ax, 01000000b
			je ISTRUE
			jne NOTX7_1

NOTX7_1:	test ax,10000000b
			je ISX6_1
			jne ISX6_2

ISX6_1:		test ax, 01000000b
			je ISX6_2
			jne ISTRUE

ISX6_2:		test ax, 01000000b
			je end
			jne ISX4_2

ISX4_2:		test ax, 00010000b
			je end
			jne ISX2_2

ISX2_2:		test ax, 00000100b
			je end
			jne NOTX0_2

NOTX0_2:	test ax, 00000001b
			je ISTRUE
			jne end

_start:
main:   	mov ax,[a]  
			mov cx, [c]
			jmp short ISX7_1
		
end:	    mov ebx,0   ;exitcode 0
        	mov eax,1   ;exit
        	int 0x80


;(x7&~x6&x3&x1) V (x6&x4&x2&x1&~x0) V (~x7&x6&x3&x1) .
