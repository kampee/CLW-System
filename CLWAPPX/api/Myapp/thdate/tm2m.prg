*TM2M.PRG
***************************************************************
* ---FUNCTION TM2M
* ---�����...... �ŧ�����͹���������͹
* ---�����¹........ Kasem K.
* ---�ѹ���....... 12.08.99
*-- �����......  nMonth=TM2M('���Ҥ�')
***************************************************************
FUNCTION TM2M
PARAMETER cTMONTH
nMM = 0
DO CASE
CASE AT('���Ҥ�', cTMONTH) > 0
        nMM = 01
CASE AT('����Ҿѹ��', cTMONTH) > 0
        nMM = 02
CASE AT('�չҤ�', cTMONTH) > 0
        nMM = 03
CASE AT('����¹', cTMONTH) > 0
        nMM = 04
CASE AT('����Ҥ�', cTMONTH) > 0
        nMM = 05
CASE AT('�Զع�¹', cTMONTH) > 0
        nMM = 06
CASE AT('�á�Ҥ�', cTMONTH) > 0
        nMM = 07
CASE AT('�ԧ�Ҥ�', cTMONTH) > 0
        nMM = 08
CASE AT('�ѹ��¹', cTMONTH) > 0
        nMM = 09
CASE AT('���Ҥ�', cTMONTH) > 0
        nMM = 10
CASE AT('��Ȩԡ�¹', cTMONTH) > 0
        nMM = 11
CASE AT('�ѹ�Ҥ�', cTMONTH) > 0
        nMM = 12
ENDCASE
RETURN nMM
