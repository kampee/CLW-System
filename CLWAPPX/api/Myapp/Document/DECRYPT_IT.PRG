*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\DECRYPT_IT.PRG
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
*:   DECRYPT_IT
*:   DECRYPT_IT
*******************************************************************
* Function Decryption
* ---โปรแกรม...... เข้าถอดรหัส
* --- ตัวอย่าง...... cDecrypt = DECRYPT_IT(ENCRYPT_IT("KASEM"))
*******************************************************************
*!******************************************************************************
*!
*! Procedure DECRYPT_IT
*!
*!******************************************************************************
Function  DECRYPT_IT     && Call this to Decrypt password
	Parameters cPassword
	cUnencrypted_password = ''
	For i = 1 To Len(cPassword)
		cLetter = Substr(cPassword, i, 1)
		cUnencrypted_password = cUnencrypted_password + ;
			CHR(Mod(Asc(cLetter)-100,255))    && Reverse of encryption formula
	Next i
	Return cUnencrypted_password
Endfunc
