*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\GETSYSDIR.PRG
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
*:   GETSYSDIR
*******************************************************************
** Program: GetSysDir.prg **
** Purpose: Demonstrates how to declare and use the Win32 **
** GetSystemDirectory API. **
*******************************************************************
lsSysDir = Space(256) && MAX_PATH, the maximum path length
liSize = 256
Declare Integer GetSystemDirectory In Win32API ;
	STRING @lsSysDir, ;
	INTEGER liSize
liRet = GetSystemDirectory(@lsSysDir, liSize)
? "Size of Data : " + Str(liRet) && ถ้าฟังก์ชันทำไม่สำเร็จจะส่งค่ากลับเป็น 0
? "Windows System Directory : " + Left(lsSysDir,liRet)
Clear Dlls
** End Program
