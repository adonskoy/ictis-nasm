.model small             ; ��।����� ⨯ ������ �����
.386                     ; ࠧ���� �ᯮ�짮����� ������権 386 ������

stack       100h         ; ��।����� ᥣ���� �⥪� ࠧ��஬ 256 ����

dataseg                  ; ��।����� ᥣ���� ������
var_b       db ?         ; ����� ��६����� (�祩�� �����) ࠧ��஬ ���� (1 ����)
var_w       dw ?         ; ����� ��६����� (�祩�� �����) ࠧ��஬ ᫮�� (2 ����)
var_dw      dd ?         ; ����� ��६����� (�祩�� �����) ࠧ��஬ ������� ᫮�� (4 ����)

codeseg                  ; ��।����� ᥣ���� ����
  start:                 ; ��砫� �믮������ �ணࠬ�� (�.��᫥���� ��ப�)
       
    startupcode          ; ��⠭����� � DS ���� ��砫� ᥣ���� ������ (���� �� ��������)

	mov AX, qqvar_w

    ;<<<>>>                
    ;<<<>>>                ����� ࠧ������� ������樨 �ணࠬ��
    ;<<<>>>                

  quit:                  ; ��⪠ ����� ࠡ���
    exitcode 0           ; ��।��� �ࠢ����� ����樮���� ��⥬�. ��� ������ 0

end start                ; ����� �ணࠬ��. 㪠������ ��⪠ ᮮ⢥����� ��砫� �ᯮ��塞��� ����
