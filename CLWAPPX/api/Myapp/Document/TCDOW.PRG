*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\TCDOW.PRG
*:
*:	Kasem Kamolchaipisit
*:	thai_vfp@hotmail.com
*:	http://members.xoom.com/thai_vfp
*:	
*:	
*:	
*:	
*:	
*:	
*:	
*:	
*:	
*:	
*:
*: Documented using Visual FoxPro Formatting wizard version  .05
*:******************************************************************************
*:   TCDOW
*:   TCDOW
*******************************************************************
* Function Convert day of week (Thai)
* ---�����...... �ʴ��ѹ��ѻ����
* --- ������ҧ...... cDAY=TCDOW(DATE())
*******************************************************************
*!******************************************************************************
*!
*! Procedure TCDOW
*!
*!******************************************************************************
Function TCDOW
	Parameter dDATE
	nDay=Dow(dDATE)
	Do Case
	Case nDay=1
		Return '�ҷԵ��'
	Case nDay=2
		Return '�ѹ���'
	Case nDay=3
		Return '�ѧ���'
	Case nDay=4
		Return '�ظ'
	Case nDay=5
		Return '����ʺ��'
	Case nDay=6
		Return '�ء��'
	Case nDay=7
		Return '�����'
	Otherwise
		Return ''
	Endcase
Endfunc
