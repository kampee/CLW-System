*BE2BC.PRG
***************************************************************
* Function Convert date from BE to BC
* ---โปรแกรม...... แปลงค่าวันที่จาก พ.ศ. เป็น ค.ศ.
*-- นำไปใช้...... dEDATE=BE2BC('25/03/2543')
***************************************************************
FUNC BE2BC 
PARA BEDATE && DD/MM/YYYY พ.ศ. 
LOCAL nDD,nMM,nYYYY
IF TYPE('BEDATE')#'C'
RETURN ''
ENDIF
nDD = VAL(SUBST(BEDATE,1,2))
nMM = VAL(SUBST(BEDATE,4,2))
nYYYY = VAL(SUBST(BEDATE,7,4))-543
IF TYPE('nDD')#'N' .OR. TYPE('nMM')#'N' .OR. TYPE('nYYYY')#'N'
RETURN ''
ELSE
IF nDD > 0 .AND. nMM > 0 .AND. nYYYY > 0
RETURN DATE(nYYYY,nMM,nDD)
ENDIF
ENDIF
RETURN ''

