section .bss
x resd 1

section .data
a db 11011111b
c dw 0

section .text
global _start
ISTRUE:
	add cx, 1

	jmp short end

ISX7_1:
		test ax,10000000b
		je NOTX7_2
		jne NOTX6_1
NOTX6_1:	
		test ax,01000000b
		je ISX3_1
		jne NOTX7_2

ISX3_1:
		test ax,00001000b
		je NOTX7_2
		jne ISX1_1
ISX1_1:
		test ax,00000010b
		je NOTX7_2
		jne ISTRUE

NOTX7_2:
		test ax, 10000000b
		je ISX6_2
		jne ISX6_3
ISX6_2:
		test ax, 01000000b
		je ISX6_3
		jne ISX3_2
ISX3_2:
		test ax, 00001000b
		je ISX6_3
		jne ISX1_2
ISX1_2:
		test ax, 00000010b
		je ISX6_3
		jne ISTRUE

ISX6_3:
		test ax, 01000000b
		je end
		jne ISX4_3
ISX4_3:
		test ax, 00010000b
		je end
		jne ISX2_3
ISX2_3:
		test ax, 00000100b
		je end
		jne ISX1_3
ISX1_3:
		test ax, 00000010b
		je end
		jne NOTX0_3
NOTX0_3:
		test ax, 00000001b
		je ISTRUE
		jne end

_start:
main:   mov ax,[a]  ;значение a в регистр aх
		mov cx, [c]
		jmp short ISX7_1
		
end:    mov ebx,0   ;exitcode 0
        mov eax,1   ;exit
        int 0x80


;(x7&~x6&x3&x1) V (x6&x4&x2&x1&~x0) V (~x7&x6&x3&x1) .
