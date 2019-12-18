*******************************************************************
** Program: Getuser.prg **
** Purpose: Demonstrates how to use and call the Win32 **
** GetUserName API. **
*******************************************************************
RetVal = 0
lpUserIDBuffer = SPACE(256) && Return buffer for user ID string
nBufferSize = 256 && Size of user ID return buffer
DECLARE INTEGER GetUserName IN Win32API AS UserName ;
STRING @lpUserIDBuffer, ;
INTEGER @nBufferSize
RetVal=UserName(@lpUserIDBuffer, @nBufferSize)
? RetVal && ถ้าฟังก์ชันทำไม่สำเร็จจะส่งค่ากลับเป็น 0 
? "Value in lpUserIDBuffer : " + lpUserIDBuffer
? "Value in nBufferSize : " + STR(nBufferSize)
? "User ID : " + LEFT(lpUserIDBuffer,nbuffersize-1)
CLEAR DLLS
** End Program
