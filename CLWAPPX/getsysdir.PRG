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
? "Size of Data : " + STR(liRet)    && ��ҿѧ��ѹ���������稨��觤�ҡ�Ѻ�� 0 
? "Windows System Directory : " + LEFT(lsSysDir,liRet)
CLEAR DLLS 
** End Program 

