*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\ENCRYPT_IT.PRG
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
*:   ENCRYPT_IT
*:   ENCRYPT_IT
*******************************************************************
* Function Encryption
* ---โปรแกรม...... เข้ารหัส
* --- ตัวอย่าง...... cEncrypt = ENCRYPT_IT("KASEM")
*******************************************************************
*!******************************************************************************
*!
*! Procedure ENCRYPT_IT
*!
*!******************************************************************************
Function ENCRYPT_IT     && Call this to encrypt password
	Parameters cPassword
	cEncrypted_password = ''
	For i = 1 To Len(cPassword)
		cLetter = Substr(cPassword, i, 1)
		cEncrypted_password = cEncrypted_password + ;
			CHR(Mod(Asc(cLetter)+100,255))      && Encryption formula
	Next i
	Return cEncrypted_password
Endfunc
