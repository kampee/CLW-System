*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\BEEP.PRG
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
*:   BEEP
*******************************************************************
** Program: Beep.prg **
** Purpose: Demonstrates how to declare and use the WIN32API **
** MessageBeep API. **
*******************************************************************
#Define MB_OK 0 && Default Sound
#Define MB_ICONHAND 16 && Certical Stop
#Define MB_ICONQUESTION 32 && Question
#Define MB_ICONEXCLAMATION 48 && Exclamation
#Define MB_ICONASTERISK 64 && Asterisk
Declare Integer MessageBeep In Win32API Integer
=MessageBeep(MB_OK)
Clear Dlls
** End Program
