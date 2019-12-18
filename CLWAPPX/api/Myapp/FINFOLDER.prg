*******************************************************************
** Program: FinFolder.prg **
** Purpose: Demonstrates how to declare and use the SHELL32 **
** SHGetSpecialFolderPath API. **
*******************************************************************
*** Define Special Folder Constants
#define CSIDL_PROGRAMS 2 &&Program Groups Folder
#define CSIDL_PERSONAL 5 &&Personal Documents Folder
#define CSIDL_FAVORITES 6 &&Favorites Folder
#define CSIDL_STARTUP 7 &&Startup Group Folder
#define CSIDL_RECENT 8 &&Recently Used Documents
#define CSIDL_SENDTO 9 &&Send To Folder
#define CSIDL_STARTMENU 11 &&Start Menu Folder
#define CSIDL_DESKTOPDIRECTORY 16 &&Desktop Folder
#define CSIDL_NETHOOD 19 &&Network Neighborhood Folder
#define CSIDL_TEMPLATES 21 &&Document Templates Folder
#define CSIDL_COMMON_STARTMENU 22 &&Common Start Menu
#define CSIDL_COMMON_PROGRAMS 23 &&Common Program Groups
#define CSIDL_COMMON_STARTUP 24 &&Common Startup Group
#define CSIDL_COMMON_DESKTOPDIR 25 &&Common Desktop Folder
#define CSIDL_APPDATA 26 &&Application Data Folder
#define CSIDL_PRINTHOOD 27 &&Printers Folder
#define CSIDL_COMMON_FAVORITES 31 &&Common Favorites Folder
#define CSIDL_INTERNET_CACHE 32 &&Temp. Internet Files Folder
#define CSIDL_COOKIES 33 &&Cookies Folder
#define CSIDL_HISTORY 34 &&History Folder
cSpecialFolderPath = space(255)
DECLARE SHGetSpecialFolderPath IN SHELL32.DLL ;
AS GetFolder LONG hwndOwner, ;
STRING @cSpecialFolderPath, ;
LONG nWhichFolder
* เช่นต้องการค้นหา StartUp Folder ว่าอยู่ ณ.ที่ใด 
* เราจะใช้ตัวแปร CSIDL_STARTUP ซึ่งมีค่าเท่ากับ 7
GetFolder(0, @cSpecialFolderPath, CSIDL_STARTUP)
?SubStr(RTrim(cSpecialFolderPath),1, Len(RTrim(cSpecialFolderPath))-1)
CLEAR DLLS
** End Program 
