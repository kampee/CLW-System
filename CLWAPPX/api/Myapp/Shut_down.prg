*******************************************************************
* Procedure ShutDown 
* ---�����...... �׹�ѹ����͡�ҡ����� 
* --- ������ҧ......  ON SHUTDOWN DO SHUT_DOWN
*******************************************************************
PROCEDURE SHUT_DOWN
LOCAL nAnswer
  nAnswer = messagebox("��ͧ����͡�ҡ�����",292,"")
  IF nAnswer = 6
	  QUIT
   ENDIF	  
ENDPROC
