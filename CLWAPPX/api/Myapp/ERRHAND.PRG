*******************************************************************
* Procedure OnError 
* ---�����...... �ʴ���ͼԴ��Ҵ����Դ���
* --- ������ҧ......  ON ERROR DO ERRHAND WITH ERROR( ),MESSAGE( ),MESSAGE(1),PROGRAM( ),LINENO( )
*******************************************************************
PROCEDURE ERRHAND
PARAMETER merror, mess, mess1, mprog, mlineno
     messagebox('�����Ţ��ͼԴ��Ҵ: ' + LTRIM(STR(merror)) + CHR(13) +  ;
                             '��ͼԴ��Ҵ: ' + mess + CHR(13) +  ;
                             '��÷Ѵ��ͼԴ��Ҵ: ' + mess1 + CHR(13) +  ;
                             '��÷Ѵ���Դ��Ҵ: ' + LTRIM(STR(mlineno)) + CHR(13) + ;
                             '�����: ' + mprog + CHR(13) + ;
                             'Please contact your Vendor '+ CHR(13) + ;
                             '��Ҥس�Դ Visual FoxPro �����͹�������Դ�������¡������ա����' , 288,"")
     ON SHUTDOWN
     QUIT
ENDPROC
