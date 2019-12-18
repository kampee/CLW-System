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
* ---โปรแกรม...... แสดงข้อผิดพลาดที่เกิดขึ้น
* --- ตัวอย่าง......  ON ERROR DO ERRHAND WITH ERROR( ),MESSAGE( ),MESSAGE(1),PROGRAM( ),LINENO( )
*******************************************************************
*!******************************************************************************
*!
*! Procedure ERRHAND
*!
*!******************************************************************************
Procedure errhand
	Parameter merror, Mess, mess1, mprog, mlineno
	Messagebox('หมายเลขข้อผิดพลาด: ' + Ltrim(Str(merror)) + Chr(13) +  ;
		'ข้อผิดพลาด: ' + Mess + Chr(13) +  ;
		'บรรทัดข้อผิดพลาด: ' + mess1 + Chr(13) +  ;
		'บรรทัดที่ผิดพลาด: ' + Ltrim(Str(mlineno)) + Chr(13) + ;
		'โปรแกรม: ' + mprog + Chr(13) + ;
		'Please contact your Vendor '+ Chr(13) + ;
		'ถ้าคุณเปิด Visual FoxPro อยู่ก่อนแล้วให้ปิดแล้วเรียกโปรแกรมอีกครั้ง' , 288,"")
	On Shutdown
	Quit
Endproc
