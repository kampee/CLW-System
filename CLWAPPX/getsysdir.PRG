**---------------------------------------------------------------**
** Program: GetSysDir.prg **
** Purpose: Demonstrates how to declare and use the Win32 **
** GetSystemDirectory API. **
**---------------------------------------------------------------**

lsSysDir = SPACE(256) && MAX_PATH, the maximum path length
liSize = 256 
DECLARE INTEGER GetSystemDirectory IN Win32API ;
STRING @lsSysDir, ;
INTEGER liSize

liRet = GetSystemDirectory(@lsSysDir, liSize) 
? "Size of Data : " + STR(liRet)    && ถ้าฟังก์ชันทำไม่สำเร็จจะส่งค่ากลับเป็น 0 
? "Windows System Directory : " + LEFT(lsSysDir,liRet)
CLEAR DLLS 
** End Program 

