*******************************************************************
* Function Convert day of week (Thai) short
* ---�����...... �ʴ��ѹ��ѻ�������ҧ���
* --- ������ҧ...... cDAY=TSCDOW(DATE())
*******************************************************************
FUNCTION TSCDOW
PARAMETER mdtm
   mdtnm=DOW(mdtm)
   mcdm=SUBST('�Ҩ.�.�.���.�.',2*mdtnm-1,2)
   RETURN (mcdm)
ENDFUNC
