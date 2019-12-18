*BC2BE.PRG
***************************************************************
* Function Convert date from BC to BE
* ---โปรแกรม...... แปลงค่าวันที่จาก ค.ศ. เป็น พ.ศ.
* ---ตัวอย่าง...... cTDATE=BC2BE(DATE())
***************************************************************
FUNC BC2BE 
PARA BCDATE && ค.ศ. 
IF TYPE('BCDATE')#'D'
RETURN ''
ENDIF
LOCAL cDD,cMM
cDD = ALLT(STR(DAY(BCDATE),2))
cDD = IIF(LEN(cDD)=1,"0"+cDD,cDD)
cMM = ALLT(STR(MONTH(BCDATE),2))
cMM = IIF(LEN(cMM)=1,"0"+cMM,cMM)
RETU cDD+'/'+cMM+'/'+STR(YEAR(BCDATE)+543,4)

