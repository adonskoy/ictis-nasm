.model small
.486
.stack 100h
.data
        askA    db    0Ah, 0Dh, 'Enter a: $'
        askB    db    0Ah, 0Dh, 'Enter b: $'
        askE    db    0Ah, 0Dh, 'Enter e: $'

        exitStr         db    0Ah, 0Dh, 'Press Escape to terminate program, any other key to continue$'
        resStr          db    0Ah, 0Dh, 'Result is: $'
        errStr          db    0Ah, 0Dh, 'Cannot calculate the solution! $'

        value2          dd    2 ; константа для вычислений
        k1              dd   -16.0              ; значение коэффициента при х^1

        y0              dd    ?         ; значение функции в х0
        y1              dd    ?         ; значение функции в х1
        y2              dd    ?         ; значение функции в х2
        x0              dd    ?         ; аргумент функции для вычисления
        x1              dd    ?         ; левая граница отрезка
        x2              dd    ?         ; правая граница отрезка

        aValue          dd    ? ; первое число
        bValue          dd    ? ; второе число
        eValue          dd    ? ; третье число


        aStrBuf         db    40                ; строка для первого числа
        aStrLen         db    ?
        aStr            db    40 dup(?)

        bStrBuf         db    40        ; строка для второго числа
        bStrLen         db    ?
        bStr            db    40 dup(?)

        eStrBuf         db    40        ; строка для третьего числа
        eStrLen         db    ?
        eStr            db    40 dup(?)

        answer          dd    ? ; результат
        answerStr       db    40 dup(?) ; строка для результата
        cwTmp   dw    ?                 ; временная переменная для изменения CW
        tmp             dq    ?         ; переменная для ввода данных

.code
        startupcode
        mov     AX, 03
        int     10h                         ; очистка экрана
        finit                                   ; инициализация сопроцессора
        xor     AX,AX                           ; обнуляем АХ
        fstcw   cwTmp                           ; получаем значение CW
        mov     AX, cwTmp
        and     AX, 1111110011111111b   ; изменяем 8 и 9 бит, отвечающие за точность
        mov     cwTmp,AX                        ; комбинация 00 - для короткого типа точности мантиссы
                                                
        fldcw   cwTmp                           ; загружаем новое значение CW
BEGIN:

AINPUT:
        lea     DX, askA                        ; запрашиваем ввод числа а
        mov     AH, 09h
        int     21h

        lea     DX, aStrBuf                     ; вводим число а
        mov     AH, 0Ah
        int     21h

        push    offset tmp                      ; конвертируем строку в число
        push    offset aStr
        call    StrToDouble
        add     SP,2
        fld tmp                         ; помещаем сконвертированное число в стек и выталкиваем в а
        fstp aValue                             

BINPUT:
        lea     DX, askB                        ; запрашиваем ввод числа b
        mov     AH, 09h
        int     21h

        lea     DX, bStrBuf                     ; вводим число b
        mov     AH, 0Ah
        int     21h

        push    offset tmp                      ; конвертируем строку в число
        push    offset bStr
        call    StrToDouble
        add     SP,2
        fld     tmp                             ; помещаем сконвертированное число в стек и выталкиваем в b
        fstp    bValue                   

EINPUT:
        lea     DX, askE                        ; запрашиваем ввод числа e
        mov     AH, 09h
        int     21h

        lea     DX, eStrBuf                     ; вводим e
        mov     AH, 0Ah
        int     21h

        push    offset tmp                      ; конвертируем строку в число
        push    offset eStr
        call    StrToDouble
        add     SP,2
        fld     tmp                             ; помещаем сконвертированное число в стек и выталкиваем в е
        fstp    eValue                  

CALC:   
        fld     aValue                  ; aValue помещается в R0
        fstp    x1                              ; инициализируем x1 числом а

        fld     bValue                  ; bValue – в R0
        fstp    x2                              ; инициализируем x2 числом b
        call    CalcSolution            ; вычисляем

        cmp     AX, 0FFFFh                      ; проверяем, не произошло ли ошибки
        jne     OUTPUT

BADOUTPUT:
        lea     DX, errStr                      ; сообщаем об ошибке
        mov     AH, 09h
        int     21h
        jmp     INPUTRETRY                      ; переход к повторению ввода

OUTPUT:
        fld     answer                  ; в стек – значение результата
        fstp    tmp                             ; выталкиваем в переменную для конвертации
                                                
        push    offset answerStr
        push    offset tmp
        call    DoubleToStr             ; конвертируем значение результата в строку
        add     SP,2

        lea     DX, resStr                      ; сообщение о выводе результата
        mov     AH, 09h
        int     21h

        lea     DX, answerStr
        mov     AH, 09h
        int     21h                             ; вывод результата

INPUTRETRY:
        lea     DX, exitStr
        mov     AH, 09h
        int     21h                     ; предлагаем продолжить или завершить программу

        mov     AH,08h
        int     21h
        cmp     AL,27                   ; сравниваем с кодом клавиши Escape
        jnz     BEGIN                   ; если не Escape – переходим в начало

        end

CalcSolution proc  near
                                        ; f(x) = x^3–16x
                                        ; вычисляем y1 и y2
_start:
        fld     x1
        fstp    x0
        call    CalcFuncValue   ; вычисляем функцию для x1
        fld     y0                      ; загружаем результат в стек
        fstp    y1                      ; сохраняем y1 = f(x1)

        fld     x2
        fstp    x0
        call    CalcFuncValue   ; вычисляем функцию для x2
        fld     y0
        fstp    y2                      ; аналогично y2 = f(x2)
                                        ; сравниваем y1*y2 c 0
        fld     y1
        fld     y2
        fmul                            ; y1 * y2
        fldz
        fcompp                  ; сравниваем 0 и y1 * y2
        fstsw   AX
        sahf                            ; копируем флаги из сопроцессора
        jb      _badanswer              ; произведение больше 0 - знаки одинаковы, корней нет


                                        ; вычисляем x0 = (x1 + x2) / 2,
        fld    x1
        fld    x2
        fadd                            ; вычислили x1 + x2
        fild    value2          ; загрузили 2
        fdiv                            ; вычислили (x1 + x2) / 2
        fstp    x0              ; сохранили значение х0
        call    CalcFuncValue   ; вычисляем y0 = f(x0)

                                        ; если y0 * y1 < 0, то x2 = x0, иначе x1 = x0
        fld y0
        fld y1
        fmul
        fldz                            ; загрузили 0 и y0 * y1
        fcompp
        fstsw   ax
        sahf
        jb _setx1x0                                     

_setx2x0:                               ; x2 присвоить x0, если 0 > y0 * y1
        fld     x0
        fstp    x2
        jmp     _nextIteration

_setx1x0:                               ; х1 присвоить х0, если 0 < y0 * y1
        fld     x0
        fstp    x1

_nextIteration:
                                        ; если x2 - x1 > e, то повторяем вычисления;
        fld     x2
        fld     x1
        fsub                            ; х2 - х1

        fld     eValue
        fcompp                  ; сравниваем е и х2 - х1
        fstsw   ax
        sahf
        jbe     _start

_solution:
                                        ; находим answer = (x1 + x2) / 2.
        fld    x1
        fld    x2
        fadd                            ; х1 + х2
        fild    value2          ; 2
        fdiv                            ; (х1 + х2) / 2
        fstp    answer

        jmp     _end

_badanswer:
        mov     AX, 0FFFFh      ; произошла ошибка - записываем в АХ специальное значение
_end:
        ret
CalcSolution  endp

                                ; вычисляем значение целевой функции
CalcFuncValue proc near
                                ; аргумент - в x0
                                ; результат - в y0
        fld     x0
        fld     x0
        fmul
        fld     x0
        fmul
        fstp    y0              ; сохранили x^3

        fld     x0
        fld     k1
        fmul                    ; -16*x
        fld     y0                              
        fadd                    ; x^3 - 16x
        fstp    y0
        ret
CalcFuncValue endp

                                ; переводит дробное число в строку
DoubleToStr proc  near
        push   bp
        mov    bp, sp
        sub    sp, 4    ; выделяем 4 байта в стеке
        push   ax bx dx cx di
        pushf

    fnstcw [bp-4]          ; сохраним значение регистра управления

    fnstcw [bp-2]
    and    word ptr [bp - 2], 1111001111111111b; биты 11–10 управление округлением, 11 – к нулю  
    or     word ptr [bp - 2], 0000110000000000b

    fldcw  [bp - 2]        ; Запись нового значения регистра управления

    mov    bx, [bp + 4]

    fld    qword ptr[bx]   ; загружаем в стек сопроцессора число

        ftst
    fstsw  ax
    and    ah, 1
    cmp    ah, 1
    jne    @@NBE
    mov    bx, [bp + 6]
    mov    byte ptr[bx], '-'
    inc    word ptr[bp + 6]

@@NBE: 
        fabs
    fst    st(1)
    fst    st(2)
    frndint
    fsub   st(2), st(0)
    mov    word ptr[bp - 2], 10
        fild   word ptr[bp - 2]   

    fxch   st(1)
    xor    cx, cx

@@BG:
   fprem
    fist   word ptr [bp - 2]
    push   word ptr [bp - 2]

    fxch   st(2)
    fdiv   st(0), st(1)
    frndint
    fst    st(2)

    inc    cx

    ftst                                        ; сравнить st(0) c 0
    fstsw  ax                   ; SR -> AX
    sahf                                        ; AH в флаги    
    jnz    @@BG         ; если 14 бит SR == 0 (6 бит AH) (если zf == 0 прыжок)

    mov    ax, cx
    mov    bx, [bp + 6]

@@BFG: 
        pop    dx
    add    dx, '0'
    mov    byte ptr[bx], dl
    inc    bx
    loop   @@BFG
    fxch   st(3)
    fst    st(2)

    ftst
    fstsw  ax
    sahf
    jz     @@CNE

    mov    byte ptr[bx], '.'

    mov    cx, 16

@@BFR: 
        fmul   st(0), st(1)
    fst    st(2)
    frndint
    fsub   st(2), st(0)
    fist   word ptr [bp - 2]
    fxch   st(2)
    mov    ax, [bp - 2]
    add    ax, '0'
    inc    bx
    mov    byte ptr[bx], al

    loop   @@BFR        

@@NIL: 
        cmp    byte ptr[bx], '0'
    jne    @@CNR
    dec    bx
    jmp    @@NIL

@@CNR: 
        inc    bx
@@CNE:  
        mov    byte ptr[bx], '$'

    fstp   st(0)
    fstp   st(0)
    fstp   st(0)
        fstp   st(0)

    fldcw  [bp - 4]                      ; восстановим настройки сопроцессора

        popf
    pop    di cx dx bx ax
    add    sp, 4
    pop    bp
    ret
DoubleToStr  endp

                                                ; переводит строку в дробное число
StrToDouble proc  near
    push   bp
    mov    bp, sp
        sub    sp, 2                 ; выделяем 2 байта в стеке
        push   ax bx dx cx di
        pushf
    mov    word ptr[bp - 2], 10    ; помещаем в выделенные 2 байта 10
    fild   word ptr[bp - 2]        ; заталкиваем в стек сопроцессора 10
    fldz                           ; заталкиваем в стек сопроцессора 0
    mov    di, 0 
    mov    bx, [bp + 4]            ; помещаем в bx адрес из стека
        cmp    byte ptr[bx], '-'
    jne    @@BPN
    inc    bx
    mov    di, 1
@@BPN:  
        movsx  ax, byte ptr [bx]
    cmp    ax, '.'
    je     @@PNT1
    cmp    ax, 0dh
    jne    @@CNT
    fxch   st(1)
    fstp   st(0)
    jmp    @@REN
@@CNT:  
        sub    ax, '0'
        mov    word ptr[bp - 2], ax
    fmul   st(0), st(1)             ; умножаем число на вершине стека на 10
    fiadd  word ptr[bp - 2]     ; добавляем к числу на вершине стека то что было в ax
        inc    bx
    jmp    @@BPN 

@@PNT1: 
    xor    cx, cx
@@BEG:  
        inc    bx
    movsx  ax, byte ptr [bx]
    cmp    ax, 0dh
    je     @@END
    loop   @@BEG
@@END:  
        dec    bx   
    fxch   st(1)
    fldz
@@APN: 
        movsx  ax, [bx]     
    cmp    ax, '.'
    je     @@PNT2
    sub    ax, '0'
    mov    word ptr[bp - 2], ax
    fiadd  word ptr[bp - 2]
    fdiv   st(0), st(1)
    dec    bx
    jmp    @@APN
@@PNT2:
    fxch   st(1)                      ; меняем число 10 и остаток местами
    fstp   st(0)                      ; выталкиваем 10
    faddp  st(1)                        ; складываем целую и дробную части
@@REN:  
    cmp    di, 1
    jne    @@CYK
    fchs
@@CYK:  
        mov    bx, [bp + 6]           ; помещаем в bx адрес из стека
    fstp   qword ptr [bx]           ; помещаем по адресу из стека число
        popf
    pop    di cx dx bx ax
    add    sp, 2
    pop    bp
    ret
StrToDouble  endp
End
