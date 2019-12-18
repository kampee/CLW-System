**---------------------------------------------------------------**
** Program: Getvol.prg **
** Purpose: Demonstrates how to declare and use the Win32 **
** GetVolumeInformation API. **
**---------------------------------------------------------------**

lpRootPathName = "c:\" && Drive and directory path
lpVolumeNameBuffer = SPACE(256) && lpVolumeName return buffer
nVolumeNameSize = 256 && Size of/lpVolumeNameBuffer
lpVolumeSerialNumber = 0 && lpVolumeSerialNumber buffer
lpMaximumComponentLength = 256
lpFileSystemFlags = 0
lpFileSystemNameBuffer = SPACE(256)
nFileSystemNameSize = 256

DECLARE INTEGER GetVolumeInformation IN Win32API AS GetVolInfo ;
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

**--------------------------------------------------------------**
** Because several of the return values are padded with a null **
** terminator, you will need to strip off the null terminator **
** in order to get the correct value, which is what is done **
** using the LEFT, ALLTRIM, and LEN functions. **
**--------------------------------------------------------------**
? "Drive & path name : " + ;
    ALLTRIM(lpRootPathName)
? "Volume name : " + ;
    LEFT(ALLTRIM(lpVolumeNameBuffer),LEN(ALLTRIM(lpVolumeNameBuffer))-1)
? "Max #/chars in vol name : " + ;
    ALLTRIM(STR(nVolumeNameSize))
? "Volume Serial # : " + ;
    ALLTRIM(STR(lpVolumeSerialNumber))
? "Max #/chars in dir/file names: " + ;
    ALLTRIM(STR(lpMaximumComponentLength))
? "File System Flags : " + ;
    ALLTRIM(STR(lpFileSystemFlags))
? "File System type : " + ;
    LEFT(ALLTRIM(lpFileSystemNameBuffer), ;
    LEN(ALLTRIM(lpFileSystemNameBuffer))-1)
? "File Sys Name Size : " + ;
    ALLTRIM(STR(nFileSystemNameSize))
CLEAR DLLS
** End Program 