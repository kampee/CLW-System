*TD2BE.PRG
***************************************************************
* ---FUNCTION TD2BE
* ---�����...... �ŧ����ѹ�����������ѹ�����
*-- �����...... cTdate=TD2BE('12 ���Ҥ� 2543')
***************************************************************
FUNC TD2BE
PARA cTDATE 
LOCAL cMM,nMM
STOR SPACE(2) TO nMM
IF TYPE('cTDATE')#'C'
RETURN ''
ENDIF
DO CASE
CASE AT('���Ҥ�', cTDATE) > 0
cMM = '���Ҥ�'
nMM = '01'
CASE AT('����Ҿѹ��', cTDATE) > 0
cMM = '����Ҿѹ��'
nMM = '02'
CASE AT('�չҤ�', cTDATE) > 0
cMM = '�չҤ�'
nMM = '03'
CASE AT('����¹', cTDATE) > 0
cMM ='����¹'
nMM = '04'
CASE AT('����Ҥ�', cTDATE) > 0
cMM = '����Ҥ�'
nMM = '05'
CASE AT('�Զع�¹', cTDATE) > 0
cMM = '�Զع�¹'
nMM = '06'
CASE AT('�á�Ҥ�', cTDATE) > 0
cMM = '�á�Ҥ�'
nMM = '07'
CASE AT('�ԧ�Ҥ�', cTDATE) > 0
cMM = '�ԧ�Ҥ�'
nMM = '08'
CASE AT('�ѹ��¹', cTDATE) > 0
cMM = '�ѹ��¹'
nMM = '09'
CASE AT('���Ҥ�', cTDATE) > 0
cMM = '���Ҥ�'
nMM = '10'
CASE AT('��Ȩԡ�¹', cTDATE) > 0
cMM = '��Ȩԡ�¹'
nMM = '11'
CASE AT('�ѹ�Ҥ�', cTDATE) > 0
cMM = '�ѹ�Ҥ�'
nMM = '12'
ENDCASE
IF !EMPTY(nMM)
RETURN ALLT(LEFT(cTDATE,ATC(cMM,cTDATE)-1))+ ;
'/'+nMM+'/' + RIGHT(cTDATE,LEN(cTDATE)- ;
(ATC(cMM,cTDATE)+LEN(cMM)))
ENDIF
RETURN ''

