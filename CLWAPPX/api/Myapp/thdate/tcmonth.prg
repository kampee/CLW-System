*TCMONTH.PRG
***************************************************************
* ---FUNCTION TCMONTH
* ---�����...... �ŧ�����͹��������
*-- �����...... mMONTH=TCMONTH(DATE())
***************************************************************
FUNC TCMONTH 
PARA  dDATE
IF TYPE('dDATE')#'D'
    RETURN ''
ENDIF
DO CASE 
CASE MONTH(dDATE)=1
	RETURN '���Ҥ�'
CASE MONTH(dDATE)=2
	RETURN '����Ҿѹ��'
CASE MONTH(dDATE)=3
	RETURN '�չҤ�'
CASE MONTH(dDATE)=4
	RETURN '����¹'
CASE MONTH(dDATE)=5
	RETURN '����Ҥ�'
CASE MONTH(dDATE)=6
	RETURN '�Զع�¹'
CASE MONTH(dDATE)=7
	RETURN '�á�Ҥ�'
CASE MONTH(dDATE)=8
	RETURN '�ԧ�Ҥ�'
CASE MONTH(dDATE)=9
	RETURN '�ѹ��¹'
CASE MONTH(dDATE)=10
	RETURN '���Ҥ�'
CASE MONTH(dDATE)=11
	RETURN '��Ȩԡ�¹'
CASE MONTH(dDATE)=12
	RETURN '�ѹ�Ҥ�'
ENDCASE
RETURN ''

