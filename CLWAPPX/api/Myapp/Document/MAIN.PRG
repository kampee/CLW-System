*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\MAIN.PRG
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
*:   MAIN
Public lSuccess,cDriveDir
* ซ่อน Main Visual FoxPro Window
_Screen.Visible = .F.
*เรียกใช้ไฟล์โพซิเยอร์ ซึ่งเก็บฟังก์ชันที่ผู้ใช้กำหนด
Set Procedure To UTILITY
* แสดงโลโก้
Do Form Logo
Inkey(5,'H')
* ฟอร์มป้อนรหัสผ่าน User & Password
Do Form LOGIN
LOGIN.Mytextbox1.SetFocus
Read Event   && สำคัญมาก ต้องมีอยู่ในโปรแกรมอย่างน้อย 1 แห่ง
Logo.Release
If lSuccess   && รหัสผ่านถูกต้อง
	* ควบคุมการออกจากโปรแกรม
	On Shutdown Do SHUT_DOWN
	* แสดงข้อผิดพลาดที่เกิดขึ้น
	On Error Do errhand With ;
		ERROR( ), Message( ), Message(1),;
		PROGRAM( ), Lineno( )
	* แสดง Main Visual FoxPro Window
	Do Resize
	_Screen.WindowState = 2
	*	DO GBackgnd WITH _SCREEN && แสดงเฉดสีฟ้าบน Main Visual FoxPro Window
	*	_SCREEN.Visible = .T.
	* เรียกโปรแกรมเมนู
	Do Menu.MPR
	Keyboard '{F10}'
	Keyboard '{DNARROW}'
	Read Event
	Set Sysmenu To Defa
	_Screen.BackColor = 16777215
	On Shutdown
	Clear
Endif
* จบโปรแกรม
