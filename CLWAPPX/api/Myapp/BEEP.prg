*******************************************************************
** Program: Beep.prg **
** Purpose: Demonstrates how to declare and use the WIN32API **
** MessageBeep API. **
*******************************************************************
#DEFINE MB_OK 0 && Default Sound
#DEFINE MB_ICONHAND 16 && Certical Stop
#DEFINE MB_ICONQUESTION 32 && Question
#DEFINE MB_ICONEXCLAMATION 48 && Exclamation
#DEFINE MB_ICONASTERISK 64 && Asterisk
DECLARE INTEGER MessageBeep IN Win32API INTEGER
=MessageBeep(MB_OK)
CLEAR DLLS
** End Program
