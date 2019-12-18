*******************************************************************
* Procedure ShutDown 
* ---โปรแกรม...... ยืนยันการออกจากโปรแกรม 
* --- ตัวอย่าง......  ON SHUTDOWN DO SHUT_DOWN
*******************************************************************
PROCEDURE SHUT_DOWN
LOCAL nAnswer
  nAnswer = messagebox("ต้องการออกจากโปรแกรม",292,"")
  IF nAnswer = 6
	  QUIT
   ENDIF	  
ENDPROC
