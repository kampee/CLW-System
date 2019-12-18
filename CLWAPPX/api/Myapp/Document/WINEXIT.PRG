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
* uFlags ข้อมูลชนิด INTEGER ที่ใช้สำหรับกำหนดหน้าที่ให้ฟังก์ชัน ExitWindowsEx ( ) สามารถมีค่าได้ดังนี้
* 0 เมื่อต้องการ สั่งให้ Log Off ออกจากระบบเครือข่าย
* 1 เมื่อต้องการ สั่งให้ Shutdown เครื่อง
* 2 เมื่อต้องการสั่งให้ Restart เครื่องใหม่
* 4 เมื่อต้องการออกจาก Windows โดยทันที (Force)
dwReserved = 0
Declare Integer ExitWindowsEx In Win32API As ExitWindows Integer uFlags , Integer dwReserved
RetVal = ExitWindows(uFlags, dwReserved)
Clear Dlls
** End Program
