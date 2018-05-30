model SMALL
stack 100h
dataseg
    Ask1 db 0Ah,0Dh,'Enter  number  (no more than 10 digits here):$'
    Ask2 db 0Ah,0Dh,'Enter delimer  (only one digit):$'
    WrInp1   db 0Ah,0Dh,'Wrong input. Max 10 digits. Try one more time$'
    WrInp2   db 0Ah,0Dh,'Wrong input. Only 1 digit and not a zero. Try one more time$'
    ResFloorStr     db 0Ah,0Dh,'Floor part is:           $'
    ResCeilStr      db 0Ah,0Dh,'Ceil part is:  $'
    Buf1    db 11
    Len1    db ?
    Opnd1   db 10 dup(?)
    Buf2    db 2
    Len2    db ?
    Opnd2   db ?
codeseg
startupcode

Input1:
    lea     DX,Ask1 ; вывод Ask1
    mov     AH,09h
    int     21h
    
    lea     DX,Buf1 ; ввод первого числа
    mov     AH,0Ah
    int     21h
    cmp     Len1,0      ;  ввести еще раз,если  строка пустая
    je      PrintErr1

    lea     BX,Opnd1
    xor     CX,CX
    mov     CL,Len1
    xor     SI,SI
    jmp Check1

PrintErr1:
    lea     DX,WrInp1
    mov     AH,09h
    int     21h
    jmp Input1

PrintErr2:
    lea     DX,WrInp2
    mov     AH,09h
    int     21h
    jmp Input2


Check1:             ; проверяем, все ли символы являются цифрами в введенной строке
    mov     AL,[BX][SI]
    cmp     AL,'0'
    jb      PrintErr1           ; не цифра
    cmp     AL,'9'
    ja      PrintErr1
    and     AL,0Fh          ; обнуление
    mov     [BX][SI],AL     ; записываем обновленное значение
    inc     SI
    loop    Check1

Input2:
    lea     DX,Ask2         ; вывод Ask2
    mov     AH,09h
    int     21h
    lea     DX,Buf2         ; ввод второго числа
    mov     AH,0Ah
    int     21h
    cmp     Len2,1      ; если в строке больше одного символа, то ввести заново
    jne     PrintErr2
    
    lea     BX,Opnd2            ; проверка, является ли символ является цифрой
    xor     SI,SI
    mov     AL,byte ptr [BX][SI]
    cmp     AL,'1' ; can't divide by zero
    jb      PrintErr2
    cmp     AL,'9'
    ja      PrintErr2
    and     AL,0Fh          ; обнуляем лишнее
    mov     [BX][SI],AL     ; записываем обновленное значение

DivisionPrep:
    xor     AX,AX
    lea     BX,Opnd1
    xor     SI,SI
    mov     DI,17            ; позиция начала записи частного
    mov     CL,Len1
    mov     AL,Opnd1        ; проверка на случай, когда нужно взять 2 цифры первого числа

    mov     AH,Opnd2
    cmp     AL,AH
    jge     DivisionStart       ; если первая цифра больше либо равна делителю начинаем деление

    cmp     CL,1
    je      DivisionStart        ; если первая цифра меньше делителя, но она единственная, то начинаем деление

    mov     AH,AL           ; копируем старший разряд числа для деления
    inc     SI              ; при обработке мы должны взять следующую цифру
    dec     CX              ; количество обрабатываемых цифр уменьшаем
    jmp     Division
DivisionStart:
    xor     AX,AX           ; обнуляем АХ
    
Division:
    mov     AL,byte ptr [BX][SI]    ; в AL помещаем текущую цифру числа
    aad                             ; выполняем коррекцию
    div     Opnd2           ; делим
    or      AL,30h           ; результат превращаем в символ
    lea     BX,ResFloorStr
    mov     byte ptr [BX][DI],AL    ; копируем цифру частного
    lea     BX,Opnd1            ; возвращаемся к числу
    inc     SI              ; следующая цифра исходного числа
    inc     DI              ; следующая позиция для вставки цифры частного
    loop    Division

OutputPrep:         ;  AH остаток,  копируем его в строку для остатка
    lea     BX,ResCeilStr       
    mov     SI,16           ; позиция для записи остатка
    or      AH,30h           ; превращаем в символ
    mov     byte ptr [BX][SI],AH    ; строка с остатком готова
Output:
    lea     DX,ResFloorStr      ; выводим строку с частным
    mov     AH,09h
    int     21h
    lea     DX,ResCeilStr       ; выводим строку с остатком
    mov     AH,09h
    int     21h

Quit: 
    end
