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
* ��͹ Main Visual FoxPro Window
_Screen.Visible = .F.
*���¡�����⾫������ ����线ѧ��ѹ��������˹�
Set Procedure To UTILITY
* �ʴ�����
Do Form Logo
Inkey(5,'H')
* �������͹���ʼ�ҹ User & Password
Do Form LOGIN
LOGIN.Mytextbox1.SetFocus
Read Event   && �Ӥѭ�ҡ ��ͧ���������������ҧ���� 1 ���
Logo.Release
If lSuccess   && ���ʼ�ҹ�١��ͧ
	* �Ǻ�������͡�ҡ�����
	On Shutdown Do SHUT_DOWN
	* �ʴ���ͼԴ��Ҵ����Դ���
	On Error Do errhand With ;
		ERROR( ), Message( ), Message(1),;
		PROGRAM( ), Lineno( )
	* �ʴ� Main Visual FoxPro Window
	Do Resize
	_Screen.WindowState = 2
	*	DO GBackgnd WITH _SCREEN && �ʴ�ੴ�տ�Һ� Main Visual FoxPro Window
	*	_SCREEN.Visible = .T.
	* ���¡���������
	Do Menu.MPR
	Keyboard '{F10}'
	Keyboard '{DNARROW}'
	Read Event
	Set Sysmenu To Defa
	_Screen.BackColor = 16777215
	On Shutdown
	Clear
Endif
* �������
