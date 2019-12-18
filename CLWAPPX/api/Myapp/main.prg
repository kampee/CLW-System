PUBLIC lSuccess,cDriveDir
* ซ่อน Main Visual FoxPro Window
_SCREEN.Visible = .F.
*เรียกใช้ไฟล์โพซิเยอร์ ซึ่งเก็บฟังก์ชันที่ผู้ใช้กำหนด
SET PROCEDURE TO UTILITY  
* แสดงโลโก้
DO FORM LOGO
INKEY(5,'H')
* ฟอร์มป้อนรหัสผ่าน User & Password
DO FORM LOGIN 
LOGIN.Mytextbox1.SetFocus
READ EVENT   && สำคัญมาก ต้องมีอยู่ในโปรแกรมอย่างน้อย 1 แห่ง
LOGO.RELEASE
IF lSuccess   && รหัสผ่านถูกต้อง
	* ควบคุมการออกจากโปรแกรม
	ON SHUTDOWN DO SHUT_DOWN
	* แสดงข้อผิดพลาดที่เกิดขึ้น
	ON ERROR DO errhand WITH ;
	   ERROR( ), MESSAGE( ), MESSAGE(1),;
	   PROGRAM( ), LINENO( )
	* แสดง Main Visual FoxPro Window   
	DO RESIZE
	_SCREEN.WindowState = 2
*	DO GBackgnd WITH _SCREEN && แสดงเฉดสีฟ้าบน Main Visual FoxPro Window
*	_SCREEN.Visible = .T. 
	* เรียกโปรแกรมเมนู
	DO MENU.MPR
	KEYBOARD '{F10}'
	KEYBOARD '{DNARROW}'
	READ EVENT
	SET SYSMENU TO DEFA
	_SCREEN.BACKCOLOR = 16777215
	ON SHUTDOWN
	CLEAR
ENDIF
* จบโปรแกรม