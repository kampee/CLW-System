*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\ERRHAND.PRG
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
*:   errhand
*:   errhand
*******************************************************************
* Procedure OnError
* ---�����...... �ʴ���ͼԴ��Ҵ����Դ���
* --- ������ҧ......  ON ERROR DO ERRHAND WITH ERROR( ),MESSAGE( ),MESSAGE(1),PROGRAM( ),LINENO( )
*******************************************************************
*!******************************************************************************
*!
*! Procedure ERRHAND
*!
*!******************************************************************************
Procedure errhand
	Parameter merror, Mess, mess1, mprog, mlineno
	Messagebox('�����Ţ��ͼԴ��Ҵ: ' + Ltrim(Str(merror)) + Chr(13) +  ;
		'��ͼԴ��Ҵ: ' + Mess + Chr(13) +  ;
		'��÷Ѵ��ͼԴ��Ҵ: ' + mess1 + Chr(13) +  ;
		'��÷Ѵ���Դ��Ҵ: ' + Ltrim(Str(mlineno)) + Chr(13) + ;
		'�����: ' + mprog + Chr(13) + ;
		'Please contact your Vendor '+ Chr(13) + ;
		'��Ҥس�Դ Visual FoxPro �����͹�������Դ�������¡������ա����' , 288,"")
	On Shutdown
	Quit
Endproc
