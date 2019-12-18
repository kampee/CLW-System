*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\GETVOL.PRG
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
*:   GETVOL
******************************************************************
** Program: Getvol.prg **
** Purpose: Demonstrates how to declare and use the Win32 **
** GetVolumeInformation API. **
*******************************************************************
lpRootPathName = "c:\" && Drive and directory path
lpVolumeNameBuffer = Space(256) && lpVolumeName return buffer
nVolumeNameSize = 256 && Size of/lpVolumeNameBuffer
lpVolumeSerialNumber = 0 && lpVolumeSerialNumber buffer
lpMaximumComponentLength = 256
lpFileSystemFlags = 0
lpFileSystemNameBuffer = Space(256)
nFileSystemNameSize = 256
Declare Integer GetVolumeInformation In Win32API As GetVolInfo ;
	STRING @lpRootPathName, ;
	STRING @lpVolumeNameBuffer, ;
	INTEGER nVolumeNameSize, ;
	INTEGER @lpVolumeSerialNumber, ;
	INTEGER @lpMaximumComponentLength, ;
	INTEGER @lpFileSystemFlags, ;
	STRING @lpFileSystemNameBuffer, ;
	INTEGER nFileSystemNameSize
RetVal=GetVolInfo(@lpRootPathName, @lpVolumeNameBuffer, ;
	nVolumeNameSize, @lpVolumeSerialNumber, ;
	@lpMaximumComponentLength, @lpFileSystemFlags, ;
	@lpFileSystemNameBuffer, nFileSystemNameSize)
** Because several of the return values are padded with a null **
** terminator, you will need to strip off the null terminator **
** in order to get the correct value, which is what is done **
** using the LEFT, ALLTRIM, and LEN functions. **
? "Drive & path name : " + ;
	ALLTRIM(lpRootPathName)
? "Volume name : " + ;
	LEFT(Alltrim(lpVolumeNameBuffer), ;
	LEN(Alltrim(lpVolumeNameBuffer))-1)
? "Max #/chars in vol name : " + ;
	ALLTRIM(Str(nVolumeNameSize))
? "Volume Serial # : " + ;
	ALLTRIM(Str(lpVolumeSerialNumber))
? "Max #/chars in dir/file names: " + ;
	ALLTRIM(Str(lpMaximumComponentLength))
? "File System Flags : " + ;
	ALLTRIM(Str(lpFileSystemFlags))
? "File System type : " + ;
	LEFT(Alltrim(lpFileSystemNameBuffer), ;
	LEN(Alltrim(lpFileSystemNameBuffer))-1)
? "File Sys Name Size : " + ;
	ALLTRIM(Str(nFileSystemNameSize))
Clear Dlls
** End Program
