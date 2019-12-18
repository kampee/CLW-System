*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\GETUSER.PRG
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
*:   GETUSER
*******************************************************************
** Program: Getuser.prg **
** Purpose: Demonstrates how to use and call the Win32 **
** GetUserName API. **
*******************************************************************
RetVal = 0
lpUserIDBuffer = Space(256) && Return buffer for user ID string
nBufferSize = 256 && Size of user ID return buffer
Declare Integer GetUserName In Win32API As UserName ;
	STRING @lpUserIDBuffer, ;
	INTEGER @nBufferSize
RetVal=UserName(@lpUserIDBuffer, @nBufferSize)
? RetVal && ถ้าฟังก์ชันทำไม่สำเร็จจะส่งค่ากลับเป็น 0
? "Value in lpUserIDBuffer : " + lpUserIDBuffer
? "Value in nBufferSize : " + Str(nBufferSize)
? "User ID : " + Left(lpUserIDBuffer,nBufferSize-1)
Clear Dlls
** End Program
