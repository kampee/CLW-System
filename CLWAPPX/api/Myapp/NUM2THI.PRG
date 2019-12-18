*******************************************************************
* Function Convert Numeric to Thai Baht
* ---โปรแกรม...... เปลี่ยนตัวเลขเป็นตัวอักษร (9,999,999,999.99)
* --- ตัวอย่าง...... cSTRING=NUM2THI(9999999999.99)
*******************************************************************
FUNCTION NUM2THI
PARAMETER mNUM 
DIMENSION mTCH(9),mTDEC(10)
   IF mNUM > 9999999999.99 .OR. Mnum <= 0
      RETURN ''
   ENDIF
   mTCH(1)='หนึ่ง'
   mTCH(2)='สอง'
   mTCH(3)='สาม'
   mTCH(4)='สี่'
   mTCH(5)='ห้า'
   mTCH(6)='หก'
   mTCH(7)='เจ็ด'
   mTCH(8)='แปด'
   mTCH(9)='เก้า'
   mTDEC(1) ='พัน'
   mTDEC(2) ='ร้อย'
   mTDEC(3) ='สิบ'
   mTDEC(4) ='ล้าน'
   mTDEC(5) ='แสน'
   mTDEC(6) ='หมื่น'
   mTDEC(7) ='พัน'
   mTDEC(8) ='ร้อย'
   mTDEC(9) ='สิบ'
   mTDEC(10)=''
   mSTNUM=STR(mNUM*100,12)
   mSTTHAI=''
   mCNT=1
   DO WHIL mCNT<=10
      mCHNUM=SUBSTR(mSTNUM,mCNT,1)
      IF mCHNUM=' '
         mSTTHAI=mSTTHAI+''
      ELSE
         IF mCHNUM='0'
            mSTTHAI=IIF(mCNT=4,mSTTHAI+'ล้าน',mSTTHAI+'')
         ELSE
            IF mCHNUM='1'
              IF (mCNT=4.AND.LEN(LTRIM(mSTNUM))#9).OR.  ;
                  (mCNT=10.AND.LEN(LTRIM(mSTNUM))#3)
                  mSTTHAI=mSTTHAI+'เอ็ด'
              ELSE
                  IF .NOT.(mCNT=3.OR.mCNT=9)
                     mSTTHAI=mSTTHAI+mTCH(VAL(mCHNUM))
                 ENDIF
               ENDIF
            ELSE
               IF mCHNUM='2'.AND.(mCNT=3.OR.mCNT=9)
                  mSTTHAI=mSTTHAI+'ยี่'
               ELSE
                  mSTTHAI=mSTTHAI+mTCH(VAL(mCHNUM))
               ENDIF
            ENDIF
            mSTTHAI=mSTTHAI+mTDEC(mCNT)
         ENDIF
      ENDIF
      mCNT=mCNT+1
   ENDDO
   mSTTHAI=mSTTHAI+'บาท'
   IF SUBSTR(mSTNUM,11,2)='00'
      mSTTHAI=mSTTHAI+'ถ้วน'
   ELSE
      mCHNUM=SUBSTR(mSTNUM,11,1)
      IF mCHNUM#'0'
         IF mCHNUM#'1'
            IF mCHNUM='2'
               mSTTHAI=mSTTHAI+'ยี่'
            ELSE
               mSTTHAI=mSTTHAI+mTCH(VAL(mCHNUM))
            ENDIF
         ENDIF
         mSTTHAI=mSTTHAI+mTDEC(9)
      ENDIF
      mCHNUM=SUBSTR(mSTNUM,12,1)
      IF mCHNUM#'0'
         IF mCHNUM='1'.AND.SUBSTR(mSTNUM,11,1)#'0'
            mSTTHAI=mSTTHAI+'เอ็ด'
         ELSE
            mSTTHAI=mSTTHAI+mTCH(VAL(mCHNUM))
         ENDIF
      ENDIF
      mSTTHAI=mSTTHAI+'สตางค์'
   ENDIF
   RETU mSTTHAI
ENDFUNC
