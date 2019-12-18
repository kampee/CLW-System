*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\FINFOLDER.PRG
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
*:   FINFOLDER
*******************************************************************
** Program: FinFolder.prg **
** Purpose: Demonstrates how to declare and use the SHELL32 **
** SHGetSpecialFolderPath API. **
*******************************************************************
*** Define Special Folder Constants
#Define CSIDL_PROGRAMS 2 &&Program Groups Folder
#Define CSIDL_PERSONAL 5 &&Personal Documents Folder
#Define CSIDL_FAVORITES 6 &&Favorites Folder
#Define CSIDL_STARTUP 7 &&Startup Group Folder
#Define CSIDL_RECENT 8 &&Recently Used Documents
#Define CSIDL_SENDTO 9 &&Send To Folder
#Define CSIDL_STARTMENU 11 &&Start Menu Folder
#Define CSIDL_DESKTOPDIRECTORY 16 &&Desktop Folder
#Define CSIDL_NETHOOD 19 &&Network Neighborhood Folder
#Define CSIDL_TEMPLATES 21 &&Document Templates Folder
#Define CSIDL_COMMON_STARTMENU 22 &&Common Start Menu
#Define CSIDL_COMMON_PROGRAMS 23 &&Common Program Groups
#Define CSIDL_COMMON_STARTUP 24 &&Common Startup Group
#Define CSIDL_COMMON_DESKTOPDIR 25 &&Common Desktop Folder
#Define CSIDL_APPDATA 26 &&Application Data Folder
#Define CSIDL_PRINTHOOD 27 &&Printers Folder
#Define CSIDL_COMMON_FAVORITES 31 &&Common Favorites Folder
#Define CSIDL_INTERNET_CACHE 32 &&Temp. Internet Files Folder
#Define CSIDL_COOKIES 33 &&Cookies Folder
#Define CSIDL_HISTORY 34 &&History Folder
cSpecialFolderPath = Space(255)
Declare SHGetSpecialFolderPath In SHELL32.Dll ;
	AS GetFolder Long hwndOwner, ;
	STRING @cSpecialFolderPath, ;
	LONG nWhichFolder
* เช่นต้องการค้นหา StartUp Folder ว่าอยู่ ณ.ที่ใด
* เราจะใช้ตัวแปร CSIDL_STARTUP ซึ่งมีค่าเท่ากับ 7
GetFolder(0, @cSpecialFolderPath, CSIDL_STARTUP)
?Substr(Rtrim(cSpecialFolderPath),1, Len(Rtrim(cSpecialFolderPath))-1)
Clear Dlls
** End Program
