*******************************************************************
** Program: topwindow.prg **
** Purpose: Demonstrates how to declare and use the WIN32API **
** FindWindowA API. **
** SetWindowPos API. **
*******************************************************************
FUNCTION TOPWINDOW
PARA cCaption, lStatus
DECLARE LONG FindWindowA IN WIN32API ;
STRING class, ;
STRING title
DECLARE SetWindowPos IN WIN32API ;
LONG HWND, ;
LONG hwndafter, ;
LONG x, ;
LONG Y, ;
LONG cx, ;
LONG cy, ;
LONG flags
formhandle = 0
formhandle = FindWindowA(0,cCaption) 
IF formhandle = 0
   =MESSAGEBOX("ไม่พบหน้าต่างที่ต้องการ")
ELSE
   swp_nosize = 1
   swp_nomove = 2 
   hwnd_topmost = -1
   hwnd_notopmost = -2
   lretval=0
   IF lStatus 
      lretval = SetWindowPos(formhandle,hwnd_topmost,;
                    0,0,0,0,swp_nosize+swp_nomove)
   ELSE 
      lretval = SetWindowPos(formhandle,hwnd_notopmost,;
                    0,0,0,0,swp_nosize+swp_nomove)
   ENDIF
ENDIF
CLEAR DLLS
RETURN
