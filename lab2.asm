section .data
	array dw -10,5,23,17,42,-20,13,96,-57,4

section .text

global _start

_start: mov ebx,array ; загружаем адрес массива 
		mov ecx,5	; устанавливаем счетчик
_loop:  mov ax,word [ebx]; текущий  элемент массива записываем в AX
		mov dx, word [ebx+2]; следующий за ним элемент записываем в DX
		mov [ebx],word dx
		mov [ebx+2],word ax; меняем элементы местами
		add ebx,4 ; смещаемся на два элемента 
		loop _loop ; возвращаемся, если  ECX!=0
_end:	mov eax,1; код системного выхода 
		mov ebx,0; код ошибки
		int 80h

 