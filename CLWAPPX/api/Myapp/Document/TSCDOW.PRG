*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\TSCDOW.PRG
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
*:   TSCDOW
*:   TSCDOW
*******************************************************************
* Function Convert day of week (Thai) short
* ---�����...... �ʴ��ѹ��ѻ�������ҧ���
* --- ������ҧ...... cDAY=TSCDOW(DATE())
*******************************************************************
*!******************************************************************************
*!
*! Procedure TSCDOW
*!
*!******************************************************************************
Function TSCDOW
	Parameter mdtm
	mdtnm=Dow(mdtm)
	mcdm=Subst('�Ҩ.�.�.���.�.',2*mdtnm-1,2)
	Return (mcdm)
Endfunc
