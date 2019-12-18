*******************************************************************
* Function Decryption 
* ---โปรแกรม...... เข้าถอดรหัส
* --- ตัวอย่าง...... cDecrypt = DECRYPT_IT(ENCRYPT_IT("KASEM"))
*******************************************************************
FUNCTION  DECRYPT_IT     && Call this to Decrypt password
      PARAMETERS cPassword
      cUnencrypted_password = ''
      FOR i = 1 TO LEN(cPassword)
         cLetter = SUBSTR(cPassword, i, 1)
         cUnencrypted_password = cUnencrypted_password + ;
            CHR(MOD(ASC(cLetter)-100,255))    && Reverse of encryption formula
      NEXT i
RETURN cUnencrypted_password
ENDFUNC
