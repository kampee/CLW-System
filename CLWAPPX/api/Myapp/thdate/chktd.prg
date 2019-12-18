*CHKTD.PRG
***************************************************************
* ---FUNCTION CHKTD
* ---โปรแกรม...... ตรวจสอบการป้อนวันที่ไทย
*-- นำไปใช้...... LDate=CHKTD('22/01/2543') return .T. or .F.
***************************************************************
FUNC CHKTD
PARA BEDATE && พ.ศ. 
IF TYPE('BEDATE')#'C'
RETURN .F.
ENDIF
ON ERROR mABC= ERROR()
LOCAL nDD,nMM,nYYYY,XXX,mABC
mABC=0
nDD = VAL(SUBSTR(BEDATE,1,2))
nMM = VAL(SUBSTR(BEDATE,4,2))
nYYYY = VAL(SUBSTR(BEDATE,7,4))-543
XXX=DATE(nYYYY,nMM,nDD)
ON ERROR
IF mABC # 0 .OR. EMPTY(XXX)
RETURN .F.
ENDIF
RETURN .T.