PUBLIC lSuccess,cDriveDir
* ��͹ Main Visual FoxPro Window
_SCREEN.Visible = .F.
*���¡�����⾫������ ����线ѧ��ѹ��������˹�
SET PROCEDURE TO UTILITY  
* �ʴ�����
DO FORM LOGO
INKEY(5,'H')
* �������͹���ʼ�ҹ User & Password
DO FORM LOGIN 
LOGIN.Mytextbox1.SetFocus
READ EVENT   && �Ӥѭ�ҡ ��ͧ���������������ҧ���� 1 ���
LOGO.RELEASE
IF lSuccess   && ���ʼ�ҹ�١��ͧ
	* �Ǻ�������͡�ҡ�����
	ON SHUTDOWN DO SHUT_DOWN
	* �ʴ���ͼԴ��Ҵ����Դ���
	ON ERROR DO errhand WITH ;
	   ERROR( ), MESSAGE( ), MESSAGE(1),;
	   PROGRAM( ), LINENO( )
	* �ʴ� Main Visual FoxPro Window   
	DO RESIZE
	_SCREEN.WindowState = 2
*	DO GBackgnd WITH _SCREEN && �ʴ�ੴ�տ�Һ� Main Visual FoxPro Window
*	_SCREEN.Visible = .T. 
	* ���¡���������
	DO MENU.MPR
	KEYBOARD '{F10}'
	KEYBOARD '{DNARROW}'
	READ EVENT
	SET SYSMENU TO DEFA
	_SCREEN.BACKCOLOR = 16777215
	ON SHUTDOWN
	CLEAR
ENDIF
* �������