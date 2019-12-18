*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\GETTEMPDIR.PRG
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
*:   GETTEMPDIR
*******************************************************************
** Program: GetTempDir.prg **
** Purpose: Demonstrates how to declare and use the Win32 **
** GetTempPath API. **
*******************************************************************
lsSysDir = Space(256) && MAX_PATH, the maximum path length
liSize = 256
Declare Integer GetTempPath In Win32API ;
	INTEGER liSize, ;
	STRING @lsSysDir
liRet = GetTempPath(liSize, @lsSysDir)
? "Size of Data : " + Str(liRet) && ถ้าฟังก์ชันทำไม่สำเร็จจะส่งค่ากลับเป็น 0
? "Windows Tempolary Directory : " + Left(lsSysDir,liRet)
Clear Dlls
** End Program
