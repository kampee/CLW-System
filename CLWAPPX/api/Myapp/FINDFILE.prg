*******************************************************************
** Program: FindFile.prg **
** Purpose: Demonstrates how to declare and use the SHELL32 **
** FindExecutable API. **
*******************************************************************
lpFile = "NOTEPAD.EXE"
lpDirectory = ''
lpResults = SPACE(128)
DECLARE INTEGER FindExecutable IN SHELL32 ;
STRING@lpFile, STRING@lpDirectory, ;
STRING @lpResults
liReturnValue = FindExecutable(@lpFile, @lpDirectory,@lpResults)
* ในกรณีที่ทำการค้นหาแล้วไม่พบ IiReturnValue จะมีค่าดังนี้
* 0 = Out of memory or resources
* 31 = No association for file type
* 2 = Specified file not found
* 3 = Specified path not found
* 11 = Invalid EXE format
?liReturnValue
lpResults = LEFT(lpResults, AT(CHR(0), lpResults) - 1)
? "Full path of application: " + lpResults
CLEAR DLLS
** End Program
