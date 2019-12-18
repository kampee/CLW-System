*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\TOPWINDOW.PRG
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
*:   TOPWINDOW
*:   TOPWINDOW
*******************************************************************
** Program: topwindow.prg **
** Purpose: Demonstrates how to declare and use the WIN32API **
** FindWindowA API. **
** SetWindowPos API. **
*******************************************************************
*!******************************************************************************
*!
*! Procedure TOPWINDOW
*!
*!  Calls
*!      FindWindowA
*!      SetWindowPos
*!
*!******************************************************************************
Function TOPWINDOW
	Para cCaption, lStatus
	Declare Long FindWindowA In WIN32API ;
		STRING Class, ;
		STRING Title
	Declare SetWindowPos In WIN32API ;
		LONG HWnd, ;
		LONG hwndafter, ;
		LONG x, ;
		LONG Y, ;
		LONG cx, ;
		LONG cy, ;
		LONG Flags
	formhandle = 0
	formhandle = FindWindowA(0,cCaption)
	If formhandle = 0
		=Messagebox("ไม่พบหน้าต่างที่ต้องการ")
	Else
		swp_nosize = 1
		swp_nomove = 2
		hwnd_topmost = -1
		hwnd_notopmost = -2
		lretval=0
		If lStatus
			lretval = SetWindowPos(formhandle,hwnd_topmost,;
				0,0,0,0,swp_nosize+swp_nomove)
		Else
			lretval = SetWindowPos(formhandle,hwnd_notopmost,;
				0,0,0,0,swp_nosize+swp_nomove)
		Endif
	Endif
	Clear Dlls
	Return
