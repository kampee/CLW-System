*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\FINDFILE.PRG
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
*:   FINDFILE
*******************************************************************
** Program: FindFile.prg **
** Purpose: Demonstrates how to declare and use the SHELL32 **
** FindExecutable API. **
*******************************************************************
lpFile = "NOTEPAD.EXE"
lpDirectory = ''
lpResults = Space(128)
Declare Integer FindExecutable In SHELL32 ;
	STRING@lpFile, String@lpDirectory, ;
	STRING @lpResults
liReturnValue = FindExecutable(@lpFile, @lpDirectory,@lpResults)
* ในกรณีที่ทำการค้นหาแล้วไม่พบ IiReturnValue จะมีค่าดังนี้
* 0 = Out of memory or resources
* 31 = No association for file type
* 2 = Specified file not found
* 3 = Specified path not found
* 11 = Invalid EXE format
?liReturnValue
lpResults = Left(lpResults, At(Chr(0), lpResults) - 1)
? "Full path of application: " + lpResults
Clear Dlls
** End Program
