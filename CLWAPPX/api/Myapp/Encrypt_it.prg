*******************************************************************
* Function Encryption 
* ---โปรแกรม...... เข้ารหัส 
* --- ตัวอย่าง...... cEncrypt = ENCRYPT_IT("KASEM")
*******************************************************************
 FUNCTION ENCRYPT_IT     && Call this to encrypt password
      PARAMETERS cPassword
      cEncrypted_password = ''
      FOR i = 1 TO LEN(cPassword)
         cLetter = SUBSTR(cPassword, i, 1)
         cEncrypted_password = cEncrypted_password + ;
            CHR(MOD(ASC(cLetter)+100,255))      && Encryption formula
      NEXT i
 RETURN cEncrypted_password
 ENDFUNC
