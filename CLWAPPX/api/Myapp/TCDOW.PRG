*******************************************************************
* Function Convert day of week (Thai)
* ---�����...... �ʴ��ѹ��ѻ���� 
* --- ������ҧ...... cDAY=TCDOW(DATE())
*******************************************************************
FUNCTION TCDOW
PARAMETER dDATE
   nDay=DOW(dDATE)
   DO CASE
   CASE nDAY=1
     RETURN '�ҷԵ��'
   CASE nDAY=2
     RETURN '�ѹ���'
   CASE nDAY=3
     RETURN '�ѧ���'
   CASE nDAY=4
     RETURN '�ظ'
   CASE nDAY=5
     RETURN '����ʺ��'
   CASE nDAY=6
     RETURN '�ء��'
   CASE nDAY=7
     RETURN '�����'
   OTHERWISE
     RETURN ''
   ENDCASE
ENDFUNC
