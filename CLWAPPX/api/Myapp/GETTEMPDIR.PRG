*******************************************************************
** Program: GetTempDir.prg **
** Purpose: Demonstrates how to declare and use the Win32 **
** GetTempPath API. **
*******************************************************************
lsSysDir = SPACE(256) && MAX_PATH, the maximum path length
liSize = 256
DECLARE INTEGER GetTempPath IN Win32API ;
INTEGER liSize, ;
STRING @lsSysDir 
liRet = GetTempPath(liSize, @lsSysDir) 
? "Size of Data : " + STR(liRet) && ��ҿѧ��ѹ���������稨��觤�ҡ�Ѻ�� 0
? "Windows Tempolary Directory : " + LEFT(lsSysDir,liRet)
CLEAR DLLS
** End Program 
