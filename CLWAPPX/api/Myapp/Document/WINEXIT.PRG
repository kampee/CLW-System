*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\WINEXIT.PRG
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
*:   WINEXIT
*******************************************************************
** Program: WinExit.prg **
** Purpose: Demonstrates how to declare and use the Win32 **
** ExitWindowsEx API. **
*******************************************************************
uFlags = 0
* uFlags �����Ū�Դ INTEGER ���������Ѻ��˹�˹�ҷ�����ѧ��ѹ ExitWindowsEx ( ) ����ö�դ����ѧ���
* 0 ����͵�ͧ��� ������ Log Off �͡�ҡ�к����͢���
* 1 ����͵�ͧ��� ������ Shutdown ����ͧ
* 2 ����͵�ͧ��������� Restart ����ͧ����
* 4 ����͵�ͧ����͡�ҡ Windows �·ѹ�� (Force)
dwReserved = 0
Declare Integer ExitWindowsEx In Win32API As ExitWindows Integer uFlags , Integer dwReserved
RetVal = ExitWindows(uFlags, dwReserved)
Clear Dlls
** End Program
