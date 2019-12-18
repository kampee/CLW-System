*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\SHUT_DOWN.PRG
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
*:   SHUT_DOWN
*:   SHUT_DOWN
*******************************************************************
* Procedure ShutDown
* ---โปรแกรม...... ยืนยันการออกจากโปรแกรม
* --- ตัวอย่าง......  ON SHUTDOWN DO SHUT_DOWN
*******************************************************************
*!******************************************************************************
*!
*! Procedure SHUT_DOWN
*!
*!******************************************************************************
Procedure SHUT_DOWN
	Local nAnswer
	nAnswer = Messagebox("ต้องการออกจากโปรแกรม",292,"")
	If nAnswer = 6
		Quit
	Endif
Endproc
