*******************************************************************
* Function Convert Numeric to Thai Baht
* ---�����...... ����¹����Ţ�繵���ѡ�� (9,999,999,999.99)
* --- ������ҧ...... cSTRING=NUM2THI(9999999999.99)
*******************************************************************
FUNCTION NUM2THI
PARAMETER mNUM 
DIMENSION mTCH(9),mTDEC(10)
   IF mNUM > 9999999999.99 .OR. Mnum <= 0
      RETURN ''
   ENDIF
   mTCH(1)='˹��'
   mTCH(2)='�ͧ'
   mTCH(3)='���'
   mTCH(4)='���'
   mTCH(5)='���'
   mTCH(6)='ˡ'
   mTCH(7)='��'
   mTCH(8)='Ỵ'
   mTCH(9)='���'
   mTDEC(1) ='�ѹ'
   mTDEC(2) ='����'
   mTDEC(3) ='�Ժ'
   mTDEC(4) ='��ҹ'
   mTDEC(5) ='�ʹ'
   mTDEC(6) ='����'
   mTDEC(7) ='�ѹ'
   mTDEC(8) ='����'
   mTDEC(9) ='�Ժ'
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
            mSTTHAI=IIF(mCNT=4,mSTTHAI+'��ҹ',mSTTHAI+'')
         ELSE
            IF mCHNUM='1'
              IF (mCNT=4.AND.LEN(LTRIM(mSTNUM))#9).OR.  ;
                  (mCNT=10.AND.LEN(LTRIM(mSTNUM))#3)
                  mSTTHAI=mSTTHAI+'���'
              ELSE
                  IF .NOT.(mCNT=3.OR.mCNT=9)
                     mSTTHAI=mSTTHAI+mTCH(VAL(mCHNUM))
                 ENDIF
               ENDIF
            ELSE
               IF mCHNUM='2'.AND.(mCNT=3.OR.mCNT=9)
                  mSTTHAI=mSTTHAI+'���'
               ELSE
                  mSTTHAI=mSTTHAI+mTCH(VAL(mCHNUM))
               ENDIF
            ENDIF
            mSTTHAI=mSTTHAI+mTDEC(mCNT)
         ENDIF
      ENDIF
      mCNT=mCNT+1
   ENDDO
   mSTTHAI=mSTTHAI+'�ҷ'
   IF SUBSTR(mSTNUM,11,2)='00'
      mSTTHAI=mSTTHAI+'��ǹ'
   ELSE
      mCHNUM=SUBSTR(mSTNUM,11,1)
      IF mCHNUM#'0'
         IF mCHNUM#'1'
            IF mCHNUM='2'
               mSTTHAI=mSTTHAI+'���'
            ELSE
               mSTTHAI=mSTTHAI+mTCH(VAL(mCHNUM))
            ENDIF
         ENDIF
         mSTTHAI=mSTTHAI+mTDEC(9)
      ENDIF
      mCHNUM=SUBSTR(mSTNUM,12,1)
      IF mCHNUM#'0'
         IF mCHNUM='1'.AND.SUBSTR(mSTNUM,11,1)#'0'
            mSTTHAI=mSTTHAI+'���'
         ELSE
            mSTTHAI=mSTTHAI+mTCH(VAL(mCHNUM))
         ENDIF
      ENDIF
      mSTTHAI=mSTTHAI+'ʵҧ��'
   ENDIF
   RETU mSTTHAI
ENDFUNC
