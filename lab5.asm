model SMALL
stack 100h
dataseg
    Msg1 db 0Ah,0Dh,'Enter  number  (no more than 10 digits here):$'
    Msg2 db 0Ah,0Dh,'Enter delimer  (only one digit):$'
    WrInp1   db 0Ah,0Dh,'Wrong input. Max 10 digits. Try one more time$'
    WrInp2   db 0Ah,0Dh,'Wrong input. Only 1 digit and not a zero. Try one more time$'
    ResultFloorString     db 0Ah,0Dh,'Floor part is:           $'
    ResultCeilString      db 0Ah,0Dh,'Ceil part is:  $'
    buffer1    db 11
    lenght1    db ?
    Operand1   db 10 dup(?)
    buffer2    db 2
    lenght2    db ?
    Operand2   db ?
codeseg
startupcode

Input1:
    lea     DX,Msg1 ; вывод Msg1
    mov     AH,09h
    int     21h
    
    lea     DX,buffer1 ; ввод первого числа
    mov     AH,0Ah
    int     21h
    cmp     lenght1,0      ;  ввести еще раз,если  строка пустая
    je      PrintError1

    lea     BX,Operand1
    xor     CX,CX
    mov     CL,lenght1
    xor     SI,SI
    jmp Check1

PrintError1:
    lea     DX,WrInp1
    mov     AH,09h
    int     21h
    jmp Input1

PrintError2:
    lea     DX,WrInp2
    mov     AH,09h
    int     21h
    jmp Input2


Check1:             ; проверяем, все ли символы являются цифрами в введенной строке
    mov     AL,[BX][SI]
    cmp     AL,'0'
    jb      PrintError1           ; не цифра
    cmp     AL,'9'
    ja      PrintError1
    and     AL,0Fh          ; обнуление
    mov     [BX][SI],AL     ; записываем обновленное значение
    inc     SI
    loop    Check1

Input2:
    lea     DX,Msg2         ; вывод Msg2
    mov     AH,09h
    int     21h
    lea     DX,buffer2         ; ввод второго числа
    mov     AH,0Ah
    int     21h
    cmp     lenght2,1      ; если в строке больше одного символа, то ввести заново
    jne     PrintError2
    
    lea     BX,Operand2            ; проверка, является ли символ является цифрой
    xor     SI,SI
    mov     AL,byte ptr [BX][SI]
    cmp     AL,'1' ; Нельзя делить на 0
    jb      PrintError2
    cmp     AL,'9'
    ja      PrintError2
    and     AL,0Fh          ; обнуляем лишнее
    mov     [BX][SI],AL     ; записываем обновленное значение

DivisionPrepare:
    xor     AX,AX
    lea     BX,Operand1
    xor     SI,SI
    mov     DI,17            ; позиция начала записи частного
    mov     CL,lenght1
    mov     AL,Operand1        ; проверка на случай, когда нужно взять 2 цифры первого числа

    mov     AH,Operand2
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
    div     Operand2           ; делим
    or      AL,30h           ; результат превращаем в символ
    lea     BX,ResultFloorString
    mov     byte ptr [BX][DI],AL    ; копируем цифру частного
    lea     BX,Operand1            ; возвращаемся к числу
    inc     SI              ; следующая цифра исходного числа
    inc     DI              ; следующая позиция для вставки цифры частного
    loop    Division

OutputPrepare:         ;  AH остаток,  копируем его в строку для остатка
    lea     BX,ResultCeilString       
    mov     SI,16           ; позиция для записи остатка
    or      AH,30h           ; превращаем в символ
    mov     byte ptr [BX][SI],AH    ; строка с остатком готова
Output:
    lea     DX,ResultFloorString      ; выводим строку с частным
    mov     AH,09h
    int     21h
    lea     DX,ResultCeilString       ; выводим строку с остатком
    mov     AH,09h
    int     21h

Quit: 
    end
